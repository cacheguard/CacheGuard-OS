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

show-waf-rules()
{
    test -n "${1}" || return 1
    local div_id=${1}

    echo "<div class='core-form'>"
    echo "<div class='table-title'>Last valid loaded rules</div>"
    echo "<div id='${div_id}'></div>"
    echo "</div>"
}

print-operation()
{
    local in_op=${1}

    local op selected

    for op in load save clear
    do
	selected=$(get-selected-option ${op} "${in_op}")
	echo -n "<option value='${op}'${selected}>${op}</option>"
    done
}

show-filter-rweb-custom-form()
{
    local width=600
    local target_div_id='waf-custom-rules'
    local state new_state field_state checked

    itemWidth[0]=35
    itemWidth[1]=65

    itemTitle[0]="Site Name"
    itemTitle[1]="Operation"
    itemTitle[2]="Protocol"
    itemTitle[3]="File Server"
    itemTitle[4]="File Path"
    itemTitle[5]="Save New?"

    itemID[0]="site_name"
    itemID[1]="operation"
    itemID[2]="protocol"
    itemID[3]="server"
    itemID[4]="filename"
    itemID[5]="new"

    local file_servers=$(show-file-servers 'cur' ${VALUES[3]})
    test -n "${RWEB_SITE_LIST}" -a -n "${file_servers}" || state=disabled
    test "${ATTRIBUTES[5]}" != new || checked=' checked'

    local operation=${VALUES[1]}
    case ${operation} in
	clear)
	    field_state="disabled"
	    new_state="disabled"
	    ;;
	load|'')
	    new_state="disabled"
	    ;;
	*)
	    ;;
    esac
    itemState[2]=${field_state}
    itemState[3]=${field_state}
    itemState[4]=${field_state}
    itemState[5]=${new_state}

    blankItemContent[0]="$(show-site-select1 '' ${VALUES[0]})"
    blankItemContent[1]="$(print-operation ${operation})"
    blankItemContent[2]="$(show-file-protocol1 ${VALUES[2]:1})"
    blankItemContent[3]=${file_servers}
    blankItemContent[4]="type='text' size='32' maxlength='128' value='${VALUES[4]}'"
    blankItemContent[5]="${checked}"

    checkItem[4]=printable

    itemForm[0]="select"
    itemForm[1]="select"
    itemForm[2]="select"
    itemForm[3]="select"
    itemForm[5]="check"

    itemData[0]="data-action='waf-rweb-custom-show-rules' data-page='/${GUI_DIR_NAME}/waf-rweb-custom-print.${GUI_EXT_NAME}' data-target-id='${target_div_id}'>"
    itemData[1]="data-action='waf-rweb-custom-operation-select' data-operation-id='operation' data-protocol-id='protocol' data-server-id='server' data-filename-id='filename' data-mode='new'"

    shortcutMenuItem[0]="access-file"
    shortcutMenuTitle[0]="File Servers"

    shortcutMenuItem[1]="rweb-site"
    shortcutMenuTitle[1]="Add rWeb"

    show-title "WAF Custom Rules" "${state}" "access waf password"
    show-form "${width}" "${state}" show-waf-rules ${target_div_id}

    echo "<div data-init-show-waf-rules data-page='/${GUI_DIR_NAME}/waf-rweb-custom-print.${GUI_EXT_NAME}' data-target-id='${target_div_id}' hidden></div>"
}

# Main()

show-filter-rweb-custom-form
