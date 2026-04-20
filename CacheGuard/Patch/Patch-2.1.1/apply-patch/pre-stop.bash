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

gen-lure-rc-init()
{
    touch /etc/rc.d/rc1.d/K00{health,keepalived,sshd,iptables,supervisor}
}

main()
{
    gen-lure-rc-init
    /etc/rc.d/init.d/supervisor restart
}

main
