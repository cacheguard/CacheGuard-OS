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

print-check-digit-function()
{
    test -n "${1}" || return 1
    local id=${1}
    echo "onblur=\"checkDigit( '${id}' );\""
}

show-vlan-core()
{
    local left=75
    local right=25
    local length=6

    shortcutMenuItem[0]="ip"
    shortcutMenuTitle[0]="IP addresses"

    show-title "802.1q VLAN Tags" "enabled" "vlan ip"
    show-shortcuts-menu

    echo "<div class='core-form'>"
    show-form-begin ${length}
    echo "<table class='highlight-form'>"

    echo "<tr>"
    echo "<td class='table-header' width=${left}%>Pseudo Device</td>"
    echo "<td class='table-header' width=${right}%>TAG</td>"
    echo "</tr>"

    echo "<tr>"
    echo "<td width=${left}%>Forward & Transparent Clients</td>"
    echo "<td width=${right}%><input id=web name=web type='text' size='7' maxlength='4' value='$(get-vlan-tag web new)' $(print-check-digit-function web)></td>"
    echo "</tr>"

    echo "<tr>"
    echo "<td width=${left}%>Reverse Web Servers</td>"
    echo "<td width=${right}%><input id=rweb name=rweb type='text' size='7' maxlength='4' value='$(get-vlan-tag rweb new)' $(print-check-digit-function rweb)></td>"
    echo "</tr>"

    echo "<tr>"
    echo "<td width=${left}%>Antivirus Clients</td>"
    echo "<td width=${right}%><input id=antivirus name=antivirus type='text' size='7' maxlength='4' value='$(get-vlan-tag antivirus new)' $(print-check-digit-function antivirus)></td>"
    echo "</tr>"

    echo "<tr>"
    echo "<td width=${left}%>Peer Appliances</td>"
    echo "<td width=${right}%><input id=peer name=peer type='text' size='7' maxlength='4' value='$(get-vlan-tag peer new)' $(print-check-digit-function peer)></td>"
    echo "</tr>"

    echo "<tr>"
    echo "<td width=${left}%>File Servers</td>"
    echo "<td width=${right}%><input id=file name=file type='text' size='7' maxlength='4' value='$(get-vlan-tag file new)' $(print-check-digit-function file)></td>"
    echo "</tr>"

    echo "<tr>"
    echo "<td width=${left}%>Administration</td>"
    echo "<td width=${right}%><input id=admin name=admin type='text' size='7' maxlength='4' value='$(get-vlan-tag admin new)' $(print-check-digit-function admin)></td>"
    echo "</tr>"

    echo "<tr>"
    echo "<td width=${left}%>Management (SNMP...)</td>"
    echo "<td width=${right}%><input id=mon name=mon type='text' size='7' maxlength='4' value='$(get-vlan-tag mon new)' $(print-check-digit-function mon)></td>"
    echo "</tr>"

    echo "</table>"
    show-do
    show-form-end
    echo "</div>"
}

# Main()

show-vlan-core
