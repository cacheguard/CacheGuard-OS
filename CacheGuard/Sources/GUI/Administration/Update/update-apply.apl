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

# Main()

gui-show-apply-log()
{
    case ${APL_ROLE} in
	gateway)
	    show-log ${APPLY_LOG}
	    ;;
	manager)
	    if gui-is-in-contextual-role ; then
		local log_dir=$(get-manager-context-apply-log-dir)
		local log=${log_dir}/apply.log
		show-log ${log}
	    else
		show-log ${APPLY_LOG}
	    fi
	    ;;
	*)
	    return 255
	    ;;
    esac
}

gui-run-authentication
gui-show-apply-log
