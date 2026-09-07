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

show-edit-guard-rule()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    local in_policy_name=${1}
    local state=${2}

    local i=0 elt range
    local policy_name action urllists_col urllists_lst
    local urllist_name policy_title

    local available_urllists_array
    local selected_urllists_array
    local select1_id='available-countries'
    local select2_id='selected-countries'

    for elt in ${GUARD_RULE_LIST}
    do
	range=$[${i} % 3]
	case ${range} in
	    0)
		policy_name=${elt}
		;;
	    1)
		action=${elt}
		;;
	    2)
		if test ${policy_name} == ${in_policy_name} ; then
		    urllists_col=${elt}
		    urllists_lst=$(colon2space ${urllists_col})
		    break
		fi
		;;
	    *)
		return 1
		;;
	esac
	((i++))
    done

    if test -z "${urllists_lst}" ; then
	echo-unavailable-message "This rule no longer exists."
	return 0
    fi

    if test "${action}" == deny ; then
	policy_title="Denied"
    else
	policy_title="Allowed"
    fi

    if test ${in_policy_name} == default ; then
	echo "<div class='table-title'>${policy_title} URL lists for the <a href='#' data-action='show-tooltip' data-tip='The default policy is applied to end-users not caught by defined policies.'>${in_policy_name}</a> policy.</div>"
    else

	local filters_col filters_lst
	local filter filter_type filter_name
	local filters

	i=0
	for elt in ${GUARD_POLICY_LIST}
	do
	    range=$[${i} % 2]
	    case ${range} in
		0)
		    policy_name=${elt}
		    ;;
		1)
		    if test ${policy_name} == ${in_policy_name} ; then
			filters_col=${elt}
			test "${filters_col}" != "self_self" || break

			filters_lst=$(colon2space ${filters_col})
			for filter in ${filters_lst}
			do
			    test ${filter} != "self_self" || continue
			    filter_type=${filter/_*}
			    filter_name=${filter#*_}
			    case ${filter_type} in
				ip)
				    filter_description=$(get-ip-filter ${filter_name})
				    ;;
				"time")
				    filter_description=$(get-time-filter ${filter_name})
				    ;;
				ldap)
				    filter_description=$(get-ldap-filter ${filter_name})
				    ;;
				*)
				    ;;
			    esac
			    filter_name="<a href='#' data-action='show-tooltip' data-tip='${filter_description}'>${filter_name}</a>"
			    filters="${filters}, [${filter_type}] ${filter_name}"
			done

			break
		    fi
		    ;;
		*)
		    break
		    ;;
	    esac
	    ((i++))
	done

	filters=${filters:2}

        echo "<span class='shortcut-menu-item'><a href='/${GUI_DIR_NAME}/edit-guard-policy.${GUI_EXT_NAME}?${in_policy_name}'>Edit <strong>${in_policy_name}</strong> policy</a></span>"

        echo "<span>"
        if test -z "${filters}" ; then
            echo "= { }"
        else
            echo "= { ${filters} }"
        fi
        echo "</span>"
        echo "<div class='table-title'>${policy_title} URL lists for the <strong>${in_policy_name}</strong> policy.</div>"
    fi

    echo "<table class='bi-select-list'>"
    echo "<thead>"
    echo "<tr valign='middle'>"
    echo "<th class='table-header'>Available URL lists</th>"
    echo "<th></th>"
    echo "<th class='table-header'>${policy_title} URL lists</th>"
    echo "</tr>"
    echo "</thead>"
    
    echo "<tbody>"
    echo "<tr valign='middle'>"
    echo "<td>"
    echo "<select name='${select1_id}' id='${select1_id}' multiple>"
    for urllist_name in ${URLLIST_LIST}
    do
	! member "${urllists_lst}" ${urllist_name} || continue
	available_urllists_array="${available_urllists_array},[\"${urllist_name}\",\"${urllist_name}\"]"
	echo "<option value='${urllist_name}' id='${urllist_name}'>${urllist_name}</option>"
    done
    echo "</select>"
    echo "</td>"

    available_urllists_array="[${available_urllists_array:1}]"

    echo-add-remove-selected-row ${select1_id} ${select2_id} "URL Lists"

    echo "<td>"

    echo "<select name='${select2_id}' id='${select2_id}' multiple>"
    for urllist_name in ${urllists_lst}
    do
	test ${urllist_name} != self || continue
	selected_urllists_array="${selected_urllists_array},[\"${urllist_name}\",\"${urllist_name}\"]"
	echo "<option value='${urllist_name}' id='${urllist_name}'>${urllist_name}</option>"
    done
    selected_urllists_array="[${selected_urllists_array:1}]"

    echo "</select>"
    echo "</td>"

    echo "</tr>"
    echo "</tbody>"
    echo "</table>"

    show-form-begin
    echo "<input name='policy_name' type='hidden' value='${in_policy_name}' />"
    echo "<input name='policy_action' type='hidden' value='${action}' />"

    show-do-apply ${state} 'add-hidden-input-from-selection-item' "[\"${select2_id}\"]" before
    show-do-reset ${state} 'set-select-guard-rule-options' "[\"${select1_id}\",${available_urllists_array},\"${select2_id}\",${selected_urllists_array}]"
    show-form-end
}

edit-guard-rule()
{
    local get_args=${1}
    local name=$(get-arg-value "${get_args}" key)

    if test -z "${name}" ; then
	redirect-page "guard-rule"
	return 0
    fi

    local state key

    if test -n "${URLLIST_LIST}" ; then
	state=enabled
    else
	state=disabled
    fi

    show-title "Editing a URL Guarding Rule" "${state}" "guard"

    echo "<div class='core-form'>"
    show-edit-guard-rule ${name} ${state}
    echo "</div>"
}

edit-guard-rule "${@}"
