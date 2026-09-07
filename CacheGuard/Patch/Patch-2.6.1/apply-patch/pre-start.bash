#!/bin/bash

###########################################################################
#
# MODULE:       Patch
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

CACHEGUARD_DIR=/etc/sysconfig/cacheguard

source ${CACHEGUARD_DIR}/constant
source ${APPLIANCE_DIR}/etc/role

remove-ifb3()
{
    rmmod ifb
    sed -ie 's/ifb numifbs=4/ifb/' /etc/sysconfig/modules-constant
    sed -ie 's/ifb numifbs=4/ifb/' /etc/sysconfig/modules
    modprobe ifb
}

remove-useless-rweb-tls()
{
    rm -f ${PROXY_SSL_SERVER_DIR}/*.{key,certificate,chain,certificate+chain}
}

kill-superfluous-rlogger()
{
    killall apl_rloggerd > /dev/null 2>&1

    rm -f \
       /var/lock/rlogger \
       /var/run/rlogger.pid
}

main()
{
    remove-ifb3

    test ${APL_ROLE} == gateway || return 0

    remove-useless-rweb-tls
    kill-superfluous-rlogger
}

main
