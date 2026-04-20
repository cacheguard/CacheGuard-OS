#!/bin/bash

test -n "${APL}" || exit 1
test -d "${APL}" || exit 2

source CacheGuard.env
source TUNER.env

gen-lcd4linux-constant()
{
    echo -e "Variables {"
    echo -e "\ttick\t\t500"
    echo -e "\tmn\t\t60000"
    echo -e "\tappliance\t'${COMMERCIAL_NAME}'"
    echo -e "}"
}

gen-lcd4linux-variable()
{
    echo -e "Variables {"
    echo -e "\tdev\t\t'eth${IF_INTERNAL_NUM}'"
    echo -e "\tbw\t\t100000000"
    echo -e "}"
}

gen-lcd4linux-start-conf()
{
    gen-lcd4linux-constant
    gen-lcd4linux-variable

    cat Constant/lcd4linux.conf-constant-1

    echo -e "Layout\t'Start'"
    echo -e "Display\t'${LCD_DISPLAY}'"
}

gen-lcd4linux-stop-conf()
{
    gen-lcd4linux-constant
    gen-lcd4linux-variable

    cat Constant/lcd4linux.conf-constant-1

    echo -e "Layout\t'Stop'"
    echo -e "Display\t'${LCD_DISPLAY}'"
}

gen-lcd4linux-restart-conf()
{
    gen-lcd4linux-constant
    gen-lcd4linux-variable

    cat Constant/lcd4linux.conf-constant-1

    echo -e "Layout\t'Restart'"
    echo -e "Display\t'${LCD_DISPLAY}'"
}

gen-lcd4linux.conf-constant()
{
    gen-lcd4linux-constant

    cat Constant/lcd4linux.conf-constant-1

    echo -e "Layout\t'RunTime'"
    echo -e "Display\t'${LCD_DISPLAY}'"
}

