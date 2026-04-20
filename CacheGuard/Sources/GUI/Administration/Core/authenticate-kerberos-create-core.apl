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

show-kerberos-create-log()
{
    refresh-buttons "update_authenticate_kerberos_create( 1 )"
    echo "<div style='clear:left;'></div><br />"
    echo "<div class='table-title'>Last kerberos initialization report</div>"
    echo "<div id='${AUTO_REPORT_ID}' class='log-report'></div>"
    echo "</div>"
}

show-av-update-form()
{
    local state
    local width

    test "${REMOTE_USER}" == "${ADMIN_NAME}" || state=disabled

    local dc_chain=$(get-domain-controller-chain ${DOMAIN_NAME})
    local fdn="cn=${CURRENT_KERBEROS_SERVICE_NAME},${CURRENT_AD_WEBGATEWAY_RDN},${dc_chain}"

    itemWidth[0]=40
    itemWidth[1]=50

    itemTitle[0]="This system full DN"
    itemTitle[1]="Kerberos Administrator User"
    itemTitle[2]="Kerberos Administrator Password"

    itemID[0]="fdn"
    itemID[1]="login"
    itemID[2]="password"

    if test -n "${VALUES[0]}" ; then
	local login=${VALUES[0]}
    else
	local login=Administrator
    fi

    blankItemContent[0]="${fdn}"
    blankItemContent[1]="type='text' size='16' maxlength='64' value='${login}'"
    blankItemContent[2]="type='password' size='32' maxlength='64'"

    itemForm[0]="text"

    checkItem[1]=printable
    checkItem[2]=printable

    shortcutMenuItem[0]="mode-feature"
    shortcutMenuItem[1]="authenticate"
    shortcutMenuItem[2]="authenticate-kerberos-ad"
    shortcutMenuItem[3]="authenticate-kerberos-server"
    shortcutMenuItem[4]="authenticate-kerberos-rweb"
    shortcutMenuItem[5]="time"
    shortcutMenuTitle[0]="Activate Authentication"
    shortcutMenuTitle[1]="Activate Kerberos"
    shortcutMenuTitle[2]="Configure Kerberos"
    shortcutMenuTitle[3]="Kerberos Servers"
    shortcutMenuTitle[4]="RWeb Kerberos"
    shortcutMenuTitle[5]="Time Settings"

    show-title "Kerberos Initialization" "${state}" "authenticate clock ntp"
    show-shortcuts-menu
    show-form "${width}" "${state}" show-kerberos-create-log
}

# Main()

show-av-update-form
