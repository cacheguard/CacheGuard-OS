#!/bin/bash

source /tmp/LFS.env
source /tmp/functions

# PACKAGES[i]="<package-name> <clean-flag> <build-pass> <patces-list>" ; ((i++))

i=0

PACKAGES[${i}]="dummy clean 2" ; ((i++))
PACKAGES[${i}]="man-pages clean 2" ; ((i++))
PACKAGES[${i}]="iana-etc clean 2" ; ((i++))
PACKAGES[${i}]="glibc clean 2 fhs-1" ; ((i++))
PACKAGES[${i}]="zlib clean 2" ; ((i++))
PACKAGES[${i}]="bzip2 clean 2 install_docs-1" ; ((i++))
PACKAGES[${i}]="xz clean 2" ; ((i++))
PACKAGES[${i}]="zstd clean 2" ; ((i++))
PACKAGES[${i}]="file clean 2" ; ((i++))
PACKAGES[${i}]="readline clean 2 fixes-1" ; ((i++))
PACKAGES[${i}]="m4 clean 2" ; ((i++))
PACKAGES[${i}]="bc clean 2" ; ((i++))
PACKAGES[${i}]="flex clean 2" ; ((i++))
PACKAGES[${i}]="tcl clean 2" ; ((i++))
PACKAGES[${i}]="expect clean 2" ; ((i++))
PACKAGES[${i}]="dejagnu clean 2" ; ((i++))
PACKAGES[${i}]="binutils clean 2 lto_fix-1" ; ((i++))
PACKAGES[${i}]="gmp clean 2" ; ((i++))
PACKAGES[${i}]="mpfr clean 2" ; ((i++))
PACKAGES[${i}]="mpc clean 2" ; ((i++))
PACKAGES[${i}]="attr clean 2" ; ((i++))
PACKAGES[${i}]="acl clean 2" ; ((i++))
PACKAGES[${i}]="libcap clean 2" ; ((i++))
PACKAGES[${i}]="shadow clean 2" ; ((i++))
PACKAGES[${i}]="gcc clean 2" ; ((i++))
PACKAGES[${i}]="pkg-config clean 2" ; ((i++))
PACKAGES[${i}]="ncurses clean 2" ; ((i++))
PACKAGES[${i}]="sed clean 2" ; ((i++))
PACKAGES[${i}]="psmisc clean 2" ; ((i++))
PACKAGES[${i}]="gettext clean 2" ; ((i++))
PACKAGES[${i}]="bison clean 2" ; ((i++))
PACKAGES[${i}]="grep clean 2" ; ((i++))
PACKAGES[${i}]="bash clean 2" ; ((i++))
PACKAGES[${i}]="libtool clean 2" ; ((i++))
PACKAGES[${i}]="gdbm clean 2" ; ((i++))
PACKAGES[${i}]="gperf clean 2" ; ((i++))
PACKAGES[${i}]="expat clean 2" ; ((i++))
PACKAGES[${i}]="inetutils clean 2 cg" ; ((i++))
PACKAGES[${i}]="less clean 2" ; ((i++))
PACKAGES[${i}]="perl clean 2 upstream_fixes-1" ; ((i++))
PACKAGES[${i}]="XML-Parser clean 2" ; ((i++))
PACKAGES[${i}]="intltool clean 2" ; ((i++))
PACKAGES[${i}]="autoconf clean 2" ; ((i++))
PACKAGES[${i}]="automake clean 2" ; ((i++))
PACKAGES[${i}]="openssl clean 2" ; ((i++))
PACKAGES[${i}]="ninja clean 2" ; ((i++))
PACKAGES[${i}]="meson clean 2" ; ((i++))
PACKAGES[${i}]="kmod clean 2" ; ((i++))
PACKAGES[${i}]="elfutils clean 2" ; ((i++))
PACKAGES[${i}]="libffi clean 2" ; ((i++))
PACKAGES[${i}]="Python clean 2" ; ((i++))
PACKAGES[${i}]="coreutils clean 2 i18n-1 chmod_fix-1" ; ((i++))
PACKAGES[${i}]="check clean 2" ; ((i++))
PACKAGES[${i}]="diffutils clean 2" ; ((i++))
PACKAGES[${i}]="gawk clean 2" ; ((i++))
PACKAGES[${i}]="findutils clean 2" ; ((i++))
PACKAGES[${i}]="groff clean 2" ; ((i++))
PACKAGES[${i}]="grub clean 2" ; ((i++))
PACKAGES[${i}]="gzip clean 2" ; ((i++))
PACKAGES[${i}]="iproute2 clean 2" ; ((i++))
PACKAGES[${i}]="kbd clean 2 backspace-1" ; ((i++))
PACKAGES[${i}]="libpipeline clean 2" ; ((i++))
PACKAGES[${i}]="make clean 2 upstream_fixes-3" ; ((i++))
PACKAGES[${i}]="patch clean 2" ; ((i++))
PACKAGES[${i}]="tar clean 2 manpage-1" ; ((i++))
PACKAGES[${i}]="texinfo clean 2 test-1" ; ((i++))
PACKAGES[${i}]="vim clean 2" ; ((i++))
PACKAGES[${i}]="eudev clean 2" ; ((i++))
PACKAGES[${i}]="man-db clean 2" ; ((i++))
PACKAGES[${i}]="procps clean 2" ; ((i++))
PACKAGES[${i}]="util-linux clean 2" ; ((i++))
PACKAGES[${i}]="e2fsprogs clean 2" ; ((i++))
PACKAGES[${i}]="sysklogd clean 2" ; ((i++))
PACKAGES[${i}]="sysvinit clean 2 consolidated-1" ; ((i++))
PACKAGES[${i}]="lfs-bootscripts clean 2 cg" ; ((i++))
PACKAGES[${i}]="Linux-PAM clean 2" ; ((i++))
PACKAGES[${i}]="linux noclean 2" ; ((i++))
PACKAGES[${i}]="linux-firmware clean 2" ; ((i++))

# Extra LFS

