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

print-revoke-reasons()
{
    echo -n "active keyCompromise CACompromise affiliationChanged superseded cessationOfOperation unspecified"
}

show-ssh-key()
{
    local get_args=${1}
    local page_ref=$(get-arg-value "${get_args}" page)

    local key_id key_state
    local state width=${DEFAULT_LIST_FORM_WIDTH_2}

    itemWidth[1]=70

    itemTitle[0]=""
    itemTitle[1]="SSH Key Id"
    itemTitle[2]="State"

    itemForm[2]="text"

    itemID[0]="SSH Key"
    itemID[1]="key_id"
    itemID[2]="not_posted"

    blankItemContent[0]=""
    blankItemContent[1]="type='text' size='${MAX_NAME_LEN}' maxlength='${MAX_NAME_LEN}'"

    checkItem[1]=identifier

    editColumnPage[0]="admin-ssh-key-load"
    editColumnTitle[0]="Load"

    unset listContent

    for key_id in ${SSH_KEY_LIST}
    do
	if test -f ${TMP_DIR}/${LOADED}.${SSH_KEY}.${key_id} ; then
	    key_state='loaded'
	elif
	    test -f ${SSH_PUBLIC_KEY_DIR}/${key_id} ; then
	    key_state='active'
	else
	    key_state='empty'
	fi

	listContent="${listContent} ${key_id} ${key_state}"
    done

    listContent="${listContent:1}"
    listContentStep=2

    test -n "${listContent}" || state=disabled

    show-title "Administrator SSH Keys" "${disabled}" "access admin"
    show-list-form ${MAX_SSH_KEY_NB} ${width} "${page_ref}"
}

# Main()

show-ssh-key "${@}"
