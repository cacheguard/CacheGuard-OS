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

show-ip-name()
{
    local get_args=${1}
    local page_ref=$(get-arg-value "${get_args}" page)

    local width=${DEFAULT_LIST_FORM_WIDTH_1}

    itemWidth[1]=55

    itemTitle[1]="Name"
    itemTitle[2]="IP"

    itemID[0]="IP Name"
    itemID[1]="name"
    itemID[2]="ip"

    blankItemContent[1]="type='text' size='32' maxlength='64'"
    blankItemContent[2]="type='text' size='15' maxlength='15'"

    checkItem[0]=
    checkItem[1]=domainname
    checkItem[2]=ip

    listContent=${IP_NAME_IP_LIST}
    test -n "${listContent}" || state=disabled

    show-title "Override DNS Resolutions" "${state}" "ip dns domainname hostname"
    show-list-form ${MAX_NAME_IP_NB} "${width}" "${page_ref}"
}

show-ip-name "${@}"
