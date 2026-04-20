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

print-conf-state()
{
    local state selected

    for state in current new
    do
	if test ${state} == "${1}" ; then
	    selected=selected
	else
	    unset selected
	fi
	echo -n "<option value='${state}' ${selected}>${state}</option>"
    done
}

show-conf-save-form()
{
    local width

    local state

    itemWidth[0]=40
    itemWidth[1]=60

    itemTitle[0]="Operation"
    itemTitle[1]="Protocol"
    itemTitle[2]="Version"
    itemTitle[3]="File Server"
    itemTitle[4]="File Path"

    itemID[0]="operation"
    itemID[1]="protocol"
    itemID[2]="version"
    itemID[3]="server"
    itemID[4]="filename"

    local version server filename upload
    local protocols

    if test "${REQUEST_METHOD}" == POST ; then
	case "${ATTRIBUTES[0]}" in
	    operation)
		local operation="${VALUES[0]}"
		local protocol="${VALUES[1]:1}"

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

	    upload)
		check-csrf-cookie || logout-page
		local uploaded_filename="${UPLOADED_FILES[0]}"

		if test -n "${uploaded_filename}" -a -f "${ADMIN_TMP_DIR}/${uploaded_filename}" ; then
		    execute-command "conf inject ${uploaded_filename}"
                    rm -f "${ADMIN_TMP_DIR}/${uploaded_filename}"
		else
		    gen-gui-error 16
		fi
		show-post-errors
		;;
	    
	    *)
		;;
	esac
    else
	local operation="load"
	local protocol="sftp"
    fi

    case "${operation}" in
	load)
	    protocols="sftp ftp tftp"
	    itemState[2]="disabled"
	    ;;
	save)
	    protocols="web sftp ftp tftp"
	    ;;
	*)
	    ;;
    esac

    case "${protocol}" in
	web)
	    itemState[3]="disabled"
	    ;;
	ftp|sftp|tftp)
	    ;;
	*)
	    ;;
    esac

    local file_servers=$(show-file-servers 'cur' ${server})
    test -n "${file_servers}" || state=disabled

    blankItemContent[0]=$(show-file-operation ${operation})
    blankItemContent[1]=$(show-file-protocol1 "${protocol}" "${protocols}")
    blankItemContent[2]=$(print-conf-state ${version})
    blankItemContent[3]=${file_servers}
    blankItemContent[4]="type='text' size='48' maxlength='128' value='${filename}'"

    checkItem[4]=printable

    itemForm[0]="select"
    itemForm[1]="select"
    itemForm[2]="select"
    itemForm[3]="select"

    local cb="configurationLoadSaveSelectCB( 'operation', 'protocol', 'version', 'server', 'filename' );"
    itemFormSelectCB[0]=${cb}
    itemFormSelectCB[1]=${cb}

    shortcutMenuItem[0]="access-file"
    shortcutMenuItem[1]="password-file"
    shortcutMenuTitle[0]="File Servers"
    shortcutMenuTitle[1]="Accounts"

    show-title "Load Save Configuration" "${state}" "access conf file password"
    show-shortcuts-menu

    local token=$(get-auth-token)

    echo "<div class='core-form'>"
    echo "<form action='/${GUI_DIR_NAME}/conf-load-save.${GUI_EXT_NAME}' method='post' enctype='multipart/form-data'>"
    echo "<input type='hidden' name='${GUI_CSRF_ATTRIBUTE}' value='${token}' />"
    echo "<table class='highlight-form'>"
    echo "<tr>"
    echo "<td width='40%'>Local File</td>"
    echo "<td width='60%'>"
    echo "<input type='file' name='upload' style='margin:0;' />"
    echo "</td>"
    echo "</tr>"
    echo "</table>"
    echo "<button id='${UPLOAD_ID}' type='submit' class='submit' style='margin:0; margin-top:5px;'>"
    echo "UPLOAD <img src='${IMAGE_DIR}/upload.png' align='top' />&nbsp;"
    echo "</button>"
    echo "<div style='clear:left;'></div><br />"
    echo "</form>"
    echo "</div>"

    show-form "${width}" ${state}

    local src_filename="${DEFAULT_SHOSTNAME}.conf.${$}"
    local dst_filename=${VALUES[3]}
    test -z "${dst_filename}" || dst_filename=" ${dst_filename}"

    if test -f ${ADMIN_TMP_DIR}/${src_filename} ; then
	local href_id="do-download"
        echo "<a href='/${GUI_DIR_NAME}/conf-download.${GUI_EXT_NAME}?${src_filename}${dst_filename}' id='${href_id}'></a>"
        call-js-function "document.getElementById( '${href_id}' ).click( )"
    fi
}

# Main()

show-conf-save-form
