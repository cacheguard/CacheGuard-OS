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

patch-v261-userenv-file()
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

	    ${current}PROXY_PORT)
		proxy_port=${assertion#*=}
		proxy_port=${proxy_port//\'}
		echo "export ${assertion}"
		;;
	    ${current}DHCP_RANGE_LIST)
		values=${assertion#*=}
		values=${values//\'}

		if test -z "${values}" ; then
		    echo "export ${assertion}"
		    continue
		else
		    interface=${values/ *}
		    case ${interface} in
			internal|auxiliary)
			    echo "export ${assertion}"
			    continue
			    ;;
			*)
			    ;;
		    esac
		fi

		i=0
		unset new_values
		for elt in ${values}
		do
		    range=$[${i} % 2]
		    case ${range} in
			0)
			    new_values="${new_values} internal ${elt}"
			    ;;
			1)
			    new_values="${new_values} ${elt}"
			    ;;
			*)
			    return 255
			    ;;
		    esac
		    ((i++))
		done
		echo "export ${variable}='${new_values:1}'"
		;;

	    ${current}DHCP_FIXED_LIST)

		values=${assertion#*=}
		values=${values//\'}

		if test -z "${values}" ; then
		    echo "export ${assertion}"
		    continue
		fi

		interface=$(get-nth-arg 2 ${values})
		case ${interface} in
		    internal|auxiliary)
			echo "export ${assertion}"
			continue
			;;
		    *)
			;;
		esac

		i=0
		unset new_values
		for elt in ${values}
		do
		    range=$[${i} % 3]
		    case ${range} in
			0)
			    new_values="${new_values} ${elt}"
			    ;;
			1)
			    new_values="${new_values} internal ${elt}"
			    ;;
			2)
			    new_values="${new_values} ${elt}"
			    ;;
			*)
			    return 255
			    ;;
		    esac
		    ((i++))
		done
		echo "export ${variable}='${new_values:1}'"
		;;

	    ${current}QOS_SHAPE_ROUTER_LIST)
		values=${assertion#*=}
		values=${values//\'}

		i=0
		unset new_values
		for elt in ${values}
		do
		    range=$[${i} % 10]
		    case ${range} in
			1)
			    test ${elt} != internal || elt='web'
			    new_values="${new_values} ${elt}"
			    ;;
			*)
			    new_values="${new_values} ${elt}"
			    ;;
		    esac
		    ((i++))
		done
		echo "export ${variable}='${new_values:1}'"
		;;

	    ${current}PEER_NEXT_LIST)
		values=${assertion#*=}
		values=${values//\'}

		i=0
		unset new_values
		for elt in ${values}
		do
		    range=$[${i} % 2]
		    case ${range} in
			1)
			    new_values="${new_values} ${elt}"
			    ;;
			*)
			    test ${elt} != nil || elt=${proxy_port}
			    new_values="${new_values} ${elt} 100"
			    ;;
		    esac
		    ((i++))
		done
		echo "export ${variable}='${new_values:1}'"
		;;

	    ${current}LDAP_SERVER_LIST)

		values=${assertion#*=}
		values=${values//\'}

		if test -z "${values}" ; then
		    echo "export ${assertion}"
		    continue
		fi

		local len=$(record-length-list 1 "${values}")
		if test ${len} -eq 3 ; then
		    echo "export ${assertion}"
		    continue
		fi

		local protocol=$(get-nth-arg 4 ${values})
		case ${protocol} in
		    ldap|ldaps|sldap)
			echo "export ${assertion}"
			continue
			;;
		    *)
			;;
		esac

		i=0
		unset new_values
		local name port

		for elt in ${values}
		do
		    range=$[${i} % 4]
		    case ${range} in
			0)
			    protocol=${elt}
			    ;;
			1)
			    name=${elt}
			    ;;
			2)
			    ;;
			3)
			    port=${elt}
			    new_values="${new_values} ${protocol} ${name} ${port}"
			    ;;
			*)
			    return 255
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

patch-v261-userenv-manager-templates()
{
    local rdir=${MANAGER_TEMPLATE_RDIR}
    local dir=${ABASE_DIR}/${rdir}
    local templates=$(ls -1 ${dir} 2> /dev/null)

    test -n "${templates}" || return 0

    local id env_file

    for id in ${templates}
    do
	env_file=${dir}/${id}/${ENV_NAME}

	patch-v261-userenv-file ${env_file}
	patch-v261-userenv-file ${env_file}.cancel
	patch-v261-userenv-file ${env_file}.current current

    done
}

patch-v261-userenv-manager-gateways()
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

	patch-v261-userenv-file ${env_file}
	patch-v261-userenv-file ${env_file}.cancel
	patch-v261-userenv-file ${env_file}.current current

    done < ${ABASE_DIR}/${MANAGER_GATEWAY_INDEX}
}

patch-v261-userenv()
{
    local env_file=${ABASE_DIR}/${ENV_RDIR}/${ENV_NAME}

    patch-v261-userenv-file ${env_file}
    patch-v261-userenv-file ${env_file}.cancel
    patch-v261-userenv-file ${env_file}.current current

    test ${APL_ROLE} == manager || return 0

    patch-v261-userenv-manager-templates
    patch-v261-userenv-manager-gateways
}

main()
{
    patch-v261-userenv
}

main
