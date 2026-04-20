#!/bin/bash

test -n "${LFS}" || exit 1
test -d "${LFS}" || exit 2

source LFS.env
source functions

# PACKAGES[i]="<package-name> <clean-flag> <build-pass> <patches-list>" ; ((i++))

i=0
PACKAGES[${i}]="dummy clean 1" ; ((i++))
PACKAGES[${i}]="binutils clean 1" ; ((i++))
PACKAGES[${i}]="gcc clean 1" ; ((i++))
PACKAGES[${i}]="linux clean 1" ; ((i++))
PACKAGES[${i}]="glibc clean 1 fhs-1" ; ((i++))
PACKAGES[${i}]="gcc clean 2" ; ((i++))
PACKAGES[${i}]="m4 clean 1" ; ((i++))
PACKAGES[${i}]="ncurses clean 1" ; ((i++))
PACKAGES[${i}]="bash clean 1" ; ((i++))
PACKAGES[${i}]="coreutils clean 1" ; ((i++))
PACKAGES[${i}]="diffutils clean 1" ; ((i++))
PACKAGES[${i}]="file clean 1" ; ((i++))
PACKAGES[${i}]="findutils clean 1" ; ((i++))
PACKAGES[${i}]="gawk clean 1" ; ((i++))
PACKAGES[${i}]="grep clean 1" ; ((i++))
PACKAGES[${i}]="gzip clean 1" ; ((i++))
PACKAGES[${i}]="make clean 1" ; ((i++))
PACKAGES[${i}]="patch clean 1" ; ((i++))
PACKAGES[${i}]="sed clean 1" ; ((i++))
PACKAGES[${i}]="tar clean 1" ; ((i++))
PACKAGES[${i}]="xz clean 1" ; ((i++))
PACKAGES[${i}]="binutils clean 2" ; ((i++))
PACKAGES[${i}]="gcc clean 3" ; ((i++))
PACKAGES_NB=${i}

build1_dummy()
{
    :
}

init-tools()
{
    sudo mkdir -pv ${LFS}/tools
    sudo chown -v ${USER}:${USER} ${LFS}/tools

    sudo mkdir -pv ${LFS}/{etc,var,usr}
    sudo chown -v ${USER}:${USER} ${LFS}/{etc,var,usr}
    mkdir -pv ${LFS}/usr/{bin,lib,sbin}

    local dir

    for dir in bin lib sbin
    do
	test -L ${LFS}/${dir} || sudo ln -sv usr/${dir} ${LFS}/${dir}
	sudo chown -vh ${USER}:${USER} ${LFS}/${dir}
    done

    case ${SYS_ARCHITECTURE} in
	x86_64)
	    sudo mkdir -pv ${LFS}/lib64
	    sudo chown -v ${USER}:${USER} ${LFS}/lib64
	    ;;
	*)
	    ;;
    esac

    export PATH=/usr/bin
    test -L /bin || PATH=/bin:${PATH}
    PATH=${LFS}/tools/bin:${PATH}
}

build1_dummy()
{
    configure-message
    compile-message
    install-message
}

build1_binutils()
{
    mkdir -v build && cd build || return 11

    configure-message &&
    ../configure \
	--prefix=${LFS}/tools \
	--target=${LFS_TGT} \
	--disable-nls \
	--disable-werror &&
    compile-message || return 13

    compile-message && make || return 15
    install-message && make install || return 17
}

