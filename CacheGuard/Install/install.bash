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

test -n "${LFS}" || exit 1
test -d "${LFS}" || exit 2
test -n "${APL}" || exit 3
test -d "${APL}" || exit 4

source CacheGuard.env
source WorkFunctions
source INSTALL.env

set-main-env()
{
    local mode=${1}

    DEVELOPMENT_INSTALL_MODE=yes
    REMOTE_DEBUG_MODE=no
    INSTALL_VERBOSE_MODE=no

    AUTO_INSTALL_ROLE=manager
    AUTO_INSTALL_ROLE=gateway

    PXE_MODE=efi
    PXE_MODE=bios

    local file

    case ${SYS_ARCHITECTURE} in
	x86_64)
	    SYS_ARCHITECTURE_BITS=64
	    SYS_ARCHITECTURE_CPU=X64
	    ;;
	*)
	    SYS_ARCHITECTURE_BITS=32
	    SYS_ARCHITECTURE_CPU=X86
	    ;;
    esac

    case ${mode} in
	prod)
	    DEVELOPMENT_INSTALL_MODE=no
	    COMPRESS_MODE=xz
	    WORKING_CPU_NB=$(get-max-working-cpu)
	    ;;
	*)
	    COMPRESS_MODE=gz
	    ;;
    esac

    DHCPD_DEV=eth2

    export SYSLINUX_DIR=${LFS}/usr/share/syslinux
    export SYSLINUX_COMMON_FILES="ldlinux.c32 libcom32.c32 libutil.c32 menu.c32"

    for file in ${SYSLINUX_COMMON_FILES} \
		isolinux.bin \
		pxelinux.0 \
		isohdpfx.bin
    do
	test ! -f ${SYSLINUX_DIR}/${file} || continue
	echo "**** Error: the ${SYSLINUX_DIR}/${file} file is missing."
	exit 11
    done

    for file in \
	efi${SYS_ARCHITECTURE_BITS}/syslinux.efi \
	   efi${SYS_ARCHITECTURE_BITS}/ldlinux.e${SYS_ARCHITECTURE_BITS}
    do
	test ! -f ${SYSLINUX_DIR}/${file} || continue
	echo "**** Error: the ${SYSLINUX_DIR}/${file} file is missing."
	exit 11
    done
    
    export KERNEL_FILE=${APL}/boot/kernel-${SYS_VERSION}-${SYS_NAME}
    export KERNEL_HM_FILE=${APL}/boot/kernel-${SYS_VERSION}-${SYS_HM_NAME}
    export KERNEL_64_FILE=${APL}/boot/kernel-${SYS_VERSION}-${SYS_64_NAME}
}

gen-dev2run-env()
{
    echo export PATH=/sbin:/usr/sbin:${LOCAL_DIR}/sbin:/bin:/usr/bin:${LOCAL_DIR}/bin
    echo export INSTALL_BACKTITLE="'${COMMERCIAL_NAME}-OS ${OS_GENERATION}-${OS_VERSION}'"
    echo export APL=/mnt/$(basename ${APL})
    echo export LICENSE=${ADMIN_DIR}${APPLIANCE_DIR}/man/man1/license.1
    echo export MAX_UPLOAD_FILE_SZ=$[${MAX_UPLOAD_FILE_SZ} / 1024]
    echo export DEFAULT_MAX_UPLOAD_FILE_SZ=$[${MAX_UPLOAD_FILE_SZ} / 1024]
    echo export INITRD_OS_FILES=\'${INITRD_OS_FILES}\'
    echo export DEV_KEYBOARD=${DEV_KEYBOARD}

    echo export REMOTE_DEBUG_MODE=${REMOTE_DEBUG_MODE}

    if test ${DEVELOPMENT_INSTALL_MODE} == yes ; then
	echo export APL_MODEL=test
	echo export APL_ROLE=${AUTO_INSTALL_ROLE}
	echo export TEST_SRC_PROTOCOL=${TEST_SRC_PROTOCOL}
	echo export TEST_SRC_IP=${TEST_SRC_IP}
	echo export TEST_SRC_DIR=${TEST_SRC_DIR}
    else
	echo unset APL_MODEL
    fi
}

