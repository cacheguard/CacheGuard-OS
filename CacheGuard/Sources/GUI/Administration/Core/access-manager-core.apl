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

show-access-manager-form()
{
    local get_args=${1}
    local page_ref=$(get-arg-value "${get_args}" page)

    local width=${DEFAULT_LIST_FORM_WIDTH}
    local state

    itemWidth[1]=50
    itemWidth[2]=50
    
    itemTitle[0]="Manager"
    itemTitle[1]="Role"
    itemTitle[2]="Network Interface"
    itemTitle[3]="IP Address"
    itemTitle[4]="Public SSH Key"

    itemID[0]=""
    itemID[1]="role"
    itemID[2]="interface"
    itemID[3]="ip"
    itemID[4]="ssh_key"

    blankItemContent[0]=""
    blankItemContent[1]="master backup"
    blankItemContent[2]="internal external auxiliary"
    blankItemContent[3]="type='text' size='15' maxlength='15'"
    blankItemContent[4]="cols='40' rows='20'"

    itemForm[1]="select"
    itemForm[2]="select"
    itemForm[4]="textarea"

    checkItem[3]=ip

    local access
    local interface role ip
    local key_id key_link key_title="Show or Load the Key"
    local elt range i=0

    for elt in ${ACCESS_MANAGER_LIST}
    do
	range=$[${i} % 3]
	case ${range} in
	    0)
		role=${elt}
		;;
	    1)
		interface=${elt}
		;;
	    2)
		ip=${elt}

		key_id=$(get-manager-key-id ${role})
		key_link="<a href=\"admin-ssh-key-load.${GUI_EXT_NAME}?key:${key_id}\"><img src=\"${IMAGE_DIR}/admin-ssh-key.png\" alt=\"${key_title}\" title=\"${key_title}\" /></a>"
		key_link=$(encode-string "${key_link}")
		access="${access} ${role} ${interface} ${ip} ${key_link}"
		;;
	    *)
		return 255
		;;
	esac
	((i++))
    done

    listContent=${access:1}
    listContentStep=4

    test -n "${listContent}" || state=disabled

    show-title "Allowed Manager Appliance IPs" "${state}" "access admin"
    show-multi-form ${MAX_ACL_MANAGER_NB} "${width}" "${page_ref}"
}

# Main()

show-access-manager-form "${@}"
