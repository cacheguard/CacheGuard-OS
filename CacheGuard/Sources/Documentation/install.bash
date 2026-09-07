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
source WorkFunctions

install-javascript()
{
    local file name

    for file in JS/*.js ; do
	name=$(file-basename ${file} .js)
	sudo install -m 440 -o ${ADMIN_UID} -g ${USERS_GID} ${file} ${APL}${GUI_DJS_DIR}/${name}-${GUI_FE_VERSION}.js
	sudo install -m 644 -o root -g root ${file} ${NET_DJS_DIR}/${name}-${GUI_FE_VERSION}.js
    done
}

check-ascci-online-command()
{
    local file base

    for file in OnlineCommands/*.1 ; do
	grep --line-number --perl-regexp "[^\x00-\x7F]" "${file}"
	if test ${?} -eq 0 ; then
	    echo "*** Error in file '${file}': non ASCII' character(s) has been detected"
	    return 11
	fi
    done
}

install-online-command()
{
    local file base

    for file in OnlineCommands/${GENERATED_DIR}/*.1 ; do
	base=$(basename ${file} .1)
	sudo install -m 440 -o ${ADMIN_UID} -g ${USERS_GID} ${file} ${APL}${ADMIN_DIR}${APPLIANCE_DIR}/man/man1/
	sudo install -m 440 -o ${ADMIN_UID} -g ${USERS_GID} OnlineCommands/${GENERATED_DIR}/${base}.html ${APL}${GUI_DOC_COMMAND_DIR}/
    done

    sudo install -m 440 -o ${ADMIN_UID} -g ${USERS_GID} OnlineCommands/${GENERATED_DIR}/index.html ${APL}${GUI_DOC_COMMAND_DIR}/

    for file in OnlineCommands/${GENERATED_DIR}/*.html ; do
	sudo install -m 644 -o root -g root ${file} ${NET_DOC_COMMAND_DIR}/
    done
}

install-users-guide()
{
    local file

    for file in UsersGuide/HTMLGenerated/*.html ; do
	sudo install -m 440 -o ${ADMIN_UID} -g ${USERS_GID} ${file} ${APL}${GUI_DOC_GUIDE_DIR}/
	sudo install -m 644 -o root -g root ${file} ${NET_DOC_GUIDE_DIR}/
    done

    for file in UsersGuide/Schema/*.png UsersGuide/Image/* ; do
	sudo install -m 440 -o ${ADMIN_UID} -g ${USERS_GID} ${file} ${APL}${GUI_DOC_IMAGE_DIR}/
	sudo install -m 644 -o root -g root ${file} ${NET_DOC_IMAGE_DIR}/
    done
}

gen-copyright()
{
    sed -e "s/@YEARS@/${YEARS}/g" -e "s/@COMPANY_NAME@/${COMPANY_NAME}/g" copyright 
}

make-web-dirs()
{
    sudo mkdir -p ${NET_DOC_COMMAND_DIR}
    sudo mkdir -p ${NET_DOC_GUIDE_DIR}
    sudo mkdir -p ${NET_DOC_IMAGE_DIR}
    sudo mkdir -p ${NET_DJS_DIR}
}

install-files()
{
    local file name

    for file in CSS/*.css
    do
	name=$(file-basename ${file} .css)
	sudo install -m 644 -o root -g root ${file} ${APL}${GUI_DOC_DIR}/${name}-${GUI_FE_VERSION}.css
	sudo install -m 644 -o root -g root ${file} ${NET_DOC_DIR}/${name}-${GUI_FE_VERSION}.css
    done
    
    sudo install -m 644 -o root -g root Image/CacheGuardLogo.png ${APL}${GUI_DOC_IMAGE_DIR}
    sudo install -m 644 -o root -g root Image/CacheGuardLogo.png ${NET_DOC_IMAGE_DIR}

    install-javascript
    install-online-command
    install-users-guide
}

gen-files()
{
    gen-copyright > ${GENERATED_DIR}/copyright
}

# Main()

mkdir -p ${FULL_GENERATED_DIR}
ln -sf ${FULL_GENERATED_DIR}

check-ascci-online-command || exit ${?}
gen-files

cd UsersGuide
./install.bash
cd ..

cd OnlineCommands
./install.bash
cd ..

make-web-dirs
install-files
