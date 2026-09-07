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

show-ip-neighbour()
{
    local line
    local tmp_file=/tmp/ip-neighbour.${$}

    execute-command-with-output "ip neighbour" > ${tmp_file}

    echo "<table class='highlight-report'>"

    echo "<thead><tr>"
    echo "<th class='table-header'>CLI</th>"
    echo "<th class='table-header'>IP</th>"
    echo "<th class='table-header'>NIC</th>"
    echo "<th class='table-header'>MAC Address</th>"
    echo "</tr></thead>"

    echo "<tbody>"

    while read line
    do
	echo "<tr>${line}</tr>"
    done < ${tmp_file}

    echo "</tbody>"
    echo "</table>"

    rm -f ${tmp_file}
}

LOG=/dev/null
gui-run-authentication
show-ip-neighbour "${@}"
