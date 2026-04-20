#!/bin/bash

###########################################################################
#
# MODULE:       Patch
# AUTHOR(S):    CacheGuard Development Team
# COPYRIGHT:    (C) 2009-2021 by CacheGuard Technologies Ltd
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

set-sysctl()
{
    sysctl --write --quiet net.core.rmem_max="33554432"
    sysctl --write --quiet net.core.wmem_max="33554432"
    sysctl --write --quiet net.ipv4.tcp_window_scaling="1"
    sysctl --write --quiet net.ipv4.tcp_timestamps="1"
    sysctl --write --quiet net.ipv4.tcp_sack="1"
    sysctl --write --quiet net.ipv4.tcp_rmem="4096 87380 33554432"
    sysctl --write --quiet net.ipv4.tcp_wmem="4096 65536 33554432"
}

main()
{
    set-sysctl
}

# Main()

main
