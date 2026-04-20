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

get-site-name-list()
{
    local elt i=0 rang
    local name

    local result nb=0

    for elt in ${RWEB_SITE_LIST}
    do
	rang=$[${i} % 5]
	case ${rang} in
	    0)
		name=${elt}
		;;
	    1|2|3)
		;;
	    4)
		if ! member "${result}" ${name} ; then
		    result="${result} ${name}"
		    ((nb++))
		fi
		;;
	    *)
		return 1
		;;
	esac
	((i++))
    done
    
    echo ${nb} ${result:1}
}

audit-checked()
{
    test -n "${1}" || return 1
    local name=${1}

    ! member "${WAF_RWEB_AUDIT_LIST}" ${name} || echo -n checked
}

show-waf-rweb-audit-form()
{
    local page_ref=${1}

    local width=${DEFAULT_LIST_FORM_WIDTH_2}
    local state

    local left=80
    local right=20
    local length=1

    local page_2show_ref=$(page-2show-ref 20 "${page_ref}")
    local records_ppage=${page_2show_ref/ *}
    local page_2show=${page_2show_ref/* }

    echo "<div class='core-form'>"

    echo "<span class='shortcut-menu-item' style='display:inline;'><a href='rweb-site.${GUI_EXT_NAME}'>Add rWeb</a></span>"
    echo "<div style='clear:left;'></div>"

    echo "<div style='float:left; margin:0; height:24px;'>"
    show-navigation-controls ${records_ppage}
    echo "</div>"
    echo "<div style='clear:left; margin:0;'></div>"
    echo "<br />"

    show-form-begin ${length}

    echo "<table id='${MAIN_TABLE_ID}' name='${MAIN_TABLE_ID}' class='highlight-list' width='${width}'>"
    echo "<thead>"
    echo "<tr>"
    echo "<td class='table-header' width=${left}%>Site Name</td>"
    echo "<td class='table-header' width=${right}% align='center'>Audit?</td>"
    echo "</tr>"
    echo "</thead>"

    local name page_nb nb=0
    local nb_sites=$(get-site-name-list)
    local site_nb=${nb_sites/ *}
    local sites=${nb_sites#* }

    test ${site_nb} -gt 0 || unset sites

    echo "<tbody>"
    for name in ${sites}
    do
	page_nb=$[${nb} / ${records_ppage}]
	if test ${page_nb} -gt ${page_2show} ; then
	    break
	elif test ${page_nb} -lt ${page_2show} ; then
	    ((nb++))
	    continue
	fi
	echo "<tr>"
	echo "<td><input type='hidden' name='site_name' value='${name}'><label for='site_${nb}'>${name}</label></td>"
	echo "<td ><center><input id='site_${nb}' name='audit' type='checkbox' onClick='activatePostButtons( );' $(audit-checked ${name}) /></center></td>"
	echo "</tr>"
	((nb++))
    done
    echo "</tbody>"
    echo '</table>'

    js-init-table-form ${site_nb} ${records_ppage} ${page_2show}
    show-do "disabled" "disabled" "" "deactivatePostButtons( )"
    show-form-end

    echo "</div>"
}

# Main()

show-waf-rweb-audit()
{
    local get_args=${1}
    local page_ref=$(get-arg-value "${get_args}" page)

    show-title "Audit rWeb Traffic" "${state}" "rweb waf"
    show-waf-rweb-audit-form "${page_ref}"
}

# Main()

show-waf-rweb-audit "${@}"
