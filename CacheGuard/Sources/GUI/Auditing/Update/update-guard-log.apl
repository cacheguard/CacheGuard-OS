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

source functions

show-log()
{
    test -n "${1}" || return 1
    local number=${1}

    [[ "${number}" =~ (^[1-9][0-9]{0,10}|^0)$ ]] || return 2
    test ${number} -le 1000 || return 3

    local log=/var/log/${ACCESS_GUARD_LOG}

    if test ! -s "${log}" ; then
	echo-unavailable-message "the denied URLs log is empty."
	return 0
    fi

    local time code req url ip user method rest
    local i=0

    echo "<table class='highlight-log'>"
    echo "<thead>"
    echo "<tr>"
    echo "<th class='table-header'><strong>Date</strong></th>"
    echo "<th class='table-header'><strong>Time</strong></th>"
    echo "<th class='table-header'><strong>Client IP</strong></th>"
    echo "<th class='table-header'><strong>Auth User</strong></th>"
    echo "<th class='table-header'><strong>Category</strong></th>"
    echo "<th class='table-header'><strong>URL</strong></th>"
    echo "</tr>"
    echo "</thead>"
    
    echo "<tbody>"

    tac ${log} | while read date time code req url ip user method rest
    do
	test -n "${method}" || continue
	test ${i} -lt ${number} || break
	req=${req/Request(/}
	req=${req/\/-)/}
	req=${req/*\//}
	echo "<tr>"
	echo "<td><span>${date}</span></td>"
	echo "<td><span>${time}</span></td>"
	echo "<td><span>${ip/\/*/}</span></td>"
	echo "<td><span>${user}</span></td>"
        echo "<td><span>${req}</span></td>"
        echo "<td><span>${url}</span></td>"
	echo "</tr>"
	((i++))
    done
    
    echo "</tbody>"
    echo "</table>"
}

# Main()

gui-run-authentication
show-log "${@}"
