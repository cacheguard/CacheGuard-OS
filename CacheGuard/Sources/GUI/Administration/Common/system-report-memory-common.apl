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

show-system-report-memory()
{
    test -f /proc/meminfo || return 0

    local display_totals=${1}
    local display_time=${2}
    local table_width=${3}

    test -n "${table_width}" || table_width='405'
    
    local ram_id='ram'
    local swap_id='swap'

    local free_ram_name='Free RAM (MB)'
    local used_ram_name='Used RAM'

    local free_swap_name='Free Swap (MB)'
    local used_swap_name='Used Swap'

    local free_color='SeaGreen'
    local used_color='FireBrick'

    local pie_height=190
    local pie_width=190

    local total=$(cat /proc/meminfo | grep MemTotal:)
    local free=$(cat /proc/meminfo | grep MemFree:)
    local stotal=$(cat /proc/meminfo | grep SwapTotal:)
    local sfree=$(cat /proc/meminfo | grep SwapFree:)

    total=${total/MemTotal:/}
    free=${free/MemFree:/}
    stotal=${stotal/SwapTotal:}
    sfree=${sfree/SwapFree:}

    total=$(echo ${total})
    total=${total/ kB/}
    total=$[${total} / 1024]

    free=$(echo ${free})
    free=${free/ kB/}
    free=$[${free} / 1024]

    stotal=$(echo ${stotal})
    stotal=${stotal/ kB/}
    stotal=$[${stotal} / 1024]

    sfree=$(echo ${sfree})
    sfree=${sfree/ kB/}
    sfree=$[${sfree} / 1024]

    local used=$[${total}-${free}]
    local sused=$[${stotal}-${sfree}]

    local total_formatted=$(format-number ${total})
    local stotal_formatted=$(format-number ${stotal})

    local pused=$[${used} * 100 / ${total}]
    local psused=$[${sused} * 100 / ${stotal}]

    echo "<div class='core-form'>"

    if test -n "${display_totals}" ; then
	echo "<table class='highlight-form' width='${table_width}'>"

	test -z "${display_time}" || display-appliance-time-row

	echo "<tr>"
	echo "<td width='80%'>"
	echo "Total RAM size"
	echo "</td>"
	echo "<td width='20%'>"
	echo "${total_formatted} MB"
	echo "</td>"
	echo "</tr>"

	echo "<tr>"
	echo "<td>"
	echo "Total swap size"
	echo "</td>"
	echo "<td>"
	echo "${stotal_formatted} MB"
	echo "</td>"
	echo "</tr>"

	echo "</table>"
    fi

    echo "<div id='${ram_id}' style='float:left; height:${pie_height}px; width:${pie_width}px; margin:0; padding:0;'></div>"
    echo "<div id='${swap_id}' style='float:left; height:${pie_height}px; width:${pie_width}px; margin:0; padding:0;'></div>"
    echo "<div style='clear:left;'></div>"

    echo "<script type='text/javascript'>"

    echo "var pie_ram = c3.generate( {"
    echo "bindto: '#${ram_id}',"
    echo "data: {"
    echo "columns: ["
    echo "['${free_ram_name}', ${free}],"
    echo "['${used_ram_name}', ${used}]"
    echo "],"
    echo "type: 'pie',"
    echo "colors: {"
    echo "'${free_ram_name}': '${free_color}',"
    echo "'${used_ram_name}': '${used_color}'"
    echo "}"
    echo "},"

    echo "pie: {"
    echo "label: {"
    echo "format: function (value, ratio, id) {"
    echo "return d3.format('^')(value);"
    echo "}"
    echo "}"
    echo "}"

    echo "} );"

    echo "var pie_swap = c3.generate( {"
    echo "bindto: '#${swap_id}',"
    echo "data: {"
    echo "columns: ["
    echo "['${free_swap_name}', ${sfree}],"
    echo "['${used_swap_name}', ${sused}]"
    echo "],"
    echo "type: 'pie',"
    echo "colors: {"
    echo "'${free_swap_name}': '${free_color}',"
    echo "'${used_swap_name}': '${used_color}'"
    echo "}"
    echo "},"

    echo "pie: {"
    echo "label: {"
    echo "format: function (value, ratio, id) {"
    echo "return d3.format('^')(value);"
    echo "}"
    echo "}"
    echo "}"

    echo "} );"

    echo "</script>"

    echo "</div>"
}