PACKAGES[${i}]="libgpg-error clean 2" ; ((i++))
PACKAGES[${i}]="libassuan clean 2" ; ((i++))
PACKAGES[${i}]="libgcrypt clean 2" ; ((i++))
PACKAGES[${i}]="libksba clean 2" ; ((i++))
PACKAGES[${i}]="pinentry clean 2" ; ((i++))
PACKAGES[${i}]="liblogging clean 2" ; ((i++))
PACKAGES[${i}]="libestr clean 2" ; ((i++))
PACKAGES[${i}]="cmake clean 2" ; ((i++))
PACKAGES[${i}]="json-c clean 2" ; ((i++))
PACKAGES[${i}]="npth clean 2" ; ((i++))
PACKAGES[${i}]="gnupg clean 2" ; ((i++))
PACKAGES[${i}]="libfastjson clean 2" ; ((i++))
PACKAGES[${i}]="libssh2 clean 1" ; ((i++))
PACKAGES[${i}]="libpsl clean 1" ; ((i++))
PACKAGES[${i}]="curl clean 1" ; ((i++))
PACKAGES[${i}]="rsyslog clean 2" ; ((i++))
PACKAGES[${i}]="busybox clean 2" ; ((i++))

PACKAGES_NB=${i}

gcc-additional-sanity-check()
{
    echo "+++ GCC additional sanity checks:"

    echo 'int main(){}' > dummy.c
    cc dummy.c -v -Wl,--verbose &> dummy.log

    echo "+++ Running: grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log"
    grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log

    echo "+++ Running: grep -B4 '^ /usr/include' dummy.log"
    grep -B4 '^ /usr/include' dummy.log

    echo "+++ Running: grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'"
    grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'

    echo "+++ Running: grep \"/lib.*/libc.so.6 \" dummy.log"
    grep "/lib.*/libc.so.6 " dummy.log

    echo "+++ Running: grep found dummy.log"
    grep found dummy.log

    rm -vf dummy.c a.out dummy.log
}

build2_dummy()
{
    compile-message &&
	make &&
	install-message &&
	make install
}

build2_man-pages()
{
    install-message && make prefix=/usr install
}

build2_iana-etc()
{
    install-message && cp services protocols /etc
}

glibc-local-def()
{
    mkdir -pv /usr/lib/locale
    localedef --inputfile=en_US --charmap=UTF-8 en_US.UTF-8
    localedef --inputfile=${SYS_LANG}_${SYS_COUNTRY} --charmap=${SYS_CHARMAP} ${SYS_LANG}_${SYS_COUNTRY}.${SYS_CHARMAP}
    return 0
}

glibc-configure()
{
    cat > /etc/nsswitch.conf << "EOF"
# Begin /etc/nsswitch.conf

passwd: files
group: files
shadow: files

hosts: files dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

# End /etc/nsswitch.conf
EOF
}

glibc-timezone-setup()
{
    test -n "${1}" || return 1
    local dir=${1}

    local tzdata_file zoneinfo tz

    tzdata_file=$(ls -1 ${dir}/tzdata[0-9][0-9][0-9][0-9][a-z].tar.{gz,bz2,xz} 2> /dev/null)
    tzdata_file=${tzdata_file/ *}
    test -n "${tzdata_file}" || return 1

    tar -xf ${tzdata_file}

    zoneinfo=/usr/share/zoneinfo
    mkdir -pv ${zoneinfo}/{posix,right}

    for tz in \
	etcetera \
	southamerica \
	northamerica \
	europe \
	africa \
	antarctica  \
        asia \
	australasia \
	backward
    do
	test -f ${tz} || continue
	zic -L /dev/null   -d ${zoneinfo}       ${tz}
	zic -L /dev/null   -d ${zoneinfo}/posix ${tz}
	zic -L leapseconds -d ${zoneinfo}/right ${tz}
    done

    cp -vf zone.tab zone1970.tab ${zoneinfo}
    zic -d ${zoneinfo} -p America/New_York

    ln -sfv /usr/share/zoneinfo/${SYS_TIME_ZONE} /etc/localtime
}

