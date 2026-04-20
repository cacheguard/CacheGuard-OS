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

show-manager-sync-report()
{
    local table_width=${1}
    test -n "${table_width}" || table_width="405"

    echo "<div class='core-form'>"

    case ${APL_ROLE} in
	gateway)
	    echo-content-unavailable ${table_width} "<i>This report is not available on a Gateway system.</i>"
	    return 0
	    ;;
	manager)
	    case ${CURRENT_MANAGER_SYNC_ROLE} in
		alone)
		    echo-content-unavailable ${table_width} "<i>This report is not available on a stand alone Manager system.</i>"
		    return 0
		    ;;
		slave)
		    echo-content-unavailable ${table_width} "<i>This report is not available on a slave Manager system.</i>"
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

    echo "<table class='highlight-list' width='${table_width}'>"

    echo "<thead>"
    echo "<tr>"
    echo "<td width='80%' class='table-header indicator-table-header' align='center'>Service</td>"
    echo "<td width='20%' class='table-header' align='center'>State</td>"
    echo "</tr>"
    echo "</thead>"

    echo "<tbody>"

    local update_files=$(ls -1 ${MANAGER_SYNC_FILE}.* 2> /dev/null)

    local seconds date status

    if test -z "${update_files}" ; then

	seconds=$(date +"%s" 2> /dev/null)
	date=$(get-date-from-epoch-seconds ${seconds})
	status="OK"
	show-log-line 0 ${date} No data to Synchronise with the Peer manager[${status}]

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
    echo "</div>"
}
