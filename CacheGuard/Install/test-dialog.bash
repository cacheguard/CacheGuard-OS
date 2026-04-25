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

source CacheGuard.env

source INSTALL.env
source ${GENERATED_DIR}/RT.env
source common-functions

# DIALOG=${APL}/usr/local/bin/dialog

DIALOG="${GENERATED_DIR}/dialog-1.2-20130928/dialog"
DISK_INFOS="scsi x:1 300 scsi x:2 3000 ide x:3 200"
DISK_NB=3

INSTALL=hpxe

dialog-test()
{
    dialog-setenv
#    dialog-welcome
#    dialog-set-keyboard
#    dialog-set-timezone
#    dialog-set-date
#    dialog-raid-config
#    dialog-read-inputs
#    dialog-read-passwords
#    dialog-limit-hdd
#    dialog-os-hdd
#    dialog-test-mode
    dialog-main-menu

}

dialog-test
