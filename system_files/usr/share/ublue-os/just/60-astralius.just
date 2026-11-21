# Astralius custom just recipes

# Enroll the secure boot key (password: universalblue)
enroll-secure-boot-key:
    #!/usr/bin/bash
    set -eoux pipefail
    sudo mokutil --timeout -1
    echo -e "universalblue\nuniversalblue" | sudo mokutil --import /etc/pki/akmods/certs/akmods-ublue.der

# Install all system flatpaks from the image's flatpak list
install-system-flatpaks:
    #!/usr/bin/bash
    set -eoux pipefail
    FLATPAK_LIST=/usr/share/ublue-os/flatpaks.list
    if [[ -f "${FLATPAK_LIST}" ]]; then
        flatpak remote-add --if-not-exists --system flathub https://flathub.org/repo/flathub.flatpakrepo
        while IFS= read -r app; do
            [[ -z "${app}" || "${app}" =~ ^[[:space:]]*# ]] && continue
            flatpak install -y --system flathub "${app}"
        done < "${FLATPAK_LIST}"
    else
        echo "No flatpak list found at ${FLATPAK_LIST}"
    fi
