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

source /tmp/LFS.env
source /tmp/functions

gen-ifconfig()
{
    echo "ONBOOT=yes"
    echo "IFACE=eth0"
    echo "SERVICE=ipv4-static"
    echo "IP=${SYS_IP}"
    echo "GATEWAY=${SYS_GATEWAY}"
    echo "PREFIX=${SYS_PREFIX}"
    echo "BROADCAST=${SYS_BROADCAST}"
}

gen-resolv()
{
    echo "# Begin"
    echo
    echo "domain ${SYS_DOMAIN}"
    echo "nameserver ${SYS_NAMESERVER}"
    echo
    echo "# End /etc/resolv.conf"
}

gen-hostname()
{
    echo "HOSTNAME=${SYS_HOSTNAME}"
}

gen-hosts()
{
    echo "127.0.0.1 localhost"
}

gen-inittab()
{
    cat > /etc/inittab << "EOF"
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

ca:12345:ctrlaltdel:/sbin/shutdown -t1 -a -r now

su:S016:once:/sbin/sulogin

1:2345:respawn:/sbin/agetty --noclear tty1 9600
2:2345:respawn:/sbin/agetty tty2 9600
3:2345:respawn:/sbin/agetty tty3 9600
4:2345:respawn:/sbin/agetty tty4 9600
5:2345:respawn:/sbin/agetty tty5 9600
6:2345:respawn:/sbin/agetty tty6 9600

# End /etc/inittab
EOF
}

gen-sysconfig-clock()
{
    cat > /etc/sysconfig/clock << "EOF"
# Begin /etc/sysconfig/clock'

CLOCKPARAMS='--directisa'
UTC='yes'

# End /etc/sysconfig/clock
EOF
}

gen-linux-console()
{
    echo "# Begin /etc/sysconfig/console"
    echo
    echo "KEYMAP=\"${SYS_KEYMAP}\""
    echo "FONT=\"${SYS_FONT}\""
    echo
    echo "# End /etc/sysconfig/console"
}

gen-profile()
{
    echo "# Begin /etc/profile"
    echo
#   echo "export LANG=${SYS_LANG}_${SYS_COUNTRY}.${SYS_CHARMAP}"
    echo "export INPUTRC=/etc/inputrc"
    echo "export TMOUT=7200"
    echo "export PS1='[\u@\h] '"
    echo "export MANPATH=/usr/man:/usr/share/man:${LOCAL_DIR}/share/man:${LOCAL_DIR}/ssl/man"
    echo "export HISTCONTROL=ignoredups"
    echo
    echo "# End /etc/profile"
}

gen-inputrc()
{
    cat > /etc/inputrc << "EOF"
# Begin /etc/inputrc
# Modified by Chris Lynn <roryo@roryo.dynup.net>

# Allow the command prompt to wrap to the next line
set horizontal-scroll-mode Off

# Enable 8bit input
set meta-flag On
set input-meta On

# Turns off 8th bit stripping
set convert-meta Off

# Keep the 8th bit for display
set output-meta On

# none, visible or audible
set bell-style none

# All of the following map the escape sequence of the value
# contained in the 1st argument to the readline specific functions
"\eOd": backward-word
"\eOc": forward-word

# for linux console
"\e[1~": beginning-of-line
"\e[4~": end-of-line
"\e[5~": beginning-of-history
"\e[6~": end-of-history
"\e[3~": delete-char
"\e[2~": quoted-insert

# for xterm
"\eOH": beginning-of-line
"\eOF": end-of-line

# for Konsole
"\e[H": beginning-of-line
"\e[F": end-of-line

# End /etc/inputrc
EOF
}

gen-shells()
{
    cat > /etc/shells << "EOF"
# Begin /etc/shells

/bin/sh
/bin/bash

# End /etc/shells
EOF
}

gen-etc-fstab()
{
    echo "# Begin /etc/fstab"
    echo
    echo "# file-system mount-point type options dump fsck-order"
    echo
    echo "/dev/${SYS_DEVICE}${SYS_DEVICE_PART} / ext4 defaults 1 1"
    echo
    echo "proc /proc proc nosuid,noexec,nodev 0 0"
    echo "sysfs /sys sysfs nosuid,noexec,nodev 0 0"
    echo "devpts /dev/pts devpts gid=5,mode=620 0 0"
    echo "tmpfs /run tmpfs defaults 0 0"
    echo "devtmpfs /dev devtmpfs mode=0755,nosuid 0 0"
    echo
    echo "/dev/${SYS_SWAP_DEVICE} swap swap pri=1 0 0"
    echo
    echo "# End /etc/fstab"
}

gen-grub1()
{
    test -n "${1}" || return 1
    local system=${1}

    local sys_device_hd=$[${SYS_DEVICE_HD} - 1]
    
    echo "menuentry \"LFS 7.4\" {"
    echo "insmod ext2"
    echo "set root=(hd${sys_device_hd},${SYS_DEVICE_PART})"
    echo "linux /boot/kernel-${system} ro root=/dev/ram0 ramdisk=${SYS_RAMDISK_SIZE} init=/linuxrc"
    echo "initrd /boot/initrd-${system}.img"
    echo "}"
}

gen-grub()
{
    echo "# Begin /boot/grub/grub.cfg"
    echo
    echo "set default=0"
    echo "set timeout=15"

    case ${SYS_ARCHITECTURE} in
	x86_64)
	    echo
	    gen-grub1 ${SYS_VERSION}-${SYS_64_NAME}
	    ;;
	*)
	    gen-grub1 ${SYS_VERSION}-${SYS_HM_NAME}
	    ;;
    esac

    echo
    echo  "# End /boot/grub/grub.cfg"
}

gen-os-release()
{
    echo 11.1-rc1 > /etc/lfs-release

    cat > /etc/lsb-release << "EOF"
DISTRIB_ID="Linux From Scratch"
DISTRIB_RELEASE="11.1-rc1"
DISTRIB_CODENAME="Appliance"
DISTRIB_DESCRIPTION="Linux From Scratch"
EOF

    cat > /etc/os-release << "EOF"
NAME="Linux From Scratch"
VERSION="11.1-rc1"
ID=lfs
PRETTY_NAME="Linux From Scratch 11.1-rc1"
VERSION_CODENAME="Appliance"
EOF
}


# Main()

set-lfs-env
gen-ifconfig > /etc/sysconfig/ifconfig.eth0
gen-resolv > /etc/resolv.conf
gen-hostname > /etc/sysconfig/network
gen-hosts > /etc/hosts
gen-inittab
gen-sysconfig-clock
gen-linux-console > /etc/sysconfig/console
gen-profile > /etc/profile
gen-inputrc
gen-shells
gen-etc-fstab > /etc/fstab
mkdir -p /boot/grub
install -d -m 700 -o root -g root /boot/efi
gen-grub > /boot/grub/grub.cfg
gen-os-release
