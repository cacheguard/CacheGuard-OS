#!/bin/bash

###########################################################################
#
# MODULE:       Patch
# AUTHOR(S):    CacheGuard Development Team
# COPYRIGHT:    (C) 2009-2023 by CacheGuard Technologies Ltd
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
source /usr/local/lib/apl_common

rename-ssh-key-file()
{
    local ktype

    for ktype in dsa rsa
    do
	test ! -f /etc/ssh_host_${ktype}.key || mv -f /etc/ssh_host_${ktype}.key /etc/ssh_host_${ktype}_key
	test ! -f /etc/ssh_host_${ktype}.key.pub || mv -f /etc/ssh_host_${ktype}.key.pub /etc/ssh_host_${ktype}_key.pub
    done
}

clean-up()
{
    echo > ${HARD_DIR}/${FIRST_STARTUP}
    rm -f ${ABASE_DIR}/${FIRST_LOGIN}
    rm -f ${ABASE_DIR}/.bash_profile
}

patch-initrd()
{
    apl_update_initrd
}

main()
{
    rename-ssh-key-file
    patch-initrd
    clean-up
}

main
