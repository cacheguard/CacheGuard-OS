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

test -n "${LFS}" || exit 1

source CacheGuard.env

DEVICE_ANDROID=0
DEVICE_APPLE=1
DEVICE_LINUX=2
DEVICE_WINDOWS=3
DEVICE_NONE=9

SETUP_STATE_INEXISTANT=0
SETUP_STATE_INITIALISED=1
SETUP_STATE_INIT_FAILED=2
SETUP_STATE_ACTIVATED=3
SETUP_STATE_MODIFIED=4
SETUP_STATE_FAILED=5
SETUP_STATE_RESET=6
SETUP_STATE_RESET_FAILED=7
SETUP_STATE_UNKNOWN=9

EMAIL_STATE_INEXISTANT=0
EMAIL_STATE_ACTIVATED=1
EMAIL_STATE_MODIFIED=2
EMAIL_STATE_FAILED=3
EMAIL_STATE_UNKNOWN=9

SUBSCRIBER_STATE_INACTIVE=0
SUBSCRIBER_STATE_ACTIVATED=1
SUBSCRIBER_STATE_2REACTIVATE=2
SUBSCRIBER_STATE_RESET=3 # Should be > SUBSCRIBER_STATE_2REACTIVATE and < SUBSCRIBER_STATE_2SUSPEND
SUBSCRIBER_STATE_2SUSPEND=4
SUBSCRIBER_STATE_SUSPENDED=5
SUBSCRIBER_STATE_2CANCEL=6
SUBSCRIBER_STATE_CANCELLED=7
SUBSCRIBER_STATE_UNKNOWN=9

SUCCESSFUL_OPERATION=0
FAILED_OPERATION=1

EMBEDDED_VPNSUBSCR_DIR=${WEB_SERVER_DIR}/${EMBEDDED_APPLICATIONS_NAME}/${EMBEDDED_VPNSUBSCR_NAME}
VPNSUBSCR_PROFILE_DIR=${EMBEDDED_VPNSUBSCR_DIR}/${EMBEDDED_VPNSUBSCR_PROFILE_DIR_NAME}

generate-menu()
{
    local line

    echo "function printmenu( )"
    echo "{"

    while read -r line
    do
	test -n "${line}" || continue;
        echo -e "\tdocument.write( '${line}' );"
    done < menu.html

    echo "}"
}

gen-apl_ea_vpnsubscr-env()
{
    local mode=${1}

    local debug

    case ${mode} in
	prod)
	    debug=no
	    ;;
	*)
	    debug=yes
	    ;;
    esac

    sed -e "s/@DEFAULT_COUNTRY_CODE@/${DEFAULT_COUNTRY_CODE}/g" apl_ea_vpnsubscr.env-1

    cat << EOT

VPNSUBSCR_VPN_TLS_ID=${EMBEDDED_VPNSUBSCR_CLI_NAME}-ipsec
VPNSUBSCR_RWEB_TLS_ID=${EMBEDDED_VPNSUBSCR_CLI_NAME}-rweb
VPNSUBSCR_HOSTNAME=${EMBEDDED_VPNSUBSCR_CLI_NAME}

VPNSUBSCR_TEST_MODE=${debug}

VPNSUBSCR_DEVICE_ANDROID=${DEVICE_ANDROID}
VPNSUBSCR_DEVICE_APPLE=${DEVICE_APPLE}
VPNSUBSCR_DEVICE_LINUX=${DEVICE_LINUX}
VPNSUBSCR_DEVICE_WINDOWS=${DEVICE_WINDOWS}
VPNSUBSCR_DEVICE_NONE=${DEVICE_NONE}

