# Maintainer: okhsunrog <me@okhsunrog.dev>

pkgname=chatgpt-desktop-bin
pkgver=26.908.40401
pkgrel=1
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
  "chatgpt_${pkgver}_amd64.deb::https://persistent.oaistatic.com/codex-app-prod/linux/deb/pool/main/c/chatgpt/chatgpt_${pkgver}_amd64.deb"
  'chatgpt-wrapper.sh'
)
sha256sums=(
  '7c089bda20728723e7ad16b7295198ddce14afd53e03f8a48f6735449f48cd03'
  '68a4fa17d496fc8fb1941e646a8599a039d96a46dcb69a8267c12a053f11e646'
)

_patch_renderer_bundle() {
  local app_asar=$1
  local broken='n();export{r as AppLayoutRoute,t as AuthedRoute,o as n,s as t};'
  local fixed='0;  export{r as AppLayoutRoute,t as AuthedRoute,o as n,s as t};'
  local -a matches

  # 26.908.40401 calls a non-callable app-primary export while loading the
  # authenticated routes. Keep the replacement byte-for-byte the same length
  # so the offsets in the ASAR header remain valid.
  [[ ${#broken} -eq ${#fixed} ]] || return 1
  mapfile -t matches < <(LC_ALL=C grep -aboF "$broken" "$app_asar")
  if (( ${#matches[@]} != 1 )); then
    printf 'Expected one renderer patch target, found %d\n' "${#matches[@]}" >&2
    return 1
  fi

  local offset=${matches[0]%%:*}
  printf '%s' "$fixed" | dd of="$app_asar" bs=1 seek="$offset" \
    conv=notrunc status=none

  if LC_ALL=C grep -aqF "$broken" "$app_asar" || \
      ! LC_ALL=C grep -aqF "$fixed" "$app_asar"; then
    printf 'Renderer patch verification failed\n' >&2
    return 1
  fi
}

package() {
  bsdtar --no-same-owner -xf data.tar.xz -C "$pkgdir" ./etc ./usr

  _patch_renderer_bundle "$pkgdir/usr/lib/chatgpt/resources/app.asar"

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
