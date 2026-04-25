#!/bin/bash

###########################################################################
#
# MODULE:       Build
# AUTHOR(S):    CacheGuard Development Team
# COPYRIGHT:    (C) 2009-2025 by CacheGuard Technologies Ltd (UK)
# COPYRIGHT:    (C) 2026-2026 by CacheGuard Technologies SAS (FR)
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#
###########################################################################

cd /tmp

source LFS.env
source APPLIANCE.env
source functions

# Useful in some hard cases: ./configure LDFLAGS="-Wl,-rpath -Wl,${LOCAL_DIR}/lib"...
# Never use the LD_LIBRARY_PATH variable. Prefer ldconfig to configure ldd.

# PACKAGES[i]="<package-name> <clean-flag> <build-pass> <patces-list>" ; ((i++))

i=0

# Libraries and Tools
PACKAGES[${i}]="dummy clean 1" ; ((i++))
PACKAGES[${i}]="gdb clean 1" ; ((i++))
PACKAGES[${i}]="jansson clean 1" ; ((i++))
PACKAGES[${i}]="libxml2 clean 1" ; ((i++))
PACKAGES[${i}]="libmnl clean 1" ; ((i++))
PACKAGES[${i}]="libuv clean 1" ; ((i++))
PACKAGES[${i}]="ply clean 1" ; ((i++))
PACKAGES[${i}]="libaio clean 1" ; ((i++))
PACKAGES[${i}]="which clean 1" ; ((i++))
PACKAGES[${i}]="nasm clean 1" ; ((i++))
PACKAGES[${i}]="mhash clean 1" ; ((i++))
PACKAGES[${i}]="pcre clean 1" ; ((i++))
PACKAGES[${i}]="pcre2 clean 1" ; ((i++))
PACKAGES[${i}]="popt clean 1" ; ((i++))
PACKAGES[${i}]="mandoc clean 1" ; ((i++))
PACKAGES[${i}]="efivar clean 1 i686-1" ; ((i++))
PACKAGES[${i}]="efibootmgr clean 1" ; ((i++))
PACKAGES[${i}]="grub clean 1" ; ((i++))
PACKAGES[${i}]="db clean 1" ; ((i++))
PACKAGES[${i}]="db-retrieve clean 1" ; ((i++))
PACKAGES[${i}]="dmidecode clean 1" ; ((i++))
PACKAGES[${i}]="lzo clean 1" ; ((i++))
PACKAGES[${i}]="gss clean 1" ; ((i++))
PACKAGES[${i}]="cyrus-sasl clean 1" ; ((i++))
PACKAGES[${i}]="krb5 clean 1" ; ((i++))
PACKAGES[${i}]="LVM2 clean 1" ; ((i++))
PACKAGES[${i}]="parted clean 1" ; ((i++))
PACKAGES[${i}]="brotli clean 1" ; ((i++))
PACKAGES[${i}]="netcat clean 1" ; ((i++))
PACKAGES[${i}]="sendmail clean 1" ; ((i++))
PACKAGES[${i}]="dos2unix clean 1" ; ((i++))
PACKAGES[${i}]="unix2dos clean 1" ; ((i++))
PACKAGES[${i}]="ipcalc clean 1 cg" ; ((i++))
PACKAGES[${i}]="wget2 clean 1" ; ((i++))
PACKAGES[${i}]="libtirpc clean 1" ; ((i++))
PACKAGES[${i}]="rpcsvc-proto clean 1" ; ((i++))
PACKAGES[${i}]="nghttp2 clean 1" ; ((i++))
PACKAGES[${i}]="yajl clean 1 cg" ; ((i++))
PACKAGES[${i}]="nfs-utils clean 1" ; ((i++))
PACKAGES[${i}]="libxslt clean 1" ; ((i++))
PACKAGES[${i}]="glib clean 1" ; ((i++))
PACKAGES[${i}]="fuse clean 1" ; ((i++))
PACKAGES[${i}]="sshfs clean 1" ; ((i++))
PACKAGES[${i}]="userspace-rcu clean 1" ; ((i++))
PACKAGES[${i}]="onig clean 1" ; ((i++))
PACKAGES[${i}]="git clean 1" ; ((i++))
PACKAGES[${i}]="rustc clean 1" ; ((i++))
PACKAGES[${i}]="lcd4linux clean 1" ; ((i++))

# System Tools
PACKAGES[${i}]="sudo clean 1" ; ((i++))
PACKAGES[${i}]="syslinux clean 1" ; ((i++))
PACKAGES[${i}]="mdadm clean 1" ; ((i++))
PACKAGES[${i}]="reiserfsprogs clean 1" ; ((i++))
PACKAGES[${i}]="dosfstools clean 1" ; ((i++))
PACKAGES[${i}]="sysfsutils clean 1" ; ((i++))
PACKAGES[${i}]="ethtool clean 1" ; ((i++))
PACKAGES[${i}]="pciutils clean 1" ; ((i++))
PACKAGES[${i}]="libusb clean 1" ; ((i++))
PACKAGES[${i}]="usbutils clean 1" ; ((i++))
PACKAGES[${i}]="logrotate clean 1" ; ((i++))
PACKAGES[${i}]="tmpwatch clean 1" ; ((i++))
PACKAGES[${i}]="vixie-cron clean 1 cg" ; ((i++))
PACKAGES[${i}]="crontabs clean 1" ; ((i++))
PACKAGES[${i}]="anacron clean 1 cg" ; ((i++))
PACKAGES[${i}]="inotify-tools clean 1" ; ((i++))
PACKAGES[${i}]="usleep clean 1" ; ((i++))

# Cloud Tools
PACKAGES[${i}]="aws-cfn-bootstrap clean 1" ; ((i++))
PACKAGES[${i}]="WALinuxAgent clean 1 cg" ; ((i++))

