# Maintainer: Joan Rieu <joan.rieu@gmail.com>
_pkgname=pacnew-auto
pkgname=$_pkgname-git
pkgver=r2.f9e0c4d
pkgrel=1
pkgdesc="Automatic pacman pacnew file merging using git rebase"
arch=(any)
url="https://github.com/joanrieu/pacnew-auto"
license=('MIT')
depends=(git)
source=("git+https://github.com/joanrieu/$_pkgname")
noextract=()
md5sums=('SKIP')

pkgver() {
    cd "$srcdir/$_pkgname"
    printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}

package() {
	DESTDIR="$pkgdir/usr/bin/"
    mkdir -p "$DESTDIR"
	mv "$_pkgname/$_pkgname.sh" "$DESTDIR/$_pkgname"
}
