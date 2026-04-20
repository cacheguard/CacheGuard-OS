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

show-edit-guard-rule()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    local in_policy_name=${1}
    local state=${2}

    local select_size=16
    local arrow_sz=25px
    local length=2

    local i=0 elt range
    local policy_name action urllists_col urllists_lst
    local urllist_name policy_title

    local from_urllists_array
    local to_urllists_array

    local tip_width

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
	tip_width=300
	echo "<div class='table-title'>${policy_title} URL lists for the <a href='#' onMouseOver='ddrivetip( \"The default policy is applied to end-users not caught by defined policies.\", ${tip_width} );' onMouseOut='hideddrivetip( );'>${in_policy_name}</a> policy.</div>"
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
			    filter_name="<a href='#' onMouseOver='ddrivetip( \"${filter_description}\", ${tip_width} );' onMouseOut='hideddrivetip( );'>${filter_name}</a>"
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

	echo "<div style='float:left;'>"
        echo "<span class='shortcut-menu-item' style='float:left;'><a href='/${GUI_DIR_NAME}/edit-guard-policy.${GUI_EXT_NAME}?${in_policy_name}'>Edit <strong>${in_policy_name}</strong> policy</a></span>"

        echo "<span style='float:left; margin:0; margin-top:2px;'>"
        if test -z "${filters}" ; then
            echo "= { }"
        else
            echo "= { ${filters} }"
        fi
        echo "</span>"
        echo "</div>"

        echo "<div style='clear:left;'></div>"
        echo "<div class='table-title'>${policy_title} URL lists for the <strong>${in_policy_name}</strong> policy.</div>"
    fi

    echo "<table class='highlight-list' width='500'>"
    echo "<thead>"
    echo "<tr valign='middle'>"
    echo "<td class='table-header' width='47%'>Available URL lists</td>"
    echo "<td class='table-header' style='background:none; background-color:White; border:none'></td>"
    echo "<td class='table-header' width='47%'>${policy_title} URL lists</td>"
    echo "</tr>"
    echo "</thead>"
    
    echo "<tbody>"
    echo "<tr valign='middle'>"
    echo "<td style='background-color:White; padding:0; margin:0; padding-top:5px; padding-bottom:5px; border:1px solid LightSteelBlue;'>"
    echo "<select name='urllist_from' id='urllist_from' multiple size='${select_size}' style='width:100%; border:0;'>"
    for urllist_name in ${URLLIST_LIST}
    do
	! member "${urllists_lst}" ${urllist_name} || continue
	from_urllists_array="${from_urllists_array},['${urllist_name}','${urllist_name}']"
	echo "<option value='${urllist_name}' id='${urllist_name}'>${urllist_name}</option>"
    done
    echo "</select>"
    echo "</td>"

    from_urllists_array="[${from_urllists_array:1}]"

    echo "<td style='background-color:White;padding:0;margin:0;'>"
    echo "<center><a href='JavaScript:void( 0 );' id='add_button'><img src='/image/right-arrow.png' alt='Add Selected URL lists' title='Add Selected URL lists' align='top' style='height:${arrow_sz}; width:${arrow_sz};' /></a></center>"

    echo "<center><a href='JavaScript:void( 0 );' id='del_button'><img src='/image/left-arrow.png' alt='Remove Selected URL lists' title='Remove Selected URL lists' align='top' border='0' style='height:${arrow_sz}; width:${arrow_sz};' /></a></center>"
    echo "</td>"

    echo "<td style='background-color:White; padding:0; margin:0; padding-top:5px; padding-bottom:5px; border:1px solid LightSteelBlue;'>"

    echo "<select name='urllist' id='urllist' multiple size='${select_size}' style='width:100%; border:0;'>"
    for urllist_name in ${urllists_lst}
    do
	test ${urllist_name} != self || continue
	to_urllists_array="${to_urllists_array},['${urllist_name}','${urllist_name}']"
	echo "<option value='${urllist_name}' id='${urllist_name}'>${urllist_name}</option>"
    done
    to_urllists_array="[${to_urllists_array:1}]"

    echo "</select>"
    echo "</td>"

    echo "</tr>"
    echo "</tbody>"
    echo "</table>"

    show-form-begin ${length}
    echo "<input name='policy_name' type='hidden' value='${in_policy_name}' />"
    echo "<input name='action' type='hidden' value='${action}' />"
    
    show-do ${state} ${state} "addHiddenInputFromSelectionItem( 'mainform', 'urllist' )" "setSelectOptions( 'urllist_from', ${from_urllists_array} ); setSelectOptions( 'urllist', ${to_urllists_array} )"
    show-form-end
    echo "<script type='text/javascript'>"
    echo "initSelectionList( 'urllist_from', 'urllist', 'add_button', 'del_button' );"
    echo "</script>"
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
