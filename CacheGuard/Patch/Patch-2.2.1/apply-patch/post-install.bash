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

patch-rweb-host-userenv-file()
{
    test -n "${1}" || return 1
    local env_file=${1}
    local current=${2}

    local export assertion variable
    local values new_values
    local elt range i

    test -z "${current}" || current=CURRENT_
    local tmp_file=/tmp/userenv.${$}

    while read -r export assertion
    do
	test -n "${export}" || continue
	test "${export:0:1}" != '#' || continue

	variable=${assertion/=*/}

	case ${variable} in

	    ${current}RWEB_SITE_HOSTS_LIST)
		local site_name hosts host
		local new_hosts
		unset new_values
		i=0
		;;
	    *)
		echo "export ${assertion}"
		continue
		;;
	esac

	values=${assertion/*=}
	values=${values//\'}

	case ${variable} in
	    ${current}RWEB_SITE_HOSTS_LIST)
		for elt in ${values}
		do
		    range=$[${i} % 2]
		    case ${range} in
			0)
			    site_name=${elt}
			    ;;
			1)
			    hosts=${elt}
			    hosts=${hosts//:/\ }
			    unset new_hosts

			    for host in ${hosts}
			    do
				if test "${host:0:5}" != rweb_ -a "${host:0:9}" != vpnipsec_ ; then
				    new_hosts="${new_hosts} rweb_http_${host}"
				else
				    new_hosts="${new_hosts} ${host}"
				fi
			    done

			    new_hosts=${new_hosts:1}
			    new_hosts=${new_hosts// /:}
			    new_values="${new_values} ${site_name} ${new_hosts}"
			    ;;
			*)
			    return 255
			    ;;
		    esac
		    ((i++))
		done

		new_values=${new_values:1}
		echo "export ${variable}='${new_values}'"
		;;
	    *)
		;;
	esac
    done < ${env_file} > ${tmp_file}

    mv -f ${tmp_file} ${env_file}
    chown ${ADMIN_NAME}:${GROUP_NAME} ${env_file}
}

patch-rweb-host-userenv-manager-templates()
{
    local rdir=${MANAGER_TEMPLATE_RDIR}
    local dir=${ABASE_DIR}/${rdir}
    local templates=$(ls -1 ${dir} 2> /dev/null)

    test -n "${templates}" || return 0

    local id env_file

    for id in ${templates}
    do
	env_file=${dir}/${id}/${ENV_NAME}

	patch-rweb-host-userenv-file ${env_file}
	patch-rweb-host-userenv-file ${env_file}.cancel
	patch-rweb-host-userenv-file ${env_file}.current current

    done
}

patch-rweb-host-userenv-manager-gateways()
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

	patch-rweb-host-userenv-file ${env_file}
	patch-rweb-host-userenv-file ${env_file}.cancel
	patch-rweb-host-userenv-file ${env_file}.current current

    done < ${ABASE_DIR}/${MANAGER_GATEWAY_INDEX}
}

patch-rweb-host()
{
    case ${APL_ROLE} in
	gateway)
	    local env_file=${ABASE_DIR}/${ENV_RDIR}/${ENV_NAME}

	    patch-rweb-host-userenv-file ${env_file}
	    patch-rweb-host-userenv-file ${env_file}.cancel
	    patch-rweb-host-userenv-file ${env_file}.current current
	    ;;
	manager)
	    patch-rweb-host-userenv-manager-templates
	    patch-rweb-host-userenv-manager-gateways
	    ;;
	*)
	    ;;
    esac
}

patch-initrd()
{
    apl_update_initrd grub
}

main()
{
    patch-rweb-host
    patch-initrd
}

main
