#!/bin/bash

source /tmp/CacheGuard.env
source /tmp/Build.env

gen-busybox-applets()
{
    local applet

    busybox --list > /tmp/busybox-applets.${$}

    while read applet
    do
	test -n "${applet}" || continue
	test ${applet:0:1} != '#' || continue

	test ${applet} != '' || continue

	echo ${applet}

    done < /tmp/busybox-applets.${$} > /tmp/busybox-applets
    rm -f /tmp/busybox-applets.${$}

    echo vi > /tmp/busybox-applets

}

gen-boot-efi()
{
    local arch=$(uname -m 2> /dev/null) bits
    test ${arch} == x86_64 || arch=i386

    grub-mkimage \
	--output=/tmp/boot.efi \
	--format=${arch}-efi \
	--prefix="/${TECHNICAL_NAME}-boot/grub" \
	--config=/tmp/grub.cfg \
	all_video \
	boot \
	efinet \
	echo \
	efi_gop \
	efi_uga \
	fat \
	iso9660 \
	linux \
	part_gpt \
	regexp \
	terminal \
	test \
	tftp \
	true \
	udf
}

optimize-os-size()
{
    echo "+++ Optimizing the CDROM size..."

    test -f /tmp/${TECHNICAL_NAME}-os.tar || return 11

    tar -f \
	/tmp/${TECHNICAL_NAME}-os.tar \
	--wildcards \
	--delete ${INITRD_OS_FILES}

    case ${SYS_ARCHITECTURE} in
	x86_64)
	    tar -f /tmp/${TECHNICAL_NAME}-os.tar --delete boot/kernel-${SYS_VERSION}-${SYS_64_NAME}
	    ;;
	*)
	    tar -f /tmp/${TECHNICAL_NAME}-os.tar --delete boot/kernel-${SYS_VERSION}-${SYS_HM_NAME}
	;;
    esac
}

compress-os()
{
    rm -f /tmp/${TECHNICAL_NAME}-os.tar.{gz,bz2,xz}

    case ${COMPRESS_MODE} in
	xz)
	    echo "+++ XZ Compressing the OS..."
	    xz --threads=${WORKING_CPU_NB} --check=crc32 /tmp/${TECHNICAL_NAME}-os.tar
	    ;;
	gz)
	    echo "+++ GZip Compressing the OS..."
	    gzip /tmp/${TECHNICAL_NAME}-os.tar
	    ;;
	*)
	    gzip /tmp/${TECHNICAL_NAME}-os.tar
	    ;;
    esac
}

main()
{
    gen-busybox-applets
    gen-boot-efi
    optimize-os-size && compress-os
}

# Main()

main
