#!/bin/bash

############################################################################
#
# MODULE:       Patch
# AUTHOR(S):    Afshin Tajvidi, <afshin.tajvidi(at)cacheguard.com>
# COPYRIGHT:    (C) 2002-2015 by the CacheGuard Technologies Limited
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

CACHEGUARD_DIR=/etc/sysconfig/cacheguard

source ${CACHEGUARD_DIR}/constant

commit-model-file()
{
    mv -f /tmp/${MODEL_NAME}.patched ${ETC_DIR}/${MODEL_NAME}
}

clean-tmp-model-file()
{
    local user

    rm -f /tmp/${MODEL_NAME}.patched
}

gen-model-file()
{
    local arch=$(uname -m 2> /dev/null)
    local pattern_arch="/CPU_NB/a CPU_ARCHITECTURE=${arch}"
    local model_file=${ETC_DIR}/${MODEL_NAME}

    sed -e "${pattern_arch}" ${model_file} > /tmp/${MODEL_NAME}.patched || return 11
}

sysctl-start()
{
    /etc/rc.d/init.d/sysctl start > /dev/null 2>&1
}

main()
{
    sysctl-start
    gen-model-file &&
    commit-model-file ||
    clean-tmp-model-file
}

# Main()

export MODEL_NAME=model.conf
main
