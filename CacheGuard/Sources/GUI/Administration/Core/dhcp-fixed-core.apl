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

show-dhcp-fixed-form()
{
    local get_args=${1}
    local page_ref=$(get-arg-value "${get_args}" page)

    local state width=${DEFAULT_LIST_FORM_WIDTH}
    local users_nb=$(gui-get-contextual-users-nb)

    local max=$[${users_nb} * 2]

    itemWidth[1]=45

    itemTitle[0]=""
    itemTitle[1]="Host Name"
    itemTitle[2]="MAC Address"
    itemTitle[3]="IP Address"
    
    itemID[0]="Fixed"
    itemID[1]="hostname"
    itemID[2]="mac"
    itemID[3]="ip"
    
    blankItemContent[0]=""
    blankItemContent[1]="type='text' size='20' maxlength='64'"
    blankItemContent[2]="type='text' size='17' maxlength='17'"
    blankItemContent[3]="type='text' size='15' maxlength='15'"

    checkItem[1]=domainname
    checkItem[2]=mac
    checkItem[3]=ip

    listContent=${DHCP_FIXED_LIST}
    test -n "${listContent}" || state=disabled

    show-title "DHCP Fixed IPs" "${state}" "dhcp"
    show-list-form ${max} "${width}" "${page_ref}"
}

# Main()

show-dhcp-fixed-form "${@}"
