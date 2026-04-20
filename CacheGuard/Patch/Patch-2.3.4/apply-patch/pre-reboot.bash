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
source ${LOCAL_DIR}/lib/apl_functions
source ${ABASE_DIR}/${ENV_RDIR}/${ENV_NAME}

pre-reboot-lock-os()
{
    local cpu_architecture=$(uname -m 2> /dev/null)

    lock-os ${cpu_architecture} /
}

update-vpnsubscr-constant-php()
{
    test \
	${EMBEDDED_VPNSUBSCR_MODE} == True -a \
	-n "${EMBEDDED_VPNSUBSCR_RWEB_SITE_NAME}" -a \
	-n "${EMBEDDED_VPNSUBSCR_RWEB_TLS_ID}" || return 0

    cd ${CONF_DIR}

    safe-generate gen-embedded-vpnsubscr-php-constant ${EMBEDDED_VPNSUBSCR_NAME}-constant.php

    if test ${?} -eq 0 ; then
	commit-classic-conf &&
	    clean-backup-conf
    else
	restore-classic-conf &&
	    clean-backup-conf
    fi

    chattr-copy \
	${EMBEDDED_VPNSUBSCR_NAME}-constant.php \
	${WEB_SERVER_DIR}/${EMBEDDED_APPLICATIONS_NAME}/${EMBEDDED_VPNSUBSCR_NAME}/constant.php
}

main()
{
    update-vpnsubscr-constant-php
    pre-reboot-lock-os
}

main
