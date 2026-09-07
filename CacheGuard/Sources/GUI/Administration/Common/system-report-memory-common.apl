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

show-system-report-memory()
{
    test -f /proc/meminfo || return 0

    test -n "${1}" || return 1
    test -n "${2}" || return 2
    local details=${1}
    local display_time=${2}
    local compact=${3}

    local ram_id='ram'
    local swap_id='swap'

    local free_ram_name='Free RAM (MB)'
    local used_ram_name='Used RAM'

    local free_swap_name='Free Swap (MB)'
    local used_swap_name='Used Swap'

    local free_color='SeaGreen'
    local used_color='FireBrick'

    local pie_height pie_width

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

    test -z "${compact}" || compact=' compact'

    if test ${details} == total ; then

	pie_height=220

	echo "<table class='highlight-form${compact}'>"
	test ${display_time} != time || display-appliance-time-row left
	echo "<tr>"
	echo "<td width='50%'>"
	echo "Total RAM size"
	echo "</td>"
	echo "<td width='50%'>"
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
	echo "<br />"
    else
	pie_height=170
    fi

    pie_width=${pie_height}

    echo "<table class='chart${compact}'>"
    echo "<tr>"
    echo "<td>"
    echo "<div id='${ram_id}'></div>"
    echo "</td>"
    echo "<td>"
    echo "<div id='${swap_id}'></div>"
    echo "</td>"
    echo "</tr>"
    echo "</table>"

    cat << EOT
<script type='application/json' data-init-memory-pie-chart>
{
EOT
    echo "\"ram\":{"
    echo "\"id\":\"${ram_id}\","
    echo "\"freeName\":\"${free_ram_name}\","
    echo "\"free\":${free},"
    echo "\"usedName\":\"${used_ram_name}\","
    echo "\"used\":${used},"
    echo "\"freeColor\":\"${free_color}\","
    echo "\"usedColor\":\"${used_color}\""
    echo "},"
    echo "\"swap\":{"
    echo "\"id\":\"${swap_id}\","
    echo "\"freeName\":\"${free_swap_name}\","
    echo "\"free\":${sfree},"
    echo "\"usedName\":\"${used_swap_name}\","
    echo "\"used\":${sused},"
    echo "\"freeColor\":\"${free_color}\","
    echo "\"usedColor\":\"${used_color}\""
    echo "},"
    echo "\"height\":${pie_height},"
    echo "\"width\":${pie_width}"

    cat << EOT
}
</script>
EOT
}
