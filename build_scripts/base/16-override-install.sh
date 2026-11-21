#!/usr/bin/bash
set -eoux pipefail

if [[ -d /ctx/system_files ]]; then
    rsync -rvKl /ctx/system_files/ /
fi

# Footgun: prevent users from changing shells
rm -f /usr/bin/chsh /usr/bin/lchsh

# Add linuxbrew to sudo secure_path
if grep -q 'secure_path' /etc/sudoers; then
    sed -Ei "s/secure_path = (.*)/secure_path = \1:\/home\/linuxbrew\/.linuxbrew\/bin/" /etc/sudoers
fi

# Default applications (xdg-mime trickery)
XDG_CONFIG_HOME=/usr/share/applications xdg-mime default io.github.kolunmi.Bazaar.desktop application/vnd.flatpak.ref 2>/dev/null || true

# Remove gnome-ssh-askpass
rm -f /etc/profile.d/gnome-ssh-askpass.{csh,sh}

# Generate per-app flatpak preinstall files from the canonical list (Aurora/Bluefin use /usr/share/flatpak/preinstall.d)
FLATPAK_LIST=/usr/share/ublue-os/flatpaks.list
PREINSTALL_DIR=/usr/share/flatpak/preinstall.d
mkdir -p "${PREINSTALL_DIR}"
if [[ -f "${FLATPAK_LIST}" ]]; then
    # Remove stale Astralius-managed preinstall files only (leave anything else the base image ships)
    while IFS= read -r app; do
        [[ -z "${app}" || "${app}" =~ ^[[:space:]]*# ]] && continue
        rm -f "${PREINSTALL_DIR}/${app}.preinstall"
    done < "${FLATPAK_LIST}"
    while IFS= read -r app; do
        [[ -z "${app}" || "${app}" =~ ^[[:space:]]*# ]] && continue
        printf '[Flatpak Preinstall %s]\nBranch=stable\nIsRuntime=false\n' "${app}" > "${PREINSTALL_DIR}/${app}.preinstall"
    done < "${FLATPAK_LIST}"
fi

glib-compile-schemas /usr/share/glib-2.0/schemas/ 2>/dev/null || true
gtk-update-icon-cache -f /usr/share/icons/hicolor/ 2>/dev/null || true
