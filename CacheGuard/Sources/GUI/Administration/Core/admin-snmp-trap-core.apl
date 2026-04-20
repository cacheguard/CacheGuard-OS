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

show-snmp-trap-form()
{
    local get_args=${1}
    local page_ref=$(get-arg-value "${get_args}" page)

    local title width=${DEFAULT_LIST_FORM_WIDTH_1}

    itemWidth[0]=40
    itemWidth[1]=60

    itemTitle[0]="Trap receiver"
    itemTitle[1]="SNMP Version"
    itemTitle[2]="Receiver IP or name"
    itemTitle[3]="Port"
    itemTitle[4]="SNMP v3 User name"
    itemTitle[5]="Authentication Hash"
    itemTitle[6]="Encryption algorithm"
    itemTitle[7]="Community (password)"
    itemTitle[8]="Encryption password"

    itemID[0]=""
    itemID[1]="version"
    itemID[2]="server"
    itemID[3]="port"
    itemID[4]="user"
    itemID[5]="hash"
    itemID[6]="enc"
    itemID[7]="password"
    itemID[8]="privacy"

    blankItemContent[1]="v3 v2c v1"
    blankItemContent[2]="type='text' size='24' maxlength='64'"
    blankItemContent[3]="type='text' size='5' maxlength='5'"
    blankItemContent[4]="type='text' size='15' maxlength='${MAX_LEN}'"
    blankItemContent[5]="sha256 sha384 sha512"
    blankItemContent[6]="des aes"
    blankItemContent[7]="type='password' size='16' maxlength='32'"
    blankItemContent[8]="type='password' size='16' maxlength='32'"

    itemFormSelectCBFunction[1]="snmpTrapSelectVersionCB"
    itemFormSelectCBArgs[1]="version user hash enc privacy"

    checkItem[0]=
    checkItem[2]=ipdomainname
    checkItem[3]=port
    checkItem[4]=printable
    checkItem[7]=printable
    checkItem[8]=printable
    
    itemForm[1]="select"
    itemForm[5]="select"
    itemForm[6]="select"

    itemType[7]="password"
    itemType[8]="password"

    shortcutMenuItem[0]="network-utilities"
    shortcutMenuTitle[0]="Test Traps"

    listContent=${SNMP_TRAP_SERVER_LIST}
    test -n "${listContent}" || disabled=disabled
    show-title "SNMP Traps Settings" "${disabled}" "admin"
    test -z "${CURRENT_SNMP_TRAP_SERVER_LIST}" -o ${CURRENT_ADMIN_SNMP} == False || show-shortcuts-menu
    show-multi-form ${MAX_SNMP_TRAP_NB} "${width}" "${page_ref}"
}

# Main()

show-snmp-trap-form "${@}"
