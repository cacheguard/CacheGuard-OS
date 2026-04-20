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

show-ldap-attributes-form()
{
    local width

    itemWidth[0]=25
    itemWidth[1]=75

    itemTitle[0]="User base DN"
    itemTitle[1]="Login attribute"
    itemTitle[2]="Password attribute"
    itemTitle[3]="Filter"
    itemTitle[4]="Group DN"
    itemTitle[5]="Bind Required"
    itemTitle[6]="Bind DN"
    itemTitle[7]="Bind Password"

    itemID[0]="user_base_dn"
    itemID[1]="login_attribute"
    itemID[2]="password_attribute"
    itemID[3]="filter"
    itemID[4]="group_base_dn"
    itemID[5]="bind_required"
    itemID[6]="bind_dn"
    itemID[7]="bind_password"

    blankItemContent[0]="type='text' size='64' maxlength='256' value='${LDAP_BASE_DN}'"
    blankItemContent[1]="type='text' size='24' maxlength='64' value='${LDAP_LOGIN}'"
    blankItemContent[2]="type='text' size='24' maxlength='64' value='${LDAP_PASSWORD}'"
    blankItemContent[3]="type='text' size='64' maxlength='384' value='${LDAP_FILTER}'"
    blankItemContent[4]="type='text' size='64' maxlength='256' value='${LDAP_GROUP_DN}'"
    blankItemContent[5]="type='checkbox'$(checked ${LDAP_BIND_MODE})"
    blankItemContent[6]="type='text' size='48' maxlength='256' value='${LDAP_BIND_DN}'"
    blankItemContent[7]="type='password' size='32' maxlength='64' value=''"

    itemForm[5]="check"

    checkItem[0]=dn
    checkItem[1]=printable
    checkItem[2]=printable
    checkItem[3]=printable
    checkItem[4]=dn
    checkItem[6]=dn
    checkItem[7]=printable

    shortcutMenuItem[0]="network-utilities"
    shortcutMenuTitle[0]="Test Authentication"

    show-title "LDAP Authentication Settings" "enabled" "authenticate"

    test \
	-z "${CURRENT_LDAP_SERVER_LIST}" -o \
	"${CURRENT_AUTHENTICATE_MODE}" == False -o \
	"${CURRENT_AUTHENTICATE_LDAP}" == False \
	|| show-shortcuts-menu

    show-form "${width}"
}

# Main()

show-ldap-attributes-form
