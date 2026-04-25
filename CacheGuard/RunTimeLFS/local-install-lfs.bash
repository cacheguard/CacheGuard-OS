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

source /tmp/CacheGuard.env
source /tmp/WorkFunctions

gen-bin-keymaps()
{
    local keymap files
    local dir=/usr/share/binkeymaps

    mkdir -p ${dir}

    files=$(find /usr/share/keymaps/i386 -type f 2> /dev/null)

    for keymap in ${files}
    do
	keymap=${keymap:2}
	! [[ "${keymap}" =~ ^.*include/.* ]] || continue
	keymap=$(file-basename ${keymap} '.map\.gz')
	loadkeys --quiet --bkeymap --unicode ${keymap} > ${dir}/${keymap} 2> /dev/null
    done
}

gen-proxy-tar()
{
    cd ${PROXY_DIR}
    gen-library-list /tmp/proxy-binaries.lst /tmp/proxy-unlinked-libraries.lst > /tmp/proxy-libraries.lst

    tar \
	--numeric-owner \
	--same-owner \
	--create \
	--file /tmp/proxy.tar \
	$(cat /tmp/proxy-binaries.lst /tmp/proxy-others.lst)

    cd /
    tar \
	--numeric-owner \
	--same-owner \
	--append \
	--file /tmp/proxy.tar \
	$(cat /tmp/proxy-libraries.lst) \
	usr/lib/libxml2.so \
	usr/lib/libpcre.so

    rm -f /tmp/proxy-libraries.lst
}

gen-web-tar()
{
    local binary tmp_bin_file=/tmp/web_bin.lst.${$} tmp_lib_file=/tmp/web_lib.lst.${$}
    for binary in ${WAUDIT_BINARY_FILES}
    do
	echo ${binary:1}
    done > ${tmp_bin_file}

    cd /
    gen-library-list ${tmp_bin_file} > ${tmp_lib_file}

    cd ${WEB_SERVER_DIR}
    gen-library-list /tmp/web-binaries.lst /tmp/web-unlinked-libraries.lst > /tmp/web-libraries.lst

    tar \
	--numeric-owner \
	--same-owner \
	--create \
	--file /tmp/web.tar \
	$(cat /tmp/web-binaries.lst /tmp/web-others.lst)

    cd /

    cat /tmp/web-libraries.lst ${tmp_lib_file} | sort -u > ${tmp_lib_file}.uniq
    tar \
	--numeric-owner \
	--same-owner \
	--append \
	--file /tmp/web.tar \
	$(cat ${tmp_lib_file}.uniq)

    rm -f \
       /tmp/web-libraries.lst \
       ${tmp_lib_file}.uniq \
       ${tmp_lib_file} \
       ${tmp_bin_file}
}

gen-admin-tar()
{
    cd /
    gen-library-list /tmp/admin-binaries.lst /tmp/admin-unlinked-libraries.lst > /tmp/admin-libraries.lst

    tar \
	--numeric-owner \
	--same-owner \
	--create \
	--file /tmp/admin.tar \
	$(cat /tmp/admin-binaries.lst /tmp/admin-libraries.lst /tmp/admin-others.lst)

    rm -f /tmp/admin-libraries.lst
}

main()
{
    gen-bin-keymaps
    gen-proxy-tar
    gen-web-tar
    gen-admin-tar
}

# Main()

main
