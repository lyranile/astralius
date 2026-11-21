#!/usr/bin/bash
echo "::group:: ===$(basename "$0")==="
set -eoux pipefail

if [[ -d /ctx/system_files ]]; then
	rsync -rvKl /ctx/system_files/ /
fi

rm -f /usr/bin/chsh /usr/bin/lchsh

if grep -q 'secure_path' /etc/sudoers; then
	sed -Ei "s/secure_path = (.*)/secure_path = \1:\/home\/linuxbrew\/.linuxbrew\/bin/" /etc/sudoers
fi

XDG_CONFIG_HOME=/usr/share/applications xdg-mime default io.github.kolunmi.Bazaar.desktop application/vnd.flatpak.ref 2>/dev/null || true

rm -f /etc/profile.d/gnome-ssh-askpass.{csh,sh}

FLATPAK_LIST=/usr/share/ublue-os/flatpaks.list
PREINSTALL_DIR=/usr/share/flatpak/preinstall.d
mkdir -p "${PREINSTALL_DIR}"
if [[ -f "${FLATPAK_LIST}" ]]; then
	while IFS= read -r app; do
		[[ -z "${app}" || "${app}" =~ ^[[:space:]]*# ]] && continue
		rm -f "${PREINSTALL_DIR}/${app}.preinstall"
	done <"${FLATPAK_LIST}"
	while IFS= read -r app; do
		[[ -z "${app}" || "${app}" =~ ^[[:space:]]*# ]] && continue
		printf '[Flatpak Preinstall %s]\nBranch=stable\nIsRuntime=false\n' "${app}" >"${PREINSTALL_DIR}/${app}.preinstall"
	done <"${FLATPAK_LIST}"
fi

glib-compile-schemas /usr/share/glib-2.0/schemas/ 2>/dev/null || true
gtk-update-icon-cache -f /usr/share/icons/hicolor/ 2>/dev/null || true

if [[ -f /usr/share/anaconda/gnome/fedora-welcome ]]; then
	sed -i "s|iconName: 'fedora-logo-icon'|iconName: 'astralius-installer'|" /usr/share/anaconda/gnome/fedora-welcome
fi
echo "::endgroup::"
