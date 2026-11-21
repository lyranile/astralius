#!/usr/bin/bash

echo "::group:: ===$(basename "$0")==="

set -eoux pipefail

# Basic sanity checks
test -f /usr/share/ublue-os/image-info.json
test -f /usr/lib/os-release

# Flatpak first-boot preinstall layout (Aurora/Bluefin model)
test -f /usr/share/flatpak/remotes.d/flathub.flatpakrepo
test -f /usr/lib/systemd/system-preset/89-astralius.preset

# systemd preset should enable flatpak-preinstall.service for first boot
grep -q '^enable flatpak-preinstall.service' /usr/lib/systemd/system-preset/89-astralius.preset

# one generated preinstall file per canonical app
while IFS= read -r app; do
	[[ -z "${app}" || "${app}" =~ ^[[:space:]]*# ]] && continue
	test -f "/usr/share/flatpak/preinstall.d/${app}.preinstall"
done < /usr/share/ublue-os/flatpaks.list

echo "::endgroup::"
