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

source /tmp/CacheGuard.env
source ${LOCAL_DIR}/lib/apl_functions

source ${ABASE_DIR}/${ENV_RDIR}/${ENV_NAME}
source ${ABASE_DIR}/${ENV_RDIR}/${ENV_CURRENT_NAME}

reset-access-log()
{
    touch ${WEB_SERVER_DIR}/var/log/${WEB_LOG}
}

reset-raccess-log()
{
    touch ${WEB_SERVER_DIR}/var/log/${RWEB_LOG}
}

reset-cache-clear-log()
{
    echo -n > ${CACHE_CLEAR_LOG}
    chown ${ADMIN_UID}:${USERS_GID} ${CACHE_CLEAR_LOG}
    chmod 640 ${CACHE_CLEAR_LOG}
}

reset-av-create-log()
{
    echo -n > ${AV_CREATE_LOG}
    chown ${ADMIN_UID}:${USERS_GID} ${AV_CREATE_LOG}
    chmod 640 ${AV_CREATE_LOG}
}

reset-av-update-log()
{
    echo -n > ${AV_UPDATE_LOG}
    chown ${ADMIN_UID}:${USERS_GID} ${AV_UPDATE_LOG}
    chmod 640 ${AV_UPDATE_LOG}
}

reset-backup-log()
{
    echo -n > ${BACKUP_LOG}
    chown ${ADMIN_UID}:${USERS_GID} ${BACKUP_LOG}
    chmod 640 ${BACKUP_LOG}
}

reset-file-operation-log()
{
    echo -n > ${FILE_OPERATION_LOG}
    chown ${ADMIN_UID}:${USERS_GID} ${FILE_OPERATION_LOG}
    chmod 640 ${FILE_OPERATION_LOG}
}

reset-log-rotate-log()
{
    echo -n > ${LOG_ROTATE_LOG}
    chown ${ADMIN_UID}:${USERS_GID} ${LOG_ROTATE_LOG}
    chmod 640 ${LOG_ROTATE_LOG}
}

reset-guard-auto-log()
{
    echo -n > ${URLLIST_AUTO_LOG}
    chown ${ADMIN_UID}:${USERS_GID} ${URLLIST_AUTO_LOG}
    chmod 644 ${URLLIST_AUTO_LOG}
}

reset-wauth-log()
{
    echo -n > ${WAUTH_LOG}
    chown ${WADMIN_UID}:${USERS_GID} ${WAUTH_LOG}
    chmod 644 ${WAUTH_LOG}
}

reset-kerberos-create-log()
{
    echo -n > ${KERBEROS_CREATE_LOG}
    chown ${ADMIN_UID}:${USERS_GID} ${KERBEROS_CREATE_LOG}
    chmod 640 ${KERBEROS_CREATE_LOG}
}

init-privileged-admin-user()
{
    case ${APL_ROLE} in
	gateway)
	    install -d -m 755 -o ${ADMIN_NAME} -g ${GROUP_NAME} ${WAF_DIR}
	    install -d -m 755 -o ${ADMIN_NAME} -g ${GROUP_NAME} ${VPN_IPSEC_DIR}
	    install -d -m 755 -o ${ADMIN_NAME} -g ${GROUP_NAME} ${URLLIST_DIR}
	    ;;
	manager)
	    install -d -m 755 -o ${ADMIN_NAME} -g ${GROUP_NAME} ${ABASE_DIR}/${MANAGER_REPOSITORY_RDIR}
	    install -d -m 755 -o ${ADMIN_NAME} -g ${GROUP_NAME} ${ABASE_DIR}/${MANAGER_TEMPLATE_RDIR}
	    install -d -m 755 -o ${ADMIN_NAME} -g ${GROUP_NAME} ${ABASE_DIR}/${MANAGER_GATEWAY_RDIR}
	    ;;
	*)
	    ;;
    esac

    init-netrc-file ${ADMIN_NAME}
    init-htpasswd-file ${ADMIN_NAME}
    init-dashboard-layout-file ${ADMIN_NAME}
}

init-root-netrc()
{
    touch /root/.netrc
    chmod 600 /root/.netrc
}

