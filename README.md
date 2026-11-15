# Astralius

A GNOME (Silverblue-based) bootc workstation image with NVIDIA open driver support, Homebrew, and secure boot.

## Features

- GNOME desktop (Fedora Silverblue base)
- NVIDIA open kernel modules variant (`astralius-nvidia-open`)
- Homebrew integration (ublue-os/brew)
- Secure boot supported (enrollment password: `universalblue`)
- Live ISO installer (Anaconda WebUI) via `iso/`

## Secure Boot

Secure boot is supported by default. After first installation you will be prompted to enroll the secure boot key in the BIOS.

Enter the password `universalblue` when prompted.

Manual enrollment:
```bash
sudo mokutil --timeout -1
sudo mokutil --import /etc/pki/akmods/certs/akmods-ublue.der
```

## Build

```bash
just check
just build astralius latest
# NVIDIA variant
podman build --build-arg NVIDIA=true -t astralius-nvidia-open:latest -f Containerfile .
```

## Live ISO

See `iso/` (Titanoboa pipeline). Build with:
```bash
cd iso && podman build --build-arg BASE_IMAGE=ghcr.io/lyranile/astralius:latest -t astralius-iso -f Containerfile .
```

## Homebrew

Homebrew is provided by ublue-os/brew and sets up automatically on first boot.
