#!/usr/bin/env bash
echo "::group:: ===$(basename "$0")==="

set -eoux pipefail

if [[ -n "${BASE_IMAGE:-}" ]]; then
	IMAGE_REF="${BASE_IMAGE%%:*}"
	IMAGE_TAG="${BASE_IMAGE##*:}"
else
	IMAGE_INFO="$(cat /usr/share/ublue-os/image-info.json)"
	IMAGE_TAG="$(jq -c -r '."image-tag"' <<<"$IMAGE_INFO")"
	IMAGE_REF="$(jq -c -r '."image-ref"' <<<"$IMAGE_INFO")"
	IMAGE_REF="${IMAGE_REF##*://}"
fi

sed -i 's/ANACONDA_PRODUCTVERSION=.*/ANACONDA_PRODUCTVERSION=""/' /usr/{,s}bin/liveinst || true

desktop-file-edit \
	--set-key=Icon --set-value=astralius-installer \
	--set-key=StartupWMClass --set-value=slitherer \
	/usr/share/applications/liveinst.desktop

# The GNOME welcome screen hardcodes iconName: 'fedora-logo-icon'; point it at the image-provided Astralius icon
sed -i "s|iconName: 'fedora-logo-icon'|iconName: 'astralius-installer'|" /usr/share/anaconda/gnome/fedora-welcome

# Substitute the live ostreecontainer reference into the mapped kickstart files
sed -i "s|__IMAGE_REF__|${IMAGE_REF}|g; s|__IMAGE_TAG__|${IMAGE_TAG}|g" \
	/usr/share/anaconda/interactive-defaults.ks \
	/usr/share/anaconda/post-scripts/install-configure-upgrade.ks

gtk-update-icon-cache -f /usr/share/icons/hicolor/ 2>/dev/null || true
ksflatten -c /usr/share/anaconda/interactive-defaults.ks 2>/dev/null || true
ksvalidator /usr/share/anaconda/interactive-defaults.ks 2>/dev/null || true
echo "::endgroup::"
