#!/usr/bin/bash
echo "::group:: ===$(basename "$0")==="
set -eoux pipefail

dnf makecache --refresh

FEDORA_PACKAGES=(
	adwaita-fonts-all
	adw-gtk3-theme
	fastfetch
	file-roller-nautilus
	git
	git-credential-libsecret
	glibc-langpack-en
	gnome-tweaks
	nautilus
	nautilus-extensions
	papirus-icon-theme
	plymouth
	polkit
	sushi
	wl-clipboard
	xdg-terminal-exec
	zsh
)

REMOVED_PACKAGES=(
	firefox
	gnome-classic-session
	gnome-console
	gnome-extensions-app
	gnome-software
	gnome-terminal
	gnome-user-docs
	htop
	malcontent-control
	nvtop
	ptyxis
	yelp
)

dnf -y install \
	--setopt=install_weak_deps=False \
	"${FEDORA_PACKAGES[@]}"

dnf -y remove "${REMOVED_PACKAGES[@]}"

# Ghostty via COPR
dnf5 -y copr enable scottames/ghostty
dnf -y install --setopt=install_weak_deps=False ghostty
dnf5 -y copr disable scottames/ghostty

# gnome-rounded-blur and uupd from ublue-os/packages
dnf5 -y copr enable ublue-os/packages
dnf -y install --setopt=install_weak_deps=False gnome-rounded-blur uupd
dnf5 -y copr disable ublue-os/packages

# Enable Flathub system-wide (Aurora style)
curl --retry 3 -Lo /usr/share/flatpak/remotes.d/flathub.flatpakrepo https://dl.flathub.org/repo/flathub.flatpakrepo

# Install all flatpaks from the image's flatpak list (HOME=/tmp avoids /root symlink issues)
FLATPAK_LIST="/ctx/system_files/usr/share/astralius/flatpaks.list"
if [[ -f "${FLATPAK_LIST}" ]]; then
	while IFS= read -r app; do
		[[ -z "${app}" || "${app}" =~ ^[[:space:]]*# ]] && continue
		HOME=/tmp flatpak install -y --noninteractive flathub "${app}"
	done <"${FLATPAK_LIST}"
fi

if [[ "${IMAGE_FLAVOR:-}" == "dx" ]]; then
	/ctx/build_scripts/dx/00-dx.sh 2>/dev/null || true
fi
echo "::endgroup::"
