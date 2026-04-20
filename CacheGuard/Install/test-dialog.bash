#!/bin/bash

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
