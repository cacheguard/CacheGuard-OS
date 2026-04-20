#!/bin/bash

###########################################################################
#
# MODULE:       Patch
# AUTHOR(S):    CacheGuard Development Team
# COPYRIGHT:    (C) 2009-2023 by CacheGuard Technologies Ltd
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

patch-ipsec-access-authenticate-userenv-file()
{
    test -n "${1}" || return 1
    local env_file=${1}
    local current=${2}

    local export assertion variable
    local value auth

    test -z "${current}" || current=CURRENT_
    local tmp_file=/tmp/userenv.${$}

    while read -r export assertion
    do
	test -n "${export}" || continue
	test "${export:0:1}" != '#' || continue

	variable=${assertion/=*/}

	case ${variable} in

	    ${current}VPN_IPSEC_AUTHENTICATE)
		value=${assertion/*=}
		value=${value//\'}

		if test ${value:0:3} == 'psk' ; then
		    auth='psk'
		elif test ${value:0:3} == 'tls' ; then
		    auth='tls'
		elif test ${value:0:6} == 'eaptls' ; then
		    auth='eaptls'
		else
		    auth='psk'
		fi

		echo "export ${assertion}"
		;;

	    ${current}VPN_IPSEC_ACCESS_AUTHENTICATE)
		test -n "${auth}" || auth='psk'
		echo "export ${variable}='${auth}'"
		;;
	    *)
		echo "export ${assertion}"
		;;
	esac
    done < ${env_file} > ${tmp_file}

    mv -f ${tmp_file} ${env_file}
    chown ${ADMIN_NAME}:${GROUP_NAME} ${env_file}
}

patch-ipsec-access-authenticate-userenv-manager-templates()
{
    local rdir=${MANAGER_TEMPLATE_RDIR}
    local dir=${ABASE_DIR}/${rdir}
    local templates=$(ls -1 ${dir} 2> /dev/null)

    test -n "${templates}" || return 0

    local id env_file

    for id in ${templates}
    do
	env_file=${dir}/${id}/${ENV_NAME}

	patch-ipsec-access-authenticate-userenv-file ${env_file}
	patch-ipsec-access-authenticate-userenv-file ${env_file}.cancel
	patch-ipsec-access-authenticate-userenv-file ${env_file}.current current

    done
}

patch-ipsec-access-authenticate-userenv-manager-gateways()
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

	patch-ipsec-access-authenticate-userenv-file ${env_file}
	patch-ipsec-access-authenticate-userenv-file ${env_file}.cancel
	patch-ipsec-access-authenticate-userenv-file ${env_file}.current current

    done < ${ABASE_DIR}/${MANAGER_GATEWAY_INDEX}
}

patch-ipsec-access-authenticate()
{
    case ${APL_ROLE} in
	gateway)
	    local env_file=${ABASE_DIR}/${ENV_RDIR}/${ENV_NAME}

	    patch-ipsec-access-authenticate-userenv-file ${env_file}
	    patch-ipsec-access-authenticate-userenv-file ${env_file}.cancel
	    patch-ipsec-access-authenticate-userenv-file ${env_file}.current current
	    ;;
	manager)
	    patch-ipsec-access-authenticate-userenv-manager-templates
	    patch-ipsec-access-authenticate-userenv-manager-gateways
	    ;;
	*)
	    ;;
    esac
}

main()
{
    patch-ipsec-access-authenticate
}

main