init-clamav-log()
{
    local logs="freshclam.log clamd.log av-extended.log"
    local log

    for log in ${logs}
    do
	touch /var/log/${log}
	chmod 644 /var/log/${log}
	chown ${AV_USER}:${AV_GROUP} /var/log/${log}
    done

    touch ${WEB_SERVER_DIR}/var/log/${ANTI_VIRUS_LOG}
    chmod 644 ${WEB_SERVER_DIR}/var/log/${ANTI_VIRUS_LOG}

    touch ${WEB_SERVER_DIR}/var/log/${ANTI_VIRUS_SERVER_LOG}
    chmod 644 ${WEB_SERVER_DIR}/var/log/${ANTI_VIRUS_SERVER_LOG}
}

init-cache-log()
{
    touch \
	${PROXY_DIR}/var/log/${PROXY_LOG} \
	${PROXY_DIR}/var/log/${PROXY_GUARD_LOG}

    chmod 644 \
	${PROXY_DIR}/var/log/${PROXY_LOG} \
	${PROXY_DIR}/var/log/${PROXY_GUARD_LOG}

    chown ${SQUID_UID}:${SQUID_GID} \
	${PROXY_DIR}/var/log/${PROXY_LOG} \
	${PROXY_DIR}/var/log/${PROXY_GUARD_LOG}
}

init-firewall-log()
{
    touch ${WEB_SERVER_DIR}/var/log/${FIREWALL_LOG}
    chmod 644 ${WEB_SERVER_DIR}/var/log/${FIREWALL_LOG}
}

init-access-guard-log()
{
    rm -f ${PROXY_LOG_DIR}/${ACCESS_GUARD_LOG}
    mkfifo -m 644 ${PROXY_LOG_DIR}/${ACCESS_GUARD_LOG}
    chown ${SQUID_UID}:${SQUID_GID} ${PROXY_LOG_DIR}/${ACCESS_GUARD_LOG}

    touch ${WEB_LOG_DIR}/${ACCESS_GUARD_LOG}
    chmod 644 ${WEB_LOG_DIR}/${ACCESS_GUARD_LOG}
}

init-content-filter-log()
{
    touch ${WEB_SERVER_DIR}/var/log/${WAF_LOG}
    chmod 644 ${WEB_SERVER_DIR}/var/log/${WAF_LOG}
}

init-ipsec-connect-log()
{
    touch ${WEB_LOG_DIR}/${VPN_IPSEC_LOG}
    chmod 644 ${WEB_LOG_DIR}/${VPN_IPSEC_LOG}
}

gen-certificate-conf()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    test -n "${3}" || return 3
    local numbits=${1}
    local days=${2}
    local name=${3}

    echo "numbits ${numbits}"
    echo "days ${days}"
    echo "commonName ${name}"
    echo "countryName ${DEFAULT_COUNTRY_CODE}"
    echo "stateOrProvinceName My Province"
    echo "localityName My Locality"
    echo "organizationName My Organisation"
    echo "organizationalUnitName My Unit"
}

gen-ssl-objects()
{
    gen-certificate-conf 2048 5555 "*.${DOMAIN_NAME}" > ${TMP_DIR}/${TLS_SERVER}.default.conf
    gen-certificate-conf 2048 5555 "${DEFAULT_CA_CN}" > ${TMP_DIR}/${SYSTEM_CA}.conf

    chown ${ADMIN_UID}:${USERS_GID} \
	${TMP_DIR}/${TLS_SERVER}.default.conf \
	${TMP_DIR}/${SYSTEM_CA}.conf
}

chmod-conf-files()
{
    chmod 444		${CONF_DIR}/hosts
    chmod 400		${CONF_DIR}/sysctl.conf \
			${CONF_DIR}/sysnetctl.conf \
			${CONF_DIR}/sysconfig.iptables \
			${CONF_DIR}/ntp.conf \
			${CONF_DIR}/dhcpd.conf \
			${CONF_DIR}/login.access \
			${CONF_DIR}/sshd_config
    chmod 600		${CONF_DIR}/lcd4linux.conf
}

