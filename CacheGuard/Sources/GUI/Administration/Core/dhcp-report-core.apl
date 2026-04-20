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

show-dhcp-report-form()
{
    local get_args=${1}
    local page_ref=$(get-arg-value "${get_args}" page)
    local page_2show_ref=$(page-2show-ref 20 "${page_ref}")
    local records_ppage=${page_2show_ref/ *}
    local page_2show=${page_2show_ref/* }
    local tmp_leases_file=/tmp/gui.dhcpd.leases.${$}
    local leases=0
    local state hostname mac ip lease_time

    local page_nb

    show-title "DHCP Leases report" disabled "dhcp"

    echo "<div class='core-form'>"

    local users_nb=$(gui-get-contextual-users-nb)
    show-table-form-controls $[${users_nb} * 2] ${records_ppage} list none

    echo "<table class='highlight-list'>"
    echo "<thead>"
    echo "<tr>"
    echo "<td class='table-header'><u>Range</u></td>"
    echo "<td class='table-header'><u>Hostname</u></td>"
    echo "<td class='table-header'><u>MAC Address</u></td>"
    echo "<td class='table-header'><u>IP Address</u></td>"
    echo "<td class='table-header'><u>Lease End Time</u></td>"
    echo "</tr>"
    echo "</thead>"

    echo "<tbody>"

    show-dhcp-leases > ${tmp_leases_file}

    while read state hostname mac ip lease_time
    do
	page_nb=$[${leases} / ${records_ppage}]

	if test ${page_nb} -ne ${page_2show} ; then
	    ((leases++))
	    continue
	fi

	echo "<tr>"
	echo "<td>R${leases}</td>"
	echo "<td>${hostname}</td>"
	echo "<td>${mac}</td>"
	echo "<td>${ip}</td>"
	echo "<td>${lease_time}</td>"
	echo "</tr>"
	((leases++))
    done < ${tmp_leases_file}

    rm -f ${tmp_leases_file}
    js-init-table-form ${leases} ${records_ppage} ${page_2show}

    echo "</tbody>"
    echo "</table>"


    echo "</div>"
}

# Main()

show-dhcp-report-form "${@}"
