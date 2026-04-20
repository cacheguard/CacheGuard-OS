#!/bin/bash

test -n "${LFS}" || exit 1
test -n "${APL}" || exit 2
test -d "${LFS}" || exit 3
test -d "${APL}" || exit 4

source CacheGuard.env
source WorkFunctions

sha1sum-file()
{
    test -n "${1}" || return 1
    local file=${1}

    local sha1=$(sudo openssl dgst -sha1 -c ${file} 2>/dev/null)
    sha1=${sha1/SHA1(}
    sha1=${sha1/)=}
    echo ${sha1}
}

not-excluded()
{
    test -n "${1}" || return 1
    local file=${1}

    local len_rproxy_guard_dir=${#PROXY_GUARD_DIR}
    ((len_rproxy_guard_dir--))

    local parted_file_prefix="etc/${PARTED_BASE_FILE}."
    local len_parted_file_prefix=${#parted_file_prefix}

    local admin_etc_prefix="${ETC_DIR:1}/${TECHNICAL_NAME}/"
    local len_admin_etc_prefix=${#admin_etc_prefix}

    test ${file} != etc/crontab || return 1
    test ${file} != etc/cron.daily/cachereconfigure.cron || return 1
    test ${file} != etc/cron.daily/kerberos.cron || return 1
    test ${file} != etc/cron.montly/dataupdate.cron || return 1
    test ${file} != etc/cron.d/${AV_EXTENDED_CRON_FILENAME} || return 1
    test ${file} != etc/fs-info || return 1
    test ${file} != etc/fstab || return 1
    test ${file} != boot/grub/grub.cfg || return 1
    test ${file} != etc/hosts || return 1
    test ${file} != etc/inittab || return 1
    test ${file} != etc/issue || return 1
    test ${file} != etc/localtime || return 1
    test ${file} != etc/logrotate-daily.conf || return 1
    test ${file} != etc/logrotate-hourly.conf || return 1
    test ${file} != etc/logrotate-daily.d/gateway || return 1
    test ${file} != etc/logrotate-daily.d/system || return 1
    test ${file} != etc/logrotate-hourly.d/gateway || return 1
    test ${file} != etc/logrotate-hourly.d/system || return 1
    test ${file} != etc/login.access || return 1
    test ${file} != etc/mtab || return 1
    test ${file} != etc/modprobe.d/bonding.conf || return 1
    test ${file} != etc/ntp.conf || return 1
    test ${file} != etc/ntp/drift || return 1
    test ${file} != etc/passwd || return 1
    test ${file} != etc/passwd- || return 1
    test ${file} != etc/resolv.conf || return 1
    test ${file} != etc/shadow || return 1
    test ${file} != etc/shadow- || return 1
    test ${file} != etc/sudoers || return 1
    test ${file} != etc/sysconfig/console || return 1
    test ${file} != etc/sysconfig/htcacheclean || return 1
    test ${file} != etc/sysconfig/modules || return 1
    test ${file} != etc/sysconfig/modules-network || return 1
    test ${file} != etc/sysconfig/qos.index || return 1
    test ${file} != etc/sysconfig/squid || return 1
    test ${file} != etc/udev/rules.d/70-persistent-net.rules || return 1

    test ${file} != ${ETC_DIR:1}/at.allow || return 1
    test ${file} != ${ETC_DIR:1}/hosts || return 1
    test ${file} != ${ETC_DIR:1}/localtime || return 1
    test ${file} != ${ETC_DIR:1}/passwd || return 1
    test ${file} != ${ETC_DIR:1}/passwd- || return 1
    test ${file} != ${ETC_DIR:1}/resolv.conf || return 1
    test ${file} != ${ETC_DIR:1}/serial || return 1
    test ${file} != ${ETC_DIR:1}/shadow || return 1
    test ${file} != ${ETC_DIR:1}/shadow- || return 1
    test ${file} != ${ETC_DIR:1}/sudoers || return 1

    test ${file} != ${ADMIN_DIR:1}${APPLIANCE_DIR}/etc/role || return 1
    test ${file} != ${ADMIN_DIR:1}${GUI_DIR}/etc/${WADMIND_NAME}.conf || return 1
    test ${file} != ${ADMIN_DIR:1}${GUI_DIR}/etc/${WADMIN_NAME}.rules || return 1

    test ${file} != ${APPLY_LOG:1} || return 1
    test ${file} != ${AV_CREATE_LOG:1} || return 1
    test ${file} != ${AV_UPDATE_LOG:1} || return 1
    test ${file} != ${BACKUP_LOG:1} || return 1
    test ${file} != ${CACHE_CLEAR_LOG:1} || return 1
    test ${file} != ${URLLIST_AUTO_LOG:1} || return 1
    test ${file} != ${LOG_ROTATE_LOG:1} || return 1
    test ${file} != ${WAUTH_LOG:1} || return 1
    test ${file} != ${WEB_WWW_DIR:1}/ha.pac || return 1

    test ${file} != ${PROXY_DIR:1}/etc/hosts || return 1
    test ${file} != ${PROXY_DIR:1}/etc/hosts.squid || return 1
    test ${file} != ${PROXY_DIR:1}/etc/httpd.conf || return 1
    test ${file} != ${PROXY_DIR:1}/etc/krb5.conf || return 1
    test ${file} != ${PROXY_DIR:1}/etc/localtime || return 1
    test ${file} != ${PROXY_DIR:1}/etc/passwd || return 1
    test ${file} != ${PROXY_DIR:1}/etc/resolv.conf || return 1
    test ${file} != ${PROXY_DIR:1}/etc/squid.conf || return 1
    test ${file} != ${PROXY_DIR:1}/etc/squidGuard.conf || return 1
    test ${file} != ${PROXY_DIR:1}/etc/waudit.rules || return 1
    test ${file} != ${PROXY_DIR:1}/usr/etc/openldap/ldap.conf || return 1
    test ${file} != ${PROXY_SSL_CA_DIR:1}/${SYSTEM_CA}.key || return 1
    test ${file} != ${PROXY_SSL_CA_DIR:1}/${SYSTEM_CA}.certificate || return 1
    test ${file} != ${PROXY_DIR:1}/var/log/${PROXY_LOG} || return 1
    test ${file} != ${PROXY_DIR:1}/var/log/${PROXY_GUARD_LOG} || return 1

    test ${file} != ${WEB_WWW_DIR:1}/ca/ca.crt || return 1
    test ${file} != ${WEB_WWW_DIR:1}/ca/ca.crt.sha1 || return 1
    test ${file} != ${WEB_WWW_DIR:1}/ca/ca.der || return 1
    test ${file} != ${WEB_WWW_DIR:1}/ca/ca.der.sha1 || return 1
    test ${file} != ${PROXY_DOMAIN_LIST_DIR:1}/${SSLMEDIATE_EXCEPTIONS_FILENAME} || return 1
    test ${file} != ${PROXY_DOMAIN_LIST_DIR:1}/${AV_WHITELIST_DOMAIN_FILENAME} || return 1

    test ${file} != ${WEB_SERVER_DIR:1}/etc/hosts || return 1
    test ${file} != ${WEB_SERVER_DIR:1}/etc/krb5.conf || return 1
    test ${file} != ${WEB_SERVER_DIR:1}/etc/domainname || return 1
    test ${file} != ${WEB_SERVER_DIR:1}/etc/resolv.conf || return 1
    test ${file} != ${WEB_SERVER_DIR:1}/var/log/${ANTI_VIRUS_LOG} || return 1
    test ${file} != ${WEB_SERVER_DIR:1}/var/log/${ANTI_VIRUS_SERVER_LOG} || return 1
    test ${file} != ${WEB_SERVER_DIR:1}/var/log/${WAF_LOG} || return 1
    test ${file} != ${WEB_SERVER_DIR:1}/var/log/${WEB_LOG} || return 1
    test ${file} != ${WEB_SERVER_DIR:1}/var/log/${FIREWALL_LOG} || return 1
    test ${file} != ${WEB_SERVER_DIR:1}/var/log/${ACCESS_GUARD_LOG} || return 1
    test ${file} != ${WEB_SERVER_DIR:1}/var/log/${RWEB_LOG} || return 1
    test ${file} != ${WEB_SERVER_DIR:1}/var/log/${IPSEC_LOG} || return 1
    test ${file} != ${WEB_SERVER_DIR:1}${LOCAL_DIR}/etc/clamd.conf || return 1
    test ${file} != ${WEB_SSL_CA_DIR:1}/ca-bundle+system.crt || return 1
    test ${file} != ${WEB_SSL_CA_DIR:1}/${SYSTEM_CA_ID}.certificate || return 1
    test ${file} != ${WEB_DB_DIR:1}/${EMBEDDED_APPLICATIONS_NAME}/${EMBEDDED_VPNSUBSCR_NAME}.db || return 1

    test ${file:0:${len_rproxy_guard_dir}} != ${PROXY_GUARD_DIR:1} || return 1
    test ${file:0:${len_parted_file_prefix}} != ${parted_file_prefix} || return 1
    test ${file:0:${len_admin_etc_prefix}} != ${admin_etc_prefix} || return 1

    return 0
}

sha1sum-files()
{
    local elt dir files file
    local kernel_files

    case ${SYS_ARCHITECTURE} in
	i386|i686|x86)
	    kernel_files="
f:boot/kernel-${SYS_VERSION}-${SYS_HM_NAME}
f:boot/config-${SYS_VERSION}-${SYS_HM_NAME}
f:boot/System.map-${SYS_VERSION}-${SYS_HM_NAME}
" 	    
	    ;;
	x86_64)
	    kernel_files="
f:boot/kernel-${SYS_VERSION}-${SYS_64_NAME}
f:boot/config-${SYS_VERSION}-${SYS_64_NAME}
f:boot/System.map-${SYS_VERSION}-${SYS_64_NAME}
"
	    ;;
	*)
	    ;;
    esac

    local roots="
${kernel_files}
d:bin
d:boot/grub
d:etc
d:sbin
d:usr/bin
d:usr/lib
d:usr/libexec
d:usr/sbin
d:usr/share
f:var/cache/ldconfig/aux-cache
d:${APPLIANCE_DIR:1}
d:${ADMIN_DIR:1}/bin
d:${ADMIN_DIR:1}/lib
d:${ADMIN_DIR:1}/usr
d:${SAVE_DIR:1}
f:${CONF_DIR:1}/*-constant
d:${ETC_DIR:1}
d:${LDAP_DIR:1}/schema
d:${LOCAL_DIR:1}/bin
f:${LOCAL_DIR:1}/etc/c-icap.magic
f:${LOCAL_DIR:1}/etc/ipsec.conf
f:${LOCAL_DIR:1}/etc/strongswan.conf
d:${LOCAL_DIR:1}/etc/strongswan.d
d:${LOCAL_DIR:1}/lib
d:${LOCAL_DIR:1}/libexec
d:${LOCAL_DIR:1}/sbin
d:${LOCAL_DIR:1}/share
f:${NAMED_DIR:1}/etc/ld.so.cache
f:${NAMED_DIR:1}/zone/0.0.127.in-addr.arpa
f:${NAMED_DIR:1}/zone/localhost
d:${PROXY_DIR:1}
d:${WEB_SERVER_DIR:1}
f:${SSL_VAR_DIR:1}/ca-bundle.crt
"
    if test ${SYS_ARCHITECTURE} == x86_64 ; then
	roots="${roots} d:lib64"
	roots="${roots} f:usr/lib64/lib*"
    fi

    for elt in ${roots}
    do
	case ${elt:0:2} in
	    d:)
		dir=${elt:2}
		files=$(sudo find ${dir} -type f)
		;;
	    f:)
		files=${elt:2}
		files=$(ls -1 ${files} 2> /dev/null)
		;;
	    *)
		unset files
		;;
	esac

	for file in ${files}
	do
	    not-excluded ${file} || continue
	    sha1sum-file ${file}
	done
    done
}

find-links()
{
    local tmp_file=/tmp/links.${$}
    local c1 c2 c3 c4 c5 c6 c7 c8 c9

    local uml_64_module_dir="lib/modules/${SYS_VERSION}-${SYS_UML_64_NAME}"
    local uml_module_dir="lib/modules/${SYS_VERSION}-${SYS_UML_NAME}"
    local len_64=${#uml_64_module_dir}
    local len=${#uml_module_dir}

    sudo find . -type l -exec ls -l {} \; 2> /dev/null > ${tmp_file}

    while read c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11
    do
	test "${c9:2:${len_64}}" != ${uml_64_module_dir} || continue
	test "${c9:2:${len}}" != ${uml_module_dir} || continue

	test "${c9:2}" != etc/cron.daily/kerberos.cron || continue
	test "${c9:2}" != etc/cron.daily/cachereconfigure.cron || continue
	test "${c9:2}" != etc/cron.monthly/dataupdate.cron || continue

	echo ${c9:2} ${c11}
    done < ${tmp_file}

    rm -f ${tmp_file}
}

find-empty-directories()
{
    sudo find . -type d -empty -exec stat -c "%n %a %u %g" {} \; | \
	grep -Ev './usr/local/proxy/cache|./lost\+found' | \
	sed 's@^./@@'

    echo ${PROXY_SSL_LOCAL_CA_DIR:1} 755 0 0
    echo ${WEB_SSL_CA_DIR:1} 755 0 0
    echo ${SSL_LOCAL_CA_DIR:1} 755 0 0
    echo ${SNMP_SSL_CA_DIR:1} 755 0 0
    echo ${SNMP_SSL_CERTIFICATE_DIR:1} 755 0 0
    echo ${SNMP_SSL_KEY_DIR:1} 700 0 0
    echo ${CONF_DIR:1}/${IPSEC_CONNECTION_DIR_NAME} 755 0 0
}

fp-files()
{
    local mode=${1}

    test "${mode}" == prod || return 0

    sudo touch /tmp/file.sudo.${$}
    sudo rm -f /tmp/file.sudo.${$}

    local os_generation=${OS_GENERATION,,}
    local architecture_id

    test ${SYS_ARCHITECTURE} != x86_64 || architecture_id="-64"
    local base_file=${TECHNICAL_NAME}-${os_generation}${architecture_id}-${OS_VERSION}
    local sha1_file=${base_file}.sha1
    local link_file=${base_file}.link
    local dir_file=${base_file}.dir

    rm -f ${GENERATED_DIR}/${TECHNICAL_NAME}-*.sha1
    rm -f ${GENERATED_DIR}/${TECHNICAL_NAME}-*.link
    rm -f ${GENERATED_DIR}/${TECHNICAL_NAME}-*.dir

    local cur_dir=${PWD}
    local gen_dir=${cur_dir}/${GENERATED_DIR}

    cd ${APL}
    echo "+++ SHA1Sum Files..."
    sha1sum-files > ${gen_dir}/${sha1_file}

    echo "+++ Index Links..."
    find-links > ${gen_dir}/${link_file}

    echo "+++ Empty directories..."
    find-empty-directories > ${gen_dir}/${dir_file}

    cd ${cur_dir}

    mkdir -p ${FINGERPRINT_DIR_NAME}

    install -m 444 ${GENERATED_DIR}/${sha1_file} ${FINGERPRINT_DIR_NAME}/${sha1_file}
    install -m 444 ${GENERATED_DIR}/${link_file} ${FINGERPRINT_DIR_NAME}/${link_file}
    install -m 444 ${GENERATED_DIR}/${dir_file} ${FINGERPRINT_DIR_NAME}/${dir_file}

    sudo install -m 444 -o root -g root ${GENERATED_DIR}/${sha1_file} ${APL}${LOCAL_DIR}/etc/
}

local-install-apl()
{
    local os_generation=${OS_GENERATION,,}
    local architecture_id

    test ${SYS_ARCHITECTURE} != x86_64 || architecture_id="-64"
    local base_file=${TECHNICAL_NAME}-${os_generation}${architecture_id}-${OS_VERSION}
    local exec_file=${base_file}.exec

    rm -f ${GENERATED_DIR}/${TECHNICAL_NAME}-*.exec

    sudo install -m 755 -o root -g root local-install-apl.bash ${APL}/tmp/
    sudo chroot ${APL} /tmp/local-install-apl.bash

    cp -f ${APL}/tmp/executable.lst ${GENERATED_DIR}/${exec_file}
    sudo rm -f \
	 ${APL}/tmp/local-install-apl.bash \
	 ${APL}/tmp/executable.lst

    mkdir -p ${FINGERPRINT_DIR_NAME}

    install -m 444 ${GENERATED_DIR}/${exec_file} ${FINGERPRINT_DIR_NAME}/${exec_file}

    sudo install -m 444 -o root -g root ${GENERATED_DIR}/${exec_file} ${APL}${LOCAL_DIR}/etc/
}

archive-os()
{
    local name="${TECHNICAL_NAME}-os"
    local files="
bin
boot
dev
etc
lib
mnt
run
sbin
usr
var
"

    local len=${#files} ; len=$[${len}-2]
    files="${files:1:${len}}"
    test ${SYS_ARCHITECTURE} != x86_64 || files="${files} lib64 usr/lib64/lib*"

    local cur_dir=${PWD}
    local gen_dir=${cur_dir}/${GENERATED_DIR}
    cd ${APL}

    echo "+++ Packing the OS..."
    sudo tar \
	--numeric-owner \
	--same-owner \
	--exclude="${ABASE_DIR:1}/${WAF_RDIR}" \
	--exclude="${ABASE_DIR:1}/${URLLIST_RDIR}" \
	--exclude="${ABASE_DIR:1}/${MANAGER_TEMPLATE_RDIR}" \
	--exclude="${ABASE_DIR:1}/${MANAGER_GATEWAY_RDIR}" \
	--exclude="${ABASE_DIR:1}/${MANAGER_GATEWAY_INDEX}" \
	--exclude="${PROXY_CACHE_DIR:1}/*" \
	--exclude="${WEB_RCACHE_DIR:1}/*" \
	--exclude="${WEB_UPLOAD_DIR:1}/*" \
	--exclude="boot/*-uml-*" \
	--exclude="usr/lib/modules/*-uml-*" \
	--exclude="etc/udev/rules.d/70-persistent-net.rules" \
	-cf ${gen_dir}/${name}.tar \
	${files}

    sudo tar \
	--numeric-owner \
	--same-owner \
	--append \
	--no-recursion \
	-f ${gen_dir}/${name}.tar \
	proc root root/.bash_profile sys tmp

    cd ${cur_dir}
}

# Main()

mkdir -p ${FULL_GENERATED_DIR}
ln -sf ${FULL_GENERATED_DIR}

fp-files "${@}"
local-install-apl
archive-os
