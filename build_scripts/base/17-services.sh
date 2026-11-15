#!/usr/bin/bash
set -eoux pipefail

systemctl enable podman.socket
systemctl preset brew-setup.service brew-update.timer brew-upgrade.timer 2>/dev/null || true
systemctl enable flatpak-preinstall.service 2>/dev/null || true
systemctl enable ublue-nvidia-flatpak-runtime-sync.service 2>/dev/null || true