build1_gcc()
{
    local package file dir

    for package in ../{mpfr,gmp,mpc}-[0-9]\.[0-9]\.[0-9]\.tar\.{gz,bz2,xz}
    do
	ls -1 ${package} > /dev/null 2> /dev/null || continue
	tar -xf ${package}
	dir=${package/\.\.\/}
	dir=${dir/\.tar\.*}
	mv -vf ${dir} ${dir/-*}
    done

    case ${SYS_ARCHITECTURE} in
	x86_64)
	    sed -e \
		'/m64=/s/lib64/lib/' \
		-i.orig gcc/config/i386/t-linux64
	    ;;
	*)
	    ;;
    esac

    mkdir -v build && cd build || return 11

    configure-message &&
	../configure \
	   --target=${LFS_TGT} \
	   --prefix=${LFS}/tools \
	   --with-glibc-version=2.35 \
	   --with-sysroot=${LFS} \
	   --with-newlib \
	   --without-headers \
	   --enable-initfini-array \
	   --disable-nls \
	   --disable-shared \
	   --disable-multilib \
	   --disable-decimal-float \
	   --disable-threads \
	   --disable-libatomic \
	   --disable-libgomp \
	   --disable-libquadmath \
	   --disable-libssp \
	   --disable-libvtv \
	   --disable-libstdcxx \
	   --enable-languages=c,c++ || return 13

    compile-message && make || return 16
    install-message && make install || return 17

    local libgcc_file=$(${LFS_TGT}-gcc -print-libgcc-file-name)
    local limits_dir=$(file-dirname ${libgcc_file})
    local limits_file=${limits_dir}/install-tools/include/limits.h

    cd .. && cat gcc/limitx.h gcc/glimits.h gcc/limity.h > ${limits_file}
}

build1_linux()
{
    compile-message &&
	make mrproper &&
	make headers_check || return 11

    install-message &&
	make INSTALL_HDR_PATH=dest headers_install &&
	install-message &&
	cp -rv dest/include ${LFS}/usr || return 13
}

build1_glibc()
{
    local gcc_version="11.2.0"

    case ${SYS_ARCHITECTURE} in
	x86_64)
	    ln -sfv ../lib/ld-linux-x86-64.so.2 ${LFS}/lib64/ld-linux-x86-64.so.2 &&
		ln -sfv ../lib/ld-linux-x86-64.so.2 ${LFS}/lib64/ld-lsb-x86-64.so.3
	    ;;
	*)
	    ln -sfv ld-linux.so.2 ${LFS}/lib/ld-lsb.so.3
	    ;;
    esac || return 11

    echo "rootsbindir=/usr/sbin" > configparms

    mkdir -v build && cd build || return 13

    configure-message &&
    ../configure \
	--prefix=/usr \
	--host=${LFS_TGT} \
	--build=$(../${PACKAGE_NAME}/scripts/config.guess) \
	--disable-profile \
	--enable-kernel=4.9.0 \
	--with-headers=${LFS}/usr/include \
	libc_cv_slibdir=/usr/lib || return 11

    compile-message && make || return 15
    install-message && make DESTDIR=${LFS} install || return 17

    sed '/RTLDLIST=/s@/usr@@g' -i ${LFS}/usr/bin/ldd

    cd .. && gcc-sanity-check ${LFS_TGT}-gcc '/ld-linux' || return 19
    ${LFS}/tools/libexec/gcc/${LFS_TGT}/${gcc_version}/install-tools/mkheaders
}

build2_gcc()
{
    echo '+++ GCC - PASS 2 for libstdc++'

    mkdir -v build && cd build || return 11

    configure-message &&
    ../libstdc++-v3/configure \
       --host=${LFS_TGT} \
       --build=$(../config.guess) \
       --prefix=/usr \
       --disable-multilib \
       --disable-nls \
       --disable-libstdcxx-pch \
       --with-gxx-include-dir=/tools/${LFS_TGT}/include/c++/${PACKAGE_VERSION} || return 13

    compile-message && make || return 13
    install-message && make  DESTDIR=${LFS} install || return 17
}

build1_m4()
{
    configure-message &&
    ./configure \
	--prefix=/usr \
	--host=${LFS_TGT} \
	--build=$(build-aux/config.guess) &&
    compile-message && make &&
    install-message && make DESTDIR=${LFS} install
}

