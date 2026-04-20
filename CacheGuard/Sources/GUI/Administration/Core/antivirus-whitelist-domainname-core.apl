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

show-antivirus-whitelist-domainname-form()
{
    local get_args=${1}
    local page_ref=$(get-arg-value "${get_args}" page)

    local width=${DEFAULT_LIST_FORM_WIDTH_3}
    local state

    itemWidth[1]=

    itemTitle[0]=""
    itemTitle[1]="Domain name"

    itemID[0]="Domain Name"
    itemID[1]="domainname"
    
    blankItemContent[0]=""
    blankItemContent[1]="type='text' size='24' maxlength='64'"

    checkItem[0]=
    checkItem[1]=domainname

    listContent=${AV_WHITELIST_DOMAINNAME_LIST}
    test -n "${listContent}" || state=disabled

    show-title "Antivirus Domain Name White List" "${state}" "sslmediate urllist"

    echo "<div class='table-title' style='margin:5px;'>Bypass the antivirus for the following domain names.</div>"
    show-list-form ${MAX_AV_WHITELIST_DOMAINNAME_NB} "${width}" "${page_ref}"
}

# Main()

show-antivirus-whitelist-domainname-form "${@}"