glibc-configure-dynamic-loader()
{
    cat > /etc/ld.so.conf << "EOF"
# Begin /etc/ld.so.conf

/usr/local/lib
/opt/lib

include /etc/ld.so.conf.d/*.conf

# End /etc/ld.so.conf
EOF
    mkdir -pv /etc/ld.so.conf.d
}

build2_glibc()
{
    mkdir -v build && cd build || return 11

    echo "rootsbindir=/usr/sbin" > configparms

    configure-message &&
	../configure \
	    --prefix=/usr \
            --disable-werror \
            --enable-kernel=${SYS_VERSION} \
            --enable-stack-protector=strong \
            --with-headers=/usr/include \
            libc_cv_slibdir=/usr/lib &&
	compile-message && make || return 13

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 13
	test-message-end
    fi

    touch /etc/ld.so.conf &&
	sed '/test-installation/s@$(PERL)@echo not running@' -i ../Makefile &&
	install-message && make install || return 15

    sed '/RTLDLIST=/s@/usr@@g' -i /usr/bin/ldd &&
	cp -v ../nscd/nscd.conf /etc/nscd.conf &&
	mkdir -pv /var/cache/nscd || return 17

    glibc-local-def &&
	glibc-configure &&
	glibc-timezone-setup "../.." &&
	glibc-configure-dynamic-loader
}

build2_zlib()
{
    configure-message &&
	./configure --prefix=/usr &&
	compile-message && make || return 11

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 13
	test-message-end
    fi
    
    install-message &&
	make install &&
	rm -fv /usr/lib/libz.a
}

build2_bzip2()
{
    sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
    sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile

    make -f Makefile-libbz2_so &&
	make clean || return 11

    compile-message && make &&
	install-message && make PREFIX=/usr install || return 13

    cp -av libbz2.so.* /usr/lib &&
	cp -v bzip2-shared /usr/bin/bzip2 &&
	ln -svf libbz2.so.1.0.8 /usr/lib/libbz2.so || return 15

    local f
    for f in /usr/bin/{bzcat,bunzip2}; do
	ln -sfv bzip2 ${f}
    done

    rm -fv /usr/lib/libbz2.a
}

build2_xz()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static \
	    --docdir=/usr/share/doc/${PACKAGE_NAME} &&
	compile-message &&
	make || return 11
    
    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 13
	test-message-end
    fi
    
    install-message && make install
}

build2_zstd()
{
    make || return 11
    
    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 13
	test-message-end
    fi

    install-message && make prefix=/usr install &&
	rm -v /usr/lib/libzstd.a
}

build2_file()
{
    configure-message &&
    ./configure	--prefix=/usr &&
    compile-message &&
    make || return 11

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 13
	test-message-end
    fi

    install-message && make install
}

build2_readline()
{
    sed -i '/MV.*old/d' Makefile.in &&
	sed -i '/{OLDSUFF}/c:' support/shlib-install || return 11

    configure-message &&
	./configure --prefix=/usr \
            --disable-static \
            --with-curses \
            --docdir=/usr/share/doc/readline-${PACKAGE_VERSION} &&
	compile-message &&
	make SHLIB_LIBS="-lncursesw" &&
	install-message &&
	make SHLIB_LIBS="-lncursesw" install || return 13

    install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-${PACKAGE_VERSION}
}

build2_m4()
{
    configure-message &&
	./configure --prefix=/usr &&
	compile-message &&
	make || return 11

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 13
	test-message-end
    fi

    install-message &&
	make install
}

build2_bc()
{
    configure-message &&
	CC=gcc ./configure --prefix=/usr -G -O3 &&
	compile-message &&
	make || return 11
    
    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make test
	test-message-end
    fi
    
    install-message &&
	make install
}

build2_flex()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
            --docdir=/usr/share/doc/${PACKAGE_NAME} \
            --disable-static &&
	compile-message &&
	make || return 11

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 13
	test-message-end
    fi

    install-message &&
	make install &&
	ln -svf flex /usr/bin/lex
}

build2_tcl()
{
    tar -xf ../tcl${PACKAGE_VERSION}-html.tar.gz --strip-components=1 || return 11

    local srcdir=$(pwd)

    configure-message &&
    cd unix
    ./configure --prefix=/usr \
		--mandir=/usr/share/man \
		$([ "${SYS_ARCHITECTURE}" = x86_64 ] && echo --enable-64bit) &&
	compile-message &&
	make || return 13

    sed -e "s|${srcdir}/unix|/usr/lib|" \
	-e "s|${srcdir}|/usr/include|" \
	-i tclConfig.sh

    sed -e "s|${srcdir}/unix/pkgs/tdbc1.1.3|/usr/lib/tdbc1.1.3|" \
	-e "s|${srcdir}/pkgs/tdbc1.1.3/generic|/usr/include|" \
	-e "s|${srcdir}/pkgs/tdbc1.1.3/library|/usr/lib/tcl8.6|" \
	-e "s|${srcdir}/pkgs/tdbc1.1.3|/usr/include|" \
	-i pkgs/tdbc1.1.3/tdbcConfig.sh

    sed -e "s|${srcdir}/unix/pkgs/itcl4.2.2|/usr/lib/itcl4.2.2|" \
	-e "s|${srcdir}/pkgs/itcl4.2.2/generic|/usr/include|" \
	-e "s|${srcdir}/pkgs/itcl4.2.2|/usr/include|" \
	-i pkgs/itcl4.2.2/itclConfig.sh

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make test || return 15
	test-message-end
    fi

    install-message && make install || return 17

    chmod -v u+w /usr/lib/libtcl8.6.so &&
	make install-private-headers &&
	ln -sfv tclsh8.6 /usr/bin/tclsh &&
	mv /usr/share/man/man3/{Thread,Tcl_Thread}.3
}

build2_expect()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --with-tcl=/usr/lib \
            --enable-shared \
            --mandir=/usr/share/man \
            --with-tclinclude=/usr/include &&
	compile-message &&
	make || return 11

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make test || return 13
	test-message-end
    fi

    install-message && make install &&
	ln -svf expect${PACKAGE_VERSION}/libexpect${PACKAGE_VERSION}.so /usr/lib
}

build2_dejagnu()
{
    mkdir -v build && cd build || return 11

    configure-message &&
	../configure --prefix=/usr &&
	makeinfo --html --no-split -o doc/dejagnu.html ../doc/dejagnu.texi &&
	makeinfo --plaintext -o doc/dejagnu.txt ../doc/dejagnu.texi || return 13

    install-message &&
	make install &&
	install -v -dm755  /usr/share/doc/dejagnu-1.6.3 &&
	install -v -m644   doc/dejagnu.{html,txt} /usr/share/doc/dejagnu-1.6.3 || return 15

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 17
	test-message-end
    fi
}

build2_binutils()
{
    mkdir -v build && cd build || return 11

    configure-message &&
	../configure \
	    --prefix=/usr \
	    --enable-gold \
	    --enable-ld=default \
	    --enable-plugins \
	    --enable-shared \
	    --disable-werror \
	    --enable-64-bit-bfd \
            --with-system-zlib || return 13

    compile-message && make tooldir=/usr || return 15

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make -k check || return 17
	test-message-end
    fi

    install-message && make tooldir=/usr install || return 17

    rm -fv /usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes}.a
}

build2_gmp()
{
    local abi

    case ${SYS_ARCHITECTURE} in
	x86_64)
	    ;;
	*)
	    export ABI=32
	    ;;
    esac

    cp -v configfsf.guess config.guess
    cp -v configfsf.sub   config.sub

    configure-message &&
	./configure \
	    --prefix=/usr \
	    --enable-cxx \
	    --disable-static \
	    --docdir=/usr/share/doc/gmp-6.2.1 || return 11

    compile-message && make && make html || return 13

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check 2>&1 | tee gmp-check-log
	echo "+++ Begin gmp-check-log:"
	awk '/# PASS:/{total+=$3} ; END{print total}' gmp-check-log
	local ret=${?}
	echo "+++ End gmp-check-log:"
	test ${ret} -eq 0 || return 15
	test-message-end
    fi

    install-message &&
	make install &&
	make install-html
}

build2_mpfr()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static \
            --enable-thread-safe \
            --docdir=/usr/share/doc/${PACKAGE_NAME} &&
	compile-message &&
	make && make html || return 11

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 13
	test-message-end
    fi

    install-message &&
	make install &&
	make install-html
}

build2_mpc()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static \
	    --docdir=/usr/share/doc/${PACKAGE_NAME} &&
	compile-message && make && make html || return 11

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 13
	test-message-end
    fi

    install-message && make install && make install-html
}

build2_attr()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static \
	    --sysconfdir=/etc \
	    --docdir=/usr/share/doc/${PACKAGE_NAME} &&
	compile-message && make || return 11

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 13
	test-message-end
    fi

    install-message && make install
}

build2_acl()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static \
	    --docdir=/usr/share/doc/${PACKAGE_NAME} &&
	compile-message && make &&
	install-message && make install
}

build2_libcap()
{
    sed -i '/install -m.*STA/d' libcap/Makefile

    compile-message && make prefix=/usr lib=lib || return 11

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make test || return 13
	test-message-end
    fi

    install-message && make prefix=/usr lib=lib install
}

build2_shadow()
{
    sed -i 's/groups$(EXEEXT) //' src/Makefile.in

    find man -name Makefile.in -exec sed -i 's/groups\.1 / /'   {} \;
    find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \;
    find man -name Makefile.in -exec sed -i 's/passwd\.5 / /'   {} \;

    sed -e 's:#ENCRYPT_METHOD DES:ENCRYPT_METHOD SHA512:'\
    -e 's:/var/spool/mail:/var/mail:' \
    -e '/PATH=/{s@/sbin:@@;s@/bin:@@}'\
    -i etc/login.defs

    touch /usr/bin/passwd

    configure-message &&
	./configure \
	    --sysconfdir=/etc \
            --with-group-name-max-length=32 &&
	compile-message && make &&
	install-message &&
	make exec_prefix=/usr install &&
	make -C man install-man || return 11

    pwconv && grpconv &&
	mkdir -p /etc/default &&
	useradd -D --gid ${USERS_GID} || return 13

    sed -i '/MAIL/s/yes/no/' /etc/default/useradd
}

build2_gcc()
{
    sed -e '/static.*SIGSTKSZ/d' \
	-e 's/return kAltStackSize/return SIGSTKSZ * 4/' \
	-i libsanitizer/sanitizer_common/sanitizer_posix_libcdep.cpp

    case ${SYS_ARCHITECTURE} in
	x86_64)
	    sed -e '/m64=/s/lib64/lib/' -i.orig gcc/config/i386/t-linux64
	    ;;

	*)
	    ;;
    esac

    mkdir -v build && cd build || return 11

    configure-message &&
	../configure \
	    LD=ld\
	    --prefix=/usr \
	    --enable-languages=c,c++ \
             --disable-multilib \
             --disable-bootstrap \
             --with-system-zlib &&
	compile-message && make || return 13

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	test-message-end
    fi

    install-message && make install || return 17

    rm -rf /usr/lib/gcc/$(gcc -dumpmachine)/${PACKAGE_VERSION}/include-fixed/bits/ &&
	chown -v -R root:root /usr/lib/gcc/*linux-gnu/${PACKAGE_VERSION}/include{,-fixed} &&
	ln -svrf /usr/bin/cpp /usr/lib &&
	ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/${PACKAGE_VERSION}/liblto_plugin.so /usr/lib/bfd-plugins/ || return 17

    mkdir -pv /usr/share/gdb/auto-load/usr/lib &&
	mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib || return 19

    gcc-sanity-check cc ': /lib' || return 21
    gcc-additional-sanity-check
}

build2_pkg-config()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --with-internal-glib \
            --disable-host-tool \
            --docdir=/usr/share/doc/${PACKAGE_NAME} &&
	compile-message &&
	make || return 11

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 13
	test-message-end
    fi

    install-message && make install
}

build2_ncurses()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
            --mandir=/usr/share/man \
            --with-shared \
            --without-debug \
            --without-normal \
            --enable-pc-files \
            --enable-widec \
            --with-pkg-config-libdir=/usr/lib/pkgconfig &&
	compile-message &&
	make || return 11

    install-message &&
	make DESTDIR=${PWD}/dest install &&
	install -vm755 dest/usr/lib/libncursesw.so.6.3 /usr/lib &&
	rm -v  dest/usr/lib/{libncursesw.so.6.3,libncurses++w.a} &&
	cp -av dest/* / || return 13

    local lib

    for lib in ncurses form panel menu
    do
	rm -vf /usr/lib/lib${lib}.so
	echo "INPUT(-l${lib}w)" > /usr/lib/lib${lib}.so
	ln -sfv ${lib}w.pc /usr/lib/pkgconfig/${lib}.pc
    done || return 15

    rm -vf /usr/lib/libcursesw.so &&
	echo "INPUT(-lncursesw)" > /usr/lib/libcursesw.so &&
	ln -sfv libncurses.so /usr/lib/libcurses.so || return 17

    mkdir -pv /usr/share/doc/ncurses-${PACKAGE_VERSION} &&
	cp -v -R doc/* /usr/share/doc/ncurses-${PACKAGE_VERSION} || return 19

    echo "+++ Rebuilding ${PACKAGE_VERSION} to be compliant with LSB"

    make distclean &&
	configure-message && 
	./configure \
	    --prefix=/usr \
            --with-shared \
            --without-normal \
            --without-debug \
            --without-cxx-binding \
            --with-abi-version=5 &&
	compile-message &&
	make sources libs &&
	install-message &&
	cp -av lib/lib*.so.5* /usr/lib
}

build2_sed()
{
    configure-message &&
	./configure --prefix=/usr &&
	compile-message &&
	make && make html || return 11

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	test-message-end
    fi

    install-message &&
	make install &&
	install -d -m755 /usr/share/doc/sed-${PACKAGE_VERSION} &&
	install -m644 doc/sed.html /usr/share/doc/sed-${PACKAGE_VERSION}
}

build2_psmisc()
{
    configure-message &&
	./configure --prefix=/usr &&
	compile-message && make &&
	install-message && make install
}

build2_gettext()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static \
            --docdir=/usr/share/doc/${PACKAGE_NAME} &&
	compile-message &&
	make || return 11
    
    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 13
	test-message-end
    fi
    
    install-message &&
	make install &&
	chmod -v 0755 /usr/lib/preloadable_libintl.so
}

build2_bison()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --docdir=/usr/share/doc/bison-${PACKAGE_NAME}

    compile-message &&
	make || return 11
    
    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 13
	test-message-end
    fi
    
    install-message && make install
}

build2_grep()
{
    configure-message && ./configure --prefix=/usr &&
	compile-message && make || return 11

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 13
	test-message-end
    fi

    install-message && make install
}

build2_bash()
{
    configure-message &&
    ./configure \
	--prefix=/usr \
        --docdir=/usr/share/doc/${PACKAGE_NAME} \
        --without-bash-malloc \
        --with-installed-readline &&
    compile-message &&
    make || return 11

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	test-message-end
    fi

    install-message && make install
}

build2_libtool()
{
    configure-message &&
	./configure --prefix=/usr &&
	compile-message &&
	make || return 11
    
    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 13
	test-message-end
    fi
    
    install-message &&
	make install &&
	rm -fv /usr/lib/libltdl.a
}

build2_gdbm()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static \
	    --enable-libgdbm-compat &&
	compile-message &&
	make || return 11
    
    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make -j1 check || return 13
	test-message-end
    fi
    
    install-message &&
	make install
}

build2_gperf()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --docdir=/usr/share/doc/${PACKAGE_NAME}
	compile-message &&
	make || return 11
    
    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 13
	test-message-end
    fi
    
    install-message &&
	make install
}

build2_expat()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	&&
	compile-message &&
	make &&
	install-message &&
	make install
}

build2_inetutils()
{
     configure-message &&
	./configure \
	    --prefix=/usr \
	    --bindir=/usr/bin \
            --localstatedir=/var \
            --disable-logger \
            --disable-whois \
            --disable-rcp \
            --disable-rexec \
            --disable-rlogin \
            --disable-rsh \
            --disable-servers &&
	compile-message &&
	make || return 11
    
    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 13
	test-message-end
    fi
    
    install-message &&
	make install &&
	mv -v /usr/{,s}bin/ifconfig
}

build2_less()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --sysconfdir=/etc &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build2_perl()
{
    export BUILD_ZLIB=False
    export BUILD_BZIP2=0

    configure-message &&
	sh Configure -des \
	   -Dprefix=/usr \
           -Dvendorprefix=/usr \
           -Dprivlib=/usr/lib/perl5/5.34/core_perl \
           -Darchlib=/usr/lib/perl5/5.34/core_perl \
           -Dsitelib=/usr/lib/perl5/5.34/site_perl \
           -Dsitearch=/usr/lib/perl5/5.34/site_perl \
           -Dvendorlib=/usr/lib/perl5/5.34/vendor_perl \
           -Dvendorarch=/usr/lib/perl5/5.34/vendor_perl \
           -Dman1dir=/usr/share/man/man1 \
           -Dman3dir=/usr/share/man/man3 \
           -Dpager="/usr/bin/less -isR" \
           -Duseshrplib \
           -Dusethreads &&
	compile-message &&
	make || return 11
    
    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make test || return 13
	test-message-end
    fi
    
    install-message && make install

    unset BUILD_ZLIB BUILD_BZIP2
}

build2_XML-Parser()
{
    configure-message &&
	perl Makefile.PL &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build2_intltool()
{    
    sed -i 's:\\\${:\\\$\\{:' intltool-update.in

    configure-message &&
	./configure --prefix=/usr &&
	compile-message &&
	make || return 11

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 13
	test-message-end
    fi

    install-message &&
	make install &&
	install -v -Dm644 doc/I18N-HOWTO /usr/share/doc/${PACKAGE_NAME}/I18N-HOWTO
}

build2_autoconf()
{
    configure-message &&
	./configure \
	    --prefix=/usr &&
	compile-message &&
	make || return 11
    
    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 13
	test-message-end
    fi
    
    install-message &&
	make install
}

build2_automake()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --docdir=/usr/share/doc/${PACKAGE_NAME} &&
	compile-message &&
	make || return 11
    
    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make -j4 check || return 13
	test-message-end
    fi

    install-message &&
	make install
}

build2_openssl()
{
    configure-message &&
	unset LANGUAGE LC_ALL LANG
    ./config \
	--prefix=/usr \
	--openssldir=/etc/ssl \
	--libdir=lib \
	shared \
	zlib-dynamic &&
	compile-message &&
	make || return 11

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make test || return 13
	test-message-end
    fi

    sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile

    install-message &&
	make MANSUFFIX=ssl install &&
	cp -vfr doc/* /usr/share/doc/${PACKAGE_NAME} &&
	ln -sfv /etc/ca-bundle.crt /etc/ssl/cert.pem
}

build2_ninja()
{
    export NINJAJOBS=4

    sed -i '/int Guess/a \
    	int   j = 0; \
  	char* jobs = getenv( "NINJAJOBS" );\
  	if ( jobs != NULL ) j = atoi( jobs );\
  	if ( j > 0 ) return j;\
	' src/ninja.cc

    configure-message &&
	python3 configure.py --bootstrap || return 11

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	./ninja ninja_test &&
	    ./ninja_test --gtest_filter=-SubprocessTest.SetWithLots || return 13
	test-message-end
    fi

    install-message &&
	install -vm755 ninja /usr/bin/ &&
	install -vDm644 misc/bash-completion /usr/share/bash-completion/completions/ninja &&
	install -vDm644 misc/zsh-completion /usr/share/zsh/site-functions/_ninja
}

build2_meson()
{    
    compile-message &&
	python3 setup.py build &&
	install-message &&
	python3 setup.py install --root=dest &&
	cp -rv dest/* / &&
	install -vDm644 data/shell-completions/bash/meson /usr/share/bash-completion/completions/meson &&
	install -vDm644 data/shell-completions/zsh/_meson /usr/share/zsh/site-functions/_meson
}

build2_kmod()
{
    mkdir -v build && cd build || return 11

    configure-message &&
	meson setup \
	      --prefix=/usr \
	      --buildtype=release \
              -D manpages=false &&
	compile-message &&
	ninja || return 13

    install-message && ninja install || return 15
}

build2_elfutils()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-debuginfod \
            --enable-libdebuginfod=dummy &&
	compile-message &&
	make || return 11

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 13
	test-message-end
    fi

    install-message &&
	make -C libelf install &&
	install -vm644 config/libelf.pc /usr/lib/pkgconfig &&
	rm /usr/lib/libelf.a
}

build2_libffi()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    -disable-static \
            --with-gcc-arch=native \
            --disable-exec-static-tramp &&
	compile-message &&
	make || return 11

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 13
	test-message-end
    fi

    install-message && make install
}

build2_Python()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --enable-shared \
            --with-system-expat \
            --with-system-ffi \
            --with-ensurepip=yes \
	    --with-openssl-rpath=auto \
	    --with-ssl-default-suites=openssl \
            --enable-optimizations &&
	compile-message &&
	make &&
	install-message &&
	make install || return 11

    install -v -dm755 /usr/share/doc/python-3.10.2/html

    tar --strip-components=1 \
    --no-same-owner \
    --no-same-permissions \
    -C /usr/share/doc/${PACKAGE_NAME,}/html \
    -xvf ../${PACKAGE_NAME,}-docs-html.tar.bz2

    ln -sfv /usr/bin/python3 /usr/bin/python
    ln -sfv /usr/bin/python3-config /usr/bin/python-config
    ln -sfv /usr/bin/pip3 /usr/bin/pip
}

build2_coreutils()
{
    configure-message &&
	autoreconf -fiv &&
	FORCE_UNSAFE_CONFIGURE=1 ./configure \
			      --prefix=/usr \
			      --enable-no-install-program=kill,uptime &&
	compile-message &&
	make || return 11

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	test-message-end
    fi

    install-message && make install || return 15

    mv -v /usr/bin/chroot /usr/sbin &&
	mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8 &&
	sed -i 's/"1"/"8"/' /usr/share/man/man8/chroot.8
}

build2_check()
{    
    compile-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static &&
	compile-message && make || return 11

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 13
	test-message-end
    fi

    install-message &&
	make docdir=/usr/share/doc/${PACKAGE_NAME} install
}

build2_diffutils()
{    
    compile-message &&
	./configure --prefix=/usr &&
	compile-message && make || return 11

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 13
	test-message-end
    fi

    install-message && make install
}

build2_gawk()
{
    sed -i 's/extras//' Makefile.in

    configure-message &&
	./configure \
	    --prefix=/usr &&
	compile-message &&
	make || return 11
    
    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 13
	test-message-end
    fi
    
    install-message &&
	make install &&
	mkdir -pv /usr/share/doc/gawk-${PACKAGE_NAME} &&
	cp    -v doc/{awkforai.txt,*.{eps,pdf,jpg}} /usr/share/doc/gawk-${PACKAGE_NAME}
}

build2_findutils()
{
    configure-message

    case ${SYS_ARCHITECTURE} in
	x86_64)
	    ./configure --prefix=/usr --localstatedir=/var/lib/locate
	    ;;
	*)
	    TIME_T_32_BIT_OK=yes ./configure --prefix=/usr --localstatedir=/var/lib/locate
	    ;;
    esac || return 11

    compile-message && make || return 13
    
    if test "${CHECK}" == "yes" ; then
	test-message-begin
	test-message-end
    fi

    install-message && make install
}

build2_groff()
{
    configure-message &&
	PAGE=A4 ./configure --prefix=/usr &&
	compile-message && make -j1 &&
	install-message && make install
}

build2_popt()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build2_efivar()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build2_efibootmgr()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build2_grub()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --sysconfdir=/etc \
	    --disable-efiemu \
	    --disable-werror \
	    --target=${SYS_ARCHITECTURE} \
	    --with-platform=pc &&
	compile-message &&
	make || return 11

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 13
	test-message-end
    fi
    
    install-message &&
	make install &&
	mv -v /etc/bash_completion.d/grub /usr/share/bash-completion/completions
}

build2_gzip()
{
    configure-message &&
	./configure --prefix=/usr &&
	compile-message &&
	make || return 11

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 13
	test-message-end
    fi

    install-message && make install
}

build2_iproute2()
{
    sed -i /ARPD/d Makefile
    rm -fv man/man8/arpd.8

    compile-message &&
	make &&
	install-message &&
	make SBINDIR=/usr/sbin install || return 11

    mkdir -pv /usr/share/doc/${PACKAGE_NAME} &&
	cp -v COPYING README* /usr/share/doc/${PACKAGE_NAME}
}

build2_kbd()
{
    sed -i '/RESIZECONS_PROGS=/s/yes/no/' configure
    sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in

    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-vlock &&
	compile-message && make || return 11

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 13
	test-message-end
    fi

    install-message &&
	make install || return 15

    mkdir -pv /usr/share/doc/${PACKAGE_NAME} &&
	cp -R -v docs/doc/* /usr/share/doc/${PACKAGE_NAME}
}

build2_libpipeline()
{
    configure-message &&
	./configure --prefix=/usr &&
	compile-message &&
	make || return 11

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 13
	test-message-end
    fi
    
    install-message && make install
}

build2_make()
{
    configure-message && ./configure --prefix=/usr &&
	compile-message &&
	make || return 11
    
    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 13
	test-message-end
    fi
    
    install-message && make install
}

build2_patch()
{
    configure-message &&
	./configure --prefix=/usr &&
	compile-message &&
	make || return 11

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 13
	test-message-end
    fi
    
    install-message && make install
}

build2_tar()
{
    configure-message &&
	FORCE_UNSAFE_CONFIGURE=1  ./configure --prefix=/usr &&
	compile-message &&
	make || return 11
    
    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 13
	test-message-end
    fi
    
    install-message &&
	make install &&
	make -C doc install-html docdir=/usr/share/doc/${PACKAGE_NAME}
}

build2_texinfo()
{
    configure-message && ./configure --prefix=/usr || return 11

    sed -e 's/__attribute_nonnull__/__nonnull/' \
	-i gnulib/lib/malloc/dynarray-skeleton.c

    compile-message &&
	make || return 13
    
    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 15
	test-message-end
    fi

    install-message &&
	make install &&
	make TEXMF=/usr/share/texmf install-tex
}

build2_vim()
{
    echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h

    configure-message &&
	./configure ./configure --prefix=/usr &&
	compile-message &&
	make || return 11

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	test-message-end
    fi

    local f

    for f in  /usr/share/man/{,*/}man1/vim.1
    do
	rm -f $(dirname ${f})/vi.1 || return 15
    done
    rm -f /usr/share/doc/${PACKAGE_NAME}

    install-message && make install || return 17
    ln -svf vim /usr/bin/vi || return 17

    for f in  /usr/share/man/{,*/}man1/vim.1
    do
	ln -svf vim.1 $(dirname ${f})/vi.1 || return 19
    done

    ln -svf ../vim/vim82/doc /usr/share/doc/${PACKAGE_NAME} || return 21

    cat > /etc/vimrc << "EOF"