make-directories()
{
    test -d /etc			|| mkdir -p /etc
    test -d /etc/sysconfig		|| mkdir -p /etc/sysconfig
    test -d /etc/snmp			|| mkdir -p /etc/snmp
    test -d ${PROXY_GUARD_DIR}/self	|| mkdir -p ${PROXY_GUARD_DIR}/self
    test -d ${ETC_DIR}			|| mkdir -p ${ETC_DIR}
    test -d ${BASE_DIR}			|| mkdir -p ${BASE_DIR}
    test -d ${GUI_ETC_DIR}		|| mkdir -p ${GUI_ETC_DIR}
    test -d ${PROXY_DIR}/etc		|| mkdir -p ${PROXY_DIR}/etc
    test -d ${SNMP_SSL_CERTIFICATE_DIR}	|| mkdir -p ${SNMP_SSL_CERTIFICATE_DIR}
    test -d ${SNMP_SSL_CA_DIR}		|| mkdir -p ${SNMP_SSL_CA_DIR}
    test -d ${SNMP_SSL_KEY_DIR}		|| mkdir -p ${SNMP_SSL_KEY_DIR}
    test -d /var/snmp			|| mkdir -p /var/snmp
    
    chown ${SQUID_UID}:${SQUID_GID} ${PROXY_GUARD_DIR}/self
    chown ${SNMP_UID}:${SNMP_GID} /var/snmp
    chmod 700 /var/snmp ${SNMP_SSL_KEY_DIR}
}

