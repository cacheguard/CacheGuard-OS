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

move-ipsec-psk-envdir()
{
    test -n "${1}" || return 1
    local envdir=${1}

    install -d -m 755 -o ${ADMIN_NAME} -g ${GROUP_NAME} ${envdir}/${VPN_IPSEC_RDIR}

    if test -f ${envdir}/vpnipsec.psk ; then
	mv -f ${envdir}/vpnipsec.psk ${envdir}/${VPN_IPSEC_RDIR}/${IPSEC_AUTHENTICATE_PSK_FILENAME}
    fi

    if test -f ${envdir}/vpnipsec.psk.current ; then
	mv -f ${envdir}/vpnipsec.psk.current ${envdir}/${VPN_IPSEC_RDIR}/${IPSEC_AUTHENTICATE_PSK_FILENAME}.current
    fi
}

move-ipsec-psk-envdir-manager-templates()
{
    local rdir=${MANAGER_TEMPLATE_RDIR}
    local dir=${ABASE_DIR}/${rdir}
    local templates=$(ls -1 ${dir} 2> /dev/null)

    test -n "${templates}" || return 0

    local id envdir

    for id in ${templates}
    do
	envdir=${dir}/${id}
	move-ipsec-psk-envdir ${envdir}
    done
}

move-ipsec-psk-envdir-manager-gateways()
{
    test -s ${ABASE_DIR}/${MANAGER_GATEWAY_INDEX} || return 0

    local rdir=${MANAGER_GATEWAY_RDIR}
    local dir=${ABASE_DIR}/${rdir}

    local uuid domain id ip
    local envdir

    while read uuid domain id ip
    do
	test -n "${ip}" || continue
	envdir=${dir}/${id}
	move-ipsec-psk-envdir ${envdir}
    done < ${ABASE_DIR}/${MANAGER_GATEWAY_INDEX}
}

move-ipsec-psk()
{
    case ${APL_ROLE} in
	gateway)
	    move-ipsec-psk-envdir ${ABASE_DIR}/${ENV_RDIR}
	    ;;
	manager)
	    rm -f ${ABASE_DIR}/${ENV_RDIR}/{vpnipsec.psk,vpnipsec.psk.current}
	    move-ipsec-psk-envdir-manager-templates
	    move-ipsec-psk-envdir-manager-gateways
	    ;;
	*)
	    ;;
    esac
}

create-vpnipsec-access-db()
{
    apl_create_db ${VPN_IPSEC_ACCESS_DB_SCHEMA} ${RUN_DIR}/${VPN_IPSEC_ACCESS_DB_FILE}
}

chown-proxy-ssl-dir()
{
    test ${APL_ROLE} == gateway || return 0
    test -d ${PROXY_DB_SSL_DIR} || return 0

    chown -R cache:cache ${PROXY_DB_SSL_DIR}
}

main()
{
    chown-proxy-ssl-dir
    move-ipsec-psk
    create-vpnipsec-access-db
}

main
