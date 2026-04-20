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

show-system-report-load()
{
    test -f /proc/loadavg || return 0

    local display_time=${1}
    local table_width=${2}
    test -n "${table_width}" || table_width="405"

    local cpu_usage=$(cat /var/run/${CPU_USAGE_FILENAME} 2> /dev/null)
    local load=$(get-system-load) load1 load2 load3

    load1=${load/:*}
    load2=${load#*:} load2=${load2/:*}
    load3=${load/*:}

    test -n "${cpu_usage}" || cpu_usage=0

    echo "<div class='core-form'>"
    echo "<table class='highlight-form' width='${table_width}'>"

    test -z "${display_time}" || display-appliance-time-row

    echo "<tr>"
    echo "<td>"
    echo "CPU usage over ${STATISTICS_INTERVAL} seconds"
    echo "</td>"
    echo "<td>"
    echo "<div id='cpu1'></div>"
    draw-percent-bar ${PERCENT_BAR_WIDTH} ${cpu_usage}
    echo "</td>"
    echo "</tr>"

    echo "<tr>"
    echo "<td>"
    echo "Relative load over 1 minute"
    echo "</td>"
    echo "<td>"
    echo "<div id='cpu1'></div>"
    draw-percent-bar ${PERCENT_BAR_WIDTH} ${load1}
    echo "</td>"
    echo "</tr>"

    echo "<tr>"
    echo "<td>"
    echo "Relative load over 5 minutes"
    echo "</td>"
    echo "<td>"
    echo "<div id='cpu5'></div>"
    draw-percent-bar ${PERCENT_BAR_WIDTH} ${load2}
    echo "</td>"
    echo "</tr>"

    echo "<tr>"
    echo "<td>"
    echo "Relative load over 15 minutes"
    echo "</td>"
    echo "<td>"
    echo "<div id='cpu15'></div>"
    draw-percent-bar ${PERCENT_BAR_WIDTH} ${load3}
    echo "</td>"
    echo "</tr>"

    echo "</table>"
    echo "</div>"
}
