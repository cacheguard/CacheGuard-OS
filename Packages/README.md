# CacheGuard-OS Source Tree

⚠️ **Warning**  
Building the operating system from scratch without proper care may damage your storage device and may result in data loss or complete disk formatting. Proceed only if you fully understand the process.

---

## Build Prerequisites

Before starting the build process, create and mount the following partitions:

- A **25 GB partition** for the Linux From Scratch (LFS) environment (e.g. `/mnt/LFS`)
- A **5 GB partition** for the CacheGuard appliance environment (e.g. `/mnt/CG`)

Set environment variables:

```bash
export LFS=/mnt/LFS
export APL=/mnt/CG
```

## Build Procedure

```bashcd Packages
./copy-package.bash LFS/Source ${LFS}/usr/src
./copy-package.bash EXTRALFS/Source ${LFS}/usr/src
./copy-package.bash APPLIANCE/Source ${LFS}/usr/src
./copy-package.bash EXECUTABLE/$(uname -m)/Source ${LFS}/usr/src

cd ../LFS
./tools-install.bash
./install.bash

cd ../APPLIANCE
./install.bash

cd ../CacheGuard
./install.bash
```

# Subdirectory Structure

---

## APPLIANCE/Source

This directory contains third-party open-source packages required to build the CacheGuard appliance system on top of a base LFS installation.

Modifications introduced by CacheGuard Technologies are provided as patch files (`*.patch.*`) applied during the build process.

### Packages

- acpid-2.0.33.tar.xz
- alarm-1.0.0.tar.bz2
- anacron-2.3-cg.patch.bz2
- anacron-2.3.tar.bz2
- apr-1.7.6.tar.gz
- apr-util-1.6.3.tar.gz
- aws-cfn-bootstrap-2.0.25.tar.gz
- bind-9.20.5.tar.xz
- brotli-1.0.9.tar.xz
- cgic-2.05.tar.bz2
- cgi-message-3.0.tar.bz2
- c_icap-0.5.13.tar.gz
- c_icap_modules-0.5.7.tar.gz
- clamav-1.4.3-cg.patch.bz2
- clamav-1.4.3.tar.gz
- constant_time_encoding-3.0.0.tar.gz
- coreruleset-3.3.7.tar.gz
- crontabs-1.10-7.tar.bz2
- cyrus-sasl-2.1.28.tar.gz
- db-4.6.21.tar.gz
- db-retrieve-1.0.tar.bz2
- dhcp-4.1-ESV-R16-P2.tar.gz
- dialog-1.3-20220117.tar.gz
- distro-1.8.0.tar.gz
- dmidecode-3.3.tar.xz
- dos2unix-3.1.tar.bz2
- dosfstools-4.2.tar.gz
- efibootmgr-18.tar.gz
- efivar-38-i686-1.patch.bz2
- efivar-38.tar.bz2
- ethtool-5.16.tar.gz
- fuse-3.17.3.tar.gz
- gdb-11.2.tar.xz
- git-2.51.0.tar.gz
- glib-2.70.5.tar.xz
- google-authenticator-libpam-1.11.tar.gz
- gss-1.0.3.tar.gz
- httpd-2.4.66.tar.bz2
- inotify-tools-3.22.6.0.tar.gz
- ipcalc-1.0-cg.patch.bz2
- ipcalc-1.0.tar.bz2
- ipset-7.9.tar.bz2
- iptables-1.8.10.tar.xz
- jansson-2.14.1.tar.bz2
- keepalived-1.2.19.tar.bz2
- krb5-1.19.2.tar.gz
- lcd4linux-0.11.0-SVN.tar.bz2
- libaio_0.3.112.tar.xz
- libecap-1.0.1.tar.gz
- libmnl-1.0.5.tar.bz2
- libnftnl-1.2.6.tar.xz
- libpcap-1.10.1.tar.gz
- libtirpc-1.3.2.tar.bz2
- libusb-1.0.25.tar.bz2
- libuv-1.43.0.tar.xz
- libxml2-2.9.12.tar.gz
- libxslt-1.1.43.tar.xz
- lm-sensors-3-6-0.tar.gz
- logrotate-3.19.0.tar.gz
- LVM2-2.03.15.tar.gz
- lzo-2.10.tar.gz
- mandoc-1.14.6.tar.gz
- mdadm-4.1.tar.bz2
- mhash-0.9.9.9.tar.bz2
- mod_auth_gssapi-1.6.3.tar.gz
- modsecurity-2.9.8-cg.patch.bz2
- modsecurity-2.9.8.tar.gz
- msktutil-1.2.tar.bz2
- nasm-2.15.05.tar.xz
- netcat-0.7.1.tar.bz2
- net-snmp-5.9.1.tar.gz
- nfs-utils-2.6.2.tar.xz
- nghttp2-1.48.0.tar.bz2
- nmap-7.92.tar.bz2
- ntp-4.2.8p15.tar.gz
- oath-toolkit-2.6.13.tar.gz
- onig-6.9.10.tar.gz
- openldap-2.6.10.tar.gz
- openssh-10.2p1.tar.gz
- otphp-11.4.2.tar.gz
- parted-3.4.tar.xz
- pciutils-3.7.0.tar.xz
- pcre2-10.39.tar.bz2
- pcre-8.45.tar.bz2
- php-8.3.13.tar.gz
- ply-3.11.tar.gz
- popt-1.18.tar.gz
- reiserfsprogs-3.6.21.tar.bz2
- rpcsvc-proto-1.4.3.tar.xz
- rsync-3.2.7.tar.gz
- rustc-1.90.0-src.tar.xz
- sendmail-8.17.1.tar.gz
- smartmontools-7.2.tar.gz
- sqlite-src-3470000.tar.gz
- squid-7.4.tar.bz2
- squid-dummy-auth-1.0.tar.bz2
- squid-ecap-gzip-master-1.3-cg.patch.bz2
- squid-ecap-gzip-master-1.3.tar.bz2
- squidGuard-1.4-cg.patch.bz2
- squidGuard-1.4.tar.bz2
- sshfs-3.7.3.tar.xz
- ssmtp-2.64.tar.bz2
- strongswan-6.0.4.tar.bz2
- sudo-1.9.9.tar.gz
- sysfsutils-2.1.0.tar.gz
- syslinux-6.04-pre1.tar.xz
- sysstat-12.5.5.tar.gz
- tcpdump-4.99.1.tar.gz
- tmpwatch-2.11.tar.bz2
- tpm2-tools-5.2.tar.gz
- tpm2-tss-3.2.0.tar.gz
- unix2dos-2.2.tar.bz2
- usbutils-014.tar.xz
- userspace-rcu-0.15.0.tar.bz2
- usleep-1.0.tar.bz2
- vixie-cron-4.1-cg.patch.bz2
- vixie-cron-4.1.tar.bz2
- WALinuxAgent-2.9.1.1-cg.patch.bz2
- WALinuxAgent-2.9.1.1.tar.gz
- wget2-2.2.1.tar.gz
- which-2.21.tar.gz
- yajl-2.1.0.tar.gz

