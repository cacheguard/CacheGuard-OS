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

set-access2()
{
    test -n "${1}" || return 1
    local at=${1}

    local pos=0
    local interface_pos network_pos
    local entry_pos del_pos

    local transaction=/tmp/${TRANSACTION_FILE}.wadmin.${REMOTE_USER}.${$}
    rm -f ${transaction}

    while test ${pos} -lt ${ATTRIBUTE_NB}
    do
	entry_pos=${pos}
	interface_pos=$[${pos} + 1]
	network_pos=$[${pos} + 2]
	del_pos=$[${pos} + 3]
	
	[[ "${ATTRIBUTES[${del_pos}]}" =~ ^del_[0-9]+$ ]]

	if test ${?} -ne 0 ; then
	    if test "${VALUES[${entry_pos}]}" == anew ; then
		if test -n "${VALUES[${network_pos}]}" ; then
		    echo "access '${at}' add '${VALUES[${interface_pos}]}' '${VALUES[${network_pos}]}'" >> ${transaction}
		fi
	    fi
	    pos=$[${pos} + 3]
	else
	    echo "access '${at}' del '${VALUES[${interface_pos}]}' '${VALUES[${network_pos}]}'" >> ${transaction}
	    pos=$[${pos} + 4]
	fi
    done

    execute-transaction ${transaction}
}

set-access3()
{
    test -n "${1}" || return 1
    local at=${1}
    
    local pos=0
    local interface_pos network_pos netmask_pos
    local entry_pos del_pos

    local transaction=/tmp/${TRANSACTION_FILE}.wadmin.${REMOTE_USER}.${$}
    rm -f ${transaction}

    while test ${pos} -lt ${ATTRIBUTE_NB}
    do
	entry_pos=${pos}
	interface_pos=$[${pos} + 1]
	network_pos=$[${pos} + 2]
	netmask_pos=$[${pos} + 3]
	del_pos=$[${pos} + 4]
	
	[[ "${ATTRIBUTES[${del_pos}]}" =~ ^del_[0-9]+$ ]]

	if test ${?} -ne 0 ; then
	    if test "${VALUES[${entry_pos}]}" == anew ; then
		if test -n "${VALUES[${network_pos}]}" ; then
		    if test -n "${VALUES[${netmask_pos}]}" ; then
			echo "access '${at}' add '${VALUES[${interface_pos}]}' '${VALUES[${network_pos}]}' '${VALUES[${netmask_pos}]}'" >> ${transaction}
		    else
			echo "access '${at}' add '${VALUES[${interface_pos}]}' '${VALUES[${network_pos}]}'" >> ${transaction}
		    fi
		fi
	    fi
	    pos=$[${pos} + 4]
	else
	    echo "access '${at}' del '${VALUES[${interface_pos}]}' '${VALUES[${network_pos}]}' '${VALUES[${netmask_pos}]}'" >> ${transaction}
	    pos=$[${pos} + 5]
	fi
    done

    execute-transaction ${transaction}
}

set-access4()
{
    test -n "${1}" || return 1
    local at=${1}

    local pos=0
    local interface_pos network_pos netmask_pos qos_pos
    local entry_pos del_pos
    local net mk px

    local transaction=/tmp/${TRANSACTION_FILE}.wadmin.${REMOTE_USER}.${$}
    rm -f ${transaction}

    while test ${pos} -lt ${ATTRIBUTE_NB}
    do
	entry_pos=${pos}
	interface_pos=$[${pos} + 1]
	network_pos=$[${pos} + 2]
	netmask_pos=$[${pos} + 3]
	qos_pos=$[${pos} + 4]
	del_pos=$[${pos} + 5]

	net=${VALUES[${network_pos}]}
	mk=${VALUES[${netmask_pos}]}

	[[ "${ATTRIBUTES[${del_pos}]}" =~ ^del_[0-9]+$ ]]
	if test ${?} -ne 0 ; then
	    if test "${VALUES[${entry_pos}]}" == anew ; then
		if test -n "${net}" ; then
		    if test -z "${mk}" ; then
			px=${net/*\/}
			test ${net} != ${px} || mk=255.255.255.0
		    fi
		    case ${at} in
			web|antivirus)
			    echo "access '${at}' add '${VALUES[${interface_pos}]}' '${net}' ${mk} '${VALUES[${qos_pos}]}'" >> ${transaction}
			    ;;
			tweb)
			    echo "transparent add '${VALUES[${interface_pos}]}' '${net}' ${mk} '${VALUES[${qos_pos}]}'" >> ${transaction}
			    ;;
			*)
			    ;;
		    esac
		fi
	    fi
	    pos=$[${pos} + 5]
	else
	    case ${at} in
		web)
		    echo "access '${at}' del '${VALUES[${interface_pos}]}' '${net}' '${mk}'" >> ${transaction}
		    ;;
		tweb)
		    echo "transparent del '${VALUES[${interface_pos}]}' '${net}' '${mk}'" >> ${transaction}
		    ;;
		*)
		    ;;
	    esac
	    pos=$[${pos} + 6]
	fi
    done

    execute-transaction ${transaction}
}
