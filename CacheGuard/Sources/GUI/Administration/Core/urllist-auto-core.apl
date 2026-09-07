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

guard-auto-show-file-servers()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    test -n "${3}" || return 3
    local state=${1}
    local id=${2}
    local data=${3}
    local class=${4}
    local in_server=${5}

    test ${data} == nil || data=" ${data}"

    if test -n "${ACCESS_FILE_LIST}" ; then
	echo -n "<select id='${id}' class='urllist-auto ${class}' name='${id}'${data}>"
	show-file-servers 'new' "${in_server}"
	echo "</select>"
    else
	echo "<a href='/${GUI_DIR_NAME}/access-file.${GUI_EXT_NAME}'>Add File Servers</a>"
    fi
}

guard-auto-show-protocols()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    test -n "${3}" || return 3
    local id=${1}
    local data=${2}
    local protocols=${3}

    echo -n "<select id='${id}' class='urllist-auto' name='${id}' ${data}>"
    show-file-protocol1 ftp "${protocols}"
    echo "</select>"
}

urllist-auto-toggle()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    test -n "${3}" || return 3
    test -n "${4}" || return 4
    local id=${1}
    local class=${2}
    local state1=${3}
    local state2=${4}

    echo "<button id='${id}' class='urllist-auto ${class}' type='button' data-action='toggle-selection' data-class='${class}' data-state1='${state1}' data-state2='${state2}'>Toggle</button>"
}

