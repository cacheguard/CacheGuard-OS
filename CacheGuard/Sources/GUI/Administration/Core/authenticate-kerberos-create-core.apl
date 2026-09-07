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

show-kerberos-create-log()
{
    refresh-buttons
    echo "<div class='table-title'>Last kerberos initialization report</div>"
    echo "<div id='${AUTO_REPORT_ID}' class='log-report'></div>"
}

show-av-update-form()
{
    local state width
    local login i=0

    test "${REMOTE_USER}" == "${ADMIN_NAME}" || state=disabled

    local principal="HTTP/${CURRENT_KERBEROS_SERVICE_NAME}.${CURRENT_DOMAIN_NAME}@${CURRENT_DOMAIN_NAME^^}"

    itemWidth[0]=40
    itemWidth[1]=50

    test -z "${VALUES[0]}" || login=${VALUES[0]}

    if test ${CURRENT_AUTHENTICATE_AD_MODE} == True ; then
	local dc_chain=$(get-domain-controller-chain ${DOMAIN_NAME})
	local fdn="cn=${CURRENT_KERBEROS_SERVICE_NAME},${CURRENT_AD_WEBGATEWAY_RDN},${dc_chain}"
	itemID[${i}]="fdn"
	itemTitle[${i}]="Full DN on Active Directory"
	blankItemContent[${i}]="${fdn}"
	itemForm[${i}]="text"
	((i++))
    fi

    itemID[${i}]="principal"
    itemTitle[${i}]="HTTP Proxy Service Principal"
    blankItemContent[${i}]="${principal}"
    itemForm[${i}]="text"
    ((i++))

    itemID[${i}]="login"
    itemTitle[${i}]="Kerberos Administrator User"
    blankItemContent[${i}]="type='text' size='16' maxlength='64' value='${login}'"
    checkItem[${i}]=printable
    ((i++))

    itemID[${i}]="password"
    itemTitle[${i}]="Kerberos Administrator Password"
    blankItemContent[${i}]="type='password' size='32' maxlength='64'"
    checkItem[${i}]=printable
    ((i++))

    shortcutMenuItem[0]="time"
    shortcutMenuTitle[0]="Time Settings"

    show-title "Kerberos Initialization" "${state}" "authenticate clock ntp"
    show-form "${width}" "${state}" show-kerberos-create-log
}

# Main()

show-av-update-form
