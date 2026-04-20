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

show-cache-loadurl-form()
{

    local left=20
    local right=80
    local length=2

    local selected

    show-title "Cache Load URL" "enabled" "cache"

    echo "<div class='core-form'>"
    show-form-begin ${length}

    echo "<table class='highlight-form'>"
    echo "<tr>"
    echo "<td width='${left}%'>Protocol</td>"
    echo "<td width='${right}%'>"
    echo "<select name='protocol'>"
    for proto in http ftp
    do
	selected=$(get-selected-option ${proto} "${VALUES[0]:1}")
        echo -n "<option value='_${proto}'${selected}>${proto}</option>"
    done
    echo "</select>://"
    echo "</td>"
    echo "</tr>"
    echo "<tr>"
    echo "<td>Location</td>"
    echo "<td>"
    echo "<input name='uri' id='uri' value='${VALUES[1]}' type='text' size='48' maxlength='$[${MAX_LEN} * 3]' onblur=\"checkPrintable( 'uri' );\" />"
    echo "</td></tr>"

    echo "</table>"
    show-do
    show-form-end
    echo "</div>"
}

# Main()

show-cache-loadurl-form
