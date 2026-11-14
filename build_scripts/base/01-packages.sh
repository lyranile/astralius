#!/usr/bin/bash
set -eoux pipefail

dnf makecache --refresh

FEDORA_PACKAGES=(
	adw-gtk3-theme
	fastfetch
	file-roller-nautilus
	git
	git-credential-libsecret
	nautilus
	nautilus-extensions
	papirus-icon-theme
	plymouth
	polkit
	sushi
	zsh
)

REMOVED_PACKAGES=(
	firefox
	gnome-classic-session
	gnome-console
	gnome-software
	gnome-terminal
	gnome-user-docs
	htop
	malcontent-control
	nvtop
	yelp
)

dnf -y install \
	--setopt=install_weak_deps=False \
	"${FEDORA_PACKAGES[@]}"

dnf -y remove "${REMOVED_PACKAGES[@]}" 2>/dev/null || true

if [[ "${IMAGE_FLAVOR:-}" == "dx" ]]; then
	/ctx/build_scripts/dx/00-dx.sh 2>/dev/null || true
fi
