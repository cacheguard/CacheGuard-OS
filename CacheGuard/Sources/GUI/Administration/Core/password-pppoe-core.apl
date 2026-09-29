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

show-password-pppoe-form()
{
    local width

    itemWidth[0]=30
    itemWidth[1]=70

    itemTitle[0]="PPPoE Service Name"
    itemTitle[1]="PPPoE Username"
    itemTitle[2]="PPPoE Password"
    
    itemID[0]="service_name"
    itemID[1]="username"
    itemID[2]="password"

    blankItemContent[0]="${IP_EXTRNAL_PPPOE_SERVICE_NAME}"
    blankItemContent[1]="${IP_EXTRNAL_PPPOE_USERNAME}"
    blankItemContent[2]="type='password' size='32' maxlength='${MAX_LEN}' value='${IP_EXTRNAL_PPPOE_PASSWORD}'"

    checkItem[2]=printable

    itemForm[0]="text"
    itemForm[1]="text"

    shortcutMenuItem[0]="ip"
    shortcutMenuTitle[0]="IP Addresses"

    show-title "PPPoE Password" "enabled" "ip"
    show-form "${width}"
}

# Main()

show-password-pppoe-form
