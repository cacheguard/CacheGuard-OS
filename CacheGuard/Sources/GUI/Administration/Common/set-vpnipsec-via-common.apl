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

set-vpnipsec-via()
{
    test -n "${1}" || return 1
    local vpn_type=${1}

    test "${ATTRIBUTES[0]}" == "vpn_id" || return 0

    local vpn_key

    case ${vpn_type} in
	access)
	    vpn_key="${vpn_type}"
	    ;;
	site)
	    local vpn_id=${VALUES[0]}
	    vpn_key="${vpn_type} ${vpn_id}"
	    ;;
	*)
	    return 11
	    ;;
    esac

    local pos=1 entry_pos del_pos
    local gateway_pos role_pos prio_pos

    local transaction=/tmp/${TRANSACTION_FILE}.wadmin.${REMOTE_USER}.${$}
    rm -f ${transaction}

    while test ${pos} -lt ${ATTRIBUTE_NB}
    do
	entry_pos=${pos}
	gateway_pos=$[${pos} + 1]
	role_pos=$[${pos} + 2]
	prio_pos=$[${pos} + 3]
	del_pos=$[${pos} + 4]

	[[ "${ATTRIBUTES[${del_pos}]}" =~ ^del_[0-9]+$ ]]
	if test ${?} -ne 0 ; then
	    if test "${VALUES[${entry_pos}]}" == anew ; then
		echo "vpnipsec via ${vpn_key} add '${VALUES[${gateway_pos}]}' '${VALUES[${role_pos}]}' '${VALUES[${prio_pos}]}'" >> ${transaction}
	    fi
	    pos=$[${pos} + 4]
	else
	    echo "vpnipsec via ${vpn_key} del '${VALUES[${gateway_pos}]}'" >> ${transaction}
	    pos=$[${pos} + 5]
	fi
    done

    execute-transaction ${transaction}
}