gen-squid-conf-constant()
{
    local len=${#PROXY_DIR}
    local state_dir=${PROXY_STATE_DIR:${len}}

    cat Constant/squid.conf-constant-acl
    echo
    echo "acl to-cloud-metadata-ip dst ${CLOUD_METADATA_IP}/32"
    echo "acl to-cloud-azure-fabric-ip dst ${CLOUD_AZURE_FABRIC_IP}/32"
    echo

    cat Constant/squid.conf-constant-etc
    echo
    echo "coredump_dir ${PROXY_LOG_DIR:${#PROXY_DIR}}"
    echo "quick_abort_pct 75"
    echo "request_header_max_size ${HTTP_REQUEST_HEADER_SZ} KB"
    echo "request_timeout ${HTTP_REQUEST_TIMEOUT} seconds"
    echo "cache_store_log none"
    echo "cache_log /var/log/${PROXY_LOG}"
    echo "cache_swap_state ${state_dir}/%s.swap.state"
}

gen-modsecurity-common-conf()
{
    cat Constant/modsecurity-common.conf-1

    echo "SecGeoLookupDB ${WEB_SERVER_DIR}/share/GeoLiteCountry.dat"
    echo "SecServerSignature \"${PUBLIC_WEB_SERVER_NAME}\""
    echo "SecUploadDir ${UPLOAD_RDIR}"
    echo "SecAuditLogStorageDir /${AUDIT_RDIR}"
    echo "SecAuditLog ${AUDIT_RDIR}/audit.log"
}

gen-modsecurity-common-rules()
{
    echo "SecRule REQUEST_URI \"^/${ERROR_LOCATION}/HTTP_.*\.html$\" \"id:200,severity:6,pass\""
    echo
    cat Constant/modsecurity-common.rules-1
}

gen-sudoers-constant()
{
    cat Constant/sudoers-constant-1

    echo 'env_keep = "TERM", \'
    echo -e "\ttimestampdir = \"/var/lib/sudo\""
    echo
    echo "Runas_Alias ROOT = root"
    echo
    echo "User_Alias ADMINISTRATOR = ${ADMIN_NAME}"
    echo "User_Alias SUPER_ADMINISTRATOR = ${SUPERADMIN_NAME}"
    echo "User_Alias SNMP_AGENT = snmp"
    echo
    echo "Cmnd_Alias CHROOT_ADMIN = /usr/sbin/chroot ${ADMIN_DIR} su --login ${ADMIN_NAME}*"
    echo "Cmnd_Alias APL_COMMAND = ${LOCAL_DIR}/bin/apl_*,${LOCAL_DIR}/sbin/apl_*"
    echo "Cmnd_Alias HEALTH_CHECK = ${LOCAL_DIR}/bin/apl_health_check*"
    echo
    echo "ADMINISTRATOR SECUREHOST = (ROOT) NOPASSWD: CHROOT_ADMIN"
    echo "SUPER_ADMINISTRATOR SECUREHOST = (ROOT) NOPASSWD: APL_COMMAND"
    echo "SNMP_AGENT SECUREHOST = (ROOT) NOPASSWD: HEALTH_CHECK"
}

gen-admin-sudoers-constant()
{
    cat Constant/sudoers-constant-1

    echo 'env_keep = "TERM MANAGER_CONTEXT_ENV", \'
    echo -e "\t timestampdir = \"/var/run/sudo\""
    echo
    echo "Cmnd_Alias CONFIGURE = \\"
    for command in ${COMMANDS}
    do
	echo -e "\t /bin/apl_bash -c ${command}*, \\"
    done
    echo -e "\t /bin/false"
    echo
    echo "User_Alias WEB_ADMINISTRATOR = ${WADMIN_NAME}"
    echo "WEB_ADMINISTRATOR SECUREHOST = (ADMINISTRATOR) NOPASSWD: CONFIGURE"
}

gen-login-access-constant()
{
    local tty ttys 

    for tty in ${TRUSTED_TTY}
    do
	ttys="${ttys} /dev/${tty}"
    done

    test -z "${ttys}" || ttys=${ttys:1}
    echo "+:${SUPERADMIN_NAME}:${ttys}"
}

gen-request-info()
{
    local http_request_header_sz=$[${HTTP_REQUEST_HEADER_SZ} * 1024]
 
    echo "LimitRequestFieldSize ${http_request_header_sz}"
    echo "LimitRequestLine ${http_request_header_sz}"
    echo "LimitXMLRequestBody 0"
    echo "TimeOut ${HTTP_REQUEST_TIMEOUT}"
}

gen-httpd-conf-common()
{
    test -n "${1}" || return 1
    server=${1}

    local base_dir error_dir

    case ${server} in
	httpd)
	    base_dir=${WEB_SERVER_DIR}
	;;

	${WADMIND_NAME})
	    base_dir=${ADMIN_DIR}${GUI_DIR}
	    error_dir=${GUI_DIR}
	;;

	*)
	;;
    esac

    cat Constant/httpd.conf-common-constant | \
	sed \
	    -e "s@_ErrorLocation_@${ERROR_LOCATION}@g" \
	    -e "s@_Web_Server_Dir_@${WEB_SERVER_DIR}@g" \
	    -e "s@_Error_Dir_@${error_dir}@g" \
	    -e "s@_Base_Dir_@${base_dir}@g" 
}

gen-httpd-modules.conf-constant()
{
    sed \
    -e "s@_Web_Server_Dir_@${WEB_SERVER_DIR}@g" \
    -e "s@_Local_Dir_@${LOCAL_DIR}@g" \
    Constant/httpd-modules.conf-constant-1
}

gen-httpd.conf-constant()
{
    echo "ServerRoot \"${WEB_SERVER_DIR}\""
    echo "ChrootDir \"${WEB_SERVER_DIR}\""
    echo
    gen-httpd-conf-common httpd
    gen-request-info

    echo "ErrorLog var/log/${WEB_SERVER_LOG}"
    echo "ErrorLogFormat \"[%{cu}t] [%l] %7F: %E: [client\ %a] %M% ,\ referer\ %{Referer}i\""

    echo "User filter"
    echo "Group filter"
    echo "PidFile var/run/httpd.pid"
    echo "ScriptAlias /${GUI_DIR_NAME}/ \"/${CGI_RDIR}/\""
    echo "DirectoryIndex index.html"

    echo "<Directory \"${WEB_SERVER_DIR}/${CGI_RDIR}\">"
    echo "AllowOverride None"
    echo "Options None"
    echo "Order allow,deny"
    echo "Deny from all"
    echo "</Directory>"
}

