#!/bin/bash

test -n "${LFS}" || exit 1
test -d "${LFS}" || exit 2

source LFS.env
source functions

# Main()

umount-lfs
