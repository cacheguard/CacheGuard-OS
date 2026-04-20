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

touch-vpnipsec-log()
{
    test ${APL_ROLE} == gateway || return 0

    touch ${WEB_LOG_DIR}/${VPN_IPSEC_LOG}
    chmod 644 ${WEB_LOG_DIR}/${VPN_IPSEC_LOG}
}

patch-os-version-manager-gateways()
{
    test ${APL_ROLE} == manager || return 0
    source /root/apply-patch/PATCH.env
    test "${PATCH_PRE_RELEASE}" == no || return 0

    source ${LOCAL_DIR}/lib/apl_system
    source ${APPLIANCE_DIR}/lib/lib-interface

    update-os-version-manager-gateways ${PATCH_OS_NEW_VERSION}
}

main()
{
    touch-vpnipsec-log
    patch-os-version-manager-gateways
}

main
