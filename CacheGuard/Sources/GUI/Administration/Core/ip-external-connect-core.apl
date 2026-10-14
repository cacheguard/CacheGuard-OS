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

show-external-connect-report()
{
    if test ${CURRENT_IP_EXTERNAL_MODE} == static ; then
	echo-unavailable-message "The connection request is not applicable when the external interface uses a static IP configuration."
	return 0
    fi

    local title
    refresh-buttons

    case ${CURRENT_IP_EXTERNAL_MODE} in
	dhcp)
	    title="External interface DHCP renewal report"
	    ;;
	pppoe)
	    title="External interface PPPoE connection report"
	    ;;
	*)
	    return 11
	    ;;
    esac

    echo "<div class='table-title'>${title}</div>"
    echo "<div id='${AUTO_REPORT_ID}' class='log-report'></div>"
}

show-ip-external-renew-form()
{
    local width

    local state

    if test "${REMOTE_USER}" != "${ADMIN_NAME}" ; then
	state='disabled'
    else
	test ${CURRENT_IP_EXTERNAL_MODE} != 'static' || state='disabled'
    fi

    shortcutMenuItem[0]="apply"
    shortcutMenuTitle[0]="Apply"

    shortcutMenuItem[1]="ip"
    shortcutMenuTitle[1]="External IP"

    show-title "Connect External Network Interface" "${state}" "apply ip"
    show-form "${width}" "${state}" show-external-connect-report
}

# Main()

show-ip-external-renew-form
