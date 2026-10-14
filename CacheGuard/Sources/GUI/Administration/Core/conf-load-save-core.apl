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

print-conf-version()
{
    local in_version=${1}

    local version selected

    for version in current new
    do
	if test ${version} == "${in_version}" ; then
	    selected=' selected'
	else
	    unset selected
	fi
	echo -n "<option value='${version}'${selected}>${version}</option>"
    done
}

show-conf-load-save-form()
{
    local state width

    itemWidth[0]=40
    itemWidth[1]=60

    itemTitle[0]="Operation"
    itemTitle[1]="Protocol"
    itemTitle[2]="Configuration Version"
    itemTitle[3]="File Server"
    itemTitle[4]="File Path"

    itemID[0]="operation"
    itemID[1]="protocol"
    itemID[2]="version"
    itemID[3]="server"
    itemID[4]="filename"

    local operation protocol
    local version server filename
    local protocols="sftp ftp tftp"

    if test "${REQUEST_METHOD}" == POST ; then
	operation="${VALUES[0]}"

	case ${operation} in
	    load|save)

		protocol="${VALUES[1]:1}"

		for ((i=2 ; i<ATTRIBUTE_NB ; i++))
		do
		    case ${ATTRIBUTES[${i}]} in
			version)
			    version="${VALUES[${i}]}"
			    ;;
			server)
			    server="${VALUES[${i}]}"
			    ;;
			filename)
			    filename="${VALUES[${i}]}"
			    ;;
			*)
			    ;;
		    esac
		done
		;;	    
	    *)
		;;
	esac
    fi

    case "${operation}" in
	load|'')
	    itemState[2]="disabled"
	    ;;
	save)
	    ;;
	*)
	    ;;
    esac

    local file_servers=$(show-file-servers 'cur' ${server})
    test -n "${file_servers}" || state=disabled

    blankItemContent[0]=$(show-file-operation ${operation})
    blankItemContent[1]=$(show-file-protocol1 "${protocol}" "${protocols}")
    blankItemContent[2]=$(print-conf-version ${operation} ${version})
    blankItemContent[3]=${file_servers}
    blankItemContent[4]="type='text' size='48' maxlength='128' value='${filename}'"

    checkItem[4]=printable

    itemForm[0]="select"
    itemForm[1]="select"
    itemForm[2]="select"
    itemForm[3]="select"

    itemData[0]="data-action='configuration-load-save' data-operation='operation' data-version='version' data-server='server' data-filename='filename'"
    itemData[1]=${itemData[0]}

    shortcutMenuItem[0]="access-file"
    shortcutMenuItem[1]="password-file"
    shortcutMenuItem[2]="file-operation"

    shortcutMenuTitle[0]="File Servers"
    shortcutMenuTitle[1]="Accounts"
    shortcutMenuTitle[2]="File Operations"

    show-title "Load Save Configuration" "${state}" "access conf file password"

    echo "<div class='core-form'>"
    echo "<div class='table-title'>Load & Save via File Server</div>"
    echo "</div>"

    show-form "${width}" ${state}
}

show-conf-upload-form()
{
    local form_id='upload-form'
    local button_id='upload-button'

    echo "<div class='core-form'>"
    echo "<div class='table-title'>Upload form Workstation</div>"

    echo "<form name='${form_id}' id='${form_id}' action='/${GUI_DIR_NAME}/submit-conf-load-save.${GUI_EXT_NAME}' method='post' enctype='multipart/form-data'>"
    echo "<input type='hidden' name='${GUI_CSRF_ATTRIBUTE}' value='${TOKEN}' />"
    echo "<input type='hidden' name='operation' value='upload' />"
    echo "<input type='hidden' name='protocol' value='_web' />"

    echo "<table class='highlight-form'>"

    echo "<tr>"
    echo "<td>Source File Path</td>"
    echo "<td>"
    echo "<input type='file' name='filename' />"
    echo "</td>"
    echo "<td align='right'>"
    echo "<button id='${button_id}' type='submit' class='form-button compact' data-post-form-id='${form_id}' data-button='submit' data-action='__nil__'>"
    echo "<div data-init-post-content data-button-id='${button_id}' data-form-id='${form_id}' data-confirmation='false' hidden></div>"
    echo "UPLOAD <img src='${IMAGE_DIR}/up.png' align='middle' />"
    echo "</button>"
    echo "</td>"
    echo "</tr>"

    echo "</table>"
    echo "</form>"
    echo "</div>"
}

show-conf-download-form()
{
    local form_id='download-form'
    local button_id='download-button'
    local version filename

    if test "${REQUEST_METHOD}" == POST ; then
	local operation="${VALUES[0]}"

	case ${operation} in
	    download)
		version=${VALUES[2]}
		filename=${VALUES[3]}
		;;
	    *)
		;;
	esac
    fi

    echo "<div class='core-form'>"
    echo "<div class='table-title'>Download to Workstation</div>"

    echo "<form name='${form_id}' id='${form_id}' action='/${GUI_DIR_NAME}/submit-conf-load-save.${GUI_EXT_NAME}' method='post' data-download='true'>"
    echo "<input type='hidden' name='${GUI_CSRF_ATTRIBUTE}' value='${TOKEN}' />"

    echo "<input type='hidden' name='operation' value='download' />"
    echo "<input type='hidden' name='protocol' value='_web' />"

    echo "<table class='highlight-form'>"

    echo "<tr>"
    echo "<td>Configuration Version</td>"
    echo "<td>"
    echo "<select name='version'>"
    print-conf-version ${version}
    echo "</select>"
    echo "</td>"
    echo "<td></td>"
    echo "</tr>"

    echo "<tr>"
    echo "<td>Target File Name</td>"
    echo "<td>"
    echo "<input type='text' name='filename' size='24' maxlength='32' value='${filename}' />"
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
    show-conf-load-save-form

    local TOKEN=$(get-auth-token)

    show-conf-upload-form
    show-conf-download-form
}

# Main()

show-forms
