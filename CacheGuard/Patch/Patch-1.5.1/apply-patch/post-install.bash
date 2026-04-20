#!/bin/bash

###########################################################################
#
# MODULE:       Patch
# AUTHOR(S):    CacheGuard Development Team
# COPYRIGHT:    (C) 2009-2020 by CacheGuard Technologies Ltd
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
source ${LOCAL_DIR}/lib/apl_functions

update-boot()
{
    cd /boot

    local new_kernels=$(ls -1 kernel-* 2> /dev/null) new_kernel
    local old_release new_release
    local sys_name

    for new_kernel in ${new_kernels}
    do
	sys_name=${new_kernel/kernel-}
	sys_name=${sys_name#*-}
	sys_name=${sys_name%-*}

	old_release=$(ls -1 initrd-*-${sys_name}-[0-9]*.img 2> /dev/null)
	new_release=$(ls -1 kernel-*-${sys_name}-[0-9]* 2> /dev/null)
	old_release=${old_release/initrd-}
	old_release=${old_release/\.img}
	new_release=${new_release/kernel-}

	test "${new_release}" != "${old_release}" || return 11

	chattr -i . config-${old_release}
	rm -f config-${old_release}
	apl_update_initrd ${old_release} ${new_release}
    done
}

add-ipsec-user()
{
    local passwd_line="${IPSEC_USER}:x:${IPSEC_UID}:${IPSEC_GID}:IPSec VPN:/usr/local/${IPSEC_USER}:/bin/false"
    local shadow_line="${IPSEC_USER}:!:12000:0:1000000:30:::"

    grep -q ${IPSEC_USER} /etc/passwd > /dev/null 2>&1
    test ${?} -ne 0 || return 13

    sed -ie "/^${AV_USER}:/a ${passwd_line}" /etc/passwd
    sed -ie "/^${AV_USER}:/a ${shadow_line}" /etc/shadow
}

update-userenv-file()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    local user=${1}
    local env_file=${2}
    local current=${3}

    local assertion var variable values
    local new_values value elt i=0 range
    local flow qos interface ip mask
    local interface interfaces
    local tmp_env_file=/tmp/userenv.${$}

    cp -f ${env_file} ${tmp_env_file}

    variable=${current}CA_LIST
    assertion=$(egrep "^export ${variable}=" ${tmp_env_file} 2> /dev/null)
    values=${assertion/*=}

    if test "${values}" != "''" ; then
	values=${values//\'}
	for value in ${values}
	do
	    new_values="${new_values} ${value} on"
	done
	new_values="${new_values:1}"
	sed -i -e "s/^export ${variable}=.*/export ${variable}='${new_values}'/" ${tmp_env_file}
    fi

    for var in \
	QOS_SHAPE_EXTERNAL_INGRESS_LIST \
	    QOS_SHAPE_EXTERNAL_EGRESS_LIST
    do
	variable=${current}${var}
	assertion=$(egrep "^export ${variable}=" ${tmp_env_file} 2> /dev/null)
	values=${assertion/*=}

	values=${values//\'}
	unset new_values
	i=0

	for elt in ${values}
	do
	    range=$[${i} % 2]
	    case ${range} in
		0)
		    flow=${elt}
		    ;;
		1)
		    qos=${elt}
		    if test ${flow} == default ; then
			new_values="${new_values} vpnipsec 10% ${flow} ${qos}"
		    else
			new_values="${new_values} ${flow} ${qos}"
		    fi
		    ;;
		*)
		    return 1
		    ;;
	    esac
	    ((i++))
	done
	new_values="${new_values:1}"
	sed -i -e "s/^export ${variable}=.*/export ${variable}='${new_values}'/" ${tmp_env_file}
    done

    for var in \
	TRANSPARENT_WEB_LIST \
	    ACCESS_WEB_LIST \
	    ACCESS_FILE_LIST \
	    ACCESS_ADMIN_LIST \
	    ACCESS_MON_LIST \
	    ACCESS_AV_LIST
    do
	variable=${current}${var}
	assertion=$(egrep "^export ${variable}=" ${tmp_env_file} 2> /dev/null)
	values=${assertion/*=}

	if test "${values}" != "''" ; then
	    values=${values//\'}
	    unset new_values
	    i=0

	    for elt in ${values}
	    do
		range=$[${i} % 3]
		case ${range} in
		    0)
			ip=${elt}
			;;
		    1)
			mask=${elt}
			;;
		    2)
			qos=${elt}
			case ${var} in
			    ACCESS_FILE_LIST|ACCESS_ADMIN_LIST|ACCESS_MON_LIST|ACCESS_AV_LIST)
				interfaces='internal external auxiliary vpnipsec'
				;;
			    TRANSPARENT_WEB_LIST|ACCESS_WEB_LIST)
				interfaces='internal auxiliary vpnipsec'
				;;
			    *)
				;;
			esac

			for interface in ${interfaces}
			do
			    new_values="${new_values} ${interface} ${ip} ${mask} ${qos}"
			done
			;;
		    *)
			return 1
			;;
		esac
		((i++))
	    done
	    new_values="${new_values:1}"
	    sed -i -e "s/^export ${variable}=.*/export ${variable}='${new_values}'/" ${tmp_env_file}
	fi
    done

    install -m 644 -o ${user} -g ${GROUP_NAME} ${tmp_env_file} ${env_file}
    rm -f ${tmp_env_file}
}

update-userenv-files()
{
    rm -f \
       ${TMP_DIR}/${LOADED}.${LDAP_CA} \
       ${TMP_DIR}/${LDAP_CA}.2del \
       ${PROXY_DIR}${LDAP_DIR}/${LDAP_CA} \
       ${SSL_DIR}/${LDAP_CA}

    cd ${BASE_DIR}

    local users=$(ls -1 2> /dev/null) user env_file

    for user in ${users}
    do
	test ${user} != lost+found || continue

	env_file=${user}/${ENV_RDIR}/${ENV_NAME}
	update-userenv-file ${user} ${env_file}

	test ${user} == ${ADMIN_NAME} || continue

	update-userenv-file ${user} ${env_file}.cancel
	update-userenv-file ${user} ${env_file}.current CURRENT_
    done
}

link-system-ca()
{
    ln -sf ../${SELF_CA}.cert ${LOCAL_CA_SSL_DIR}/${SYSTEM_CA_ID}.cert
    ln -sf ../${SELF_CA}.cert ${PROXY_LOCAL_CA_SSL_DIR}/${SYSTEM_CA_ID}.cert
}

set-vpn-psk()
{
    local secret=$(random-psk)
    local psk_file=${ABASE_DIR}/${ENV_RDIR}/${IPSEC_AUTHENTICATE_PSK_FILENAME}

    secret=$(encrypt-password "clear:${secret}" "${IPSEC_LOCAL_PASSWD}")
    echo -n "${secret}" > ${psk_file}

    cp -f ${psk_file} ${psk_file}.current
    chown ${ADMIN_NAME}:${GROUP_NAME} ${psk_file} ${psk_file}.current
}

update-boot "${@}"
add-ipsec-user "${@}"
update-userenv-files "${@}"
link-system-ca "${@}"
set-vpn-psk "${@}"