---

## APPLIANCE/Signature
Contains cryptographic fingerprints for all packages in APPLIANCE/Source.

---

## LFS/Source

This directory contains all packages required to build the base Linux From Scratch system, including toolchain, system utilities, libraries, kernel, and core system components.

### Packages

- acl-2.3.1.tar.xz
- attr-2.5.1.tar.gz
- autoconf-2.71.tar.xz
- automake-1.16.5.tar.xz
- bash-5.1.16.tar.gz
- bc-5.2.2.tar.xz
- binutils-2.38-lto_fix-1.patch.bz2
- binutils-2.38.tar.xz
- bison-3.8.2.tar.xz
- bzip2-1.0.8-install_docs-1.patch.bz2
- bzip2-1.0.8.tar.gz
- check-0.15.2.tar.gz
- coreutils-9.0-chmod_fix-1.patch.bz2
- coreutils-9.0-i18n-1.patch.bz2
- coreutils-9.0.tar.xz
- dejagnu-1.6.3.tar.gz
- diffutils-3.8.tar.xz
- dummy-0.0.tar.gz
- e2fsprogs-1.46.5.tar.gz
- elfutils-0.186.tar.bz2
- eudev-3.2.11.tar.gz
- expat-2.4.5.tar.bz2
- expect5.45.4.tar.gz
- expect-5.45.4.tar.xz
- file-5.41.tar.gz
- findutils-4.9.0.tar.xz
- flex-2.6.4.tar.gz
- gawk-5.1.1.tar.xz
- gcc-11.2.0.tar.xz
- gdbm-1.23.tar.gz
- gettext-0.21.tar.xz
- glibc-2.35-fhs-1.patch.bz2
- glibc-2.35.tar.xz
- gmp-6.2.1.tar.xz
- gperf-3.1.tar.gz
- grep-3.7.tar.xz
- groff-1.22.4.tar.gz
- grub-2.06.tar.xz
- gzip-1.11.tar.xz
- iana-etc-20220207.tar.gz
- inetutils-2.2-cg.patch.bz2
- inetutils-2.2.tar.xz
- intltool-0.51.0.tar.gz
- iproute2-5.16.0.tar.xz
- kbd-2.4.0-backspace-1.patch.bz2
- kbd-2.4.0.tar.xz
- kmod-34.2.tar.gz
- less-590.tar.gz
- lfs-bootscripts-20210608-cg.patch.bz2
- lfs-bootscripts-20210608.tar.xz
- libcap-2.63.tar.xz
- libffi-3.4.2.tar.gz
- libpipeline-1.5.5.tar.gz
- libpsl-0.21.5.tar.gz
- libtool-2.4.6.tar.xz
- linux-6.6.100.tar.xz
- linux-cg-64-3.2.config.bz2
- linux-cg-firmware.bz2
- linux-cg-hm-3.2.config.bz2
- linux-firmware-20250708.tar.xz
- Linux-PAM-1.5.3-docs.tar.xz
- Linux-PAM-1.5.3.tar.xz
- linux.README
- m4-1.4.19.tar.xz
- make-4.3.tar.gz
- man-db-2.10.1.tar.xz
- man-pages-5.13.tar.xz
- meson-0.61.1.tar.gz
- mpc-1.2.1.tar.gz
- mpfr-4.1.0.tar.xz
- ncurses-6.3.tar.gz
- ninja-1.10.2.tar.gz
- openssl-3.6.0.tar.gz
- patch-2.7.6.tar.xz
- perl-5.34.0.tar.xz
- perl-5.34.0-upstream_fixes-1.patch.bz2
- pkg-config-0.29.2.tar.gz
- procps-3.3.17.tar.xz
- psmisc-23.4.tar.xz
- python-3.10.2-docs-html.tar.bz2
- Python-3.10.2.tar.xz
- readline-8.1.2.tar.gz
- sed-4.8.tar.xz
- shadow-4.11.1.tar.xz
- sysklogd-1.5.1.tar.gz
- sysvinit-3.01-consolidated-1.patch.bz2
- sysvinit-3.01.tar.xz
- tar-1.34.tar.xz
- tcl8.6.12-html.tar.gz
- tcl8.6.12-src.tar.gz
- tcl-8.6.12.tar.xz
- texinfo-6.8.tar.xz
- tzdata2021e.tar.gz
- udev-lfs-20171102.tar.xz
- util-linux-2.37.4.tar.xz
- vim-8.2.4383.tar.gz
- XML-Parser-2.46.tar.gz
- xz-5.2.5.tar.xz
- zlib-1.2.11.tar.xz
- zstd-1.5.2.tar.gz

