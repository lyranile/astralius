#!/usr/bin/bash
set -eoux pipefail

if [[ -d /ctx/system_files ]]; then
	rsync -rvKl /ctx/system_files/ /
fi

glib-compile-schemas /usr/share/glib-2.0/schemas/ 2>/dev/null || true
