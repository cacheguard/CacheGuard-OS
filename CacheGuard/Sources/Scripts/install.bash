#!/bin/bash

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
    local dir=NetworkScripts

    sudo install -m 754 -o root -g root ${dir}/link-802-3ad ${APL}/lib/services/link-802-3ad
    sudo install -m 754 -o root -g root ${dir}/link-802-1q ${APL}/lib/services/link-802-1q
    sudo install -m 755 -o root -g root ${dir}/dhclient-script ${APL}/sbin/dhclient-script
}

install-login-scripts()
{
    local dir=LoginScripts

    sudo install -m 755 -o root -g root ${GENERATED_DIR}/apl_bash ${APL}${USR_BIN_DIR}/apl_bash
    sudo install -m 755 -o root -g root ${dir}/apl_chroot_bash ${APL}${LOCAL_DIR}/bin
    sudo install -m 755 -o root -g root ${dir}/apl_serial_login ${APL}${LOCAL_DIR}/bin
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