# Network Tools
PACKAGES[${i}]="libecap clean 1" ; ((i++))
PACKAGES[${i}]="libpcap clean 1" ; ((i++))
PACKAGES[${i}]="tcpdump clean 1" ; ((i++))
PACKAGES[${i}]="keepalived clean 1" ; ((i++))
PACKAGES[${i}]="libnftnl clean 1" ; ((i++))
PACKAGES[${i}]="iptables clean 1" ; ((i++))
PACKAGES[${i}]="ipset clean 1" ; ((i++))
PACKAGES[${i}]="openssh clean 1" ; ((i++))
PACKAGES[${i}]="nmap clean 1" ; ((i++))

# Hardware Monitoring
PACKAGES[${i}]="lm-sensors clean 1" ; ((i++))
PACKAGES[${i}]="acpid clean 1" ; ((i++))
PACKAGES[${i}]="smartmontools clean 1" ; ((i++))
PACKAGES[${i}]="sysstat clean 1" ; ((i++))

# Network Services & Tools
PACKAGES[${i}]="ntp clean 1" ; ((i++))
PACKAGES[${i}]="dhcp clean 1" ; ((i++))
PACKAGES[${i}]="bind clean 1" ; ((i++))
PACKAGES[${i}]="net-snmp clean 1" ; ((i++))
PACKAGES[${i}]="ssmtp clean 1" ; ((i++))
PACKAGES[${i}]="openldap clean 1" ; ((i++))
PACKAGES[${i}]="msktutil clean 1" ; ((i++))
PACKAGES[${i}]="curl clean 1" ; ((i++))
PACKAGES[${i}]="rsync clean 1" ; ((i++))

# Specific to CacheGuard Appliance
PACKAGES[${i}]="dialog clean 1" ; ((i++))
PACKAGES[${i}]="clamav clean 1 cg" ; ((i++))
PACKAGES[${i}]="c_icap clean 1" ; ((i++))
PACKAGES[${i}]="c_icap_modules clean 1" ; ((i++))
PACKAGES[${i}]="squid clean 1" ; ((i++))
PACKAGES[${i}]="squid-ecap-gzip-master clean 1 cg" ; ((i++))
PACKAGES[${i}]="squid-dummy-auth clean 1" ; ((i++))
PACKAGES[${i}]="squidGuard clean 1 cg" ; ((i++))
PACKAGES[${i}]="tpm2-tss clean 1" ; ((i++))
PACKAGES[${i}]="tpm2-tools clean 1" ; ((i++))
PACKAGES[${i}]="strongswan clean 1" ; ((i++))
PACKAGES[${i}]="cgic clean 1" ; ((i++))
PACKAGES[${i}]="apr clean 1" ; ((i++))
PACKAGES[${i}]="apr-util clean 1" ; ((i++))
PACKAGES[${i}]="httpd clean 1" ; ((i++))
PACKAGES[${i}]="cgi-message clean 1" ; ((i++))
PACKAGES[${i}]="modsecurity clean 1 cg" ; ((i++))
PACKAGES[${i}]="coreruleset clean 1" ; ((i++))
PACKAGES[${i}]="mod_auth_gssapi clean 1" ; ((i++))
PACKAGES[${i}]="sqlite-src clean 1" ; ((i++))
PACKAGES[${i}]="php clean 1" ; ((i++))
PACKAGES[${i}]="constant_time_encoding clean 1" ; ((i++))
PACKAGES[${i}]="otphp clean 1" ; ((i++))
PACKAGES[${i}]="google-authenticator-libpam clean 1" ; ((i++))
PACKAGES[${i}]="oath-toolkit clean 1" ; ((i++))

PACKAGES_NB=${i}

build_python_module()
{
    compile-message &&
	python setup.py build
}

install_python_module()
{
    install-message &&
	python setup.py install
}

build_install_python_module()
{
    build_python_module &&
	install_python_module
}

prefix-to-usr()
{
    test -f Makefile || return 1
    local lower=${1}

    local prefix='PREFIX'
    test -z "${lower}" || prefix=${prefix,,}

    sed -i -e "s@^${prefix}\s*=.*@${prefix} = /usr@" Makefile
}

build1_dummy()
{
    compile-message &&
	make &&
	install-message &&
	make install
}

