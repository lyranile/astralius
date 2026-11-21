#!/usr/bin/bash
echo "::group:: ===$(basename "$0")==="
set -eoux pipefail

test -f /usr/share/ublue-os/image-info.json
test -f /usr/lib/os-release
test -f /usr/share/flatpak/remotes.d/flathub.flatpakrepo
test -f /usr/lib/systemd/system-preset/89-astralius.preset
grep -q '^enable flatpak-preinstall.service' /usr/lib/systemd/system-preset/89-astralius.preset

while IFS= read -r app; do
	[[ -z "${app}" || "${app}" =~ ^[[:space:]]*# ]] && continue
	test -f "/usr/share/flatpak/preinstall.d/${app}.preinstall"
done </usr/share/ublue-os/flatpaks.list

echo "::endgroup::"
