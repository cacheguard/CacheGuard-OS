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

show-file-exchange-table()
{
    local table_width=500

    local file progress base i=0
    local urllist prefix len
    local bar

    echo "<table class='highlight-list' width='${table_width}'>"
    echo "<thead>"
    echo "<tr>"
    echo "<td class='table-header indicator-table-header' align='center'>Content</td>"
    echo "<td class='table-header indicator-table-header' align='center'>Action</td>"
    echo "<td class='table-header' width='${PERCENT_BAR_WIDTH}' align='center'>Progression</td>"
    echo "</tr>"
    echo "</thead>"

    echo "<tbody>"

    local exchanging_files=$(ls -1tr ${TMP_DIR}/*.${PROGRESS} 2> /dev/null)

    for file in ${exchanging_files}
    do
	base=$(file-basename ${file})
	progress=$(echo-exchanged-file-percent "${base}")
	test "${progress}" != '100' || continue
	base=$(file-basename ${base} .${PROGRESS})
	bar=$(draw-percent-bar ${PERCENT_BAR_WIDTH} ${progress})

	echo -n "<tr>"

	case "${base}" in
	    ${SAVED}.backup)
		echo "<td align='left'>System Backup</td><td align='center'>Saving</td><td  align='left'>${bar}</td>"
		;;
	    ${LOADED}.backup)
		echo "<td align='left'>System Backup</td><td align='center'>Loading</td><td  align='left'>${bar}</td>"
		;;
	    ${LOADED}.os.tar.compressed)
		echo "<td align='left'>OS Patch</td><td align='center'>Loading</td><td  align='left'>${bar}</td>"
		;;
	esac

	prefix=${LOADED}.${URLLIST}. ; len=${#prefix}

	if test ${base:0:${len}} == ${prefix} ; then
	    urllist=${base:${len}}
	    echo "<td align='left'>${urllist} content</td><td align='center'>Loading</td><td align='left'>${bar}</td>"
	fi

	((i++))
	echo -n "</tr>"
    done

    echo "</tbody>"
    echo "</table>"

    echo "<table class='highlight-list' width='${table_width}' style='margin:0; margin-top:5px;'>"
    echo "<thead></thead>"
    echo "<tbody>"
    echo "<tr><td align='left' width='100%'>Number of files being exchanged:<span style='float:right;'>${i}</span></td></tr>"
    echo "</tbody>"
    echo "</table>"
}
