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

get-ssh-key()
{
    test -n "${1}" || return 1
    local key_id=${1}

    local file

    if test -f ${TMP_DIR}/${LOADED}.${SSH_KEY}.${key_id} ; then
	file=${TMP_DIR}/${LOADED}.${SSH_KEY}.${key_id}
    elif
	test -f ${SSH_PUBLIC_KEY_DIR}/${key_id} ; then
	file=${SSH_PUBLIC_KEY_DIR}/${key_id}
    fi

    test -n "${file}" || return 0

    cat ${file}
}

show-ssh-key-set-form()
{
    local get_args=${1}
    local key_id=$(get-arg-value "${get_args}" key)

    if test -z "${key_id}" ; then
	redirect-page "admin-ssh-key"
	return 0
    fi

    local state width=550

    itemTitle[0]="Hidden"
    itemTitle[1]="SSH Key Id"
    itemTitle[2]="SSH Public Key"

    itemID[0]="key_id"
    itemID[1]="not_posted"
    itemID[2]="key_value"

    blankItemContent[0]="value='${key_id}'"
    blankItemContent[1]="${key_id}"
    blankItemContent[2]="cols='60' rows='16' maxlength='1000'"

    itemValue[2]=$(get-ssh-key ${key_id})
    checkItem[2]=text

    itemForm[0]="hidden"
    itemForm[1]="text"
    itemForm[2]="textarea"

    show-title "Set SSH Key" "${state}" "admin"
    show-form "${width}" "${state}"
}

# Main()

show-ssh-key-set-form "${@}"
