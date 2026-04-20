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

show-access-web-form()
{
    local get_args=${1}
    local page_ref=$(get-arg-value "${get_args}" page)

    local width=${DEFAULT_LIST_FORM_WIDTH}
    local state

    itemWidth[1]=10
    itemWidth[4]=5

    itemTitle[0]=""
    itemTitle[1]="Interface"
    itemTitle[2]="Network IP"
    itemTitle[3]="Net Mask"
    itemTitle[4]="<center>QoS %</center>"
    
    itemID[0]="Web access"
    itemID[1]="interface"
    itemID[2]="ip"
    itemID[3]="mk"
    itemID[4]="qos"
    
    blankItemContent[0]=""
    blankItemContent[1]="internal auxiliary vpnipsec admin antivirus file mon rweb web"
    blankItemContent[2]="type='text' size='18' maxlength='18'"
    blankItemContent[3]="type='text' size='15' maxlength='15'"
    blankItemContent[4]="type='text' size='3' maxlength='3'"

    itemForm[1]="select"

    checkItem[0]=
    checkItem[2]=ip
    checkItem[3]=ip
    checkItem[4]=percent

    listContent=${ACCESS_WEB_LIST}
    test -n "${listContent}" || state=disabled

    
    show-title "Allowed Web Browsing Client IPs" "${state}" "access"
    show-list-form ${MAX_ACL_WEB_NB} "${width}" "${page_ref}"
}

# Main()

show-access-web-form "${@}"
