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

test -n "${APL}" || exit 1
test -d "${APL}" || exit 2

source CacheGuard.env

gen-profile()
{
    local com link
    local license=${APPLIANCE_DIR}/man/man1/license.1

    cat top-profile

    cat <<EOF

first-startup-license()
{
    test \${USER} == ${ADMIN_NAME} || return 0
    test -f /${HARD_DIR_NAME}/${FIRST_STARTUP} || return 1

    local action
    read action < /${HARD_DIR_NAME}/${FIRST_STARTUP}
    test "\${action}" == license || return 0

    PATH=/bin man -r 'Press <SPACE> to continue or <Q> to Quit' ${license}
    echo -n "Do you accept the terms of the ${COMMERCIAL_NAME}-OS License (Y|N) [Y]? "
    local response
    read response
    test -z "\${response}" -o "\${response}" == y -o "\${response}" == Y || logout

    echo setup > /${HARD_DIR_NAME}/${FIRST_STARTUP}
}

first-login-password()
{
    test -f \${HOME}/${FIRST_LOGIN} || return 0

    echo 'You are invited to modify your password. A valid password is between 16 and 32 characters long and contains at least one lowercase char, one uppercase char, one digit and one special sign of !@#%.$&*-.'

    while true
    do
	password login
	test \${?} -ne 0 || break
    done
}

first-login-2fa()
{
    test \${USER} != ${ADMIN_NAME} || return 0

    local mfa_enabled=\$(admin internal 2fa-is-enabled)

    if test \${mfa_enabled} == yes ; then
        local mfa_initialised=\$(admin internal 2fa-is-initialised)
        test \${mfa_initialised} == yes || admin internal 2fa-initialise
    fi
}

update-google-authenticator()
{
    test \${USER} != ${ADMIN_NAME} || return 0
    test \${TERM} != ${WADMIN_TERM} || return 0

    admin internal 2fa-revert-copy-conf
}

first-startup-setup()
{
    test \${USER} == ${ADMIN_NAME} || return 0
    test -f /${HARD_DIR_NAME}/${FIRST_STARTUP} || return 1

    local action
    read action < /${HARD_DIR_NAME}/${FIRST_STARTUP}
    test "\${action}" == setup || return 0

    setup
}

EOF

    for com in bin/*
    do
	test ! -L ${com} || continue
	com=${com/bin\/}
	echo "source /etc/profile.d/${com}"	
    done

    echo

    for com in bin/*
    do
	if test -L ${com} ; then
	    link=$(readlink ${com})
	    com=${com/bin\/}
	    echo "complete -F __complete-${link} ${com}"
	else
	    com=${com/bin\/}
	    echo "complete -F __complete-${com} ${com}"
	fi
    done

    echo "complete -F __complete-help ?"
    echo
    echo "export PATH=${APPLIANCE_DIR}/bin:${APPLIANCE_DIR}/lib"
    echo "WADMIN_TERM=${WADMIN_TERM}"
    echo "export PS1='\${USER}@\$(prompt)> '"

    cat bottom-profile
}

gen-functions()
{
    sed \
	-e "s@#APPLIANCE_DIR#@${APPLIANCE_DIR}@g" \
	functions-template
}

gen-prompt()
{
    sed \
	-e "s@#APPLIANCE_DIR#@${APPLIANCE_DIR}@g" \
	prompt-template
}

get-admin-passwd-sha1()
{
    local password

    sha1=$(echo ${password} | openssl dgst -sha1 2> /dev/null)
    echo ${sha1}
}

main()
{
    local com lib apl profile len link

    get-admin-passwd-sha1 > ${GENERATED_DIR}/admin.password.sha1
    gen-profile > ${GENERATED_DIR}/profile
    gen-functions > ${GENERATED_DIR}/functions
    gen-prompt > ${GENERATED_DIR}/prompt

    sudo install -m 600 -o ${ADMIN_UID} -g ${USERS_GID} ${GENERATED_DIR}/admin.password.sha1 ${APL}${ABASE_DIR}/.passwd.sha1
    sudo install -m 600 -o ${ADMIN_UID} -g ${USERS_GID} ${GENERATED_DIR}/admin.password.sha1 ${APL}${ABASE_DIR}/.htpasswd.sha1
    sudo install -d 555 -o root -g root ${APL}${ETC_DIR}/profile.d
    sudo install -m 444 -o root -g root ${GENERATED_DIR}/profile ${APL}${ETC_DIR}/profile
    sudo install -m 444 -o root -g root inputrc ${APL}${ETC_DIR}/inputrc
    
    for com in bin/*
    do
	if test -L ${com} ; then
	    link=$(readlink ${com})
	    sudo ln -sf ${link} ${APL}${ADMIN_DIR}${APPLIANCE_DIR}/${com}
	else
	    len=${#com} ; ((len--))
	    test ${com:${len}:1} != "~" || continue
	    profile=${com/bin\/}

	    sudo install -m 550 -o ${ADMIN_UID} -g ${USERS_GID} ${com} ${APL}${ADMIN_DIR}${APPLIANCE_DIR}/bin
	    sudo install -m 444 -o root -g root profile/${profile} ${APL}${ETC_DIR}/profile.d
	fi
    done

    sudo install -m 550 -o ${ADMIN_UID} -g ${USERS_GID} ${GENERATED_DIR}/prompt ${APL}${ADMIN_DIR}${APPLIANCE_DIR}/bin
    sudo ln -sf help ${APL}${ADMIN_DIR}${APPLIANCE_DIR}/bin/?

    for lib in lib/* ${GENERATED_DIR}/functions
    do
	len=${#lib} ; ((len--))
	test ${lib:${len}:1} != "~" || continue
	sudo install -m 444 -o ${ADMIN_UID} -g ${USERS_GID} ${lib} ${APL}${ADMIN_DIR}${APPLIANCE_DIR}/lib
    done

    for apl in apl/apl_*
    do
	len=${#apl} ; ((len--))
	test ${apl:${len}:1} != "~" || continue
	sudo install -m 550 -o ${ADMIN_UID} -g ${USERS_GID} ${apl} ${APL}${ADMIN_DIR}${LOCAL_DIR}/bin
    done
}

# Main()

mkdir -p ${FULL_GENERATED_DIR}
ln -sf ${FULL_GENERATED_DIR}

main
