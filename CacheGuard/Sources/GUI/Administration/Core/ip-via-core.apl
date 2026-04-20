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

show-ip-via()
{
    local get_args=${1}
    local page_ref=$(get-arg-value "${get_args}" page)

    local width=${DEFAULT_LIST_FORM_WIDTH_1}
    local state

    itemWidth[1]=45

    itemTitle[1]="Via Gateway"
    itemTitle[2]="Role"
    itemTitle[3]="Priority"

    itemID[0]="IP Via"
    itemID[1]="gateway"
    itemID[2]="role"
    itemID[3]="priority"

    blankItemContent[0]=""
    blankItemContent[1]=$(get-external-gateways)
    blankItemContent[2]="master backup"
    blankItemContent[3]="type='text' size='3' maxlength='3'"
    
    itemForm[1]="select"
    itemForm[2]="select"

    checkItem[3]=digit

    listContent=${IP_VIA_LIST}
    test -n "${listContent}" || state=disabled

    show-title "Via Gateways" "${state}" "ip rweb vpnipsec"
    show-list-form ${MAX_IP_ROUTES_NB} "${width}" "${page_ref}"
}

show-ip-via "${@}"
