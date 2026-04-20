#!/bin/bash

###########################################################################
#
# MODULE:       Patch
# AUTHOR(S):    CacheGuard Development Team
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

delete-dsa-keys()
{
    rm -f \
       /etc/ssh_host_dsa_key \
       /etc/ssh_host_dsa_key.pub \
       ${HARD_DIR}/ssh_host_dsa.fp

    test ${APL_ROLE} == manager || return 0

    test -s ${ABASE_DIR}/${MANAGER_GATEWAY_INDEX} || return 0

    local rdir=${MANAGER_GATEWAY_RDIR}
    local dir=${ABASE_DIR}/${rdir}

    local uuid domain id ip
    local env_dir

    while read uuid domain id ip
    do
	test -n "${ip}" || continue
	env_dir=${dir}/${id}

	rm -f ${env_dir}/${HARD_DIR_NAME}/ssh_host_dsa.fp
    done < ${ABASE_DIR}/${MANAGER_GATEWAY_INDEX}
}

main()
{
    delete-dsa-keys
}

main
