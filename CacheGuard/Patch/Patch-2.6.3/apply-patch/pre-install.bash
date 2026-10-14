#!/bin/bash

###########################################################################
#
# MODULE:       Patch
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

CACHEGUARD_DIR=/etc/sysconfig/cacheguard

source ${CACHEGUARD_DIR}/constant
source ${APPLIANCE_DIR}/etc/role
source ${LOCAL_DIR}/lib/apl_common

patch-v263-userenv-file()
{
    test -n "${1}" || return 1
    local env_file=${1}
    local current=${2}

    local proxy_port='8080'
    local export assertion variable
    local values new_values interface
    local elt range i

    test -z "${current}" || current=CURRENT_
    local tmp_file=/tmp/userenv.${$}

    while read -r export assertion
    do
	test -n "${export}" || continue
	test "${export:0:1}" != '#' || continue

	variable=${assertion/=*/}

	case ${variable} in

	    ${current}IP_EXTRNAL_PPPOE_SERVICE_NAME|${current}IP_EXTRNAL_PPPOE_USERNAME|${current}IP_EXTRNAL_PPPOE_PASSWORD)
		variable=${variable/_EXTRNAL_/_EXTERNAL_}
		values=${assertion#*=}
		values=${values//\'}
		echo "export ${variable}='${values}'"
		;;
	    *)
		echo "export ${assertion}"
		;;
	esac
    done < ${env_file} > ${tmp_file}

    mv -f ${tmp_file} ${env_file}
    chown ${ADMIN_NAME}:${GROUP_NAME} ${env_file}
}

patch-v263-userenv-manager-templates()
{
    local rdir=${MANAGER_TEMPLATE_RDIR}
    local dir=${ABASE_DIR}/${rdir}
    local templates=$(ls -1 ${dir} 2> /dev/null)

    test -n "${templates}" || return 0

    local id env_file

    for id in ${templates}
    do
	env_file=${dir}/${id}/${ENV_NAME}

	patch-v263-userenv-file ${env_file}
	patch-v263-userenv-file ${env_file}.cancel
	patch-v263-userenv-file ${env_file}.current current

    done
}

patch-v263-userenv-manager-gateways()
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

	patch-v263-userenv-file ${env_file}
	patch-v263-userenv-file ${env_file}.cancel
	patch-v263-userenv-file ${env_file}.current current

    done < ${ABASE_DIR}/${MANAGER_GATEWAY_INDEX}
}

patch-v263-userenv()
{
    local env_file=${ABASE_DIR}/${ENV_RDIR}/${ENV_NAME}

    patch-v263-userenv-file ${env_file}
    patch-v263-userenv-file ${env_file}.cancel
    patch-v263-userenv-file ${env_file}.current current

    test ${APL_ROLE} == manager || return 0

    patch-v263-userenv-manager-templates
    patch-v263-userenv-manager-gateways
}

cleanup-ppp()
{
    rm -f /etc/ppp/*.example
}

main()
{
    patch-v263-userenv
    cleanup-ppp
}

main
