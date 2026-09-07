#!/bin/bash

###########################################################################
#
# MODULE:       GUI
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

show-access-fweb-form()
{
    local get_args=${1}
    local page_ref=$(get-arg-value "${get_args}" page)

    local width=${DEFAULT_LIST_FORM_WIDTH_3}
    local state

    itemWidth[1]=42
    itemWidth[2]=41

    itemTitle[0]=""
    itemTitle[1]="Network IP"
    itemTitle[2]="Net Mask"
    
    itemID[0]="Forwarded web access"
    itemID[1]="ip"
    itemID[2]="mk"
    
    blankItemContent[0]=""
    blankItemContent[1]="type='text' size='18' maxlength='18'"
    blankItemContent[2]="type='text' size='15' maxlength='15'"

    checkItem[0]=
    checkItem[1]=ip
    checkItem[2]=ip

    listContent=${ACCESS_FORWARDED_WEB_LIST}
    test -n "${listContent}" || state=disabled

    show-title "Allowed Web Proxy Forwarded Clients" "${state}" "access"
    show-list-form ${MAX_ACL_WEB_NB} "${width}" "${page_ref}"
}

# Main()

show-access-fweb-form "${@}"
