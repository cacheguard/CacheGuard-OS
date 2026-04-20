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

show-guard-filter-time-form()
{
    local get_args=${1}
    local page_ref=$(get-arg-value "${get_args}" page)

    local width=${DEFAULT_LIST_FORM_WIDTH}
    local state

    itemWidth[1]=35

    itemTitle[0]=""
    itemTitle[1]="Name"
    itemTitle[2]="Type"
    itemTitle[3]="Time"
    
    itemID[0]="Time Filter"
    itemID[1]="name"
    itemID[2]="type"
    itemID[3]="time"

    blankItemContent[0]=""
    blankItemContent[1]="type='text' size='${MAX_NAME_LEN}' maxlength='${MAX_NAME_LEN}'"
    blankItemContent[2]="slot frame date"
    blankItemContent[3]="type='text' size='22' maxlength='22' onMouseOver='showTimeToolTip( this.id );' onMouseOut='hideTimeToolTip( );'"
    
    checkItem[1]=guard
    checkItem[3]=time
    
    itemForm[2]="select"

    listContent=${GUARD_FILTER_TIME_LIST}
    test -n "${listContent}" || state=disabled

    call-js-function "hideTimeToolTip( )"
    show-title "Time Filters" "${state}" "guard"
    show-list-form ${MAX_GUARD_FILTERS_NB} "${width}" "${page_ref}"
}

# Main()

show-guard-filter-time-form "${@}"
