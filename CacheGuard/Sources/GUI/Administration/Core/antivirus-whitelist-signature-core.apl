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

print-operation()
{
    local file_servers=${1}
    local in_op=${2}

    local selected
    local op ops

    if test -n "${file_servers}" ; then
	ops="load clear"
    else
	ops="clear"
    fi

    for op in ${ops}
    do
	if test ${op} == "${in_op}" ; then
	    selected=" selected"
	else
	    unset selected
	fi
	echo -n "<option value='${op}'${selected}>${op}</option>"
    done
}

show-av-wl-load-form()
{
    local width
    local field_state operation

    local operation_id='operation'
    local protocol_id='protocol'
    local server_id='server'
    local filename_id='filename'

    itemTitle[0]="Operation"
    itemTitle[1]="Protocol"
    itemTitle[2]="File Server"
    itemTitle[3]="File Path"

    itemID[0]="${operation_id}"
    itemID[1]="${protocol_id}"
    itemID[2]="${server_id}"
    itemID[3]="${filename_id}"

    local file_servers=$(show-file-servers 'cur' ${VALUES[2]})

    if test "${REQUEST_METHOD}" == POST ; then
	operation=${VALUES[0]}
	case ${operation} in
	    clear)
		field_state=disabled
		;;
	    load)
		field_state=enabled
		;;
	    *)
		;;
	esac
    else
	test -n "${file_servers}" || field_state=disabled
    fi

    itemState[1]=${field_state}
    itemState[2]=${field_state}
    itemState[3]=${field_state}

    blankItemContent[0]="$(print-operation "${file_servers}" ${operation})"
    blankItemContent[1]="$(show-file-protocol1 ${VALUES[1]:1})"
    blankItemContent[2]=${file_servers}
    blankItemContent[3]="type='text' size='48' maxlength='128' value='${VALUES[3]}'"

    checkItem[3]=printable

    itemForm[0]="select"
    itemForm[1]="select"
    itemForm[2]="select"

    itemFormSelectCB[0]="antivirusWhitelistOperationSelectCB( '${operation_id}', '${protocol_id}', '${server_id}', '${filename_id}' );"

    shortcutMenuItem[0]="access-file"
    shortcutMenuItem[1]="password-file"
    shortcutMenuTitle[0]="File Servers"
    shortcutMenuTitle[1]="Accounts"

    show-title "Load white list of virus names" enabled "access antivirus password"
    show-shortcuts-menu

    show-form "${width}" enabled
}

# Main()

show-av-wl-load-form "${@}"