VPNSUBSCR_SETUP_STATE_INEXISTANT=${SETUP_STATE_INEXISTANT}
VPNSUBSCR_SETUP_STATE_INITIALISED=${SETUP_STATE_INITIALISED}
VPNSUBSCR_SETUP_STATE_INIT_FAILED=${SETUP_STATE_INIT_FAILED}
VPNSUBSCR_SETUP_STATE_ACTIVATED=${SETUP_STATE_ACTIVATED}
VPNSUBSCR_SETUP_STATE_MODIFIED=${SETUP_STATE_MODIFIED}
VPNSUBSCR_SETUP_STATE_FAILED=${SETUP_STATE_FAILED}
VPNSUBSCR_SETUP_STATE_RESET=${SETUP_STATE_RESET}
VPNSUBSCR_SETUP_STATE_RESET_FAILED=${SETUP_STATE_RESET_FAILED}
VPNSUBSCR_SETUP_STATE_UNKNOWN=${SETUP_STATE_UNKNOWN}

VPNSUBSCR_EMAIL_STATE_INEXISTANT=${EMAIL_STATE_INEXISTANT}
VPNSUBSCR_EMAIL_STATE_ACTIVATED=${EMAIL_STATE_ACTIVATED}
VPNSUBSCR_EMAIL_STATE_MODIFIED=${EMAIL_STATE_MODIFIED}
VPNSUBSCR_EMAIL_STATE_FAILED=${EMAIL_STATE_FAILED}
VPNSUBSCR_EMAIL_STATE_UNKNOWN=${EMAIL_STATE_UNKNOWN}

VPNSUBSCR_SUBSCRIBER_STATE_INACTIVE=${SUBSCRIBER_STATE_INACTIVE}
VPNSUBSCR_SUBSCRIBER_STATE_ACTIVATED=${SUBSCRIBER_STATE_ACTIVATED}
VPNSUBSCR_SUBSCRIBER_STATE_RESET=${SUBSCRIBER_STATE_RESET}
VPNSUBSCR_SUBSCRIBER_STATE_2SUSPEND=${SUBSCRIBER_STATE_2SUSPEND}
VPNSUBSCR_SUBSCRIBER_STATE_SUSPENDED=${SUBSCRIBER_STATE_SUSPENDED}
VPNSUBSCR_SUBSCRIBER_STATE_2REACTIVATE=${SUBSCRIBER_STATE_2REACTIVATE}
VPNSUBSCR_SUBSCRIBER_STATE_2CANCEL=${SUBSCRIBER_STATE_2CANCEL}
VPNSUBSCR_SUBSCRIBER_STATE_CANCELLED=${SUBSCRIBER_STATE_CANCELLED}
VPNSUBSCR_SUBSCRIBER_STATE_UNKNOWN=${SUBSCRIBER_STATE_UNKNOWN}

VPNSUBSCR_SUCCESSFUL_OPERATION=${SUCCESSFUL_OPERATION}
VPNSUBSCR_FAILED_OPERATION=${FAILED_OPERATION}

VPNSUBSCR_LOG_FILE=${WEB_LOG_DIR}/${EMBEDDED_VPNSUBSCR_NAME}.log
VPNSUBSCR_PROFILE_DIR=${VPNSUBSCR_PROFILE_DIR}
EOT
}

gen-constant-php-constant()
{
    local mode=${1}

    local debug

    case ${mode} in
	prod)
	    debug=FALSE
	    ;;
	*)
	    debug=TRUE
	    ;;
    esac

    cat <<EOT
/*
###########################################################################
#
# MODULE:       VPN Subscription
# AUTHOR(S):    CacheGuard Development Team
# COPYRIGHT:    (C) ${YEARS} by CacheGuard Technologies Ltd
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
*/

EOT
    echo "define( 'DEBUG_MODE', ${debug} );"
    echo "define( 'YEARS', '${YEARS}' );"
    echo "define( 'COMPANY', '${COMPANY_NAME}' );"
    cat constant.php-constant-1
    cat <<EOT

define( 'COMMERCIAL_NAME', '${EMBEDDED_VPNSUBSCR_COMMERCIAL_NAME}' );

