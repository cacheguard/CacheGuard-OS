#!/bin/bash

test -n "${LFS}" || exit 1
test -d "${LFS}" || exit 2
test -n "${APL}" || exit 3
test -d "${APL}" || exit 4

source CacheGuard.env
source WorkFunctions
source common-functions

# Caution: Very Dangerous Function!
clean-rt()
{
    test -n "${APL}" || return 1

    cd ${APL}
    if test ${?} -ne 0 ; then echo "*** Fatal Error!" ; return 2 ; fi

    local base_dirs_2del="
bin
boot
dev
etc
home
lib
lib64
media
mnt
opt
proc
root
run
sbin
srv
sys
tmp
usr
var
"
    local len=${#base_dirs_2del} ; len=$[${len}-2]
    base_dirs_2del="${base_dirs_2del:1:${len}}"
    test ${SYS_ARCHITECTURE} != x86_64 || base_dirs_2del="${base_dirs_2del} lib64"

    test -n "${base_dirs_2del}" || return 3

    sudo chattr -fRi ${base_dirs_2del}
    sudo rm -rf ${base_dirs_2del}
}

init-packaging()
{
    test -n "${APL}" || return 1
    umount-lfs > /dev/null 2>&1
    local cur_dir=$(pwd)
    cd ${APL}
    clean-rt
    cd ${cur_dir}
}

do-mkdir-system()
{
    sudo install -d -m 755 -o root -g root ${APL}/root

    sudo install -d -m 755 -o root -g root ${APL}/etc/logrotate-daily.d
    sudo install -d -m 755 -o root -g root ${APL}/etc/logrotate-hourly.d
    sudo install -d -m 755 -o root -g root ${APL}/var/db

    sudo install -d -m 755 -o ${SUPERADMIN_UID} -g ${SUPERADMIN_GID} ${APL}${SUPERADMIN_DIR}
    sudo install -d -m 755 -o ${SN_UID}         -g ${USERS_GID}      ${APL}${SN_DIR}

    sudo install -d -m 755 -o root -g root ${APL}/etc/acpi/events
    sudo install -d -m 755 -o root -g root ${APL}/etc/sysconfig
    sudo install -d -m 755 -o root -g root ${APL}/etc/cron.hourly
    sudo install -d -m 755 -o root -g root ${APL}/etc/cron.daily
    sudo install -d -m 755 -o root -g root ${APL}/etc/cron.weekly
    sudo install -d -m 755 -o root -g root ${APL}/etc/cron.monthly

    sudo install -d -m 755 -o root -g root ${APL}${LOCAL_DIR}/var/lock
    sudo install -d -m 755 -o root -g root ${APL}/etc/${TECHNICAL_NAME}
    sudo install -d -m 755 -o root -g root ${APL}${APPLIANCE_PHP_DIR}
    sudo install -d -m 755 -o root -g root ${APL}${APPLIANCE_DIR}/etc
    sudo install -d -m 755 -o root -g root ${APL}${DB_SCHEMA_DIR}
    sudo install -d -m 500 -o root -g root ${APL}${PRIVATE_DIR}

    sudo install -d -m 755 -o root -g root ${APL}/mnt/cloud
    sudo install -d -m 755 -o root -g root ${APL}${CLOUD_DIR}
}

do-mkdir-srv()
{
    local dir

    sudo install -d -m 755 -o ${NAMED_UID} -g ${NAMED_GID} ${APL}${NAMED_DIR}/var
    sudo install -d -m 755 -o ${NAMED_UID} -g ${NAMED_GID} ${APL}${NAMED_DIR}/zone

    sudo install -d -m 755 -o root -g root ${APL}${NAMED_DIR}/{dev,etc}
    sudo install -d -m 755 -o root -g root ${APL}/etc/ntp

    # To make again after /run mount as tmpfs (see /etc/rc.d/init.d/mountvirtfs)
    for dir in c-icap \
	       clamav \
	       slapd \
	       smartd \
	       var/bootlog
    do
	sudo install -d -m 755 -o root -g root ${APL}/run/${dir}
    done
}

do-mkdir-proxy()
{
    sudo install -d -m 1777 -o root         -g root         ${APL}${PROXY_DIR}/tmp
    sudo install -d -m  755 -o root         -g root         ${APL}${PROXY_DIR}/dev
    sudo install -d -m 1777 -o root         -g root         ${APL}${PROXY_DIR}/dev/shm
    sudo install -d -m  755 -o root         -g root         ${APL}${PROXY_DIR}/etc
    sudo install -d -m  755 -o root         -g root         ${APL}${PROXY_RUN_DIR}
    sudo install -d -m  755 -o root         -g root         ${APL}${PROXY_SSL_DIR}
    sudo install -d -m  755 -o root         -g root         ${APL}${PROXY_SSL_SERVER_DIR}
    sudo install -d -m  755 -o root         -g root         ${APL}${PROXY_SSL_CA_DIR}
    sudo install -d -m  755 -o root         -g root         ${APL}${PROXY_SSL_LOCAL_CA_DIR}
    sudo install -d -m  755 -o root         -g root         ${APL}${PROXY_DIR}/share/errors
    sudo install -d -m  755 -o root         -g root         ${APL}${PROXY_DIR}${LDAP_DIR}
    sudo install -d -m  755 -o root	    -g root	    ${APL}${PROXY_CACHE_DIR}
    sudo install -d -m  755 -o root         -g root         ${APL}${PROXY_DIR}${KERBEROS_KEYTAB_DIR}
    sudo install -d -m  755 -o root         -g root	    ${APL}${PROXY_DOMAIN_LIST_DIR}
    sudo install -d -m  755 -o root         -g root	    ${APL}${PROXY_EXPRESSION_LIST_DIR}
    sudo install -d -m  755 -o ${SQUID_UID} -g ${SQUID_GID} ${APL}${PROXY_DIR}${KERBEROS_CACHE_DIR}
    sudo install -d -m  755 -o ${SQUID_UID} -g ${SQUID_GID} ${APL}${PROXY_LOG_DIR}
    sudo install -d -m  755 -o ${SQUID_UID} -g ${SQUID_GID} ${APL}${PROXY_STATE_DIR}
    sudo install -d -m  755 -o ${SQUID_UID} -g ${SQUID_GID} ${APL}${PROXY_GUARD_DIR}
}

do-mkdir-web()
{
    sudo install -d -m 1777 -o root         -g root         ${APL}${WEB_SERVER_DIR}/tmp
    sudo install -d -m  755 -o root         -g root         ${APL}${WEB_SERVER_DIR}/dev
    sudo install -d -m  755 -o root         -g root         ${APL}${WEB_SERVER_DIR}${LOCAL_DIR}/bin
    sudo install -d -m  755 -o root         -g root         ${APL}${WEB_SERVER_DIR}${LOCAL_DIR}/etc
    sudo install -d -m  755 -o root         -g root         ${APL}${WEB_SERVER_DIR}/share/errors
    sudo install -d -m  755 -o root         -g root         ${APL}${WEB_SERVER_DIR}${LDAP_DIR}
    sudo install -d -m  755 -o root         -g root         ${APL}${WEB_MESSAGE_DIR}
    sudo install -d -m  755 -o root         -g root         ${APL}${WEB_SERVER_DIR}/${STANDBY_NAME}
    sudo install -d -m  755 -o root         -g root         ${APL}${WEB_SERVER_DIR}${KERBEROS_KEYTAB_DIR}
    sudo install -d -m  755 -o root         -g root         ${APL}${WEB_WAF_DIR}
    sudo install -d -m  755 -o ${HTTPD_UID} -g ${HTTPD_GID} ${APL}${WEB_SERVER_DIR}${KERBEROS_CACHE_DIR}
    sudo install -d -m  755 -o ${HTTPD_UID} -g ${HTTPD_GID} ${APL}${WEB_RCACHE_DIR}
    sudo install -d -m  755 -o ${HTTPD_UID} -g ${HTTPD_GID} ${APL}${WEB_AUDIT_DIR}
    sudo install -d -m  755 -o ${HTTPD_UID} -g ${HTTPD_GID} ${APL}${RWEB_AUDIT_DIR}
    sudo install -d -m 2750 -o ${HTTPD_UID} -g ${AV_GID}    ${APL}${WEB_UPLOAD_DIR}
    sudo install -d -m  755 -o root         -g root         ${APL}${WEB_WWW_DIR}
    sudo install -d -m  755 -o root         -g root         ${APL}${WEB_CA_DIR}
    sudo install -d -m  755 -o root         -g root         ${APL}${WEB_RUN_DIR}
    sudo install -d -m  755 -o root         -g root         ${APL}${WEB_ETC_DIR}
    sudo install -d -m  755 -o root         -g root         ${APL}${WEB_LOG_DIR}
    sudo install -d -m  755 -o root         -g root         ${APL}${WEB_SSL_DIR}
    sudo install -d -m  755 -o root         -g root         ${APL}${WEB_SSL_CA_DIR}
}

do-mkdir-av()
{
    sudo install -d -m 755 -o ${AV_UID} -g ${AV_GID} ${APL}${AV_DB_DIR}
    sudo install -d -m 755 -o ${AV_UID} -g ${AV_GID} ${APL}/run/${AV_NAME}
    sudo install -d -m 755 -o ${MANAGER_UID} -g ${USERS_GID} ${APL}${AV_EXTENDED_CACHE_DIR}
    sudo install -d -m 755 -o ${MANAGER_UID} -g ${USERS_GID} ${APL}${AV_EXTENDED_CACHE_FP_DIR}
    sudo install -d -m 755 -o ${MANAGER_UID} -g ${USERS_GID} ${APL}${AV_EXTENDED_CACHE_DB_DIR}
}

do-mkdir-ipsec()
{
    sudo install -d -m 755 -o ${IPSEC_UID} -g ${IPSEC_GID} ${APL}${IPSEC_DIR}
    sudo install -d -m 755 -o ${IPSEC_UID} -g ${IPSEC_GID} ${APL}${IPSEC_VAR_DIR}
    sudo install -d -m 755 -o ${IPSEC_UID} -g ${IPSEC_GID} ${APL}${IPSEC_SSL_DIR}
    sudo install -d -m 755 -o ${IPSEC_UID} -g ${IPSEC_GID} ${APL}${IPSEC_SSL_CA_DIR}
}

do-mkdir-conf()
{
    sudo install -d -m 755 -o root -g root ${APL}${CACHEGUARD_DIR}
    sudo install -d -m 755 -o root -g root ${APL}${CONF_DIR}
    sudo install -d -m 755 -o root -g root ${APL}${CONF_RUN_DIR}
    sudo install -d -m 755 -o root -g root ${APL}${CONF_DIR}/${IPSEC_CONNECTION_DIR_NAME}
}

do-mkdir-admin()
{
    sudo install -d -m 755 -o ${ADMIN_UID} -g ${USERS_GID} ${APL}${ADMIN_DIR}
    sudo install -d -m 755 -o ${ADMIN_UID} -g ${USERS_GID} ${APL}${HARD_DIR}
    sudo install -d -m 755 -o ${ADMIN_UID} -g ${USERS_GID} ${APL}${ABASE_DIR}
    sudo install -d -m 700 -o ${ADMIN_UID} -g ${USERS_GID} ${APL}${ADMIN_DIR}/.ssh
    sudo install -d -m 750 -o ${ADMIN_UID} -g ${USERS_GID} ${APL}${ABASE_DIR}/.ssh
    sudo install -d -m 750 -o ${ADMIN_UID} -g ${USERS_GID} ${APL}${ABASE_DIR}/${SSH_PUBLIC_KEY_RDIR}
    sudo install -d -m 755 -o ${ADMIN_UID} -g ${USERS_GID} ${ABASE_DIR}/${ENV_RDIR}
    sudo install -d -m 700 -o ${SUPERADMIN_UID} -g ${SUPERADMIN_GID} ${APL}${SUPERADMIN_DIR}/.ssh

    sudo install -d -m 1777 -o root -g root ${APL}${TMP_DIR}
    sudo install -d -m  755 -o root -g root ${APL}${ADMIN_DIR}/dev
    sudo install -d -m  755 -o root -g root ${APL}${ADMIN_DIR}/dev/pts
    sudo install -d -m  755 -o root -g root ${APL}${ADMIN_DIR}/proc

    sudo install -d -m 755 -o root -g root ${APL}${GUI_ERR_DIR}
    sudo install -d -m 555 -o root -g root ${APL}${GUI_DOC_COMMAND_DIR}
    sudo install -d -m 555 -o root -g root ${APL}${GUI_DOC_GUIDE_DIR}
    sudo install -d -m 555 -o root -g root ${APL}${GUI_DOC_IMAGE_DIR}
    sudo install -d -m 555 -o root -g root ${APL}${GUI_IMAGE_DIR}
    sudo install -d -m 555 -o root -g root ${APL}${GUI_JS_DIR}
    sudo install -d -m 555 -o root -g root ${APL}${GUI_DJS_DIR}
    sudo install -d -m 555 -o root -g root ${APL}${GUI_MIB_DIR}

    sudo install -d -m  755 -o root -g root ${APL}${ETC_DIR}
    sudo install -d -m  755 -o root -g root ${APL}${ETC_DIR}/ssl
    sudo install -d -m  755 -o root -g root ${APL}${VAR_DIR}

    sudo install -d -m  755 -o root -g root ${APL}${RUN_DIR}
    sudo install -d -m  755 -o root -g root ${APL}${DB_DIR}
    sudo install -d -m  755 -o root -g root ${APL}${SSL_DIR}
    sudo install -d -m  755 -o root -g root ${APL}${SSL_SERVER_DIR}
    sudo install -d -m  755 -o root -g root ${APL}${SSL_CA_DIR}
    sudo install -d -m  755 -o root -g root ${APL}${SSL_LOCAL_CA_DIR}
    sudo install -d -m  755 -o root -g root ${APL}${SSL_CTL_DIR}
    sudo install -d -m  755 -o root -g root ${APL}${SSL_VAR_DIR}

    sudo install -d -m  755 -o ${ADMIN_UID} -g ${USERS_GID} ${APL}${URLLIST_VAR_DIR}
    sudo install -d -m  755 -o ${ADMIN_UID} -g ${USERS_GID} ${APL}${AV_VAR_DIR}

    sudo install -d -m  755 -o root -g root ${APL}${SAVE_DIR}
    sudo install -d -m  755 -o root -g root ${APL}${USR_DIR}
    sudo install -d -m  755 -o root -g root ${APL}${GUI_CGI_DIR}
    sudo install -d -m  755 -o root -g root ${APL}${MISC_DIR}
    sudo install -d -m  755 -o root -g root ${APL}${USR_BIN_DIR}
    sudo install -d -m  755 -o root -g root ${APL}${BASE_DIR}
    sudo install -d -m  755 -o root -g root ${APL}${LOG_DIR}
    sudo install -d -m  700 -o root -g root ${APL}${SUDO_DIR}
    sudo install -d -m 1777 -o root -g root ${APL}${LOCK_DIR}

    sudo install -d -m  775 -o ${ADMIN_UID} -g ${USERS_GID} ${APL}${RUN_DIR}/${SUPERVISOR_ARGS}
    sudo install -d -m  755 -o ${ADMIN_UID} -g ${USERS_GID} ${APL}${SSL_CLIENT_DIR}
    sudo install -d -m  755 -o ${ADMIN_UID} -g ${USERS_GID} ${APL}${SSL_SNMP_DIR}

    sudo install -d -m 755 -o root -g root ${APL}${ADMIN_DIR}${LOCAL_DIR}/bin
    sudo install -d -m 755 -o root -g root ${APL}${ADMIN_DIR}${APPLIANCE_DIR}/bin
    sudo install -d -m 755 -o root -g root ${APL}${ADMIN_DIR}${APPLIANCE_DIR}/etc
    sudo install -d -m 755 -o root -g root ${APL}${ADMIN_DIR}${APPLIANCE_DIR}/lib
    sudo install -d -m 755 -o root -g root ${APL}${ADMIN_DIR}${APPLIANCE_DIR}/man/man1

    sudo install -d -m 550 -o ${ADMIN_UID} -g ${USERS_GID} ${APL}${ADMIN_DIR}${PRIVATE_DIR}

    sudo install -d -m 755 -o root -g root ${APL}${WAUDIT_DIR}/${IMAGE_DIR_NAME}
    sudo install -d -m 755 -o root -g root ${APL}${WAUDIT_DIR}/${JS_DIR_NAME}

    sudo install -d -m 700 -o ${DAEMON_UID} -g ${DAEMON_GID} ${APL}${ADMIN_DIR}/usr/local/var/spool/at/jobs
    sudo install -d -m 700 -o ${DAEMON_UID} -g ${DAEMON_GID} ${APL}${ADMIN_DIR}/usr/local/var/spool/at/spool

    sudo install -d -m 755 -o root -g root ${APL}${ADMIN_DIR}${LDAP_DIR}

    sudo install -d -m 755 -o ${WADMIN_UID} -g root ${APL}${ADMIN_DIR}/${AUDIT_RDIR}
    sudo install -d -m 755 -o ${WADMIN_UID} -g root ${APL}${ADMIN_DIR}/${UPLOAD_RDIR}
}

do-mkdir-manager()
{
    sudo install -d -m 755 -o ${MANAGER_UID} -g ${USERS_GID} ${APL}${MANAGER_DIR}
    sudo install -d -m 700 -o ${MANAGER_UID} -g ${USERS_GID} ${APL}${MANAGER_DIR}/.ssh
}

do-mkdir-embedded()
{
    sudo install -d -m 755 -o root -g root ${APL}${WEB_DB_DIR}/${EMBEDDED_APPLICATIONS_NAME}
    sudo install -d -m 755 -o root -g root ${APL}${WEB_SERVER_DIR}/${EMBEDDED_APPLICATIONS_NAME}
}

apl-mkdirs()
{
    do-mkdir-system
    do-mkdir-srv
    do-mkdir-proxy
    do-mkdir-web
    do-mkdir-av
    do-mkdir-ipsec
    do-mkdir-conf
    do-mkdir-admin
    do-mkdir-manager
    do-mkdir-embedded
}

gen-modules()
{
    cat sysconfig.modules-constant
    cat sysconfig.modules-network
    echo
    echo "# End /etc/sysconfig/modules"
}

gen-apl-id()
{
    local serial_date=$(date +%y%m%d)
    local nb=$(gen-random-nb)
    local level=$(get-usage-level ${TEST_USERS_NB} ${TEST_RUSERS_NB})
    local id="_${SN_PREFIX}-L${level}_${serial_date}T-${nb}"
    APPLIANCE_ID=${id}
    echo ${id}
}

gen-inittab()
{
    cat << EOF
# Begin /etc/inittab

id:3:initdefault:

si::sysinit:/etc/rc.d/init.d/rc S

l0:0:wait:/etc/rc.d/init.d/rc 0
l1:S1:wait:/etc/rc.d/init.d/rc 1
l2:2:wait:/etc/rc.d/init.d/rc 2
l3:3:wait:/etc/rc.d/init.d/rc 3
l4:4:wait:/etc/rc.d/init.d/rc 4
l5:5:wait:/etc/rc.d/init.d/rc 5
l6:6:wait:/etc/rc.d/init.d/rc 6

ca:13:ctrlaltdel:/sbin/shutdown -t1 -a -r now

su:S016:once:/sbin/sulogin

EOF

    echo "s1:3:respawn:/sbin/agetty --noclear -L -I '\033(B' ttyS0 ${SERIAL_SPEED} vt100"
    cat << EOF
1:3:respawn:/sbin/agetty --noclear tty1 9600
2:3:respawn:/sbin/agetty tty2 9600
3:3:respawn:/sbin/agetty tty3 9600

# End /etc/inittab
EOF
}

gen-passwd()
{
    cat ${LFS}/etc/passwd

    echo "${APPLIANCE_ID}:x:${SN_UID}:${USERS_GID}:Serial Number:${SN_DIR}:/usr/local/bin/apl_serial_login"
    echo "${SUPERADMIN_NAME}:x:${SUPERADMIN_UID}:${SUPERADMIN_GID}:Super Administrator:${SUPERADMIN_DIR}:/bin/bash"
    echo "${WADMIN_NAME}:x:${WADMIN_UID}:${USERS_GID}:Web Administration Daemon:${ADMIN_DIR}${GUI_DIR}/${WWW_DIR_NAME}:/bin/false"
    echo "${ADMIN_NAME}:x:${ADMIN_UID}:${USERS_GID}:Administrator:${ADMIN_DIR}:/usr/local/bin/apl_chroot_bash"
    echo "${MANAGER_NAME}:x:${MANAGER_UID}:${USERS_GID}:Manager:${MANAGER_DIR}:/bin/bash"
}

gen-shadow()
{
    sudo cat ${LFS}/etc/shadow

    echo "${SUPERADMIN_NAME}::12000:0:1000000:30:::"
    echo "${APPLIANCE_ID}::12000:0:1000000:30:::"
    echo "${ADMIN_NAME}::12000:0:1000000:30:::"
    echo "${MANAGER_NAME}:*:12000:0:1000000:30:::"
}

gen-group()
{
    cat ${LFS}/etc/group

    echo "${SUPERADMIN_NAME}:x:${SUPERADMIN_GID}:"
}

disk-index()
{
    test -n "${1}" || return 1
    local hd_name=${1}

    local hd_index=${hd_name:2}

    case ${hd_name:0:2} in
	sd|hd|nv|vd)
	    hd_index=$(printf "%d" \'${hd_index})
	    hd_index=$[${hd_index} - 97]
	    ;;
	md)
	    hd_index=$[${hd_index} - 1]
	    ;;
	*)
	    ;;
    esac

    echo ${hd_index}
    return 0
}

