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

gauge-animate()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    test -n "${3}" || return 3
    local var=${1}
    local name=${2}
    local value=${3}

    local timeout=700

    echo "setTimeout( function( ) {"
    echo "${var}.load( {"
    echo "columns: [['${name}', ${value}]]"
    echo "} );"
    echo "}, ${timeout} );"
}

gauge-init()
{
    local id="${1}"
    local name="${2}"
    local value="${3}"
    local gauge_values="${4}"
    local height="${5}"
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    test -n "${3}" || return 3
    test -n "${4}" || return 4
    test -n "${5}" || return 5

    cat << EOT
<script type='application/json' data-init-gauge-chart>
{
EOT
    echo "\"bindto\": \"#${id}\","
    echo "\"data\": {"
    echo "\"columns\": [[\"${name}\", 100.00]],"
    echo "\"type\": \"gauge\""
    echo "},"
    echo "\"color\": {"
    echo "\"pattern\": [\"FireBrick\", \"DarkOrange\", \"Gold\", \"SeaGreen\"],"
    echo "\"threshold\": {"
    echo "\"values\": [${gauge_values}]"
    echo "}"
    echo "},"
    echo "\"size\": {"
    echo "\"height\": ${height}"
    echo "},"
    echo "\"animation\": {"
    echo "\"name\": \"${name}\","
    echo "\"value\": ${value},"
    echo "\"timeout\": 700"
    echo "}"

    cat << EOT
}
</script>
EOT
}

show-cache-report()
{
    local display_time=${1}

    local percent_bar_width=250
    local gauge_cache_var="gauge_cache"
    local gauge_rcache_var="gauge_rcache"
    local cache_id="cache"
    local rcache_id="rcache"
    local cache_name="Used Cache"
    local rcache_name="Used rWeb Cache"

    local gauge_height=150
    local gauge_values="20, 50, 70, 100"
    local bar_width='50%'

    local size=$(get-cache-size)
    local bigsize=$(get-bigcache-size)
    local rsize=$(get-rcache-size)
    local real_mosize=$(get-cache-real-mean-object-sz)
    local ref_mosize=$(get-cache-reference-mean-object-sz)
    local used=$(get-cache-used)
    local rused=$(get-rcache-used)
    local hit=$(get-cache-hit)
    
    local hit_request=${hit/ *}
    local hit_volume=${hit/* }

    size=$(format-number ${size})
    bigsize=$(format-number ${bigsize})
    rsize=$(format-number ${rsize})
    real_mosize=$(format-number ${real_mosize})
    ref_mosize=$(format-number ${ref_mosize})

    local mosize=$(get-external-mean-object-size ${real_mosize} ${ref_mosize})
    mosize=${mosize//KB/ KB}

    test ${display_time} != time || display-appliance-time-table

    echo "<table class='highlight-list'>"
    echo "<tr>"
    echo "<th class='table-header' width='50%'><center>Persistent Cache</center></th>"
    echo "<th class='table-header' width='50%'><center>Persistent rWeb Cache</center></th>"
    echo "</tr>"
    echo "<tr>"
    echo "<td>"
    echo "<center><div id='${cache_id}'></div></center>"
    echo "</td>"
    echo "<td align='center'>"
    echo "<div id='${rcache_id}'></div>"
    echo "</td>"
    echo "</tr>"
    echo "</table>"

    gauge-init "${cache_id}" "${cache_name}" "${used}" "${gauge_values}" "${gauge_height}"
    gauge-init "${rcache_id}" "${rcache_name}" "${rused}" "${gauge_values}" "${gauge_height}"

    echo "<br />"

    echo "<table class='highlight-form'>"

    echo "<tr >"
    echo "<td>"
    echo "Total main cache size"
    echo "</td>"
    echo "<td>"
    echo "${size} MB"
    echo "</td>"
    echo "</tr>"

    echo "<tr>"
    echo "<td>"
    echo "Big objects reserved"
    echo "</td>"
    echo "<td>"
    echo "${bigsize} MB"
    echo "</td>"
    echo "</tr>"

    echo "<tr>"
    echo "<td>"
    echo "rWeb cache size"
    echo "</td>"
    echo "<td>"
    echo "${rsize} MB"
    echo "</td>"
    echo "</tr>"

    echo "<tr>"
    echo "<td>"
    echo "Mean Object Size"
    echo "</td>"
    echo "<td>"
    echo "${mosize}"
    echo "</td>"
    echo "</tr>"

    echo "<tr>"
    echo "<td>"
    echo "Main cache Hit request"
    echo "</td>"
    echo "<td width='${bar_width}'>"
    draw-cache-meter-bar ${hit_request}
    echo "</td>"
    echo "</tr>"

    echo "<tr>"
    echo "<td>"
    echo "Main cache Hit volume"
    echo "</td>"
    echo "<td width='${bar_width}'>"
    draw-cache-meter-bar ${hit_volume}
    echo "</td>"
    echo "</tr>"
    echo "</table>"
}
