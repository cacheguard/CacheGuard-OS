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

show-password-ad-account-form()
{
    local width

    itemWidth[0]=50
    itemWidth[1]=50

    itemTitle[0]="Account Login"
    itemTitle[1]="Account Password"
    itemTitle[2]="Account Password [Retype]"
    
    itemID[0]="login"
    itemID[1]="password1"
    itemID[2]="password2"
    blankItemContent[0]=${AD_WEBGATEWAY_LOGIN}
    blankItemContent[1]="type=password size='24' maxlength='32'"
    blankItemContent[2]="type=password size='24' maxlength='32'"

    checkItem[1]=printable
    checkItem[2]=printable
    
    itemForm[0]="text"

    shortcutMenuItem[0]="authenticate-kerberos-ad"
    shortcutMenuTitle[0]="Kerberos Settings"

    show-title "AD Account Password" "enabled" "authenticate password"
    show-form "${width}"
}

# Main()

show-password-ad-account-form
