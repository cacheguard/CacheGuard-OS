#!/bin/bash

###########################################################################
#
# MODULE:       Build
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

test -n "${LFS}" || exit 1
test -d "${LFS}" || exit 2

make-patch()
{
    test -n "${1}" || return 1
    local package=${1}

    local patch="cg"
    local package_name package_dir files file level_two_name
    case ${package} in
	vim)
	    package_name="${package}[0-9][0-9]*"
	    ;;
	*)
	    package_name="${package}[-_][0-9]*"
	    ;;
    esac
    package_dir=$(find . -maxdepth 1 -name "${package_name}" -type d | grep -v "\-${patch}")
    package_dir=$(echo "${package_dir}" | sed -e 's,\./,,')

    test -n "${package_dir}" || return 11
    test -d ${package_dir} || return 13
    test -d ${package_dir}-${patch} || return 15

    find ${package_dir}-${patch} -name "*~" -exec rm {} \;

    files=$(find ${package_dir}-${patch} -type f)
    rm -f ${package_dir}-${patch}.patch

    for file in ${files}
    do
	level_two_name=$(echo ${file} | sed -e "s,.*-${patch}/,,")
	diff -Naur ${package_dir}/${level_two_name} ${file} >> ${package_dir}-${patch}.patch
    done
    
    rm -f ${package_dir}-${patch}.patch.bz2
    bzip2 ${package_dir}-${patch}.patch
}

make-patch ${*}