" Begin /etc/vimrc

source $VIMRUNTIME/defaults.vim
let skip_defaults_vim=1

set nocompatible
set backspace=2
set mouse=
syntax on
if (&term == "xterm") || (&term == "putty")
  set background=dark
endif

" End /etc/vimrc
EOF
}

build2_eudev()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
            --bindir=/usr/sbin \
            --sysconfdir=/etc \
            --enable-manpages \
            --disable-static &&
	compile-message &&
	make || return 11

    mkdir -pv /usr/lib/udev/rules.d &&
	mkdir -pv /etc/udev/rules.d || return 13

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 15
	test-message-end
    fi
    
    install-message && make install || return 17

    tar -xvf ../udev-lfs-20171102.tar.xz &&
	install-message &&
	make -f udev-lfs-20171102/Makefile.lfs install

    configure-message && udevadm hwdb --update
}

build2_man-db()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --docdir=/usr/share/doc/${PACKAGE_NAME} \
	    --sysconfdir=/etc \
            --disable-setuid \
            --enable-cache-owner=bin \
            --with-browser=/usr/bin/lynx \
            --with-vgrind=/usr/bin/vgrind \
            --with-grap=/usr/bin/grap \
            --with-systemdtmpfilesdir= \
            --with-systemdsystemunitdir= &&
	compile-message &&
	make || return 11
    
    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 13
	test-message-end
    fi
    
    install-message && make install
}

