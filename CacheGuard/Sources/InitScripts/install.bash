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

install-all-scripts()
{
    local script

    for script in Scripts/*
    do
	sudo install -m 754 -o root -g root ${script} ${APL}/etc/rc.d/init.d
    done
}

install-all-libraries()
{
    local lib

    for lib in Libraries/*
    do
	sudo install -m 644 -o root -g root ${lib} ${APL}${LOCAL_DIR}/lib
    done
}

build-script-list()
{
    unset SCRIPTS
    local script

    for script in Scripts/*
    do
	SCRIPTS="${SCRIPTS} ${script/*\//}"
    done

    echo "SCRIPTS='${SCRIPTS}'" > ${GENERATED_DIR}/INITSCRIPTS.env
}

# Main()

mkdir -p ${FULL_GENERATED_DIR}
ln -sf ${FULL_GENERATED_DIR}

build-script-list
install-all-scripts
install-all-libraries

sudo install -m 755 -o root -g root local-install.bash ${APL}/tmp/local-install.bash
sudo install -m 755 -o root -g root CacheGuard.env ${APL}/tmp
sudo install -m 755 -o root -g root ${GENERATED_DIR}/INITSCRIPTS.env ${APL}/tmp

sudo chroot ${APL} /tmp/local-install.bash
sudo rm -f  ${APL}/tmp/local-install.bash
sudo rm -f  ${APL}/tmp/CacheGuard.env
sudo rm -f  ${APL}/tmp/INITSCRIPTS.env
