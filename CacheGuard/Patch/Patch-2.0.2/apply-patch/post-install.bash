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
source ${ABASE_DIR}/${ENV_RDIR}/${ENV_CURRENT_NAME}

upgrad-tls-conf()
{
    local conf_file conf_files
    local var numbits line
    local cert_file tmp_conf_file=/tmp/upgraded-tls-conf.${$}

    conf_files=$(ls -1 ${SSL_CA_DIR}/${SYSTEM_CA}.conf ${SSL_SERVER_DIR}/*.conf ${SSL_CLIENT_DIR}/*.cur/*.conf 2> /dev/null)

    if test ${APL_ROLE} == manager ; then
	local template_conf_files=$(ls -1 ${ABASE_DIR}/${MANAGER_TEMPLATE_RDIR}/*/${SSL_CA_RDIR}/${SYSTEM_CA}.conf ${ABASE_DIR}/${MANAGER_TEMPLATE_RDIR}/*/${SSL_SERVER_RDIR}/*.conf 2> /dev/null)

	local gateway_conf_files=$(ls -1 ${ABASE_DIR}/${MANAGER_GATEWAY_RDIR}/*/${SSL_CA_RDIR}/${SYSTEM_CA}.conf ${ABASE_DIR}/${MANAGER_GATEWAY_RDIR}/*/${SSL_SERVER_RDIR}/*.conf ${ABASE_DIR}/${MANAGER_GATEWAY_RDIR}/*/${SSL_CLIENT_RDIR}/*.cur/*.conf 2> /dev/null)

	conf_files="${conf_files} ${template_conf_files} ${gateway_conf_files}"
    fi

    for conf_file in ${conf_files}
    do
	read var numbits < ${conf_file}

	test -n "${numbits}" || continue
	test ${var} != numbits || continue

	cert_file=${conf_file/%\.conf/\.certificate}

	test -f ${cert_file} || continue

	numbits=$(openssl x509 -in ${cert_file} -text -noout 2> /dev/null | grep "RSA Public-Key:")
	numbits=${numbits/*RSA Public-Key: \(}
	numbits=${numbits/ *}
	test -n "${numbits}" || numbits=2048

	echo "numbits ${numbits}" > ${tmp_conf_file}

	while read line
	do
	    echo ${line}
	done < ${conf_file} >> ${tmp_conf_file}

	cp ${conf_file} ${conf_file}.old
	install -m 644 -o ${ADMIN_NAME} -g ${GROUP_NAME} ${tmp_conf_file} ${conf_file}

	rm -f ${tmp_conf_file}
	rm -f ${conf_file}.old
    done
}

network-restart()
{
    test ${CURRENT_IP_AUXILIARY_IP} != '0.0.0.0' || return 0
    test -n "${CURRENT_BOND_AUXILIARIES}" || return 0

    /etc/rc.d/init.d/network stop
    /etc/rc.d/init.d/network start
}

main()
{
    upgrad-tls-conf
    network-restart
}

main
