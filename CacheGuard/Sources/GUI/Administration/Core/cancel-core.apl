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

show-cancel-form()
{
    local width state message
    local diff=${ADMIN_TMP_DIR}/conf.diff.${$}

    execute-command-with-output "conf diff" > ${diff}
    local ret=${?}

    if test ${ret} -ne 0 ; then
	message="The RUNning vs the NEW configuration is not available."
	state=disabled
    elif test ! -s "${diff}" ; then
	message="The RUNning and NEW configurations are identical."
	state=disabled
    else
	message="The RUNning configurations has been modified."
    fi

    show-title "Cancel New Configuration" "${state}" "cancel"

    echo "<div class='core-form'>"

    echo "<div style='margin:0; margin-bottom:10px; font-size:110%;'>${message}</div>"

    echo "<table class='highlight-list' width='100%'>"

    echo "<thead>"
    echo "<tr>"
    echo "<td class='table-header indicator-table-header' align='left' width='300' >Command</td>"
    echo "<td class='table-header' align='center' width='40'>State</td>"
    echo "<td class='table-header'  align='left'>Value(s)</td>"
    echo "</tr>"
    echo "</thead>"
    echo "<tbody>"

    local line

    while read line
    do
	echo "<tr>${line}</tr>"
    done < ${diff}

    echo "</tbody>"
    echo '</table>'

    show-scroll-top
    test -n "${state}" || echo "<div style='margin:0; margin-top:5px; margin-bottom:5px; font-size:110%;'>Press the SUBMIT button to CANCEL modifications.</div>"
    echo "</div>"

    show-form "${width}" ${state}
    rm -f ${diff}
}

# Main()

show-cancel-form
