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

show-waf-rweb-bypass-rule-form()
{
    local get_args=${1}
    local page_ref=$(get-arg-value "${get_args}" page)

    local width=${DEFAULT_LIST_FORM_WIDTH}
    local state nb

    itemWidth[1]=30

    itemTitle[0]=""
    itemTitle[1]="Website Name"
    itemTitle[2]="Rule IDs"
    
    itemID[0]="Bypass"
    itemID[1]="site_name"
    itemID[2]="rule_ids"

    itemForm[1]="select"
    itemForm[2]="textarea"

    blankItemContent[0]=""
    blankItemContent[1]=$(show-uniq-rweb-sites)
    blankItemContent[2]="rows='2' cols='42'"

    checkItem[0]=
    checkItem[1]=
    checkItem[2]=text

    local bypasses
    local site rules
    local elt range i=0

    for elt in ${WAF_RWEB_BYPASS_RULE_LIST}
    do
	range=$[${i} % 2]
	case ${range} in
	    0)
		site=${elt}
		;;
	    1)
		rules=${elt//:/ }
		rules=$(encode-string "${rules}")
		bypasses="${bypasses} ${site} ${rules}"
		;;
	    *)
		return 255
		;;
	esac
	((i++))
    done

    listContent=${bypasses:1}

    nb=$(rweb-site-nb)
    test ${nb} -ne 0 || state=disabled

    shortcutMenuItem[0]="rweb-site"
    shortcutMenuTitle[0]="Add Websites"

    show-title "Bypass WAF Rules" "${state}" "admin waf"
    show-shortcuts-menu
    show-list-form ${nb} "${width}" "${page_ref}"
}

# Main()

show-waf-rweb-bypass-rule-form "${@}"
