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

display-log-line()
{
    show-log-line "${@}"
}

display-command-output-in-log()
{
    show-log-line 0 "" "${@}[OK]"
}

gui-show-manager-gateway-pull-report()
{
    local log=${MANAGER_PULL_OPERATION_LOG}

    if test ! -s ${log} ; then
	echo-content-unavailable 100% "This report is not yet available"
	return 0
    fi


    echo "<table class='report' width='100%'>"
    display-manager-gateway-pull-report
    echo "</table>"
}

gui-show-manager-gateway-push-report()
{
    local log=${MANAGER_PUSH_OPERATION_LOG}

    if test ! -s ${log} ; then
	echo-content-unavailable 100% "This report is not yet available"
	return 0
    fi

    echo "<table class='report' width='100%'>"
    display-manager-gateway-push-report
    echo "</table>"

}

gui-show-manager-gateway-apply-report()
{
    local log=${MANAGER_LOCAL_EXEC_OPERATION_LOG}
    if test ! -s ${log} ; then
	echo-content-unavailable 100% "This report is not yet available"
	return 0
    fi

    echo "<table class='report' width='100%'>"
    display-manager-exec-report gateway local
    echo "</table>"
}

main()
{
    test ${APL_ROLE} == manager || return 0

    local operation=${1}
    test -n "${operation}" || operation=pull

    local title

    case ${operation} in
	pull|push)
	    title=${operation^}
	    ;;
	apply)
	    title="Local Execution"
	    ;;
	*)
	    return 0
	    ;;
    esac

    echo "<span class='table-title'>Last ${title} report</span>"
    gui-show-manager-gateway-${operation}-report
}

# Main()

gui-run-authentication
main ${@}
