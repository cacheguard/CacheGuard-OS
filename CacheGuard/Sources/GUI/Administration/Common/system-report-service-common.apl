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

show-system-report-service()
{
    test -n "${1}" || return 1
    local display_time=${1}
    local compact=${2}

    test -z "${compact}" || compact=' compact'

    echo "<table class='highlight-list${compact}'>"
    echo "<thead>"
    echo "<tr>"
    echo "<th class='table-header'>Service</th>"
    echo "<th class='table-header'>State</th>"
    echo "</tr>"
    echo "</thead>"

    echo "<tbody>"

    test ${display_time} != time || display-appliance-time-row

    local service flag
    local name

    if test -s ${RUN_DIR}/${SERVICES_STATE_FILENAME} ; then
	while read service flag
	do
	    name=$(get-service-title ${service})
	    test -n "${name}" || continue

            echo "<tr>"
            echo "<td>${name}</td>"

            if test ${flag} -eq 0 ; then
		echo "<td><img class='small' src='/image/ok.png' /></td>"
            else
		echo "<td><img class='small' src='/image/ko.png' title='KO' /></td>"
            fi
            echo "</tr>"
	    
	done < ${RUN_DIR}/${SERVICES_STATE_FILENAME}
    fi

    echo "</tbody>"
    echo "</table>"
}
