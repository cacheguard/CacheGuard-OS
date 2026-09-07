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

    local log=/var/log/${ANTI_VIRUS_SERVER_LOG}

    if test ! -s "${log}" ; then
	echo-unavailable-message "<i>the blocked malware log is empty.</i>"
	return 0
    fi

    local rfc3339_time hostname program stream_ip virus found
    local date_time date time
    local ip i=0

    echo "<table class='highlight-log'>"
    echo "<thead>"
    echo "<tr>"
    echo "<th class='table-header'><strong>Date</strong></th>"
    echo "<th class='table-header'><strong>Time</strong></th>"
    echo "<th class='table-header'><strong>Client IP</strong></th>"
    echo "<th class='table-header'><strong>Virus Name</strong></th>"
    echo "</tr>"
    echo "</thead>"

    echo "<tbody>"

    tac ${log} | while read rfc3339_time hostname program stream_ip virus found
    do
	test ${i} -lt ${number} || break
	test -n "${found}" || continue

	ip=${stream_ip/instream\(}
	ip=${ip/@*}

	date_time=$(gui-get-date-time "${rfc3339_time}")
	date=${date_time/@*}
	time=${date_time/*@}

	test ${ip} != '127.0.0.1' || ip='<center>-</center>'
	echo "<tr>"
	echo "<td><span>${date}</span></td>"
	echo "<td><span>${time}</span></td>"
	echo "<td><span>${ip}</span></td>"
	echo "<td><span>${virus}</span></td>"
	echo "</tr>"
	((i++))
    done

    echo "</tbody>"
    echo "</table>"
}

# Main()

gui-run-authentication
show-log "${@}"
