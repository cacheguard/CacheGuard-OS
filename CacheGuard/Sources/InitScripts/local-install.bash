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
source /tmp/INITSCRIPTS.env

source ${CACHEGUARD_DIR}/constant
source ${APPLIANCE_DIR}/etc/role
source ${ABASE_DIR}/${ENV_RDIR}/${ENV_NAME}

member()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 1

    local list=${1}
    local elt=${2} e

    for e in ${list} ; do
	test ${e} != ${elt} || return 0
    done
    return 1
}

del-links()
{
    local level
    local script
    for level in 0 3 6
    do
	cd /etc/rc.d/rc${level}.d
	
	for script in ${SCRIPTS} in
	do
	    rm -f *${script}
	done
    done

    for level in 1 2 4 5
    do
	rm -f /etc/rc.d/rc${level}.d/*
    done

    rm -f /etc/rc.d/rcS.d/*ethernet
    rm -f /etc/rc.d/rcS.d/*lvm
    rm -f /etc/rc.d/rcS.d/*hardware
}

add-link()
{
    local level self_dns

    if test ${DNS_MODE} == True ; then
	self_dns=yes
    else
	! member "${NAME_SERVER_LIST}" "127.0.0.1" || self_dns=yes
    fi

    ####### Stop Part #######
    for level in 0 6
    do
	cd /etc/rc.d/rc${level}.d

	ln -sf ../init.d/health K02health
	ln -sf ../init.d/path _K02path
	ln -sf ../init.d/jobs K03jobs
	ln -sf ../init.d/mdadm K04mdadm

	if test ${ADMIN_SNMP} == True ; then
	    ln -sf ../init.d/snmpd K06snmpd
	else
	    ln -sf ../init.d/snmpd _K06snmpd
	fi

	ln -sf ../init.d/statistics K08statistics
	ln -sf ../init.d/acpid K10acpid
	ln -sf ../init.d/anacron K14anacron
	ln -sf ../init.d/crond K16crond

	if test ${HA_MODE} == True ; then
	    ln -sf ../init.d/keepalived K18keepalived
	else
	    ln -sf ../init.d/keepalived _K18keepalived
	fi

	if test ${RWEB_MODE} == True -a ${CACHE_MODE} == True -a ${WAF_MODE} == True ; then
	    ln -sf ../init.d/htcacheclean K22htcacheclean
	else
	    ln -sf ../init.d/htcacheclean _K22htcacheclean
	fi

	ln -sf ../init.d/squid K24squid
	ln -sf ../init.d/httpd K25httpd
	ln -sf ../init.d/slapd _K28slapd

	if test ${AV_MODE} == True ; then
	    ln -sf ../init.d/c-icap K30c-icap
	    ln -sf ../init.d/clamd K32clamd
	    ln -sf ../init.d/freshclam K34freshclam
	else
	    ln -sf ../init.d/c-icap _K30c-icap
	    ln -sf ../init.d/clamd _K32clamd
	    ln -sf ../init.d/freshclam _K34freshclam
	fi

	if test ${ADMIN_WADMIN} == True ; then
	    ln -sf ../init.d/${WADMIND_NAME} K40${WADMIND_NAME}
	else
	    ln -sf ../init.d/${WADMIND_NAME} _K40${WADMIND_NAME}
	fi

	if test ${ADMIN_SSH} == True ; then
	    ln -sf ../init.d/sshd K42sshd
	else
	    ln -sf ../init.d/sshd _K42sshd
	fi

	if test ${DHCP_MODE} == True ; then
	    ln -sf ../init.d/dhcpd K50dhcpd
	else
	    ln -sf ../init.d/dhcpd _K50dhcpd
	fi

	if test -n "${NTP_SERVER_LIST}" ; then
	    ln -sf ../init.d/ntpd K52ntpd
	else
	    ln -sf ../init.d/ntpd _K52ntpd
	fi

	if test -n "${self_dns}" ; then
	    ln -sf ../init.d/named K54named
	else
	    ln -sf ../init.d/named _K54named
	fi

	ln -sf ../init.d/iked _K70iked

	if test ${OCSP_MODE} == True ; then
	    ln -sf ../init.d/ocspd K74ocspd
	else
	    ln -sf ../init.d/ocspd _K74ocspd
	fi

	if test ${MANAGER_SYNC_ROLE} == True ; then
	    ln -sf ../init.d/smanager K76smanager
	else
	    ln -sf ../init.d/smanager _K76smanager
	fi

	ln -sf ../init.d/tc K78tc
	ln -sf ../init.d/cloud-network K82cloud-network
	ln -sf ../init.d/iptables K84iptables
	ln -sf ../init.d/waagent K86waagent
	ln -sf ../init.d/smartd K88smartd
	ln -sf ../init.d/rlogger _K89rlogger
	ln -sf ../init.d/supervisor K94supervisor
	ln -sf ../init.d/lcd4linux K95lcd4linux

	ln -sf ../init.d/lvm S71lvm
    done

    ### Start Part ###

    cd /etc/rc.d/rcS.d
    ln -sf ../init.d/ethernet S12ethernet
    ln -sf ../init.d/lvm S06lvm
    ln -sf ../init.d/hardware S92hardware

    cd /etc/rc.d/rc3.d
    ln -sf ../init.d/cloud-network S02cloud-network
    ln -sf ../init.d/waagent S04waagent
    ln -sf ../init.d/cloud-init S06cloud-init
    ln -sf ../init.d/appliance S08appliance
    ln -sf ../init.d/rlogger _S11rlogger
    ln -sf ../init.d/smartd S12smartd
    ln -sf ../init.d/iptables S14iptables
    ln -sf ../init.d/tc S24tc

    if test ${MANAGER_SYNC_ROLE} == True ; then
	ln -sf ../init.d/smanager S25smanager
    else
	ln -sf ../init.d/smanager _S25smanager
    fi

    if test ${OCSP_MODE} == True ; then
	ln -sf ../init.d/ocspd S26ocspd
    else
	ln -sf ../init.d/ocspd _S26ocspd
    fi

    ln -sf ../init.d/iked _S28iked

    if test -n "${self_dns}" ; then
	ln -sf ../init.d/named S34named
    else
	ln -sf ../init.d/named _S34named
    fi

    if test -n "${NTP_SERVER_LIST}" ; then
	ln -sf ../init.d/ntpd S36ntpd
    else
	ln -sf ../init.d/ntpd _S36ntpd
    fi

    if test ${DHCP_MODE} == True ; then
	ln -sf ../init.d/dhcpd S38dhcpd
    else
	ln -sf ../init.d/dhcpd _S38dhcpd
    fi

    if test ${ADMIN_SSH} == True ; then
	ln -sf ../init.d/sshd S46sshd
    else
	ln -sf ../init.d/sshd _S46sshd
    fi

    if test ${ADMIN_WADMIN} == True ; then
	ln -sf ../init.d/${WADMIND_NAME} S48${WADMIND_NAME}
    else
	ln -sf ../init.d/${WADMIND_NAME} _S48${WADMIND_NAME}
    fi

    if test ${AV_MODE} == True ; then
	ln -sf ../init.d/freshclam S60freshclam
	ln -sf ../init.d/clamd S62clamd
	ln -sf ../init.d/c-icap S64c-icap
    else
	ln -sf ../init.d/freshclam _S60freshclam
	ln -sf ../init.d/clamd _S62clamd
	ln -sf ../init.d/c-icap _S64c-icap
    fi

    ln -sf ../init.d/slapd _S66slapd
    ln -sf ../init.d/httpd S67httpd
    ln -sf ../init.d/squid S68squid

    if test ${RWEB_MODE} == True -a ${CACHE_MODE} == True -a ${WAF_MODE} == True ; then
	ln -sf ../init.d/htcacheclean S71htcacheclean
    else
	ln -sf ../init.d/htcacheclean _S71htcacheclean
    fi

    if test ${HA_MODE} == True ; then
	ln -sf ../init.d/keepalived S72keepalived
    else
	ln -sf ../init.d/keepalived _S72keepalived
    fi

    ln -sf ../init.d/crond S74crond
    ln -sf ../init.d/anacron S76anacron
    ln -sf ../init.d/acpid S78acpid
    ln -sf ../init.d/statistics S80statistics

    if test ${ADMIN_SNMP} == True ; then
	ln -sf ../init.d/snmpd S92snmpd
    else
	ln -sf ../init.d/snmpd _S92snmpd
    fi

    ln -sf ../init.d/mdadm S94mdadm
    ln -sf ../init.d/jobs S95jobs
    ln -sf ../init.d/lcd4linux S95lcd4linux
    ln -sf ../init.d/supervisor S96supervisor
    ln -sf ../init.d/health S97health
    ln -sf ../init.d/path _S97path
    ln -sf ../init.d/embedded S98embedded
    ln -sf ../init.d/cloud-provision S99cloud-provision
}

# Main()

del-links
add-link