gen-rc-site()
{
    cat << EOF
# rc.site
# Optional parameters and override functions for boot scripts.

# Distro Information
# These values, if specified here, override the defaults

print_error_msg()
{
   :
}

EOF
    echo "DISTRO='${COMMERCIAL_NAME}-OS'"
    echo "DISTRO_CONTACT='${SUPPORT_EMAIL}'"
    echo "DISTRO_MINI='${TECHNICAL_NAME}'"
    echo "HOSTNAME=${TECHNICAL_NAME}"

    cat << EOF

BRACKET="\\033[1;34m" # Blue
FAILURE="\\033[1;31m" # Red
INFO="\\033[1;36m"    # Cyan
NORMAL="\\033[0;39m"  # Grey
SUCCESS="\\033[1;32m" # Green
WARNING="\\033[1;33m" # Yellow

BMPREFIX="     "
SUCCESS_PREFIX="\${SUCCESS}  *  \${NORMAL}"
WARNING_PREFIX="\${WARNING}  *  \${NORMAL}"
FAILURE_PREFIX="\${FAILURE} *** \${NORMAL}"

IPROMPT="no"
itime="3"

wlen=$(echo "Welcome to ${DISTRO}" | wc -c )
welcome_message="Welcome to ${INFO}${DISTRO}${NORMAL}"

ilen=$(echo "Press 'I' to enter interactive startup" | wc -c )
i_message="Press '${FAILURE}I${NORMAL}' to enter interactive startup"

FASTBOOT=no
HEADLESS=no
VERBOSE_FSCK=yes
OMIT_UDEV_SETTLE=no
OMIT_UDEV_RETRY_SETTLE=no
SKIPTMPCLEAN=no

UTC=1
CLOCKPARAMS=""

LOGLEVEL=alert
KILLDELAY=3

SYSKLOGD_PARMS=""

UNICODE=1
KEYMAP="uk"
KEYMAP_CORRECTIONS="euro2"
FONT="lat0-16 -m 8859-15"
LEGACY_CHARSET=""
EOF
}