gen-wadmind.conf-constant()
{
    echo "ServerRoot \"${ADMIN_DIR}\""
    echo "ChrootDir \"${ADMIN_DIR}\""

    gen-httpd-conf-common ${WADMIND_NAME}
    gen-request-info

    echo "ErrorLog ${ADMIN_DIR}/var/log/${WADMIND_NAME}.log"
    echo "Mutex file:${ADMIN_DIR}/var/run"
    echo
    echo "PidFile var/run/${WADMIND_NAME}.pid"
    sed -e "s@_Web_Server_Dir_@${WEB_SERVER_DIR}@g" Constant/wadmind.conf-constant-1
    echo "SSLSessionCache shmcb:${ADMIN_DIR}/var/run/ssl_scache(32000)"
    echo
    echo "ScriptAlias /${GUI_DIR_NAME}/ \"${GUI_DIR}/${CGI_RDIR}/\""
    echo "DirectoryIndex /${GUI_DIR_NAME}/system-report.${GUI_EXT_NAME}"
    echo "User ${WADMIN_NAME}"
    echo "Group users"
    echo "PidFile ${ADMIN_DIR}/var/run/${WADMIND_NAME}.pid"
}

gen-sshd_config-constant()
{
    echo "AllowGroups users ${SUPERADMIN_NAME}"
    echo "Banner ${LOCAL_DIR}/etc/banner"
    echo "HostKey ${SSH_HOST_RSA_KEY_FILE}"

    cat Constant/sshd_config-constant-1
}

gen-tst-links()
{
    echo "eth0 aa:bb:cc:dd:ee:00 Test NIC"
    echo "eth1 aa:bb:cc:dd:ee:01 Test NIC"
}

gen-tst-hw-drive()
{
    echo "HD [1] (10 GB)"
}

configure-tst()
{
    local memory_type keyboard

    gen-tst-links > ${MODEL_GENERATED_DIR}/hw-links
    gen-tst-hw-drive > ${MODEL_GENERATED_DIR}/hw-drive

    sudo install -m 644 -o root -g root ${MODEL_GENERATED_DIR}/hw-links ${APL}${HARD_DIR}/hw-links
    sudo install -m 644 -o root -g root ${MODEL_GENERATED_DIR}/hw-drive ${APL}${HARD_DIR}/hw-drive

    case ${SYS_ARCHITECTURE} in
	x86_64)
	    memory_type=64mem
	    ;;
	*)
	    memory_type=lowmem
	    ;;
    esac

    case ${TEST_ROLE} in

	gateway)

	    local total_rweb_cache_sz=$[${TEST_RWEB_NB} * ${TEST_PER_RWEB_CACHE_SZ}]

	    DEVELOPMENT_CONF_DIR=${GENERATED_DIR}/ \
	    GENERATED_DIR=${MODEL_GENERATED_DIR} \
	    ./apl_model_configure \
	    ${memory_type} \
	    ${TEST_CPU_NB} \
	    ${TEST_MEMORY_SZ} \
	    "${TEST_DISK_INFOS}" \
	    "${TEST_NETWORK_DEVICES}" \
	    "${keyboard}" \
	    "${TEST_ROLE}:${TEST_USERS_NB},${TEST_URLLIST_RECORDS_NB},${TEST_RUSERS_NB},${TEST_RWEB_NB},${TEST_LOGROTATE_NB},${total_rweb_cache_sz},${TEST_MAX_UPLOAD_FILE_SZ},on,on,on"
	    ;;

	manager)
	    local test_total_users_nb=$[${TEST_USERS_NB} * ${TEST_GATEWAY_NB}]
	    local test_total_rweb_nb=$[${TEST_RWEB_NB} * ${TEST_GATEWAY_NB}]

	    DEVELOPMENT_CONF_DIR=${GENERATED_DIR}/ \
	    GENERATED_DIR=${MODEL_GENERATED_DIR} \
	    ./apl_model_configure \
	    ${memory_type} \
	    ${TEST_CPU_NB} \
	    ${TEST_MEMORY_SZ} \
	    "${TEST_DISK_INFOS}" \
	    "${TEST_NETWORK_DEVICES}" \
	    "${keyboard}" \
	    "${TEST_ROLE}:${TEST_GATEWAY_NB},${TEST_TEMPLATE_NB},${test_total_users_nb},${test_total_rweb_nb},${TEST_URLLIST_RECORDS_NB}"
	    ;;
	*)
	    ;;
    esac
}

