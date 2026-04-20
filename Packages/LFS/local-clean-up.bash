#!/bin/bash

source /tmp/LFS.env

clean-up()
{
    rm -rf /tmp/*
    find /usr/lib /usr/libexec -name \*.la -delete
    test -z "${SYS_ARCHITECTURE}" || find /usr -depth -name ${SYS_ARCHITECTURE}-lfs-linux-gnu\* | xargs rm -rf
}

# Main()

clean-up
