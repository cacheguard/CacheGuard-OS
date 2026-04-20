#!/bin/bash

restore-syslinux()
{
    test ! -d usr/share/syslinux || return 0
    test -f /tmp/syslinux.tar.gz || return 1
    cd /
    tar xvf /tmp/syslinux.tar.gz
}

# Main()

restore-syslinux