define( 'DEVICE_ANDROID', ${DEVICE_ANDROID} );
define( 'DEVICE_APPLE', ${DEVICE_APPLE} );
define( 'DEVICE_LINUX', ${DEVICE_LINUX} );
define( 'DEVICE_WINDOWS', ${DEVICE_WINDOWS} );
define( 'DEVICE_NONE', ${DEVICE_NONE} );

define( 'SETUP_STATE_INEXISTANT', ${SETUP_STATE_INEXISTANT} );
define( 'SETUP_STATE_INITIALISED', ${SETUP_STATE_INITIALISED} );
define( 'SETUP_STATE_INIT_FAILED', ${SETUP_STATE_INIT_FAILED} );
define( 'SETUP_STATE_ACTIVATED', ${SETUP_STATE_ACTIVATED} );
define( 'SETUP_STATE_MODIFIED', ${SETUP_STATE_MODIFIED} );
define( 'SETUP_STATE_FAILED', ${SETUP_STATE_FAILED} );
define( 'SETUP_STATE_RESET', ${SETUP_STATE_RESET} );
define( 'SETUP_STATE_RESET_FAILED', ${SETUP_STATE_RESET_FAILED} );
define( 'SETUP_STATE_UNKNOWN', ${SETUP_STATE_UNKNOWN} );

define( 'EMAIL_STATE_INEXISTANT', ${EMAIL_STATE_INEXISTANT} );
define( 'EMAIL_STATE_ACTIVATED', ${EMAIL_STATE_ACTIVATED} );
define( 'EMAIL_STATE_MODIFIED', ${EMAIL_STATE_MODIFIED} );
define( 'EMAIL_STATE_FAILED', ${EMAIL_STATE_FAILED} );
define( 'EMAIL_STATE_UNKNOWN', ${EMAIL_STATE_UNKNOWN} );

define( 'SUBSCRIBER_STATE_INACTIVE', ${SUBSCRIBER_STATE_INACTIVE} );
define( 'SUBSCRIBER_STATE_ACTIVATED', ${SUBSCRIBER_STATE_ACTIVATED} );
define( 'SUBSCRIBER_STATE_RESET', ${SUBSCRIBER_STATE_RESET} );
define( 'SUBSCRIBER_STATE_2SUSPEND', ${SUBSCRIBER_STATE_2SUSPEND} );
define( 'SUBSCRIBER_STATE_SUSPENDED', ${SUBSCRIBER_STATE_SUSPENDED} );
define( 'SUBSCRIBER_STATE_2REACTIVATE', ${SUBSCRIBER_STATE_2REACTIVATE} );
define( 'SUBSCRIBER_STATE_2CANCEL', ${SUBSCRIBER_STATE_2CANCEL} );
define( 'SUBSCRIBER_STATE_CANCELLED', ${SUBSCRIBER_STATE_CANCELLED} );
define( 'SUBSCRIBER_STATE_UNKNOWN', ${SUBSCRIBER_STATE_UNKNOWN} );

define( 'SUCCESSFUL_OPERATION', ${SUCCESSFUL_OPERATION} );
define( 'FAILED_OPERATION', ${FAILED_OPERATION} );

define( 'TWO_FACTOR_AUTHENTICATION_STEP_SIZE', ${TWO_FACTOR_AUTHENTICATION_STEP_SIZE} );
define( 'TWO_FACTOR_AUTHENTICATION_WINDOW_SIZE', ${TWO_FACTOR_AUTHENTICATION_WINDOW_SIZE} );
EOT
}

