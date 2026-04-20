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

show-system-report-raid()
{
    local display_time=${1}
    local table_width=${2}
    test -n "${table_width}" || table_width="405"

    if test ! -s ${RUN_DIR}/${RAID_HEALTH_FILENAME} ; then
        echo "<div class='core-form'>"
	echo-content-unavailable ${table_width} "This system has been installed without RAID support."
        echo "</div>"
        return 0
    fi

    local key value

    echo "<div class='core-form'>"
    echo "<table class='highlight-form' width='${table_width}'>"

    test -z "${display_time}" || display-appliance-time-row

    while read key value
    do
	case ${key} in
	    Raid_State)
		case "${value}" in
		    clean|active)
			value="<img src='/image/ok.png' title='OK' alt='[OK]' /> [${value}]"
			;;
		    *)
			value="<img src='/image/ko.png' title='KO' alt='[KO]' /> [${value}]"
			;;
		esac
		;;
	    Build_Status)
		value="<div id='status'></div><script type='text/javascript'>drawPercentBar( 'status', ${PERCENT_BAR_WIDTH}, ${value} );</script>"
		;;
	    *)
		;;
	esac

	echo "<tr>"
	echo "<td width='35%'>${key//_/ }</td>"
	echo "<td width='65%'>${value}</td>"
	echo "</tr>"

    done < ${RUN_DIR}/${RAID_HEALTH_FILENAME}

    echo "</table>"
    echo "</div>"
}
