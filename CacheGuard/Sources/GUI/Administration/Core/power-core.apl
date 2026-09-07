#!/bin/bash

###########################################################################
#
# MODULE:       GUI
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

show-power-state-radio-buttons()
{
    test -n "${1}" || return 1
    local id=${1}

    local i=0 n operationT stateT titleT
    declare -a  operationT stateT titleT

    operationT[${i}]="reboot" ; stateT[${i}]="" ; titleT[${i}]="Reboot" ; ((i++))
    operationT[${i}]="halt" ; stateT[${i}]="" ; titleT[${i}]="Power Off" ; ((i++))
    operationT[${i}]="ha-active" ; stateT[${i}]="" ; titleT[${i}]="HA Node On" ; ((i++))
    operationT[${i}]="ha-failover" ; stateT[${i}]="" ; titleT[${i}]="HA Node Off" ; ((i++))
    ((n = i))
    
    if test "${CURRENT_HA_MODE}" == False ; then
	for ((i=2 ; i<n ; i++))
	do
	    stateT[${i}]="disabled "
	    titleT[${i}]="<span class='unavailable-item'>${titleT[${i}]}</span>"
	done
    fi

    echo "<table class='highlight-form' width='300'>"
    for ((i=0 ; i<n ; i++))
    do
	echo "<tr>"
	echo "<td height='20' width='90%'><label for='${operationT[${i}]}'>${titleT[${i}]}</label></td>"
	echo "<td height='20' align='right'><input ${stateT[${i}]}type='radio' name='${id}' id='${operationT[${i}]}' value='${operationT[${i}]}' /></td>"
	echo "</tr>"
    done
    echo "</table>"
}

show-power-form()
{
    local state
    test "${REMOTE_USER}" == "${ADMIN_NAME}" || state=disabled

    show-title "Reboot | Halt | HA State" "${state}" "ha mode reboot halt"

    echo "<div class='core-form'>"
    show-form-begin
    show-power-state-radio-buttons operation
    show-do ${state}
    show-form-end
    echo "</div>"
}

# Main()

show-power-form
