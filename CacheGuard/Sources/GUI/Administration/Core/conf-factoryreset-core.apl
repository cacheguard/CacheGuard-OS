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

show-factoryreset-form()
{
    local disabled width=0
    local conf=/tmp/conf.show.${$} line

    test "${REMOTE_USER}" == "${ADMIN_NAME}" || disabled=disabled
    show-title "Configuration Factory Reset" "${disabled}" "factoryreset"
    execute-command-with-output "conf" > ${conf}

    show-form "${width}" ${disabled}
    echo "<div style='clear:left;'></div>"

    echo "<div class='core-form'>"
    echo "<div class='table-title'>The configuration settings</div>"
    echo "<table class='highlight-list' width='100%'>"

    while read line
    do
	echo "<tr>${line}</tr>"
    done < ${conf}
    rm -f ${conf}

    echo "</table>"
    echo "</div>"
}

# Main()

show-factoryreset-form
