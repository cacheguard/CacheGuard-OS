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

source functions

print-rules()
{
    test -n "${1}" || return 1
    local name=${1}

    local rule=${WAF_DIR}/${name}.rules

    if test -f ${rule} ; then
        local key value action method
        echo "<table class='highlight-list'>"
        echo "<thead>"
        echo "<tr>"
        echo "<td class='table-header' width='10%'>Reference</td><td class='table-header' width='10%'>Action</td><td class='table-header' width='10%'>Method<hr />Attribute</td><td class='table-header' width='70%'>Regular Expression</td>"
        echo "</tr>"
        echo "</thead>"
        echo "<tbody>"
        while read -r key value action method
        do
            test -n "${key}" || continue
            test "${key:0:1}" != '#' || continue
            case ${key} in
                rule)
                    echo "<tr class='main-line'><td>${value}</td><td>${action}</td><td>${method}</td><td></td></tr>"
                    ;;
                uri|body|ip)
                    echo "<tr><td></td><td></td><td>${key}</td><td>${value}</td></tr>"
                    ;;
                *)
                    echo "<tr><td></td><td></td><td></td><td></td></tr>"
                    ;;
            esac
        done < ${rule}
        echo "</tbody>"
        echo '</table>'
    else
        echo "<div class='with-border unavailable-message'>&lt;No custom rules&gt;</div>"
    fi
}

gui-run-authentication
print-rules "${@}"

