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

source edit-guard-common.${GUI_EXT_NAME}

set-all-guard-filters()
{
    local i=0 nb=0 elt range
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
    local filter_item filter_description

    local from_filters_array
    local to_filters_array
    
    local arrow_sz=25px
    local length=2

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

    echo "<table class='highlight-list'>"
    echo "<thead>"
    echo "<tr>"
    echo "<td class='table-header' width='47%'>Available Filters</td>"
    echo "<td class='table-header' width='6%' style='background:none; background-color:White; border:none'></td>"
    echo "<td class='table-header' width='47%'>Selected Filters</td>"
    echo "</tr>"
    echo "</thead>"
    
    echo "<tbody>"
    echo "<tr>"

    set-all-guard-filters

    echo "<td style='background-color:White;padding:0;margin:0;padding-top:5px;padding-bottom:5px;'>"
    echo "<select name='filter_from' id='filter_from' multiple size='16' style='width:100%;'>"

    nb=${#FILTERS[@]}
    
    for ((i=0 ; i < ${nb} ; i++))
    do
	filter=${FILTERS[${i}]}
	! member "${filters_lst}" ${filter/:/_} || continue

	filter_type=${filter/:*}
	case ${filter_type} in
	    ip)
		tip_width=250
		;;
	    "time")
		tip_width=250
		;;
	    ldap)
		tip_width=400
		;;
	    *)
		;;
	esac
	
	filter_name=${filter/*:}
	filter_item="[${filter_type}] ${filter_name}"
	filter_description=${FILTER_DESCRIPTIONS[${i}]}
	from_filters_array="${from_filters_array},['${filter}','${filter}']"
	from_filters_tips="${from_filters_tips},'${tip_width}:${filter_description}'"

	echo -n "<option id='${filter}' value='${filter}' onMouseOver='ddrivetip( \"${filter_description}\", ${tip_width} );' onMouseOut='hideddrivetip( );'>${filter_item}</option>"
    done
    echo "</select>"
    echo "</td>"

    from_filters_array="[${from_filters_array:1}]"
    from_filters_tips="[${from_filters_tips:1}]"

    echo "<td style='background-color:White;padding:0;margin:0;'>"
    echo "<center><a href='JavaScript:void( 0 );' id='add_button'><img src='/image/right-arrow.png' alt='Add Selected Filters' title='Add Selected Filters' align='top' width='${arrow_sz}' height='${arrow_sz}' style='height:${arrow_sz}; width:${arrow_sz};' /></a></center>"

    echo "<center><a href='JavaScript:void( 0 );' id='del_button'><img src='/image/left-arrow.png' alt='Remove Selected Filters' title='Remove Selected Filters' align='top' width='${arrow_sz}' height='${arrow_sz}' style='height:${arrow_sz}; width:${arrow_sz};' /></a></center>"
    echo "</td>"

    echo "<td style='background-color:White;padding:0;margin:0;padding-top:5px;padding-bottom:5px;'>"

    echo "<select name='filter' id='filter' multiple size='16' style='width:100%;'>"
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
		tip_width=250
		;;
	    "time")
		tip_width=250
		filter_description=$(get-time-filter ${filter_name})
		;;
	    ldap)
		tip_width=400
		filter_description=$(get-ldap-filter ${filter_name})
		;;
	    *)
		;;
	esac

	to_filters_array="${to_filters_array},['${filter}','${filter}']"
	to_filters_tips="${to_filters_tips},'${tip_width}:${filter_description}'"
	echo -n "<option id='${filter}' value='${filter}' onMouseOver='ddrivetip( \"${filter_description}\", ${tip_width} );' onMouseOut='hideddrivetip( );'>${filter_item}</option>"

    done

    to_filters_array="[${to_filters_array:1}]"
    to_filters_tips="[${to_filters_tips:1}]"

    echo "</select>"
    echo "</td>"

    echo "<tr>"
    echo "</tbody>"
    echo "</table>"
    echo "<br />"

    show-form-begin ${length}
    echo "<input name='policy_name' type='hidden' value='${in_policy_name}' />"
    echo "<input name='action' type='hidden' value='${action}' />"
    
    show-do ${state} ${state} "addHiddenInputFromSelectionItem( 'mainform', 'filter' )" "setSelectOptions( 'filter_from', ${from_filters_array}, ${from_filters_tips} ); setSelectOptions( 'filter', ${to_filters_array}, ${to_filters_tips} )"
    show-form-end
    echo "<script type='text/javascript'>"
    echo "initSelectionList( 'filter_from', 'filter', 'add_button', 'del_button' );"
    echo "</script>"
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
