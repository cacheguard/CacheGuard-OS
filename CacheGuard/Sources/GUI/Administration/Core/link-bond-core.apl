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

show-nic()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 1
    test -n "${3}" || return 1
    local dev=${1}
    local state=${2}
    local title=${3}

    local left=15
    local right=85
    local length=1

    local eth mac info nb=0
    local bonds
    local aux_used=0

    echo "<tr>"
    echo "<td width='${left}%' valign='center' align='center'>${title}</td>"
    echo "<td width='${right}%' align='left'>"

    case ${dev} in
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
	test ${nb} -lt ${max} || break
	
	case ${state} in
	    master)
		test "${eth}" != "${master}" || aux_used=1
		selected=$(get-selected-option "${eth}" "${master}")
		options="${options}<option value='${eth}' ${selected}>Ethernet ${nb}: ${info} [${mac}]</option>"
		;;
	    backup)
		if member "${bonds}" "${eth}" && test "${eth}" != "${master}"; then
		    selected=checked
		else
		    unset selected
		fi
		echo "<div style='font-size:80%;'>"
		echo "<input style='width:20px;' type='checkbox' name='${dev}_${nb}' id='${dev}_${nb}' value='${eth}' ${selected} />"
		echo "Ethernet ${nb}: ${info} [${mac}]"
		echo "</div>"
		;;
	    *)
		;;
	esac
	((nb++))
    done < ${HARD_DIR}/hw-links

    if test ${state} == master ; then
	echo "<select name='${dev}' id='${dev}'>"
	if test ${dev} == auxiliary ; then
	    selected=$(get-selected-option ${aux_used} 1)
	    options="<option value='none'${selected}>None: Don't use an auxiliary NIC</option>${options}"
	fi
	echo ${options}
	echo "</select>"
    fi

    echo "</td>"
    echo "</tr>"
}

show-bond-form()
{
    show-title "Links Bonding" "enabled" "link"

    echo "<div class='core-form'>"
    show-form-begin 3
    echo "<table class='highlight-form'>"

    if gui-contextual-is-allowed ; then
	show-nic external master "Master<br />External"
	show-nic external backup "Backup<br />External"
    fi

    show-nic internal master "Master<br />Internal"
    show-nic internal backup "Backup<br />Internal"

    if gui-contextual-is-allowed ; then
	show-nic auxiliary master "Master<br />Auxiliary"
	show-nic auxiliary backup "Backup<br />Auxiliary"
    fi

    echo "</table>"
    show-do
    show-form-end
    echo "</div>"
}

# Main()

show-bond-form