build1_gdb()
{
    configure-message &&
	./configure --prefix=/usr &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_jansson()
{
    configure-message &&
	make configure &&
	./configure \
	    --prefix=/usr &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_libxml2()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static \
	    --with-history &&
	compile-message &&
	make &&
	install-message &&
	make install
}
build1_libmnl()
{
    configure-message &&
	./configure \
	    --host=${HOST_BUILD} \
	    --build=${HOST_BUILD} \
	    --prefix=/usr \
	    --enable-shared \
	    --disable-static &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_libuv()
{
    configure-message &&
	./autogen.sh &&
	./configure \
	    --prefix=/usr \
	    --disable-static &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_ply()
{
    install-message &&
	python3 setup.py install
}

build1_libaio()
{
    configure-message &&
	sed -i '/install.*libaio.a/s/^/#/' src/Makefile &&
	compile-message &&
	make || return 11

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make partcheck || return 13
	test-message-end
    fi
    
	install-message &&
	make install
}

build1_which()
{
    configure-message &&
	./configure --prefix=/usr &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_nasm()
{
    configure-message &&
	./autogen.sh &&
	    ./configure --prefix=/usr &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_mhash()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_pcre()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_pcre2()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_popt()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_mandoc()
{
    configure-message &&
	./configure &&
	compile-message &&
	make mandoc &&
	install-message &&
	install -v -m 755 mandoc   /usr/bin &&
	install -v -m 644 mandoc.1 /usr/share/man/man1
}

build1_efivar()
{
    configure-message &&
	sed '/prep :/a\\ttouch prep' -i src/Makefile &&
	compile-message &&
	make ERRORS= &&
	install-message &&
	make install LIBDIR=/usr/lib
}

build1_efibootmgr()
{
    local name=APL

    compile-message &&
	make EFIDIR=${name} EFI_LOADER=grubx64.efi &&
	install-message &&
	make install EFIDIR=${name}
}

vbuild1_grub()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --sysconfdir=/etc \
	    --disable-efiemu \
	    --disable-werror \
	    --target=${SYS_ARCHITECTURE} \
	    --with-platform=efi &&
	compile-message &&
	make || return 11
    
    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 13
	test-message-end
    fi
    
    install-message &&
	make install &&
	mv -v /etc/bash_completion.d/grub /usr/share/bash-completion/completions
}

build1_db()
{
    cd build_unix &&
	configure-message &&
	../dist/configure \
	    --prefix=/usr \
            --enable-compat185 \
            --enable-dbm \
            --disable-static \
            --enable-cxx &&
	compile-message &&
	make &&
	install-message &&
	make docdir=/usr/share/doc/${PACKAGE_NAME} install &&
	chown -v -R root:root \
	      /usr/bin/db_* \
	      /usr/include/db{,_185,_cxx}.h \
	      /usr/lib/libdb*.{so,la} \
	      /usr/share/doc/${PACKAGE_NAME}
}

build1_db-retrieve()
{
    gcc -ldb db_retrieve.c -o db_retrieve
    install -v -m 755 -o root -g root db_retrieve /usr/bin/db_retrieve
}

build1_dmidecode()
{
    prefix-to-usr lower &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_lzo()
{
    configure-message &&
	./configure \
	    --disable-static &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_gss()
{
    configure-message &&
	./configure \
	    --prefix=/usr  \
	    --disable-static \
	    --enable-srp-setpass \
	    --enable-srp \
	    --enable-otp \
	    --enable-scram \
	    --enable-digest \
	    --enable-cram \
	    --enable-checkapop \
	    --enable-gssapi=/usr/include/gssapi &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_cyrus-sasl()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_krb5()
{
    configure-message &&
	cd src &&
	./configure \
	    --prefix=/usr \
	    --disable-static &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_LVM2()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_parted()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_brotli()
{
    configure-message &&
	./bootstrap &&
	./configure --prefix=/usr &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_netcat()
{
    configure-message &&
	./configure \
	    --prefix=/usr &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_sendmail()
{
    cd libmilter &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_dos2unix()
{
    compile-message &&
	gcc dos2unix.c -o dos2unix &&
	install-message &&
	install -v -m 755 -o root -g root dos2unix /usr/bin/dos2unix &&
	install -v -m 444 -o root -g root dos2unix.1 /usr/share/man/man1/dos2unix.1
}

build1_unix2dos()
{
    compile-message &&
	gcc unix2dos.c -o unix2dos &&
	install-message &&
	install -v -m 755 -o root -g root unix2dos /usr/bin/unix2dos &&
	install -v -m 444 -o root -g root unix2dos.1 /usr/share/man/man1/unix2dos.1
}

build1_ipcalc()
{
    compile-message &&
	make &&
	install-message &&
	make install
}

build1_wget2()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static \
	    --with-openssl \
	    --with-ssl=openssl &&
	compile-message &&
	make || return 11

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 13
	test-message-end
    fi

    install-message &&
	make install
}

build1_libtirpc()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static &&
	compile-message &&
	make || return 11

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 13
	test-message-end
    fi

    install-message &&
	make install
}

build1_rpcsvc-proto()
{
    configure-message &&
	./configure \
	    --prefix=/usr &&
	compile-message &&
	make &&
	install-message &&
	make install
}


build1_nghttp2()
{
    configure-message &&
	./configure \
	    --prefix=/usr &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_yajl()
{
    configure-message &&
	./configure \
	    --prefix=${LOCAL_DIR} &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_libnl()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static \
	    --disable-debug &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_libevent()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-debug-mode \
	    --disable-static &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_nfs-utils()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-gss \
	    --disable-nfsv4 \
	    --disable-nfsv41 \
	    --disable-ipv6 &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_libxslt()
{
    configure-message &&
	./configure \
	    --prefix=/usr &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_glib()
{
    mkdir -vp build &&
	cd build &&
	configure-message &&
	meson setup .. &&
	meson configure -D prefix=/usr -D libdir=lib -D tests=false &&
	meson setup --reconfigure ..
	compile-message &&
	ninja &&
	install-message &&
	ninja install
}

build1_fuse()
{
    mkdir -vp build &&
	cd build &&
	configure-message &&
	meson setup .. &&
	meson configure -D prefix=/usr -D libdir=lib &&
	meson setup --reconfigure ..
	compile-message &&
	ninja &&
	install-message &&
	ninja install
}

build1_sshfs()
{
    mkdir -vp build &&
	cd build &&
	configure-message &&
	meson setup .. &&
	meson configure -D prefix=/usr -D libdir=lib &&
	meson setup --reconfigure ..
	compile-message &&
	ninja &&
	install-message &&
	ninja install
}

build1_userspace-rcu()
{
    configure-message &&
	./configure \
	    --prefix=/usr &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_onig()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_git()
{
    configure-message &&
	make configure &&
	./configure \
	    --prefix=/usr &&
	compile-message &&
	make all &&
	install-message &&
	make install
}

build1_rustc()
{
    local cross_version=1.89.0
    local cross_pkgs="rust-std rustc cargo"
    local build_dir=build/cache/2025-08-07
    local package_version=${PACKAGE_VERSION/-src}
    local pkg

    cat << EOF > bootstrap.toml
change-id = 144675

[llvm]
link-shared = true
targets = "X86"

[build]
description = "for CacheGuard-OS"
docs = false
locked-deps = true
tools = ["cargo", "clippy", "rustdoc", "rustfmt"]

[install]
prefix = "/opt/rustc-1.90.0"
docdir = "share/doc/rustc-1.90.0"

[rust]
channel = "stable"
lto = "thin"
codegen-units = 1
llvm-bitcode-linker = false

[target.x86_64-unknown-linux-gnu]
# llvm-config = "/usr/bin/llvm-config"

[target.i686-unknown-linux-gnu]
# llvm-config = "/usr/bin/llvm-config"
EOF

    export PKG_CONFIG_PATH=/usr/lib/pkgconfig
    export LIBSSH2_SYS_USE_PKG_CONFIG=1
    export LIBSQLITE3_SYS_USE_PKG_CONFIG=1

    mkdir -vp /opt/rustc-${package_version} &&
	ln -svfn rustc-${package_version} /opt/rustc

    mkdir -vp ${build_dir}

    for pkg in ${cross_pkgs}
    do
	cp -vf ../${pkg}-${cross_version}-${SYS_ARCHITECTURE}-unknown-linux-gnu.tar.xz ${build_dir}
    done

    compile-message &&
	./x.py build || return 11

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	./x.py test --verbose --no-fail-fast | tee rustc-testlog
	test-message-end
    fi

    install-message &&
	./x.py install
}

build1_lcd4linux()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_sudo()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static \
            --libexecdir=/usr/lib \
            --docdir=/usr/share/doc/${PACKAGE_NAME} \
	    --with-passprompt="[sudo] password for %p: " \
            --with-env-editor &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_syslinux()
{
    test ${SYS_ARCHITECTURE} == x86_64 || return 0

    local mk

    for mk in mk/{com32,efi,elf,embedded,lib}.mk
    do
	sed -i \
	    -e 's/^CFLAGS\s*=/CFLAGS = -fcommon/' \
	    -e 's/^LNXCFLAGS\s*=/LNXCFLAGS = -fcommon/' ${mk}
    done

    sed -i -e 's/^CFLAGS\s*=/CFLAGS = -fcommon/'  mk/build.mk

    sed -i \
	-e 's/^MAKEDEPS\s*=/MAKEDEPS = -fcommon/' \
	-e 's/^UMAKEDEPS\s*=/UMAKEDEPS = -fcommon/' mk/syslinux.mk

    if test ${PACKAGE_VERSION} == '6.03' ; then

	for mk in mk/{com32,efi,elf,embedded,lib}.mk
	do
	    sed -i -e 's/^LDFLAGS\s*=/LDFLAGS = --no-dynamic-linker/' ${mk}
	done

	sed -i -e 's/^LD\s*+=/LD += --no-dynamic-linker/' mk/embedded.mk

	sed -i \
	    -e 's/^CFLAGS\s*:=/CFLAGS := -fcommon/' \
	    -e 's/^LDFLAGS\s*:=/LDFLAGS := --no-dynamic-linker/' gpxe/src/Makefile
    fi

    sed -i \
	-e '/#include <sys\/stat.h>/a #include <sys\/sysmacros.h>' extlinux/main.c

    sed -i \
	-e '/#endif/d' \
	-e '/#define strlen(a)/d' dos/string.h

    cat << EOF >> dos/string.h
static inline int strlen(const char *str)
{
  const char *s;

  for (s = str; *s; ++s);
  return (s - str);
}

#endif /* _STRING_H */
EOF

    compile-message &&
	make &&
	install-message &&
	make install || return 11

    cd / &&
	tar cf /tmp/syslinux.tar usr/share/syslinux &&
	gzip /tmp/syslinux.tar
}

build1_mdadm()
{
    sed -i -e 's/-Werror//' Makefile

    make clean &&
	compile-message &&
	make RUN_DIR=/var/run/mdadm &&
	make RUN_DIR=/var/run/mdadm mdadm.static &&
	install-message &&
	make RUN_DIR=/var/run/mdadm install &&
	install -v -o root -g root -m 755 mdadm.static /sbin/mdadm.static
}

build1_reiserfsprogs()
{
    configure-message &&
	./configure \
	    CFLAGS='-fgnu89-inline -D_GNU_SOURCE' \
	    --prefix=/usr \
	    --sbindir=/sbin &&
	compile-message &&
	make &&
	install-message &&
	make install &&
	ln -svf reiserfsck /sbin/fsck.reiserfs &&
	ln -svf mkreiserfs /sbin/mkfs.reiserfs
}

build1_dosfstools()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --enable-compat-symlinks \
	    --mandir=/usr/share/man \
	    -docdir=/usr/share/doc/${PACKAGE_NAME}&&
	compile-message &&
	make &&
	install-message &&
	make install &&
	ln -svf reiserfsck /sbin/fsck.reiserfs &&
	ln -svf mkreiserfs /sbin/mkfs.reiserfs
}

build1_sysfsutils()
{
    configure-message &&
	./configure \
	    --prefix=/usr &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_ethtool()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_pciutils()
{
    local pci_url="https://pci-ids.ucw.cz/v2.2/pci.ids.gz"

    prefix-to-usr &&
	compile-message &&
	SHARED=yes make &&
	install-message &&
	SHARED=yes make install &&
	echo "+++ ${CURL_COMMAND} ${pci_url} > pci.ids.gz" &&
	${CURL_COMMAND} ${pci_url} > pci.ids.gz &&
	rm -vf /usr/share/pci.ids.gz &&
	install -v -m 644 -o root -g root pci.ids.gz /usr/share/pci.ids.gz
}

build1_libusb()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_usbutils()
{
    local usb_url="http://www.linux-usb.org/usb.ids.gz"

    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static &&
	compile-message &&
	make &&
	install-message &&
	make install &&
	echo "+++ ${CURL_COMMAND} ${usb_url} > usb.ids.gz" &&
	${CURL_COMMAND} ${usb_url} > usb.ids.gz &&
	install -v -m 644 -o root -g root usb.ids.gz /usr/share/usb.ids.gz &&
	rm -f /usr/share/usb.ids &&
	gunzip /usr/share/usb.ids.gz
}

build1_logrotate()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static &&
    compile-message &&
	make &&
	install-message &&
	make install
}

build1_tmpwatch()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_vixie-cron()
{
    compile-message &&
	make &&
	install-message &&
	make install
}

build1_crontabs()
{
    install-message &&
	install -v -m 644 -o root -g root crontab /etc/crontab
    install -v -m 755 -o root -g root run-parts /bin/run-parts
    install -v -m 755 -o root -g root -d /etc/cron.d
    install -v -m 755 -o root -g root -d /etc/cron.hourly
    install -v -m 755 -o root -g root -d /etc/cron.daily
    install -v -m 755 -o root -g root -d /etc/cron.weekly
    install -v -m 755 -o root -g root -d /etc/cron.monthly
    install -v -m 700 -o root -g root -d /var/spool/cron
}

build1_anacron()
{
    compile-message &&
	make &&
	install-message &&
	make install

    install -v -m 700 -o root -g root -d /var/spool/anacron
}

build1_inotify-tools()
{
    configure-message &&
	./autogen.sh &&
	./configure \
	    --prefix=/usr &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_usleep()
{
    prefix-to-usr &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_aws-cfn-bootstrap()
{
    build_install_python_module
}

build1_WALinuxAgent()
{
    pip install distro &&
	install_python_module
}

build1_libecap()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_libpcap()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static &&
	make &&
	install-message &&
	make install
}

build1_tcpdump()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_keepalived()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_libnftnl()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --host=${HOST_BUILD} \
	    --build=${HOST_BUILD} \
	    --prefix=/usr \
	    --enable-shared \
	    --disable-static &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_iptables()
{
    configure-message &&
	./configure \
	--prefix=/usr \
	--disable-static \
	--enable-shared \
	--enable-devel &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_ipset()
{
    echo "+++ ./autogen.sh ${PACKAGE_NAME}" &&
	./autogen.sh &&
	configure-message &&
	./configure \
	    --prefix=/usr \
	    --host=${HOST_BUILD} \
	    --build=${HOST_BUILD} \
	    --disable-static \
	    --enable-shared \
	    --with-maxsets=256 \
	    --with-ksource=/usr/src/linux-${SYS_VERSION} \
	    --with-kbuild=/usr/src/linux-${SYS_VERSION} \
	    compile-message &&
	make &&
	install-message &&
	make install
}

build1_openssh()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --with-pam \
	    --with-ssl-engine \
	    --with-libs=-ldl \
	    --disable-lastlog \
	    --with-privsep-user=sshd &&
	compile-message &&
	make &&
	install-message &&
	make install &&
	mkdir -vp /etc/ssh &&
	ln -vfs /etc/sshd_config /etc/ssh/sshd_config
}

build1_nmap()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static \
	    --without-zenmap &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_lm-sensors()
{
    compile-message &&
	make all &&
	install-message &&
	make install
}

build1_acpid()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static \
	    --host=${HOST_BUILD} \
	    --build=${HOST_BUILD} \
	    --docdir=/usr/share/doc/${PACKAGE_NAME} &&
	compile-message &&
	make &&
	install-message &&
	make install &&
	install -v -m755 -d /etc/acpi/events &&
	cp -r samples /usr/share/doc/${PACKAGE_NAME} &&
	rm -vf /usr/share/doc/${PACKAGE_NAME}/samples/powerbtn/powerbtn.sh.old
}

build1_smartmontools()
{    
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static &&
	compile-message &&
	make &&
	install-message &&
	make install &&
	echo "+++ Updating the Smart Drive DB..." &&
	update-smart-drivedb &&
	rm -vf /usr/share/smartmontools/drivedb.h.old
}

build1_sysstat()
{    
    configure-message &&
	./configure \
	    --prefix=/usr &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_ntp()
{
    sed -e 's/"(\\S+)"/"?([^\\s"]+)"?/' \
	-i scripts/update-leap/update-leap.in

    sed -e 's/#ifndef __sun/#if !defined(__sun) \&\& !defined(__GLIBC__)/' \
	-i libntp/work_thread.c

    configure-message &&
	./configure \
	    --bindir=/usr/sbin \
            --sysconfdir=/etc \
            --enable-linuxcaps \
            --with-lineeditlibs=readline \
            --docdir=/usr/share/doc/${PACKAGE_NAME} || return 11

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 13
	test-message-end
    fi

    compile-message &&
	make &&
	install-message &&
	make install &&
	install -v -o ntp -g ntp -d /var/lib/ntp
}

build1_dhcp()
{
    configure-message &&
	./configure \
	    CFLAGS=-fcommon \
	    --prefix=/usr \
	    --disable-static &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_bind()
{
    configure-message &&
	./configure \
	    --prefix=${LOCAL_DIR} \
	    --disable-static &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_net-snmp()
{
    configure-message &&
	./configure --prefix=/usr \
		    --disable-static \
		    --host=${HOST_BUILD} \
		    --build=${HOST_BUILD} \
		    --disable-deprecated \
		    --disable-embedded-perl \
		    --enable-local-smux \
		    --enable-fast-install \
		    --without-rpm \
		    --with-defaults \
		    --with-default-snmp-version=3 \
		    --with-sys-contact="snmp@example.com" \
		    --with-sys-location="UK" \
		    --with-persistent-directory=/var/snmp \
		    --with-copy-persistent-files="yes" \
		    --with-transports="UDP TCP DTLSUDP TLSTCP Unix Callback Alias" \
		    --with-security-modules="usm tsm" \
		    --without-root-access \
		    --with-mib-modules="mibII snmpv3mibs ucd_snmp agent_mibs agentx notification target utilities disman/event disman/schedule host mibII/mta_sendmail ucd-snmp/diskio tunnel etherlike-mib" &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_ssmtp()
{
    rm -vf /usr/local/etc/ssmtp/ssmtp.conf &&
	configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static &&
	compile-message &&
	make &&
	install-message &&
	make install << EOF
example.com

EOF
}

build1_openldap()
{
    configure-message &&
	./configure \
	    --build=${HOST_BUILD} \
	    --host=${HOST_BUILD} \
	    --target=${HOST_BUILD} \
	    --prefix=/usr \
	    --disable-debug \
	    --disable-static \
	    --enable-shared \
	    --enable-dynamic \
	    --enable-slapd \
	    --enable-modules \
	    --enable-ldap \
	    --enable-mdb \
	    --enable-meta \
	    --enable-asyncmeta \
	    --enable-null \
	    --enable-passwd \
	    --enable-relay \
	    --enable-cleartext \
	    --enable-crypt \
	    --with-cyrus-sasl \
	    --with-tls=openssl &&
	make depend &&
	compile-message &&
	make &&
	install-message &&
	make install &&
	install -v -dm755 /usr/share/doc/${PACKAGE_NAME} &&
	cp -vfr doc/drafts /usr/share/doc/${PACKAGE_NAME} &&
	cp -vfr doc/rfc /usr/share/doc/${PACKAGE_NAME} &&
	cp -vfr doc/guide /usr/share/doc/${PACKAGE_NAME}
}

build1_msktutil()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_curl()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static \
	    --with-ca-bundle=/etc/ca-bundle.crt \
	    --with-openssl \
	    --with-gssapi \
	    --with-brotli \
	    --enable-ldap \
	    --enable-ldaps \
	    --with-nghttp2 \
	    --without-ngtcp2 \
	    --with-libssh2 \
            --enable-threaded-resolver &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_rsync()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-xxhash \
	    --disable-lz4 &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_dialog()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_cgic()
{
    compile-message &&
	make &&
	install-message &&
	make install
}

build1_cgi-message()
{
    compile-message &&
	CPFLAGS="-DMESSAGE_FILE=${CGI_MESSAGE_FILE}" make &&
	install-message &&
	make install
}

build1_clamav()
{
    PATH=${PATH}:/opt/rustc/bin

    mkdir -v build &&
	cd build &&
	configure-message &&
	cmake .. \
	      -D CMAKE_BUILD_TYPE=Release \
	      -D CMAKE_INSTALL_PREFIX=${LOCAL_DIR} \
	      -D CMAKE_INSTALL_LIBDIR=lib \
	      -D APP_CONFIG_DIRECTORY=${LOCAL_DIR}/etc \
	      -D DATABASE_DIRECTORY=/var/clamav \
	      -D ENABLE_JSON_SHARED=ON \
	    &&
	    compile-message &&
	    cmake --build . || return 11

    if test "${CHECK}" == "yes" ; then
	test-message-begn
	ctest || return 13
	test-message-end
    fi

    rm -vf ${LOCAL_DIR}/lib/libclam* &&
	install-message &&
	cmake --build . --target install
}

build1_c_icap()
{
    configure-message &&
	./configure \
	    --prefix=${LOCAL_DIR} \
	    --host=${HOST_BUILD} \
	    --build=${HOST_BUILD} \
	    --disable-static \
	    --enable-large-files \
	    LIBS="-lpthread" &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_c_icap_modules()
{
    configure-message &&
	./configure \
	    --host=${HOST_BUILD} \
	    --build=${HOST_BUILD} \
	    --prefix=${LOCAL_DIR} \
	    --with-c-icap=${LOCAL_DIR} \
	    --with-clamav=${LOCAL_DIR} \
	    --disable-static &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_squid()
{
    unset LANGUAGE LC_ALL LANG
    local openssl=$(file-basename ../openssl-[0-9]*.tar.bz2 .tar.bz2)
    
    configure-message &&
	./configure \
	    --prefix=${PROXY_DIR} \
	    --mandir=${LOCAL_DIR}/man \
	    --disable-static \
	    --disable-arch-native \
	    --disable-strict-error-checking \
	    --enable-shared=yes \
	    --enable-static=no \
	    --enable-fast-install \
	    --enable-ltdl-install \
	    --enable-disk-io \
	    --enable-storeio="aufs,diskd" \
	    --with-pthreads \
	    --with-aufs-threads=32 \
	    --enable-removal-policies=lru \
	    --enable-icmp \
	    --enable-esi \
	    --enable-icap-client \
	    --enable-ecap \
	    --enable-useragent-log \
	    --enable-kill-parent-hack \
	    --enable-cachemgr-hostname=${APP_NAME} \
	    --enable-arp-acl \
	    --enable-forw-via-db \
	    --disable-devpoll \
	    --enable-linux-netfilter \
	    --enable-follow-x-forwarded-for \
	    --enable-auth \
	    --enable-auth-digest="eDirectory,file,LDAP" \
	    --enable-auth-basic="NCSA,LDAP" \
	    --enable-auth-negotiate="kerberos,wrapper" \
	    --enable-ntlm-fail-open \
	    --enable-external-acl-helpers="LDAP_group" \
	    --enable-cpu-profiling \
	    --enable-x-accelerator-vary \
	    --enable-zph-qos \
	    --disable-translation \
	    --disable-auto-locale \
	    --enable-default-err-language=English \
	    --enable-err-languages=English \
	    --enable-http-violations \
	    --with-dl \
	    --with-openssl \
	    --enable-ssl \
	    --enable-ssl-crtd \
	    --with-large-files \
	    --with-filedescriptors=2048 \
	&&
	compile-message &&
	make &&
	install-message &&
	make install &&
	make install-pinger
}

build1_squid-ecap-gzip-master()
{
    configure-message &&
	./configure \
	    --prefix=${PROXY_DIR} \
	    --disable-static &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_squid-dummy-auth()
{
    compile-message &&
	make &&
	install-message &&
	install -v -m 755 -o root -g root dummy_auth ${PROXY_DIR}/libexec/dummy_auth
}

build1_squidGuard()
{
    configure-message &&
	CFLAGS=-fcommon \
	    ./configure \
	    --prefix=${PROXY_DIR} \
	    --disable-static \
	    --with-squiduser=${SQUID_USER} \
	    --with-sg-logdir=/var/log \
	    --with-sg-dbhome=/var/db/squidGuard \
	    --with-ldap \
	    --with-sg-config=/etc/squidGuard.conf \
	&&
	compile-message &&
	make &&
	install-message &&
	make install &&
	rmdir -v /var/db/squidGuard
}

build1_tpm2-tss()
{
    configure-message &&
	./configure \
	    PKG_CONFIG_PATH=${PKGCONFIG_DIR} \
	    --prefix=/usr \
	    --disable-static &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_tpm2-tools()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static &&
	compile-message &&
	make &&
	install-message &&
	make install
}

uninstall_strongswan()
{
    cd /usr/local/libexec
    rm -rf ipsec
    cd /usr/local/lib
    rm -rf ipsec/
    rm /usr/local/sbin/ipsec
    cd /usr/local/etc
    rm -rf strongswan.d
    rm /usr/local/share/man/man8/ipsec.8
    cd /usr/local/share
    rm -rf strongswan
    rm /usr/local/sbin/charon-cmd
    rm /usr/local/share/man/man8/charon-cmd.8
    rm /usr/local/share/man/man5/strongswan.conf.5
    rm /usr/local/etc/strongswan.conf
}

build1_strongswan()
{
    local pkgconfig

    configure-message &&
	./configure \
	    PKG_CONFIG_PATH=${PKGCONFIG_DIR} \
	    --prefix=${LOCAL_DIR} \
	    --disable-static \
	    --enable-aes \
	    --enable-cmac \
	    --enable-des \
	    --enable-drbg \
	    --enable-fips-prf \
	    --enable-gmp \
	    --enable-curve25519 \
	    --enable-hmac \
	    --enable-md5 \
	    --enable-nonce \
	    --enable-random \
	    --enable-rc2 \
	    --enable-sha1 \
	    --enable-sha2 \
	    --enable-xcbc \
	    --enable-dnskey \
	    --enable-pem \
	    --enable-pgp \
	    --enable-pkcs1 \
	    --enable-pkcs7 \
	    --enable-pkcs8 \
	    --enable-pkcs12 \
	    --enable-pubkey \
	    --enable-sshkey \
	    --enable-x509 \
	    --enable-constraints \
	    --enable-revocation \
	    --enable-xauth-generic \
	    --enable-kernel-netlink \
	    --enable-socket-default \
	    --enable-stroke \
	    --enable-vici \
	    --enable-resolve \
	    --enable-updown \
	    --enable-charon \
	    --enable-libtool-lock \
	    \
	    --enable-af-alg \
	    --enable-bliss \
	    --enable-blowfish \
	    --enable-ccm \
	    --enable-chapoly \
	    --enable-ctr \
	    --enable-gcm \
	    --enable-md4 \
	    --enable-mgf1 \
	    --enable-newhope \
	    --enable-ntru \
	    --enable-openssl \
	    --enable-rdrand \
	    --enable-aesni \
	    --enable-sha3 \
	    --enable-curl \
	    --enable-files \
	    --enable-ldap \
	    --enable-addrblock \
	    --enable-acert \
	    --enable-agent \
	    --enable-coupling \
	    --enable-dnscert \
	    --enable-eap-aka \
	    --enable-eap-aka-3gpp \
	    --enable-eap-aka-3gpp2 \
	    --enable-eap-identity \
	    --enable-eap-md5 \
	    --enable-eap-gtc \
	    --enable-eap-mschapv2 \
	    --enable-eap-tls \
	    --enable-eap-ttls \
	    --enable-eap-peap \
	    --enable-eap-tnc \
	    --enable-eap-dynamic \
	    --enable-eap-radius \
	    --enable-ext-auth \
	    --enable-ipseckey \
	    --enable-pkcs11 \
	    --enable-tpm \
	    --enable-whitelist \
	    --enable-xauth-eap \
	    --enable-xauth-noauth \
	    --enable-socket-dynamic \
	    --enable-smp \
	    --enable-sql \
	    --enable-attr-sql \
	    --enable-dhcp \
	    --enable-p-cscf \
	    --enable-unity \
	    --enable-imc-test \
	    --enable-imv-test \
	    --enable-imc-scanner \
	    --enable-imv-scanner \
	    --enable-imc-os \
	    --enable-imv-os \
	    --enable-imc-attestation \
	    --enable-imv-attestation \
	    --enable-imc-swima \
	    --enable-imv-swima \
	    --enable-imc-hcd \
	    --enable-imv-hcd \
	    --enable-tnc-ifmap \
	    --enable-tnc-imc \
	    --enable-tnc-imv \
	    --enable-tnc-pdp \
	    --enable-tnccs-11 \
	    --enable-tnccs-20 \
	    --enable-tnccs-dynamic \
	    --enable-bypass-lan \
	    --enable-certexpire \
	    --enable-connmark \
	    --enable-counters \
	    --enable-forecast \
	    --enable-duplicheck \
	    --enable-error-notify \
	    --enable-farp \
	    --enable-ha \
	    --enable-led \
	    --enable-load-tester \
	    --enable-lookip \
	    --enable-radattr \
	    --enable-save-keys \
	    --enable-systime-fix \
	    --enable-test-vectors \
	    --enable-cmd \
	    --enable-conftest \
	    --enable-medcli \
	    --enable-integrity-test \
	    --enable-mediation \
	    --enable-lock-profiler \
	    --enable-log-thread-ids \
	    --enable-shared \
	    --with-user=${IPSEC_USER} \
	    --with-group=${IPSEC_GROUP} \
	    --with-capabilities=libcap &&
	compile-message &&
	make &&
	install-message &&
	make install &&
	cat << EOF > ${LOCAL_DIR}/etc/strongswan.d/charon/kernel-netlink.conf
kernel-netlink {
	load = yes
}
EOF
}

build1_apr()
{
    configure-message &&
	./configure \
	    --prefix=${LOCAL_DIR} \
	    --disable-static &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_apr-util()
{
    configure-message &&
	./configure \
	    --prefix=${LOCAL_DIR} \
	    --with-apr=${LOCAL_DIR} \
	    --with-ldap=ldap \
	    --with-crypto \
	    --disable-static &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_httpd()
{
    configure-message &&
	./configure \
	    --prefix=${WEB_SERVER_DIR} \
	    --sysconfdir=${WEB_SERVER_DIR}/etc \
	    --with-apr=${LOCAL_DIR} \
	    --with-apr-util=${LOCAL_DIR} \
	    --with-crypto \
	    --with-ldap \
	    --with-mpm=prefork \
	    --datadir=${WEB_SERVER_DIR}/share \
	    --includedir=${WEB_SERVER_DIR}/include \
	    --localstatedir=${WEB_SERVER_DIR}/var \
	    --disable-static \
	    --enable-layout=GNU \
	    --enable-filter \
	    --disable-charset-lite \
	    --enable-ssl=shared \
	    --enable-http \
	    --disable-autoindex \
	    --disable-asis \
	    --enable-cgi=shared \
	    --disable-cgid \
	    --disable-negotiation \
	    --disable-actions \
	    --disable-userdir \
	    --enable-rewrite=shared \
	    --enable-so \
	    --enable-deflate=shared \
	    --enable-proxy=shared \
	    --enable-proxy-connect=shared \
	    --enable-proxy-ftp=shared \
	    --enable-proxy-http=shared \
	    --enable-proxy-ajp=shared \
	    --enable-headers=shared \
	    --enable-status=shared \
	    --enable-proxy-balancer=shared \
	    --enable-cache=shared \
	    --enable-mem-cache=shared \
	    --enable-disk-cache=shared \
	    --enable-unique-id=shared \
	    --enable-ldap=shared \
	    --enable-authnz-ldap=shared \
	    --enable-static-htpasswd &&
	compile-message &&
	make &&
	install-message &&
	make install &&
	chmod -v u+s ${WEB_SERVER_DIR}/bin/htpasswd
}

build1_modsecurity()
{
    configure-message &&
	./autogen.sh &&
	./configure \
	    --with-apr=${LOCAL_DIR} \
	    --with-apxs=${WEB_SERVER_DIR}/bin/apxs \
	    --with-yajl="${LOCAL_DIR}/lib ${LOCAL_DIR}" &&
	compile-message &&
	make &&
	install-message &&
	make install &&
	install -v -m 644 -o root -g root unicode.mapping ${WEB_SERVER_DIR}/etc/unicode.mapping &&
	chmod -v 755 ${WEB_SERVER_DIR}/libexec/mod_security2.so
}

build1_coreruleset()
{
    install-message &&
	install -v -m 644 -o root -g root crs-setup.conf.example ${WEB_SERVER_DIR}/etc/crs-setup.conf &&
	rm -rf ${WEB_SERVER_DIR}/etc/rules &&
	cp -vrf rules ${WEB_SERVER_DIR}/etc
}

build1_mod_auth_gssapi()
{
    configure-message &&
	autoreconf -fi &&
	./configure \
	    --with-apxs=${WEB_SERVER_DIR}/bin/apxs \
	    APACHE=${WEB_SERVER_DIR}/sbin/httpd &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_sqlite-src()
{
    configure-message &&
	./configure \
	    --host=${HOST_BUILD} \
	    --build=${HOST_BUILD} \
	    --prefix=${LOCAL_DIR} \
	    --enable-all &&
	compile-message &&
	make &&
	install-message &&
	make install &&
	cat << EOF > /usr/lib/pkgconfig/sqlite3.pc
###########################################################################
# sqlite3 installation details
###########################################################################

prefix=${LOCAL_DIR}
exec_prefix=\${prefix}
libdir=\${exec_prefix}/lib
includedir=\${prefix}/include

Name: SQLite
URL: https://sqlite.org/
Description: SQL database engine
Version: 3.47.0
Libs: -L\${libdir} -lsqlite3 -ldl
Libs.private: -lpthread
Cflags: -I\${includedir}
EOF
}

build1_php()
{
    configure-message &&
	./configure \
	    --host=${HOST_BUILD} \
	    --build=${HOST_BUILD} \
	    --prefix=${LOCAL_DIR} \
	    --with-apxs2=${WEB_SERVER_DIR}/bin/apxs \
	    --enable-mbstring \
	    PKG_CONFIG_PATH=${PKGCONFIG_DIR} \
	    SQLITE_CFLAGS=-lsqlite3 \
	    SQLITE_LIBS=-lsqlite3
	compile-message &&
	make &&
	install-message &&
	make install
}

install-php-libraries()
{
    local dir=${WEB_SERVER_DIR}/share/php/${PACKAGE_NAME} file

    mkdir -vp ${dir} && \
	install-message

    for file in src/*.php
    do
	install -v -m 644 -o root -g root ${file} ${dir}
    done
}

build1_constant_time_encoding()
{
    install-php-libraries
}

build1_otphp()
{
    install-php-libraries
}

build1_google-authenticator-libpam()
{
    configure-message &&
	./bootstrap.sh &&
	./configure \
	    --prefix=${LOCAL_DIR} \
	    --host=${HOST_BUILD} \
	    --build=${HOST_BUILD} \
	    --disable-static &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_oath-toolkit()
{
    configure-message &&
	./configure \
	    --prefix=${LOCAL_DIR} \
	    --host=${HOST_BUILD} \
	    --build=${HOST_BUILD} \
	    --enable-year2038 \
	    --disable-static &&
	compile-message &&
	make &&
	install-message &&
	make install
}

# Main()

# i=0
# PACKAGES_NB=${i}

CHECK=no
HOST_BUILD=${SYS_ARCHITECTURE}-linux-gnu
CURL_COMMAND="curl --silent -H 'Cache-Control: no-cache' --cacert /etc/ca-bundle.crt --url"
unset https_proxy
unset HTTPS_PROXY
init-install-env
mkdir -vp /tmp/${COMPILE_LOG_DIR}
install-packages /tmp/${COMPILE_LOG_DIR}
ldconfig
