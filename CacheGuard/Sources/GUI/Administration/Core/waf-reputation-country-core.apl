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

get-country-option-style()
{
    test -n "${1}" || return 1
    local code=${1}

    echo "text-indent: 26px; background:no-repeat url( ${IMAGE_DIR}/country-flag-${code}.png ); background-size:26px 17px;"
}

waf-reputation-country()
{
    local select_size=16
    local arrow_sz=25px
    local length=2

    local country_code country_name countries style

    local from_countries_array
    local to_countries_array
    local tmp_file=/tmp/reputation.${$}

    show-title "WAF Country Reputation" enabled "waf"

    echo "<div class='core-form'>"

    echo "<table class='highlight-list'>"
    echo "<thead>"
    echo "<tr>"
    echo "<td class='table-header' width='47%'>Available Countries</td>"
    echo "<td class='table-header' width='6%' style='background:none; background-color:White; border:none'></td>"
    echo "<td class='table-header' width='47%'>Blocked Countries</td>"
    echo "</tr>"
    echo "</thead>"
    
    echo "<tbody>"
    echo "<tr>"

    echo "<td style='background-color:White;padding:0;margin:0;padding-top:5px;padding-bottom:5px;'>"
    echo "<select name='country_from' id='country_from' multiple size='${select_size}' style='width:100%;'>"

    sqlite3 -separator ' ' \
	    ${USERENV_DIR}/${CONFIGURATION_DB_NAME} \
	    "SELECT country, name FROM waf_reputation_country INNER JOIN country ON country = code WHERE reputation = FALSE;" > ${tmp_file}

    while read country_code country_name
    do
	test -n "${country_name}" || continue
	style=$(get-country-option-style ${country_code})
	from_countries_array="${from_countries_array},['${country_code^^}','${country_name//\'/\\\'}','${style}']"
	echo -n "<option value='${country_code}' id='${country_code}' style='${style}'>${country_name} [${country_code^^}]</option>"
    done < ${tmp_file}

    echo "</select>"
    echo "</td>"

    from_countries_array="[${from_countries_array:1}]"

    echo "<td style='background-color:White;padding:0;margin:0;'>"
    echo "<center><a href='JavaScript:void( 0 );' id='add_button'><img src='/image/right-arrow.png' alt='Add Selected Countries' title='Add Selected Countries' align='top' style='height:${arrow_sz}; width:${arrow_sz};' /></a></center>"

    echo "<center><a href='JavaScript:void( 0 );' id='del_button'><img src='/image/left-arrow.png' alt='Remove Selected Countries' title='Remove Selected Countries' align='top' border='0' style='height:${arrow_sz}; width:${arrow_sz};' /></a></center>"
    echo "</td>"

    echo "<td style='background-color:White;padding:0;margin:0;padding-top:5px;padding-bottom:5px;'>"

    echo "<select name='country' id='country' multiple size='${select_size}' style='width:100%;'>"

    sqlite3 -separator ' ' \
	    ${USERENV_DIR}/${CONFIGURATION_DB_NAME} \
	    "SELECT country, name FROM waf_reputation_country INNER JOIN country ON country = code WHERE reputation = TRUE;" > ${tmp_file}

    while read country_code country_name
    do
	test -n "${country_name}" || continue
	style=$(get-country-option-style ${country_code})
	to_countries_array="${to_countries_array},['${country_code^^}','${country_name//\'/\\\'}','${style}']"
	echo -n "<option value='${country_code}' id='${country_code}' style='${style}'>${country_name} [${country_code^^}]</option>"
    done < ${tmp_file}

    to_countries_array="[${to_countries_array:1}]"

    echo "</select>"
    echo "</td>"

    echo "<tr>"
    echo "</tbody>"
    echo "</table>"

    show-form-begin ${length}
    echo "<input name='dummy' type='hidden' value='on' />"
    show-do enabled enabled "addHiddenInputFromSelectionItem( 'mainform', 'country' )" "setSelectOptions( 'country_from', ${from_countries_array} ); setSelectOptions( 'country', ${to_countries_array} )"
    show-form-end
    echo "<script type='text/javascript'>"
    echo "initSelectionList( 'country_from', 'country', 'add_button', 'del_button' );"
    echo "</script>"

    echo "</div>"
}

waf-reputation-country "${@}"
