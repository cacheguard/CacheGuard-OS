#!/bin/bash

############################################################################
#
# MODULE:       Patch
# AUTHOR(S):    Afshin Tajvidi, <afshin.tajvidi(at)cacheguard.com>
# COPYRIGHT:    (C) 2002-2015 by the CacheGuard Technologies Limited
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

commit-env-files()
{
    local user

    mv -f /tmp/${ADMIN_NAME}.${ENV_NAME}.patched ${ABASE_DIR}/${ENV_RDIR}/${ENV_NAME}
    mv -f /tmp/${ADMIN_NAME}.${ENV_CURRENT_NAME}.patched ${ABASE_DIR}/${ENV_RDIR}/${ENV_CURRENT_NAME}
    mv -f /tmp/${ADMIN_NAME}.${ENV_CANCEL_NAME}.patched ${ABASE_DIR}/${ENV_RDIR}/${ENV_CANCEL_NAME}

    for user in ${ADMIN_USER_LIST}
    do
	mv -f /tmp/${user}.${ENV_NAME}.patched ${BASE_DIR}/${user}/${ENV_RDIR}/${ENV_NAME}
    done
}

clean-tmp-env-files()
{
    local user

    rm -f \
	/tmp/${ADMIN_NAME}.${ENV_NAME}.patched \
	/tmp/${ADMIN_NAME}.${ENV_CURRENT_NAME}.patched \
	/tmp/${ADMIN_NAME}.${ENV_CANCEL_NAME}.patched

    for user in ${ADMIN_USER_LIST}
    do
	rm -f /tmp/${user}.${ENV_NAME}.patched
    done
}

gen-env-files()
{
    local pattern_rweb_hosts="/RWEB_SITE_HOSTS_LIST=/s/_[1-9][0-9]*/_80&_100/g"
    local pattern_rweb_balancer1="/RWEB_SITE_BALANCER_LIST=/s/ nosticky None/ nosticky None None/g"
    local pattern_rweb_balancer2="/RWEB_SITE_BALANCER_LIST=/s/ sticky / sticky insert /g"

    local env_name env_file user

    for env_name in \
	${ENV_NAME} \
	${ENV_CURRENT_NAME} \
	${ENV_CANCEL_NAME}
    do
	env_file=${ABASE_DIR}/${ENV_RDIR}/${env_name}
	sed \
	    -e "${pattern_rweb_hosts}" \
	    -e "${pattern_rweb_balancer1}" \
	    -e "${pattern_rweb_balancer2}" \
	    ${env_file} > /tmp/${ADMIN_NAME}.${env_name}.patched || return 11
    done

    source ${ABASE_DIR}/${ENV_RDIR}/${ENV_NAME} || return 13

    for user in ${ADMIN_USER_LIST}
    do
	env_file=${BASE_DIR}/${user}/${ENV_RDIR}/${ENV_NAME}
	sed \
	    -e "${pattern_rweb_hosts}" \
	    -e "${pattern_rweb_balancer1}" \
	    -e "${pattern_rweb_balancer2}" \
	    ${env_file} > /tmp/${user}.${ENV_NAME}.patched || return 15
    done
}

main()
{
    gen-env-files &&
    commit-env-files ||
    clean-tmp-env-files
}

# Main()

main
