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

show-dhcp-range-form()
{
    local get_args=${1}
    local page_ref=$(get-arg-value "${get_args}" page)

    local width=${DEFAULT_LIST_FORM_WIDTH_3}
    local state

    itemWidth[1]=40

    itemTitle[1]="Min IP Address"
    itemTitle[2]="Max IP Address"
    
    itemID[0]="Range"
    itemID[1]="ip1"
    itemID[2]="ip2"
    
    blankItemContent[0]=""
    blankItemContent[1]="type='text' size='15' maxlength='15'"
    blankItemContent[2]="type='text' size='15' maxlength='15'"

    checkItem[1]=ip
    checkItem[2]=ip

    listContent=${DHCP_RANGE_LIST}
    test -n "${listContent}" || state=disabled

    show-title "DHCP IP Ranges" "${state}" "dhcp"
    show-list-form ${MAX_DHCP_RANGE_NB} "${width}" "${page_ref}"
}

# Main()

show-dhcp-range-form "${@}"
