#!/bin/bash

###########################################################################
#
# MODULE:       GUI
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

auto-logout( )
{
    test -n "${1}" || return 1
    local mode=${1}

    readonly timeout=1800
    local auth=$(get-auth-token)

    local session_id=$(echo -n "${auth}" | openssl dgst -sha1)
    session_id=${session_id/* }

    local check_file=/tmp/${GUI_CHECK_DATE_FILENAME}.${session_id}
    local now=$(date +"%s" 2> /dev/null)

    case ${mode} in
	touch)
	    echo ${now} > ${check_file}
	    ;;
	check)
	    if test ! -s ${check_file} ; then
		echo KO
		return 11
	    fi

	    local last_check=$(cat ${check_file})
	    local elapsed=$((now - last_check))

	    if test ${elapsed} -ge ${timeout} ; then
		echo -n > ${check_file}.2del
		echo KO
	    else
		echo OK
	    fi
	    ;;
	raz)
	    echo -n > ${check_file}.2del
	    echo OK
	    ;;
	*)
	    echo KO
	    ;;
    esac
}

gui-run-authentication
auto-logout ${@}
