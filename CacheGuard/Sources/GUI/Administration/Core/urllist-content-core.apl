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

source urllist-common.${GUI_EXT_NAME}

select-urllist-content-operation()
{
    local operation_id="${1}"
    local protocol_id="${2}"
    local server_id="${3}"
    local filename_id="${4}"
    local verify_id="${5}"

    call-js-function "URLListContentSelectCB( '${operation_id}', '${protocol_id}', '${server_id}', '${filename_id}', '${verify_id}' )"
}

show-urllist()
{
    local in_urllist=${1}

    local urllist

    for urllist in ${URLLIST_LIST}
    do
	if test ${urllist} == "${in_urllist}" ; then
	    echo -n "<option value='${urllist}' selected>${urllist}</option>"
	else
	    echo -n "<option value='${urllist}'>${urllist}</option>"
	fi
    done
}

print-operation()
{
    local in_op=${1}
    local op selected

    for op in create update auto clear
    do
	selected=$(get-selected-option ${op} "${in_op}")
	echo -n "<option value='${op}'${selected}>${op}</option>"
    done
}

show-urllist-load-form()
{
    local get_args=${1}
    local in_urllist=$(get-arg-value "${get_args}" key)

    local width
    local state

    local progress_id='progress'
    local urllist_id='urllist'
    local operation_id='operation'
    local protocol_id='protocol'
    local server_id='server'
    local filename_id='filename'
    local verify_id='verify'

    local urllist=${VALUES[0]}
    local operation=${VALUES[1]}
    local protocol=${VALUES[2]:1}
    local server=${VALUES[3]}
    local filename

    if test -z "${urllist}" ; then
	if test -n "${in_urllist}" ; then
	    urllist=${in_urllist}
	else
	    urllist=${URLLIST_LIST/ *}
	fi
    fi

    test -n "${operation}" || operation=create

    itemWidth[0]=35
    itemWidth[1]=65

    if test -n "${urllist}" ; then
	itemTitle[0]="${urllist} download progress"
    else
	itemTitle[0]="Download Progression"
    fi

    itemTitle[1]="Urllist Name"
    itemTitle[2]="Operation"
    itemTitle[3]="Protocol"
    itemTitle[4]="File Server"
    itemTitle[5]="File Path"
    itemTitle[6]="Verify signature"
    itemTitle[7]="Domain Names"
    itemTitle[8]="URLS"
    itemTitle[9]="Regular Expressions"

    itemID[0]="${progress_id}"
    itemID[1]="${urllist_id}"
    itemID[2]="${operation_id}"
    itemID[3]="${protocol_id}"
    itemID[4]="${server_id}"
    itemID[5]="${filename_id}"
    itemID[6]="${verify_id}"
    itemID[7]="domains"
    itemID[8]="urls"
    itemID[9]="expressions"

    local checked_verify
    local checked_domains
    local checked_urls
    local checked_expressions
    local pos i

    if test ${operation} == clear ; then
	pos=2
    else
	filename=${VALUES[4]}
	pos=5
    fi

    for ((i=pos ; i<=${ATTRIBUTE_NB} ; i++))
    do
	test "${ATTRIBUTES[${i}]}" != verify || checked_verify=checked
	test "${ATTRIBUTES[${i}]}" != domains || checked_domains=checked
	test "${ATTRIBUTES[${i}]}" != urls || checked_urls=checked
	test "${ATTRIBUTES[${i}]}" != expressions || checked_expressions=checked
    done

    if test -z "${checked_domains}" -a -z "${checked_urls}" -a -z "${checked_expressions}" ; then
	checked_domains=checked
	checked_urls=checked
    fi

    local file_servers=$(show-file-servers 'cur' ${server})
    test -n "${URLLIST_LIST}" -a -n "${file_servers}" || state=disabled

    blankItemContent[0]=""
    blankItemContent[1]="$(show-urllist ${urllist})"
    blankItemContent[2]="$(print-operation ${operation})"
    blankItemContent[3]="$(show-file-protocol1 ${protocol})"
    blankItemContent[4]=${file_servers}
    blankItemContent[5]="type='text' size='48' maxlength='128' value='${filename}'"
    blankItemContent[6]="type='checkbox' ${checked_verify}"
    blankItemContent[7]="type='checkbox' ${checked_domains}"
    blankItemContent[8]="type='checkbox' ${checked_urls}"
    blankItemContent[9]="type='checkbox' ${checked_expressions}"

    checkItem[5]=printable

    itemForm[0]="text"
    itemForm[1]="select"
    itemForm[2]="select"
    itemForm[3]="select"
    itemForm[4]="select"

    itemFormSelectCB[2]="URLListContentSelectCB( '${operation_id}', '${protocol_id}', '${server_id}', '${filename_id}', '${verify_id}' );"
    local progression=$(echo-urllist-download-percent ${urllist})	

    shortcutMenuItem[0]="access-file"
    shortcutMenuItem[1]="password-file"
    shortcutMenuTitle[0]="File Servers"
    shortcutMenuTitle[1]="Accounts"

    local after_function="select-urllist-content-operation ${operation_id} ${protocol_id} ${server_id} ${filename_id} ${verify_id}"

    show-title "Manage URL Lists Content" "${state}" "access guard password sslmediate urllist"
    show-shortcuts-menu
    show-form "${width}" "${state}" "${after_function}"

    init-refresh-exchnage-file-progress-bar ${urllist_id} ${progress_id} ${progression} "urllist-download-percentage"
}

# Main()

show-urllist-load-form "${@}"