build1_ncurses()
{
    sed -i s/mawk// configure || return 11

    mkdir build &&
	pushd build &&
	configure-message &&
	../configure &&
	compile-message &&
	make -C include &&
	make -C progs tic &&
	popd || return 11

    configure-message &&
	./configure \
	    --prefix=/usr \
	    --host=${LFS_TGT} \
	    --build=$(./config.guess) \
	    --mandir=/usr/share/man \
	    --with-manpage-format=normal \
	    --with-shared \
	    --without-debug \
	    --without-ada \
	    --without-normal \
	    --disable-stripping \
	    --enable-widec &&
	compile-message &&
	make &&
	install-message &&
	make DESTDIR=${LFS} TIC_PATH=$(pwd)/build/progs/tic install || return 13
    echo "INPUT(-lncursesw)" > ${LFS}/usr/lib/libncurses.so
}

build1_bash()
{
    configure-message &&
    ./configure \
	--prefix=/usr \
	--host=${LFS_TGT} \
	--build=$(support/config.guess) \
        --without-bash-malloc
    compile-message &&
    make &&
    install-message &&
    make DESTDIR=${LFS} install || return 11
    ln -svf bash ${LFS}/bin/sh
}

build1_coreutils()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --host=${LFS_TGT} \
            --build=$(build-aux/config.guess) \
            --enable-install-program=hostname \
            --enable-no-install-program=kill,uptime &&
	compile-message &&
	make &&
	install-message &&
	make DESTDIR=${LFS} install || return 11

    mv -vf ${LFS}/usr/bin/chroot ${LFS}/usr/sbin
    mkdir -pv ${LFS}/usr/share/man/man8
    mv -vf ${LFS}/usr/share/man/man1/chroot.1 ${LFS}/usr/share/man/man8/chroot.8
    sed -i 's/"1"/"8"/' ${LFS}/usr/share/man/man8/chroot.8
}

build1_diffutils()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --host=${LFS_TGT} &&
	compile-message &&
	make &&
	install-message &&
	make DESTDIR=${LFS} install
}

build1_file()
{
    mkdir build && pushd build || return 11

    configure-message &&
	../configure \
	    --disable-bzlib \
            --disable-libseccomp \
            --disable-xzlib \
            --disable-zlib &&
	compile-message &&
	make &&
	popd || return 11

    compile-message &&
	./configure \
	    --prefix=/usr \
	    --host=${LFS_TGT} \
	    --build=$(./config.guess) &&
	make FILE_COMPILE=$(pwd)/build/src/file &&
	make DESTDIR=${LFS} install
}

build1_findutils()
{
    configure-message &&
    ./configure \
	--prefix=/usr \
        --localstatedir=/var/lib/locate \
	--host=${LFS_TGT} \
        --build=$(build-aux/config.guess)
    compile-message &&
    make &&
    install-message &&
    make DESTDIR=${LFS} install
}

build1_gawk()
{
    sed -i 's/extras//' Makefile.in || return 11

    configure-message &&
	./configure \
	    --prefix=/usr   \
	    --host=${LFS_TGT} \
            --build=$(build-aux/config.guess) &&
	compile-message &&
	make &&
	install-message &&
	make DESTDIR=${LFS} install
}

build1_grep()
{
    configure-message &&
	./configure \
	    --prefix=/usr   \
	    --host=${LFS_TGT} &&
	compile-message &&
	make &&
	install-message &&
	make DESTDIR=${LFS} install
}

build1_gzip()
{
    configure-message &&
	./configure \
	    --prefix=/usr   \
	    --host=${LFS_TGT} &&
	compile-message &&
	make &&
	install-message &&
	make DESTDIR=${LFS} install
}

build1_make()
{
    configure-message &&
	./configure \
	    --prefix=/usr   \
            --without-guile \
	    --host=${LFS_TGT} \
            --build=$(build-aux/config.guess) &&
	compile-message &&
    make &&
    install-message &&
    make DESTDIR=${LFS} install
}