gen-os-release()
{
    echo "PRETTY_NAME=\"${COMMERCIAL_NAME}-OS ${OS_GENERATION}-${OS_VERSION}\""
    echo "NAME=\"${COMMERCIAL_NAME}\""
    echo "VERSION_ID=\"${OS_VERSION}\""
    echo "VERSION=\"${OS_GENERATION}-${OS_VERSION}\""
    echo "VERSION_CODENAME=\"UTM\""
    echo "ID=\"${TECHNICAL_NAME}\""
    echo "HOME_URL=\"https://${WEBSITE}/\""
    echo "SUPPORT_URL=\"https://${HELP_WEBSITE}/\""
}

gen-bash_profile()
{
    cat bash_profile
    echo "export CURL_CA_BUNDLE=${PROXY_SSL_CA_DIR}/ca-bundle.crt"
}

gen-conf-files()
{
    gen-modules > ${GENERATED_DIR}/sysconfig.modules
    gen-apl-id > ${GENERATED_DIR}/etc.${SN_ID}
    gen-inittab > ${GENERATED_DIR}/etc.inittab
    gen-passwd > ${GENERATED_DIR}/etc.passwd
    gen-shadow > ${GENERATED_DIR}/etc.shadow
    gen-group > ${GENERATED_DIR}/etc.group
    gen-rc-site > ${GENERATED_DIR}/sysconfig.rc.site
    gen-os-release > ${GENERATED_DIR}/etc.os-release
    gen-bash_profile > ${GENERATED_DIR}/bash_profile
}

