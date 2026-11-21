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

## Repository layout

- `system_files/` — files copied verbatim to `/` for every image build.
- `iso/system_files/` — ISO-only overlay copied verbatim to `/` on top of the base image.
- `iso/build_files/` — scripts run by the ISO build.
- `build_scripts/` — image build scripts.
- `build_scripts/shared/` — shared image helpers.

Flatpaks follow the Aurora/Bluefin first-boot model and are not installed at image build time.
They come from one list:

- `system_files/usr/share/ublue-os/flatpaks.list`

At build time we generate one `/usr/share/flatpak/preinstall.d/<app>.preinstall` per entry,
ship the Flathub remote at `/usr/share/flatpak/remotes.d/flathub.flatpakrepo`, and enable
`flatpak-preinstall.service` via the system preset. On first boot it installs the flatpaks
automatically. The ISO uses the same image layout.

## Live ISO

See `iso/` (Titanoboa pipeline). Build with:

```bash
cd iso && podman build --build-arg BASE_IMAGE=ghcr.io/lyranile/astralius:latest -t astralius-iso -f Containerfile .
```

## Homebrew

Homebrew is provided by ublue-os/brew and sets up automatically on first boot.