gen-build-env()
{
    echo export INITRD_OS_FILES=\'${INITRD_OS_FILES}\'
    echo export COMPRESS_MODE=${COMPRESS_MODE}
    echo export WORKING_CPU_NB=${WORKING_CPU_NB}
}

gen-syslinux-cfg()
{
    test -n "${1}" || return 1
    itype=${1}

    local timeout

    if test ${DEVELOPMENT_INSTALL_MODE} == yes -o ${REMOTE_DEBUG_MODE} == yes ; then
	timeout=1
    else
	timeout=300
    fi

    local options="install=${itype} root=/dev/ram0 prompt_ramdisk=0 devfs=mount load_ramdisk=1 rw lang= ramdisk_size=${INSTALL_RAMDISK_SIZE} init=/sbin/init irqpoll"
    local title="MENU TITLE ${COMMERCIAL_NAME}-OS version ${OS_GENERATION}-${OS_VERSION} Installation"

    local initrd kernel dir

    case ${SYS_ARCHITECTURE} in
	x86_64)
	    title="${title} (64 bits)"
	    kernel=${CG_KERNEL_64}
	    initrd=${CG_INITRD_64}
	    ;;
	*)
	    title="${title} (32 bits)"
	    kernel=${CG_KERNEL_HM}
	    initrd=${CG_INITRD_HM}
	    ;;
    esac

    case ${itype} in
	iso)
	    dir='/'
	    ;;
	pxe)
	    dir='../../'
	    ;;
	*)
	    ;;
    esac

    echo UI menu.c32
    echo SERIAL 0 ${SERIAL_SPEED}
    echo SERIAL 1 ${SERIAL_SPEED}
    echo TIMEOUT ${timeout}

    echo
    echo -e "${title}"
    echo
    echo -e "LABEL Console on Screen/Keyboard (Default)"
    echo -e "\tAPPEND console=tty0 ${options}"
    echo -e "\tLINUX ${dir}${TECHNICAL_NAME}-boot/${kernel}"
    echo -e "\tINITRD ${dir}${TECHNICAL_NAME}-boot/${initrd}"
    echo
    echo -e "LABEL Console on Serial Port: ${SERIAL_SPEED}${SERIAL_CONF}"
    echo -e "\tAPPEND console=ttyS0,${SERIAL_SPEED}${SERIAL_CONF} ${options}"
    echo -e "\tLINUX ${dir}${TECHNICAL_NAME}-boot/${kernel}"
    echo -e "\tINITRD ${dir}${TECHNICAL_NAME}-boot/${initrd}"
}

gen-grub-cfg()
{
    local options="root=/dev/ram0 prompt_ramdisk=0 devfs=mount load_ramdisk=1 rw lang= ramdisk_size=${INSTALL_RAMDISK_SIZE} init=/sbin/init irqpoll"

    cat <<EOF
insmod progress

boot="(\${root})/${TECHNICAL_NAME}-boot/"

regexp "tftp,.+" "\${root}"
if test \${?} -eq 0 ; then
   itype="pxe"
else
   itype="iso"
fi

menuentry "Console on Screen/Keyboard (Default)" {
    linux \${boot}cg_kernel_64 install=\${itype} console=tty0 ${options}
    initrd \${boot}cg_initrd_64
}

menuentry "Console on Serial Port: ${SERIAL_SPEED}${SERIAL_CONF}" {
    insmod serial
    serial --unit=0 --speed=${SERIAL_SPEED} --word=8 --parity=no --stop=1
    linux \${boot}cg_kernel_64 install=\${itype} console=ttyS0,${SERIAL_SPEED}${SERIAL_CONF} ${options}
    initrd \${boot}cg_initrd_64
}
EOF
}

