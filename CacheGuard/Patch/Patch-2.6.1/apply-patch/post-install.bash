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

clean-old-httpd-conf-tuned()
{
    rm -f ${CONF_DIR}/{httpd-noproxy.conf-tuned,httpd-proxy.conf-tuned,httpd-proxy.conf-cache-tuned}
}

reset-dashboard-layout()
{
    local users=$(ls -1 ${ADMIN_DIR}/home 2> /dev/null)
    local user

    for user in ${users}
    do
	test ${user} != "lost+found" || continue
	echo -n > ${ADMIN_DIR}/home/${user}/${ENV_RDIR}/dashboard-layout
    done
}

fix-manager-gateway-tmp-ownership()
{
    mkdir -p ${TMP_GATEWAY_DIR}
    chown -R ${ADMIN_NAME}:${GROUP_NAME} ${TMP_GATEWAY_DIR}

    test -s ${ABASE_DIR}/${MANAGER_GATEWAY_INDEX} || return 0

    local rdir=${MANAGER_GATEWAY_RDIR}
    local dir=${ABASE_DIR}/${rdir}

    local uuid domain id ip

    while read uuid domain id ip
    do
	test -n "${ip}" || continue

	mkdir -p ${TMP_GATEWAY_DIR}/${id}
	chown -R ${ADMIN_NAME}:${GROUP_NAME} ${TMP_GATEWAY_DIR}/${id}

    done < ${ABASE_DIR}/${MANAGER_GATEWAY_INDEX}
}

fix-manager-template-tmp-ownership()
{
    mkdir -p ${TMP_TEMPLATE_DIR}
    chown -R ${ADMIN_NAME}:${GROUP_NAME} ${TMP_TEMPLATE_DIR}

    local rdir=${MANAGER_TEMPLATE_RDIR}
    local dir=${ABASE_DIR}/${rdir}
    local templates=$(ls -1 ${dir} 2> /dev/null)

    test -n "${templates}" || return 0

    local id

    for id in ${templates}
    do
	mkdir -p ${TMP_TEMPLATE_DIR}/${id}
	chown -R ${ADMIN_NAME}:${GROUP_NAME} ${TMP_TEMPLATE_DIR}/${id}
    done

    test ! -d ${TMP_GATEWAY_DIR} || chown -R ${ADMIN_NAME} ${TMP_GATEWAY_DIR}
}

rename-ad-account-passwd()
{
    test -f ${ADMIN_DIR}${PRIVATE_DIR}/.kerberos.passwd || return 0

    mv -f \
       ${ADMIN_DIR}${PRIVATE_DIR}/.kerberos.passwd \
       ${ADMIN_DIR}${PRIVATE_DIR}/.ad-account.passwd
}

build-template-hardware-conf()
{
    local rdir=${MANAGER_TEMPLATE_RDIR}
    local dir=${ABASE_DIR}/${rdir}
    local templates=$(ls -1 ${dir} 2> /dev/null)

    test -n "${templates}" || return 0

    local id

    for id in ${templates}
    do
	test ! -d ${dir}/${id}/${HARD_DIR_NAME} || continue
	cp -a --no-preserve=ownership ${ADMIN_DIR}/${HARD_DIR_NAME} ${dir}/${id}
	chown -R ${ADMIN_NAME}:${GROUP_NAME} ${dir}/${id}
    done
}

main()
{
    clean-old-httpd-conf-tuned
    reset-dashboard-layout

    if test ${APL_ROLE} == gateway ; then
	rename-ad-account-passwd
	return 0
    fi

    fix-manager-gateway-tmp-ownership
    fix-manager-template-tmp-ownership

    build-template-hardware-conf
}

main
