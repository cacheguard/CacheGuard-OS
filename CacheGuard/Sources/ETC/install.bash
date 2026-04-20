#!/bin/bash

test -n "${APL}" || exit 1
test -d "${APL}" || exit 2

source WorkFunctions
source CacheGuard.env

remove-newline()
{
    test -n "${1}"
    local file=${1}

    local line
    while read line
    do
	echo -n ${line}
    done < ${file}
}

gen-message-item()
{
    local item=${1}

    echo -n "${item}.<p />"
}

gen-message-top()
{
    local left_title=${1}
    local right_title=${2}

    echo -n "<!DOCTYPE html>"
    echo -n "<html>"
    echo -n "<head>"
    echo -n "<title>${right_title}</title>"
    echo -n "<style type='text/css'>"
    echo -n "${STYLES_CSS}"
    echo -n "</style>"
    echo -n "</head>"

    echo -n "<body>"
    echo -n "<div id='wrap'><div id='content'>"    
    echo -n "<table>"
    echo -n "<tr>"
    echo -n "<td>${left_title}</td>"
    echo -n "<td>${right_title}</td>"
    echo -n "</tr>"
}

gen-message-bottom()
{
    echo -n "</table>"
    echo -n "</div></div>"
    echo -n "</body>"
    echo -n "</html>"
}

gen-squid-html-error()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    test -n "${3}" || return 3
    test -n "${4}" || return 4
    local err_type=${1}
    local err_code=${2}
    local err_title=${3}
    local err_text1=${4}
    local err_text2=${5}
    local err_text3=${6}

    local left_title_message

    case ${err_type} in
	ERR_)
	    left_title_message="Error ${err_code}"
	    ;;
	INF_)
	    left_title_message="Notification"
	    ;;
	*)
	    left_title_message="Message"
	    ;;
    esac

    gen-message-top "${left_title_message}" "${err_title}"
    
    echo -n "<tr>"
    echo -n "<td>Message</td>"
    echo -n "<td>"

    gen-message-item "${err_text1}"
    test -z "${err_text2}" || gen-message-item "${err_text2}"
    test -z "${err_text3}" || gen-message-item "${err_text3}"
    test ${err_type} == "INF_" || gen-message-item "You can reach your Gateway administrator at <a href='mailto:%w?subject=Gateway Error ${err_code}@%h'>%w</a>"

    echo -n "</td>"
    echo -n "</tr>"

    gen-message-bottom
}

gen-httpd-html-error()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 1
    test -n "${3}" || return 1

    local err_code=${1}
    local err_title=${2}
    local err_text1=${3}
    local err_text2=${4}
    local err_text3=${5}

    if test ${err_code} -ge 400 -a ${err_code} -lt 500 ; then
	local title="Client error ${err_code}"
    elif test ${err_code} -ge 500 -a ${err_code} -lt 600 ; then
	local title="Server error ${err_code}"
    fi

    gen-message-top "${title}" "${err_title}"

    echo -n "<tr>"
    echo -n "<td>Message</td>"
    echo -n "<td>"

    gen-message-item "${err_text1}"
    test -z "${err_text2}" || gen-message-item "${err_text2}"
    test -z "${err_text3}" || gen-message-item "${err_text3}"

    gen-message-item "The request for this URL could not be served at this moment"

    echo -n "</td>"
    echo -n "</tr>"

    gen-message-bottom
}

gen-squid-directory-listing()
{
    local title="Directory Content"
    local parent_dir=""

    echo -n "<!DOCTYPE html>"
    echo -n "<html>"
    echo -n "<head>"
    echo -n "<title>Directory Content</title>"
    echo -n "<style type='text/css'>"
    echo -n "${STYLES_CSS}"
    echo -n "</style>"
    echo -n "</head>"

    echo -n "<body>"
    echo -n "<div id='wrap'><div id='content'>"    
    echo -n "<table>"
    echo -n "<tr>"
    echo -n "<td>Directory Content</td>"
    echo -n "</tr>"
    echo -n "</table>"

    echo -n "<table class='directory'>"
    echo -n "<tr><td></td><td>Name</td><td>Last Modified</td><td width='60'>Size</td><td></td></tr>"
    echo -n "<tr><td><a href='/'><img border='0' src='/squid-internal-static/icons/silk/arrow_up.png' alt='' /><img border='0' src='/squid-internal-static/icons/silk/arrow_up.png' alt='/' /></a></td><td><a href='/'>Root Directory</a></td><td></td><td></td><td></td></tr>"
    echo -n "<tr><td><a href='../'><img border='0' src='/squid-internal-static/icons/silk/arrow_up.png' alt='..' /></a></td><td><a href='../'>Parent Directory</a></td><td></td><td></td><td></td></tr>"
    echo -n "%g"
    echo -n "</table>"

    echo -n "</div></div>"
    echo -n "</body>"
    echo -n "</html>"
}

