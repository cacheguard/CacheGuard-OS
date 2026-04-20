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

show-authenticate-ldap-server-form()
{
    local get_args=${1}
    local page_ref=$(get-arg-value "${get_args}" page)

    local width=${DEFAULT_LIST_FORM_WIDTH}
    local state

    itemWidth[1]=10
    itemWidth[3]=25
    itemWidth[4]=10

    itemTitle[0]=''
    itemTitle[1]="Protocol"
    itemTitle[2]="Server name"
    itemTitle[3]="IP Address"
    itemTitle[4]="Port"
    
    itemID[0]="LDAP Server"
    itemID[1]="protocol"
    itemID[2]="name"
    itemID[3]="ip"
    itemID[4]="port"

    blankItemContent[0]=""
    blankItemContent[1]="ldap ldaps sldap"
    blankItemContent[2]="type='text' size='24' maxlength='${MAX_LEN}'"
    blankItemContent[3]="type='text' size='15' maxlength='15'"
    blankItemContent[4]="type='text' size='5' maxlength='5'"

    checkItem[2]=domainname
    checkItem[3]=ip
    checkItem[4]=port

    itemForm[1]="select"

    shortcutMenuItem[0]="network-utilities"
    shortcutMenuTitle[0]="Test Authentication"

    listContent=${LDAP_SERVER_LIST}
    test -n "${listContent}" || state=disabled

    show-title "LDAP Authentication Servers" "${state}" "authenticate"

    test \
	-z "${CURRENT_LDAP_SERVER_LIST}" -o \
	"${CURRENT_AUTHENTICATE_MODE}" == False -o \
	"${CURRENT_AUTHENTICATE_LDAP}" == False \
	|| show-shortcuts-menu

    show-list-form ${MAX_LDAP_SERVER_NB} "${width}" "${page_ref}"
}

# Main()

show-authenticate-ldap-server-form "${@}"
