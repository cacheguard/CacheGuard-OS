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
