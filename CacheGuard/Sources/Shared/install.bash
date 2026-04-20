#!/bin/bash

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