install-conf-files()
{
    sudo install -m 400 -o root -g root sysconfig.modules-constant ${APL}/etc/sysconfig/modules-constant
    sudo install -m 400 -o root -g root sysconfig.modules-network ${APL}/etc/sysconfig/modules-network
    sudo install -m 644 -o root -g root ${GENERATED_DIR}/sysconfig.modules ${APL}/etc/sysconfig/modules
    sudo install -m 644 -o root -g root ${GENERATED_DIR}/etc.${SN_ID} ${APL}${HARD_DIR}/${SN_ID}
    sudo install -m 644 -o root -g root ${GENERATED_DIR}/etc.inittab ${APL}/etc/inittab
    sudo install -m 644 -o root -g root ${GENERATED_DIR}/etc.passwd ${APL}/etc/passwd
    sudo install -m 644 -o root -g root ${GENERATED_DIR}/etc.shadow ${APL}/etc/shadow
    sudo install -m 644 -o root -g root ${GENERATED_DIR}/etc.group ${APL}/etc/group
    sudo install -m 644 -o root -g root ${GENERATED_DIR}/sysconfig.rc.site ${APL}/etc/sysconfig/rc.site
    sudo install -m 644 -o root -g root ${GENERATED_DIR}/etc.os-release ${APL}/etc/os-release
    sudo install -m 644 -o root -g root ${GENERATED_DIR}/bash_profile ${APL}/root/.bash_profile
    sudo install -m 644 -o ${SUPERADMIN_UID} -g ${SUPERADMIN_GID} ${GENERATED_DIR}/bash_profile ${APL}${SUPERADMIN_DIR}/.bash_profile
}

