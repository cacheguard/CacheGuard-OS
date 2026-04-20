#!/bin/bash

test -n "${APL}" || exit 1
test -d "${APL}" || exit 2

source CacheGuard.env

gen-current-userenv()
{
    local export assertion

    local variables_name="USERENV_VARS"
    local len_variables_name=${#variables_name}
    local current_variables

    while read export assertion
    do
	test -n "${export}" || continue
	test ${assertion:0:${len_variables_name}} != ${variables_name} || continue
	echo "export CURRENT_${assertion}"
	current_variables="${current_variables} CURRENT_${assertion/=*}"
    done < ${GENERATED_DIR}/userenv

    test -z "${current_variables}" || current_variables=${current_variables:1}
    echo "export CURRENT_USERENV_VARS='${current_variables}'"
}

gen-userenv-0()
{
    local domain="example.com"
    local email="${TECHNICAL_NAME}@${domain}"

    echo "export DOMAIN_NAME='${domain}'"
    echo "export ADMINISTRATOR_EMAIL='${email}'"
    echo "export ADMINISTRATOR_NAME='${COMMERCIAL_NAME} Administrator'"
    echo "export EMAIL_ACCOUNT_SERVER_FQDN=''"
    echo "export EMAIL_ACCOUNT_SERVER_PORT='587'"
    echo "export EMAIL_ACCOUNT_USERNAME='${email}'"
    echo "export EMAIL_ACCOUNT_PASSWORD=''"
}

gen-userenv-2()
{
    local secret=${DEFAULT_CA_CN// }${YEARS/*-}

    echo "export SNMP_USER='${ADMIN_NAME}'"
    echo "export SNMP_COMMUNITY='${secret}'"
    echo "export SNMP_PRIVACY='${secret}'"

    case ${TEST_ROLE} in
	gateway)
	    echo "export BOND_INTERNALS='eth${IF_INTERNAL_NUM}'"
	    echo "export BOND_EXTERNALS='eth${IF_EXTERNAL_NUM}'"
	    ;;
	manager)
	    echo "export BOND_INTERNALS='eth0'"
	    echo "export BOND_EXTERNALS=''"
	    ;;
	*)
	    ;;
    esac

    echo "export BOND_AUXILIARIES=''"

    echo "export SHOSTNAME='${TECHNICAL_NAME}'"
    echo "export WAF_FILES_SIZE='${MAX_UPLOAD_FILE_SZ}'"
}

gen-userenv-vars1()
{
    local export assertion
    local variable assertions

    while read export assertion
    do
	variable=${assertion/=*/}
	assertions="${assertions} ${variable}"
    done < ${1}
    test -z "${assertions}" || echo -n "${assertions:1}"
}

gen-userenv-vars()
{
    echo -n "export USERENV_VARS='"
    gen-userenv-vars1 ${1}
    echo "'"
}

gen-userenv()
{
    gen-userenv-0				 > ${GENERATED_DIR}/userenv
    cat userenv-1				>> ${GENERATED_DIR}/userenv
    gen-userenv-2				>> ${GENERATED_DIR}/userenv

    local tmp_userenv=/tmp/userenv.${$}
    gen-userenv-vars ${GENERATED_DIR}/userenv	 > ${tmp_userenv}

    cat ${tmp_userenv} 				>> ${GENERATED_DIR}/userenv
    rm -f ${tmp_userenv}
}

gen-apl_functions()
{
    local lib name len

    echo "#!/bin/bash"
    echo
    cat header
    echo
    echo "CACHEGUARD_DIR=${CACHEGUARD_DIR}"
    echo
    echo 'source ${CACHEGUARD_DIR}/constant'
    echo 'source ${APPLIANCE_DIR}/etc/role'
    echo 'source ${HARD_DIR}/model.conf'
    echo 'source ${HARD_DIR}/cloud.conf'
    echo 'source ${APPLIANCE_DIR}/lib/lib-interface'
    echo 'source ${APPLIANCE_DIR}/lib/lib-openssl'
    echo 'source ${APPLIANCE_DIR}/lib/lib-2fa'
    echo

    for lib in lib/*
    do
	name=$(basename ${lib})
	len=${#name} ; ((len--))
	test "${name:${len}}" != "~" || continue
	test "${name:0:1}" != "#" || continue

	name=${name^^}
	echo "test -n \"\${LIB_${name}}\" || source ${LOCAL_DIR}/${lib}"
    done
}

local-install()
{
    sudo install -m 755 -o root -g root local-install.bash ${APL}/tmp
    sudo install -m 644 -o root -g root CacheGuard.env ${APL}/tmp

    sudo mount -t proc proc ${APL}/proc
    sudo chroot ${APL} /tmp/local-install.bash
    sudo umount ${APL}/proc

    sudo rm -f  \
	 ${APL}/tmp/CacheGuard.env \
	 ${APL}/tmp/local-install.bash
}

reset-htpasswd()
{
    sudo rm -f ${APL}${HARD_DIR}/.htpasswd
    sudo touch ${APL}${HARD_DIR}/.htpasswd
}

install-files()
{
    local lib bin

    sudo install -d -m 755 -o ${ADMIN_UID} -g ${USERS_GID} ${APL}${ABASE_DIR}/${ENV_RDIR}

    sudo install -m 644 -o ${ADMIN_UID} -g ${USERS_GID} ${GENERATED_DIR}/userenv ${APL}${ABASE_DIR}/${ENV_RDIR}/${ENV_NAME}
    sudo install -m 644 -o ${ADMIN_UID} -g ${USERS_GID} ${GENERATED_DIR}/userenv ${APL}${ABASE_DIR}/${ENV_RDIR}/${ENV_CANCEL_NAME}
    sudo install -m 644 -o ${ADMIN_UID} -g ${USERS_GID} ${GENERATED_DIR}/current-userenv ${APL}${ABASE_DIR}/${ENV_RDIR}/${ENV_CURRENT_NAME}

    sudo install -m 444 -o ${ADMIN_UID} -g ${USERS_GID} ${GENERATED_DIR}/userenv ${APL}${SAVE_DIR}/${ENV_FACTORY_NAME}.gateway
    sudo install -m 444 -o ${ADMIN_UID} -g ${USERS_GID} ${GENERATED_DIR}/current-userenv ${APL}${SAVE_DIR}/${ENV_CURRENT_FACTORY_NAME}.gateway

    for lib in lib/apl_*
    do
	len=${#lib} ; ((len--))
	test "${lib:${len}}" != "~" || continue
	sudo install -m 444 -o root -g root ${lib} ${APL}${LOCAL_DIR}/lib
    done

    for bin in sbin/apl_*
    do
	len=${#bin} ; ((len--))
	test "${bin:${len}}" != "~" || continue
	sudo install -m 755 -o root -g root ${bin} ${APL}${LOCAL_DIR}/sbin
    done

    sudo install -m 444 -o root -g root ${GENERATED_DIR}/apl_functions ${APL}${LOCAL_DIR}/lib

    sudo install -m 644 -o root -g root ${VPN_IPSEC_ACCESS_DB_SCHEMA} ${APL}${DB_SCHEMA_DIR}
    sudo install -m 644 -o root -g root ${CONFIGURATION_DB_SCHEMA} ${APL}${DB_SCHEMA_DIR}
}

# Main()

mkdir -p ${FULL_GENERATED_DIR}
ln -sf ${FULL_GENERATED_DIR}

gen-userenv

gen-current-userenv > ${GENERATED_DIR}/current-userenv
gen-apl_functions > ${GENERATED_DIR}/apl_functions

reset-htpasswd
install-files
local-install
