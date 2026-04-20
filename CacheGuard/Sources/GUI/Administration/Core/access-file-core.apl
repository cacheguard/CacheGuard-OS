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

show-access-file-form()
{
    local get_args=${1}
    local page_ref=$(get-arg-value "${get_args}" page)

    local width=${DEFAULT_LIST_FORM_WIDTH_2}
    local interfaces=$(gui-get-contextual-network-interfaces)
    local state

    itemWidth[1]=20

    itemTitle[0]=""
    itemTitle[1]="Interface"
    itemTitle[2]="Network IP or Name"

    itemID[0]="File access"
    itemID[1]="interface"
    itemID[2]="server"

    blankItemContent[0]="urllist-auto"
    blankItemContent[1]="${interfaces}"
    blankItemContent[2]="type='text' size='24' maxlength='64'"

    itemForm[1]="select"

    checkItem[0]=
    checkItem[2]=ipdomainname

    shortcutMenuItem[0]="password-file"
    shortcutMenuTitle[0]="File Server Accounts"

    listContent=${ACCESS_FILE_LIST}
    listContentStep=4
    listContentVisibility[2]=off
    listContentVisibility[3]=off

    test -n "${listContent}" || disabled=disabled

    show-title "Trusted File Servers" "${disabled}" "access password"
    show-shortcuts-menu
    show-list-form ${MAX_ACL_FILE_NB} "${width}" "${page_ref}"
}

# Main()

show-access-file-form "${@}"