tar-lfs-4apl()
{
    local cur_dir=${PWD}

    test -n "${cur_dir}" || return 1
    test -d "${cur_dir}" || return 2

    local runtime_files=$(cat runtime-files.lst)
    test -n "${runtime_files}" || return 3
    test ${SYS_ARCHITECTURE} != x86_64 || runtime_files="${runtime_files} lib64 usr/lib64"

    cd ${LFS} &&
    sudo tar \
	--numeric-owner \
	--same-owner \
	--exclude='lib*.a' \
	--exclude='usr/src*' \
	--exclude="${PROXY_DIR:1}/include*" \
	--exclude="${WEB_SERVER_DIR:1}/include*" \
	-cf ${cur_dir}/${GENERATED_DIR}/lfs.tar ${runtime_files}
    cd ${cur_dir}
    sudo chown ${USER}:${USER} ${GENERATED_DIR}/lfs.tar
}

add-special-bin()
{
    sudo cp -a ${LFS}/${WEB_SERVER_DIR}/sbin/httpd	${LFS}${WEB_SERVER_DIR}/sbin/wadmind
    sudo cp -a ${LFS}/${LOCAL_DIR}/bin/avscan		${LFS}${WEB_SERVER_DIR}/bin/avscan
    sudo cp -a ${LFS}/usr/bin/logger			${LFS}${WEB_SERVER_DIR}/bin/logger
    sudo cp -a ${LFS}/${WEB_SERVER_DIR}/bin/htpasswd	${LFS}/usr/bin/htpasswd
    sudo cp -a ${LFS}/${PROXY_DIR}/bin/squidclient	${LFS}/usr/bin/squidclient
}