show-urllist-auto-load()
{
    local urllist option i=0
    local bool load operation period protocol server filename

    local sel_on sel_off
    local sel_load sel_vload
    local sel_create sel_update
    local sel_daily sel_weekly

    local protocol_title=Proto
    local protocol_items="ftp sftp tftp" protocol_item selected
    local push_method state
    local protocol_id file_server_id filename_id

    local state_class="state"
    local load_class="load"
    local operation_class="operation"
    local period_class="period"
    local protocol_class="protocol"
    local file_server_class="file-server"
    local filename_class="filename"
    local state class

    case ${APL_ROLE} in
	gateway)
	    test -z "${ACCESS_MANAGER_LIST}" || push_method=yes
	    ;;
	manager)
	    ! gui-is-in-contextual-role || push_method=yes
	    ;;
	*)
	    ;;
    esac

    if test -n "${push_method}" ; then
	protocol_title="${protocol_title} /<br />Method"
	protocol_items="${protocol_items} push"
    fi

    echo "<table class='highlight-list'>"

    echo "<thead>"
    echo "<tr>"
    echo "<th class='table-header'>URL List</th>"
    echo "<th class='table-header'><center>State<br /></center></th>"
    echo "<th class='table-header'><center>Verify<br /></center></th>"
    echo "<th class='table-header'><center>Op<br /></center></th>"
    echo "<th class='table-header'><center>Period</center></th>"
    echo "<th class='table-header'><center>${protocol_title}</center></th>"
    echo "<th class='table-header'>File Serve</th>"
    echo "<th class='table-header'>Filename</th>"
    echo "</tr>"
    echo "</thead>"

    echo "<tbody>"
    echo "<tr>"

    echo "<td></td>"

    echo "<td>"
    urllist-auto-toggle 'toggle-state' ${state_class} on off
    echo "</td>"

    echo "<td>"
    urllist-auto-toggle 'toggle-load' ${load_class} load vload
    echo "</td>"

    echo "<td>"
    urllist-auto-toggle 'toggle-operation' ${operation_class} update create
    echo "</td>"

    echo "<td>"
    urllist-auto-toggle 'toggle-period' ${period_class} daily weekly
    echo "</td>"

    echo "<td>"
    guard-auto-show-protocols protocol "data-action='select-url-list-auto-all-protocol' data-type='protocol' data-protocol-class='${protocol_class}' data-file-server-class='${file_server_class}' data-filename-class='${filename_class}'" "${protocol_items}"
    echo "</td>"

    echo "<td>"
    guard-auto-show-file-servers on file-server "data-action='select-all-the-same' data-class='${file_server_class}'" ${file_server_class}
    echo "</td>"

    echo "<td></td>"
    echo "</tr>"

    for urllist in ${URLLIST_LIST}
    do
	unset bool load operation period protocol server filename
	if test -f ${URLLIST_DIR}/${urllist}.${URLLIST_AUTO} ; then
	    read bool load operation period protocol server filename < ${URLLIST_DIR}/${urllist}.${URLLIST_AUTO}
	else
	    if test -f ${URLLIST_DIR}/${urllist}.${URLLIST_AUTO}.current ; then
		read bool load operation period protocol server filename < ${URLLIST_DIR}/${urllist}.${URLLIST_AUTO}.current
	    else
		filename=${urllist}
	    fi
	fi

	unset sel_off sel_on sel_vload sel_load sel_update sel_create sel_daily sel_weekly

	case ${bool} in
	    on)
		sel_on=selected
		;;
	    off)
		sel_off=selected
		;;
	    *)
		;;
	esac

	case ${load} in
	    load)
		sel_load=selected
		;;
	    vload)
		sel_vload=selected
		;;
	    *)
		;;
	esac
	
	case ${operation} in
	    create)
		sel_create=selected
		;;
	    update)
		sel_update=selected
		;;
	    *)
		;;
	esac

	case ${period} in
	    weekly)
		sel_weekly=selected
		;;
	    daily)
		sel_daily=selected
		;;
	    *)
		;;
	esac

	echo "<tr>"

	echo "<td><input name='urllist_${i}' value='${urllist}' type='hidden'><i>${urllist}</i></td>"

	echo "<td><select name='state_${i}' class='urllist-auto ${state_class}'>"
	echo -n "<option value='off' ${sel_off}>Off</option>"
	echo -n "<option value='on' ${sel_on}>On</option>"
	echo "</select></td>"

	echo "<td><select name='load_${i}' class='urllist-auto ${load_class}'>"
	echo -n "<option value='load' ${sel_load}>No</option>"
	echo -n "<option value='vload' ${sel_vload}>Yes</option>"
	echo "</select></td>"

	echo "<td><select name='operation_${i}' class='urllist-auto ${operation_class}'>"
	echo -n "<option value='update' ${sel_update}>Update</option>"
	echo -n "<option value='create' ${sel_create}>Create</option>"
	echo "</select></td>"

	echo "<td><select name='period_${i}' class='urllist-auto ${period_class}'>"
	echo -n "<option value='daily' ${sel_daily}>Daily</option>"
	echo -n "<option value='weekly' ${sel_weekly}>Weekly</option>"
	echo "</select></td>"

	if test "${protocol}" == 'push' ; then
	    state=off
	    class=' read-only'
	else
	    state=on
	    unset class
	fi

	protocol_id="protocol_${i}"
	file_server_id="file_server_${i}"
	filename_id="filename_${i}"

	echo "<td><select id='${protocol_id}' name='${protocol_id}' class='urllist-auto ${protocol_class}' data-action='select-url-list-auto-protocol' data-file-server-id='${file_server_id}' data-filename-id='${filename_id}'>"

	for protocol_item in ${protocol_items}
	do
	    selected=$(get-selected-option ${protocol_item} "${protocol}")
	    echo -n "<option value='_${protocol_item}'${selected}>${protocol_item}</option>"
	done
	echo "</select></td>"

	echo "<td>"
	if test -n "${ACCESS_FILE_LIST}" ; then
	    guard-auto-show-file-servers ${state} ${file_server_id} nil ${file_server_class} ${server}
	else
	    echo "<a href='/${GUI_DIR_NAME}/access-file.${GUI_EXT_NAME}'>Add File Servers</a>"
	fi
	echo "</td>"

	echo "<td>"
	echo "<input id='filename_${i}' name='filename_${i}' class='${filename_class}${class}' type='text' size='48' maxlength='128' value='${filename}' data-action='check-input' data-check-function='checkPrintable'>"
	echo "</td>"

	    echo "</tr>"
	((i++))
    done

    echo "</tbody>"
    echo "</table>"
}

show-guard-auto-form()
{
    local state
    local full_show

    case ${APL_ROLE} in
	gateway)
	    full_show=yes
	    ;;
	manager)
	    if ! gui-is-in-contextual-role ; then
		full_show=yes
	    fi
	    ;;
	*)
	    ;;
    esac

    if test -z "${URLLIST_LIST}" ; then
	state=disabled
    else
	test -z "${full_show}" || test -n "${ACCESS_FILE_LIST}" || state=disabled
    fi

    shortcutMenuItem[0]="access-file"
    shortcutMenuItem[1]="password-file"

    shortcutMenuTitle[0]="File Servers"
    shortcutMenuTitle[1]="Accounts"

    if test -n "${full_show}" ; then
	shortcutMenuItem[2]="urllist-update"
	shortcutMenuTitle[2]="Auto Update Now"
    fi

    show-title "Auto Load Contents" "${state}" "access guard password sslmediate urllist"

    echo "<div class='core-form'>"
    show-shortcuts-menu
    show-form-begin
    show-urllist-auto-load
    show-do ${state} ${state}
    show-form-end
    echo "</div>"
}

# Main()

show-guard-auto-form
