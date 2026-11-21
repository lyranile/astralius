# Astralius

A GNOME (Silverblue-based) bootc workstation image with NVIDIA open driver support, Homebrew, and secure boot.

## Features

- GNOME desktop (Fedora Silverblue base)
- NVIDIA open kernel modules variant (`astralius-nvidia-open`)
- Homebrew integration (ublue-os/brew)
- Secure boot supported (enrollment password: `universalblue`)
- Bootable ISO via bootc-image-builder with zirconium-style TOML installer customizations

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

## Bootable ISO

Build a bootable ISO using bootc-image-builder with zirconium-style TOML customizations.

The container image must be published to GHCR first, then the ISO is built from the
published image using a throw-away build image that adds Fedora repos for DNF to
resolve boot packages (grub, shim, kernel, installer tools):

```bash
# 1. Build and push the container image
just build astralius latest
podman push localhost/astralius:latest ghcr.io/lyranile/astralius:latest

# 2. Build the ISO from the published image (via CI or manually)
# CI: .github/workflows/build-disk.yaml (triggered on push to disk_config/**)
# Manual: requires the image to be published to GHCR first
```

The ISO customization lives in `disk_config/iso.toml` (and `disk_config/iso-nvidia.toml` for NVIDIA) using `[customizations.installer.modules]` to enable/disable Anaconda installer modules and `[customizations.installer.kickstart]` for the bootc switch kickstart. `[customizations.iso]` sets volume metadata.

Bootc install settings are in `system_files/usr/lib/bootc/10-astralius-install.toml` (`root-fs-type = "btrfs"`).

## Repository layout

- `system_files/` — files copied verbatim to `/` for every image build.
- `system_files/usr/lib/bootc/` — bootc configuration (e.g. `10-astralius-install.toml`, `install/20-astralius.toml`).
- `system_files/usr/lib/bootc/kargs.d/` — kernel arguments (e.g. `10-astralius-plymouth.toml`).
- `disk_config/disk.toml` — bootc-image-builder TOML for qcow2/raw disk images.
- `disk_config/iso.toml` — bootc-image-builder TOML for ISO builds (installer modules + kickstart).
- `disk_config/iso-nvidia.toml` — bootc-image-builder TOML for NVIDIA ISO builds.
- `build_scripts/` — image build scripts.
- `build_scripts/shared/` — shared image helpers.

Flatpaks follow the Aurora/Bluefin first-boot model and are not installed at image build time.
They come from one list:

- `system_files/usr/share/ublue-os/flatpaks.list`

At build time we generate one `/usr/share/flatpak/preinstall.d/<app>.preinstall` per entry,
ship the Flathub remote at `/usr/share/flatpak/remotes.d/flathub.flatpakrepo`, and enable
`flatpak-preinstall.service` via the system preset. On first boot it installs the flatpaks
automatically.

The Anaconda installer welcome screen icon is patched to use `astralius-installer` (from
`system_files/usr/share/icons/hicolor/scalable/apps/astralius-installer.svg`)
instead of the default `fedora-logo-icon`, so it does not show a missing-image placeholder.

## Homebrew

Homebrew is provided by ublue-os/brew and sets up automatically on first boot.