del-special-bin()
{
    sudo rm -f \
	 ${LFS}${WEB_SERVER_DIR}/sbin/wadmind \
	 ${LFS}${WEB_SERVER_DIR}/bin/avscan \
	 ${LFS}${WEB_SERVER_DIR}/bin/logger \
	 ${LFS}/usr/bin/htpasswd \
	 ${LFS}/usr/bin/squidclient
}

local-install-lfs()
{
    local file files="
CacheGuard.env
WorkFunctions
admin-unlinked-libraries.lst
proxy-unlinked-libraries.lst
web-unlinked-libraries.lst
proxy-binaries.lst
proxy-others.lst
admin-binaries.lst
admin-others.lst
web-binaries.lst
web-others.lst
local-install-lfs.bash
"
    for file in ${files}
    do
	sudo install ${file} ${LFS}/tmp/
    done

    sudo chroot ${LFS} /bin/bash /tmp/local-install-lfs.bash

    sudo install -m 644 ${LFS}/tmp/admin.tar ${GENERATED_DIR}
    sudo install -m 644 ${LFS}/tmp/proxy.tar ${GENERATED_DIR}
    sudo install -m 644 ${LFS}/tmp/web.tar ${GENERATED_DIR}

    for file in ${files}
    do
	file=$(file-basename ${file})
	sudo rm -f ${LFS}/tmp/${file}
    done
    sudo rm -f ${LFS}/tmp/admin.tar
    sudo rm -f ${LFS}/tmp/proxy.tar
    sudo rm -f ${LFS}/tmp/web.tar
}

local-install-apl()
{
    local file files="
CacheGuard.env
WorkFunctions
local-install-apl.bash
"
    for file in ${files}
    do
	install ${file} ${APL}/tmp/
    done

    sudo chroot ${APL} /bin/bash /tmp/local-install-apl.bash

    for file in ${files}
    do
	file=$(file-basename ${file})
	rm -f ${APL}/tmp/${file}
    done
}

untar-lsf-2apl()
{
    local cur_dir=${PWD}

    cd ${APL}
    sudo tar -xpf ${cur_dir}/${GENERATED_DIR}/lfs.tar
    cd ${cur_dir}
    rm -f ${GENERATED_DIR}/lfs.tar
}

