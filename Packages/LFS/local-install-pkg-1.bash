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

source /tmp/LFS.env
source /tmp/functions

# PACKAGES[i]="<package-name> <clean-flag> <build-pass> <patces-list>" ; ((i++))

i=0

PACKAGES[${i}]="dummy clean 1" ; ((i++))
PACKAGES[${i}]="gcc clean 1" ; ((i++))
PACKAGES[${i}]="gettext clean 1" ; ((i++))
PACKAGES[${i}]="bison clean 1" ; ((i++))
PACKAGES[${i}]="perl clean 1" ; ((i++))
PACKAGES[${i}]="Python clean 1" ; ((i++))
PACKAGES[${i}]="texinfo clean 1" ; ((i++))
PACKAGES[${i}]="util-linux clean 1" ; ((i++))
PACKAGES_NB=${i}

build1_dummy()
{
    compile-message &&
	make &&
	install-message &&
	make install
}

build1_gcc()
{
    ln -svf gthr-posix.h libgcc/gthr-default.h

    mkdir -v build && cd build || return 11

    configure-message &&
	CXXFLAGS="-g -O2 -D_GNU_SOURCE" \
		../libstdc++-v3/configure \
		--prefix=/usr \
		--disable-multilib \
		--disable-nls \
		--host=${SYS_ARCHITECTURE}-lfs-linux-gnu \
		--disable-libstdcxx-pch &&
	compile-message && make &&
	install-message && make install
}

build1_gettext()
{
    configure-message && ./configure --disable-shared &&
	compile-message && make &&
	install-message && cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /usr/bin
}

build1_bison()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --docdir=/usr/share/doc/bison-${PACKAGE_VERSION} &&
	compile-message && make &&
	install-message &&
	make install
}

build1_perl()
{
    configure-message &&
	sh Configure -des \
           -Dprefix=/usr  \
           -Dvendorprefix=/usr  \
           -Dprivlib=/usr/lib/perl5/${PACKAGE_VERSION}/core_perl \
           -Darchlib=/usr/lib/perl5/${PACKAGE_VERSION}/core_perl \
           -Dsitelib=/usr/lib/perl5/${PACKAGE_VERSION}/site_perl \
           -Dsitearch=/usr/lib/perl5/${PACKAGE_VERSION}/site_perl \
           -Dvendorlib=/usr/lib/perl5/${PACKAGE_VERSION}/vendor_perl \
           -Dvendorarch=/usr/lib/perl5/${PACKAGE_VERSION}/vendor_perl &&
	compile-message && make &&
	install-message &&
	make install &&
	cat << EOF > /etc/pip.conf
[global]
timeout = 60
no-cache-dir = false

[install]
no-compile = no
ignore-installed = true
no-dependencies = yes
EOF
}

build1_Python()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --enable-shared \
            --without-ensurepip &&
	compile-message && make &&
	install-message &&
	make install
}

build1_texinfo()
{
    sed -e 's/__attribute_nonnull__/__nonnull/' \
	-i gnulib/lib/malloc/dynarray-skeleton.c || return 11

    configure-message && ./configure --prefix=/usr &&
	compile-message && make &&
	install-message &&
	make install
}

build1_util-linux()
{
    mkdir -pv /var/lib/hwclock || return 11

    configure-message &&
	./configure \
	    ADJTIME_PATH=/var/lib/hwclock/adjtime \
            --libdir=/usr/lib \
            --docdir=/usr/share/doc/util-linux-2.37.4 \
            --disable-chfn-chsh \
            --disable-login \
            --disable-nologin \
            --disable-su \
            --disable-setpriv \
            --disable-runuser \
            --disable-pylibmount \
            --disable-static \
            --without-python \
            runstatedir=/run &&
	compile-message && make &&
	install-message &&
	make install
}

# Main()

#i=0
#PACKAGES_NB=${i}

set-lfs-env
CHECK=no
CHECK_RT=no
mkdir -p /tmp/${COMPILE_LOG_DIR}
init-install-env
install-packages /tmp/${COMPILE_LOG_DIR}
