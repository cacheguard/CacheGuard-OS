#!/bin/bash

###########################################################################
#
# MODULE:       Patch
# AUTHOR(S):    CacheGuard Development Team
# COPYRIGHT:    (C) 2009-2025 by CacheGuard Technologies Ltd
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
source ${APPLIANCE_DIR}/lib/lib-openssl

idempotent-decrypt-password()
{
    local clear_password

    clear_password=$(decrypt-password "${1}" "${2}")
    test ${?} -eq 0 || clear_password=${1}
    echo ${clear_password}
}

patch-encrypted-userenv-file()
{
    test -n "${1}" || return 1
    local env_file=${1}
    local current=${2}

    local ipsec_passwd
    local export assertion variable
    local values new_values
    local value new_value
    local elt range i

    if test -f ${PRIVATE_DIR}/.ipsec.site.passwd ; then
	ipsec_passwd='ipsec.site.passwd'
    elif test -f ${PRIVATE_DIR}/.ipsec.passwd ; then
	ipsec_passwd='ipsec.passwd'
    fi

    test -z "${current}" || current=CURRENT_
    local tmp_file=/tmp/userenv.${$}

    while read -r export assertion
    do
	test -n "${export}" || continue
	test "${export:0:1}" != '#' || continue

	variable=${assertion/=*/}

	case ${variable} in

	    ${current}SNMP_COMMUNITY|${current}SNMP_PRIVACY)
		values=${assertion#*=}
		values=${values//\'}
		new_values=$(idempotent-decrypt-password "${values}" "${SNMP_PASSWD}")
		echo "export ${variable}='${new_values}'"
		;;

	    ${current}EMAIL_ACCOUNT_PASSWORD)
		values=${assertion#*=}
		values=${values//\'}
		new_values=$(idempotent-decrypt-password "${values}" "${EMAIL_PASSWD}")
		echo "export ${variable}='${new_values}'"
		;;

	    ${current}KERBEROS_HA_SHARED_PASSWORD)
		values=${assertion#*=}
		values=${values//\'}
		new_values=$(idempotent-decrypt-password "${values}" "${KERBEROS_SHARED_PASSWD}")
		echo "export ${variable}='${new_values}'"
		;;

	    ${current}LDAP_BIND_PASSWORD)
		values=${assertion#*=}
		values=${values//\'}
		new_values=$(idempotent-decrypt-password "${values}" "${LDAP_PASSWD}")
		echo "export ${variable}='${new_values}'"
		;;

	    ${current}FILE_SERVER_PASSWORD_LIST)
		values=${assertion#*=}
		values=${values//\'}
		i=0
		unset new_values
		for elt in ${values}
		do
		    range=$[${i} % 4]
		    case ${range} in
			0|1|2)
			    new_values="${new_values} ${elt}"
			    ;;
			3)
			    elt=$(idempotent-decrypt-password "${elt}" "${FILE_PASSWD}")
			    new_values="${new_values} ${elt}"
			    ;;
			*)
			    return 1
			    ;;
		    esac
		    ((i++))
		done
		echo "export ${variable}='${new_values:1}'"
		;;

	    ${current}SNMP_TRAP_SERVER_LIST)
		local version
		values=${assertion#*=}
		values=${values//\'}
		i=0
		unset new_values

		for elt in ${values}
		do
		    range=$[${i} % 8]
		    case ${range} in
			0)
			    version=${elt}
			    new_values="${new_values} ${elt}"
			    ;;

			1|2|3|4|5)
			    new_values="${new_values} ${elt}"
			    ;;
			6)
			    elt=$(idempotent-decrypt-password "${elt}" "${SNMP_PASSWD}")
			    new_values="${new_values} ${elt}"
			    ;;
			7)
			    if test ${version} == v3 ; then
				elt=$(idempotent-decrypt-password "${elt}" "${SNMP_PASSWD}")
			    else
				elt=none
			    fi
			    new_values="${new_values} ${elt}"
			    ;;

			*)
			    return 1
			    ;;
		    esac
		    ((i++))
		done
		echo "export ${variable}='${new_values:1}'"
		;;

	    ${current}VPN_IPSEC_SITE_LIST)
		local auth_type
		values=${assertion#*=}
		values=${values//\'}
		i=0
		unset new_values

		for elt in ${values}
		do
		    range=$[${i} % 12]
		    case ${range} in
			0|1|4|5|6|7|8|9|10|11)
			    new_values="${new_values} ${elt}"
			    ;;
			2)
			    auth_type=${elt}
			    new_values="${new_values} ${elt}"
			    ;;
			3)
			    if test ${auth_type} == psk ; then
				elt=$(idempotent-decrypt-password "${elt}" "${ipsec_passwd}")
			    fi
			    new_values="${new_values} ${elt}"
			    ;;
			*)
			    return 1
			    ;;
		    esac
		    ((i++))
		done
		echo "export ${variable}='${new_values:1}'"
		;;
	    *)
		echo "export ${assertion}"
		;;
	esac
    done < ${env_file} > ${tmp_file}

    mv -f ${tmp_file} ${env_file}
    chown ${ADMIN_NAME}:${GROUP_NAME} ${env_file}
}

patch-encrypted-userenv-manager-templates()
{
    local rdir=${MANAGER_TEMPLATE_RDIR}
    local dir=${ABASE_DIR}/${rdir}
    local templates=$(ls -1 ${dir} 2> /dev/null)

    test -n "${templates}" || return 0

    local id env_file

    for id in ${templates}
    do
	env_file=${dir}/${id}/${ENV_NAME}

	patch-encrypted-userenv-file ${env_file}
	patch-encrypted-userenv-file ${env_file}.cancel
	patch-encrypted-userenv-file ${env_file}.current current

    done
}

patch-encrypted-userenv-manager-gateways()
{
    test -s ${ABASE_DIR}/${MANAGER_GATEWAY_INDEX} || return 0

    local rdir=${MANAGER_GATEWAY_RDIR}
    local dir=${ABASE_DIR}/${rdir}

    local uuid domain id ip
    local env_file

    while read uuid domain id ip
    do
	test -n "${ip}" || continue
	env_file=${dir}/${id}/${ENV_NAME}

	patch-encrypted-userenv-file ${env_file}
	patch-encrypted-userenv-file ${env_file}.cancel
	patch-encrypted-userenv-file ${env_file}.current current

    done < ${ABASE_DIR}/${MANAGER_GATEWAY_INDEX}
}

patch-encrypted()
{
    local env_file=${ABASE_DIR}/${ENV_RDIR}/${ENV_NAME}

    patch-encrypted-userenv-file ${env_file}
    patch-encrypted-userenv-file ${env_file}.cancel
    patch-encrypted-userenv-file ${env_file}.current current

    test ${APL_ROLE} == manager || return 0

    patch-encrypted-userenv-manager-templates
    patch-encrypted-userenv-manager-gateways
}

main()
{
    patch-encrypted
}

main