build2_procps()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --docdir=/usr/share/doc/${PACKAGE_NAME} \
	    --disable-static \
	    --disable-kill &&
	compile-message &&
	make || return 11

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check
	test-message-end
    fi

    install-message && make install
}

build2_util-linux()
{
    configure-message &&
	./configure ADJTIME_PATH=/var/lib/hwclock/adjtime \
            --bindir=/usr/bin \
            --libdir=/usr/lib \
            --sbindir=/usr/sbin \
            --docdir=/usr/share/doc/${PACKAGE_NAME} \
            --disable-chfn-chsh \
            --disable-login \
            --disable-nologin \
            --disable-su \
            --disable-setpriv \
            --disable-runuser \
            --disable-pylibmount \
            --disable-static \
            --without-python \
            --without-systemd  \
            --without-systemdsystemunitdir &&
	compile-message &&
	make || return 11

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 13
	test-message-end
    fi

    install-message && make install
}

build2_e2fsprogs()
{
    mkdir -pv build && cd build || return 11

    configure-message &&
	../configure \
	    --prefix=/usr \
	    --sysconfdir=/etc \
             --enable-elf-shlibs \
             --disable-libblkid \
             --disable-libuuid \
             --disable-uuidd \
             --disable-fsck &&
	compile-message &&
	make || return 11

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 13
	test-message-end
    fi

    install-message && make install || return 15

    rm -fv /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a &&
	gunzip -v /usr/share/info/libext2fs.info.gz &&
	install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info || return 17

    makeinfo -o doc/com_err.info ../lib/et/com_err.texinfo &&
	install -v -m644 doc/com_err.info /usr/share/info &&
	install-info --dir-file=/usr/share/info/dir /usr/share/info/com_err.info
}

