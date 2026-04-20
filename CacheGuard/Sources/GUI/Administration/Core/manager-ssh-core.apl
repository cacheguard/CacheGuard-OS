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

show-manager-ssh-operation()
{
    show-list-options "generate load save" ${1}
}

show-manager-key-type()
{
    show-list-options "public private" ${1}
}

show-manager-public-ssh()
{
    echo "<div style='clear:left;'></div><br />"

    local public_file public_state private_state

    if test -f ${TMP_DIR}/${LOADED}.manager.${SSH_KEY}.public ; then
	public_file=${TMP_DIR}/${LOADED}.manager.${SSH_KEY}.public
	public_state="<span style='color:FireBrick;'>[loaded]</span>"
    elif
	test -f ${ADMIN_DIR}/.ssh/id_rsa.pub ; then
	public_file=${ADMIN_DIR}/.ssh/id_rsa.pub
	public_state='[active]'
    else
	public_state='[empty]'
    fi

    if test -f ${TMP_DIR}/${LOADED}.manager.${SSH_KEY}.private ; then
	private_file=${TMP_DIR}/${LOADED}.manager.${SSH_KEY}.private
	private_state="<span style='color:FireBrick;'>[loaded]</span>"
    elif
	test -f ${ADMIN_DIR}/.ssh/id_rsa ; then
	private_file=${ADMIN_DIR}/.ssh/id_rsa
	private_state='[active]'
    else
	private_state='[empty]'
    fi

    echo "<div class='table-title' style='width:100%;'>Manager's Private SSH Key ${private_state} (<i>hidden for security reasons</i>)</div>"
    echo '<br />'
    echo "<div class='table-title' style='width:100%;'>Manager's Public SSH Key ${public_state}</div>"
    show-public-ssh-key ${public_file}
}

show-manager-ssh-key-form()
{
    local state width=550

    local operation_id="operation"
    local key_type_id="key_type"
    local protocol_id="protocol"
    local server_id="server"
    local filename_id="filename"
    local field_state

    itemWidth[0]=30
    itemWidth[1]=70

    itemTitle[0]="Operation"
    itemTitle[1]="Key Type"
    itemTitle[2]="Protocol"
    itemTitle[3]="File Server"
    itemTitle[4]="File Path"

    itemID[0]=${operation_id}
    itemID[1]=${key_type_id}
    itemID[2]=${protocol_id}
    itemID[3]=${server_id}
    itemID[4]=${filename_id}

    local file_servers=$(show-file-servers 'cur' ${VALUES[3]})

    blankItemContent[0]=$(show-manager-ssh-operation ${VALUES[0]})
    blankItemContent[1]=$(show-manager-key-type ${VALUES[1]})
    blankItemContent[2]="$(show-file-protocol1 ${VALUES[2]:1})"
    blankItemContent[3]=${file_servers}
    blankItemContent[4]="type='text' size='48' maxlength='128' value='${VALUES[4]}'"

    checkItem[4]=printable

    itemForm[0]="select"
    itemForm[1]="select"
    itemForm[2]="select"
    itemForm[3]="select"

    if test "${REQUEST_METHOD}" == POST ; then
	operation=${VALUES[0]}
	case ${operation} in
 	    generate)
		field_state=disabled
		;;
	    *)
		test -n "${file_servers}" || field_state=disabled
		;;
	esac
    else
	field_state=disabled
    fi

    itemState[1]=${field_state}
    itemState[2]=${field_state}
    itemState[3]=${field_state}
    itemState[4]=${field_state}

    itemFormSelectCB[0]="SSHOperationSelectCB( '${operation_id}', '${key_type_id}', '${protocol_id}', '${server_id}', '${filename_id}' );"

    shortcutMenuItem[0]="access-file"
    shortcutMenuItem[1]="password-file"
    shortcutMenuTitle[0]="File Servers"
    shortcutMenuTitle[1]="Accounts"

    show-title "Manager Client SSH Keys" "${state}" "manager"
    show-shortcuts-menu

    show-form "${width}" "${state}" "show-manager-public-ssh"
}

# Main()

show-manager-ssh-key-form "${@}"