gen-slapd.conf-constant()
{
    local schema

    for schema in core cosine inetorgperson nis misc
    do
	echo "include ${LDAP_DIR}/schema/${schema}.schema"
    done

    echo

    cat Constant/slapd.conf-constant-1
}

gen-squidGuard.conf-constant()
{
    cat Constant/squidGuard.conf-constant-1
}

gen-clamd.conf-constant()
{
    cat Constant/clamd.conf-constant-1

    echo "TemporaryDirectory /var/tmp"
    echo "DatabaseDirectory ${AV_DB_DIR}"
    echo "User ${AV_USER}"
    echo "StreamMinPort ${AV_STREAM_MIN_PORT}"
    echo "StreamMaxPort ${AV_STREAM_MAX_PORT}"
}

gen-freshclam.conf-constant()
{
    cat Constant/freshclam.conf-constant-1

    echo "DatabaseOwner ${AV_USER}"
    echo "DatabaseDirectory ${AV_DB_DIR}"
    echo "OnErrorExecute ${LOCAL_DIR}/bin/apl_av_operation error"
    echo "OnUpdateExecute ${LOCAL_DIR}/bin/apl_av_operation update"
    echo "OnOutdatedExecute ${LOCAL_DIR}/bin/apl_av_operation outdated %v"
}

gen-virus_scan.conf-constant()
{
    cat Constant/virus_scan.conf-constant-1
}

gen-c-icap.conf-constant()
{
    local timeout=300

    cat Constant/c-icap.conf-constant-1
    echo
    echo "icap_access allow localnet"
    echo "icap_access deny all"
    echo
    echo "Timeout ${timeout}"
    echo "KeepAliveTimeout $[${timeout} * 2]"
    echo "ServerName ${TECHNICAL_NAME}"
}

gen-certificate.cnf-head-constant()
{
    cat Constant/certificate.cnf-head-constant-1

    echo "serial = \$SSLDIR/${SSL_CTL_DIR_NAME}/serial"
    echo "database = \$SSLDIR/${SSL_CTL_DIR_NAME}/index.txt"
    echo "new_certs_dir = \$SSLDIR/${SSL_CTL_DIR_NAME}"
    echo "certificate  = \$SSLDIR/${CA_DIR_NAME}/${SYSTEM_CA}.certificate"
    echo "private_key = \$SSLDIR/${CA_DIR_NAME}/${SYSTEM_CA}.key"
    echo
    cat Constant/certificate.cnf-head-constant-2
}

gen-rsyslog.conf-constant()
{
    cat << EOF
# Begin /etc/rsyslog.conf

\$ModLoad imuxsock.so
\$ModLoad imklog.so
\$AddUnixListenSocket ${PROXY_DIR}/dev/log

\$template CG_FileFormat,"%TIMESTAMP:::date-rfc3339% %HOSTNAME% %syslogtag%%msg:::sp-if-no-1st-sp%%msg:::drop-last-lf%\n"

\$ActionFileDefaultTemplate CG_FileFormat

daemon.* -/var/log/daemon.log;CG_FileFormat

user.* -/var/log/user.log;CG_FileFormat

ftp.*;lpr.*;mail.*;news.*;syslog.*;uucp.*;local0.*;local1.*;local7.*;cron.!info -/var/log/sys.log;CG_FileFormat

local3.* -/var/log/smartd.log;CG_FileFormat
EOF
}

gen-snmpd.conf-constant()
{
    local line

    while read line
    do
	echo "[snmp] ${line}"
    done < Constant/snmp.conf-constant-1
    echo
    echo "sysDescr ${COMMERCIAL_NAME}-OS v${OS_VERSION}"

    cat Constant/snmpd.conf-constant-2

    echo "pass_persist .${SNMP_OID} ${LOCAL_DIR}/bin/apl_snmp_agent"
}

