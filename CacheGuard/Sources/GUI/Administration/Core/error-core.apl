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

source ${APPLIANCE_DIR}/lib/errors-tab

show-error-form()
{
    local code_type code description n

    local code_types="GUI_Error Command_Error Command_Warning Command_Information"
    local tabs_id='error_descriptions'
    local width=800

    show-title "Error Descriptions" "enabled" "error information warning"

    echo "<div class='core-form' style='margin-top:15px;'>"

    echo "<ul id='${tabs_id}' class='shadetabs' style='font-size:14px;'>"
    for code_type in ${code_types}
    do
	echo "<li><a href='#' rel='${code_type}' class='selected'>${code_type//_/ }s</a></li>"
    done
    echo "</ul>"
    
    for code_type in ${code_types}
    do
	echo "<div id='${code_type}' class='tabcontent' style='margin:0; padding:0; padding-top:10px;'>"
	echo "<table class='highlight-list' width='${width}'>"
	echo "<thead>"
	echo "<tr>"
	echo "<td class='table-header' style='height:50px;' width='10%' align='center'>Code</td>"
	echo "<td class='table-header' width='90%' align='center'>Description</td>"
	echo "</tr>"
	echo "</thead>"
	echo "<tbody>"

	case ${code_type} in
	    GUI_Error)
		n=${#GUIErrors[@]}
		for ((code=1 ; code<=n ; code++))
		do
		    description=${GUIErrors[${code}]}
		    test -n "${description}" || continue
		    echo "<tr><td>$((1000 + ${code}))</td><td>${description}</td></tr>"
		done
		;;
	    Command_Error)
		n=${#Errors[@]}
		for ((code=1 ; code<=n ; code++))
		do
		    description=${Errors[${code}]}
		    test -n "${description}" || continue
		    echo "<tr><td>${code}</td><td>${description}</td></tr>"
		done
		;;
	    Command_Warning)
		n=${#Warnings[@]}
		for ((code=1 ; code<=n ; code++))
		do
		    description=${Warnings[${code}]}
		    test -n "${description}" || continue
		    echo "<tr><td>${code}</td><td>${description}</td></tr>"
		done
		;;
	    Command_Information)
		n=${#Informations[@]}
		for ((code=1 ; code<=n ; code++))
		do
		    description=${Informations[${code}]}
		    test -n "${description}" || continue
		    echo "<tr><td>${code}</td><td>${description}</td></tr>"
		done
		;;
	    *)
		;;
	esac

	echo "</tbody>"
	echo "</table>"
	echo "</div>"
    done

    # Tab Display

    echo "<script type='text/javascript'>"
    echo "var formTabs = new ddtabcontent( '${tabs_id}' );"
    echo "formTabs.setpersist( true );"
    echo "formTabs.setselectedClassTarget( 'link' );"
    echo "formTabs.init( );"
    echo "</script>"

    show-scroll-top

    echo "</div>"
    echo "<br />"
}

# Main()

show-error-form
