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

dashboard-save()
{
    read-post-data || return 11
    check-csrf-cookie || return 13

    local tmp_file=/tmp/${GUI_DASHBOARD_LAYOUT_FILENAME}.${$}
    local title rest
    local elt i

    for ((i=0 ; i<ATTRIBUTE_NB ; i++))
    do
	echo -n ${ATTRIBUTES[${i}]}

	title=${VALUES[${i}]/ *}
	rest=${VALUES[${i}]#* }

	title=${title//@/=}
	title=$(decode-string ${title})

	for elt in ${rest}
	do
	    echo -n " ${elt}"
	done
	echo
    done > ${tmp_file}

    cp -f ${tmp_file} ${HOME}/${ENV_RDIR}/${GUI_DASHBOARD_LAYOUT_FILENAME}
    rm -f ${tmp_file}
}

main()
{
    gui-run-authentication
    dashboard-save "${@}"
}

# Main()

main
