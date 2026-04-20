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

show-tls-component-list()
{
    local in_component=${1}
    local component selected

    for component in certificate key csr
    do
	selected=$(get-selected-option ${component} "${in_component}")
	echo -n "<option value='${component}'${selected}>${component}</option>"
    done
}

show-tls-component()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    test -n "${3}" || return 3
    test -n "${4}" || return 4
    test -n "${5}" || return 5
    test -n "${6}" || return 6
    local tls=${1}
    local component_id=${2}
    local operation_id=${3}
    local days_id=${4}
    local ocsp_id=${5}
    local content_id=${6}

    echo "<div style='clear:left;'></div><br />"
    echo "<div class='table-title'>The TLS object</div>"
    echo "<div id='${content_id}'></div>"

    call-js-function "TLSComponentSelectCB( '${component_id}', '${operation_id}', '${days_id}', '${ocsp_id}', '/${GUI_DIR_NAME}/tls-print.${GUI_EXT_NAME}?server:${tls}', '${content_id}' )"
}

show-tls-manage-form()
{
    local get_args=${1}
    local tls=$(get-arg-value "${get_args}" key)

    if test -z "${tls}" ; then
	redirect-page "tls-server"
	return 0
    fi

    local state width ocsp

    local component_id="tls_component"
    local content_id="tls_content"
    local operation_id="operation"
    local days_id="days"
    local ocsp_id="ocsp"

    itemWidth[0]=30
    itemWidth[1]=70
    
    itemTitle[0]="Hidden"
    itemTitle[1]="TLS Identifier"
    itemTitle[2]="TLS Component"
    itemTitle[3]="Operation"
    itemTitle[4]="Protocol"
    itemTitle[5]="File Server"
    itemTitle[6]="File Path"
    itemTitle[7]="Days Validity"
    itemTitle[8]="Use OCSP"

    itemID[0]="tls"
    itemID[1]="not_posted"
    itemID[2]="${component_id}"
    itemID[3]="${operation_id}"
    itemID[4]="protocol"
    itemID[5]="server"
    itemID[6]="filename"
    itemID[7]="${days_id}"
    itemID[8]="${ocsp_id}"

    if test -n "${VALUES[7]}" ; then
	ocsp=" checked"
    else
	unset ocsp
    fi

    local file_servers=$(show-file-servers 'cur' ${VALUES[4]})
    test -n "${file_servers}" || state=disabled

    blankItemContent[0]="value='${tls}'"
    blankItemContent[1]="${tls}"
    blankItemContent[2]="$(show-tls-component-list ${VALUES[1]})"
    blankItemContent[3]="$(show-file-operation "${VALUES[2]}")"
    blankItemContent[4]="$(show-file-protocol1 ${VALUES[3]:1})"
    blankItemContent[5]=${file_servers}
    blankItemContent[6]="type='text' size='48' maxlength='128' value='${VALUES[5]}'"
    blankItemContent[7]="type='text' size='8' maxlength='8' value='${VALUES[6]}'"
    blankItemContent[8]="type='checkbox'${ocsp}"

    checkItem[6]=printable
    checkItem[7]=digit

    itemForm[0]="hidden"
    itemForm[1]="text"
    itemForm[2]="select"
    itemForm[3]="select"
    itemForm[4]="select"
    itemForm[5]="select"

    itemFormSelectCB[2]="TLSComponentSelectCB( '${component_id}', '${operation_id}', '${days_id}', '${ocsp_id}', '/${GUI_DIR_NAME}/tls-print.${GUI_EXT_NAME}?server:${tls}', '${content_id}' );"
    itemFormSelectCB[3]="TLSOperationSelectCB( '${component_id}', '${operation_id}', '${days_id}', '${ocsp_id}' );"

    shortcutMenuItem[0]="access-file"
    shortcutMenuItem[1]="password-file"
    shortcutMenuTitle[0]="File Servers"
    shortcutMenuTitle[1]="Accounts"

    show-title "Load/Save Server TLS" "${state}" "access password rweb tls"
    show-shortcuts-menu

    show-form "${width}" "${state}" "show-tls-component ${tls} ${component_id} ${operation_id} ${days_id} ${ocsp_id} ${content_id}"
}

# Main()

show-tls-manage-form "${@}"
