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

waf-errors-checked()
{
    test -n "${1}" || return 1
    
    case "${1}" in
	deny)
	    echo -n "checked"
	    return 0
	    ;;
	allow)
	    return 0
	    ;;
	*)
	    return 1
	    ;;
    esac
}

waf-imethods-checked()
{
    test -n "${1}" || return 1
    
    case "${1}" in
	deny)
	    return 0
	    ;;
	allow)
	    echo -n "checked"
	    return 0
	    ;;
	*)
	    return 1
	    ;;
    esac
}

show-waf-select-options()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    local in_selected=${1}
    local nb=${2}

    local i selected

    for ((i=1 ; i<=nb ; i++))
    do
	selected=$(get-selected-option ${i} "${in_selected}")
	echo -n "<option value='${i}'${selected}>${i}</option>"
    done
}


show-waf-limit-form()
{
    local rbl_url="https://www.projecthoneypot.org"

    local width=520

    itemWidth[0]=45
    itemWidth[1]=55

    itemTitle[0]="Filtering Level"
    itemTitle[1]="Request Score Threshold"
    itemTitle[2]="Response Score Threshold"
    itemTitle[3]="Project Honey Pot RBL API Key"
    itemTitle[4]="Rewrite HTTP Error Pages"
    itemTitle[5]="Allow insecure HTTP methods"

    itemID[0]="level"
    itemID[1]="score_request"
    itemID[2]="score_response"
    itemID[3]="rbl_key"
    itemID[4]="errors"
    itemID[5]="imethods"

    checkItem[3]=alphanum

    itemForm[0]="select"
    itemForm[1]="select"
    itemForm[2]="select"

    blankItemContent[0]=$(show-waf-select-options ${WAF_LEVEL} 4)
    blankItemContent[1]=$(show-waf-select-options ${WAF_REQUEST_SCORE} ${MAX_WAF_SCORE})
    blankItemContent[2]=$(show-waf-select-options ${WAF_RESPONSE_SCORE} ${MAX_WAF_SCORE})
    blankItemContent[3]="type='password' size='32' maxlength='64' value='${WAF_REPUTATION_RBL_KEY}'"
    blankItemContent[4]="type='checkbox' $(waf-errors-checked ${WAF_REWRITE_HTTP_ERRORS})"
    blankItemContent[5]="type='checkbox' $(waf-imethods-checked ${WAF_IMETHODS})"

    show-title "Scoring & Other WAF Settings" "waf"
    show-form "${width}"

    echo "<div class='core-form'>"
    echo "<p><br />"
    echo "<div style='clear:left;'></div>"
    echo "<div class='table-title'>"
    echo "Get a Real Time Blacklists API Key at <a href='${rbl_url}/' target='_blank'>${rbl_url}</a>"
    echo "</div>"
    echo "</div>"
}

# Main()

show-waf-limit-form
