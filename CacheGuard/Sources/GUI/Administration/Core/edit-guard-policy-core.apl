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

source edit-guard-common.${GUI_EXT_NAME}

set-all-guard-filters()
{
    local elt range i=0 nb=0
    local filter_name
    local description
    local ip_key ip1 ip2
    local time_type time
    local ldap_group ldap_login ldap_filter

    unset FILTER_DESCRIPTIONS
    unset FILTERS

    for elt in ${GUARD_FILTER_IP_LIST}
    do
	range=$[${i} % 4]
	case ${range} in
	    0)
		filter_name=${elt}
		;;
	    1)
		ip_key=${elt}
		;;
	    2)
		ip1=${elt}
		;;
	    3)
		ip2=${elt}

		case ${ip_key} in
		    range)
			if test ${ip1} == ${ip2} ; then
			    description="[ip] ${ip1}"
			else
			    description="[range] ${ip1}-${ip2}"
			fi
			;;
		    network)
			description="[network] ${ip1}/${ip2}"
			;;
		    *)
			;;
		esac

		FILTER_DESCRIPTIONS[${nb}]="${description}"
		FILTERS[${nb}]="ip:${filter_name}"
		((nb++))
		;;
	    *)
		break
		;;
	esac
	((i++))
    done

    i=0
    for elt in ${GUARD_FILTER_TIME_LIST}
    do
	range=$[${i} % 3]
	case ${range} in
	    0)
		filter_name=${elt}
		;;
	    1)
		time_type=${elt}
		;;
	    2)
		time=${elt}
		description="[${time_type}] ${time}"
		FILTERS[${nb}]="time:${filter_name}"
		FILTER_DESCRIPTIONS[${nb}]="${description}"
		((nb++))
		;;
	    *)
		break
		;;
	esac
	((i++))
    done

    i=0
    for elt in ${GUARD_FILTER_LDAP_LIST}
    do
	range=$[${i} % 4]
	case ${range} in
	    0)
		filter_name=${elt}
		;;
	    1)
		ldap_group=${elt}
		;;
	    2)
		ldap_login=${elt}
		;;
	    3)
		ldap_filter=${elt}
		description="[group dn ${ldap_group}], [login attribute ${ldap_login}], [ldap filter ${ldap_filter}]"
		FILTERS[${nb}]="ldap:${filter_name}"
		FILTER_DESCRIPTIONS[${nb}]="${description}"
		((nb++))
		;;
	    *)
		break
		;;
	esac
	((i++))
    done
}

show-edit-guard-policy()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    local in_policy_name=${1}
    local state=${2}

    local i=0 nb elt range
    local policy_name filters_col filters_lst
    local filter filter_type filter_name
    local filter_item filter_description from_filters_tips

    local available_filters_array
    local selected_filters_array
    local select1_id='available-filters'
    local select2_id='selected-filters'

    for elt in ${GUARD_POLICY_LIST}
    do
	range=$[${i} % 2]
	case ${range} in
	    0)
		policy_name=${elt}
		;;
	    1)
		if test ${in_policy_name} == ${policy_name} ; then
		    filters_col=${elt}
		    filters_lst=$(colon2space ${filters_col})
		    break
		fi
		;;
	    *)
		return 1
		;;
	esac
	((i++))
    done

    if test -z "${filters_lst}" ; then
	echo-unavailable-message "This policy no longer exists."
	return 0
    fi

    echo "<div class='table-title'>Associated filters to the <strong>${in_policy_name}</strong> policy</div>"

    echo "<table class='bi-select-list'>"
    echo "<thead>"
    echo "<tr>"
    echo "<th class='table-header'>Available Filters</th>"
    echo "<th></th>"
    echo "<th class='table-header'>Selected Filters</th>"
    echo "</tr>"
    echo "</thead>"
    
    echo "<tbody>"
    echo "<tr>"

    set-all-guard-filters
    
    echo "<td>"
    echo "<select name='${select1_id}' id='${select1_id}' multiple>"

    nb=${#FILTERS[@]}
    
    for ((i=0 ; i < ${nb} ; i++))
    do
	filter=${FILTERS[${i}]}
	! member "${filters_lst}" ${filter/:/_} || continue

	filter_type=${filter/:*}	
	filter_name=${filter/*:}
	filter_item="[${filter_type}] ${filter_name}"
	filter_description=${FILTER_DESCRIPTIONS[${i}]}
	available_filters_array="${available_filters_array},['${filter}','${filter_item}']"
	from_filters_tips="${from_filters_tips},'${filter_description}'"

	echo -n "<option id='${filter}' value='${filter}' data-action='show-tooltip' data-tip='${filter_description}'>${filter_item}</option>"
    done
    echo "</select>"
    echo "</td>"

    available_filters_array="[${available_filters_array:1}]"
    from_filters_tips="[${from_filters_tips:1}]"

    echo-add-remove-selected-row ${select1_id} ${select2_id} "Policies"

    echo "<td>"

    echo "<select name='${select2_id}' id='${select2_id}' multiple>"

    for filter in ${filters_lst}
    do
	test ${filter} != self_self || continue
	filter=${filter/_/:}
	filter_type=${filter/:*}
	filter_name=${filter/*:}
	filter_item="[${filter_type}] ${filter_name}"
	case ${filter_type} in
	    ip)
		filter_description=$(get-ip-filter ${filter_name})
		;;
	    'time')
		filter_description=$(get-time-filter ${filter_name})
		;;
	    ldap)
		filter_description=$(get-ldap-filter ${filter_name})
		;;
	    *)
		;;
	esac

	selected_filters_array="${selected_filters_array},['${filter}','${filter_item}']"
	to_filters_tips="${to_filters_tips},'${filter_description}'"
	echo -n "<option id='${filter}' value='${filter}' data-action='show-tooltip' data-tip='${filter_description}'>${filter_item}</option>"

    done

    selected_filters_array="[${selected_filters_array:1}]"
    to_filters_tips="[${to_filters_tips:1}]"

    echo "</select>"
    echo "</td>"

    echo "</tr>"

    echo "</tbody>"
    echo "</table>"

    show-form-begin
    echo "<input name='policy_name' type='hidden' value='${in_policy_name}' />"

    show-do-apply ${state} 'add-hidden-input-from-selection-item' "[\"${select2_id}\"]" before
    show-do-reset ${state} 'set-select-guard-policy-options' "[\"${select1_id}\",\"${available_filters_array}\",\"${from_filters_tips}\",\"${select2_id}\",\"${selected_filters_array}\",\"${to_filters_tips}\"]"

    show-form-end
}

edit-guard-rule()
{
    local get_args=${1}
    local name=$(get-arg-value "${get_args}" key)

    if test -z "${name}" ; then
	redirect-page "guard-policy"
	return 0
    fi

    local state key

    if test -n "${GUARD_FILTER_IP_LIST}" -o -n "${GUARD_FILTER_TIME_LIST}" -o -n "${GUARD_FILTER_LDAP_LIST}" ; then
	state=enabled
    else
	state=disabled
    fi

    show-title "Editing a URL Guarding Policy" "${state}" "guard"
    echo "<div class='core-form'>"
    show-edit-guard-policy ${name} ${state}
    echo "</div>"
}

edit-guard-rule "${@}"
