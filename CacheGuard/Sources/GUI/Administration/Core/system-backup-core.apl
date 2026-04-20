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

source system-backup-common.${GUI_EXT_NAME}

print-operation()
{
    local file_servers=${1}
    local in_op=${2}

    local op ops
    local selected

    if test -n "${file_servers}" ; then
	ops="load create save clear"
    else
	ops="clear create"
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

show-system-backup-log()
{
    echo "<div class='core-form' style='margin-top:0;'>"
    refresh-buttons "update_system_backup( 1 )"
    echo "<div style='clear:left;'></div><br />"
    echo "<span class='table-title'>Last system backup report&nbsp;</span>"
    echo "<div id='${AUTO_REPORT_ID}' class='log-report'></div>"
    echo "</div>"
}

show-system-backup-form()
{
    local width
    local field_state operation

    local progress_id='progress'
    local operation_id='operation'
    local protocol_id='protocol'
    local server_id='server'
    local filename_id='filename'

    itemWidth[0]=35
    itemWidth[1]=65

    itemTitle[0]="Last backup date"
    itemTitle[1]="Transfer Progression"
    itemTitle[2]="Operation"
    itemTitle[3]="Protocol"
    itemTitle[4]="File Server"
    itemTitle[5]="File Path"

    itemID[0]="date"
    itemID[1]="${progress_id}"
    itemID[2]="${operation_id}"
    itemID[3]="${protocol_id}"
    itemID[4]="${server_id}"
    itemID[5]="${filename_id}"

    local backup_file="${TMP_DIR}/${SAVED}.backup"
    local file_servers=$(show-file-servers 'cur' ${VALUES[2]})

    if test \
	   -f  ${backup_file}.*.tar -o \
	   -f ${backup_file}.*.tar.gz -o \
	   "${VALUES[0]}" == create ; then
	local date="In progress..."
    else
	local date=$(get-file-modification-date ${backup_file})
    fi

    if test "${REQUEST_METHOD}" == POST ; then
	operation=${VALUES[0]}
	case ${operation} in
 	    clear)
		field_state=disabled
		;;
	    create)
		field_state=enabled
		;;

	    load|save)
		test -n "${file_servers}" || field_state=disabled
		;;
	    *)
		;;
	esac
    else
	test -n "${file_servers}" || field_state=disabled
    fi

    itemState[3]=${field_state}
    itemState[4]=${field_state}
    itemState[5]=${field_state}

    blankItemContent[0]="${date}"
    blankItemContent[2]="$(print-operation "${file_servers}" ${operation})"
    blankItemContent[3]="$(show-file-protocol1 ${VALUES[1]:1})"
    blankItemContent[4]=${file_servers}
    blankItemContent[5]="type='text' size='48' maxlength='128' value='${VALUES[3]}'"

    checkItem[5]=printable

    itemForm[0]="text"
    itemForm[1]="text"
    itemForm[2]="select"
    itemForm[3]="select"
    itemForm[4]="select"

    itemFormSelectCB[2]="backupOperationSelectCB( '${operation_id}', '${protocol_id}', '${server_id}', '${filename_id}' );"

    shortcutMenuItem[0]="access-file"
    shortcutMenuItem[1]="password-file"
    shortcutMenuTitle[0]="File Servers"
    shortcutMenuTitle[1]="Accounts"

    show-title "Backup Restore" enabled "system"
    show-shortcuts-menu

    local progression=$(echo-backup-exchanged-percent ${operation})	

    show-form "${width}" enabled show-system-backup-log

    init-refresh-exchnage-file-progress-bar ${operation_id} ${progress_id} ${progression} "backup-exchanged-percentage"
}

# Main()

show-system-backup-form
