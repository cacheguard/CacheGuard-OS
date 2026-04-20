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

show-guard-policy-form()
{
    local get_args=${1}
    local page_ref=$(get-arg-value "${get_args}" page)

    local width=${DEFAULT_LIST_FORM_WIDTH_2}
    local state

    itemWidth[1]=70

    itemTitle[1]="Name"

    itemID[0]="Guard Policy"
    itemID[1]="policy_name"

    blankItemContent[0]=""
    blankItemContent[1]="type='text' size='${MAX_NAME_LEN}' maxlength='${MAX_NAME_LEN}'"
    
    checkItem[1]=identifier

    editColumnPage[0]="edit-guard-policy"
    editColumnTitle[0]="Edit"

    listContent=${GUARD_POLICY_LIST}
    listContentStep=2
    listContentVisibility[1]=off

    test -n "${listContent}" || state=disabled
    
    show-title "URL Guarding Policies" "${state}" "guard"
    show-list-form ${MAX_GUARD_POLICIES_NB} "${width}" "${page_ref}"
}

# Main()

show-guard-policy-form "${@}"
