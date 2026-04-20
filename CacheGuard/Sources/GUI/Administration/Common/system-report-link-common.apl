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

get-html-bond-devs()
{
    test -n "${1}" || return 1
    dev=${1}

    local devs=$(get-bond-devs ${dev})

    test "${devs/:}" == "${dev}" || dev="${devs/:*}<br />[${devs/*:}]"
    echo "<td align='center'>${dev}</td>"
}

show-system-report-link()
{
    test -s ${RUN_DIR}/${LINKS_STATE_FILENAME} || return 0

    local display_time=${1}
    local table_width=${2}
    test -n "${table_width}" || table_width="405"
    local dev state ips
    local ip

    echo "<div class='core-form'>"

    if test -n "${display_time}" ; then
	echo "<table class='highlight-form' style='margin-bottom:5px;' width='${table_width}'>"
	display-appliance-time-row right
	echo "</table>"
    fi

    echo "<table class='highlight-list' width='${table_width}'>"

    echo "<thead>"
    echo "<tr>"
    echo "<td class='table-header indicator-table-header' width='30%' align='center'>Device</td>"
    echo "<td class='table-header' width='20%' align='center'>State</td>"
    echo "<td class='table-header' width='50%' align='center'>IP Address(es)</td>"
    echo "</tr>"
    echo "</thead>"

    echo "<tbody>"
    while read dev state ips
    do
	test -n "${ips}" || continue

	echo "<tr>"
	dev=$(get-html-bond-devs ${dev})
	echo ${dev}

	if test "${state}" == OK ; then
	    echo "<td align='center'><img src='${IMAGE_DIR}/ok.png' /></td>"
	else
	    echo "<td align='center'><img src='${IMAGE_DIR}/ko.png' title='KO' /></td>"
	fi

	echo "<td align='left'>"
	for ip in ${ips}
	do
	    echo "${ip}<br />"
	done
	echo "</td>"
	echo "</tr>"

    done < ${RUN_DIR}/${LINKS_STATE_FILENAME}

    echo "</tbody>"
    echo "</table>"
    echo "</div>"
}