---

## LFS/Signature
Contains cryptographic fingerprints for all packages in LFS/Source.

---

## EXTRALFS/Source

Additional packages extending the base LFS system:

- busybox-1.35.0.tar.bz2
- busybox.config.bz2
- cmake-3.22.0.tar.bz2
- curl-8.18.0.tar.bz2
- gnupg-2.2.34.tar.bz2
- json-c-0.15.tar.gz
- libassuan-2.5.5.tar.bz2
- libestr-0.1.11.tar.gz
- libfastjson-1.2304.0.tar.gz
- libgcrypt-1.8.9.tar.bz2
- libgpg-error-1.44.tar.bz2
- libksba-1.6.0.tar.bz2
- liblogging-1.0.6.tar.gz
- libssh2-1.10.0.tar.bz2
- npth-1.6.tar.bz2
- pinentry-1.2.0.tar.bz2
- protobuf-34.1.tar.gz
- protobuf-c-1.5.2.tar.gz
- rsyslog-8.2602.0.tar.gz

---

## EXTRALFS/Signature
Contains cryptographic fingerprints for all packages in EXTRALFS/Source.

---

## EXECUTABLE

Precompiled binaries that could not be built within the standard LFS toolchain:

- cargo-1.89.0-x86_64-unknown-linux-gnu.tar.xz
- rust-std-1.89.0-x86_64-unknown-linux-gnu.tar.xz
- rustc-1.89.0-x86_64-unknown-linux-gnu.tar.xz
- rust-std-1.89.0-i686-unknown-linux-gnu.tar.xz
- cargo-1.89.0-i686-unknown-linux-gnu.tar.xz
- rustc-1.89.0-i686-unknown-linux-gnu.tar.xz
