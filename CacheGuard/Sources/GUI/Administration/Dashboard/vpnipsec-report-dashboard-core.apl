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

show-system-report-vpnipsec-site()
{
    if test ! -s ${RUN_DIR}/${VPN_IPSEC_SITE_STATE_FILENAME} ; then
        echo "<div class='core-form'>"
	echo-unavailable-message "this is no entry in this report yet."
        echo "</div>"
        return 0
    fi

    echo "<div class='core-form'>"

    test ${display_time} != time || display-appliance-time-table

    echo "<table class='highlight-list compact'>"

    echo "<thead>"
    echo "<tr>"
    echo "<th class='table-header' width='50%' align='center'>Remote Site Name</th>"
    echo "<th class='table-header' width='35%' align='center'>Remote IP</th>"
    echo "<th class='table-header' width='15%' align='center'>State</th>"
    echo "</tr>"
    echo "</thead>"

    echo "<tbody>"

    local connection remote_address state
    local site ext_state

    while read connection remote_address state
    do
	test -n "${connection}" || continue
	site=${connection#site-}
	test ${remote_address} != nil || unset remote_address

	echo "<tr>"
	echo "<td align='left'>${site}</td>"
	echo "<td align='left'>${remote_address}</td>"
	if test "${state}" == OK ; then
	    echo "<td align='center'><img src='${IMAGE_DIR}/ok.png' /></td>"
	else
	    echo "<td align='center'><img src='${IMAGE_DIR}/ko.png' title='KO' /></td>"
	fi
	echo "</tr>"

    done < ${RUN_DIR}/${VPN_IPSEC_SITE_STATE_FILENAME}

    echo "</tbody>"
    echo "</table>"
    echo "</div>"
}

show-system-report-vpnipsec-site-dashboard()
{
    show-system-report-vpnipsec-site
    reset-gui-error-log
}

# Main()

show-system-report-vpnipsec-site-dashboard
