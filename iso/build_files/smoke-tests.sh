#!/usr/bin/env bash
echo "::group:: ===$(basename "$0")==="
set -eoux pipefail

stat /etc/pki/akmods/certs/akmods-ublue.der
echo "::endgroup::"
