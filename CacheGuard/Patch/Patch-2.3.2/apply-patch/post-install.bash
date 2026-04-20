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

restore-deleted-files()
{
    cp -af /root/${SYSTEM_CA_ID}.certificate ${WEB_SSL_CA_DIR} || return 11
    cp -af /root/${EMBEDDED_VPNSUBSCR_NAME}.db ${WEB_DB_DIR}/${EMBEDDED_APPLICATIONS_NAME} || return 13

    rm -f \
       /root/${SYSTEM_CA_ID}.certificate \
       /root/${EMBEDDED_VPNSUBSCR_NAME}.db
}

main()
{
    restore-deleted-files
}

main
