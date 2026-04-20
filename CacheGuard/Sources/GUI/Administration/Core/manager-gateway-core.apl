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

show-manager-gateway-form()
{
    local get_args=${1}
    local page_ref=$(get-arg-value "${get_args}" page)

    local width=700
    local state i=0

    local source_list

    itemWidth[1]=25
    itemWidth[2]=25
    itemWidth[3]=20

    itemTitle[1]="Gateway Identifier"
    itemTitle[2]="Domain Identifier"
    itemTitle[3]="IP Address"

    itemID[0]="Managed Gateway"
    itemID[1]="gateway_id"
    itemID[2]="domain_id"
    itemID[3]="ip"

    checkItem[1]=identifier
    checkItem[2]=identifier
    checkItem[3]=ip

    unset listContent

    if test -s ${ADMIN_DIR}/${MANAGER_GATEWAY_INDEX} ; then

	local uuid domain id ip i=0

	while read uuid domain id ip
	do
	    listContent="${listContent} ${id} ${domain} ${ip}"
	done < ${ADMIN_DIR}/${MANAGER_GATEWAY_INDEX}
    fi
    listContent=${listContent:1}

    blankItemContent[0]=""
    blankItemContent[1]="type='text' size='32' maxlength='${MAX_NAME_LEN}'"
    blankItemContent[2]="type='text' size='32' maxlength='${MAX_NAME_LEN}'"
    blankItemContent[3]="type='text' size='15' maxlength='15'"

    test -n "${listContent}" || state=disabled

    editColumnPage[${i}]="conf-show"
    editColumnTitle[${i}]="Edit"
    editColumnKey[${i}]="gateway"
    editColumnCommentFalse[${i}]="Configuration Validated"
    editColumnCommentTrue[${i}]="Configuration Modified"
    editColumnCommentFunction[${i}]="quick-conf-modified gateway"
    ((i++))

    editColumnPage[${i}]="manager-gateway-operation"
    editColumnQuery[${i}]="pull"
    editColumnTitle[${i}]="Pull"
    editColumnCommentIcon[${i}]="manager-gateway-pull"
    ((i++))

    editColumnPage[${i}]="manager-gateway-operation"
    editColumnQuery[${i}]="push"
    editColumnTitle[${i}]="Push"
    editColumnCommentIcon[${i}]="manager-gateway-push"
    ((i++))

    show-title "Gateways Repository" "${state}" "manager"
    show-list-form ${MANAGER_GATEWAY_NB} "${width}" "${page_ref}"
}

# Main()

show-manager-gateway-form "${@}"
