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

echo-patch-download-percent()
{
    local file="${LOADED}.os.tar.compressed.${PROGRESS}"
    echo-exchanged-file-percent "${file}"
}

show-system-patch-form()
{
    local width
    local state

    local check_id=check
    local accept_id=accept
    local progress_id=progress
    local patch_id=patch

    local checked_aload=' checked'
    local field_state="disabled"
    local posted_accept_index=2
    local pos=1

    local accept_value

    if test "${REQUEST_METHOD}" == POST ; then
	if test "${ATTRIBUTES[1]}" != aload ; then
	    pos=0
	    unset checked_aload
	    field_state='enabled'
	    posted_accept_index=4
	fi
    fi

    if test "${ATTRIBUTES[${posted_accept_index}]}" == ${accept_id} ; then
	state="enabled"
    else
	state="disabled"
    fi

    test ${state} == disabled || accept_value=" checked"

    itemTitle[0]="<div><a href='#' onClick='getLatestVersion( \"/${GUI_DIR_NAME}/system-soft-check.${GUI_EXT_NAME}\", \"${check_id}-insider\" )'>Check for Updates</a></div>"
    itemTitle[1]="Download progress"
    itemTitle[2]="Automatic Load"
    itemTitle[3]="Protocol"
    itemTitle[4]="File Server"
    itemTitle[5]="File Path"
    itemTitle[6]="I agree to terms of the <a href='${LICENSE_URL}' target='_blank'>Latest ${COMMERCIAL_NAME}-OS License</a>"
    itemTitle[7]=''

    itemID[0]="${check_id}"
    itemID[1]="${progress_id}"
    itemID[2]="aload"
    itemID[3]="protocol"
    itemID[4]="server"
    itemID[5]="filename"
    itemID[6]="${accept_id}"
    itemID[7]="${patch_id}"

    local file_servers=$(show-file-servers 'cur' ${VALUES[${pos}+2]})
    blankItemContent[0]="<span style='line-height:10px; margin:0; padding:0;' id='${check_id}-insider'><i>&lt;not yet checked&gt;</i></span>"
    blankItemContent[2]="type='checkbox'${checked_aload}"
    blankItemContent[3]=$(show-file-protocol1 ${VALUES[${pos}+1]:1})
    blankItemContent[4]=${file_servers}
    blankItemContent[5]="type='text' size='48' maxlength='128' value='${VALUES[${pos}+3]}'"
    blankItemContent[6]="type='checkbox'${accept_value} onClick='agreeLicense(\"${accept_id}\")'"
    blankItemContent[7]="value=''"

    checkItem[2]=printable

    itemForm[0]="text"
    itemForm[1]="text"
    itemForm[2]="check"
    itemForm[3]="select"
    itemForm[4]="select"
    itemForm[6]="check"
    itemForm[7]="hidden"
    
    itemState[3]=${field_state}
    itemState[4]=${field_state}
    itemState[5]=${field_state}

    itemFormCheckCB[2]="patchOperationAutoLoadCB( 'aload', 'protocol', 'server', 'filename' );"

    shortcutMenuItem[0]="access-file"
    shortcutMenuItem[1]="password-file"
    shortcutMenuTitle[0]="File Servers"
    shortcutMenuTitle[1]="Accounts"

    show-title "Load OS Patch" "${state}" "access password system"
    show-shortcuts-menu

    local progression=$(echo-patch-download-percent)	

    show-form "${width}" ${state}

    init-refresh-exchnage-file-progress-bar ${patch_id} ${progress_id} ${progression} "patch-download-percentage"
}
