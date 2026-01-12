# AMD ISP4 Camera Driver

Out-of-tree module for the AMD ISP4 camera found in Ryzen AI laptops (e.g., ASUS Zenbook S 16, HP ZBook Ultra G1a).

The driver is not yet merged into mainline Linux. This repo downloads the [patch series](https://lore.kernel.org/linux-media/20251128091929.165272-1-Bin.Du@amd.com/) via `b4` and builds it as a loadable module.

## Requirements

- Linux kernel 6.17.9+ (with `amd_isp4` platform driver)
- Kernel headers
- Build tools and `b4`

```bash
# Arch
sudo pacman -S base-devel linux-headers b4

# Ubuntu/Debian
sudo apt install build-essential linux-headers-$(uname -r) b4

# Fedora
sudo dnf install kernel-devel kernel-headers gcc make b4
```

## Install

```bash
make
sudo make install
```

This downloads the patches, compiles the module, installs it, and configures it to load at boot.

## After kernel updates

```bash
make clean && make && sudo make install
```

## Use with DKMS

```bash
make patch && sudo dkms install .
```

This creates patched module source and installs it in DKMS system so kernel updates are automatically handled.