build2_sysklogd()
{
    sed -i '/Error loading kernel symbols/{n;n;d}' ksym_mod.c
    sed -i 's/union wait/int/' syslogd.c

    compile-message && make &&
	install-message &&
	make BINDIR=/sbin install

    cat > /etc/syslog.conf << "EOF"
# Begin /etc/syslog.conf

auth,authpriv.* -/var/log/auth.log
*.*;auth,authpriv.none -/var/log/sys.log
daemon.* -/var/log/daemon.log
kern.* -/var/log/kern.log
mail.* -/var/log/mail.log
user.* -/var/log/user.log
*.emerg *

# End /etc/syslog.conf
EOF
}

build2_sysvinit()
{
    compile-message &&
	make &&
	install-message &&
	make install
}

build2_lfs-bootscripts()
{
    make install
}

build2_Linux-PAM()
{
    sed -e /service_DATA/d \
	-i modules/pam_namespace/Makefile.am &&
	autoreconf || return 11

    tar -xf ../Linux-PAM-${PACKAGE_VERSION}-docs.tar.xz --strip-components=1 || return 13

    configure-message &&
	./configure --prefix=/usr \
		    --sbindir=/usr/sbin \
		    --sysconfdir=/etc \
		    --libdir=/usr/lib \
		    --enable-securedir=/usr/lib/security \
		    --docdir=/usr/share/doc/Linux-PAM-1.5.3 || return 15

    compile-message && make || return 17

    install -v -m755 -d /etc/pam.d &&
	cat > /etc/pam.d/other << EOF
auth     required       pam_deny.so
account  required       pam_deny.so
password required       pam_deny.so
session  required       pam_deny.so
EOF

    rm -fv /etc/pam.d/other

    install-message &&
	make install &&
	chmod -v 4755 /usr/sbin/unix_chkpwd
}

