# ChatGPT Desktop for Arch Linux

Unofficial Arch Linux packaging for the official OpenAI ChatGPT desktop app.
The package repacks OpenAI's x86-64 Debian package and applies the narrowly
scoped compatibility workarounds documented below.

> [!NOTE]
> OpenAI currently documents Ubuntu, Debian, and Fedora as supported Linux
> distributions. This Arch Linux package is community-maintained and is not
> affiliated with or supported by OpenAI.

## Build and install

Install the standard Arch packaging tools, clone this repository, and build the
package:

```bash
sudo pacman -S --needed base-devel git
git clone https://github.com/okhsunrog/chatgpt-desktop-bin.git
cd chatgpt-desktop-bin
makepkg -si
```

The download is roughly 334 MiB. The resulting package is roughly 448 MiB and
uses about 1.3 GiB when installed.

Launch **ChatGPT** from the application menu or run:

```bash
chatgpt
```

## Wayland keyboard layouts

The upstream launcher can fall back to XWayland. Under KDE Plasma Wayland, the
XWayland keyboard map may contain only `us`, causing non-Latin layouts to keep
typing Latin characters even when the desktop shows another active layout.

This package installs a small wrapper that automatically passes
`--ozone-platform=wayland` when `WAYLAND_DISPLAY` is set. X11 sessions remain
unchanged, and an explicitly supplied `--ozone-platform=...` option always
takes precedence.

## 26.908.40401 renderer workaround

The upstream `26.908.40401` renderer calls a non-callable export while loading
its authenticated routes, causing the generic **ChatGPT hit a snag** screen.
This package replaces that four-byte initializer call with an equal-length
no-op inside `app.asar`, preserving all archive offsets.

The package build requires exactly one match for the known broken byte sequence
and verifies the replacement afterward. It therefore fails safely if a future
upstream bundle changes instead of applying the workaround to unknown code. The
workaround should be removed once upstream ships a corrected renderer.

## Updating

When OpenAI publishes a new build:

1. Read the current x86-64 package metadata from the official stable APT index.
2. Update `pkgver`, reset `pkgrel` to `1`, and update the Debian package SHA-256
   checksum in `PKGBUILD`.
3. Confirm the corresponding versioned APT pool object is available.
4. Regenerate `.SRCINFO` and build a clean package:

```bash
makepkg --printsrcinfo > .SRCINFO
makepkg --cleanbuild --force
namcap PKGBUILD
```

Current metadata is published at:

```text
https://persistent.oaistatic.com/codex-app-prod/linux/deb/dists/stable/main/binary-amd64/Packages
```

PKGBUILD sources use immutable, versioned pool objects:

```text
https://persistent.oaistatic.com/codex-app-prod/linux/deb/pool/main/c/chatgpt/chatgpt_${pkgver}_amd64.deb
```

## Verification

The source archive is pinned by SHA-256. To verify the sources without building:

```bash
makepkg --verifysource
```

## License

The ChatGPT application and bundled components remain subject to their upstream
licenses and terms. See the installed notices under
`/usr/share/licenses/chatgpt-desktop-bin/` and `/usr/lib/chatgpt/`.
