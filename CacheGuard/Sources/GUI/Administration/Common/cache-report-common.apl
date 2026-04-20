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

show-cache-report()
{
    local display_time=${1}
    local table_width=${2}
    test -n "${table_width}" || table_width="450"

    local percent_bar_width=$((PERCENT_BAR_WIDTH + 70))
    local gauge_cache_var="gauge_cache"
    local gauge_rcache_var="gauge_rcache"
    local cache_id="cache"
    local rcache_id="rcache"
    local cache_name="Used Cache"
    local rcache_name="Used rWeb Cache"
    local gauge_width=225

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

    echo "<div class='core-form'>"

    if test -n "${display_time}" ; then
	echo "<table class='highlight-form' style='margin-bottom:5px;' width='${table_width}'>"
	display-appliance-time-row right
	echo "</table>"
    fi

    echo "<table>"
    echo "<tr>"
    echo "<td class='table-header' style='line-height:25px;'><center>Persistent Cache</center></td>"
    echo "<td class='table-header' style='line-height:25px;'><center>Persistent rWeb Cache</center></td>"
    echo "</tr>"
    echo "<tr>"
    echo "<td>"
    echo "<div id='${cache_id}' style='float:left; width:${gauge_width}px; margin:0; padding:0;'></div>"
    echo "</td>"
    echo "<td>"
    echo "<div id='${rcache_id}' style='float:left; width:${gauge_width}px; margin:0; padding:0;'></div>"
    echo "</td>"
    echo "</tr>"
    echo "</table>"

    echo "<br />"

    echo "<script type='text/javascript'>"

    echo "var ${gauge_cache_var} = c3.generate( {"
    echo "bindto: '#${cache_id}',"
    echo "data: {"
    echo "columns: ["
    echo "['${cache_name}', 100.00]"
    echo "],"
    echo "type: 'gauge',"
    echo "onclick: function (d, i) { console.log( 'onclick', d, i ); },"
    echo "onmouseover: function (d, i) { console.log( 'onmouseover', d, i ); },"
    echo "onmouseout: function (d, i) { console.log( 'onmouseout', d, i ); }"
    echo "},"
    echo "color: {"
    echo "pattern: ['FireBrick', 'DarkOrange', 'Gold', 'SeaGreen'],"
    echo "threshold: {"
    echo "values: [20, 50, 70, 100]"
    echo "}"
    echo "},"
    echo "size: {"
    echo "height: 110"
    echo "}"
    echo "} );"
    gauge-animate ${gauge_cache_var} "${cache_name}" ${used}

    echo "var ${gauge_rcache_var} = c3.generate( {"
    echo "bindto: '#${rcache_id}',"
    echo "data: {"
    echo "columns: ["
    echo "['${rcache_name}', 100.00]"
    echo "],"
    echo "type: 'gauge',"
    echo "onclick: function (d, i) { console.log( 'onclick', d, i ); },"
    echo "onmouseover: function (d, i) { console.log( 'onmouseover', d, i ); },"
    echo "onmouseout: function (d, i) { console.log( 'onmouseout', d, i ); }"
    echo "},"
    echo "color: {"
    echo "pattern: ['FireBrick', 'DarkOrange', 'Gold', 'SeaGreen'],"
    echo "threshold: {"
    echo "values: [20, 50, 70, 100]"
    echo "}"
    echo "},"
    echo "size: {"
    echo "height: 110"
    echo "}"
    echo "} );"
    gauge-animate ${gauge_rcache_var} "${rcache_name}" ${rused}

    echo "</script>"

    echo "<table class='highlight-form' width='${table_width}'>"

    echo "<tr >"
    echo "<td width='40'>"
    echo "Total main cache size"
    echo "</td>"
    echo "<td width='60%'>"
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
    echo "<td>"
    echo "<div id='hit_request'></div>"
    echo "<script type='text/javascript'>"
    echo "drawPercentBar( 'hit_request', ${percent_bar_width}, ${hit_request} );"
    echo "</script>"
    echo "</td>"
    echo "</tr>"

    echo "<tr>"
    echo "<td>"
    echo "Main cache Hit volume"
    echo "</td>"
    echo "<td>"
    echo "<div id='hit_volume'></div>"
    echo "<script type='text/javascript'>"
    echo "drawPercentBar( 'hit_volume', ${percent_bar_width}, ${hit_volume} );"
    echo "</script>"
    echo "</td>"
    echo "</tr>"
    echo "</table>"

    echo "</div>"
}