pack-site()
{
    local local_dir=$(pwd)
    local name=${EMBEDDED_VPNSUBSCR_NAME}

    rm -rf ${GENERATED_DIR}/${name} &&
	mkdir -p ${GENERATED_DIR}/${name} &&
	cp -rfL {html/*.html,php/*.php,*.css,js,doc/*.html} ${GENERATED_DIR}/${name} &&
	mkdir -p ${GENERATED_DIR}/${name}/image &&
	cp -f doc/image/* ${GENERATED_DIR}/${name}/image &&
	find image -type f -exec cp -f {} ${GENERATED_DIR}/${name}/image \; &&
	cp -fL ${GENERATED_DIR}/*.js ${GENERATED_DIR}/${name}/js || return 11

    cd ${GENERATED_DIR} &&
	tar --owner=0 --group=0 -cf ${name}.tar ${name} &&
	rm -f ${name}.tar.gz &&
	gzip ${name}.tar &&
	cd ${local_dir}
}

install-doc()
{
    sudo mkdir -p ${EMBEDDED_VPNSUBSCR_NET_DOC_DIR}/image

    sudo install -m 644 -o root -g root style.css ${EMBEDDED_VPNSUBSCR_NET_DOC_DIR}
    sudo install -m 644 -o root -g root doc/*.html ${EMBEDDED_VPNSUBSCR_NET_DOC_DIR}
    sudo install -m 644 -o root -g root doc/image/* ${EMBEDDED_VPNSUBSCR_NET_DOC_DIR}/image
}

install-files()
{
    sudo install -m 755 -o root -g root -d ${APL}${VPNSUBSCR_PROFILE_DIR}
    sudo install -m 644 -o root -g root profile.htaccess ${APL}${VPNSUBSCR_PROFILE_DIR}/.htaccess
    sudo install -m 644 -o root -g root image.htaccess ${APL}${EMBEDDED_VPNSUBSCR_DIR}/${IMAGE_DIR_NAME}/.htaccess

    sudo install -m 644 -o root -g root ${EMBEDDED_VPNSUBSCR_DB_SCHEMA} ${APL}${DB_SCHEMA_DIR}
}

local-install()
{
    local name=${EMBEDDED_VPNSUBSCR_NAME}
    local file

    sudo install -m 644 -o root -g root CacheGuard.env ${APL}/tmp/
    sudo install -m 755 -o root -g root local-install.bash ${APL}/tmp/

    for file in lib/apl_ea_vpnsubscr_*
    do
	sudo install -m 644 -o root -g root ${file} ${APL}${LOCAL_DIR}/lib
    done
    sudo install -m 644 -o root -g root ${GENERATED_DIR}/apl_ea_vpnsubscr.env ${APL}${LOCAL_DIR}/lib

    for file in bin/apl_ea_vpnsubscr_*
    do
	sudo install -m 755 -o root -g root ${file} ${APL}${LOCAL_DIR}/bin
    done

    sudo install -m 644 -o root -g root ${GENERATED_DIR}/constant.php-constant ${APL}${CONF_DIR}/constant.php-constant

    sudo install -m 644 -o root -g root ${GENERATED_DIR}/${name}.tar.gz ${APL}/tmp/${name}.tar.gz
    sudo install -m 644 -o root -g root ${EMBEDDED_VPNSUBSCR_DB_SCHEMA} ${APL}/tmp/${EMBEDDED_VPNSUBSCR_DB_SCHEMA}

    sudo chroot ${APL} /tmp/local-install.bash
    sudo rm -f \
	 ${APL}/tmp/CacheGuard.env \
	 ${APL}/tmp/local-install.bash \
	 ${APL}/tmp/${name}.tar.gz \
	 ${APL}/tmp/${EMBEDDED_VPNSUBSCR_DB_SCHEMA}
}

main()
{
    generate-menu "${@}" > ${GENERATED_DIR}/printmenu.js
    gen-apl_ea_vpnsubscr-env "${@}" > ${GENERATED_DIR}/apl_ea_vpnsubscr.env
    gen-constant-php-constant "${@}" > ${GENERATED_DIR}/constant.php-constant
    pack-site
    install-doc
    local-install
    install-files
}

# Main()

mkdir -p ${FULL_GENERATED_DIR}
ln -sf ${FULL_GENERATED_DIR}
main "${@}"
