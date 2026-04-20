#!/bin/bash

############################################################################
#
# MODULE:       Patch
# AUTHOR(S):    Afshin Tajvidi, <afshin.tajvidi(at)cacheguard.com>
# COPYRIGHT:    (C) 2002-2015 by the CacheGuard Technologies Limited
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

CACHEGUARD_DIR=/etc/sysconfig/cacheguard

source ${CACHEGUARD_DIR}/constant

gen-modules-1()
{
    cat /etc/sysconfig/modules-constant
    cat /etc/sysconfig/modules-network
    echo
    echo "# End /etc/sysconfig/modules"
}

gen-modules()
{
    gen-modules-1 > /tmp/modules.patched
}

install-modules()
{
    install -m 644 -o root -g root /tmp/modules.patched /etc/sysconfig/modules
}

clean-modules()
{
    rm -f /tmp/modules.patched
}

make-missing-dirs()
{
    install -d -m  775 -o ${ADMIN_NAME} -g ${GROUP_NAME} ${RUN_DIR}/${SUPERVISOR_ARGS}
}

main()
{
    make-missing-dirs

    gen-modules && 
    install-modules ||
    clean-modules
}

# Main()

main
