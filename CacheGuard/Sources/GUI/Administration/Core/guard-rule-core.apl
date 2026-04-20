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

get-policy-options()
{
    local i=0 elt range

    local list="default"

    for elt in ${GUARD_POLICY_LIST}
    do
	range=$[${i} % 2]
	case ${range} in
	    0)
		name=${elt}
		;;
	    1)
		list="${list} ${name}"
		;;
	    *)
		;;
	esac
	((i++))
    done

    echo ${list}
}

show-guard-rule-form()
{
    local get_args=${1}
    local page_ref=$(get-arg-value "${get_args}" page)

    local width=${DEFAULT_LIST_FORM_WIDTH}
    local state

    itemWidth[0]=ordered
    itemWidth[1]=50

    itemTitle[0]=""
    itemTitle[1]="Policy Name"
    itemTitle[2]="Action"
    
    itemID[0]="Guard Rule"
    itemID[1]="policy_name"
    itemID[2]="action"

    blankItemContent[0]=""
    blankItemContent[1]=$(get-policy-options)
    blankItemContent[2]="deny allow"
    
    itemForm[1]="select"
    itemForm[2]="select"

    editColumnPage[0]="edit-guard-rule"
    editColumnTitle[0]="Edit"

    listContent=${GUARD_RULE_LIST}
    listContentStep=3
    listContentVisibility[2]=off

    test -n "${listContent}" || state=disabled
    
    show-title "URL Guarding Rules" "${state}" "guard"
    show-list-form ${MAX_GUARD_RULES_NB} "${width}" "${page_ref}" "" insert
}

# Main()

show-guard-rule-form "${@}"
