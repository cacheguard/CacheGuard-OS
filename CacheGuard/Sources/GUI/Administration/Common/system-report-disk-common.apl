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

show-system-report-disk()
{
    local display_time=${1}
    local table_width=${2}
    test -n "${table_width}" || table_width="405"

    local col1=180
    local col2=100

    echo "<div class='core-form'>"
    echo "<table class='highlight-form' width='${table_width}'>"

    test -z "${display_time}" || display-appliance-time-row

    if test -s ${RUN_DIR}/${DISKS_HEALTH_FILENAME} ; then

	local disk state lifetime

	while read disk state lifetime
	do
	    echo "<tr>"
	    echo "<td width='${col1}'>Disk SMART (${disk/\/dev\//})</td>"

	    echo "<td width='${col2}'>"

	    if test "${state}" -eq 0 ; then
                echo -n "<img src='/image/ok.png' alt='[OK]' title='OK' />"
            else
                echo -n "<img src='/image/ko.png' alt='[KO]' title='KO' />"
            fi

	    if test -z "${lifetime}" ; then
		echo
	    else
		echo " ${lifetime}% life"
	    fi
	    echo "</td>"

	    echo "</tr>"
	done < ${RUN_DIR}/${DISKS_HEALTH_FILENAME}
    fi

    if test -f ${RUN_DIR}/${DISKS_STATS_IO_FILENAME} ; then
	local io=$(cat ${RUN_DIR}/${DISKS_STATS_IO_FILENAME} 2> /dev/null)
	if test ${io} -eq 0 ; then
	    local avg=0
	else
	    if test -f ${RUN_DIR}/${DISKS_STATS_TIME_IO_FILENAME} ; then
		local time_io=$(cat ${RUN_DIR}/${DISKS_STATS_TIME_IO_FILENAME} 2> /dev/null)
		local avg=$[${time_io} / ${io}]
	    else
		local avg=0
	    fi
	fi

	echo "<tr>"
	echo "<td width='${col1}'>"
	echo "Disk(s) average i/o time"
	echo "</td>"
	echo "<td width='${col2}'>"
	echo "${avg} millisecond"
	echo "</td>"
	echo "</tr>"
    fi

    local check_interval

    if test -f ${RUN_DIR}/${DISKS_STATS_AVG_FILENAME}.date1 -a -f ${RUN_DIR}/${DISKS_STATS_AVG_FILENAME}.date2 ; then
	local date1=$(cat ${RUN_DIR}/${DISKS_STATS_AVG_FILENAME}.date1 2> /dev/null)
	local date2=$(cat ${RUN_DIR}/${DISKS_STATS_AVG_FILENAME}.date2 2> /dev/null)
	((check_interval = date2 - date1))
    else
	check_interval=0
    fi

    if test -f ${RUN_DIR}/${DISKS_STATS_AVG_FILENAME} ; then
	local last_check_date=$(cat ${RUN_DIR}/${DISKS_STATS_AVG_FILENAME}.lasttime 2> /dev/null)
	local avg_rel=$(cat ${RUN_DIR}/${DISKS_STATS_AVG_FILENAME} 2> /dev/null)
	echo "<tr>"
	echo "<td>"
	echo "Disk(s) average i/o time in ${check_interval} seconds"
	echo "</td>"
	echo "<td>"
	echo "${avg_rel} millisecond"
	echo "</td>"
	echo "</tr>"
    fi

    echo "</table>"
    echo "</div>"
}
