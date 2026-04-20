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

show-urllist-form()
{
    local get_args=${1}
    local page_ref=$(get-arg-value "${get_args}" page)

    local width state

    case ${APL_ROLE} in
	gateway)
	    width=${DEFAULT_LIST_FORM_WIDTH_2}
	    itemWidth[1]=70
	    editColumnPage[0]="urllist-content"
	    editColumnTitle[0]="Content"
	    ;;
	manager)
	    width=${DEFAULT_LIST_FORM_WIDTH_3}
	    ;;
	*)
	    ;;
    esac

    itemTitle[1]="URL List"
    
    itemID[0]=${itemTitle[1]}
    itemID[1]="urllist"
    
    blankItemContent[0]=""
    blankItemContent[1]="type='text' size='${MAX_NAME_LEN}' maxlength='${MAX_NAME_LEN}'"
    
    checkItem[1]=guard
    
    listContent=${URLLIST_LIST}
    test -n "${listContent}" || state=disabled

    show-title "Add & Delete Lists" "${state}" "guard sslmediate urllist"
    show-list-form ${MAX_URLLIST_NB} "${width}" "${page_ref}"
}

# Main()

show-urllist-form "${@}"
