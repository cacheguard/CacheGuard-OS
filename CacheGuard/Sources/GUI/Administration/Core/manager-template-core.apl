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

show-manager-template-form()
{
    local get_args=${1}
    local page_ref=$(get-arg-value "${get_args}" page)

    local width=${DEFAULT_LIST_FORM_WIDTH_1}
    local state

    local source_list

    itemWidth[1]=35
    itemWidth[2]=35

    itemTitle[1]="Identifier"
    itemTitle[2]="Copy From"

    itemID[0]="Template Id"
    itemID[1]="template_id"
    itemID[2]="source"

    listContentVisibility[2]=off
    checkItem[1]=identifier

    itemForm[1]="input"
    itemForm[2]="select:blank"

    local dir=$(get-manager-context-rdir template)
    local templates=$(ls -1 ${ADMIN_DIR}/${dir} 2> /dev/null) template i=0
    unset listContent

    for template in ${templates}
    do
	template=$(file-basename ${template})
	listContent="${listContent} ${template} nil"
	source_list="${source_list} TEMPLATE&nbsp;>&nbsp;${template}"
    done
    listContent=${listContent:1}

    if test -s ${ADMIN_DIR}/${MANAGER_GATEWAY_INDEX} ; then

	local uuid domain id ip

	while read uuid domain id ip
	do
	    source_list="${source_list} GATEWAY&nbsp;>&nbsp;${id}"
	done < ${ADMIN_DIR}/${MANAGER_GATEWAY_INDEX}
    fi
    source_list=${source_list:1}

    blankItemContent[0]=""
    blankItemContent[1]="type='text' size='${MAX_NAME_LEN}' maxlength='${MAX_NAME_LEN}'"
    blankItemContent[2]=${source_list}

    editColumnPage[${i}]="conf-show"
    editColumnTitle[${i}]="Edit"
    editColumnKey[${i}]="template"
    editColumnCommentFalse[${i}]="Configuration Validated"
    editColumnCommentTrue[${i}]="Configuration Modified"
    editColumnCommentFunction[${i}]="quick-conf-modified template"
    ((i++))

    test -n "${listContent}" || state=disabled
    
    show-title "Manage Templates" "${state}" "manager"
    show-list-form ${MANAGER_TEMPLATE_NB} "${width}" "${page_ref}"
}

# Main()

show-manager-template-form "${@}"
