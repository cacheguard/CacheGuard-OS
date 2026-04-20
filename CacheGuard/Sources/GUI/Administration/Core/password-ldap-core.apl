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

show-password-ldap-form()
{
    local width

    itemWidth[0]=30
    itemWidth[1]=70

    itemTitle[0]="Bind DN"
    itemTitle[1]="Password"
    
    itemID[0]="bind_dn"
    itemID[1]="bind_password"
    
    blankItemContent[0]="${LDAP_BIND_DN}"
    blankItemContent[1]="type='password' size='32' maxlength='64'"

    checkItem[1]=printable

    itemForm[0]="text"

    shortcutMenuItem[0]="authenticate-ldap-request"
    shortcutMenuTitle[0]="Bind DN"

    show-title "LDAP Bind Password" "enabled" "authenticate password"
    show-shortcuts-menu
    show-form "${width}"
}

# Main()

show-password-ldap-form
