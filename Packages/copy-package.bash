#!/bin/bash

test -n "${LFS}" || exit 1
test -d "${LFS}" || exit 2
test -f LFS/LFS.env || exit 3
source LFS/LFS.env

copy-packages()
{
    test -n "${1}" || return 11
    test -n "${2}" || return 12
    local local_dir=${1}
    local dest_dir=${2}

    local all_packages=$(ls ${local_dir}/*.gz ${local_dir}/*.bz2 ${local_dir}/*.xz 2> /dev/null) package

    if test ! -d ${dest_dir} ; then
	sudo mkdir -vp ${dest_dir}
	sudo chown -v ${USER}:${USER} ${dest_dir}
    fi

    for package in ${all_packages}
    do
	echo "Installing ${package}"
	install -m 644 ${package} ${dest_dir}
    done
}

# Main()

copy-packages ${1} ${2}
