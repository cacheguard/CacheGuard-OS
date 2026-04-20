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

show-waf-limit-form()
{
    local width=400

    itemWidth[0]=80
    itemWidth[1]=20

    itemTitle[0]="Per client max requests"
    itemTitle[1]="Duration period (seconds)"
    itemTitle[2]="Blocking duration (seconds)"
    
    itemID[0]="counter"
    itemID[1]="slice"
    itemID[2]="timeout"

    local dos_counter=${WAF_DOS_LIMIT/ *}
    local dos_slice=${WAF_DOS_LIMIT#* } ; dos_slice=${dos_slice/ *}
    local dos_timeout=${WAF_DOS_LIMIT/* }

    blankItemContent[0]="type='text' size='8' maxlength='7' value='${dos_counter}' onMouseOver=showMinMaxToolTip(1,1000000); onMouseOut=hideMinMaxToolTip();"
    blankItemContent[1]="type='text' size='8' maxlength='5' value='${dos_slice}' onMouseOver=showMinMaxToolTip(1,86400); onMouseOut=hideMinMaxToolTip();"
    blankItemContent[2]="type='text' size='8' maxlength='6' value='${dos_timeout}' onMouseOver=showMinMaxToolTip(1,604800); onMouseOut=hideMinMaxToolTip();"

    checkItem[0]=digit
    checkItem[1]=digit
    checkItem[2]=digit

    call-js-function "hideMinMaxToolTip( )"
    show-title "WAF Denial of Service" "enabled" "waf"
    show-form "${width}"
}

# Main()

show-waf-limit-form
