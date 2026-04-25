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
test -f LFS/LFS.env || exit 3
source LFS/LFS.env

copy-packages()
{
    test -n "${1}" || return 11
    test -n "${2}" || return 12
    local local_dir=${1}
    local dest_dir=${2}

    local all_packages=$(ls ${local_dir}/*.gz ${local_dir}/*.bz2 ${local_dir}/*.xz 2> /dev/null) package

    if test ! -d ${dest_dir} ; then
	sudo mkdir -vp ${dest_dir}
	sudo chown -v ${USER}:${USER} ${dest_dir}
    fi

    for package in ${all_packages}
    do
	echo "Installing ${package}"
	install -m 644 ${package} ${dest_dir}
    done
}

# Main()

copy-packages ${1} ${2}
