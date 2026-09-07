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

show-site-select()
{
    local site_name=${1}
    local id='site_name'

    echo "<select name='${id}' id='${id}' data-action='ajax-update-deny-url'>"    
    show-site-select1 any "${site_name}"
    echo "</select>"
}

show-filter-rweb-denyurl-form()
{
    local left=20
    local right=80

    local state
    test -n "${RWEB_SITE_LIST}" || state=disabled

    shortcutMenuItem[0]="rweb-site"
    shortcutMenuTitle[0]="Add rWeb"

    show-title "WAF Deny URL" "${state}" "waf"
    echo "<div class='core-form'>"
    show-shortcuts-menu
    show-form-begin
    echo "<table class='highlight-form'>"

    echo "<tr>"
    echo "<td width='${left}%'>Site Name</td>"
    echo "<td width='${right}%'>"

    if test -z "${GET_ARGS}" ; then
        local site_name=${RWEB_SITE_LIST/ */}
    else
        local site_name=${GET_ARGS}
    fi

    show-site-select ${site_name}
    echo "</td></tr>"

    echo "<tr>"
    echo "<td width=${left}%>Deny URL</td>"
    echo "<td width=${right}%>"
    echo '<div id="denyurl">'

    print-denyurl ${site_name}

    echo '</div>'
    echo "</td></tr>"

    echo "</table>"
    show-do ${state} ${state}
    show-form-end

    echo "</div>"
}

# Main()

show-filter-rweb-denyurl-form
