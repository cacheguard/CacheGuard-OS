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

show-system-report-raid()
{
    test -n "${1}" || return 1
    local display_time=${1}
    local compact=${2}

    if test ! -s ${RUN_DIR}/${RAID_HEALTH_FILENAME} ; then
	test -n "${compact}" || echo-unavailable-message "this system has been installed without RAID."
        return 0
    fi

    local key value

    test -z "${compact}" || compact=' compact'

    echo "<table class='highlight-form${compact}'>"
    test ${display_time} != time || display-appliance-time-row left

    while read key value
    do
	case ${key} in
	    Raid_State)
		case "${value}" in
		    clean|active)
			value="<img class='small' src='/image/ok.png' title='OK' alt='[OK]' />[${value}]"
			;;
		    *)
			value="<img class='small' src='/image/ko.png' title='KO' alt='[KO]' />[${value}]"
			;;
		esac
		;;
	    Build_Status)
		value=$(draw-progress-bar ${value})
		;;
	    *)
		;;
	esac

	echo "<tr>"
	echo "<td width='50%'>${key//_/ }</td>"
	echo "<td width='50%'>${value}</td>"
	echo "</tr>"

    done < ${RUN_DIR}/${RAID_HEALTH_FILENAME}

    echo "</table>"
}
