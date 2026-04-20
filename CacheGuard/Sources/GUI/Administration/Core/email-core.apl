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

show-email-form()
{
    local width

    itemWidth[0]=40
    itemWidth[1]=60

    itemTitle[0]="Anonymous FTP Email"
    itemTitle[1]="Administrator Email"
    itemTitle[2]="Administrator Name"
    itemTitle[3]="Mail Server Name"
    itemTitle[4]="Mail Server Port"
    itemTitle[5]="Username"
    itemTitle[6]="Password"

    itemID[0]="ftp_email"
    itemID[1]="admin_email"
    itemID[2]="admin_name"
    itemID[3]="server"
    itemID[4]="port"
    itemID[5]="username"
    itemID[6]="password"

    blankItemContent[0]="type='text' size='32' maxlength='${MAX_LEN}' value='${ANONYMOUS_FTP_EMAIL}'"
    blankItemContent[1]="type='text' size='32' maxlength='${MAX_LEN}' value='${ADMINISTRATOR_EMAIL}'"
    blankItemContent[2]="type='text' size='32' maxlength='${MAX_LEN}' value='${ADMINISTRATOR_NAME}'"
    blankItemContent[3]="type='text' size='32' maxlength='${MAX_LEN}' value='${EMAIL_ACCOUNT_SERVER_FQDN}'"
    blankItemContent[4]="type='text' size='5' maxlength='5' value='${EMAIL_ACCOUNT_SERVER_PORT}'"
    blankItemContent[5]="type='text' size='32' maxlength='${MAX_LEN}' value='${EMAIL_ACCOUNT_USERNAME}'"
    blankItemContent[6]="type='password' size='32' maxlength='${MAX_LEN}' value=''"

    checkItem[0]=email
    checkItem[3]=domainname
    checkItem[4]=port

    shortcutMenuItem[0]="network-utilities"
    shortcutMenuTitle[0]="Test Email Sending"

    show-title "Email Configuration" "enabled" "email vpnipsec"

    test -z "${CURRENT_ADMINISTRATOR_EMAIL}" -o \
	 -z "${CURRENT_EMAIL_ACCOUNT_SERVER_FQDN}" -o \
	 -z "${CURRENT_EMAIL_ACCOUNT_SERVER_PORT}" -o \
	 -z "${CURRENT_EMAIL_ACCOUNT_USERNAME}" || show-shortcuts-menu

    show-form "${width}"
}

# Main()

show-email-form
