#!/bin/bash
set -e

let n=1
until tail -$n /var/log/pacman.log | head -1 | grep -q 'starting full system upgrade'
do
    let n=$(($n+1))
done

exec 3>&1
exec >/dev/null

tail -$n /var/log/pacman.log | sed -nr 's/.+ (.+) installed as \1.pacnew/\1/p' | while IFS= read -r file
do
    [[ -e "$file.pacnew" ]] || continue
    pkg=$(pacman -Qqo "$file")
    pkgfile=$(ls -t /var/cache/pacman/pkg/$pkg-* | head -2 | tail -1)
    tmpdir=$(mktemp -d)
    relfile="${file#/}"
    cd "$tmpdir"
    git init
    mkdir -p "$(dirname "$relfile")"
    # old
    tar xOaf $pkgfile "$relfile" >"$relfile"
    git add -A
    git commit -m "old"
    # custom
    git checkout -b custom &>/dev/null
    cat "$file" >"$relfile"
    git commit -am "custom"
    # new
    git checkout master &>/dev/null
    cat "$file.pacnew" >"$relfile"
    git commit -am "new"
    # rebase
    git checkout custom &>/dev/null
    git rebase master
    git diff HEAD^ >&3
    cat "$relfile" | sudo -k tee "$file.pacnew"
    sudo mv "$file.pacnew" "$file"
    cd - >/dev/null
    rm -rf "$tmpdir"
done