make-links()
{
    ln -sf ${CONF_DIR}/dhcpd.conf			/etc/dhcpd.conf
    ln -sf ${CONF_DIR}/rt_tables			/etc/iproute2/rt_tables
    ln -sf ${CONF_DIR}/hosts				/etc/hosts
    ln -sf ${CONF_DIR}/login.access			/etc/login.access

    ln -sf ${CONF_DIR}/network				/etc/sysconfig/network
    ln -sf ${CONF_DIR}/network.lo			/etc/sysconfig/network.lo
    ln -sf ${CONF_DIR}/sysconfig.iptables		/etc/sysconfig/iptables
    ln -sf ${CONF_DIR}/sysconfig.tc			/etc/sysconfig/tc
    ln -sf ${CONF_DIR}/sysconfig.ntpd			/etc/sysconfig/ntpd
    ln -sf ${CONF_DIR}/sysconfig.dhcpd			/etc/sysconfig/dhcpd
    ln -sf ${CONF_DIR}/sysconfig.ocspd			/etc/sysconfig/ocspd
    ln -sf ${CONF_DIR}/sysconfig.ipsec			/etc/sysconfig/ipsec
    ln -sf ${CONF_DIR}/sysconfig.smanager		/etc/sysconfig/smanager
    ln -sf ${CONF_DIR}/sysconfig.snmpd			/etc/sysconfig/snmpd
    ln -sf ${CONF_DIR}/sysconfig.health			/etc/sysconfig/health
    ln -sf ${CONF_DIR}/sysconfig.path			/etc/sysconfig/path
    ln -sf ${CONF_DIR}/sysconfig.rlogger		/etc/sysconfig/rlogger
    ln -sf ${CONF_DIR}/sysconfig.vpnsubscr		/etc/sysconfig/vpnsubscr
    ln -sf ${CONF_DIR}/sysconfig.squid			/etc/sysconfig/squid

    ln -sf ${CONF_DIR}/rsyslog.conf			/etc/rsyslog.conf
    ln -sf ${CONF_DIR}/sysctl.conf			/etc/sysctl.conf
    ln -sf ${CONF_DIR}/sysnetctl.conf			/etc/sysnetctl.conf
    ln -sf ${CONF_DIR}/resolv.conf			/etc/resolv.conf
    ln -sf ${CONF_DIR}/ntp.conf				/etc/ntp.conf
    ln -sf ${CONF_DIR}/modprobe.bonding.conf		/etc/modprobe.d/bonding.conf
    ln -sf ${CONF_DIR}/lcd4linux.conf			/etc/lcd4linux.conf
    ln -sf ${CONF_DIR}/squid.conf			/etc/squid.conf
    ln -sf ${CONF_DIR}/squidGuard.conf			/etc/squidGuard.conf
    ln -sf ${PROXY_DIR}/bin/squidGuard			/bin/squidGuard
    ln -sf ${CONF_DIR}/issue				/etc/issue
    ln -sf ${CONF_DIR}/global.krb5.conf			/etc/krb5.conf
    ln -sf ${CONF_DIR}/snmpd.conf			/etc/snmp/snmpd.conf
    ln -sf ${CONF_DIR}/snmp.conf			/etc/snmp/snmp.conf
    ln -sf ${CONF_DIR}/sshd_config			/etc/sshd_config
    ln -sf ${CONF_DIR}/keepalived.conf			/usr/etc/keepalived/keepalived.conf
    ln -sf ${CONF_DIR}/issue				${LOCAL_DIR}/etc/banner
    ln -sf ${CONF_DIR}/clamd.conf			${LOCAL_DIR}/etc/clamd.conf
    ln -sf ${CONF_DIR}/freshclam.conf			${LOCAL_DIR}/etc/freshclam.conf
    ln -sf ${CONF_DIR}/c-icap.conf			${LOCAL_DIR}/etc/c-icap.conf
    ln -sf ${CONF_DIR}/virus_scan.conf			${LOCAL_DIR}/etc/virus_scan.conf
    ln -sf ${CONF_DIR}/ipsec.ca.conf			${LOCAL_DIR}/etc/ipsec.ca.conf
    ln -sf ${CONF_DIR}/ipsec.global.conf		${LOCAL_DIR}/etc/ipsec.global.conf
    ln -sf ${CONF_DIR}/ipsec.charon.conf		${LOCAL_DIR}/etc/strongswan.d/charon.conf
    ln -sf ${CONF_DIR}/ipsec.dhcp.conf			${LOCAL_DIR}/etc/strongswan.d/charon/dhcp.conf
    ln -sf ${CONF_DIR}/ipsec.ha.conf			${LOCAL_DIR}/etc/strongswan.d/charon/ha.conf
    ln -sf ${CONF_DIR}/ipsec.whitelist.conf		${LOCAL_DIR}/etc/strongswan.d/charon/whitelist.conf
    ln -sf ${CONF_DIR}/ipsec.charon-logging.conf	${LOCAL_DIR}/etc/strongswan.d/charon-logging.conf

    ln -sf ${CONF_DIR}/ldap.conf			${LDAP_DIR}/ldap.conf
    ln -sf ${CONF_DIR}/slapd.conf			${LDAP_DIR}/slapd.conf
    ln -sf ${CONF_DIR}/httpd.conf			${WEB_SERVER_DIR}/etc/httpd.conf
    ln -sf ${CONF_DIR}/${WAUDIT_NAME}.rules		${WEB_SERVER_DIR}/etc/${WAUDIT_NAME}.rules
    ln -sf ${CONF_DIR}/${WADMIN_NAME}.rules		${GUI_DIR}/etc/${WADMIN_NAME}.rules
    ln -sf ${CONF_DIR}/${WADMIND_NAME}.conf		${GUI_DIR}/etc/${WADMIND_NAME}.conf
    ln -sf ${CONF_DIR}/ipsec.secrets			${LOCAL_DIR}/etc/ipsec.secrets

    ln -sf ${CONF_DIR}/php.ini				${LOCAL_DIR}/lib/php.ini

    test -L ${LOCAL_DIR}/etc/${IPSEC_CONNECTION_DIR_NAME} || \
	ln -sf ${CONF_DIR}/${IPSEC_CONNECTION_DIR_NAME}	${LOCAL_DIR}/etc/${IPSEC_CONNECTION_DIR_NAME}

    ln -sf \
       ${CONF_DIR}/${EMBEDDED_VPNSUBSCR_NAME}.conf \
       ${WEB_SERVER_DIR}/etc/${EMBEDDED_VPNSUBSCR_NAME}.conf
}

reset-all-logs()
{
    reset-access-log
    reset-raccess-log
    reset-cache-clear-log
    reset-av-create-log
    reset-av-update-log
    reset-backup-log
    reset-file-operation-log
    reset-log-rotate-log
    reset-guard-auto-log
    reset-wauth-log
    reset-kerberos-create-log

    init-root-netrc

    init-clamav-log
    init-cache-log
    init-firewall-log
    init-access-guard-log
    init-content-filter-log
    init-ipsec-connect-log
}

