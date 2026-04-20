#!/bin/bash

source /tmp/CacheGuard.env
source /tmp/WorkFunctions

gen-bin-keymaps()
{
    local keymap files
    local dir=/usr/share/${BINKEYMAP_DIR_NAME}

    mkdir -p ${dir}

    files=$(find /usr/share/keymaps/i386 -type f 2> /dev/null)

    for keymap in ${files}
    do
	keymap=${keymap:2}
	! [[ "${keymap}" =~ ^.*include/.* ]] || continue
	keymap=$(file-basename ${keymap} '.map\.gz')
	loadkeys --quiet --bkeymap --unicode ${keymap} > ${dir}/${keymap} 2> /dev/null
    done
}

remove-lib-dbg()
{
    rm -f /usr/lib/*.dbg
}

remove-kernel-build()
{
    local kernel

    case ${SYS_ARCHITECTURE} in
	x86_64)
	    kernel=${SYS_VERSION}-${SYS_64_NAME}
	    ;;
	*)
	    kernel=${SYS_VERSION}-${SYS_HM_NAME}
	    ;;
    esac

    rm -f /usr/lib/modules/${kernel}/build
}

main()
{
    gen-bin-keymaps
    remove-lib-dbg
    remove-kernel-build
}

# Main()

main
