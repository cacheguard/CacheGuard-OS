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

show-guard-filter-ldap-form()
{
    local get_args=${1}
    local page_ref=$(get-arg-value "${get_args}" page)

    local width=${DEFAULT_LIST_FORM_WIDTH}
    local state

    itemWidth[0]=35
    itemWidth[1]=65

    itemTitle[0]="LDAP Filter"
    itemTitle[1]="Name"
    itemTitle[2]="Base DN"
    itemTitle[3]="Login Attribute"
    itemTitle[4]="LDAP Filter"
    
    itemID[0]=""
    itemID[1]="name"
    itemID[2]="base_dn"
    itemID[3]="login_attribute"
    itemID[4]="filter"
    
    blankItemContent[1]="type='text' size='${MAX_NAME_LEN}' maxlength='${MAX_NAME_LEN}'"
    blankItemContent[2]="type='text' size='48' maxlength='256'"
    blankItemContent[3]="type='text' size='24' maxlength='64'"
    blankItemContent[4]="type='text' size='48' maxlength='384'"
    
    checkItem[0]=
    checkItem[1]=guard
    checkItem[2]=dn
    checkItem[3]=printable
    checkItem[4]=printable
    
    listContent=${GUARD_FILTER_LDAP_LIST}
    test -n "${listContent}" || state=disabled
    
    show-title "LDAP Filters" "${state}" "guard"
    show-multi-form ${MAX_GUARD_FILTERS_NB} "${width}" "${page_ref}"
}

# Main()

show-guard-filter-ldap-form "${@}"
