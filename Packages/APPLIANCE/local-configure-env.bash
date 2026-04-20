#!/bin/bash

cd /tmp
source LFS.env
source APPLIANCE.env

make-dirs()
{
    mkdir -p ${SSHD_DIR}

    mkdir -p ${AV_DIR}
    chown ${AV_UID}:${AV_GID} ${AV_DIR}

    mkdir -p ${IPSEC_DIR}
    chown ${IPSEC_UID}:${IPSEC_GID} ${IPSEC_DIR}
}

gen-passwd()
{
    cat > /etc/passwd << EOF
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/dev/null:/usr/bin/false
daemon:x:${DAEMON_UID}:${DAEMON_GID}:Daemon User:/dev/null:/usr/bin/false
messagebus:x:18:18:D-Bus Message Daemon User:/run/dbus:/usr/bin/false
uuidd:x:80:80:UUID Generation Daemon User:/dev/null:/usr/bin/false
nobody:x:99:99:Unprivileged User:/dev/null:/usr/bin/false
EOF
    echo "sshd:x:${SSHD_UID}:${SSHD_GID}:Secure Shell:${SSHD_DIR}:/bin/false" >> /etc/passwd
    echo "ntp:x:${NTP_UID}:${NTP_GID}:Network Time Protocol:${NTP_DIR}:/bin/false" >> /etc/passwd
    echo "named:x:${NAMED_UID}:${NAMED_GID}:DNS:${NAMED_DIR}:/bin/false" >> /etc/passwd
    echo "${SQUID_USER}:x:${SQUID_UID}:${SQUID_GID}:Squid:${PROXY_DIR}:/bin/false" >> /etc/passwd
    echo "${HTTPD_USER}:x:${HTTPD_UID}:${HTTPD_GID}:Web:${WEB_SERVER_DIR}:/bin/false" >> /etc/passwd
    echo "proxy:x:${PROXY_UID}:${PROXY_GID}:Proxy:${PROXY_DIR}:/bin/false" >> /etc/passwd
    echo "snmp:x:${SNMP_UID}:${SNMP_GID}:SNMP Agent:/dev/null:/bin/false" >> /etc/passwd
    echo "${AV_USER}:x:${AV_UID}:${AV_GID}:Anti Virus:${AV_DIR}:/bin/false" >> /etc/passwd
    echo "${IPSEC_USER}:x:${IPSEC_UID}:${IPSEC_GID}:IPSec VPN:${IPSEC_DIR}:/bin/false" >> /etc/passwd
}

gen-shadow()
{
    test -f /etc/passwd || return 1

    local line user

    while read line
    do
	user=${line/:*}
	echo ${user}::12000:0:1000000:30:::
    done < /etc/passwd > /etc/shadow
}

gen-group()
{
    cat > /etc/group << EOF
root:x:0:
bin:x:1:daemon
sys:x:2:
kmem:x:3:
tape:x:4:
tty:x:5:
daemon:x:6:
floppy:x:7:
disk:x:8:
lp:x:9:
dialout:x:10:
audio:x:11:
video:x:12:
utmp:x:13:
usb:x:14:
cdrom:x:15:
adm:x:16:
messagebus:x:18:
input:x:24:
mail:x:34:
kvm:x:61:
uuidd:x:80:
wheel:x:97:
nogroup:x:99:
dummy:x:1000:nobody
${GROUP_NAME}:x:${USERS_GID}:
EOF
    echo "sshd:x:${SSHD_GID}:" >> /etc/group
    echo "ntp:x:${NTP_GID}:" >> /etc/group
    echo "named:x:${NAMED_GID}:" >> /etc/group
    echo "${SQUID_GROUP}:x:${SQUID_GID}:" >> /etc/group
    echo "${HTTPD_GROUP}:x:${HTTPD_GID}:" >> /etc/group
    echo "proxy:x:${PROXY_GID}:${SQUID_USER},${HTTPD_USER}" >> /etc/group
    echo "snmp:x:${SNMP_GID}:" >> /etc/group
    echo "${AV_GROUP}:x:${AV_GID}:" >> /etc/group
    echo "${IPSEC_GROUP}:x:${IPSEC_GID}:" >> /etc/group
    cat >> /etc/group << "EOF"
EOF
}

gen-host-conf()
{
    cat > /etc/host.conf << EOF
order hosts,bind
EOF
}

update-profile()
{
    sed -i -e "s@^export MANPATH=.*@export MANPATH=/usr/man:/usr/share/man:${LOCAL_DIR}/share/man:${WEB_SERVER_DIR}/man:${LOCAL_DIR}/php/man@" /etc/profile
}

# Main()

make-dirs
gen-passwd
gen-shadow
gen-group
gen-host-conf
update-profile
