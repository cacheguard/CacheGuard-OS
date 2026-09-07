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

show-dhcp-report-form()
{
    local get_args=${1}
    local page_ref=$(get-arg-value "${get_args}" page)
    local page_2show_ref=$(page-2show-ref 20 "${page_ref}")
    local records_ppage=${page_2show_ref/ *}
    local page_2show=${page_2show_ref/* }
    local tmp_leases_file=/tmp/gui.dhcpd.leases.${$}

    local page_nb i=0
    local state hostname mac ip lease_time
    local hostname_t mac_t ip_t lease_time_t
    declare -a hostname_t mac_t ip_t lease_time_t

    show-dhcp-leases > ${tmp_leases_file}

    while read state hostname mac ip lease_time
    do
	hostname_t[${i}]=${hostname}
	mac_t[${i}]=${mac}
	ip_t[${i}]=${ip}
	lease_time_t[${i}]=${lease_time}
	((i++))
    done < ${tmp_leases_file}

    rm -f ${tmp_leases_file}

    local users_nb=$(gui-get-contextual-users-nb)
    local leases_nb=${i}
    show-title "DHCP Leases report" disabled "dhcp"

    echo "<div class='core-form'>"

    show-table-form-controls ${leases_nb} $[${users_nb} * 2] ${records_ppage} ${page_2show} list none

    echo "<table class='highlight-list noselect'>"
    echo "<thead>"
    echo "<tr>"
    echo "<th class='table-header'><u>Range</u></th>"
    echo "<th class='table-header'><u>Hostname</u></th>"
    echo "<th class='table-header'><u>MAC Address</u></th>"
    echo "<th class='table-header'><u>IP Address</u></th>"
    echo "<th class='table-header'><u>Lease End Time</u></th>"
    echo "</tr>"
    echo "</thead>"

    echo "<tbody>"

    for ((i=0 ; i<leases_nb ; i++))
    do
	page_nb=$[${i} / ${records_ppage}]
	test ${page_nb} -eq ${page_2show} || continue

	echo "<tr>"
	echo "<td>R${i}</td>"
	echo "<td>${hostname_t[${i}]}</td>"
	echo "<td>${mac_t[${i}]}</td>"
	echo "<td>${ip_t[${i}]}</td>"
	echo "<td>${lease_time_t[${i}]}</td>"
	echo "</tr>"
    done

    echo "</tbody>"
    echo "</table>"

    data-init-table-form ${leases_nb} ${records_ppage} ${page_2show}

    echo "</div>"
}

# Main()

show-dhcp-report-form "${@}"
