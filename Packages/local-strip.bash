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

do-strip()
{
    local lib bin file

    local save_usrlib="$(cd /usr/lib; ls ld-linux*.so.[0-9] 2> /dev/null)
    	  libc.so.6
	  libthread_db.so.1
	  libquadmath.so.0.0.0
	  libstdc++.so.6.0.29
	  libitm.so.1.0.0
	  libatomic.so.1.2.0"

    cd /usr/lib

    for lib in ${save_usrlib}
    do
	objcopy --only-keep-debug ${lib} ${lib}.dbg
	cp ${lib} /tmp/${lib}
	strip --strip-unneeded /tmp/${lib}
	objcopy --add-gnu-debuglink=${lib}.dbg /tmp/${lib}
	install -m755 /tmp/${lib} /usr/lib
	rm /tmp/${lib}
    done

    local online_usrbin="bash find strip"
    local online_usrlib="libbfd-2.38.so
               libhistory.so.8.1
               libncursesw.so.6.3
               libm.so.6
               libreadline.so.8.1
               libz.so.1.2.11
               $(cd /usr/lib; find libnss*.so* -type f)"

    for bin in ${online_usrbin}
    do
	cp /usr/bin/${bin} /tmp/${bin}
	strip --strip-unneeded /tmp/${bin}
	install -m755 /tmp/${bin} /usr/bin
	rm /tmp/${bin}
    done

    for lib in ${online_usrlib}
    do
	cp /usr/lib/${lib} /tmp/${lib}
	strip --strip-unneeded /tmp/${lib}
	install -m755 /tmp/${lib} /usr/lib
	rm /tmp/${lib}
    done

    for file in $(find /usr/lib -type f -name \*.so* ! -name \*dbg) \
		$(find /usr/lib -type f -name \*.a) \
		$(find /usr/{bin,sbin,libexec} -type f)
    do
	case "${online_usrbin} ${online_usrlib} ${save_usrlib}" in
            *$(basename ${file})* )
            ;;
        * ) strip --strip-unneeded ${file}
            ;;
        esac
    done
}

main()
{
    do-strip 2>&1 \
	| grep --invert-match "file format not recognized" \
	| grep --invert-match "File truncated" \
	| grep --invert-match "strip: error while loading shared libraries" \
	| grep --invert-match "objcopy: error while loading shared libraries:" \
	| grep --invert-match "debuglink section already exists" \
    	| grep --invert-match "strip: unable to copy file '/usr/bin/grep';" 
    
	       
}

main
