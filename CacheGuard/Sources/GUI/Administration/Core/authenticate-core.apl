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

show-feature-form()
{
    local width=350

    itemWidth[0]=95
    itemWidth[1]=5

    itemTitle[0]=""
    itemTitle[1]="LDAP Authentication"
    itemTitle[2]="Kerberos Authentication"
    itemTitle[3]="Authenticate Forwarding end-users"
    itemTitle[4]="Authenticate end-users of reverse Websites"

    itemID[0]="dummy"
    itemID[1]="ldap"
    itemID[2]="kerberos"
    itemID[3]="web"
    itemID[4]="rweb"

    blankItemContent[0]="value='on'"
    blankItemContent[1]="type=checkbox$(checked ${AUTHENTICATE_LDAP})"
    blankItemContent[2]="type=checkbox$(checked ${AUTHENTICATE_KERBEROS})"
    blankItemContent[3]="type=checkbox$(checked ${AUTHENTICATE_WEB})"
    blankItemContent[4]="type=checkbox$(checked ${AUTHENTICATE_RWEB})"

    itemForm[0]="hidden"

    show-title "Users Authentication Main Settings" "enabled" "authenticate"
    show-form "${width}"
}

# Main()

show-feature-form
