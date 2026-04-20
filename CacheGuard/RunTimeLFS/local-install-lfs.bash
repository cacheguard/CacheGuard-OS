#!/bin/bash

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
