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

get-lb-method()
{
    local in_method=${1}

    local method selected

    for method in robin traffic pending
    do
	selected=$(get-selected-option ${method} "${in_method}")
	echo -n "<option value='${method}' id='${method}'${selected}>${method}</option>"
    done
}

get-lb-sticky()
{
    local in_sticky=${1}

    if test "${in_sticky}" == sticky ; then
	local state=True
    else
	local state=False
    fi

    echo "type=checkbox$(checked ${state})"
}

get-lb-mode()
{
    local in_mode=${1}

    local mode selected

    for mode in insert use
    do
	selected=$(get-selected-option ${mode} "${in_mode}")
	echo -n "<option value='${mode}' id='${mode}'${selected}>${mode}</option>"
    done
}

show-rweb-balancer-form()
{
    local get_args=${1}
    local key=$(get-arg-value "${get_args}" key)

    if test -z "${key}" ; then
	redirect-page "rweb-site"
	return 1
    fi

    local in_name=${key/§*}

    if test -z "${in_name}" ; then
	redirect-page "rweb-site"
        return 1
    fi


    if test -z "${in_name}" ; then
	redirect-page "rweb-site"
	return 1
    fi

    local balancer=$(get-site-balancer ${in_name} new)

    if test -z "${balancer}" ; then
	show-title ${title} disabled "rweb"
	return 1
    fi

    local algorithm=${balancer/ *}
    local sticky_mode_cookie=${balancer#* }
    local sticky=${sticky_mode_cookie/ *}
    local mode_cookie=${sticky_mode_cookie#* }
    local mode=${mode_cookie/ *}
    local cookie=${mode_cookie#* }

    local width

    itemWidth[0]=60
    itemWidth[1]=40

    itemTitle[0]="Hidden"
    itemTitle[1]="Website Name"
    itemTitle[2]="Load Balancing Method"
    itemTitle[3]="Stickiness"
    itemTitle[4]="Mode"
    itemTitle[5]="Cookie Name"
    
    itemID[0]="site_name"
    itemID[1]="not_posted"
    itemID[2]="method"
    itemID[3]="sticky"
    itemID[4]="mode"
    itemID[5]="cookie"

    local color='SeaGreen'

    blankItemContent[0]="value='${in_name}'"
    blankItemContent[1]="<div style='color:${color};'>${in_name}</div>"
    blankItemContent[2]=$(get-lb-method ${algorithm})
    blankItemContent[3]=$(get-lb-sticky ${sticky})
    blankItemContent[4]=$(get-lb-mode ${mode})

    local gui_cookie
    test ${sticky} != sticky || gui_cookie=${cookie}

    blankItemContent[5]="type='text' size='${MAX_COOKIE_LEN}' maxlength='${MAX_COOKIE_LEN}' value='${gui_cookie}'"

    itemForm[0]="hidden"
    itemForm[1]="text"
    itemForm[2]="select"
    itemForm[3]="check"
    itemForm[4]="select"

    checkItem[5]=aalphanum

    if test "${sticky}" == nosticky ; then
	itemState[4]="disabled"
	itemState[5]="disabled"
    fi

    local cb="stickyLBSelectCB( 'sticky', 'mode', 'cookie' );"
    itemFormCheckCB[3]=${cb}

    show-title "Load Balancing" enabled "rweb"
    show-form "${width}"
}

# Main()

show-rweb-balancer-form "${@}"