gen-snmp.conf-constant()
{
    cat Constant/snmp.conf-constant-1
}

gen-rt_tables-constant()
{
    cat Constant/rt_tables-constant-1

    echo ${IPSEC_ROUTE_TABLE_NB} ${IPSEC_ROUTE_TABLE_NAME}
}

gen-pam_d_sshd()
{
    cat pam.d/sshd-1
    echo
    echo "auth [success=1 default=ignore] pam_exec.so quiet ${LOCAL_DIR}/bin/apl_pam_2fa"
    echo "auth required ${LOCAL_DIR}/lib/security/pam_google_authenticator.so echo_verification_code"
}

gen-ipsec-ca-conf()
{
    echo "ca ${COMMERCIAL_NAME}"
    echo "    auto = ignore"
    echo "    cacert = ${SYSTEM_CA_ID}.certificate"
    echo "    ocspuri ="
}

gen-ipsec-charon-conf()
{
    sed \
	-e "s/group =.*/group = ${IPSEC_GROUP}/" \
	-e "s/routing_table =.*/routing_table = ${IPSEC_ROUTE_TABLE_NB}/" \
	-e "s/routing_table_prio =.*/routing_table_prio = ${IPSEC_ROUTE_PRIORITY}/" \
	-e "s/user =.*/user = ${IPSEC_USER}/" \
	\
	IPsec/charon.conf
}

gen-ipsec-conf()
{
    gen-ipsec-ca-conf > ${GENERATED_DIR}/ipsec.ca.conf
    gen-ipsec-charon-conf > ${GENERATED_DIR}/ipsec.charon.conf
}

install-ipsec-conf()
{
    sudo install -m 400 -o root -g root ${GENERATED_DIR}/ipsec.ca.conf ${APL}${CACHEGUARD_DIR}/ipsec.ca.conf
    sudo install -m 400 -o root -g root ${GENERATED_DIR}/ipsec.charon.conf ${APL}${CACHEGUARD_DIR}/ipsec.charon.conf
    sudo install -m 400 -o root -g root IPsec/dhcp.conf ${APL}${CACHEGUARD_DIR}/ipsec.dhcp.conf
    sudo install -m 400 -o root -g root IPsec/ha.conf ${APL}${CACHEGUARD_DIR}/ipsec.ha.conf
    sudo install -m 400 -o root -g root IPsec/charon-logging.conf ${APL}${CACHEGUARD_DIR}/ipsec.charon-logging.conf
}

gen-tuner-conf()
{
    gen-lcd4linux-start-conf > ${GENERATED_DIR}/lcd4linux-start.conf
    gen-lcd4linux-stop-conf > ${GENERATED_DIR}/lcd4linux-stop.conf
    gen-lcd4linux-restart-conf > ${GENERATED_DIR}/lcd4linux-restart.conf

    gen-modsecurity-common-conf > ${GENERATED_DIR}/modsecurity-common.conf
    gen-modsecurity-common-rules > ${GENERATED_DIR}/modsecurity-common.rules

    gen-squid-conf-constant > ${GENERATED_DIR}/squid.conf-constant
    gen-sudoers-constant > ${GENERATED_DIR}/sudoers-constant
    gen-admin-sudoers-constant > ${GENERATED_DIR}/admin-sudoers-constant
    gen-login-access-constant > ${GENERATED_DIR}/login.access-constant
    gen-httpd-modules.conf-constant > ${GENERATED_DIR}/httpd-modules.conf-constant
    gen-httpd.conf-constant > ${GENERATED_DIR}/httpd.conf-constant
    gen-wadmind.conf-constant > ${GENERATED_DIR}/${WADMIND_NAME}.conf-constant
    gen-sshd_config-constant > ${GENERATED_DIR}/sshd_config-constant
    gen-slapd.conf-constant > ${GENERATED_DIR}/slapd.conf-constant
    gen-squidGuard.conf-constant > ${GENERATED_DIR}/squidGuard.conf-constant
    gen-clamd.conf-constant > ${GENERATED_DIR}/clamd.conf-constant
    gen-freshclam.conf-constant > ${GENERATED_DIR}/freshclam.conf-constant
    gen-virus_scan.conf-constant > ${GENERATED_DIR}/virus_scan.conf-constant
    gen-c-icap.conf-constant > ${GENERATED_DIR}/c-icap.conf-constant
    gen-certificate.cnf-head-constant > ${GENERATED_DIR}/certificate.cnf-head-constant
    gen-rsyslog.conf-constant > ${GENERATED_DIR}/rsyslog.conf-constant
    gen-lcd4linux.conf-constant > ${GENERATED_DIR}/lcd4linux.conf-constant
    gen-snmpd.conf-constant > ${GENERATED_DIR}/snmpd.conf-constant
    gen-snmp.conf-constant > ${GENERATED_DIR}/snmp.conf-constant
    gen-rt_tables-constant > ${GENERATED_DIR}/rt_tables-constant
    gen-pam_d_sshd > ${GENERATED_DIR}/pam.d.sshd
}

