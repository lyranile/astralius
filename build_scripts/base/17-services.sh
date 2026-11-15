#!/usr/bin/bash
echo "::group:: ===$(basename "$0")==="
set -eoux pipefail

systemctl preset-all
systemctl --global preset-all

systemctl enable podman.socket
systemctl enable flatpak-preinstall.service 2>/dev/null || true
systemctl enable uupd.timer 2>/dev/null || true
systemctl enable ublue-nvidia-flatpak-runtime-sync.service 2>/dev/null || true
echo "::endgroup::"