gen-squid-html-errors()
{
    local err_file err_code err_title err_text1 err_text2 err_text3
    local base_name html_file i=0 j

    for err_file in ${SQUID_ERR_TEXT_DIR}/*.txt
    do
	j=0
	unset err_title err_text1 err_text2 err_text3

	err_code=$[1000 + ${i}]
	while read line
	do
	    case ${j} in
		0)
		    err_title=${line}
		    ;;
		1)
		    err_text1=${line}
		    ;;
		2)
		    err_text2=${line}
		    ;;
		3)
		    err_text3=${line}
		    ;;
		*)
		    ;;
	    esac
	    ((j++))
	done < ${err_file}

	if test "${err_text2}" == "${err_text1}" ; then err_text2="" ; fi
	if test "${err_text3}" == "${err_text2}" -o "${err_text3}" == "${err_text1}"; then err_text3="" ; fi
	
	base_name=$(basename ${err_file} .txt)
	html_file="${SQUID_ERR_GENERATED_DIR}/${base_name}.html"

	gen-squid-html-error "${base_name:0:4}" "${err_code}" "${err_title}" "${err_text1}" "${err_text2}" "${err_text3}" > ${html_file}
	((i++))
    done
}

gen-virus-scan-message()
{
    test -n "${1}" || return 1
    local virus_scan_msg_file=${1}

    local message=$(cat ${virus_scan_msg_file})

    gen-message-top "Malware detected" "This content has been blocked"

    echo -n "<tr><td>Message</td><td>${message}</td></tr>"
    echo -n "<tr><td>Requested URL</td><td>%huo</td></tr>"
    echo -n "<tr><td>Malware name</td><td>%VVN</td></tr>"
    echo -n "<tr><td>Source IP</td><td>%>a</td></tr>"
    echo -n "<tr><td>User</td><td>%{X-Authenticated-User}>ih</td></tr>"

    gen-message-bottom
}

gen-virus-scan-messages()
{
    local msg_file

    for msg_file in ${VIRUS_SCAN_TEXT_DIR}/*.txt
    do
	base_name=$(basename ${msg_file} .txt)
	gen-virus-scan-message ${msg_file} > ${VIRUS_SCAN_MSG_GENERATED_DIR}/${base_name}.html
    done
}

gen-httpd-html-errors()
{
    local err_file err_code err_title err_text1 err_text2 err_text3
    local base_name html_file i

    for err_file in ${HTTPD_ERR_TEXT_DIR}/*.txt
    do
	i=0
	unset err_code err_title err_text1 err_text2 err_text3

	while read line
	do
	    case ${i} in
		0)
		    err_code=${line}
		    ;;
		1)
		    err_title=${line}
		    ;;
		2)
		    err_text1=${line}
		    ;;
		3)
		    err_text2=${line}
		    ;;
		4)
		    err_text3=${line}
		    ;;
		*)
		    ;;
	    esac
	    ((i++))
	done < ${err_file}

	if test "${err_text2}" == "${err_text1}" ; then unset err_text2 ; fi
	if test "${err_text3}" == "${err_text2}" -o "${err_text3}" == "${err_text1}"; then unset err_text3 ; fi

	base_name=$(basename ${err_file} .txt)
	html_file="${APACHE_ERR_GENERATED_DIR}/${base_name}.html"
	
	gen-httpd-html-error "${err_code}" "${err_title}" "${err_text1}" "${err_text2}" "${err_text3}" > ${html_file}
    done
}

gen-logrotate-common-conf()
{
    cat logrotate-common.conf-1

    echo "olddir ${LOG_DIR}"
}

gen-sysconfig-tmpfs()
{
    local dirs="root:root@c-icap root:root@slapd root:root@smartd root:root@var/bootlog ${AV_USER}:${AV_GROUP}@clamav"

    echo "TMPFS_SUBDIRS=\"${dirs}\""
}

gen-sysconfig-clamav()
{
    cat sysconfig.freshclam-1

    echo "AV_USER=${AV_USER}"
    echo "AV_GROUP=${AV_GROUP}"
    echo "AV_DB_DIR=${AV_DB_DIR}"
}

gen-sysconfig-named()
{
    echo "ROOT_DIR=${NAMED_DIR}"
    echo "OPTIONS=\"-t ${NAMED_DIR} -c /etc/named.conf -4 -u named\""
}

gen-acpi-events-halt()
{
    echo "event=button[ /]power"
    echo "action=${LOCAL_DIR}/sbin/apl_halt"
}

gen-anacrontab()
{
    cat anacrontab-1
    echo
    echo "SHELL=${SHELL}"
    echo "PATH=${PATH}"
    echo
    cat anacrontab-3
}

gen-os-name()
{
    echo "${OS_NAME}"
}

gen-os-version()
{
    echo "${OS_VERSION}"
}

gen-admin-man_db-conf()
{
    echo "MANDATORY_MANPATH ${APPLIANCE_DIR}/man"
    echo "MANPATH_MAP ${APPLIANCE_DIR}/bin ${APPLIANCE_DIR}/man"
    echo "SECTION 1"
    echo "DEFINE tr /usr/bin/tr '\255\267\264\327' '\055\157\047\170'"
}

gen-webserver-rules()
{
    local email_len=$[3 * 64]

    cat webserver.rules-1
    echo
    echo "SecRule REQUEST_METHOD \"^GET$\" id:400,log,auditlog,severity:6,allow,chain"
    echo "SecRule REQUEST_URI \"^/${AV_DENIED_URI//\./\\.}\?url=.{0,2048}\&source=[[:print:]]{0,255}\&user=[[:print:]]{0,255}\&virus=[[:print:]]{0,255}$\""
    echo
    echo "SecRule REQUEST_METHOD \"^GET$\" id:402,log,auditlog,severity:6,allow,chain"
    echo "SecRule REQUEST_URI \"^/${URL_DENIED_BASE_URI//\./\\.}\?email=[[:print:]]{3,${email_len}}\&url=.{0,2048}\&bl=[[:print:]]{1,32}\&ip=[[:print:]]{1,15}\&user=[[:print:]]{0,255}\&dummy=[[:print:]]{0,255}$\""
    echo
    echo "SecRule REQUEST_METHOD \"^GET$\" id:404,log,auditlog,severity:6,allow,chain"
    echo "SecRule REQUEST_URI \"^/${ACCESS_WARNING_URI//\./\\.}\?email=[[:print:]]{3,${email_len}}$\""
    echo
    echo "SecRule REQUEST_METHOD \"^GET$\" id:406,log,auditlog,severity:6,allow,chain"
    echo "SecRule REQUEST_URI \"^/${WEB_GATEWAY_URI//\./\\.}\?email=[[:print:]]{3,${email_len}}$\""
    echo
    echo "SecRule REQUEST_METHOD \"^GET$\" id:408,log,auditlog,severity:6,allow,chain"
    echo "SecRule REQUEST_URI \"^/${CA_DIR_NAME}/ca\.(der|crt)(\.sha1)?$\""
    echo
    echo "SecAction id:416,status:403,severity:2,deny"
}

gen-timezones()
{
    local init_dir=${PWD}
    cd ${APL}/usr/share/zoneinfo

    local africa=$(find Africa -type f 2> /dev/null | sort)
    local america=$(find America -type f 2> /dev/null | sort)
    local antarctica=$(find Antarctica -type f 2> /dev/null | sort)
    local asia=$(find Asia -type f 2> /dev/null | sort)
    local atlantic=$(find Atlantic -type f 2> /dev/null | sort)
    local australia=$(find Australia -type f 2> /dev/null | sort)
    local europe=$(find Europe -type f 2> /dev/null | sort)
    local pacific=$(find Pacific -type f 2> /dev/null | sort)

    local timezone

    for timezone in ${africa} ${america} ${antarctica} ${asia} ${atlantic} ${australia} ${europe} ${pacific}
    do
	echo ${timezone}
    done

    cd ${init_dir}
}

gen-keyboards()
{
    local init_dir=${PWD}

    cd ${APL}/usr/share/keymaps/i386
    local files=$(find . -type f 2> /dev/null | sort)
    local keyboard

    for keyboard in ${files}
    do
	keyboard=${keyboard:2}
	! [[ "${keyboard}" =~ ^.*include/.* ]] || continue
	keyboard=${keyboard/\.map\.gz}
	echo ${keyboard}
    done

    cd ${init_dir}
}

gen-ipsec-conf()
{
    cat IPsec/ipsec.conf

    echo "include ${IPSEC_CONNECTION_DIR_NAME}/*.conf"
}

gen-ipsec-load-tester-conf()
{
    sed \
	-e "s@ca_dir =.*@ca_dir = ${IPSEC_SSL_CA_DIR}@" \
	-e "s@initiator_id =.*@initiator_id = ${TECHNICAL_NAME}-initiator@" \
	-e "s@initiator_match =.*@initiator_match = ${TECHNICAL_NAME}-responder@" \
	-e "s@issuer_cert =.*@issuer_cert = ${IPSEC_SSL_CA_DIR}/${SYSTEM_CA}.certificate@" \
	-e "s@issuer_key =.*@issuer_key = ${IPSEC_SSL_CA_DIR}/${SYSTEM_CA}.key@" \
	-e "s@responder_id =.*@responder_id = ${TECHNICAL_NAME}-responder@" \
	\
	IPsec/ipsec.load-tester.conf
}

gen-ssh_config-common()
{
    cat ssh_config-1
    echo
    echo "User ${ADMIN_NAME}"
}

gen-ssh_config-admin()
{
    gen-ssh_config-common
    echo "RequestTTY no"
}

gen-ssh_config-apl()
{
    gen-ssh_config-common
    echo "RequestTTY yes"
}

gen-waagent_conf()
{
    cat waagent.conf-1
    echo
    echo "Lib.Dir=${LOCAL_DIR}/cloud"
}

gen-conf-files()
{
    gen-logrotate-common-conf > ${GENERATED_DIR}/logrotate-common.conf
    gen-sysconfig-tmpfs  > ${GENERATED_DIR}/sysconfig.tmpfs
    gen-sysconfig-clamav > ${GENERATED_DIR}/sysconfig.freshclam
    gen-sysconfig-clamav > ${GENERATED_DIR}/sysconfig.clamd
    gen-sysconfig-named  > ${GENERATED_DIR}/sysconfig.named
    gen-acpi-events-halt > ${GENERATED_DIR}/acpi.events.halt
    gen-anacrontab > ${GENERATED_DIR}/anacrontab
    gen-os-name > ${GENERATED_DIR}/os-name
    gen-os-version > ${GENERATED_DIR}/os-version
    gen-admin-man_db-conf > ${GENERATED_DIR}/admin.man_db.conf
    gen-webserver-rules > ${GENERATED_DIR}/webserver.rules
    gen-timezones > ${GENERATED_DIR}/timezones
    gen-keyboards > ${GENERATED_DIR}/keyboards
    gen-ipsec-conf > ${GENERATED_DIR}/ipsec.conf
    gen-ipsec-load-tester-conf > ${GENERATED_DIR}/ipsec.load-tester.conf
    gen-ssh_config-admin > ${GENERATED_DIR}/admin.ssh_config
    gen-ssh_config-apl > ${GENERATED_DIR}/apl.ssh_config
    gen-waagent_conf > ${GENERATED_DIR}/waagent.conf
}

gen-message()
{
    local file=${1}
    local hex=$(hexdump -ve '1/1 " %x"' ${file})
    local len=${#hex} ; len=$[${len} - 2]
    hex=${hex:0:${len}}
    hex=${hex// /\\x}
    echo -n "${hex}"
}

install-html-squid-errors()
{
    local file installed_name

    for file in ${SQUID_ERR_GENERATED_DIR}/*.html
    do
	installed_name=$(basename ${file} .html)
	sudo install -m 444 -o root -g root ${file} ${APL}${PROXY_DIR}/share/errors/${installed_name}
    done

    sudo install -m 444 -o root -g root ${LFS}${PROXY_DIR}/share/errors/templates/error-details.txt ${APL}${PROXY_DIR}/share/errors/error-details.txt
}

install-html-httpd-errors()
{
    local file installed_name
    
    for file in ${APACHE_ERR_GENERATED_DIR}/*.html
    do
	installed_name=$(basename ${file})
	sudo install -m 444 -o root -g root ${file} ${APL}${WEB_ERR_DIR}/${installed_name}
	sudo install -m 444 -o root -g root ${file} ${APL}${GUI_ERR_DIR}/${installed_name}
    done

    sudo install -m 444 -o root -g root standby.html ${APL}${WEB_SERVER_DIR}/${STANDBY_NAME}/standby.html
}

install-virus-scan-messages()
{
    local template_file installed_name

    for template_file in ${VIRUS_SCAN_MSG_GENERATED_DIR}/*.html
    do
	installed_name=$(basename ${template_file} .html)
	sudo install -m 644 -o root -g root ${template_file} ${APL}${LOCAL_DIR}/share/c_icap/templates/virus_scan/en/${installed_name}
    done
}

verify-mib-syntax()
{
    local errors=$(smilint -l 6 ${MAIN_MIB_NAME})
    if test -n "${errors}" ; then
	echo ${errors}
	return 1
    fi

    return 0
}

install-all-etc()
{
    local password_file

    sudo install -m 400 -o ${NAMED_UID} -g ${NAMED_GID} 0.0.127.in-addr.arpa ${APL}${NAMED_DIR}/zone
    sudo install -m 400 -o ${NAMED_UID} -g ${NAMED_GID} localhost ${APL}${NAMED_DIR}/zone
    sudo install -m 644 -o ${NAMED_UID} -g ${NAMED_GID} ${GENERATED_DIR}/sysconfig.named ${APL}/etc/sysconfig/named

    sudo install -m 400 -o root -g root ${GENERATED_DIR}/logrotate-common.conf ${APL}/etc/logrotate-common.conf
    sudo install -m 644 -o root -g root ${GENERATED_DIR}/sysconfig.tmpfs ${APL}/etc/sysconfig/tmpfs
    sudo install -m 644 -o root -g root ${GENERATED_DIR}/sysconfig.freshclam ${APL}/etc/sysconfig/freshclam
    sudo install -m 644 -o root -g root ${GENERATED_DIR}/sysconfig.clamd ${APL}/etc/sysconfig/clamd
    sudo install -m 600 -o root -g root ${GENERATED_DIR}/acpi.events.halt ${APL}/etc/acpi/events/halt
    sudo install -m 400 -o root -g root ${GENERATED_DIR}/anacrontab ${APL}/etc/anacrontab
    sudo install -m 644 -o root -g root ${GENERATED_DIR}/os-name ${APL}${HARD_DIR}/os-name
    sudo install -m 644 -o root -g root ${GENERATED_DIR}/admin.man_db.conf ${APL}${ETC_DIR}/man_db.conf
    sudo install -m 444 -o root -g root ${GENERATED_DIR}/timezones ${APL}${ETC_DIR}/timezones
    sudo install -m 444 -o root -g root ${GENERATED_DIR}/keyboards ${APL}${ETC_DIR}/keyboards
    sudo install -m 644 -o root -g root ${GENERATED_DIR}/webserver.rules ${APL}${WEB_ETC_DIR}/webserver.rules

    sudo install -m 644 -o root -g root ${GENERATED_DIR}/os-version ${APL}${HARD_DIR}/os-version
    sudo install -m 644 -o root -g root ${GENERATED_DIR}/os-version ${APL}${HARD_DIR}/.install.os-version
    sudo install -m 644 -o root -g root cloud.conf ${APL}${HARD_DIR}/cloud.conf

    sudo install -m 644 -o root -g root 90-usb-notify.rules ${APL}/etc/udev/rules.d/
    sudo install -m 600 -o root -g root GPL.txt ${APL}/etc/GPL.txt

    sudo install -m 644 -o root -g root raid0.conf ${APL}/etc/modprobe.d/raid0.conf
    sudo install -m 644 -o root -g root lvm.conf ${APL}/etc/lvm/lvm.conf
    sudo install -m 400 -o root -g root sysconfig.sshd ${APL}/etc/sysconfig/sshd
    sudo install -m 644 -o root -g root sysconfig.smartd ${APL}/etc/sysconfig/smartd
    sudo install -m 644 -o root -g root sysconfig.mdadm ${APL}/etc/sysconfig/mdadm

    sudo install -m 400 -o root -g root cron.allow ${APL}/etc/cron.allow
    sudo install -m 500 -o root -g root cron/statistics-hourly.cron ${APL}/etc/cron.hourly/statistics.cron
    sudo install -m 500 -o root -g root cron/xlogrotate-hourly.cron ${APL}/etc/cron.hourly/xlogrotate.cron
    sudo install -m 500 -o root -g root cron/xlogrotate-daily.cron ${APL}/etc/cron.daily/xlogrotate.cron
    sudo install -m 500 -o root -g root cron/urllist-update-daily.cron ${APL}/etc/cron.daily/urllistupdate.cron
    sudo install -m 500 -o root -g root cron/urllist-update-weekly.cron ${APL}/etc/cron.weekly/urllistupdate.cron
    sudo install -m 500 -o root -g root cron/alive-check.cron ${APL}/etc/cron.weekly/alivecheck.cron
    sudo install -m 500 -o root -g root cron/cloud-update-ip.cron ${APL}/etc/cron.weekly/cloudupdateip.cron
    sudo install -m 500 -o root -g root cron/tmpwatch.cron ${APL}/etc/cron.weekly/tmpwatch.cron
    sudo install -m 500 -o root -g root cron/sanity.cron ${APL}/etc/cron.weekly/sanity.cron

    sudo ln -sf ${LOCAL_DIR}/bin/apl_verify_usage ${APL}/etc/cron.daily/verifyusage.cron
    
    sudo install -m 644 -o root -g root login.defs ${APL}/etc/login.defs
    sudo install -m 644 -o root -g root login.defs ${APL}${ETC_DIR}/login.defs
    sudo install -m 600 -o root -g root securetty ${APL}/etc/securetty
    sudo install -m 600 -o root -g root license-public-key.pem ${APL}/etc/license-public-key.pem
    sudo install -m 600 -o root -g root register-public-key.pem ${APL}/etc/register-public-key.pem
    sudo install -m 600 -o root -g root patch-public-key.pem ${APL}/etc/patch-public-key.pem
    sudo install -m 600 -o root -g root guard-public-key.pem ${APL}/etc/guard-public-key.pem
    sudo install -m 600 -o root -g root appliance-public-key.pem ${APL}/etc/appliance-public-key.pem
    sudo install -m 644 -o root -g root admin.etc.shells ${APL}${ETC_DIR}/shells
    sudo install -m 644 -o root -g root admin.more.help ${APL}${MISC_DIR}/more.help
    sudo install -m 444 -o root -g root countries ${APL}${ADMIN_DIR}${APPLIANCE_DIR}/etc/countries
    sudo install -m 400 -o root -g root boot.banner ${APL}/boot/grub/banner
    sudo install -m 644 -o root -g root styles.css ${APL}${WEB_WWW_DIR}/styles.css
    sudo install -m 644 -o root -g root favicon.ico ${APL}${WEB_WWW_DIR}/favicon.ico
    sudo install -m 644 -o root -g root backup-files ${APL}${LOCAL_DIR}/${TECHNICAL_NAME}/etc/backup-files
    sudo install -m 644 -o root -g root ldap.conf ${APL}${ADMIN_DIR}${LDAP_DIR}/ldap.conf

    sudo install -d -m 755 -o root -g root ${APL}${GUI_MIB_DIR}
    sudo install -m 644 -o root -g root ${MAIN_MIB_NAME} ${APL}${GUI_MIB_DIR}/${MAIN_MIB_NAME}
    sudo install -m 644 -o root -g root ${MAIN_MIB_NAME} ${APL}/usr/share/snmp/mibs/${MAIN_MIB_NAME}

    for password_file in ${BACKUP_PASSWD} \
			 ${APPLIANCE_PASSWD} \
			 ${IPSEC_PASSWD} \
			 ${FILE_PASSWD} \
			 ${KERBEROS_SHARED_PASSWD} \
			 ${LDAP_PASSWD} \
			 ${EMAIL_PASSWD} \
			 ${SNMP_PASSWD} \
			 ${WAF_REPUTATION_RBL_PASSWD} \
			 ${DYNDNS_PASSWD}
    do
	test -s Passwords/${password_file} || head -c 12 /dev/urandom | base64 > Passwords/${password_file}
    done
			     
    sudo install -m 400 -o root -g root Passwords/${BACKUP_PASSWD} ${APL}${PRIVATE_DIR}/.${BACKUP_PASSWD}
    sudo install -m 400 -o root -g root Passwords/${IPSEC_PASSWD} ${APL}${PRIVATE_DIR}/.${IPSEC_PASSWD}

    sudo install -m 440 -o ${ADMIN_UID} -g ${USERS_GID} Passwords/${IPSEC_PASSWD} ${APL}${ADMIN_DIR}${PRIVATE_DIR}/.${IPSEC_PASSWD}

    for password_file in ${APPLIANCE_PASSWD} \
			 ${FILE_PASSWD} \
			 ${KERBEROS_SHARED_PASSWD} \
			 ${LDAP_PASSWD} \
			 ${EMAIL_PASSWD} \
			 ${SNMP_PASSWD} \
			 ${WAF_REPUTATION_RBL_PASSWD} \
			 ${DYNDNS_PASSWD}
    do
	sudo install -m 400 -o ${ADMIN_UID} -g ${USERS_GID} Passwords/${password_file} ${APL}${ADMIN_DIR}${PRIVATE_DIR}/.${password_file}
    done
}

install-local-mib()
{
    install -d -m 755 ${HOME}/.snmp/mibs
    install -m 644 ${MAIN_MIB_NAME} ${HOME}/.snmp/mibs/${MAIN_MIB_NAME}
}

install-messages()
{
    local file nb

    for file in MessageApl/apl-message-*
    do
	nb=${file/MessageApl\/*-/}
	gen-message ${file} > ${GENERATED_DIR}/apl-message-${nb}
	sudo install -m 400 -o root -g root ${GENERATED_DIR}/apl-message-${nb} ${APL}${LOCAL_DIR}/${TECHNICAL_NAME}/etc/.file${nb}
    done

    for file in MessageWeb/web-warning-message-*
    do
	nb=${file/MessageWeb\/*-/}
	sudo install -m 444 -o root -g root ${file} ${APL}${WEB_MESSAGE_DIR}/.file${nb}
    done

    for file in MessageAdmin/admin-message-*
    do
	nb=${file/MessageAdmin\/*-/}
	gen-message ${file} > ${GENERATED_DIR}/admin-message-${nb}
	sudo install -m 444 -o root -g root ${GENERATED_DIR}/admin-message-${nb} ${APL}${ADMIN_DIR}${APPLIANCE_DIR}/etc/.file${nb}
    done
}

install-ipsec-files()
{
    local file base

    sudo install -m 400 -o root -g root IPsec/strongswan.conf ${APL}${LOCAL_DIR}/etc/strongswan.conf

    for file in IPsec/strongswan.d/*.conf
    do
	base=$(file-basename ${file})
	sudo install -m 400 -o root -g root ${file} ${APL}${LOCAL_DIR}/etc/strongswan.d/${base}
    done

    for file in IPsec/strongswan.d/charon/*.conf
    do
	base=$(file-basename ${file})
	sudo install -m 400 -o root -g root ${file} ${APL}${LOCAL_DIR}/etc/strongswan.d/charon/${base}
    done

    sudo install -m 400 -o root -g root ${GENERATED_DIR}/ipsec.conf ${APL}${LOCAL_DIR}/etc/ipsec.conf
    sudo install -m 400 -o root -g root ${GENERATED_DIR}/ipsec.load-tester.conf ${APL}${LOCAL_DIR}/etc/strongswan.d/charon/load-tester.conf

    sudo install -m 644 -o root -g root ${GENERATED_DIR}/apl.ssh_config ${APL}/usr/etc/ssh_config
    sudo install -m 644 -o root -g root ${GENERATED_DIR}/admin.ssh_config ${APL}${ADMIN_DIR}/usr/etc/ssh_config
}

install-azure-files()
{
    sudo install -m 644 -o root -g root ${GENERATED_DIR}/waagent.conf ${APL}/etc/waagent.conf
    sudo install -m 644 -o root -g root dhclient.conf ${APL}/etc/dhclient.conf
}

install-other-files()
{
    sudo install -m 444 -o root -g root av-extended-test.txt ${APL}${AV_EXTENDED_CACHE_DIR}/.av-test.txt
    sudo install -m 444 -o root -g root av-extended-test.txt ${APL}${ADMIN_DIR}${APPLIANCE_DIR}/etc/.av-test.txt
}

get-ca-bundle()
{
    local timeout=5
    local max_time=10
    local ca_bundle_url="https://curl.se/ca/cacert.pem"
    local ca_bundle_sha256_url="https://curl.se/ca/cacert.pem.sha256"

    curl \
	-qf \
	--no-show-error --stderr /dev/null \
	--connect-timeout ${timeout}  --max-time ${max_time} \
	--capath /etc/ssl/certs \
	--url ${ca_bundle_sha256_url} > ca-bundle.crt.sha256 || return 21

    curl \
	-qf \
	--no-show-error --stderr /dev/null \
	--connect-timeout ${timeout}  --max-time ${max_time} \
	--capath /etc/ssl/certs \
	--url ${ca_bundle_url} > ca-bundle.crt || return 23

    local sha256_1=$(sha256sum ca-bundle.crt 2> /dev/null)
    local sha256_2=$(cat ca-bundle.crt.sha256 2> /dev/null)

    sha256_1=${sha256_1/ *}
    sha256_2=${sha256_2/ *}

    test "${sha256_1}" == "${sha256_2}" || return 25
}

get-geo-country()
{
    local timeout=5
    local max_time=15

    curl \
	-qf \
	--no-show-error --stderr /dev/null \
	--connect-timeout ${timeout}  --max-time ${max_time} \
	--capath /etc/ssl/certs \
	--url ${GEO_LITE_COUNTRY_URL}.sha256 > GeoLiteCountry.dat.sha256 || return 31

    curl \
	-qf \
	--no-show-error --stderr /dev/null \
	--connect-timeout ${timeout}  --max-time ${max_time} \
	--capath /etc/ssl/certs \
	--url ${GEO_LITE_COUNTRY_URL} > GeoLiteCountry.dat || return 33

    local sha256_1=$(sha256sum GeoLiteCountry.dat 2> /dev/null)
    local sha256_2=$(cat GeoLiteCountry.dat.sha256 2> /dev/null)

    sha256_1=${sha256_1/ *}
    sha256_2=${sha256_2/ *}

    test "${sha256_1}" == "${sha256_2}" || return 35
}

get-remote-files()
{
    local mode=${1}

    test "${mode}" == prod -a ${SYS_ARCHITECTURE} == x86_64 || return 0

    local ip

    ip=$(getent hosts ${NETWORK_WEBSITE} 2> /dev/null)

    test ${?} -eq 0 || return 11
    ip=${ip/ *}
    test -n "${ip}" || return 13
    test ${ip:0:11} != ${TEST_IP_EXTERNAL_IP:0:11} || return 15

    unset https_proxy
    unset HTTPS_PROXY

    get-ca-bundle || return ${?}
    get-geo-country || return ${?}
}

install-ca-bundle()
{
    sudo install -m 444 -o root -g root ca-bundle.crt ${APL}/etc/ca-bundle.crt
    sudo install -m 444 -o root -g root ca-bundle.crt ${APL}${SSL_VAR_DIR}/ca-bundle.crt
    sudo install -m 444 -o root -g root ca-bundle.crt ${APL}${PROXY_SSL_CA_DIR}/ca-bundle.crt
    sudo install -m 444 -o root -g root ca-bundle.crt ${APL}${WEB_SSL_CA_DIR}/ca-bundle+system.crt
}

install-geo-country()
{
    sudo install -m 444 -o root -g root GeoLiteCountry.dat ${APL}${WEB_SERVER_DIR}/share/GeoLiteCountry.dat
}

initialise-pki()
{
    sudo touch ${APL}${SSL_CTL_DIR}/index.txt

    echo 1001 > /tmp/serial.${$}
    sudo install -m 644 -o root -g root /tmp/serial.${$} ${APL}${SSL_CTL_DIR}/serial

    echo "unique_subject = no" > /tmp/index.txt.attr.${$}
    sudo install -m 644 -o root -g root /tmp/index.txt.attr.${$} ${APL}${SSL_CTL_DIR}/index.txt.attr
    rm -f /tmp/{serial.${$},index.txt.attr.${$}}
}

initialise-cloudip()
{
    sudo touch ${APL}${CLOUD_NETWORK_IP_FILE}
}

error()
{
    echo "*** Error ${1}"
    exit ${1}
}

main()
{
    get-remote-files "${@}" || error ${?}

    gen-squid-directory-listing > ${SQUID_ERR_GENERATED_DIR}/ERR_DIR_LISTING.html

    gen-squid-html-errors
    gen-httpd-html-errors
    gen-virus-scan-messages
    gen-conf-files

    install-html-squid-errors
    install-html-httpd-errors
    install-virus-scan-messages

    verify-mib-syntax
    install-all-etc
    install-local-mib
    install-messages
    install-ipsec-files
    install-azure-files
    install-other-files
    install-ca-bundle
    install-geo-country
    initialise-pki
    initialise-cloudip
}

# Main()

SQUID_ERR_TEXT_DIR=SquidErrors
HTTPD_ERR_TEXT_DIR=ApacheErrors
VIRUS_SCAN_TEXT_DIR=VirusScanMessages
STYLES_CSS=$(remove-newline styles.css)

mkdir -p ${FULL_GENERATED_DIR}
ln -sf ${FULL_GENERATED_DIR}

mkdir -p ${BASE_GENERATED_DIR}/${SQUID_ERR_GENERATED_DIR}
ln -sf ${BASE_GENERATED_DIR}/${SQUID_ERR_GENERATED_DIR}

mkdir -p ${BASE_GENERATED_DIR}/${APACHE_ERR_GENERATED_DIR}
ln -sf ${BASE_GENERATED_DIR}/${APACHE_ERR_GENERATED_DIR}

mkdir -p ${BASE_GENERATED_DIR}/${VIRUS_SCAN_MSG_GENERATED_DIR}
ln -sf ${BASE_GENERATED_DIR}/${VIRUS_SCAN_MSG_GENERATED_DIR}

main "${@}"