install-tuner-conf()
{
    sudo install -m 600 -o root -g root ${GENERATED_DIR}/lcd4linux-start.conf ${APL}/etc/lcd4linux-start.conf
    sudo install -m 600 -o root -g root ${GENERATED_DIR}/lcd4linux-stop.conf ${APL}/etc/lcd4linux-stop.conf
    sudo install -m 600 -o root -g root ${GENERATED_DIR}/lcd4linux-restart.conf ${APL}/etc/lcd4linux-restart.conf

    sudo install -m 644 -o root -g root pam.d/other ${APL}/etc/pam.d/other
    sudo install -m 644 -o root -g root ${GENERATED_DIR}/pam.d.sshd ${APL}/etc/pam.d/sshd

    sudo install -m 444 -o root -g root ${GENERATED_DIR}/modsecurity-common.conf ${APL}${WEB_ETC_DIR}/modsecurity-common.conf
    sudo install -m 444 -o root -g root ${GENERATED_DIR}/modsecurity-common.rules ${APL}${WEB_ETC_DIR}/modsecurity-common.rules

    sudo install -m 444 -o root -g root ${GENERATED_DIR}/squid.conf-constant ${APL}${CONF_DIR}/squid.conf-constant
    sudo install -m 440 -o root -g root ${GENERATED_DIR}/sudoers-constant ${APL}${CONF_DIR}/sudoers-constant
    sudo install -m 444 -o root -g root ${GENERATED_DIR}/admin-sudoers-constant ${APL}${CONF_DIR}/admin-sudoers-constant
    sudo install -m 400 -o root -g root ${GENERATED_DIR}/login.access-constant ${APL}${CONF_DIR}/login.access-constant
    sudo install -m 400 -o root -g root ${GENERATED_DIR}/httpd-modules.conf-constant ${APL}${CONF_DIR}/httpd-modules.conf-constant
    sudo install -m 400 -o root -g root ${GENERATED_DIR}/httpd.conf-constant ${APL}${CONF_DIR}/httpd.conf-constant
    sudo install -m 400 -o root -g root ${GENERATED_DIR}/${WADMIND_NAME}.conf-constant ${APL}${CONF_DIR}/${WADMIND_NAME}.conf-constant
    sudo install -m 400 -o root -g root ${GENERATED_DIR}/sshd_config-constant ${APL}${CONF_DIR}/sshd_config-constant
    sudo install -m 400 -o root -g root ${GENERATED_DIR}/slapd.conf-constant ${APL}${CONF_DIR}/slapd.conf-constant
    sudo install -m 400 -o root -g root ${GENERATED_DIR}/squidGuard.conf-constant ${APL}${CONF_DIR}/squidGuard.conf-constant
    sudo install -m 400 -o root -g root ${GENERATED_DIR}/clamd.conf-constant ${APL}${CONF_DIR}/clamd.conf-constant
    sudo install -m 400 -o root -g root ${GENERATED_DIR}/freshclam.conf-constant ${APL}${CONF_DIR}/freshclam.conf-constant
    sudo install -m 400 -o root -g root ${GENERATED_DIR}/virus_scan.conf-constant ${APL}${CONF_DIR}/virus_scan.conf-constant
    sudo install -m 400 -o root -g root ${GENERATED_DIR}/c-icap.conf-constant ${APL}${CONF_DIR}/c-icap.conf-constant
    sudo install -m 600 -o root -g root ${GENERATED_DIR}/lcd4linux.conf-constant ${APL}${CONF_DIR}/lcd4linux.conf-constant
    sudo install -m 644 -o root -g root ${GENERATED_DIR}/snmpd.conf-constant ${APL}${CONF_DIR}/snmpd.conf-constant
    sudo install -m 644 -o root -g root ${GENERATED_DIR}/snmp.conf-constant ${APL}${CONF_DIR}/snmp.conf-constant
    sudo install -m 400 -o root -g root ${GENERATED_DIR}/rsyslog.conf-constant ${APL}${CONF_DIR}/rsyslog.conf-constant
    sudo install -m 400 -o root -g root ${GENERATED_DIR}/rt_tables-constant ${APL}${CONF_DIR}/rt_tables-constant
    sudo install -m 444 -o root -g root ${GENERATED_DIR}/certificate.cnf-head-constant ${APL}${ADMIN_DIR}${APPLIANCE_DIR}/etc/certificate.cnf-head-constant

    sudo install -m 400 -o root -g root Constant/sysctl.conf-constant ${APL}${CONF_DIR}/sysctl.conf-constant
    sudo install -m 400 -o root -g root Constant/named.conf-top-constant ${APL}${CONF_DIR}/named.conf-top-constant
    sudo install -m 400 -o root -g root Constant/named.conf-bottom-constant ${APL}${CONF_DIR}/named.conf-bottom-constant
    sudo install -m 400 -o root -g root Constant/dhcpd.conf-constant ${APL}${CONF_DIR}/dhcpd.conf-constant
    sudo install -m 400 -o root -g root Constant/httpd-proxy.conf-cache-constant ${APL}${CONF_DIR}/httpd-proxy.conf-cache-constant
    sudo install -m 400 -o root -g root Constant/ntp.conf-constant ${APL}${CONF_DIR}/ntp.conf-constant
    sudo install -m 400 -o root -g root Constant/wpad.pac-1-constant ${APL}${CONF_DIR}/wpad.pac-1-constant
    sudo install -m 400 -o root -g root Constant/wpad.pac-3-constant ${APL}${CONF_DIR}/wpad.pac-3-constant

    sudo install -m 400 -o root -g root Constant/sysconfig.ntpd-constant ${APL}${CONF_DIR}/sysconfig.ntpd-constant
    sudo install -m 400 -o root -g root Constant/sysconfig.snmpd-constant ${APL}${CONF_DIR}/sysconfig.snmpd-constant
    sudo install -m 600 -o root -g root Constant/sysconfig.lcd4linux ${APL}/etc/sysconfig/lcd4linux
    sudo install -m 444 -o root -g root Constant/certificate.cnf-req-dn-constant ${APL}${ADMIN_DIR}${APPLIANCE_DIR}/etc/certificate.cnf-req-dn-constant
}

model-install()
{
    cp -f ${MODEL_GENERATED_DIR}/etc.fstab ${MODEL_GENERATED_DIR}/etc.fstab.uuid

    GENERATED_DIR=${MODEL_GENERATED_DIR} \
	sudo -E \
	${PWD}/apl_model_install install ${TEST_ROLE}
}

install-scripts()
{
    sudo install -m 755 -o root -g root apl_model_configure ${APL}${LOCAL_DIR}/bin/
    sudo install -m 755 -o root -g root apl_model_install ${APL}${LOCAL_DIR}/bin/
    sudo install -m 755 -o root -g root apl_model_retune ${APL}${LOCAL_DIR}/bin/
    sudo install -m 644 -o root -g root TUNER.env ${APL}${CACHEGUARD_DIR}/
}

# Main()

mkdir -p ${FULL_GENERATED_DIR}
ln -sf ${FULL_GENERATED_DIR}

mkdir -p ${BASE_GENERATED_DIR}/${MODEL_GENERATED_DIR}
ln -sf ${BASE_GENERATED_DIR}/${MODEL_GENERATED_DIR}

gen-ipsec-conf
install-ipsec-conf
gen-tuner-conf
configure-tst
install-tuner-conf
model-install
install-scripts
