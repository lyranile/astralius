#!/usr/bin/bash
echo "::group:: ===$(basename "$0")==="
set -eoux pipefail

if [[ -L /root ]]; then
	_root_target=$(readlink -f /root)
	rm -f /root
	mkdir -p /root
	[[ -n "${_root_target}" && -d "${_root_target}" ]] && cp -a "${_root_target}/." /root/ 2>/dev/null || true
	_restore=1
else
	_restore=0
fi

dracut --regenerate-all -f

if [[ "${_restore}" == "1" ]]; then
	rm -rf /root
	ln -s "${_root_target}" /root
fi
echo "::endgroup::"
