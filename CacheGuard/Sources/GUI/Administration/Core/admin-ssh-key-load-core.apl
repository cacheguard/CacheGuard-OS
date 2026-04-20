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

show-ssh-key()
{
    test -n "${1}" || return 1
    local key_id=${1}

    echo "<div style='clear:left;'></div><br />"

    local file state

    if test -f ${TMP_DIR}/${LOADED}.${SSH_KEY}.${key_id} ; then
	file=${TMP_DIR}/${LOADED}.${SSH_KEY}.${key_id}
	state="<span style='color:FireBrick;'>[loaded]</span>"
    elif
	test -f ${SSH_PUBLIC_KEY_DIR}/${key_id} ; then
	file=${SSH_PUBLIC_KEY_DIR}/${key_id}
	state='[active]'
    else
	state='[empty]'
    fi

    echo "<div class='table-title' style='width:100%;'>The Public SSH Key ${state}</div>"
    show-public-ssh-key ${file}
}

show-ssh-key-load-form()
{
    local get_args=${1}
    local key_id=$(get-arg-value "${get_args}" key)

    if test -z "${key_id}" ; then
	redirect-page "admin-ssh-key"
	return 0
    fi

    local state width=550

    local operation_id="operation"

    itemWidth[0]=30
    itemWidth[1]=70

    itemTitle[0]="Hidden"
    itemTitle[1]="SSH Key Id"
    itemTitle[2]="Protocol"
    itemTitle[3]="File Server"
    itemTitle[4]="File Path"

    itemID[0]="key_id"
    itemID[1]="not_posted"
    itemID[2]="protocol"
    itemID[3]="server"
    itemID[4]="filename"

    local file_servers=$(show-file-servers 'cur' ${VALUES[2]})
    test -n "${file_servers}" || state=disabled

    blankItemContent[0]="value='${key_id}'"
    blankItemContent[1]="${key_id}"
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

    show-title "Load SSH Keys" "${state}" "admin access"
    show-shortcuts-menu

    show-form "${width}" "${state}" "show-ssh-key ${key_id}"
}

# Main()

show-ssh-key-load-form "${@}"
