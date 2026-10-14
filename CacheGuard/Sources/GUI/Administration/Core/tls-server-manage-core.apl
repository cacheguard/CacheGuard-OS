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

OPERATION_VALUE=${VALUES[2]}

if test "${REQUEST_METHOD}" == POST ; then
    case ${OPERATION_VALUE} in
	load|save)
	    COMPONENT_VALUE=${VALUES[1]}
	    PROTOCOL_VALUE=${VALUES[3]:1}
	    FILE_SERVER_VALUE=${VALUES[4]}
	    FILENAME_VALUE=${VALUES[5]}
	    DAYS_VALUE=${VALUES[6]}
	    test -z "${VALUES[7]}" || OCSP_VALUE=" checked"
	    ;;
	upload)
	    COMPONENT_VALUE=${VALUES[1]}
	    PROTOCOL_VALUE=${VALUES[3]:1}
	    DAYS_VALUE=${VALUES[5]}

	    test "${COMPONENT_VALUE}" == 'csr' || CSR_STATE=' disabled'
	    test -z "${VALUES[6]}" || OCSP_VALUE=" checked"
	    ;;
	download)
	    FILENAME_VALUE=${VALUES[4]}
	    ;;
	*)
	    unset OPERATION_VALUE
	    ;;
    esac
else
    COMPONENT_VALUE='certificate'
    CSR_STATE=' disabled'
fi

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

    echo "<div class='core-form'>"
    echo "<div class='table-title'>The TLS object</div>"
    echo "<div id='${content_id}'></div>"

    echo "<div data-init-tls-component-select data-component-id='${component_id}' data-operation-id='${operation_id}' data-days-id='${days_id}' data-ocsp-id='${ocsp_id}' data-page='/${GUI_DIR_NAME}/tls-print.${GUI_EXT_NAME}?server:${tls}' data-content-id='${content_id}' hidden></div>"
    echo "</div>"
}

show-manage-file-server-form()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    test -n "${3}" || return 3
    test -n "${4}" || return 4
    test -n "${5}" || return 5
    test -n "${6}" || return 6
    test -n "${7}" || return 7
    test -n "${8}" || return 8
    local tls=${1}
    local component_id=${2}
    local operation_id=${3}
    local protocol_id=${4}
    local filename_id=${5}
    local days_id=${6}
    local ocsp_id=${7}
    local content_id=${8}

    local state width

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
    itemID[4]="${protocol_id}"
    itemID[5]="server"
    itemID[6]="${filename_id}"
    itemID[7]="${days_id}"
    itemID[8]="${ocsp_id}"

    local file_servers=$(show-file-servers 'cur' ${FILE_SERVER_VALUE})
    test -n "${file_servers}" || state=disabled

    blankItemContent[0]="value='${tls}'"
    blankItemContent[1]="<a href='/${GUI_DIR_NAME}/tls-server-generate.${GUI_EXT_NAME}?key:${tls}'><img  src='${IMAGE_DIR}/tls-server-generate.png' title='Regenerate the Certificate' /> ${tls}</a>"
    blankItemContent[2]="$(show-tls-component-list ${COMPONENT_VALUE})"
    blankItemContent[3]="$(show-file-operation "${OPERATION_VALUE}")"
    blankItemContent[4]="$(show-file-protocol1 ${PROTOCOL_VALUE})"
    blankItemContent[5]=${file_servers}
    blankItemContent[6]="type='text' size='32' maxlength='128' value='${FILENAME_VALUE}'"
    blankItemContent[7]="type='text' size='8' maxlength='8' value='${DAYS_VALUE}'"
    blankItemContent[8]="type='checkbox'${OCSP_VALUE}"

    checkItem[6]=printable
    checkItem[7]=digit

    itemForm[0]="hidden"
    itemForm[1]="text"
    itemForm[2]="select"
    itemForm[3]="select"
    itemForm[4]="select"
    itemForm[5]="select"

    itemData[2]="data-action='tls-component' data-component-id='${component_id}' data-operation-id='${operation_id}' data-days-id='${days_id}' data-ocsp-id='${ocsp_id}' data-url='/${GUI_DIR_NAME}/tls-print.${GUI_EXT_NAME}?server:${tls}' data-content-id='${content_id}'"
    itemData[3]="data-action='tls-operation' data-component-id='${component_id}' data-operation-id='${operation_id}' data-days-id='${days_id}' data-ocsp-id='${ocsp_id}'"

    shortcutMenuItem[0]="access-file"
    shortcutMenuItem[1]="password-file"
    shortcutMenuTitle[0]="File Servers"
    shortcutMenuTitle[1]="Accounts"

    show-title "Load/Save Server TLS" "${state}" "access password rweb tls"

    echo "<div class='core-form'>"
    echo "<div class='table-title'>Load & Save via File Server</div>"
    echo "</div>"

    show-form "${width}" "${state}"
}

