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

show-log()
{
    test -n "${1}" || return 1
    local number=${1}

    [[ "${number}" =~ (^[1-9][0-9]{0,10}|^0)$ ]] || return 2
    test ${number} -le 1000 || return 3

    local log=/var/log/${ACCESS_GUARD_LOG}

    if test ! -s "${log}" ; then
	echo "<div style='font-style:italic;'>&lt;The denied URLs log is empty&gt;</div>"
	return 0
    fi

    local time code req url ip user method rest
    local i=0
    local style="style='word-wrap:break-word;'"

    echo "<table class='highlight-list' width:100%;'>"
    echo "<thead>"
    echo "<tr>"
    echo "<td class='table-header'><strong>Date</strong></td>"
    echo "<td class='table-header'><strong>Client IP</strong></td>"
    echo "<td class='table-header'><strong>Auth User</strong></td>"
    echo "<td class='table-header'><strong>Category</strong></td>"
    echo "<td class='table-header'><strong>URL</strong></td>"
    echo "</tr>"
    echo "</thead>"
    
    echo "<tbody>"

    tac ${log} | while read time code req url ip user method rest
    do
	test ${i} -lt ${number} || break
	req=${req/Request(/}
	req=${req/\/-)/}
	req=${req/*\//}
	echo "<tr>"
	echo "<td><span ${style}>${date} ${time}</span></td>"
	echo "<td><span ${style}>${ip/\/*/}</span></td>"
	echo "<td><span ${style}>${user}</span></td>"
        echo "<td><span ${style}>${req}</span></td>"
        echo "<td><span ${style}>${url}</span></td>"
	echo "</tr>"
	((i++))
    done
    
    echo "</tbody>"
    echo "</table>"
}

# Main()

gui-run-authentication
show-log "${@}"
