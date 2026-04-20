#!/bin/bash

###########################################################################
#
# MODULE:       Patch
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

CACHEGUARD_DIR=/etc/sysconfig/cacheguard
source ${CACHEGUARD_DIR}/constant
source ${APPLIANCE_DIR}/etc/role

gen-sysconfig-squid-patch()
{
    case ${APL_ROLE} in
	manager)
	    ;;
	gateway)
	    echo "export SQUID_DUMP_CACHE=on"
	    cat /etc/sysconfig/squid
	    ;;
    esac
}

deploy-sysconfig-squid-tuned()
{
    test ! -f ${CONF_DIR}/sysconfig.squid-tuned || return 0

    install -m 400 -o root -g root /etc/sysconfig/squid ${CONF_DIR}/sysconfig.squid-tuned
    gen-sysconfig-squid-patch > ${CONF_DIR}/sysconfig.squid
    ln -sf ${CONF_DIR}/sysconfig.squid /etc/sysconfig/squid
}

chmod-ipsec-charon.conf-tuned()
{
    chmod 400 ${CONF_DIR}/ipsec.charon.conf-tuned
}

main()
{
    deploy-sysconfig-squid-tuned
    chmod-ipsec-charon.conf-tuned
}
