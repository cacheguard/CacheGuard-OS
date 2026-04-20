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

show-tls-ca-cert()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    local tls_ca=${1}
    local content_id=${2}

    echo "<div style='clear:left;'></div><br />"
    echo "<div class='table-title'>The TLS object</div>"
    echo "<div id='${content_id}'></div>"

    call-js-function "printTLSCA( '/${GUI_DIR_NAME}/tls-print.${GUI_EXT_NAME}?ca:${tls_ca}+certificate', '${content_id}' );"
}

show-tls-ca-third-load-form()
{
    local get_args=${1}
    local tls_ca=$(get-arg-value "${get_args}" key)

    if test -z "${tls_ca}" ; then
	redirect-page "tls-ca-third"
	return 0
    fi
    
    local width state
    local content_id="tls_ca_content"

    itemWidth[0]=30
    itemWidth[1]=70

    itemTitle[0]="Hidden"
    itemTitle[1]="CA Identifier"
    itemTitle[2]="Protocol"
    itemTitle[3]="File Server"
    itemTitle[4]="File Path"

    itemID[0]="tls_ca"
    itemID[1]="not_posted"
    itemID[2]="protocol"
    itemID[3]="server"
    itemID[4]="filename"

    local file_servers=$(show-file-servers 'cur' ${VALUES[2]})
    test -n "${file_servers}" || state=disabled

    blankItemContent[0]="value='${tls_ca}'"
    blankItemContent[1]="${tls_ca}"
    blankItemContent[2]="$(show-file-protocol1 ${VALUES[1]:1})"
    blankItemContent[3]=${file_servers}
    blankItemContent[4]="type='text' size='48' maxlength='128' value='${VALUES[3]}'"

    checkItem[4]=printable

    itemForm[0]="hidden"
    itemForm[1]="text"
    itemForm[2]="select"
    itemForm[3]="select"
    
    shortcutMenuItem[0]="access-file"
    shortcutMenuItem[1]="password-file"
    shortcutMenuTitle[0]="File Servers"
    shortcutMenuTitle[1]="Accounts"

    show-title "Import Other CA Certificate" "${state}" "admin access password sslmediate tls"
    show-shortcuts-menu
    show-form "${width}" "${state}" "show-tls-ca-cert ${tls_ca} ${content_id}"
}

# Main()

show-tls-ca-third-load-form "${@}"
