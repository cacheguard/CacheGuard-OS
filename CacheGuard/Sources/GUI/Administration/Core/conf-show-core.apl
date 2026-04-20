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

show-conf-show-form()
{
    local conf=/tmp/conf.show.${$} line
    local apply_title=$(get-apply-icon-title)
    local title i=0

    if gui-is-in-contextual-role ; then
	local context_base=${GUI_CONTEXT/:*}
	local context_leaf=${GUI_CONTEXT/*:}
	title="[ ${context_base^} > ${context_leaf} ] Configuration Overview"
    else
	title="${APL_ROLE^} Configuration Overview"
    fi

    local commands="conf"
    ! gui-is-in-contextual-role || commands="${commands} manager"

    show-title "${title}" "disabled" "${commands}"
    execute-command-with-output "conf" > ${conf}

    shortcutMenuItem[${i}]=apply
    shortcutMenuArgs[${i}]=''
    shortcutMenuIcon[${i}]=apply
    shortcutMenuTitle[${i}]=${apply_title}
    ((i++))

    shortcutMenuItem[${i}]=cancel
    shortcutMenuArgs[${i}]=''
    shortcutMenuIcon[${i}]=cancel
    shortcutMenuTitle[${i}]=${CANCEL_ICON_TITLE}
    ((i++))

    shortcutMenuItem[${i}]=
    shortcutMenuArgs[${i}]=''
    shortcutMenuIcon[${i}]=
    shortcutMenuTitle[${i}]=""
    ((i++))


    shortcutMenuItem[${i}]=conf-load-save
    shortcutMenuArgs[${i}]=''
    shortcutMenuIcon[${i}]=conf-load-save
    shortcutMenuTitle[${i}]="Load & Save Configuration"
    ((i++))

    if gui-is-in-contextual-role ; then

	local context_base=${GUI_CONTEXT/:*}

	if test ${context_base} == gateway ; then

	    shortcutMenuItem[${i}]=manager-gateway-operation
	    shortcutMenuArgs[${i}]=pull,key:${context_leaf}
	    shortcutMenuIcon[${i}]=manager-gateway-pull
	    shortcutMenuTitle[${i}]="Pull Configuration from Gateway"
	    ((i++))

	    if test ${CONF_MODIFIED} != yes ; then
		shortcutMenuItem[${i}]=manager-gateway-operation
		shortcutMenuArgs[${i}]=push,key:${context_leaf}
		shortcutMenuIcon[${i}]=manager-gateway-push
		shortcutMenuTitle[${i}]="Push Configuration to Gateway"
		((i++))
	    fi

	    shortcutMenuItem[${i}]=conf-manager
	    shortcutMenuIcon[${i}]=conf-manager
	    shortcutMenuTitle[${i}]="Configure Using a Template"
	    ((i++))
	fi
    fi

    show-shortcuts-menu

    echo "<div class='core-form'>"
    echo "<table class='highlight-list' width='100%'>"
    echo "<thead>"
    echo "<tr>"
    echo "<td class='table-header indicator-table-header' align='left' width='300' >Command</td>"
    echo "<td class='table-header' align='center' width='40'>State</td>"
    echo "<td class='table-header'  align='left'>Value(s)</td>"
    echo "</tr>"
    echo "</thead>"

    echo "<tbody>"
    while read line
    do
	echo "<tr>${line}</tr>"
    done < ${conf}
    rm -f ${conf}

    echo "</tbody>"
    echo "</table>"

    show-scroll-top

    echo "</div>"
}

# Main()

show-conf-show-form
