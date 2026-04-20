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

clear-new-tls()
{
    rm -f ${TMP_DIR}/${SYSTEM_CA}.conf
    rm -f ${TMP_DIR}/${TLS_SERVER}.*.{conf,2sign}

    test ${APL_ROLE} == manager || return 0

    rm -f ${TMP_TEMPLATE_DIR}/*/${SYSTEM_CA}.conf
    rm -f ${TMP_TEMPLATE_DIR}/*/${TLS_SERVER}.*.{conf,2sign}

    rm -f ${TMP_GATEWAY_DIR}/*/${SYSTEM_CA}.conf
    rm -f ${TMP_GATEWAY_DIR}/*/${TLS_SERVER}.*.{conf,2sign}
}

main()
{
    rm -f /etc/ntp/driftfile
    clear-new-tls
}

main
