#!/bin/bash

###########################################################################
#
# MODULE:       Patch
# AUTHOR(S):    CacheGuard Development Team
# COPYRIGHT:    (C) 2009-2024 by CacheGuard Technologies Ltd
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

CACHEGUARD_DIR=/etc/sysconfig/cacheguard
source ${CACHEGUARD_DIR}/constant
source ${APPLIANCE_DIR}/etc/role
source ${LOCAL_DIR}/lib/apl_common

update-html-help()
{
    chmod 644 ${GUI_DIR}${ETC_HTML_RDIR}/*
    chmod 644 ${WEB_SERVER_DIR}${ETC_HTML_RDIR}/*
}

update-fstab()
{
    local tmp_fstab=/tmp/fstab.${$}
    local dev mp ftype rest

    while read dev mp ftype rest
    do
	if test -z "${dev}" ; then
	    echo
	    continue
	elif test ${dev:0:1} == '#' ; then
	     echo -n ${dev} ${mp} ${ftype}
	     test -z "${rest}" || echo -n ${rest}
	     echo
	     continue
	elif test "${mp}" == /boot/efi ;then
	    echo ${dev} ${mp} ${ftype} rw,nosuid,noexec,nodev,umask=0077 0 1
	    continue
	fi

	case ${dev} in
	    proc|sysfs)
		echo ${dev} ${mp} ${ftype} rw,${rest}
		;;
	    devpts)
		echo ${dev} ${mp} ${ftype} rw,nosuid,noexec,gid=5,mode=620 0 0
		;;
	    tmpfs)
		echo ${dev} ${mp} ${ftype} rw,nosuid,noexec 0 0
		;;
	    devtmpfs)
		echo ${dev} ${mp} ${ftype} rw,nosuid,noexec,mode=0755 0 0
		;;
	    efivarfs)
		echo ${dev} ${mp} ${ftype} rw,nosuid,noexec,nodev 0 0
		;;
	    proxy)
		echo ${dev} ${mp} ${ftype} rw,nosuid,noexec,nodev 0 0
		;;
	    /dev/Data/Swap)
		echo ${dev} ${mp} ${ftype} ${rest}
		;;
	    /dev/Data/Logs|/dev/Data/Temp|/dev/Data/AdminTemp|/dev/Data/AdminVar|/dev/Data/ProxyDB|/dev/Data/Var)
		echo ${dev} ${mp} ${ftype} rw,nosuid,noexec,nodev,auto,nouser,async,data=ordered 1 1
		;;
	    /dev/Data/AdminHome)
		echo ${dev} ${mp} ${ftype} rw,suid,exec,nodev,auto,nouser,async,data=journal 1 1
		;;
	    /dev/Data/WebCache|/dev/Data/ProxyCache)
		echo ${dev} ${mp} ${ftype} rw,nosuid,noexec,nodev,auto,nouser,async,noatime 1 1
		;;
	    /dev/pts)
		echo ${dev} ${mp} devpts rw,nosuid,noexec,gid=5,mode=620 0 0
		;;
	    *)
		echo ${dev} ${mp} ${ftype} ${rest}
		;;
	esac
    done < /etc/fstab > ${tmp_fstab}

    if test ${?} -ne 0 ; then
	rm -f ${tmp_fstab}
	return 11
    fi

    mv -f ${tmp_fstab} /etc/fstab
}

update-model-conf()
{
    local model_file model_files="${HARD_DIR}/model.conf"
    local pattern="HDD_INFOS="
    local len_pattern=${#pattern}

    local hdd_infos len_hdd_infos disk_infos
    local disk_type disk_id disk_size
    local elt range i=0

    if test ${APL_ROLE} == manager ; then
	local gateway_model_files=$(ls -1 ${ABASE_DIR}/${MANAGER_GATEWAY_RDIR}/*/${HARD_DIR_NAME}/model.conf 2> /dev/null)
	test -z "${gateway_model_files}" || \
	    model_files="${model_files} ${gateway_model_files}"
    fi

    for model_file in ${model_files}
    do
	sed -e '/^NAMED_MEMORY_SZ=.*/a SNMPD_MEMORY_SZ=4' ${model_file} > ${model_file}.upgraded
	mv -f ${model_file}.upgraded ${model_file}
    done
}

update-chroot-lib()
{
    local dir file base

    cd /root

    for dir in ${ADMIN_DIR} ${PROXY_DIR} ${WEB_SERVER_DIR}
    do
	rm -f ${dir}/lib/{libcom_err.so.2,libcom_err.so.2.1}
	rm -f ${dir}/lib/{libe2p.so.2,libe2p.so.2.3}

	for file in ${dir}/lib/*
	do
	    base=$(file-basename ${file})
	    ! test -f ${dir}/usr/lib/${base} || continue
	    cp -af ${file} ${dir}/usr/lib/
	done

	rm -rf ${dir}/lib
	ln -sf usr/lib ${dir}/lib

	case ${dir} in
	    ${ADMIN_DIR})
		for file in libacl.so \
			    libattr.so \
			    libbrotlicommon.so \
			    libbrotlidec.so \
			    libbz2.so \
			    libcap.so \
			    libcom_err.so \
			    libcurl.so \
			    libexpat.so \
			    libgdbm.so \
			    libgmp.so \
			    libgss.so \
			    libgssapi_krb5.so \
			    libhistory.so \
			    libk5crypto.so \
			    libkrb5.so \
			    libkrb5support.so \
			    liblber.so \
			    libldap.so \
			    liblzma.so \
			    libmagic.so \
			    libncursesw.so \
			    libnghttp2.so \
			    libpcre.so \
			    libpcre2-8.so \
			    libpcreposix.so \
			    libpipeline.so \
			    libpopt.so \
			    libreadline.so \
			    libsasl2.so \
			    libssh2.so \
			    libstdc++.so \
			    libuuid.so \
			    libxml2.so \
			    libz.so \
			    libzstd.so
		do
		    rm -f ${dir}/usr/lib/${file}
		done
		;;

	    ${PROXY_DIR})
		for file in libcurl.so \
			    libcurl.so.4 \
			    libcurl.so.4.8.0
		do
		    rm -f ${dir}/usr/lib/${file}
		done

		rm -rf ${dir}/usr/lib/sudo
		rm -rf ${dir}/usr/local
		;;
	    ${WEB_SERVER_DIR})
		for file in libcap.so \
			    libcurl.so \
			    libhistory.so \
			    libncursesw.so \
			    libreadline.so \
			    libcom_err.so.3 \
			    libcom_err.so.3.0
		do
		    rm -f ${dir}/usr/lib/${file}
		done

		rm -rf ${dir}/usr/lib/sudo
		;;
	    *)
		;;
	esac

	cd ${dir}/usr
	base=$(file-basename ${dir})
	tar cf /root/${base}-lib.tar lib
    done
}

main()
{
    update-html-help
    update-fstab
    update-model-conf
    update-chroot-lib
}

main
