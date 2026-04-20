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

show-system-report-connection()
{
    test -s ${RUN_DIR}/${CONNECTION_FILENAME} || return 0
    test -s ${RUN_DIR}/${CONNECTION_SUMMARY_FILENAME} || return 0
    
    local display_time=${1}
    local table_width=${2}
    test -n "${table_width}" || table_width="405"
    local dev connection
    local ip

    echo "<div class='core-form'>"

    if test -n "${display_time}" ; then
	echo "<table class='highlight-form' style='margin-bottom:5px;' width='${table_width}'>"
	display-appliance-time-row right
	echo "</table>"
    fi

    echo "<table class='highlight-list' width='${table_width}'>"

    echo "<thead>"
    echo "<tr>"
    echo "<td class='table-header indicator-table-header' width='50%' align='center'>Interface</td>"
    echo "<td class='table-header' width='50%' align='center'>Active TCP Connections</td>"
    echo "</tr>"
    echo "</thead>"

    echo "<tbody>"

    local dev connection interface

    if test -f ${RUN_DIR}/${CONNECTION_FILENAME} ; then
	while read dev connection
	do
	    test -n "${dev}" || continue
	    test -n "${connection}" || connection=0
	    interface=$(get-logical-interface ${dev})
	    test ${interface} != 'auxiliary' || continue
	    echo "<tr>"
	    echo "<td align='center'>${interface}</td>"
	    echo "<td align='center'>${connection}</td>"
	    echo "</tr>"
	done < ${RUN_DIR}/${CONNECTION_FILENAME}
    fi

    echo "</tbody>"
    echo "</table>"

    if test -f ${RUN_DIR}/${CONNECTION_SUMMARY_FILENAME} ; then
	local all=$(cat ${RUN_DIR}/${CONNECTION_SUMMARY_FILENAME})
    else
	all=0
    fi

    echo "<table class='highlight-list' style='margin-top:1px;' width='${table_width}'>"
    echo "<thead>"
    echo "<tr>"
    echo "<td class='table-header indicator-table-header' width='50%' align='center'>Interface</td>"
    echo "<td class='table-header' width='50%' align='center'>All TCP Connections</td>"
    echo "</tr>"
    echo "</thead>"

    echo "<tbody>"

    echo "<tr><td align='center'><i>all interfaces</i></td><td align='center'>${all}</td></tr>"
    echo "</tbody>"
    echo "</table>"
    echo "</div>"
}
