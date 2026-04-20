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

show-ip-route-form()
{
    local get_args=${1}
    local page_ref=$(get-arg-value "${get_args}" page)

    local width=720 ip_width=17
    local state

    itemWidth[0]=ordered
    itemWidth[1]=$((ip_width + 2))
    itemWidth[2]=${ip_width}
    itemWidth[3]=${ip_width}
    itemWidth[4]=10
    itemWidth[5]=${ip_width}

    itemTitle[0]=""
    itemTitle[1]="Net Address"
    itemTitle[2]="Net Mask"
    itemTitle[3]="Gateway"
    itemTitle[4]="Weight"
    itemTitle[5]="Pinged Server"
    
    itemID[0]="IP Route"
    itemID[1]="ip"
    itemID[2]="mk"
    itemID[3]="gw"
    itemID[4]="wt"
    itemID[5]="hl"

    blankItemContent[0]=""
    blankItemContent[1]="type='text' size='18' maxlength='18'"
    blankItemContent[2]=${blankItemContent[1]}
    blankItemContent[3]=${blankItemContent[1]}
    blankItemContent[4]="type='text' size='3' maxlength='3'"
    blankItemContent[5]=${blankItemContent[1]}

    checkItem[1]=ip
    checkItem[2]=ip
    checkItem[3]=ip
    checkItem[4]=weight
    checkItem[5]=ipdomainname
    
    shortcutMenuItem[0]="network-utilities"
    shortcutMenuTitle[0]="Send Pings"

    listContent=${IP_ROUTE_LIST}

    test -n "${listContent}" || state=disabled

    show-title "Static IP Routes" "${state}" "ip"
    show-shortcuts-menu
    show-list-form ${MAX_IP_ROUTES_NB} "${width}" "${page_ref}" "" insert
}

# Main()

show-ip-route-form "${@}"