make_linux()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    local version=${1}
    local arch=${2}

    local config_file="linux-${version}"
    if test ! -f ../${config_file}.config.bz2 ; then
	echo "*** The configuration file '${config_file}.config.bz2' is missing."
	return 11
    fi
    
    local kernel

    echo "+++ Reseting & Cleaning ${PACKAGE_NAME}..." &&
	make mrproper &&
	make clean &&
	cp -vf ../${config_file}.config.bz2 . &&
	rm -f ${config_file}.config &&
	bunzip2 ${config_file}.config.bz2 || return 13

    sed \
	-e "s/CONFIG_LOCALVERSION=.*/CONFIG_LOCALVERSION=\"-${version}\"/" \
	-e "s/CONFIG_DEFAULT_HOSTNAME=.*/CONFIG_DEFAULT_HOSTNAME=\"${SYS_HOST_NAME}\"/" \
	${config_file}.config > .config

    case ${arch} in
	x64)
	    kernel=arch/x86_64/boot/bzImage
	    ;;
	x86)
	    kernel=arch/x86/boot/bzImage
	    ;;
	*)
	    kernel=arch/i386/boot/bzImage
	    ;;
    esac

    configure-message &&
	make oldconfig &&
	compile-message &&
	make || return 15

    install-message &&
	rm -f /boot/{kernel,System.map,config}-${SYS_VERSION}-${version} &&
	rm -rf /lib/modules/${SYS_VERSION}-${version} &&
	make modules_install || return 21

    test -f ${kernel} || return 23
    test -f System.map || return 23
    test -f .config || return 25

    install -m 644 -o root -g root ${kernel} /boot/kernel-${SYS_VERSION}-${version}
    install -m 644 -o root -g root System.map /boot/System.map-${SYS_VERSION}-${version}
    install -m 644 -o root -g root .config /boot/config-${SYS_VERSION}-${version}

    rm -f /boot/System.map
}

build2_linux()
{
    case ${SYS_ARCHITECTURE} in
	i386|i686|x86)
	    make_linux ${SYS_HM_NAME} x86
	    ;;
	x86_64)
	    make_linux ${SYS_64_NAME} x64
	    ;;
	*)
	    ;;
    esac || return ${?}
    
    mkdir -pv /etc/modprobe.d
}