clean-unwanted()
{
    test -n "${APL}" || exit 111
    test -d ${APL} || exit 113

    local cur_dir=${PWD}

    cd ${APL}

    sudo rm -rf \
	 tmp/* \
	 var/tmp/* \
	 etc/group- etc/shadow- etc/passwd- \
	 etc/rc.d/init.d/waagent \
	 proc/* \
	 sys/* \
	 var/log/* \
	 var/spool/anacron/* \
	 var/spool/cron/* \
	 var/empty/sshd/* \
	 mnt/initrd/* \
	 run/{c-icap,clamav,slapd,smartd,var/bootlog}/* \
	 ${PROXY_DIR:1}/var/run/* \
	 ${WEB_SERVER_DIR:1}/var/run/* \
	 ${AV_DIR:1}/*

    cd ${cur_dir}
}

untar-admin-2apl()
{
    local cur_dir=${PWD}

    cd ${APL}${ADMIN_DIR}
    sudo tar -xpf ${cur_dir}/${GENERATED_DIR}/admin.tar
    cd ${cur_dir}
}

untar-proxy-2apl()
{
    local cur_dir=${PWD}

    cd ${APL}${PROXY_DIR}
    sudo tar -xpf ${cur_dir}/${GENERATED_DIR}/proxy.tar
    cd ${cur_dir}
}

untar-web-2apl()
{
    local cur_dir=${PWD}

    cd ${APL}${WEB_SERVER_DIR}
    sudo tar -xpf ${cur_dir}/${GENERATED_DIR}/web.tar
    cd ${cur_dir}
}

conf-others()
{
    sudo touch ${APL}/etc/mtab
    sudo touch ${APL}/etc/ntp/drift
    test -c ${APL}/dev/urandom || sudo mknod -m 0666 ${APL}/dev/urandom c 1 9

    sudo rm  -f ${APL}${LOCAL_DIR}/etc/smartd.conf
    sudo rm  -f ${APL}/etc/rc.d/{rc*.d/*sysklogd,init.d/sysklogd}
    sudo rm -rf ${APL}${LDAP_DIR}/{slapd.*,ldap.conf.default,DB_CONFIG.example}

    sudo rm -f  ${APL}${LOCAL_DIR}/share/snmp/tls/openssl.in
    sudo rm -f  ${APL}${LOCAL_DIR}/share/snmp/tls/.openssl.conf
    sudo rm -rf  ${APL}${LOCAL_DIR}/share/snmp/tls/newcerts

    sudo ln -sf ../${SYSTEM_CA}.certificate ${APL}${SSL_LOCAL_CA_DIR}/${SYSTEM_CA_ID}.certificate
    sudo ln -sf ../${SYSTEM_CA}.certificate ${APL}${PROXY_SSL_LOCAL_CA_DIR}/${SYSTEM_CA_ID}.certificate

    sudo rm -rf ${APL}${LOCAL_DIR}/etc/ipsec.d/private && sudo ln -sf ${SSL_SERVER_DIR} ${APL}${LOCAL_DIR}/etc/ipsec.d/private
    sudo rm -rf ${APL}${LOCAL_DIR}/etc/ipsec.d/certs && sudo ln -sf ${SSL_SERVER_DIR} ${APL}${LOCAL_DIR}/etc/ipsec.d/certs
    sudo rm -rf ${APL}${LOCAL_DIR}/etc/ipsec.d/cacerts && sudo ln -sf ${SSL_LOCAL_CA_DIR} ${APL}${LOCAL_DIR}/etc/ipsec.d/cacerts
}

chroot-bind()
{
    test -c ${APL}${NAMED_DIR}/dev/null || sudo mknod -m 0666 ${APL}${NAMED_DIR}/dev/null c 1 3
    test -c ${APL}${NAMED_DIR}/dev/zero || sudo mknod -m 0666 ${APL}${NAMED_DIR}/dev/zero c 1 5
    test -c ${APL}${NAMED_DIR}/dev/random || sudo mknod -m 0666 ${APL}${NAMED_DIR}/dev/random c 1 8

    sudo install -m 644 -o root -g root ${APL}/etc/ld.so.cache ${APL}${NAMED_DIR}/etc/ld.so.cache
    sudo install -m 644 -o root -g root ${APL}${LOCAL_DIR}/etc/bind.keys ${APL}${NAMED_DIR}/etc/bind.keys
}

gen-proxy-passwd()
{
    echo "root:x:0:0:root:/root:/bin/false"
    echo "cache:x:${SQUID_UID}:${SQUID_GID}:Proxy Cache:/:/bin/false"
    echo "proxy:x:${PROXY_UID}:${PROXY_GID}:Proxy:${PROXY_DIR}:/bin/false"
}

gen-proxy-shadow()
{
    echo "root:!:17282:0:1000000:30:::"
    echo "cache:!:12000:0:1000000:30:::"
    echo "proxy:!:12000:0:1000000:30:::"
}

gen-proxy-group()
{
    echo "root:x:0:"
    echo "cache:x:${SQUID_GID}:"
    echo "proxy:x:${PROXY_GID}:cache"
}

gen-web-passwd()
{
    echo "filter:x:${HTTPD_UID}:${HTTPD_GID}:Web:${WEB_SERVER_DIR}:/bin/false"
}

gen-web-shadow()
{
    echo "filter::12000:0:1000000:30:::"
}

gen-web-group()
{
    echo "proxy:x:${PROXY_GID}:cache,filter"
}

chroot-proxy()
{
    gen-proxy-passwd > ${GENERATED_DIR}/proxy.etc.passwd
    gen-proxy-group > ${GENERATED_DIR}/proxy.etc.group
    gen-proxy-shadow > ${GENERATED_DIR}/proxy.etc.shadow

    test -c ${APL}${PROXY_DIR}/dev/null || sudo mknod -m 0666 ${APL}${PROXY_DIR}/dev/null c 1 3
    test -c ${APL}${PROXY_DIR}/dev/urandom || sudo mknod -m 0666 ${APL}${PROXY_DIR}/dev/urandom c 1 9

    sudo install -m 644 -o root -g root ${APL}/etc/nsswitch.conf ${APL}${WEB_SERVER_DIR}/etc
    sudo install -m 644 -o root -g root ${APL}/etc/host.conf ${APL}${WEB_SERVER_DIR}/etc

    sudo install -m 644 -o root -g root ${GENERATED_DIR}/proxy.etc.passwd ${APL}${PROXY_DIR}/etc/passwd
    sudo install -m 644 -o root -g root ${GENERATED_DIR}/proxy.etc.shadow ${APL}${PROXY_DIR}/etc/shadow
    sudo install -m 644 -o root -g root ${GENERATED_DIR}/proxy.etc.group ${APL}${PROXY_DIR}/etc/group
    sudo install -m 755 -o root -g root ${APL}/usr/bin/false ${APL}${PROXY_DIR}/bin/false
    sudo install -m 644 -o root -g root ${APL}/etc/ld.so.cache ${APL}${PROXY_DIR}/etc/ld.so.cache

    sudo mv ${APL}${PROXY_DIR}/lib/* ${APL}${PROXY_DIR}/usr/lib/
    sudo cp -a ${APL}/usr/lib/sasl2 ${APL}${PROXY_DIR}/usr/lib
    sudo rmdir ${APL}${PROXY_DIR}/lib

    sudo ln -sf /tmp ${APL}${PROXY_DIR}/var/tmp
    sudo ln -sf usr/lib ${APL}${PROXY_DIR}/lib
}

chroot-web()
{
    gen-web-passwd > ${GENERATED_DIR}/web.etc.passwd
    gen-web-group > ${GENERATED_DIR}/web.etc.group
    gen-web-shadow > ${GENERATED_DIR}/web.etc.shadow

    sudo install -m 644 -o root -g root ${GENERATED_DIR}/web.etc.passwd ${APL}${WEB_SERVER_DIR}/etc/passwd
    sudo install -m 644 -o root -g root ${GENERATED_DIR}/web.etc.shadow ${APL}${WEB_SERVER_DIR}/etc/shadow
    sudo install -m 644 -o root -g root ${GENERATED_DIR}/web.etc.group ${APL}${WEB_SERVER_DIR}/etc/group
    sudo install -m 644 -o root -g root ${APL}/etc/ld.so.cache ${APL}${WEB_SERVER_DIR}/etc/ld.so.cache

    test -c ${APL}${WEB_SERVER_DIR}/dev/null || sudo mknod -m 0666 ${APL}${WEB_SERVER_DIR}/dev/null c 1 3

    sudo ln -sf usr/lib ${APL}${WEB_SERVER_DIR}/lib
    sudo ln -sf /tmp ${APL}${WEB_SERVER_DIR}/var/tmp
}

gen-admin-group()
{
    echo "root:x:0:"
    echo "tty:x:${TTY_GID}:"
    echo "daemon:x:${DAEMON_GID}:"
    echo "${GROUP_NAME}:x:${USERS_GID}:"
    echo "dialout:x:${DIALOUT_GID}:"
}

gen-admin-passwd()
{
    echo "root:x:0:0:Super User:/:/bin/false"
    echo "daemon:x:6:6:daemon:/sbin:/bin/false"
    echo "${WADMIN_NAME}:x:${WADMIN_UID}:${USERS_GID}:WEB Administration Daemon:${GUI_DIR}:/bin/false"
    echo "${ADMIN_NAME}:x:${ADMIN_UID}:${USERS_GID}:Main Administrator:/home/${ADMIN_NAME}:/bin/apl_bash"
}

gen-admin-shadow()
{
    echo "root:!:12000:0:99999:7:::"
    echo "${WADMIN_NAME}:!:12000:0:1000000:30:::"
    echo "${ADMIN_NAME}:!:12000:0:1000000:30:::"
}

chroot-admin()
{
    sudo chmod u+s ${APL}${ADMIN_DIR}/usr/bin/{date,ping}

    test -c "${APL}${ADMIN_DIR}/dev/urandom" || sudo mknod -m 0666 ${APL}${ADMIN_DIR}/dev/urandom c 1 9
    test -c "${APL}${ADMIN_DIR}/dev/null"    || sudo mknod -m 0666 ${APL}${ADMIN_DIR}/dev/null c 1 3
    test -c "${APL}${ADMIN_DIR}/dev/zero"   || sudo mknod -m 0666 ${APL}${ADMIN_DIR}/dev/zero c 1 5
    test -c "${APL}${ADMIN_DIR}/dev/ptmx"   || sudo mknod -m 0666 ${APL}${ADMIN_DIR}/dev/ptmx c 5 2

    local i

    if test ! -c "${APL}${ADMIN_DIR}/dev/tty" ; then
	sudo mknod -m 0666 ${APL}${ADMIN_DIR}/dev/tty c 5 0
	sudo chgrp ${TTY_GID} ${APL}${ADMIN_DIR}/dev/tty
    fi

    for ((i=0 ; i<4 ; i++))
    do
	if test ! -c ${APL}${ADMIN_DIR}/dev/tty${i} ; then
	    sudo mknod -m 0620 ${APL}${ADMIN_DIR}/dev/tty${i} c 4 ${i}
	    sudo chgrp ${TTY_GID} ${APL}${ADMIN_DIR}/dev/tty${i}
	fi

	if test ! -c ${APL}${ADMIN_DIR}/dev/ttyS${i} ; then
	    sudo mknod -m 0660 ${APL}${ADMIN_DIR}/dev/ttyS${i} c 4 $((64 + i))
	    sudo chgrp ${DIALOUT_GID} ${APL}${ADMIN_DIR}/dev/ttyS${i}
	fi
    done

    gen-admin-passwd > ${GENERATED_DIR}/admin.etc.passwd
    gen-admin-shadow > ${GENERATED_DIR}/admin.etc.shadow
    gen-admin-group  > ${GENERATED_DIR}/admin.etc.group

    sudo install -m 644 -o root -g root ${GENERATED_DIR}/admin.etc.passwd ${APL}${ADMIN_DIR}/etc/passwd
    sudo install -m 400 -o root -g root ${GENERATED_DIR}/admin.etc.shadow ${APL}${ADMIN_DIR}/etc/shadow
    sudo install -m 644 -o root -g root ${GENERATED_DIR}/admin.etc.group  ${APL}${ADMIN_DIR}/etc/group

    sudo install -m 644 -o root -g root ${APL}/etc/ld.so.cache ${APL}${ADMIN_DIR}/etc/ld.so.cache
    sudo install -m 644 -o root -g root ${APL}/etc/ssl/openssl.cnf ${APL}${ADMIN_DIR}/etc/ssl/openssl.cnf

    sudo ln -sf usr/lib ${APL}${ADMIN_DIR}/lib
    sudo ln -sf usr/sbin ${APL}${ADMIN_DIR}/sbin
}

main()
{
    init-packaging
    add-special-bin
    tar-lfs-4apl
    local-install-lfs
    del-special-bin
    untar-lsf-2apl
    apl-mkdirs
    untar-admin-2apl
    untar-proxy-2apl
    untar-web-2apl
    clean-unwanted
    gen-conf-files
    install-conf-files
    conf-others
    chroot-bind
    chroot-proxy
    chroot-web
    chroot-admin
    local-install-apl
}

# Main()

mkdir -p ${FULL_GENERATED_DIR}
ln -sf ${FULL_GENERATED_DIR}

main
