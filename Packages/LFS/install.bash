#!/bin/bash

test -n "${LFS}" || exit 1
test -d "${LFS}" || exit 2

source LFS.env
source functions

manage-owner()
{
    sudo chown -R root:root ${LFS}/{usr,lib,var,etc,bin,sbin,tools}
    sudo chown -R ${USER}:${USER} ${LFS}/usr/src ${LFS}/usr/local/src

    case ${SYS_ARCHITECTURE} in
	x86_64)
	    sudo chown -R root:root ${LFS}/lib64
	    ;;
	*)
	    ;;
    esac
}

prepare-minimal()
{
    sudo mkdir -pv ${LFS}/{dev,proc,sys,run}

    test -c ${LFS}/dev/console || sudo mknod -m 600 ${LFS}/dev/console c 5 1
    test -c ${LFS}/dev/null || sudo mknod -m 666 ${LFS}/dev/null c 1 3

    sudo install -dv -m 1777 ${LFS}/tmp
}

create-essential()
{
    run /bin/bash local-create-essential.bash LFS.env
}

create-login-info()
{
    run /bin/bash local-create-login-info.bash
}

install-lfs-packages-1()
{
    run /bin/bash local-install-pkg-1.bash LFS.env functions || return 1
    move-log
}

clean-up-tools()
{
    echo "+++ Cleaning up tools..."
    run /bin/bash local-clean-up-tools.bash || return 1
}

install-ca-bundle()
{
    sudo install -v -m 644 -o root -g root ca-bundle.crt ${LFS}/etc/ca-bundle.crt
}

install-lfs-packages-2()
{
    run /bin/bash local-install-pkg-2.bash LFS.env functions || return 1
    move-log
}

clean-up()
{
    echo "+++ Cleaning up..."
    run /bin/bash local-clean-up.bash LFS.env
}

lfs-configure()
{
    echo "+++ OS Configuration..."
    run /bin/bash local-configure.bash LFS.env functions
}

clean-tmp()
{
    sudo rm -f ${LFS}/tmp/*
}

main()
{
    if test ${PKG2_ONLY} != 'yes' ; then
	manage-owner || return 11
	prepare-minimal || return 13
    fi

    mount-lfs || return 15

    if test ${PKG2_ONLY} != 'yes' ; then
	create-essential || return 17
	create-login-info || return 19
	install-lfs-packages-1
	if-error-clean-return ${?}
	clean-up-tools || return 21
	install-ca-bundle
    fi

    install-lfs-packages-2
    if-error-clean-return ${?}

    clean-up || return 23
    do-stripe

    test ${PKG2_ONLY} == 'yes' || lfs-configure || return 25

    umount-lfs || return 29
    clean-tmp
}

# Main( )

PKG2_ONLY=no
LOG_DIR=${COMPILE_LOG_DIR}-${SYS_ARCHITECTURE}

mkdir -vp ${LOG_DIR}
set-lfs-env
main
