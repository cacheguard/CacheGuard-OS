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

file-size()
{
    test -n "${1}" || return 1
    local file=${1}

    if test ! -f ${file} ; then
	echo 0
	return 11
    fi

    local f1 f2 f3 f4 size fn

    ls -l ${file} 2> /dev/null | \
	while read f1 f2 f3 f4 size fn
    do
	test -n "${size}" || continue
	echo ${size}
	break
    done

    return 0
}

download-conf()
{
    test -n "${1}" || return 1
    local src_filename=${1}
    local dst_filename=${2}

    local src_file=${ADMIN_TMP_DIR}/${src_filename}
    test -f ${src_file} || return 3

    test -n "${dst_filename}" || dst_filename=${DEFAULT_SHOSTNAME}.conf
    local size=$(file-size ${src_file})

    echo -e "Content-Disposition: attachment; filename=\"${dst_filename}\""
    echo -e "Content-Length: ${size}"
    echo -e "Cache-control: private"

    echo-http-header "application/octet-stream"

    cat ${src_file}

    execute-command "conf clear ${src_filename}"
    reset-gui-error-log
}

# Main()

check-cgi-security
verify-authentication || http-exit 1
gui-init-env-variables
download-conf ${@}
