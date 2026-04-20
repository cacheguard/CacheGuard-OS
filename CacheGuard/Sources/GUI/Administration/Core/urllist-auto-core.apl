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

guard-auto-show-file-servers()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    test -n "${3}" || return 3
    local state=${1}
    local id=${2}
    local height=${3}
    local cb=${4}
    local class=${5}
    local in_server=${6}

    local readonly style="width:100%; height:${height}px;"

    if test ${state} == off ; then
	readonly=' readonly'
	style="${style}; ${GUI_READONLY_STYLE}"
    fi

    test -z "${class}" || class=" class='${class}'"
    test -z "${cb}" || cb=" onChange=\"${cb}\""

    if test -n "${ACCESS_FILE_LIST}" ; then
	echo -n "<select id='${id}'${class} style='${style}'${readonly} name='${id}'${cb}>"
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
    test -n "${4}" || return 4
    local id=${1}
    local height=${2}
    local cb=${3}
    local protocols=${4}

    test -z "${cb}" || cb=" onChange=\"${cb}\""

    echo -n "<select id='${id}' class='table-form-action' style='width:100%; height:${height}px;' name='${id}'${cb}>"
    show-file-protocol1 ftp "${protocols}"
    echo "</select>"
}

urllist-auto-toggle()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    local id=${1}
    local class=${2}
    local in_list=${3}

    local width=100% height=30px
    local item list

    for item in ${in_list}
    do
	list="${list}, '${item}'"
    done

    echo "<button id='${id}' class='${class}' style='width:${width}; height:${height};' type='button' onClick=\"toggleSelection( '${class}' ${list} );\">Toggle</button>"
}

show-urllist-auto-load()
{
    local urllist option i=0
    local bool load operation period protocol server filename

    local sel_on sel_off
    local sel_load sel_vload
    local sel_create sel_update
    local sel_daily sel_weekly

    local toggle_width=60
    local protocol_title=Proto
    local protocol_items="ftp sftp tftp" protocol_item selected
    local push_method state readonly readonly_cb
    local protocol_id file_server_id filename_id

    local state_class="state"
    local load_class="load"
    local operation_class="operation"
    local period_class="period"
    local protocol_class="protocol"
    local file_server_class="file-server"
    local filename_class="filename"

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

    echo "<table width='900' class='highlight-list'>"

    echo "<thead>"
    echo "<tr style='height:50px;'>"
    echo "<td width='15%' class='table-header'>URL List</td>"
    echo "<td width='${toggle_width}' class='table-header'><center>State<br /></center></td>"
    echo "<td width='${toggle_width}' class='table-header'><center>Verify<br /></center></td>"
    echo "<td width='${toggle_width}' class='table-header'><center>Op<br /></center></td>"
    echo "<td width='${toggle_width}' class='table-header'><center>Period</center></td>"
    echo "<td class='table-header'><center>${protocol_title}</center></td>"
    echo "<td class='table-header'>File Serve</td>"
    echo "<td width='20%' class='table-header'>Filename</td>"
    echo "</tr>"
    echo "</thead>"

    

    echo "<tbody>"
    echo "<tr style='height:40px;'>"

    echo "<td></td>"

    echo "<td>"
    urllist-auto-toggle 'toggle-state' ${state_class} "on off"
    echo "</td>"

    echo "<td>"
    urllist-auto-toggle 'toggle-load' ${load_class} "load vload"
    echo "</td>"

    echo "<td>"
    urllist-auto-toggle 'toggle-operation' ${operation_class} "update create"
    echo "</td>"

    echo "<td>"
    urllist-auto-toggle 'toggle-period' ${period_class} "daily weekly"
    echo "</td>"

    echo "<td>"
    guard-auto-show-protocols protocol 30 "selectURLListAutoAllProtocolCB( 'protocol', '${protocol_class}', '${file_server_class}', '${filename_class}' )" "${protocol_items}"
    echo "</td>"

    echo "<td>"
    guard-auto-show-file-servers on file-server 30 "selectAllTheSameCB( 'file-server', '${file_server_class}' )" table-form-action
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

	echo "<td><select name='state_${i}' class='${state_class}' style='width:100%;'>"
	echo -n "<option value='off' ${sel_off}>Off</option>"
	echo -n "<option value='on' ${sel_on}>On</option>"
	echo "</select></td>"

	echo "<td><select name='load_${i}' class='${load_class}' style='width:100%;'>"
	echo -n "<option value='load' ${sel_load}>No</option>"
	echo -n "<option value='vload' ${sel_vload}>Yes</option>"
	echo "</select></td>"

	echo "<td><select name='operation_${i}' class='${operation_class}' style='width:100%;'>"
	echo -n "<option value='update' ${sel_update}>Update</option>"
	echo -n "<option value='create' ${sel_create}>Create</option>"
	echo "</select></td>"

	echo "<td><select name='period_${i}' class='${period_class}' style='width:100%;'>"
	echo -n "<option value='daily' ${sel_daily}>Daily</option>"
	echo -n "<option value='weekly' ${sel_weekly}>Weekly</option>"
	echo "</select></td>"

	local state
	if test "${protocol}" == 'push' ; then
	    state=off
	    readonly=' readonly'
	    style=" style='${GUI_READONLY_STYLE}'"
	else
	    state=on
	    unset readonly style
	fi

	protocol_id="protocol_${i}"
	file_server_id="file_server_${i}"
	filename_id="filename_${i}"
	readonly_cb="selectURLListAutoProtocolCB( '${protocol_id}', '${file_server_id}', '${filename_id}' )"

	echo "<td><select id='${protocol_id}' name='${protocol_id}' class='${protocol_class}' style='width:100%;' onChange=\"${readonly_cb}\">"

	for protocol_item in ${protocol_items}
	do
	    selected=$(get-selected-option ${protocol_item} "${protocol}")
	    echo -n "<option value='_${protocol_item}'${selected}>${protocol_item}</option>"
	done
	echo "</select></td>"

	echo "<td>"
	if test -n "${ACCESS_FILE_LIST}" ; then
	    guard-auto-show-file-servers ${state} ${file_server_id} 30 '' ${file_server_class} ${server}
	else
	    echo "<a href='/${GUI_DIR_NAME}/access-file.${GUI_EXT_NAME}'>Add File Servers</a>"
	fi
	echo "</td>"

	echo "<td>"
	echo "<input id='filename_${i}'${readonly}${style} name='filename_${i}' class='${filename_class}' type='text' size='48' maxlength='128' value='${filename}' onblur=\"checkPrintable( 'filename_${i}' );\" onmouseout=\"checkPrintable( 'filename_${i}' );\">"
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
    local length=8
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
    show-shortcuts-menu

    echo "<div class='core-form'>"
    show-form-begin ${length}
    show-urllist-auto-load
    show-do ${state} ${state}
    show-form-end
    echo "</div>"
}

# Main()

show-guard-auto-form
