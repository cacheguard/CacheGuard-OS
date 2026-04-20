#!/bin/bash

############################################################################
#
# MODULE:       Patch
# AUTHOR(S):    CacheGuard Development Team
# COPYRIGHT:    (C) 2009-2020 by CacheGuard Technologies Ltd
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

remove-old-modules()
{
    local active_sys_name=$(uname -r 2> /dev/null)
    local active_sys_version=${active_sys_name/-*}
    local active_sys_version_len=${#active_sys_version}

    cd /lib/modules
    local sys_names=$(ls -1 2> /dev/null) sys_name

    chattr -i .
    for sys_name in ${sys_names}
    do
	test ${sys_name:0:${active_sys_version_len}} != ${active_sys_version} || continue
	chattr -R -i ${sys_name}
	rm -rf ${sys_name}
    done
    chattr +i .
}

remove-old-modules
