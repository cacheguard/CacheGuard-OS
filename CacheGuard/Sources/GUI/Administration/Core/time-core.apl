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

show-time-form()
{
    local width
    local left=35
    local right=65
    local length=7

    local date_std=$(/bin/date --utc 2> /dev/null)
    local date_seconds=$(/bin/date --set="${date_std}" +"%s" 2> /dev/null)
    local date_formatted=$(/bin/date --set="${date_std}" +"%Y/%m/%d-%T" 2> /dev/null)
    local date_zone=$(/bin/date +"%z" 2> /dev/null)

    local date_offset_sens=${date_zone:0:1}
    local date_zone_hours=${date_zone:1:2}
    local date_zone_minutes=${date_zone:3:2}
    local date_offest_minutes=$[${date_zone_hours} * 60 + ${date_zone_minutes}]
    local date_offest_mn="${date_offset_sens}${date_offest_minutes}"

    local time=${date_formatted/*-}
    local date=${date_formatted/-*}

    local year=${date:0:4}
    local month=${date:5:2}
    local day=${date:8:2}
    local hours=${time:0:2}
    local minutes=${time:3:2}
    local seconds=${time:6:2}

    local time_zone i=0

    echo "<script type='text/javascript' src='/js/localTime.js'></script>"

    show-title "Date & Clock" "enabled" "clock, timezone, timezonelist"

    echo "<div class='core-form'>"
    echo "<div style='font-size:11px; margin:0;margin-bottom:5px;'><span>Appliance time: </span><span id='timecontainer'></span></div>"

    call-js-function "new showLocalTime( 'timecontainer', ${date_seconds}, ${date_offest_mn}, 'short')"

    show-form-begin ${length}
    show-table-begin ${length} ${width}

    echo "<tr><td width='${left}%'>Time Zone</td>"
    echo "<td width='${right}%'><select name='timezone'>"

    while read time_zone
    do
	test -n "${time_zone}" || continue
	if test "${TIMEZONE}" == "${time_zone}" ; then
	    echo -n "<option value='${time_zone}' selected>${time_zone} [${i}]</option>"
	else
	    echo -n "<option value='${time_zone}'>${time_zone} [${i}]</option>"
	fi
	((i++))
    done < /etc/timezones
    echo "</select>"
    echo "</td></tr>"
    
    echo "<tr>"
    echo "<td width='${left}%'>Date</td><td width='${right}%'>"
    echo "<input name='year' id='year' value='${year}' size='4' maxlength='4' onChange='setCalendarDay( \"year\", \"month\", \"day\" );' />"
    echo '/'
    echo "<select name='month' id='month' onChange='setCalendarDay( \"year\", \"month\", \"day\" );'>"
    echo-month-options ${month}
    echo '</select>'
    echo '/'
    echo "<select name='day' id='day'>"
    echo-month-day-options ${year} ${month} ${day}
    echo '</select>'
    echo "</td></tr>"
    
    echo "<tr>"
    echo "<td width='${left}%'>Time</td>"
    
    echo "<td width='${right}%'>"
    echo "<select name='hours' id='hours'>"
    echo-hour-options ${hours}
    echo '</select>'
    echo ':'
    echo "<select name='minutes' id='minutes'>"
    echo-minute-options ${minutes}
    echo '</select>'
    echo ':'
    echo "<select name='seconds' id='seconds'>"
    echo-minute-options ${seconds}
    echo '</select>'
    echo "</td></tr>"
    
    echo "<tr>"
    echo "<td width='${left}%'>NTP</td>"
    echo "<td width='${right}%'><span class='shortcut-menu-item' style='font-size:100%;'><a href=/${GUI_DIR_NAME}/ntp.${GUI_EXT_NAME}>Netwrok Time Servers</a></span></td>"
    echo "</tr>"
    
    show-table-end ${length}
    show-do enabled disabled
    show-form-end

    echo "</div>"
}

# Main()

show-time-form
