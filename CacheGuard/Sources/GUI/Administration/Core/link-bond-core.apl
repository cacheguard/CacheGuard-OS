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

show-nic()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    local interface=${1}
    local state=${2}

    local length=1

    local eth mac info
    local bonds aux_used=0
    local backups_t n i=0
    declare -a backups_t

    case ${interface} in
	internal)
	    bonds=${BOND_INTERNALS}
	    ;;
	external)
	    bonds=${BOND_EXTERNALS}
	    ;;
	auxiliary)
	    bonds=${BOND_AUXILIARIES}
	    ;;
	*)
	    ;;
    esac

    local options selected
    local max=$[3 * ${MAX_BOND_NB}]
    local master=${bonds/ */}

    while read eth mac info
    do
	test ${i} -lt ${max} || break
	
	case ${state} in
	    master)
		test "${eth}" != "${master}" || aux_used=1
		selected=$(get-selected-option "${eth}" "${master}")
		options="${options}<option value='${eth}' ${selected}>Ethernet ${i}: ${info} [${mac}]</option>"
		;;

	    backup)
		if member "${bonds}" "${eth}" && test "${eth}" != "${master}"; then
		    selected=' checked'
		else
		    unset selected
		fi

		backups_t[${i}]="<input type='checkbox' name='${interface}_${i}' id='${interface}_${i}' value='${eth}'${selected} /> Ethernet ${i}: ${info} [${mac}]"
		;;
	    *)
		;;
	esac
	((i++))
    done < ${HARD_DIR}/hw-links
    n=${i}

    case ${state} in
	master)
	    echo "<tr><td></td><td class='table-title'><strong>${interface^} Interface</strong><td></tr>"
	    echo "<tr>"
	    echo "<td>${state^} Interface</td>"
	    echo "<td>"

	    echo "<select name='${interface}' id='${interface}'>"
	    if test ${interface} == auxiliary ; then
		selected=$(get-selected-option ${aux_used} 1)
		options="<option value='none'${selected}>None: Don't use an auxiliary NIC</option>${options}"
	    fi
	    echo ${options}

	    echo "</select>"
	    echo "</td>"
	    echo "</tr>"
	    ;;

	backup)
	    echo "<tr>"
	    echo "<td>${state^} Interface</td>"
	    echo "<td>${backups_t[0]}</td>"
	    echo "</tr>"

	    for ((i=1 ; i<n ; i++))
	    do
		echo "<tr>"
		echo "<td></td><td>${backups_t[${i}]}</td>"
		echo "</tr>"
	    done
	    ;;
	*)
	    ;;
    esac
}

show-bond-form()
{
    show-title "Links Bonding" "enabled" "link"

    echo "<div class='core-form'>"
    show-form-begin 3

    echo "<table class='highlight-form'>"

    if gui-contextual-is-allowed ; then
	show-nic external master
	show-nic external backup
    fi

    show-nic internal master
    show-nic internal backup

    if gui-contextual-is-allowed ; then
	show-nic auxiliary master
	show-nic auxiliary backup
    fi

    echo "</table>"
    show-do
    show-form-end
    echo "</div>"
}

# Main()

show-bond-form
