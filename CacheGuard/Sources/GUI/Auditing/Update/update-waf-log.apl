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

    local log=/var/log/${WAF_LOG}

    if test ! -s "${log}" ; then
	echo-unavailable-message "the WAF log is empty."
	return 0
    fi

    local rfc3339_time machine process ip modsecurity_tag rest
    local date_time date time
    local previous_rest id msg severity hostname
    local attack

    local detected_msg=" Detected."
    local detected_msg_len=${#detected_msg}
    local i=0

    echo "<table class='highlight-log'>"
    echo "<thead>"
    echo "<tr>"
    echo "<th class='table-header'><strong>Date</strong></th>"
    echo "<th class='table-header'><strong>Time</strong></th>"
    echo "<th class='table-header'><strong>Client IP</strong></th>"
    echo "<th class='table-header'><strong>Website</strong></th>"
    echo "<th class='table-header'><strong>ID</strong></th>"
    echo "<th class='table-header'><strong>Severity</strong></th>"
    echo "<th class='table-header'><strong>Attack</strong></th>"
    echo "</tr>"
    echo "</thead>"
    
    echo "<tbody>"

    tac ${log} | while read rfc3339_time machine process ip modsecurity_tag rest
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

	date_time=$(gui-get-date-time "${rfc3339_time}")
	date=${date_time/@*}
	time=${date_time/*@}

	echo "<tr>"
	echo "<td><span>${date}</span></td>"
	echo "<td><span>${time}</span></td>"
	echo "<td><span>${ip}</span></td>"
	echo "<td><span>${hostname}</span></td>"
        echo "<td><span>${id}</span></td>"
        echo "<td><span>${severity}</span></td>"
	echo "<td><span>${msg}</span></td>"
	echo "</tr>"
	((i++))
    done
    
    echo "</tbody>"
    echo "</table>"
}

# Main()

gui-run-authentication
show-log "${@}"
