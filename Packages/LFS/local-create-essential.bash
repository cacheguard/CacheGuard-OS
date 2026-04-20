#!/bin/bash

source /tmp/LFS.env

create-directories()
{
    mkdir -pv /{boot,home,mnt,opt,srv}

    mkdir -pv /etc/{opt,sysconfig}
    mkdir -pv /lib/firmware
    mkdir -pv /media/{floppy,cdrom}
    mkdir -pv /usr/{,local/}{include,src}
    mkdir -pv /usr/local/{bin,lib,sbin}
    mkdir -pv /usr/{,local/}share/{color,dict,doc,info,locale,man}
    mkdir -pv /usr/{,local/}share/{misc,terminfo,zoneinfo}
    mkdir -pv /usr/{,local/}share/man/man{1..8}
    mkdir -pv /var/{cache,local,log,mail,opt,spool}
    mkdir -pv /var/lib/{color,misc,locate}

    ln -sfv /run /var/run
    ln -sfv /run/lock /var/lock

    install -dv -m 0750 /root
    install -dv -m 1777 /tmp /var/tmp
}

create-files-symlinks()
{
    ln -svf /proc/self/mounts /etc/mtab
}

create-etc-host()
{
    cat > /etc/hosts << EOF
127.0.0.1  localhost $(hostname)
::1        localhost
EOF
}

create-etc-passwd()
{
    cat > /etc/passwd << EOF
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/dev/null:/usr/bin/false
daemon:x:${DAEMON_UID}:${DAEMON_GID}:Daemon User:/dev/null:/usr/bin/false
messagebus:x:18:18:D-Bus Message Daemon User:/run/dbus:/usr/bin/false
uuidd:x:80:80:UUID Generation Daemon User:/dev/null:/usr/bin/false
tss:x:81:81:TPM Software Stack:/dev/null:/bin/false
nobody:x:99:99:Unprivileged User:/dev/null:/usr/bin/false
EOF
}

create-etc-group()
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
tss:x:81:
wheel:x:97:
nogroup:x:99:
${GROUP_NAME}:x:${USERS_GID}:
EOF
}

# Main()

create-directories
create-files-symlinks
create-etc-host
create-etc-passwd
create-etc-group
