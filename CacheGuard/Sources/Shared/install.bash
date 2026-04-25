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

source CacheGuard.env

gen-jobs-tab()
{
    local op com page title
    local i=0

    cat jobs-tab-header > ${GENERATED_DIR}/jobs-tab
    cat jobs-tab-js-header > ${GENERATED_DIR}/jobs-tab.js

    echo "JobsLock[${i}]=''
JobsCommand[${i}]=''
JobsPage[${i}]=''
" >> ${GENERATED_DIR}/jobs-tab
    echo "var JOBS = ["  >> ${GENERATED_DIR}/jobs-tab.js
    echo "['','']," >> ${GENERATED_DIR}/jobs-tab.js
    ((i++))

    while read op com page title
    do
	com=${com//_/ }
	echo "JobsLock[${i}]='${op}'
JobsCommand[${i}]='${com}'
JobsPage[${i}]='${page}'
JobsTitle[${i}]='${title}'
" >> ${GENERATED_DIR}/jobs-tab
	echo "['${page}','${title}']," >> ${GENERATED_DIR}/jobs-tab.js
	((i++))
    done < jobs

    echo "JobsLockNb=${i}" >> ${GENERATED_DIR}/jobs-tab
    echo "];" >> ${GENERATED_DIR}/jobs-tab.js
    echo "var JOBS_NB=${i}" >> ${GENERATED_DIR}/jobs-tab.js
}

gen-js-functions()
{
    cat ${GENERATED_DIR}/jobs-tab > ${GENERATED_DIR}/apl-js-var.apl
    cat ${GENERATED_DIR}/jobs-tab.js > ${GENERATED_DIR}/apl-js-var.js

    echo >> ${GENERATED_DIR}/apl-js-var.apl
    echo >> ${GENERATED_DIR}/apl-js-var.js

    while read var val
    do
	echo "export ${var}=\"${val}\"" >> ${GENERATED_DIR}/apl-js-var.apl
	echo "var ${var} = \"${val}\";" >> ${GENERATED_DIR}/apl-js-var.js
    done < VARIABLES
}

install-shared()
{
    sudo install -m 444 -o ${ADMIN_UID} -g ${USERS_GID} ${GENERATED_DIR}/jobs-tab ${APL}${ADMIN_DIR}${APPLIANCE_DIR}/lib/jobs-tab
}

# Main()

mkdir -p ${FULL_GENERATED_DIR}
ln -sf ${FULL_GENERATED_DIR}

gen-jobs-tab
gen-js-functions
install-shared
