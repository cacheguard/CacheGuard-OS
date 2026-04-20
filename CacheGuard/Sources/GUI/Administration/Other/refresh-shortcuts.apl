#!/bin/bash

###########################################################################
#
# MODULE:       GUI
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

source functions

echo-shortcut-state()
{
    local apply_bstate=0
    local cancel_bstate=0
    local kerberos_bstate=0
    local ha_bstate=0
    local exchange_bstate=0
    local lock_bstate=0

    local ha_state=$(get-ha-state)
    check-lock
    local lock_state=${?}

    if quick-conf-modified ; then apply_bstate=1 ; cancel_bstate=2 ; fi
    test ! -f ${TMP_DIR}/${KERBEROS_CREATE_FILENAME} || kerberos_bstate=4
    test ${ha_state} != failover || ha_bstate=8
    ! check-exchanging || exchange_bstate=16
    test ${lock_state} -eq 0 || lock_bstate=32

    local state=$[${apply_bstate} + ${cancel_bstate} + ${kerberos_bstate} + ${ha_bstate} +  ${exchange_bstate} + ${lock_bstate}]
    echo -n "${state}:${lock_state}"
}

main()
{
    gui-run-authentication
    echo-shortcut-state
}

main
