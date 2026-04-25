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

test -n "${APL}" || exit 1
test -d "${APL}" || exit 2

gen-cachegurd-env()
{
    local mode=${1}

    case ${1} in
	''|dev)
	    echo "export APL_MODEL=\"test\""
	    echo "export WEB_PROTOCOL=\"http\""
	    ;;
	pprod)
	    echo "export WEB_PROTOCOL=\"http\""
	    echo "export NETWORK_WEBSITE=\"test-www.cacheguard.net\""
	    echo "export OS_WEBSITE=\"test-os.cacheguard.net\""
	    echo "export APPLIANCE_WEBSITE=\"test-appliance.cacheguard.net\""
	    echo "export MANAGER_WEBSITE=\"test-manager.cacheguard.net\""
	    ;;

	*)
	    ;;
    esac

    local tmp_file=/tmp/cg-commands.${$}
    local tmp_file_sorted=${tmp_file}.sorted
    local commands cmd

    ls -1 Sources/Commands/bin/ 2> /dev/null > ${tmp_file}
    echo exit >> ${tmp_file}
    echo history >> ${tmp_file}
    sort ${tmp_file} > ${tmp_file_sorted}
    while read cmd
    do
	commands="${commands} ${cmd}"
    done < ${tmp_file_sorted}
    rm -f ${tmp_file_sorted} ${tmp_file}
    commands="${commands:1}"

    cat LFS.env
    echo
    cat APPLIANCE.env
    echo
    cat CacheGuard.env-1
    echo
    echo "export COMMANDS=\"${commands}\""
}

main()
{
    local mode=${1}
    local env_only=${2}

    gen-cachegurd-env ${mode} > CacheGuard.env
    test -z "${env_only}" || return 0

    local modules module

    case ${mode} in
	''|dev)
	    modules="Sources OS Install"
	    ;;
	pprod|prod)
	    modules="RunTimeLFS Sources OS Install"
	    ;;
	*)
	    return 1
	    ;;
    esac

    local cur_dir=$(pwd)

    for module in ${modules}
    do
	cd ${cur_dir}/${module}
	test -f install.bash || continue
	echo "ooo Installing the module \"${module}\"..."
	./install.bash ${mode}
    done

    cd ${cur_dir}
}

# Main()

main "${@}"
