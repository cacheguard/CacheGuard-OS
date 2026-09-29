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

show-system-report-gateway()
{
    test -n "${1}" || return 1
    local display_time=${1}
    local compact=${2}

    if test ! -s ${RUN_DIR}/${GATEWAYS_STATE_FILENAME} ; then
	echo "<div class='core-form'>"
	echo-unavailable-message "the gateway health monitoring is not available."
        echo "</div>"
	return 0
    fi

    test ${display_time} != time || display-appliance-time-table ${compact}
    test -z "${compact}" || compact=' compact'

    echo "<table class='highlight-list${compact}'>"

    echo "<thead>"
    echo "<tr>"
    echo "<th class='table-header' align='center'>Gateway</th>"
    echo "<th class='table-header' align='center'>NIC</th>"
    echo "<th class='table-header' align='center'>Pinged</th>"
    echo "<th class='table-header' align='center'>State</th>"
    echo "</tr>"
    echo "</thead>"

    echo "<tbody>"

    local dev_gateway_health
    local dev gateway health

    local state

    while read dev_gateway_health state
    do
	dev=${dev_gateway_health/\/*}
	gateway_health=${dev_gateway_health#*\/}
	gateway=${gateway_health/\/*}	
	health=${gateway_health/*\/}

        echo "<tr>"
        echo "<td align='left'>${gateway}</td>"
        echo "<td align='center'>${dev}</td>"
        echo "<td align='left'>${health}</td>"

        if test "${state}" == OK ; then
            echo "<td align='center'><img class='small' src='/image/ok.png' /></td>"
        else
            echo "<td align='center'><img class='small' src='/image/ko.png' title='Unreachable' /></td>"
        fi

        echo "</tr>"

    done < ${RUN_DIR}/${GATEWAYS_STATE_FILENAME}

    echo "</tbody>"
    echo "</table>"
}
