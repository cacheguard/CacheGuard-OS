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

show-system-report-service()
{
    local display_time=${1}
    local table_width=${2}
    test -n "${table_width}" || table_width="405"

    echo "<div class='core-form'>"
    echo "<table class='highlight-list' width='${table_width}'>"

    echo "<thead>"
    echo "<tr>"
    echo "<td width='80%' class='table-header indicator-table-header' align='center'>Service</td>"
    echo "<td width='20%' class='table-header' align='center'>State</td>"
    echo "</tr>"
    echo "</thead>"

    echo "<tbody>"

    test -z "${display_time}" || display-appliance-time-row center

    local service flag
    local name

    if test -s ${RUN_DIR}/${SERVICES_STATE_FILENAME} ; then
	while read service flag
	do
	    name=$(get-service-title ${service})
	    test -n "${name}" || continue
	    
            echo "<tr>"
            echo "<td align='left'>${name}</td>"
	    
            if test ${flag} -eq 0 ; then
		echo "<td align='center'><img src='/image/ok.png' /></td>"
            else
		echo "<td align='center'><img src='/image/ko.png' title='KO' /></td>"
            fi
            echo "</tr>"
	    
	done < ${RUN_DIR}/${SERVICES_STATE_FILENAME}
    fi

    echo "</tbody>"
    echo "</table>"
    echo "</div>"
}
