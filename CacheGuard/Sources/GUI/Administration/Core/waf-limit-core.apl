#!/bin/bash

###########################################################################
#
# MODULE:       GUI
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

    itemTitle[0]="Maximum response body size (KB)"
    itemTitle[1]="Maximum request body size (KB)"
    itemTitle[2]="Maximum number of assertions (or arguments)"
    itemTitle[3]="Maximum length for an argument name"
    itemTitle[4]="Maximum length for an argument value"
    itemTitle[5]="Total arguments length limit"
    itemTitle[6]="Maximum size for combined uploaded files (KB)"
    
    itemID[0]="response"
    itemID[1]="request"
    itemID[2]="assertions"
    itemID[3]="name"
    itemID[4]="value"
    itemID[5]="arguments"
    itemID[6]="files"

    blankItemContent[0]="type='text' size='8' maxlength='8' value='${WAF_RESPONSE_BODY}' data-action='show-min-max-tooltip' data-min='1' data-max='1048576'"
    blankItemContent[1]="type='text' size='8' maxlength='8' value='${WAF_REQUEST_BODY}' data-action='show-min-max-tooltip' data-min='1' data-max='1048576'"
    blankItemContent[2]="type='text' size='8' maxlength='8' value='${WAF_NUM_ARG}' data-action='show-min-max-tooltip' data-min='(0' data-max='8192'"
    blankItemContent[3]="type='text' size='8' maxlength='8' value='${WAF_ARG_NAME_LENGTH}' data-action='show-min-max-tooltip' data-min='0' data-max='1024'"
    blankItemContent[4]="type='text' size='8' maxlength='8' value='${WAF_ARG_LENGTH}' data-action='show-min-max-tooltip' data-min='0' data-max='1048576'"
    blankItemContent[5]="type='text' size='8' maxlength='8' value='${WAF_TOTAL_ARG_LENGTH}' data-action='show-min-max-tooltip' data-min='0' data-max='1048576'"
    blankItemContent[6]="type='text' size='8' maxlength='8' value='${WAF_FILES_SIZE}' data-action='show-min-max-tooltip' data-min='1' data-max='${MAX_UPLOAD_FILE_SZ}'"

    checkItem[0]=digit
    checkItem[1]=digit
    checkItem[2]=digit
    checkItem[3]=digit
    checkItem[4]=digit
    checkItem[5]=digit
    checkItem[6]=digit

    show-title "WAF Size Limits" "enabled" "waf"
    show-form "${width}"
}

# Main()

show-waf-limit-form
