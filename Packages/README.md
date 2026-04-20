This directory contains all CacheGuard-OS source files. CAUTION: Building the OS from scratch without proper care may damage your hard disk and may result in it being formatted.

- The CacheGuard directory includes all code developed by CacheGuard Technologies.
- The OS directory contains scripts used to create a tar.gz archive of all components of CacheGuard-OS, including third-party binaries and code developed by CacheGuard Technologies.
- The Packages directory contains a list of all third-party open-source packages used to build CacheGuard-OS.

To begin the build process, proceed as follows:

- Create a dedicated 25 GB partition for LFS (Linux From Scratch) and mount it on the filesystem (for example, /mnt/LFS).
- Create a dedicated 5 GB partition for the CacheGuard Appliance and mount it on the filesystem (for example, /mnt/CG).

Set the following environment variables (use your own mount points instead of /mnt/LFS and /mnt/CG):

```bash
export LFS=/mnt/LFS
export APL=/mnt/CG
```

- Step 1: Copy all third-party open-source packages to ${LFS} by running the following commands:

```bash cd Packages
./copy-package.bash LFS/Source ${LFS}/usr/src
./copy-package.bash EXTRALFS/Source ${LFS}/usr/src
./copy-package.bash APPLIANCE/Source ${LFS}/usr/src
./copy-package.bash EXECUTABLE/$(uname -m)/Source ${LFS}/usr/src
```

- Step 2: Build a temporary minimalist Linux system by running the following commands:

```bash
cd LFS
./tools-install.bash
```

- Step 3: Build the LFS system by running the following command:

```bash
./install.bash
```

- Step 4: Build the Appliance system by running the following commands:

```bash
cd ../APPLIANCE
./install.bash
```

- Step 5: Copy all CacheGuard programs to the appliance filesystem (/mnt/CG) and create the installation CD-ROM:

```bash
cd ../CacheGuard/
./install.bash
```
