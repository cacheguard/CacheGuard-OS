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

print-http-errors-actions()
{
    echo -n "allow deny"
}

show-waf-rweb-errors-form()
{
    local get_args=${1}
    local page_ref=$(get-arg-value "${get_args}" page)

    local width=${DEFAULT_LIST_FORM_WIDTH_1}
    local state title

    itemWidth[2]=15

    itemTitle[1]="Site Name"
    itemTitle[2]="Policy"
    
    itemID[0]="Rule"
    itemID[1]="site_name"
    itemID[2]="policy"
    
    blankItemContent[0]=""
    blankItemContent[1]=$(show-uniq-rweb-sites)
    blankItemContent[2]=$(print-http-errors-actions)

    itemForm[1]="select"
    itemForm[2]="select"

    checkItem[0]=
    
    listContent=${WAF_RWEB_REWRITE_HTTP_ERRORS_LIST}
    local rweb_nb=$(gui-get-contextual-rweb-nb)

    test -n "${RWEB_SITE_LIST}" || state=disabled    
    show-title "WAF HTTP Errors" "${state}" "waf"
    show-list-form ${rweb_nb} "${width}" "${page_ref}" "" "" ${state}

    if test -z "${RWEB_SITE_LIST}" ; then
	echo "<div class='core-form'>"
	echo "<p><br />"
	echo "<div style='clear:left;'></div>"
	echo "<div class='table-title'>"
	echo "<span class='table-title' style='fload:left;'>&lt;no reverse Web site has been defined&gt;</span>"
	echo "<span class='shortcut-menu-item' style='display:inline;'><a href='rweb-site.${GUI_EXT_NAME}'>Add rWeb</a></span>"
	echo "</div>"
	echo "</div>"
    fi
}

# Main()

show-waf-rweb-errors-form "${@}"
