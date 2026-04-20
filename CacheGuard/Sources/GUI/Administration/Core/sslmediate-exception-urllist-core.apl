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

show-urllist()
{
    local urllist

    for urllist in ${URLLIST_LIST}
    do
	echo "${urllist}"
    done
}

show-sslmediate-exception-urllist-form()
{
    local get_args=${1}
    local page_ref=$(get-arg-value "${get_args}" page)

    local width=${DEFAULT_LIST_FORM_WIDTH_3}
    local state add_state

    itemWidth[1]=

    itemTitle[1]="URL List"

    itemID[0]=""
    itemID[1]="urllist"
    
    blankItemContent[0]=""
    blankItemContent[1]="$(show-urllist)"

    itemForm[1]="select"

    listContent=${SSLMEDIATE_EXCEPTION_URLLIST_LIST}
    test -n "${listContent}" || state=disabled
    test -n "${URLLIST_LIST}" || add_state=disabled

    shortcutMenuItem[0]="sslmediate"
    shortcutMenuItem[1]="urllist"
    shortcutMenuTitle[0]="SSL Mediation General Settings"
    shortcutMenuTitle[1]="URL Lists"

    show-title "SSL Mediation URL List Exceptions" "${state}" "sslmediate urllist"
    show-shortcuts-menu
    local style="style='margin:5px;'"

    case "${SSLMEDIATE_POLICY}" in
	allow)
	    echo "<div class='table-title' ${style}><strong>Policy</strong>: mediate SSL connections for the following domain names only.</div>"
	    ;;
	deny)
	    echo "<div class='table-title' ${style}><strong>Policy</strong>: exclude the SSL Mediation for the following domain names.</div>"
	    ;;
	*)
	    ;;
    esac

    show-list-form ${MAX_URLLIST_NB} "${width}" "${page_ref}" "" "" "${add_state}"
}

# Main()

show-sslmediate-exception-urllist-form "${@}"
