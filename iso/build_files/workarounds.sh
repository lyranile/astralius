#!/usr/bin/env bash
echo "::group:: ===$(basename "$0")==="
set -eoux pipefail

rm -f /usr/lib/systemd/system/flatpak-add-fedora-repos.service
echo "::endgroup::"
