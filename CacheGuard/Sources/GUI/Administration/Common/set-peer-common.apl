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

set-peers()
{
    test -n "${1}" || return 1
    local ptype=${1}
    
    local peers

    case ${ptype} in
	share)
	    ;;
	ha)
	    ;;
	next)
	    ;;
	previous)
	    ;;
	*)
	    return 1
	    ;;
    esac

    local pos=0 entry_pos del_pos
    local ip_pos qos_pos

    local transaction=/tmp/${TRANSACTION_FILE}.wadmin.${REMOTE_USER}.${$}
    rm -f ${transaction}

    while test ${pos} -lt ${ATTRIBUTE_NB}
    do
	entry_pos=${pos}
	ip_pos=$[${pos} + 1]
	qos_pos=$[${pos} + 2]
	del_pos=$[${pos} + 3]
	
	[[ "${ATTRIBUTES[${del_pos}]}" =~ ^del_[0-9]+$ ]]
	if test ${?} -ne 0 ; then
	    if test "${VALUES[${entry_pos}]}" == anew -a -n "${VALUES[${ip_pos}]}" ; then
		echo "peer ${ptype} add '${VALUES[${ip_pos}]}' '${VALUES[${qos_pos}]}'" >> ${transaction}
	    fi
	    
	    pos=$[${pos} + 3]
	else
	    echo "peer ${ptype} del '${VALUES[${ip_pos}]}'" >> ${transaction}
	    pos=$[${pos} + 4]
	fi
    done
    
    execute-transaction ${transaction}
}
