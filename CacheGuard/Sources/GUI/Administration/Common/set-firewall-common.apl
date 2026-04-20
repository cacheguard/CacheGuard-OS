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

set-firewall()
{
    test -n "${1}" || return 1
    local rset=${1}

    local pos=0 entry_pos del_pos offset
    local rule_id_pos state_pos action_pos
    local protocol_pos src_ip_pos dst_dev_pos dst_ip_pos dst_ports_pos
    local src_nat_ip_pos dst_nat_ip_pos dst_pat_port_pos 
    
    local entry_type rule_id state action
    local protocol src_ip dst_dev dst_ip dst_ports
    local src_nat_ip dst_nat_ip dst_pat_port

    local old_rule_id location position prev_rule_id rule new_list
    local states del_array insert_array add_array move_array
    declare -a del_array insert_array add_array move_array
    local del_nb=0 insert_nb=0 add_nb=0 move_nb=0 i

    local transaction=/tmp/${TRANSACTION_FILE}.wadmin.${REMOTE_USER}.${$}
    rm -f ${transaction}

    while test ${pos} -lt ${ATTRIBUTE_NB}
    do
	offset=0
	entry_pos=${pos}
	rule_id_pos=$[${pos} + ${offset} + 1]
	state_pos=$[${pos} + ${offset} + 2]

	[[ "${ATTRIBUTES[${state_pos}]}" =~ ^state_[0-9]+$ ]]
	if test ${?} -eq 0 ; then
	    state=on
	else
	    state=off
	    ((offset--))
	fi

	action_pos=$[${pos} + ${offset} + 3]
	protocol_pos=$[${pos} + ${offset} + 4]
	src_ip_pos=$[${pos} + ${offset} + 5]
	dst_dev_pos=$[${pos} + ${offset} + 6]
	dst_ip_pos=$[${pos} + ${offset} + 7]
	dst_ports_pos=$[${pos} + ${offset} + 8]
	src_nat_ip_pos=$[${pos} + ${offset} + 9]
	dst_nat_ip_pos=$[${pos} + ${offset} + 10]
	dst_pat_port_pos=$[${pos} + ${offset} + 11]
	del_pos=$[${pos} + ${offset} + 12]

	entry_type=${VALUES[${entry_pos}]}
	rule_id=${VALUES[${rule_id_pos}]}
	action=${VALUES[${action_pos}]}
	protocol=${VALUES[${protocol_pos}]}

	src_ip=${VALUES[${src_ip_pos}]}
	dst_dev=${VALUES[${dst_dev_pos}]}
	dst_ip=${VALUES[${dst_ip_pos}]}
	dst_ports=${VALUES[${dst_ports_pos}]}
	src_nat_ip=${VALUES[${src_nat_ip_pos}]}
	dst_nat_ip=${VALUES[${dst_nat_ip_pos}]}
	dst_pat_port=${VALUES[${dst_pat_port_pos}]}

	src_ip=${src_ip// /}
	dst_ip=${dst_ip// /}
	dst_ports=${dst_ports// /}
	
	[[ "${ATTRIBUTES[${del_pos}]}" =~ ^del_[0-9]+$ ]]
	if test ${?} -eq 0 ; then
	    del_array[${del_nb}]="${rule_id}"
	    ((del_nb++))
	    pos=$[${pos} + ${offset} + 13]
	else
	    if test -n "${rule_id}" ; then

		if test "${entry_type}" == anew -o "${entry_type}" == inew ; then
		    test -n "${src_ip}" || src_ip=any
		    test -n "${dst_ip}" || dst_ip=any
		    test -n "${dst_ports}" || dst_ports=any
		    test -n "${src_nat_ip}" || src_nat_ip=nil
		    test -n "${dst_nat_ip}" || dst_nat_ip=nil
		    test -n "${dst_pat_port}" || dst_pat_port=nil

		    case "${protocol}" in
			tcp|udp|ftp_active|ftp_passive|ftp_trivial|sip)
			    ;;
			*)
			    dst_ports=any
			    dst_pat_port=nil
			    ;;
		    esac

		    rule="'${rule_id}' '${action}' '${protocol}' '${src_ip}' '${dst_dev}' '${dst_ip}' '${dst_ports}'"
		    rule="${rule} '${src_nat_ip}' '${dst_nat_ip}' '${dst_pat_port}'"

		    new_list="${new_list} ${rule_id}"

		    case "${entry_type}" in
			anew)
			    add_array[${add_nb}]="${rule}"
			    ((add_nb++))
			    ;;
			inew)
			    insert_array[${insert_nb}]="${rule}"
			    ((insert_nb++))
			    ;;
			*)
			    ;;
		    esac
		
		elif test "${entry_type:0:4}" == move ; then
		    position=${entry_type:4}
		    move_array[${move_nb}]="${rule_id}:${position}:${prev_rule_id}"
		    ((move_nb++))
		elif test "${entry_type}" == old ; then
		    old_rule_id=${rule_id}

		    for ((i=0 ; i<insert_nb ; i++))
		    do
			echo "firewall ${rset} 'insert:${rule_id}' ${insert_array[${i}]}" >> ${transaction}
		    done
		    unset insert_array
		    insert_nb=0
		fi
		states="${states} ${state} ${rule_id}"
	    fi
	    pos=$[${pos} + ${offset} + 12]
	fi
	prev_rule_id=${rule_id}
    done

    new_list=${new_list:1}

    for ((i=0 ; i<insert_nb ; i++))
    do
        echo "firewall ${rset} 'insert:${rule_id}' ${insert_array[${i}]}" >> ${transaction}
    done

    if test -n "${old_rule_id}" ; then
	rule_id=${old_rule_id}
	for ((i=0 ; i<add_nb ; i++))
	do
	    echo "firewall ${rset} 'add:${rule_id}' ${add_array[${i}]}" >> ${transaction}
	    rule_id=${add_array[${i}]/ *}
	done
    else
	for ((i=0 ; i<add_nb ; i++))
	do
	    echo "firewall ${rset} add ${add_array[${i}]}" >> ${transaction}
	done
    fi

    for ((i=0 ; i<move_nb ; i++))
    do
	location=${move_array[${i}]}
	rule_id=${location/:*}
	prev_rule_id=${location/*:}

	if test -z "${prev_rule_id}" ; then
	    position=${location#*:}
	    position=${position/:*}
	    echo "firewall ${rset} move:${position} '${rule_id}'" >> ${transaction}
	else
	    
	    echo "firewall ${rset} 'move:+${prev_rule_id}' '${rule_id}'" >> ${transaction}
	fi
    done

    for ((i=0 ; i<del_nb ; i++))
    do
	! member "${new_list}" ${del_array[${i}]} || continue
	echo "firewall ${rset} del ${del_array[${i}]}" >> ${transaction}
    done

    states=${states:1}
    test -z "{states}" || echo "firewall ${rset} ${states}" >> ${transaction}

    execute-transaction ${transaction}
}