gen-dhcp-conf()
{
    local network_info=$(ip address show dev ${DHCPD_DEV} | tail -2 | head -1 | tr -s ' ')
    local inet=${network_info/ inet */inet}
    test "${inet}" == inet || return 13

    local boot_file
    local ip_mk=${network_info/*inet /}
    ip_mk=${ip_mk/ brd*}

    local ip=${ip_mk/\/*}
    local mk=${ip_mk/*\/}

    local tftp_server_ip=${ip}
    local network_ip=${ip%\.*}.0

    local network_mask=255.255.255.0
    local min_ip=${ip%\.*}.101
    local max_ip=${ip%\.*}.200

    case ${PXE_MODE} in
	bios)
	    boot_file="/${TECHNICAL_NAME}-boot/isolinux/pxelinux.0"
	    ;;
	efi)
	    boot_file="/${TECHNICAL_NAME}-boot/pxeboot.efi"
	    ;;
	*)
	    ;;
    esac

    cat etc.dhcpd.conf
    echo
    echo "filename \"${boot_file}\";"
    echo
    echo -e "subnet ${network_ip} netmask ${network_mask} {"
    echo -e "\trange ${min_ip} ${max_ip};"
    echo -e "\tnext-server ${tftp_server_ip};"
    echo "}"
}

gen-default-dhcp-server()
{
    echo "INTERFACESv4=\"${DHCPD_DEV}\""
}

gen-fstab()
{
    cat << EOF
# Begin /etc/fstab

# FileSystem Mount-Point FS-Type Options Dump Fsck-Order

proc /proc proc nosuid,noexec,nodev 0 0
sysfs /sys sysfs nosuid,noexec,nodev 0 0

# End /etc/fstab
EOF
}

gen-inittab()
{
    cat << EOF
# Begin /etc/inittab

id:7:initdefault:
l1:7:wait:/etc/rc.d/init.d/rc 7

# End /etc/inittab
EOF
}

gen-system-conf-files()
{
    gen-fstab > ${GENERATED_DIR}/etc.fstab
    gen-inittab > ${GENERATED_DIR}/inittab
    gen-dhcp-conf > ${GENERATED_DIR}/etc.dhcpd.conf
    gen-default-dhcp-server > ${GENERATED_DIR}/etc.default.isc-dhcp-server
}

gen-abstract()
{
    echo "${COMMERCIAL_NAME}-${OS_GENERATION} UTM Appliance"
}

gen-bibliography()
{
    echo "${WEBSITE}"
}

gen-copyright()
{
    echo "Copyright (C) ${YEARS} ${COMMERCIAL_NAME}"
}

gen-cdrom-conf-files()
{
    gen-abstract > ${GENERATED_DIR}/abstract.txt
    gen-bibliography > ${GENERATED_DIR}/bibliography.txt
    gen-copyright > ${GENERATED_DIR}/copyright.txt
}

gen-maintenance-scripts()
{
    gen-raid-fail > ${GENERATED_DIR}/raidfail
}

gen-useful-files()
{
    gen-system-conf-files
    gen-cdrom-conf-files
    gen-maintenance-scripts
}

gen-raid-fail()
{
    sed \
	-e "s/@RAID_MD_NB@/${RAID_MD_NB}/g" \
	-e "s/@RAID_PARTITION_NB@/${RAID_PARTITION_NB}/g" \
	raidfail
}

pxe-install()
{
    test -n "${TFTPBOOT_DIR}" || return 11
    test -d "${TFTPBOOT_DIR}" || return 13

    sudo install -m 644 -o root -g root ${GENERATED_DIR}/etc.dhcpd.conf /etc/dhcp/dhcpd.conf
    sudo install -m 644 -o root -g root ${GENERATED_DIR}/etc.default.isc-dhcp-server /etc/default/isc-dhcp-server

    sudo rm -rf ${TFTPBOOT_DIR}/${TECHNICAL_NAME}-boot
    sudo rm -rf ${TFTPBOOT_DIR}/${TECHNICAL_NAME}

    sudo cp -rf ${CDROM_GENERATED_DIR}/${TECHNICAL_NAME}-boot ${TFTPBOOT_DIR}/
    sudo cp -rf ${CDROM_GENERATED_DIR}/isolinux ${TFTPBOOT_DIR}/${TECHNICAL_NAME}-boot
    sudo cp -rf ${CDROM_GENERATED_DIR}/${TECHNICAL_NAME} ${TFTPBOOT_DIR}/

    sudo chown \
	 -R nobody:nogroup \
	 ${TFTPBOOT_DIR}/${TECHNICAL_NAME} \
	 ${TFTPBOOT_DIR}/${TECHNICAL_NAME}-boot
}

get-compressed-file-extension()
{
    case ${COMPRESS_MODE} in
	xz)
	    extension=xz
	    ;;
	gz)
	    extension=gz
	    ;;
	bz)
	    extension=bz2
	    ;;
	*)
	    extension=gz
	    ;;
    esac

    echo ${extension}
}

iso-install()
{
    local syslinux_iso_dir=${CDROM_GENERATED_DIR}/isolinux
    local boot_dir=${CDROM_GENERATED_DIR}/${TECHNICAL_NAME}-boot
    local grub_dir=${boot_dir}/grub
    local os_dir=${CDROM_GENERATED_DIR}/${TECHNICAL_NAME}
    local etc_dir=${CDROM_GENERATED_DIR}/${TECHNICAL_NAME}-etc
    local doc_dir=${CDROM_GENERATED_DIR}/${TECHNICAL_NAME}-${DOC_DIR_NAME}
    local js_dir=${doc_dir}/${JS_DIR_NAME}
    local doc_guide_dir=${doc_dir}/guide
    local doc_command_dir=${doc_dir}/command

    local label=EFI
    local src_doc_dir=../Sources/Documentation
    local extension=$(get-compressed-file-extension)

    local grub_arch kernel
    local file files

    case ${SYS_ARCHITECTURE} in
	x86_64)
	    grub_arch=${SYS_ARCHITECTURE}-efi
	    kernel=${SYS_VERSION}-${SYS_64_NAME}
	    ;;
	*)
	    grub_arch=i386-pc
	    kernel=${SYS_VERSION}-${SYS_HM_NAME}
	    ;;
    esac

    test -n "${CDROM_GENERATED_DIR}" || exit 99
    rm -rf ${CDROM_GENERATED_DIR}/*

    mkdir -p \
	  ${syslinux_iso_dir}/pxelinux.cfg \
	  ${boot_dir} \
	  ${grub_dir}/${grub_arch} \
	  ${os_dir} \
	  ${doc_command_dir} \
	  ${doc_guide_dir} \
	  ${doc_dir}/${IMAGE_DIR_NAME} \
	  ${js_dir} \
	  ${etc_dir}

    for file in ${SYSLINUX_COMMON_FILES} isolinux.bin
    do
	install -m 644 ${SYSLINUX_DIR}/${file} ${syslinux_iso_dir}
    done

    dd if=/dev/zero of=${syslinux_iso_dir}/efiboot.img bs=1M count=10 > /dev/null 2>&1
    sudo mkfs -t vfat -n ${label} -F 12 ${syslinux_iso_dir}/efiboot.img > /dev/null 2>&1

    mmd -i ${syslinux_iso_dir}/efiboot.img ::EFI
    mmd -i ${syslinux_iso_dir}/efiboot.img ::EFI/BOOT

    mcopy -i ${syslinux_iso_dir}/efiboot.img ${GENERATED_DIR}/boot.efi ::EFI/BOOT/BOOTX${SYS_ARCHITECTURE_BITS}.EFI

    test ! -f ${KERNEL_HM_FILE} || \
	install -m 644 ${KERNEL_HM_FILE} ${boot_dir}/${CG_KERNEL_HM}
    test ! -f ${KERNEL_64_FILE} || \
	install -m 644 ${KERNEL_64_FILE} ${boot_dir}/${CG_KERNEL_64}

    test ! -f ${GENERATED_DIR}/${CG_INITRD_HM}.${extension} || \
	install -m 644 ${GENERATED_DIR}/${CG_INITRD_HM}.${extension} ${boot_dir}/${CG_INITRD_HM}
    test ! -f ${GENERATED_DIR}/${CG_INITRD_64}.${extension} || \
	install -m 644 ${GENERATED_DIR}/${CG_INITRD_64}.${extension} ${boot_dir}/${CG_INITRD_64}

    rm -f ${os_dir}/os.*
    for file in ${GENERATED_DIR}/os.* ; do
	install -m 644 ${file} ${os_dir}
    done

    install -m 644 ${GENERATED_DIR}/isolinux.cfg ${syslinux_iso_dir}/
    install -m 644 ${GENERATED_DIR}/pxelinux.cfg ${syslinux_iso_dir}/pxelinux.cfg/default
    install -m 644 ${SYSLINUX_DIR}/pxelinux.0	 ${syslinux_iso_dir}/
    install -m 644 ${GENERATED_DIR}/boot.efi	 ${boot_dir}/pxeboot.efi

    cp -f ${src_doc_dir}/OnlineCommands/${GENERATED_DIR}/*.html ${doc_command_dir}
    cp -f ${src_doc_dir}/UsersGuide/HTML${GENERATED_DIR}/*.html ${doc_guide_dir}
    cp -f ${src_doc_dir}/UsersGuide/Schema/*.png ${doc_dir}/${IMAGE_DIR_NAME}
    cp -f ${src_doc_dir}/UsersGuide/Image/* ${doc_dir}/${IMAGE_DIR_NAME}
    cp -f ${src_doc_dir}/Image/* ${doc_dir}/${IMAGE_DIR_NAME}
    cp -f ${src_doc_dir}/apl.css ${doc_dir}
    cp -f ${src_doc_dir}/favicon.ico ${doc_dir}

    for file in ${src_doc_dir}/JS/*.js
    do
	cp -f ${file} ${js_dir}
    done

    files=$(find ${doc_dir} -type f -name "*.html")
    for file in ${files}
    do
	sed -i -e "s@/${DOC_DIR_NAME}/@../@g" ${file}
    done

    cat ${src_doc_dir}/jquery_treeview.css | sed -e "s@/${DOC_DIR_NAME}/${IMAGE_DIR_NAME}/@${IMAGE_DIR_NAME}/@g" > ${doc_dir}/jquery_treeview.css

    install -m 644 ${GENERATED_DIR}/grub.cfg ${grub_dir}/grub.cfg

    for file in progress \
		cat \
		chain \
		configfile \
		crypto \
		font \
		gfxterm \
		halt \
		help \
		keystatus \
		linux16 \
		loopback \
		ls \
		normal \
		probe \
		read \
		reboot \
		serial \
		terminfo \
		video_colors \
		videoinfo
    do
	install -m 644 ${APL}/usr/lib/grub/${grub_arch}/${file}.mod ${grub_dir}/${grub_arch}/
    done

    install -m 644 README.txt ${CDROM_GENERATED_DIR}

    install -m 644 ${GENERATED_DIR}/CGL.txt ${etc_dir}
    install -m 644 GPL.txt ${etc_dir}/GPL.txt
    install -m 644 cacheguard.ico ${etc_dir}/cacheguard.ico
    install -m 644 ${MAIN_MIB_NAME} ${etc_dir}/${MAIN_MIB_NAME}

}

make-cdrom()
{
    local cur_dir=${PWD} arch

    mkdir -p ${OS_IMAGE_DIR}

    cd ${CDROM_GENERATED_DIR}

    local application_id="${COMMERCIAL_NAME}-${OS_GENERATION} transforms an x86/x64 based machine into a network appliance."
    local publisher_id="CacheGuard Technologies Ltd - www.cacheguard.com"
    local preparer_id="CacheGuard Technologies Ltd - www.cacheguard.com"
    local system_id="${COMMERCIAL_NAME}-${OS_GENERATION}-${OS_VERSION}-${SYS_ARCHITECTURE_CPU}"
    local volume_set="${system_id}"
    local volume_id="${system_id}"

    case ${SYS_ARCHITECTURE} in
	x86_64)
	    arch="X64"
	    ;;
	*)
	    arch="X86"
	    ;;
    esac

    local iso_file="${cur_dir}/${OS_IMAGE_DIR}/${COMMERCIAL_NAME}-${OS_GENERATION}-${OS_VERSION}-${arch}.iso"

    echo "+++ Burning the CDROM..."
    xorrisofs \
	-quiet \
	-full-iso9660-filenames \
	-rational-rock \
	-m . -m .. \
	-joliet-long \
	-allow-lowercase \
	-appid "${application_id}" \
	-abstract ../${GENERATED_DIR}/abstract.txt \
	-biblio ../${GENERATED_DIR}/bibliography.txt \
	-copyright ../${GENERATED_DIR}/copyright.txt \
	-publisher "\"${publisher_id}\"" \
	-preparer "${preparer_id}" \
	-sysid "${system_id}" \
	-volset "${volume_set}" \
	-volid "${volume_id}" \
	-iso-level 4 \
	-pad \
	-isohybrid-mbr ${SYSLINUX_DIR}/isohdpfx.bin \
	-isohybrid-gpt-basdat \
	-c isolinux/boot.cat \
	-eltorito-boot isolinux/isolinux.bin \
	-no-emul-boot \
	-boot-load-size 4 \
	-boot-info-table \
	-eltorito-alt-boot \
	-e isolinux/efiboot.img -no-emul-boot \
	-o ${iso_file} \
	. > /dev/null 2>&1
    
    cd ${cur_dir}
}

split-os()
{
    echo "+++ Splitting the OS..."

    local os extension kbytes
    local cur_dir=${PWD}

    rm -f ${GENERATED_DIR}/os.*

    case ${COMPRESS_MODE} in
	xz)
	    kbytes=3072
	    extension=xz
	    ;;
	gz)
	    kbytes=5120
	    extension=gz
	    echo "development mode" > ${GENERATED_DIR}/os.dv
	    ;;
	*)
	    kbytes=5120
	    extension=gz
	    ;;
    esac

    cd ${GENERATED_DIR}

    test -f ${TECHNICAL_NAME}-os.tar.${extension} || return 11

    split --suffix-length=2 --bytes=${kbytes}kB --numeric-suffixes=00 ${TECHNICAL_NAME}-os.tar.${extension} os.
    ls os.[0-9]* | wc -l > os.xx

    for os in os.[0-9]*
    do
	sha1sum ${os}
    done > os.sg

    cd ${cur_dir}
}

custom-ramdisk()
{
    test -n "${1}" || return 1
    local dst_rdir=${1}

    test -d ${dst_rdir} || return 11
    test -f ${GENERATED_DIR}/busybox-applets || return 13

    local file base link rdir
    local kernel

    sudo install -v -m 644 -o root -g root ${GENERATED_DIR}/etc.fstab ${dst_rdir}/etc/fstab

    sudo install -v -d -m  777 -o root -g root ${dst_rdir}${INSTALL_DIR}
    sudo install -v -d -m  755 -o root -g root ${dst_rdir}${APL}
    sudo install -v -d -m  755 -o root -g root ${dst_rdir}/proc
    sudo install -v -d -m  755 -o root -g root ${dst_rdir}/sys
    sudo install -v -d -m 1777 -o root -g root ${dst_rdir}/tmp
    sudo install -v -d -m 755 -o root -g root ${dst_rdir}/etc/rc.d/rc7.d

    sudo mv -f ${dst_rdir}/etc/inittab ${dst_rdir}/etc/inittab.save
    sudo install -v -m 644 -o root -g root ${GENERATED_DIR}/inittab ${dst_rdir}/etc/inittab

    sudo install -v -m 644 -o root -g root INSTALL.env ${dst_rdir}${INSTALL_DIR}
    sudo install -v -m 644 -o root -g root ${GENERATED_DIR}/RUN.env ${dst_rdir}${INSTALL_DIR}/RUN.env
    sudo install -v -m 644 -o root -g root constant ${dst_rdir}${INSTALL_DIR}/constant
    sudo install -v -m 644 -o root -g root common-functions ${dst_rdir}${INSTALL_DIR}/common-functions
    sudo install -v -m 644 -o root -g root device-functions ${dst_rdir}${INSTALL_DIR}/device-functions
    sudo install -v -m 644 -o root -g root install-functions ${dst_rdir}${INSTALL_DIR}/install-functions
    sudo install -v -m 644 -o root -g root functions ${dst_rdir}${INSTALL_DIR}/functions
    sudo install -v -m 754 -o root -g root apl_install ${dst_rdir}${INSTALL_DIR}/apl_install
    sudo install -v -m 755 -o root -g root Tuner/apl_model_configure ${dst_rdir}${INSTALL_DIR}/apl_model_configure
    sudo install -v -m 755 -o root -g root Tuner/apl_model_install ${dst_rdir}${INSTALL_DIR}/apl_model_install
    sudo install -v -m 644 -o root -g root ${GENERATED_DIR}/raidfail ${dst_rdir}${INSTALL_DIR}/raidfail
    sudo install -v -m 754 -o root -g root install ${dst_rdir}/etc/rc.d/init.d/install
    sudo install -v -m 755 -o root -g root ${APL}/usr/sbin/dhclient-script ${dst_rdir}/usr/sbin/dhclient-script

    sudo ln -vsf ../init.d/install ${dst_rdir}/etc/rc.d/rc7.d/S00install
    sudo ln -vsf install ${dst_rdir}/root

    case ${SYS_ARCHITECTURE} in
	x86_64)
	    kernel=${SYS_VERSION}-${SYS_64_NAME}
	    ;;
	*)
	    kernel=${SYS_VERSION}-${SYS_HM_NAME}
	    ;;
    esac

    sudo mkdir -vp \
	 ${dst_rdir}/usr/bin \
	 ${dst_rdir}/usr/sbin

    while read file
    do
	test -n "${file}" || continue
	test ${file:0:1} != '#' || continue

	sudo ln -vsf busybox ${dst_rdir}/usr/bin/${file}
    done < ${GENERATED_DIR}/busybox-applets

    while read file
    do
	test -n "${file}" || continue
	test ${file:0:1} != '#' || continue

	! grep --quiet ${file} ${GENERATED_DIR}/busybox-applets || continue
	rdir=$(file-dirname ${file})
	sudo cp -va ${APL}/${file} ${dst_rdir}/${rdir}/
    done < binaries.lst

    while read file
    do
	test -n "${file}" || continue
	test ${file:0:1} != '#' || continue

	sudo cp -va ${APL}/${file} ${dst_rdir}/usr/lib/
    done < ${GENERATED_DIR}/libraries.lst

    if test ${DEVELOPMENT_INSTALL_MODE} == yes ; then
	sudo install -v -m 600 -o root -g root ssh/id_rsa ${dst_rdir}${INSTALL_DIR}/id_rsa
    fi
}

local-install-lfs()
{
    sudo install -m 644 -o root -g root WorkFunctions ${LFS}/tmp/
    sudo install -m 644 -o root -g root CacheGuard.env ${LFS}/tmp/
    sudo install -m 644 -o root -g root unlinked-libraries.lst ${LFS}/tmp/
    sudo install -m 644 -o root -g root binaries.lst  ${LFS}/tmp/
    sudo install -m 755 -o root -g root local-install-lfs.bash ${LFS}/tmp/

    sudo chroot ${LFS} /tmp/local-install-lfs.bash

    cp -f ${LFS}/tmp/libraries.lst ${GENERATED_DIR}/libraries.lst

    sudo rm -f \
	 ${LFS}/tmp/WorkFunctions \
	 ${LFS}/tmp/CacheGuard.env \
	 ${LFS}/tmp/unlinked-libraries.lst \
	 ${LFS}/tmp/binaries.lst \
	 ${LFS}/tmp/libraries.lst \
	 ${LFS}/tmp/local-install-lfs.bash
}

create-initrd()
{
    local initrd initrd_sz
    local output

    if test "${INSTALL_VERBOSE_MODE}" == yes ; then
	output=/dev/stdout
    else
	output=/dev/null
    fi

    echo "+++ Generating the InitRD..."

    export INITRD_OS_FILES="
bin
etc
lib
run
sbin
usr/lib/firmware
usr/lib/grub
usr/lib/lsb
usr/lib/modules
usr/lib/services/init-functions
usr/lib/udev
usr/libexec/sshd-session
usr/share/${BINKEYMAP_DIR_NAME}
usr/share/groff
usr/share/grub
usr/share/i18n
usr/share/keymaps
usr/share/pci.ids.gz
usr/share/terminfo
usr/share/usb.ids
usr/share/zoneinfo
var
${ADMIN_DIR:1}${APPLIANCE_DIR}/man/man1/license.1
$(cat binaries.lst) $(cat ${GENERATED_DIR}/libraries.lst)
"
    INITRD_OS_FILES=${INITRD_OS_FILES:1}

    gen-dev2run-env > ${GENERATED_DIR}/RUN.env

    initrd_sz=$(get-size-of-files-in-dir ${APL} "${INITRD_OS_FILES}")
    initrd_sz=$[${initrd_sz} + (16 * 1024)]

    export INSTALL_RAMDISK_SIZE=$[${initrd_sz} + (16 * 1024)]

    case ${SYS_ARCHITECTURE} in
	x86_64)
	    gen-root-fs \
		ext2 \
		${GENERATED_DIR} \
		${CG_INITRD_64} \
		${PWD}/../OS/${GENERATED_DIR}/${TECHNICAL_NAME}-os.tar \
		${initrd_sz} \
		dev ${INITRD_OS_FILES} > ${output} 2>&1 || return $[100+${?}]
	    initrd=${CG_INITRD_64}
	    ;;
	*)
	    gen-root-fs \
		ext2 \
		${GENERATED_DIR} \
		${CG_INITRD_HM} \
		${PWD}/../OS/${GENERATED_DIR}/${TECHNICAL_NAME}-os.tar \
		${initrd_sz} \
		dev ${INITRD_OS_FILES} > ${output} 2>&1 || return $[100+${?}]
	    initrd=${CG_INITRD_HM}
	    ;;
    esac

    rm -f ${GENERATED_DIR}/${initrd}.{gz,bz2,xz}

    case ${COMPRESS_MODE} in
	xz)
	    echo "+++ XZ Compressing the InitRD..."
	    xz --memlimit=20% --threads=${WORKING_CPU_NB} --check=crc32 ${GENERATED_DIR}/${initrd}
	    ;;
	gz)
	    echo "+++ GZip Compressing the InitRD..."
	    gzip ${GENERATED_DIR}/${initrd}
	    ;;
	*)
	    echo "+++ GZip Compressing the InitRD..."
	    gzip ${GENERATED_DIR}/${initrd}
	    ;;
    esac
}

local-install-apl()
{
    rm -f ${GENERATED_DIR}/${TECHNICAL_NAME}-os.tar.{gz,bz2,xz}

    local extension=$(get-compressed-file-extension)

    gen-build-env > ${GENERATED_DIR}/Build.env

    sudo install -m 644 -o root -g root CacheGuard.env ${APL}/tmp/
    sudo install -m 644 -o root -g root ${GENERATED_DIR}/Build.env ${APL}/tmp/
    sudo install -m 644 -o root -g root grub.cfg.embedded ${APL}/tmp/grub.cfg
    sudo install -m 755 -o root -g root local-install-apl.bash ${APL}/tmp/
    sudo install -m 644 -o root -g root ../OS/${GENERATED_DIR}/${TECHNICAL_NAME}-os.tar ${APL}/tmp/

    sudo chroot ${APL} /tmp/local-install-apl.bash

    cp -f ${APL}/tmp/busybox-applets ${GENERATED_DIR}/busybox-applets
    cp -f ${APL}/tmp/boot.efi ${GENERATED_DIR}/boot.efi
    cp -f ${APL}/tmp/${TECHNICAL_NAME}-os.tar.${extension} ${GENERATED_DIR}/

    sudo rm -f \
	 ${APL}/tmp/CacheGuard.env \
	 ${APL}/tmp/Build.env \
	 ${APL}/tmp/local-install-apl.bash \
	 ${APL}/tmp/${TECHNICAL_NAME}-os.tar.${extension} \
	 ${APL}/tmp/busybox-applets \
	 ${APL}/tmp/grub.cfg \
	 ${APL}/tmp/boot.efi
}

gen-boot-conf-files()
{
    gen-syslinux-cfg iso > ${GENERATED_DIR}/isolinux.cfg
    gen-syslinux-cfg pxe > ${GENERATED_DIR}/pxelinux.cfg

    gen-grub-cfg > ${GENERATED_DIR}/grub.cfg
}

chown-cdrom()
{
    sudo chown -R ${USER}:${USER} ${GENERATED_DIR}/ ${CDROM_GENERATED_DIR}/
}

main()
{
    set-main-env "${@}"

    if test "${INSTALL_VERBOSE_MODE}" == yes ; then
	make
    else
	make > /dev/null 2>&1
    fi

    gen-useful-files
    local-install-lfs
    create-initrd || return ${?}
    local-install-apl
    gen-boot-conf-files
    split-os
    iso-install
    pxe-install
    make-cdrom
    chown-cdrom
}

# Main

mkdir -p ${FULL_GENERATED_DIR}
ln -sf ${FULL_GENERATED_DIR}
mkdir -p ${BASE_GENERATED_DIR}/${CDROM_GENERATED_DIR}
ln -sf ${BASE_GENERATED_DIR}/${CDROM_GENERATED_DIR}

main "${@}"
