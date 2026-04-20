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

show-password-email-form()
{
    local width

    itemWidth[0]=30
    itemWidth[1]=70

    itemTitle[0]="Email Account Details"
    itemTitle[1]="Password"
    
    itemID[0]="email_account"
    itemID[1]="email_password"
    
    blankItemContent[0]="smtp://${EMAIL_ACCOUNT_USERNAME}@${EMAIL_ACCOUNT_SERVER_FQDN}:${EMAIL_ACCOUNT_SERVER_PORT}"
    blankItemContent[1]="type='password' size='32' maxlength='64'"

    checkItem[1]=printable

    itemForm[0]="text"

    shortcutMenuItem[0]="email"
    shortcutMenuTitle[0]="Email Account"

    show-title "Administrator Email Account Password" "enabled" "email password"
    show-shortcuts-menu
    show-form "${width}"
}

# Main()

show-password-email-form