init-etc-db-files()
{
    apl_create_db ${VPN_IPSEC_ACCESS_DB_SCHEMA} ${RUN_DIR}/${VPN_IPSEC_ACCESS_DB_FILE}
}

set-vpn-psk()
{
    test ${APL_ROLE} == gateway || return 0

    local secret="clear:${TECHNICAL_NAME}"
    local psk_file=${ABASE_DIR}/${ENV_RDIR}/${VPN_IPSEC_RDIR}/${IPSEC_AUTHENTICATE_PSK_FILENAME}

    secret=$(ROOT_DIR=${ADMIN_DIR} encrypt-password "${secret}" "${IPSEC_PASSWD}")
    echo -n "encrypted:${secret}" > /tmp/${IPSEC_AUTHENTICATE_PSK_FILENAME}.${$}

    install -m 640 -o ${ADMIN_UID} -g ${USERS_GID} /tmp/${IPSEC_AUTHENTICATE_PSK_FILENAME}.${$} ${psk_file}
    install -m 640 -o ${ADMIN_UID} -g ${USERS_GID} /tmp/${IPSEC_AUTHENTICATE_PSK_FILENAME}.${$} ${psk_file}.current

    rm -f /tmp/${IPSEC_AUTHENTICATE_PSK_FILENAME}.${$}
}

create-configuration-db()
{
    local db_file=${CONFIGURATION_DB_DIR}/${CONFIGURATION_DB_NAME}

    apl_create_db ${CONFIGURATION_DB_SCHEMA} ${db_file}
    chown ${ADMIN_NAME}:${GROUP_NAME} ${db_file}
}

init-configuration-db()
{
    local db_file=${CONFIGURATION_DB_DIR}/${CONFIGURATION_DB_NAME}
    test -f ${db_file} || return 11

    local code name
    local tmp_file=/tmp/init-configuration-db-${$}.sql

    while read code name
    do
	name=${name//\'/\'\'}
	echo "INSERT INTO country( code, name ) VALUES( '${code}', '${name}' );"
	echo "INSERT INTO waf_reputation_country( country ) VALUES( '${code}' );"
    done < ${APPLIANCE_DIR}/etc/countries > ${tmp_file}

    sqlite3 ${db_file} < ${tmp_file}

    rm -f ${tmp_file}
}

archive-configuration-db()
{
    local db_file=${CONFIGURATION_DB_DIR}/${CONFIGURATION_DB_NAME}

    install -m 644 -o ${ADMIN_UID} -g ${USERS_GID} ${db_file} ${CONFIGURATION_DB_DIR}/${CONFIGURATION_CURRENT_DB_NAME}

    install -m 444 -o ${ADMIN_UID} -g ${USERS_GID} ${db_file} ${SAVE_DIR}/${CONFIGURATION_FACTORY_DB_NAME}.gateway
    install -m 444 -o ${ADMIN_UID} -g ${USERS_GID} ${db_file} ${SAVE_DIR}/${CONFIGURATION_CURRENT_FACTORY_DB_NAME}.gateway
}

set-configuration-db()
{
    create-configuration-db
    init-configuration-db
    archive-configuration-db
}

set-modification-state()
{
    update-modification-state
    chown ${ADMIN_NAME}:${GROUP_NAME} ${ABASE_DIR}/${ENV_RDIR}/${MODIFICATION_STATE_FILENAME}
}

main()
{
    local context=configure

    make-directories

    init-account-environment
    set-configuration-db
    set-implicit-parameters
    gen-ssl-objects
    set-tls-certificates force
    set-classic-config-files ${context} force online
    make-links
    reset-all-logs
    init-etc-db-files
    init-privileged-admin-user
    set-prompt!
    set-local-time!
    set-self-urllist
    update-proxy-av-whitelist ${context}
    add-urllists nolog ${URLLIST_LIST}
    set-vpn-psk
    log-reset
    chmod-conf-files
    set-modification-state
}

# Main()

main

# Set modification date - See set-admin-users()
touch ${ETC_DIR}/shadow /etc/shadow
