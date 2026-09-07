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

show-ca-component-list()
{
    local in_component=${1}
    local component selected

    for component in certificate key der
    do
	selected=$(get-selected-option ${component} "${in_component}")
	echo -n "<option value='${component}'${selected}>${component}</option>"
    done
}

show-ca-component()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    local component_id=${1}
    local content_id=${2}

    echo "<div class='table-title'>The TLS object</div>"
    echo "<div id='${content_id}'></div>"

    echo "<div data-init-print-tls data-page='/${GUI_DIR_NAME}/tls-print.${GUI_EXT_NAME}?ca:system' data-component-id='${component_id}' data-content-id='${content_id}' hidden></div>"
}

show-ca-system-manage-form()
{
    local component_id="ca_component"
    local content_id="ca_content"

    local state width
    local i=0 n=0

    itemWidth[0]=30
    itemWidth[1]=70

    local file_servers=$(show-file-servers 'cur' ${VALUES[3]})
    test -n "${file_servers}" || state=disabled

    if test ${APL_ROLE} == gateway ; then
	itemTitle[${i}]="CA Certificate Link"
	itemID[${i}]="ca_links"
	blankItemContent[${i}]="<a href='http://${SERVER_NAME}' target='_blank'>${SERVER_NAME}</a> (available from the internal interface)"
	itemForm[${i}]="text"
	((i++))
    fi

    itemTitle[${i}]="Generation Link"
    itemID[${i}]="generation_link"
    blankItemContent[${i}]="<a href='/${GUI_DIR_NAME}/tls-ca-system-generate.${GUI_EXT_NAME}'><img  src='${IMAGE_DIR}/tls-ca-system-generate.png' title='Regenerate the System CA Certificate' /> ${tls}</a>"
    itemForm[${i}]="text"
    ((i++))

    n=${i}

    itemTitle[${i}]="CA Component"
    itemData[${i}]="data-action='print-tls' data-url='/${GUI_DIR_NAME}/tls-print.${GUI_EXT_NAME}?ca:system' data-component-id='${component_id}' data-content-id='${content_id}'"
    ((i++))

    itemTitle[${i}]="Operation" ; ((i++))
    itemTitle[${i}]="Protocol" ; ((i++))
    itemTitle[${i}]="File Server" ; ((i++))
    itemTitle[${i}]="File Path" ; ((i++))

    i=${n}
    itemID[${i}]="${component_id}" ; ((i++))
    itemID[${i}]="operation" ; ((i++))
    itemID[${i}]="protocol" ; ((i++))
    itemID[${i}]="server" ; ((i++))
    itemID[${i}]="filename" ; ((i++))

    i=${n}
    blankItemContent[${i}]="$(show-ca-component-list ${VALUES[0]})" ; ((i++))
    blankItemContent[${i}]="$(show-file-operation ${VALUES[1]})" ; ((i++))
    blankItemContent[${i}]="$(show-file-protocol1 ${VALUES[2]:1})" ; ((i++))
    blankItemContent[${i}]=${file_servers} ; ((i++))

    blankItemContent[${i}]="type='text' size='32' maxlength='128' value='${VALUES[4]}'" ; ((i++))
    checkItem[${i}]=printable

    i=${n}
    itemForm[${i}]="select" ; ((i++))
    itemForm[${i}]="select" ; ((i++))
    itemForm[${i}]="select" ; ((i++))
    itemForm[${i}]="select" ; ((i++))

    shortcutMenuItem[0]="access-file"
    shortcutMenuItem[1]="password-file"
    shortcutMenuTitle[0]="File Servers"
    shortcutMenuTitle[1]="Accounts"

    show-title "System CA Management" "${state}" "access admin password sslmediate tls"
    show-form "${width}" "${state}" "show-ca-component ${component_id} ${content_id}"
}

# Main()

show-ca-system-manage-form "${@}"
