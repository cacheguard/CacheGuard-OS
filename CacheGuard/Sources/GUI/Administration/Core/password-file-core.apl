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

print-password-file-servers()
{
    local elt i=0 range
    local server servers

    for elt in ${ACCESS_FILE_LIST}
    do
	range=$[${i} % 4]
	case ${range} in
	    0|2)
		;;
	    1)
		server=${elt}
		;;
	    2)
		;;
	    3)
		servers="${servers} ${server}"
		;;
	    *)
		return 255
		;;
	esac
	((i++))
    done

    echo -n "${servers:1}"
}

show-password-ftp-form()
{
    local get_args=${1}
    local page_ref=$(get-arg-value "${get_args}" page)

    local width=700
    local state

    itemWidth[2]=20
    itemWidth[3]=20

    itemTitle[0]=""
    itemTitle[1]="Protocol"
    itemTitle[2]="File Server"
    itemTitle[3]="Login"
    itemTitle[4]="Password"
    
    itemID[0]="Account"
    itemID[1]="protocol"
    itemID[2]="server"
    itemID[3]="login"
    itemID[4]="password"
    
    blankItemContent[0]=""
    blankItemContent[1]="ftp sftp"
    blankItemContent[2]="$(print-password-file-servers)"
    blankItemContent[3]="type='text' size='12' maxlength='32'"
    blankItemContent[4]="type='password' size='12' maxlength='32'"

    blankItemContentValues[1]="_ftp _sftp"

    checkItem[3]=printable
    checkItem[4]=printable

    itemForm[1]=select
    itemForm[2]=select

    itemType[1]=protocol
    itemType[4]=password

    shortcutMenuItem[0]="access-file"
    shortcutMenuTitle[0]="File Servers"

    listContent=${FILE_SERVER_PASSWORD_LIST}
    test -n "${listContent}" || state=disabled

    show-title "File Server Accounts" "${state}" "password access"
    show-shortcuts-menu
    show-list-form ${MAX_ACL_FILE_NB} "${width}" "${page_ref}"
}

# Main()

show-password-ftp-form "${@}"
