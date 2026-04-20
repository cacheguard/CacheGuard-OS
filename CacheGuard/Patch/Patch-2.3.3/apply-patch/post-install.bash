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

setup-configuration-db-files()
{
    test -n "${1}" || return 1
    local env_dir=${1}

    local env_file=${env_dir}/${ENV_NAME}
    local db_file=${env_dir}/${CONFIGURATION_DB_NAME}
    local db_cur_file=${env_dir}/${CONFIGURATION_CURRENT_DB_NAME}

    test ! -f ${db_file} || return 0
    local export assertion variable
    local values value

    install -m 644 -o ${ADMIN_NAME} -g ${GROUP_NAME} ${SAVE_DIR}/${CONFIGURATION_FACTORY_DB_NAME}.gateway ${db_file}

    while read -r export assertion
    do
	test -n "${export}" || continue
	test "${export:0:1}" != '#' || continue

	variable=${assertion/=*/}

	case ${variable} in

	    WAF_REPUTATION_COUNTRIES)

		values=${assertion#*=}
		values=${values//\'}

		for value in ${values}
		do
		    sqlite3 ${db_file} \
			    "UPDATE waf_reputation_country SET reputation = TRUE WHERE country = '${value,,}';"
		done
		;;

	    *)
		;;
	esac
    done < ${env_file}

    cp -a ${db_file} ${db_cur_file}
}

setup-configuration-db-manager-templates()
{
    local rdir=${MANAGER_TEMPLATE_RDIR}
    local dir=${ABASE_DIR}/${rdir}
    local templates=$(ls -1 ${dir} 2> /dev/null)

    test -n "${templates}" || return 0

    local id env_dir

    for id in ${templates}
    do
	env_dir=${dir}/${id}

	setup-configuration-db-files ${env_dir}
    done
}

setup-configuration-db-manager-gateways()
{
    test -s ${ABASE_DIR}/${MANAGER_GATEWAY_INDEX} || return 0

    local rdir=${MANAGER_GATEWAY_RDIR}
    local dir=${ABASE_DIR}/${rdir}

    local uuid domain id ip
    local env_dir

    while read uuid domain id ip
    do
	test -n "${ip}" || continue
	env_dir=${dir}/${id}

	setup-configuration-db-files ${env_dir}
    done < ${ABASE_DIR}/${MANAGER_GATEWAY_INDEX}
}

setup-configuration-db()
{
    local env_dir=${ABASE_DIR}/${ENV_RDIR}

    setup-configuration-db-files ${env_dir}

    test ${APL_ROLE} == manager || return 0

    setup-configuration-db-manager-templates
    setup-configuration-db-manager-gateways
}

main()
{
    setup-configuration-db
}

main
