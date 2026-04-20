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

show-manager-sync-role()
{
    show-list-options "alone master slave" ${1}
}

show-manager-sync-form()
{
    local in_role width=${DEFAULT_LIST_FORM_WIDTH}
    local ssh_key_title="Load from a File server"
    local ssh_key_sz="20"

    itemWidth[0]=30
    itemWidth[1]=70

    itemTitle[0]="Role"
    itemTitle[1]="Peer IP"
    itemTitle[2]="Peer Public SSH Key"
    itemTitle[3]="Peer Public SSH Key"

    itemID[0]=role
    itemID[1]=peer_ip
    itemID[2]=ssh_key
    itemID[3]=load

    local ssh_key ssh_key_id=$(get-manager-key-id peer)

    if test -f ${TMP_DIR}/${LOADED}.${SSH_KEY}.${ssh_key_id} ; then
	ssh_key=$(cat ${TMP_DIR}/${LOADED}.${SSH_KEY}.${ssh_key_id} 2> /dev/null)
    elif test -f ${SSH_PUBLIC_KEY_DIR}/${ssh_key_id} ; then
	ssh_key=$(cat ${SSH_PUBLIC_KEY_DIR}/${ssh_key_id} 2> /dev/null)
    fi

    itemValue[2]=${ssh_key}

    if test "${REQUEST_METHOD}" == POST ; then
        in_role="${VALUES[0]}"
    else
	in_role=${MANAGER_SYNC_ROLE}
    fi

    blankItemContent[0]=$(show-manager-sync-role ${in_role})
    blankItemContent[1]="type='text' size='15' maxlength='15' value='${MANAGER_SYNC_PEER_IP}'"
    blankItemContent[2]="cols='50' rows='20'"
    blankItemContent[3]="<a href='admin-ssh-key-load.${GUI_EXT_NAME}?key:${ssh_key_id}'><img style='height:${ssh_key_sz}px; width:${ssh_key_sz}px;' src='${IMAGE_DIR}/admin-ssh-key.png' alt='' title='${ssh_key_title}' /></a>"

    checkItem[1]=ip
    checkItem[2]=printable

    itemForm[0]="select"
    itemForm[2]="textarea"
    itemForm[3]="text"

    show-title "Manager HA Peer" enabled "manager"

    show-form "${width}"
}

# Main()

show-manager-sync-form "${@}"
