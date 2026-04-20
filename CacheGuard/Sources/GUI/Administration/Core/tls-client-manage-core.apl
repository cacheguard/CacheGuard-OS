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

show-tls-client-component-list()
{
    local in_component=${1}
    local component selected

    for component in certificate key pkcs12 pfx password
    do
	selected=$(get-selected-option ${component} "${in_component}")
	echo -n "<option value='${component}'${selected}>${component}</option>"
    done
}

show-tls-client-component()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    test -n "${3}" || return 3
    local tls=${1}
    local component_id=${2}
    local content_id=${3}

    echo "<div style='clear:left;'></div><br />"
    echo "<div class='table-title'>The TLS object</div>"
    echo "<div id='${content_id}'></div>"

    call-js-function "printTLS( '/${GUI_DIR_NAME}/tls-print.${GUI_EXT_NAME}?client:${tls}', '${component_id}', '${content_id}' )"
}

show-tls-load-save-form()
{
    local get_args=${1}
    local tls=$(get-arg-value "${get_args}" key)

    if test -z "${tls}" ; then
	redirect-page "tls-client"
	return 0
    fi

    local component_id="tls_component"
    local content_id="tls_content"
    local operation_id="operation"

    local state
    local width
    
    itemWidth[0]=30
    itemWidth[1]=70

    itemTitle[0]="Hidden"
    itemTitle[1]="TLS ID"
    itemTitle[2]="TLS Component"
    itemTitle[3]="Operation"
    itemTitle[4]="Protocol"
    itemTitle[5]="File Server"
    itemTitle[6]="File Path"

    itemID[0]="tls"
    itemID[1]="not_posted"
    itemID[2]="${component_id}"
    itemID[3]="${operation_id}"
    itemID[4]="protocol"
    itemID[5]="server"
    itemID[6]="filename"

    local file_servers=$(show-file-servers 'cur' ${VALUES[4]})
    test -n "${file_servers}" || state=disabled

    blankItemContent[0]="value='${tls}'"
    blankItemContent[1]="${tls}"
    blankItemContent[2]="$(show-tls-client-component-list ${VALUES[1]})"
    blankItemContent[3]="$(show-file-operation "${VALUES[2]}")"
    blankItemContent[4]="$(show-file-protocol1 ${VALUES[3]:1})"
    blankItemContent[5]=${file_servers}
    blankItemContent[6]="type='text' size='48' maxlength='128' value='${VALUES[5]}'"

    checkItem[6]=printable

    itemForm[0]="hidden"
    itemForm[1]="text"
    itemForm[2]="select"
    itemForm[3]="select"
    itemForm[4]="select"
    itemForm[5]="select"

    itemFormSelectCB[2]="printTLS( '/${GUI_DIR_NAME}/tls-print.${GUI_EXT_NAME}?client:${tls}', '${component_id}', '${content_id}' );"

    shortcutMenuItem[0]="access-file"
    shortcutMenuItem[1]="password-file"
    shortcutMenuTitle[0]="File Servers"
    shortcutMenuTitle[1]="Accounts"

    show-title "Load/Save Client TLS" "${state}" "access password tls"
    show-shortcuts-menu
    show-form "${width}" "${state}" "show-tls-client-component ${tls} ${component_id} ${content_id}"
}

# Main()

show-tls-load-save-form "${@}"