build2_linux-firmware()
{
    selected_firmware_file="linux-cg-firmware"

    if test ! -f ../${selected_firmware_file}.bz2 ; then
	echo "*** The selected firmware file '${selected_firmware_file}.bz2' is missing."
	return 11
    fi

    cp -vf ../${selected_firmware_file}.bz2 .
    bunzip2 ${selected_firmware_file}.bz2 || return 13

    local file dir extension
    local link linked
    local firmware_dir=/lib/firmware

    rm -rf ${firmware_dir}
    mkdir -vp ${firmware_dir}

    while read file
    do
	test -n "${file}" || continue
	test "${file:0:1}" != '#' || continue

	dir=$(file-dirname ${file})

	if test ! -d ${dir} ; then
	    echo "*** The ${dir} firmware directory no longer exist"
	    return 21
	fi

	mkdir -vp ${firmware_dir}/${dir}
	cp -vf ${file} ${firmware_dir}/${dir}

	extension=${file/*\.}

	case ${extension} in
	    dat|fw|bin|sbin|cld)
		xz --verbose --check=crc32 ${firmware_dir}/${file}
		;;
	    *)
		;;
	esac
    done < ${selected_firmware_file}
}

# Extra LFS

build2_libgpg-error()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static &&
	compile-message &&
	make || return 11

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 13
	test-message-end
    fi

    install-message && make install
}

build2_libassuan()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static &&
	compile-message &&
	make || return 11

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 13
	test-message-end
    fi

    install-message && make install
}

build2_libgcrypt()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static &&
	compile-message &&
	make || return 11

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 13
	test-message-end
    fi

    install-message &&
    make install
}

build2_libksba()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static &&
	compile-message &&
	make || return 11

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 13
	test-message-end
    fi

    install-message &&
    make install
}

build2_pinentry()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static &&
	compile-message &&
	make || return 11

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 13
	test-message-end
    fi

    install-message &&
    make install
}

build2_liblogging()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static &&
	compile-message &&
	make || return 1

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 13
	test-message-end
    fi

    install-message &&
    make install
}

build2_libestr()
{
    configure-message &&
	./autogen.sh &&
	./configure \
	    --prefix=/usr \
	    --disable-static &&
	compile-message &&
	make || return 11

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 13
	test-message-end
    fi

    install-message &&
    make install
}

build2_cmake()
{
    configure-message &&
	./configure \
	    --prefix=/usr &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build2_json-c()
{
    mkdir -v build && cd build || return 11

    configure-message &&	
	cmake -DCMAKE_INSTALL_PREFIX=/usr \
	      -DCMAKE_BUILD_TYPE=Release \
	      -DBUILD_STATIC_LIBS=OFF \
	      .. &&
	compile-message &&
	make || return 11

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make test || return 13
	test-message-end
    fi

    install-message &&
    make install
}

build2_npth()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static &&
	compile-message &&
	make || return 11

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 13
	test-message-end
    fi

    install-message &&
    make install
}

build2_gnupg()
{
    sed -i -e '/noinst_SCRIPTS = gpg-zip/c sbin_SCRIPTS += gpg-zip' tools/Makefile.in &&
	sed -i -e '/^  test_agent_protect/s:^://:' agent/t-protect.c &&
	sed -i -e '174,186 s/^/;;/' tests/openpgp/ecc.scm || return 1

    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static \
	    --enable-symcryptrun \
	    --enable-maintainer-mode \
            --docdir=/usr/share/doc/gnupg-${PACKAGE_VERSION} &&
	compile-message &&
	make &&
	makeinfo --html --no-split -o doc/gnupg_nochunks.html doc/gnupg.texi &&
	makeinfo --plaintext -o doc/gnupg.txt doc/gnupg.texi || return 3
    
    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 5
	test-message-end
    fi
    
    install-message &&
	make install &&
	install -v -m755 -d /usr/share/doc/gnupg-${PACKAGE_VERSION}/html &&
	install -v -m644 doc/gnupg_nochunks.html /usr/share/doc/gnupg-${PACKAGE_VERSION}/html/gnupg.html &&
	install -v -m644 doc/*.texi doc/gnupg.txt /usr/share/doc/gnupg-${PACKAGE_VERSION} || return 7

    local f

    for f in gpg gpgv
    do
	ln -svf ${f}2.1 /usr/share/man/man1/${f}.1 &&
	    ln -svf ${f}2 /usr/bin/${f}
    done || return 9
}

build2_gnupg()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static &&
	compile-message && make || return 11

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 5
	test-message-end
    fi
    
    install-message && make install
}

build2_libfastjson()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static &&
	compile-message && make || return 11

    install-message && make install
}

build1_libssh2()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static &&
	compile-message &&
	make &&
	install-message &&
	make install
}

build1_libpsl()
{
    mkdir -v build && cd build || return 11

    configure-message &&
	meson setup \
	      --prefix=/usr \
	      --buildtype=release &&
	compile-message &&
	ninja &&
	install-message &&
	ninja install
}

build1_curl()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --disable-static \
	    --with-ca-bundle=/etc/ca-bundle.crt \
	    --with-openssl \
            --enable-threaded-resolver &&
	compile-message &&
	make &&
	install-message &&
	make install
}

configure-rsyslog()
{
        cat << EOF
# Begin /etc/rsyslog.conf

\$ModLoad imuxsock.so
\$ModLoad imklog.so

\$template TraditionalFileFormat,"%TIMESTAMP:::date-rfc3339% %HOSTNAME% %syslogtag%%msg:::sp-if-no-1st-sp%%msg:::drop-last-lf%\n"
\$ActionFileDefaultTemplate TraditionalFileFormat

auth,authpriv.* -/var/log/auth.log;TraditionalFileFormat
*.*;auth,authpriv.none -/var/log/sys.log;TraditionalFileFormat
daemon.* -/var/log/daemon.log;TraditionalFileFormat
kern.* -/var/log/kern.log;TraditionalFileFormat
mail.* -/var/log/mail.log;TraditionalFileFormat
user.* -/var/log/user.log;TraditionalFileFormat
*.emerg *;TraditionalFileFormat

# End /etc/rsyslog.conf
EOF
}

build2_rsyslog()
{
    configure-message &&
	./configure \
	    --prefix=/usr \
	    --sbindir=/sbin \
	    --disable-static \
	    --enable-openssl \
	    --enable-omdtls \
	    --enable-imdtls \
	    --disable-libsystemd \
	    --disable-impstats-push \
	    --enable-cached-man-pages \
	    --disable-imfile-tests \
	    PKG_CONFIG_PATH=${PKGCONFIG_DIR} &&
	compile-message &&
	make || return 11

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make check || return 13
	test-message-end
    fi

    install-message && make install || return 15

    if test "${CHECK}" == "yes" ; then
	test-message-begin
	make installcheck || return 15
	test-message-end
    fi

    configure-rsyslog > /etc/rsyslog.conf
}

build2_busybox()
{
    test -f ../busybox.config.bz2 || return 1
    rm -f .config
    cp ../busybox.config.bz2 .config.bz2 &&
	bunzip2 .config.bz2 &&
	configure-message &&
	make oldconfig &&
	compile-message &&
	make &&
	install-message &&
	install -v -m 755 -o root -g root busybox /bin/busybox &&
	install -v -m 644 -o root -g root docs/busybox.1 /usr/share/man/man1/busybox.1 
}

# Main()

# i=0
# PACKAGES_NB=${i}

set-lfs-env
CHECK=no
mkdir -p /tmp/${COMPILE_LOG_DIR}
init-install-env
install-packages /tmp/${COMPILE_LOG_DIR}
