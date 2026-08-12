# Maintainer: okhsunrog <me@okhsunrog.dev>

pkgname=chatgpt-desktop-bin
pkgver=26.803.81509
pkgrel=2
pkgdesc='Official ChatGPT desktop app for Linux'
arch=('x86_64')
url='https://developers.openai.com/codex/app'
license=('custom')
depends=(
  'alsa-lib'
  'at-spi2-core'
  'cairo'
  'dbus'
  'expat'
  'gcc-libs'
  'gdk-pixbuf2'
  'glib2'
  'glibc'
  'gtk3'
  'libcups'
  'libdrm'
  'libnotify'
  'libusb'
  'libx11'
  'libxcb'
  'libxcomposite'
  'libxdamage'
  'libxext'
  'libxfixes'
  'libxkbcommon'
  'libxrandr'
  'mesa'
  'nspr'
  'nss'
  'openssl'
  'pango'
  'systemd-libs'
  'xdg-utils'
  'xz'
)
optdepends=(
  'apparmor: load the bundled ChatGPT AppArmor profile'
  'git: Git repository integration'
  'libpulse: PulseAudio support'
)
provides=('chatgpt')
conflicts=('chatgpt')
options=('!strip')
source=(
  "chatgpt_${pkgver}_amd64.deb::https://persistent.oaistatic.com/codex-app-prod/linux/deb/latest/chatgpt_amd64.deb"
  'chatgpt-wrapper.sh'
)
sha256sums=(
  'a9bf91a368f9f7c4eea38082a9fb8fb46b8d005b719a6d7715d2e5a1982c38eb'
  '68a4fa17d496fc8fb1941e646a8599a039d96a46dcb69a8267c12a053f11e646'
)

package() {
  bsdtar -xf "chatgpt_${pkgver}_amd64.deb" data.tar.xz
  bsdtar -xf data.tar.xz -C "$pkgdir" ./etc ./usr

  # Debian packaging metadata is not useful on Arch Linux.
  rm -rf "$pkgdir/usr/share/lintian"

  # The upstream launcher defaults to XWayland, whose XKB state can diverge
  # from the active KDE Wayland layout. Prefer native Wayland in a Wayland
  # session while preserving explicit user overrides and X11 sessions.
  install -Dm755 "$srcdir/chatgpt-wrapper.sh" \
    "$pkgdir/usr/lib/chatgpt/codex-launcher"

  install -Dm644 "$pkgdir/usr/share/doc/chatgpt/copyright" \
    "$pkgdir/usr/share/licenses/$pkgname/copyright"
}
