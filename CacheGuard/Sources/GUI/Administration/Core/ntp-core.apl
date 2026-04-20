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

show-ntp-form()
{
    local get_args=${1}
    local page_ref=$(get-arg-value "${get_args}" page)

    local width=${DEFAULT_LIST_FORM_WIDTH_3}
    local state

    itemWidth[1]=

    itemTitle[0]=""
    itemTitle[1]="Network IP or Name"
    
    itemID[0]="NTP Server"
    itemID[1]="server"
    
    blankItemContent[0]=""
    blankItemContent[1]="type='text' size='24' maxlength='64'"
    
    checkItem[0]=
    checkItem[1]=ipdomainname
    
    shortcutMenuItem[0]="network-utilities"
    shortcutMenuTitle[0]="Synchronise Time"

    listContent=${NTP_SERVER_LIST}
    test -n "${listContent}" || state=disabled    
    show-title "NTP Servers" "${state}" "clock ntp"
    test -z "${CURRENT_NTP_SERVER_LIST}" || show-shortcuts-menu
    show-list-form ${MAX_NTP_SERVER_NB} "${width}" "${page_ref}"
}

# Main()

show-ntp-form "${@}"
