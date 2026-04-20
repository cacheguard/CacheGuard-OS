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

show-admin-user-form()
{
    local get_args=${1}
    local page_ref=$(get-arg-value "${get_args}" page)

    local width=${DEFAULT_LIST_FORM_WIDTH_2}
    local state

    itemWidth[1]=35
    
    itemTitle[0]=""
    itemTitle[1]="Login Name"
    itemTitle[2]="First Login Password"
    
    itemID[0]="Administrator"
    itemID[1]="user"
    itemID[2]="password"

    blankItemContent[0]=""
    blankItemContent[1]="type='text' size='24' maxlength='${MAX_USER_LEN}'"
    blankItemContent[2]="type='password' size='24' maxlength='32' value=''"

    checkItem[0]=
    checkItem[1]=aalphanum
    checkItem[2]=printable

    itemType[2]=password

    local user
    unset listContent

    for user in ${ADMIN_USER_LIST}
    do
	listContent="${listContent} ${user} nil"
    done
    listContent=${listContent:1}

    test -n "${listContent}" || state=disabled
    
    show-title "Unprivileged Administrators" "${state}" "admin"
    show-list-form ${MAX_ADMINISTRATORS_NB} "${width}" "${page_ref}"
}

# Main()

show-admin-user-form "${@}"
