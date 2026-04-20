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

    local log=/var/log/${WAF_LOG}

    if test ! -s "${log}" ; then
	echo "<div style='font-style:italic;'>&lt;The WAF log is empty&gt;</div>"
	return 0
    fi

    local time machine process ip modsecurity_tag rest
    local previous_rest id msg severity hostname
    local attack

    local detected_msg=" Detected."
    local detected_msg_len=${#detected_msg}
    local i=0

    local style="style='word-wrap:break-word;'"

    echo "<table class='highlight-list' width:100%;'>"
    echo "<thead>"
    echo "<tr>"
    echo "<td class='table-header'><strong>Date</strong></td>"
    echo "<td class='table-header'><strong>Client IP</strong></td>"
    echo "<td class='table-header'><strong>Website</strong></td>"
    echo "<td class='table-header'><strong>ID</strong></td>"
    echo "<td class='table-header'><strong>Severity</strong></td>"
    echo "<td class='table-header'><strong>Attack</strong></td>"
    echo "</tr>"
    echo "</thead>"
    
    echo "<tbody>"

    tac ${log} | while read time machine process ip modsecurity_tag rest
    do
	test ${i} -lt ${number} || break

	rest=${rest/*\[id \"}
	id=${rest/\"\]*}

	rest=${rest/*\[msg \"}
	msg=${rest/\"\]*}

	previous_rest=${rest}
	rest=${rest/*\[severity \"}
	if test "${rest}" == "${previous_rest}" ; then
	    severity='<center>-</center>'
	else
	    severity=${rest/\"\]*}
	fi

	rest=${rest/*\[hostname \"}
	hostname=${rest/\"\]*}
	
	echo "<tr>"
	echo "<td><span ${style}>${time}</span></td>"
	echo "<td><span ${style}>${ip}</span></td>"
	echo "<td><span ${style}>${hostname}</span></td>"
        echo "<td><span ${style}>${id}</span></td>"
        echo "<td><span ${style}>${severity}</span></td>"
	echo "<td><span ${style}>${msg}</span></td>"
	echo "</tr>"
	((i++))
    done
    
    echo "</tbody>"
    echo "</table>"
}

# Main()

gui-run-authentication
show-log "${@}"
