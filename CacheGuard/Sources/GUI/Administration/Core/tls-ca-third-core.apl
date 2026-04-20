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

show-tls-ca-third-form()
{
    local get_args=${1}
    local page_ref=$(get-arg-value "${get_args}" page)

    local width=${DEFAULT_LIST_FORM_WIDTH_1}
    local state

    itemWidth[1]=50

    itemTitle[0]=""
    itemTitle[1]="Identifier"
    itemTitle[2]="Browsing"
    
    itemID[0]="Other CA"
    itemID[1]="tls_ca"
    itemID[2]="browsing"

    itemForm[2]="select"

    blankItemContent[0]=''
    blankItemContent[1]="type='text' size='${MAX_NAME_LEN}' maxlength='${MAX_NAME_LEN}'"

    if gui-contextual-is-allowed ; then
	blankItemContent[2]="on off"
    else
	blankItemContent[2]="off"
    fi    

    checkItem[1]=identifier

    editColumnPage[0]="tls-ca-third-load"
    editColumnTitle[0]="Manage"
    
    listContent=${TLS_CA_LIST}
    test -n "${listContent}" || state=disabled

    show-title "Third Party CA Certificates" "${state}" "sslmediate tls"
    show-list-form ${MAX_TLS_CA_NB} "${width}" "${page_ref}"
}

# Main()

show-tls-ca-third-form "${@}"
