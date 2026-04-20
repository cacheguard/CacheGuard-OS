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
source ${APPLIANCE_DIR}/lib/lib-check

send-ping()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    local machine=${1}
    local width=${2}

    if ! check-domainname "${machine}" ; then
	echo "<div class='with-border' style='font-size:90%; font-style:italic; color:red; width:${width}px; margin-bottom:5px;'>This is not a valid machine name.</div>"
	return 3
    fi

    echo "<div class='with-border' style='font-size:90%; font-style:italic; width:${width}px; margin-bottom:5px;'>"
    echo "<pre>"
    PATH=/bin ping -w 4 -c 3 -n ${machine} 2>&1
    echo "</pre>"
    echo "</div>"
}

LOG=/dev/null
PING_ARGS=${@//\\\&/ } 
gui-run-authentication
send-ping ${PING_ARGS}
