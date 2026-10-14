#!/bin/bash

###########################################################################
#
# MODULE:       Build
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

test -n "${APL}" || exit 1
test -d "${APL}" || exit 2

source CacheGuard.env

gen-apl-bash()
{
    local dir=LoginScripts
    cat ${dir}/apl_bash-1
    echo
    echo "source ${APPLIANCE_DIR}/etc/constant"
    echo "source ${APPLIANCE_DIR}/etc/role"
    echo "source ${APPLIANCE_DIR}/lib/lib-usage"
    echo "source /${HARD_RDIR}/cloud.conf"

    cat <<EOF

ilogin-usage-message()
{
    test \${USER} == ${ADMIN_NAME} || return 0
    test \${TERM} == ${WADMIN_TERM} || print-usage-message ${TRIAL_PERIOD} ${TRIAL_PERIOD_MARGIN} ${INSTALL_DATE} ${VARIATION_DATE} ${SERIAL_DATE} ${RENEW_DAYS} ${LICENSE_PERIOD} ${LICENSE_PERIOD_MARGIN_1}
}

export __BATCH_MODE=''
apl_bash-main "\${@}"
EOF
}

install-php-scripts()
{
    local script

    for script in PHP/*.php
    do
	sudo install -m 644 -o root -g root ${script} ${APL}${APPLIANCE_PHP_DIR}/
    done
}

install-command-scripts()
{
    local script len

    for script in CommandScripts/apl_*
    do
	len=${#script}
	((len--))
	test ${script:${len}:1} != "~" || continue
	sudo install -m 755 -o root -g root ${script} ${APL}${LOCAL_DIR}/bin
    done

    sudo install -m 400 -o root -g root CommandScripts/apl_verify_usage ${APL}${LOCAL_DIR}/sbin/.sanity
}

install-daemon-scripts()
{
    local script len

    for script in DaemonScripts/*
    do
	len=${#script}
	((len--))
	test ${script:${len}:1} != "~" || continue
	sudo install -m 755 -o root -g root ${script} ${APL}${LOCAL_DIR}/bin
    done
}

install-network-scripts()
{
    local file dir=NetworkScripts

    for file in link-802-3ad link-802-1q ipv4-dhcp ipv4-pppoe
    do
	sudo install -m 754 -o root -g root ${dir}/${file} ${APL}/lib/services/${file}
    done

    for file in apl_dhclient apl_pppoe_up apl_pppoe_down
    do
	sudo install -m 755 -o root -g root ${dir}/${file} ${APL}${LOCAL_DIR}/bin/${file}
    done

    sudo install -m 755 -o root -g root ${dir}/dhclient-script ${APL}/sbin/dhclient-script

    sudo install -m 644 -o root -g root ${dir}/dhclient-functions ${APL}${ETC_DHCP_DIR}
    sudo install -m 644 -o root -g root ${dir}/dhclient-enter-hooks ${APL}${LOCAL_DIR}/etc
    sudo install -m 644 -o root -g root ${dir}/dhclient-exit-hooks ${APL}${LOCAL_DIR}/etc
}

install-login-scripts()
{
    local dir=LoginScripts

    sudo install -m 755 -o root -g root ${GENERATED_DIR}/apl_bash ${APL}${USR_BIN_DIR}
    sudo install -m 755 -o root -g root ${dir}/apl_chroot_bash ${APL}${LOCAL_DIR}/bin
    sudo install -m 755 -o root -g root ${dir}/apl_serial_login ${APL}${LOCAL_DIR}/bin
}

install-etc-scripts()
{
    local dir=EtcScripts

    sudo install -m 755 -o root -g root ${dir}/apl_sni_guard ${APL}${PROXY_DIR}/bin
}

# Main()

mkdir -p ${FULL_GENERATED_DIR}
ln -sf ${FULL_GENERATED_DIR}

gen-apl-bash > ${GENERATED_DIR}/apl_bash

install-php-scripts
install-command-scripts
install-daemon-scripts
install-network-scripts
install-login-scripts
install-etc-scripts
