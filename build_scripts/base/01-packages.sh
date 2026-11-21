#!/usr/bin/bash
echo "::group:: ===$(basename "$0")==="
set -eoux pipefail

dnf makecache --refresh

FEDORA_PACKAGES=(
	adwaita-fonts-all
	adw-gtk3-theme
	bibata-cursor-theme
	fastfetch
	file-roller-nautilus
	git
	git-credential-libsecret
	glibc-langpack-en
	gnome-tweaks
	nautilus
	nautilus-extensions
	os-prober
	papirus-icon-theme
	plymouth
	podman
	polkit
	sushi
	starship
	wl-clipboard
	xdg-terminal-exec
	zsh
	ghostty-nautilus
	papers-nautilus
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

dnf5 -y copr enable scottames/ghostty
dnf -y install --setopt=install_weak_deps=False ghostty
dnf5 -y copr disable scottames/ghostty

dnf5 -y copr enable ublue-os/packages
dnf -y install --setopt=install_weak_deps=False gnome-rounded-blur uupd
dnf5 -y copr disable ublue-os/packages

curl --retry 3 -Lo /usr/share/flatpak/remotes.d/flathub.flatpakrepo https://dl.flathub.org/repo/flathub.flatpakrepo

if [[ "${IMAGE_FLAVOR:-}" == "dx" ]]; then
	/ctx/build_scripts/dx/00-dx.sh 2>/dev/null || true
fi
echo "::endgroup::"
