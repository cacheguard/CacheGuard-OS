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

waf-reputation-country()
{
    local country_code country_name countries

    local availale_countries_array
    local selected_countries_array
    local select1_id='available-countries'
    local select2_id='selected-countries'

    local tmp_file=/tmp/reputation.${$}

    show-title "WAF Country Reputation" enabled "waf"

    echo "<div class='core-form'>"

    echo "<table class='bi-select-list'>"
    echo "<thead>"
    echo "<tr>"
    echo "<th class='table-header'>Available Countries</th>"
    echo "<th></th>"
    echo "<th class='table-header'>Blocked Countries</th>"
    echo "</tr>"
    echo "</thead>"
    
    echo "<tbody>"
    echo "<tr>"

    echo "<td>"
    echo "<select name='${select1_id}' id='${select1_id}' multiple>"

    sqlite3 -separator ' ' \
	    ${USERENV_DIR}/${CONFIGURATION_DB_NAME} \
	    "SELECT country, name FROM waf_reputation_country INNER JOIN country ON country = code WHERE reputation = FALSE;" > ${tmp_file}

    while read country_code country_name
    do
	test -n "${country_name}" || continue
	availale_countries_array="${availale_countries_array},[\"${country_code^^}\",\"${country_name//\'/d&#39;} [${country_code^^}]\"]"
	echo -n "<option value='${country_code}' id='${country_code}'>${country_name} [${country_code^^}]</option>"
    done < ${tmp_file}
    rm -f ${tmp_file}

    echo "</select>"
    echo "</td>"

    availale_countries_array="[${availale_countries_array:1}]"

    echo-add-remove-selected-row ${select1_id} ${select2_id} "Countries"

    echo "<td>"

    echo "<select name='${select2_id}' id='${select2_id}' multiple>"

    sqlite3 -separator ' ' \
	    ${USERENV_DIR}/${CONFIGURATION_DB_NAME} \
	    "SELECT country, name FROM waf_reputation_country INNER JOIN country ON country = code WHERE reputation = TRUE;" > ${tmp_file}

    while read country_code country_name
    do
	test -n "${country_name}" || continue
	selected_countries_array="${selected_countries_array},[\"${country_code^^}\",\"${country_name//\'/d&#39;} [${country_code^^}]\"]"
	echo -n "<option value='${country_code}' id='${country_code}'>${country_name} [${country_code^^}]</option>"
    done < ${tmp_file}
    rm -f ${tmp_file}

    selected_countries_array="[${selected_countries_array:1}]"

    echo "</select>"
    echo "</td>"

    echo "<tr>"
    echo "</tbody>"
    echo "</table>"

    show-form-begin
    echo "<input name='dummy' type='hidden' value='on' />"

    show-do-apply enabled 'add-hidden-input-from-selection-item' "[\"${select2_id}\"]" before
    show-do-reset enabled 'set-select-country-options' "[\"${select1_id}\",${availale_countries_array},\"${select2_id}\",${selected_countries_array}]"

    show-form-end

    echo "</div>"
}

waf-reputation-country "${@}"
