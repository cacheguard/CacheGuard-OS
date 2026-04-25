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

source LFS.env
source APPLIANCE.env
source functions

apl-configure()
{
    export LOG_FILENAME=configure.log
    run /bin/bash local-configure-env.bash APPLIANCE.env LFS.env
}

install-apl-packages()
{
    run /bin/bash local-install-pkg.bash APPLIANCE.env LFS.env functions
    local ret=${?}
    move-log
    return ${ret}
}

archive-syslinux()
{
    test ${SYS_ARCHITECTURE} == x86_64 || return 0
    test -f ${LFS}/tmp/syslinux.tar.gz || return 0
    cp -f ${LFS}/tmp/syslinux.tar.gz syslinux.tar.gz || return 1
    sudo rm -f ${LFS}/tmp/syslinux.tar.gz
}

restore-syslinux()
{
    test ${SYS_ARCHITECTURE} != x86_64 || return 0
    run /bin/bash local-restore-syslinux.bash syslinux.tar.gz
}

# Main()


LOG_DIR=${COMPILE_LOG_DIR}-${SYS_ARCHITECTURE}
mkdir -vp ${LOG_DIR}

apl-configure
mount-lfs
install-apl-packages && do-stripe
umount-lfs
archive-syslinux
restore-syslinux
