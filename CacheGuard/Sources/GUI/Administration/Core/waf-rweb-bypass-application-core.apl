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

show-application-type()
{
    echo cpanel dokuwiki drupal nextcloud wordpress xenforo
}

show-waf-rweb-bypass-application-form()
{
    local get_args=${1}
    local page_ref=$(get-arg-value "${get_args}" page)

    local width=${DEFAULT_LIST_FORM_WIDTH_1}
    local state nb

    itemWidth[2]=15

    itemTitle[1]="Website Name"
    itemTitle[2]="Application "
    
    itemID[0]="Bypass"
    itemID[1]="site_name"
    itemID[2]="atype"

    itemForm[1]="select"
    itemForm[2]="select"

    blankItemContent[0]=""
    blankItemContent[1]=$(show-uniq-rweb-sites)
    blankItemContent[2]=$(show-application-type)

    listContent=${WAF_RWEB_BYPASS_APPLICATION_LIST}

    nb=$(rweb-site-nb)
    test ${nb} -ne 0 || state=disabled

    show-title "Bypass WAF Rules by Application Type" "${state}" "admin waf"
    show-list-form ${nb} "${width}" "${page_ref}"
}

# Main()

show-waf-rweb-bypass-application-form "${@}"
