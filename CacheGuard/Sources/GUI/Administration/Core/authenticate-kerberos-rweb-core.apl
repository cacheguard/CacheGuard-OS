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

source rweb-common.${GUI_EXT_NAME}

show-kerberos-rweb-form()
{
    local get_args=${1}
    local page_ref=$(get-arg-value "${get_args}" page)

    local width=${DEFAULT_LIST_FORM_WIDTH_1}
    local state nb

    itemWidth[1]=55

    itemTitle[1]="Website Name"
    itemTitle[2]="Canonical Name"
    
    itemID[0]="Kerberos RWeb"
    itemID[1]="site_name"
    itemID[2]="canonical_name"

    itemForm[1]="select"

    blankItemContent[0]=""
    blankItemContent[1]=$(show-uniq-rweb-sites)
    blankItemContent[2]="type='text' size='15' maxlength='14'"

    checkItem[2]=hostname

    shortcutMenuItem[0]="authenticate-kerberos-create"
    shortcutMenuTitle[0]="Kerberos Initialization"

    listContent=${KERBEROS_RWEB_LIST}
    test -n "${listContent}" || state=disabled
    show-title "Kerberos Authentication for Reverse Websites" "${state}" "authenticate rweb"

    nb=$(rweb-site-nb)

    test \
	-z "${CURRENT_KERBEROS_SERVER_LIST}" -o \
	"${CURRENT_AUTHENTICATE_MODE}" == False -o \
	"${CURRENT_AUTHENTICATE_KERBEROS}" == False \
	|| show-shortcuts-menu

    show-list-form ${nb} "${width}" "${page_ref}"
}

# Main()

show-kerberos-rweb-form "${@}"
