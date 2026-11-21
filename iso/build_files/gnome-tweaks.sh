#!/usr/bin/env bash
echo "::group:: ===$(basename "$0")==="
set -eoux pipefail

# GNOME live environment tweaks
dconf update 2>/dev/null || true

# systemd-tmpfiles --create --boot --root=/mnt/sysroot --prefix=/var/home fails
find /mnt -mindepth 1 -delete 2>/dev/null || true
install -d -m 0755 /mnt
echo "::endgroup::"
