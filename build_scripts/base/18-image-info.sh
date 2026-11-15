#!/usr/bin/env bash
echo "::group:: ===$(basename "$0")==="
set -ouex pipefail

IMAGE_NAME="${IMAGE_NAME:-astralius}"
IMAGE_VENDOR="${IMAGE_VENDOR:-lyranile}"
BASE_IMAGE_NAME="${BASE_IMAGE_NAME:-silverblue-main}"
FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-$(rpm -E %fedora)}"
UBLUE_IMAGE_TAG="${UBLUE_IMAGE_TAG:-latest}"
VERSION="${VERSION:-00.00000000}"
SHA_HEAD_SHORT="${SHA_HEAD_SHORT:-}"

IMAGE_INFO="/usr/share/ublue-os/image-info.json"
IMAGE_REF="ostree-image-signed:docker://ghcr.io/${IMAGE_VENDOR}/${IMAGE_NAME}"

image_flavor="main"
[[ "${IMAGE_NAME}" =~ nvidia-open ]] && image_flavor="nvidia-open"

cat >"${IMAGE_INFO}" <<EOF
{
  "image-name": "${IMAGE_NAME}",
  "image-flavor": "${image_flavor}",
  "image-vendor": "${IMAGE_VENDOR}",
  "image-ref": "${IMAGE_REF}",
  "image-tag": "${UBLUE_IMAGE_TAG}",
  "base-image-name": "${BASE_IMAGE_NAME}",
  "fedora-version": "${FEDORA_MAJOR_VERSION}"
}
EOF

sed -i "s|^EFIDIR=.*|EFIDIR=\"fedora\"|" /usr/sbin/grub2-switch-to-blscfg 2>/dev/null || true
echo "::endgroup::"
