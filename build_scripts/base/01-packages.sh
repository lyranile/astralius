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
	ghostty
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

# Terra repo (fyralabs) - needed for bibata-cursor-theme, starship, ghostty-nautilus, papers-nautilus
mkdir -p /etc/pki/rpm-gpg
curl --retry 3 -Lo /etc/pki/rpm-gpg/RPM-GPG-KEY-terra45 https://repos.fyralabs.com/terra45/key.asc
cat >/etc/yum.repos.d/terra.repo <<'EOF'
[terra]
name=Terra $releasever
metalink=https://tetsudou.fyralabs.com/metalink?repo=terra$releasever&arch=$basearch
metadata_expire=6h
type=rpm
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-terra45
repo_gpgcheck=0
enabled=1
EOF

dnf -y install \
	--setopt=install_weak_deps=False \
	"${FEDORA_PACKAGES[@]}"

dnf -y remove "${REMOVED_PACKAGES[@]}"

dnf5 -y copr enable ublue-os/packages
dnf -y install --setopt=install_weak_deps=False gnome-rounded-blur uupd
dnf5 -y copr disable ublue-os/packages

curl --retry 3 -Lo /usr/share/flatpak/remotes.d/flathub.flatpakrepo https://dl.flathub.org/repo/flathub.flatpakrepo

if [[ "${IMAGE_FLAVOR:-}" == "dx" ]]; then
	/ctx/build_scripts/dx/00-dx.sh 2>/dev/null || true
fi
echo "::endgroup::"
