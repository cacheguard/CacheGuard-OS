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

show-manager-sync-report()
{
    local compact=${1}

    case ${APL_ROLE} in
	gateway)
	    echo-unavailable-message "this report is not available on a Gateway system."
	    return 0
	    ;;
	manager)
	    case ${CURRENT_MANAGER_SYNC_ROLE} in
		alone)
		    echo-unavailable-message "this report is not available on a stand alone Manager system."
		    return 0
		    ;;
		slave)
		    echo-unavailable-message "this report is not available on a slave Manager system."
		    return 0
		    ;;
		master)
		    ;;
		*)
		    return 0
		    ;;
	    esac
	    ;;
	*)
	    return 0
	    ;;
    esac

    test -z "${compact}" || compact=' compact'

    echo "<table class='highlight-list${compact}'>"

    echo "<thead>"
    echo "<tr>"
    echo "<th class='table-header' align='center'>Service</th>"
    echo "<th class='table-header' align='center'>State</th>"
    echo "</tr>"
    echo "</thead>"

    echo "<tbody>"

    local update_files=$(ls -1 ${MANAGER_SYNC_FILE}.* 2> /dev/null)

    local seconds date status

    if test -z "${update_files}" ; then

	seconds=$(date +"%s" 2> /dev/null)
	date=$(get-date-from-epoch-seconds ${seconds})
	status="OK"
	show-log-line 0 ${date} No data to synchronise with the peer manager[${status}]

    else
	local update_file
	local base name title code error_txt

	for update_file in ${update_files}
	do
	    base=$(file-basename ${update_file})
	    name=${base#*\.}

	    title=$(get-manager-sync-title ${name})
	    test -n "${name}" || continue

	    read code seconds < ${update_file}

	    if test ${code} -eq 0 ; then
		status="OK"
		unset error_txt
	    else
		status="KO"
		error_txt=" (${code})"
	    fi

	    date=$(get-date-from-epoch-seconds ${seconds})
	    show-log-line 0 ${date} Synchronising ${title}${error_txt}[${status}]
	done
    fi

    echo "</tbody>"
    echo "</table>"
}