build1_patch()
{
    configure-message &&
	./configure \
	    --prefix=/usr   \
	    --host=${LFS_TGT} \
            --build=$(build-aux/config.guess) &&
	compile-message &&
    make &&
    install-message &&
    make DESTDIR=${LFS} install
}

build1_sed()
{
    configure-message &&
	./configure \
	    --prefix=/usr   \
	    --host=${LFS_TGT} &&
	compile-message &&
    make &&
    install-message &&
    make DESTDIR=${LFS} install

}

build1_tar()
{
    configure-message &&
	./configure \
	    --prefix=/usr   \
	    --host=${LFS_TGT} \
            --build=$(build-aux/config.guess) &&
	compile-message &&
    make &&
    install-message &&
    make DESTDIR=${LFS} install

}

build1_xz()
{
    configure-message &&
	./configure \
	    --prefix=/usr   \
	    --host=${LFS_TGT} \
            --build=$(build-aux/config.guess) \
	    --disable-static \
            --docdir=/usr/share/doc/xz-${PACKAGE_VERSION} &&
	compile-message &&
    make &&
    install-message &&
    make DESTDIR=${LFS} install
}


build2_binutils()
{
    sed '6009s/$add_dir//' -i ltmain.sh || return 11
    mkdir -v build && cd build || return 13

    configure-message &&
	../configure \
	    --prefix=/usr \
	    --build=$(../config.guess) \
	    --host=${LFS_TGT} \
	    --disable-nls \
	    --enable-shared \
	    --disable-werror \
	    --enable-64-bit-bfd &&
	compile-message &&
	make &&
	install-message &&
	make DESTDIR=${LFS} install
}

build3_gcc()
{
    echo '+++ GCC - PASS 3'

    local package file dir

    for package in ../{mpfr,gmp,mpc}-[0-9]\.[0-9]\.[0-9]\.tar\.{gz,bz2,xz}
    do
	ls -1 ${package} > /dev/null 2> /dev/null || continue
	tar -xf ${package}
	dir=${package/\.\.\/}
	dir=${dir/\.tar\.*}
	mv -vf ${dir} ${dir/-*}
    done

    case ${SYS_ARCHITECTURE} in
	x86_64)
	    sed -e \
		'/m64=/s/lib64/lib/' \
		-i.orig gcc/config/i386/t-linux64
	    ;;
	*)
	    ;;
    esac

    mkdir -v build && cd build || return 11
    mkdir -pv ${LFS_TGT}/libgcc || return 13
    ln -sf ../../../libgcc/gthr-posix.h ${LFS_TGT}/libgcc/gthr-default.h || return 15
    
    configure-message &&
	../configure \
	    CC_FOR_TARGET=${LFS_TGT}-gcc \
	    --build=$(../config.guess) \
	    --host=${LFS_TGT} \
	    --prefix=/usr \
	    --with-build-sysroot=${LFS} \
	    --enable-initfini-array \
	    --disable-nls \
	    --disable-multilib \
	    --disable-decimal-float \
	    --disable-libatomic \
	    --disable-libgomp \
	    --disable-libquadmath \
	    --disable-libssp \
	    --disable-libvtv \
	    --disable-libstdcxx \
	    --enable-languages=c,c++ || return 17

    compile-message && make || return 19
    install-message && make DESTDIR=${LFS} install || return 21
    ln -sfv gcc ${LFS}/usr/bin/cc || return 23
}


# Main()

#i=0
#PACKAGES_NB=${i}

SOURCE_DIRECTORY=${LFS}/usr/src
LOG_DIR=${PWD}/${COMPILE_LOG_DIR}-${SYS_ARCHITECTURE}
mkdir -vp ${LOG_DIR}/Tools
set-lfs-env
init-tools
install-packages ${LOG_DIR}/Tools || exit ${?}