show-manage-upload-form()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    test -n "${3}" || return 3
    test -n "${4}" || return 4
    test -n "${5}" || return 5
    test -n "${6}" || return 6
    test -n "${7}" || return 7
    test -n "${8}" || return 8
    local tls=${1}
    local component_id=${2}
    local operation_id=${3}
    local protocol_id=${4}
    local filename_id=${5}
    local days_id=${6}
    local ocsp_id=${7}
    local content_id=${8}

    local form_id='upload-form'
    local button_id='upload-button'
    local csr_state

    echo "<div class='core-form'>"
    echo "<div class='table-title'>Upload form Workstation</div>"

    echo "<form name='${form_id}' id='${form_id}' action='/${GUI_DIR_NAME}/submit-tls-server-manage.${GUI_EXT_NAME}?key:${tls}' method='post' enctype='multipart/form-data'>"
    echo "<input type='hidden' name='${GUI_CSRF_ATTRIBUTE}' value='${TOKEN}' />"
    echo "<input type='hidden' name='tls' value='${tls}' />"

    echo "<table class='highlight-form'>"

    echo "<tr>"
    echo "<td>TLS Component</td>"
    echo "<td>"

    echo "<select name='${component_id}' id='${component_id}' data-action='tls-component' data-component-id='${component_id}' data-operation-id='${operation_id}' data-days-id='${days_id}' data-ocsp-id='${ocsp_id}' data-url='/${GUI_DIR_NAME}/tls-print.${GUI_EXT_NAME}?server:${tls}' data-content-id='${content_id}'>"
    show-tls-component-list ${COMPONENT_VALUE}
    echo "</select>"
    echo "<input type='hidden' name='${operation_id}' id='${operation_id}' value='upload' />"
    echo "<input type='hidden' name='${protocol_id}' value='_web' />"
    echo "</td>"
    echo "</tr>"

    echo "<tr>"
    echo "<td>Source File Path</td>"
    echo "<td>"
    echo "<input type='file' name='${filename_id}' />"
    echo "</td>"
    echo "<td align='right'>"
    echo "<button id='${button_id}' type='submit' class='form-button compact' data-post-form-id='${form_id}' data-button='submit' data-action='__nil__'>"
    echo "<div data-init-post-content data-button-id='${button_id}' data-form-id='${form_id}' data-confirmation='false' hidden></div>"
    echo "UPLOAD <img src='${IMAGE_DIR}/up.png' align='middle' />"
    echo "</button>"
    echo "</td>"
    echo "</tr>"

    echo "<tr>"
    echo "<td>Days Validity</td>"
    echo "<td><input name='${days_id}' id='${days_id}' type='text' autocomplete='off' size='8' maxlength='8' value='${DAYS_VALUE}'${CSR_STATE} /></td>"
    echo "</tr>"

    echo "<tr>"
    echo "<td><label for='${ocsp_id}'>Use OCSP</label></td>"
    echo "<td><input name='${ocsp_id}' id='${ocsp_id}' type='checkbox'${OCSP_VALUE}${CSR_STATE} /></td>"
    echo "</tr>"

    echo "</table>"
    echo "</form>"
    echo "</div>"    
}

show-manage-download-form()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    test -n "${3}" || return 3
    test -n "${4}" || return 4
    local tls=${1}
    local component_id=${2}
    local filename_id=${3}
    local content_id=${4}

    local form_id='download-form'
    local button_id='download-button'

    echo "<div class='core-form'>"
    echo "<div class='table-title'>Download to Workstation</div>"

    echo "<form name='${form_id}' id='${form_id}' action='/${GUI_DIR_NAME}/submit-tls-server-manage.${GUI_EXT_NAME}?key:${tls}' method='post' data-download='true'>"
    echo "<input type='hidden' name='${GUI_CSRF_ATTRIBUTE}' value='${TOKEN}' />"
    echo "<input type='hidden' name='tls' value='${tls}' />"

    echo "<table class='highlight-form'>"

    echo "<tr>"
    echo "<td>TLS Component</td>"
    echo "<td>"
    echo "<select name='${component_id}' id='${component_id}' data-action='print-tls' data-component-id='${component_id}' data-url='/${GUI_DIR_NAME}/tls-print.${GUI_EXT_NAME}?server:${tls}' data-content-id='${content_id}'>"
    show-tls-component-list
    echo "</select>"
    echo "<input type='hidden' name='${operation_id}' value='download' />"
    echo "<input type='hidden' name='${protocol_id}' value='_web' />"
    echo "</td>"
    echo "<td></td>"
    echo "</tr>"

    echo "<tr>"
    echo "<td>Target File Name</td>"
    echo "<td>"
    echo "<input type='text' name='${filename_id}' autocomplete='off' size='24' maxlength='32' value='${FILENAME_VALUE}' />"
    echo "</td>"
    echo "<td align='right'>"
    echo "<button id='${button_id}' type='submit' class='form-button compact'>"
    echo "DOWNLOAD <img src='${IMAGE_DIR}/down.png' align='middle' />"
    echo "</button>"
    echo "</td>"
    echo "</tr>"

    echo "</table>"
    echo "</form>"
    echo "</div>"
}

show-forms()
{
    local get_args=${1}
    local tls=$(get-arg-value "${get_args}" key)

    if test -z "${tls}" ; then
	redirect-page "tls-server"
	return 0
    fi

    local component_id="tls_component"
    local operation_id="operation"
    local protocol_id="protocol"
    local filename_id="filename"
    local days_id="days"
    local ocsp_id="ocsp"
    local content_id="tls_content"

    show-manage-file-server-form ${tls} \
				 ${component_id} \
				 ${operation_id} \
				 ${protocol_id} \
				 ${filename_id} \
				 ${days_id} \
				 ${ocsp_id} \
				 ${content_id}

    local TOKEN=$(get-auth-token)

    show-manage-upload-form ${tls} \
			    ${component_id}u \
			    ${operation_id}u \
			    ${protocol_id} \
			    ${filename_id} \
			    ${days_id}u \
			    ${ocsp_id}u \
			    ${content_id}

    show-manage-download-form ${tls} ${component_id}d ${filename_id} ${content_id}

    show-tls-component ${tls} ${component_id} ${operation_id} ${days_id} ${ocsp_id} ${content_id}
}

# Main()

show-forms "${@}"
