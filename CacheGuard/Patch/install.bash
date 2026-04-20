#!/bin/bash

source CacheGuard.env
source WorkFunctions

set-environment()
{
    test -n "${APL}" || exit 1
    test -d "${APL}" || exit 3
    test -n "${PATCH_DIR_NAME}" || return 5

    PATCH_RDIR=Patch-${OS_VERSION}
    source ${PATCH_RDIR}/PATCH.env

    test ${PATCH_OS_NEW_VERSION} != 2.2.1 || PATCH_COMPRESS=gz

    unset ARCHITECTURE_ID
    test ${SYS_ARCHITECTURE} != x86_64 || ARCHITECTURE_ID="-64"

    local os_generation=${OS_GENERATION,,}
    local base_signature_file=../OS/${FINGERPRINT_DIR_NAME}/${TECHNICAL_NAME}-${os_generation}${ARCHITECTURE_ID}

    NEW_SHA1FILE=${base_signature_file}-${PATCH_OS_NEW_VERSION}.sha1
    OLD_SHA1FILE=${base_signature_file}-${PATCH_OS_VERSION_NEEDED}.sha1

    NEW_LINKFILE=${base_signature_file}-${PATCH_OS_NEW_VERSION}.link
    OLD_LINKFILE=${base_signature_file}-${PATCH_OS_VERSION_NEEDED}.link

    NEW_DIRFILE=${base_signature_file}-${PATCH_OS_NEW_VERSION}.dir
    OLD_DIRFILE=${base_signature_file}-${PATCH_OS_VERSION_NEEDED}.dir

    NEW_EXECFILE=${base_signature_file}-${PATCH_OS_NEW_VERSION}.exec

    test -f ${NEW_LINKFILE} || return 11
    test -f ${OLD_LINKFILE} || return 13

    test -f ${NEW_SHA1FILE} || return 15
    test -f ${OLD_SHA1FILE} || return 17

    test -f ${NEW_EXECFILE} || return 19

    WORKING_CPU_NB=$(get-max-working-cpu)
}

gen-date-file()
{
    test -n "${1}" || return 1
    test -n "${2}" || return 2
    local date=${1}
    local date_file=${2}

    local date=${date//\/}
    date=${date}0000.00
    touch -t ${date} ${date_file}
}

clean-old()
{
    local old_dir=${PWD}
    cd ${GENERATED_DIR}

    sudo rm -rf ${PATCHED_CONTENT} apply-patch PATCH.env || return 1
    rm -f ${NON_ROOT_DIRECTORIES} patch.tar.{xz,gz} removed-files userenv.diff patched-files || return 3

    cd ${old_dir}
}

tuner-program-modified()
{
    local file
    local old_sha1 old_file_sha1
    local new_sha1 new_file_sha1

    for file in \
	${LOCAL_DIR:1}/bin/apl_model_configure \
	${LOCAL_DIR:1}/bin/apl_model_install \
	${LOCAL_DIR:1}/bin/apl_model_retune \
	${CACHEGUARD_DIR:1}/TUNER.env ;
    do
	old_file_sha1=$(grep "${file}" ${OLD_SHA1FILE} 2> /dev/null)
	new_file_sha1=$(grep "${file}" ${NEW_SHA1FILE} 2> /dev/null)

	old_sha1=${old_file_sha1/${file} }
	new_sha1=${new_file_sha1/${file} }

	test "${old_sha1}" == "${new_sha1}" || return 0
    done

    return 1
}

gen-patch-env()
{
    local architecture_id
    local retune

    case ${SYS_ARCHITECTURE} in
	i386|i686|x86)
	    architecture_id=x86
	    ;;
	x86_64)
	    architecture_id=x64
	    ;;
	*)
	    ;;
    esac

    if tuner-program-modified ; then
	retune=yes
    else
	retune=no
    fi

    echo "PATCH_ARCHITECTURE='${architecture_id}'"
    cat ${PATCH_RDIR}/PATCH.env
    echo "PATCH_RETUNE='${retune}'"
}

make-diff-sha1()
{
    local modified_files
    local added_files
    local removed_files

    local old_file old_sha1 old_file_sha1
    local new_file new_sha1 new_file_sha1
    local pattern

    while read new_file new_sha1
    do
	test -n "${new_file}" || continue

	pattern="${new_file//+/\\+}"
	pattern="${pattern//\?/\\?}"
	pattern="${pattern//\(/\\(}"
	pattern="${pattern//\)/\\)}"

	old_file_sha1=$(egrep "^${pattern} " ${OLD_SHA1FILE} 2> /dev/null)
	if test -z "${old_file_sha1}" ; then
	    added_files="${added_files} ${new_file}"
	else
	    old_sha1=${old_file_sha1/* }
	    test ${old_sha1} == ${new_sha1} || modified_files="${modified_files} ${new_file}"
	fi
    done < ${NEW_SHA1FILE}

    while read old_file old_sha1
    do
	test -n "${old_file}" || continue

	test ${old_file:0:12} != "boot/config-" || continue
	test ${old_file:0:12} != "boot/kernel-" || continue
	test ${old_file:0:12} != "boot/initrd-" || continue
	test ${old_file:0:16} != "boot/System.map-" || continue
	test ${old_file:0:16} != "usr/lib/modules/" || continue

	pattern=${old_file//+/\\+}
	pattern=${pattern//\?/\\?}
	pattern=${pattern//\(/\\(}
	pattern=${pattern//\)/\\)}

	new_file_sha1=$(egrep "^${pattern} " ${NEW_SHA1FILE} 2> /dev/null)

	test -z "${new_file_sha1}" || continue

	removed_files="${removed_files} ${old_file}"

    done < ${OLD_SHA1FILE}

    added_files=${added_files:1}
    modified_files=${modified_files:1}
    removed_files=${removed_files:1}

    ADDED_FILES=${added_files}
    MODIFIED_FILES=${modified_files}
    REMOVED_FILES=${removed_files}
}

make-diff-link()
{
    local added_links
    local modified_links
    local removed_links

    local new_link new_target new_link_target
    local old_link old_target old_link_target
    local pattern link

    while read new_link new_target
    do
	test -n "${new_link}" || continue

	pattern=${new_link//+/\\+}
	pattern=${pattern//\?/\\?}

	old_link_target=$(egrep "^${pattern} " ${OLD_LINKFILE} 2> /dev/null)
	if test -z "${old_link_target}" ; then
	    added_links="${added_links} ${new_link}"
	else
	    old_target=${old_link_target/* }
	    test ${old_target} == ${new_target} || modified_links="${modified_links} ${new_link}"
	fi
    done < ${NEW_LINKFILE}

    while read old_link old_target
    do
	test -n "${old_link}" || continue

	pattern=${old_link//+/\\+}
	pattern=${pattern//\?/\\?}

	new_link_target=$(egrep "^${pattern} " ${NEW_LINKFILE} 2> /dev/null)
	if test -z "${new_link_target}" ; then
	    removed_links="${removed_links} ${old_link}"
	    if test ${old_link:0:11} == etc/rc.d/rc ; then
		case ${old_link:15:1} in
		    S|K)
			link="${old_link:0:15}_${old_link:15}"
			;;
		    _)
			link="${old_link:0:15}${old_link:16}"
			;;
		    *)
			;;
		esac

		test ${link:0:16} != "usr/lib/modules/" || continue

		removed_links="${removed_links} ${link}"
	    fi
	fi
    done < ${OLD_LINKFILE}

    added_links=${added_links:1}
    modified_links=${modified_links:1}
    removed_links=${removed_links:1}

    ADDED_LINKS=${added_links}
    MODIFIED_LINKS=${modified_links}
    REMOVED_LINKS=${removed_links}
}

make-diff-dir()
{
    local modified_dirs
    local added_dirs
    local removed_dirs

    local new_dir new_stat new_dir_stat
    local old_dir old_stat old_dir_stat
    local pattern

    while read new_dir new_stat
    do
	test -n "${new_dir}" || continue

	pattern=${new_dir//+/\\+}
	pattern=${pattern//\?/\\?}

	old_dir_stat=$(egrep "^${pattern} " ${OLD_DIRFILE} 2> /dev/null)
	if test -z "${old_dir_stat}" ; then
	    added_dirs="${added_dirs} ${new_dir}"
	else
	    old_stat=${old_dir_stat#* }
	    test "${old_stat}" == "${new_stat}" || modified_dirs="${modified_dirs} ${new_dir}"
	fi
    done < ${NEW_DIRFILE}

    while read old_dir old_stat
    do
	test -n "${old_dir}" || continue

	pattern=${old_dir//+/\\+}
	pattern=${pattern//\?/\\?}

	new_dir_stat=$(egrep "^${pattern} " ${NEW_DIRFILE} 2> /dev/null)

	test -z "${new_dir_stat}" || continue
	test ${old_dir:0:16} != "usr/lib/modules/" || continue

	removed_dirs="${removed_dirs} ${old_dir}"

    done < ${OLD_DIRFILE}

    added_dirs=${added_dirs:1}
    modified_dirs=${modified_dirs:1}
    removed_dirs=${removed_dirs:1}

    ADDED_DIRS=${added_dirs}
    MODIFIED_DIRS=${modified_dirs}
    REMOVED_DIRS=${removed_dirs}
}

make-diff()
{
    make-diff-sha1 || return 1
    make-diff-link || return 3
    make-diff-dir || return 5
}

length-list()
{
    if test -z "${1}" ; then
	echo 0
	return 0
    fi
    local list=${1}

    local len1=${#list}
    list=${list// }
    local len2=${#list}
    local len=$[${len1} - ${len2}]
    ((len++))

    echo ${len}
}

get-list-position()
{
    if test -z "${1}" ; then
	echo 0
	return 1
    fi
    local in_elt=${1}
    local in_list=${2}

    local elt position=1

    for elt in ${in_list}
    do
	if test ${elt} == ${in_elt} ; then
	    echo ${position}
	    return 0
	fi
	((position++))
    done

    echo 0
    return 11
}

gen-userenv-1()
{
    local diff_file="${PATCH_RDIR}/apply-patch/userenv.diff"
    test -s ${diff_file} || return 0

    local line_diff assertion_diff variable_diff
    local operation position

    local userenv_file=../Sources/Configurator/${GENERATED_DIR}/userenv
    local userenv_line=$(tail -1 ${userenv_file} 2> /dev/null)
    local userenv_assertion=${userenv_line/export /}
    local userenv_variables=${userenv_assertion/USERENV_VARS=\'}
    local len=${#userenv_variables} ; ((len--))

    userenv_variables=${userenv_variables:0:${len}}

    while read -r line_diff
    do
	test -n "${line_diff}" || continue
	test "${line_diff:0:1}" != '#' || continue
	
	operation=${line_diff:0:1}
	case ${operation} in
	    -)
		echo "${line_diff}"
		continue
		;;
	    +)
		assertion_diff=${line_diff:1}
		variable_diff=${assertion_diff/=*/}
		position=$(get-list-position ${variable_diff} "${userenv_variables}")
		echo "${operation}${position}:${assertion_diff}"
		;;
	    *)
		continue
		;;
	esac

    done < ${diff_file}

    position=$(length-list "${userenv_variables}")
    ((position++))

    echo "+${position}:USERENV_VARS='${userenv_variables}'"
}

gen-userenv()
{
    gen-userenv-1 > ${GENERATED_DIR}/userenv.diff
}

gen-removed-files()
{
    local file dir base
    local found

    for file in ${REMOVED_FILES}
    do
	! member "${ADDED_LINKS}" ${file} || continue
	! member "${ADDED_DIRS}" ${file} || continue
	echo /${file}
    done

    for file in ${REMOVED_LINKS}
    do
	! member "${ADDED_FILES}" ${file} || continue
	! member "${ADDED_DIRS}" ${file} || continue
	echo /${file}
    done

    for dir in ${REMOVED_DIRS}
    do
	for file in ${ADDED_FILES} ${ADDED_LINKS} ${ADDED_DIRS}
	do
	    base=${file%\/*}
	    if test ${base} == ${dir} ; then
		found='yes'
		break
	    fi
	done
	test -n "${found}" || echo /${dir}
	unset found
    done
}

get-non-root-directories()
{
    test -n "${1}" || return 1
    local input_file=${1}

    test -f ${input_file} || return 11

    local file dir ownner

    while read file
    do
	dir=$(file-dirname ${file})
	while test ${dir} != '.'
	do
	    owner=$(stat --format="%u %g" ${dir})
	    test "${owner}" == "0 0" || echo ${dir}
	    dir=$(file-dirname ${dir})
	done
    done < ${tmp_files2tar} | sort | uniq
}

build-patch()
{
    test \
	-n "${MODIFIED_FILES}" -o \
	-n "${ADDED_FILES}" -o \
	-n "${MODIFIED_LINKS}" -o \
	-n "${ADDED_LINKS}" -o \
	-n "${MODIFIED_DIRS}" -o \
	-n "${ADDED_DIRS}" \
	|| return 1

    local tmp_date_file=/tmp/date-file.${$}
    local tmp_files2tar=/tmp/files2tar.${$}
    local tmp_dirs2tar=/tmp/dirs2tar.${$}
    local tmp_files=files.${$}
    local os_generation=${OS_GENERATION,,}

    local file

    gen-patch-env > ${GENERATED_DIR}/PATCH.env
    gen-date-file ${PATCH_OS_OLD_VERSION_DATE} ${tmp_date_file}

    local sha1_file=${TECHNICAL_NAME}-${os_generation}${ARCHITECTURE_ID}-${PATCH_OS_NEW_VERSION}.sha1
    local exec_file=${TECHNICAL_NAME}-${os_generation}${ARCHITECTURE_ID}-${PATCH_OS_NEW_VERSION}.exec

    sudo install -m 444 -o root -g root ${NEW_SHA1FILE} ${APL}${LOCAL_DIR}/etc/${sha1_file}
    sudo install -m 444 -o root -g root ${NEW_EXECFILE} ${APL}${LOCAL_DIR}/etc/${exec_file}

    local cur_dir=${PWD}
    cd ${GENERATED_DIR}

    sudo rm -rf ${PATCH_DIR_NAME}
    sudo mkdir ${PATCH_DIR_NAME}

    cd ${APL}

    for file in ${MODIFIED_FILES} \
		${ADDED_FILES} \
		${MODIFIED_LINKS} \
		${ADDED_LINKS} \
		${MODIFIED_DIRS} \
		${ADDED_DIRS} \
		${LOCAL_DIR:1}/etc/${sha1_file} \
		${LOCAL_DIR:1}/etc/${exec_file}
    do
	echo ${file}
    done > ${tmp_files2tar}

    get-non-root-directories ${tmp_files2tar} > ${tmp_dirs2tar}

    sudo tar \
	 --numeric-owner \
	 --create --file ${cur_dir}/${GENERATED_DIR}/${tmp_files}.tar \
	 --files-from=${tmp_files2tar}

    sudo tar \
	 --numeric-owner \
	 --no-recursion \
	 --append --file ${cur_dir}/${GENERATED_DIR}/${tmp_files}.tar \
	 --files-from=${tmp_dirs2tar}

    cd ${cur_dir}/${GENERATED_DIR}/${PATCH_DIR_NAME}
    sudo tar \
	 --numeric-owner \
	 --same-owner \
	 --preserve-permissions \
	 --extract --file ${cur_dir}/${GENERATED_DIR}/${tmp_files}.tar

    cd ${cur_dir}

    if test \
	-n "${REMOVED_FILES}" -o \
	-n "${REMOVED_LINKS}" -o \
	-n "${REMOVED_DIRS}" ; then
	gen-removed-files > ${GENERATED_DIR}/removed-files
    else
	rm -f ${GENERATED_DIR}/removed-files
    fi

    mv -f ${tmp_files2tar} ${GENERATED_DIR}/patched-files
    mv -f ${tmp_dirs2tar} ${GENERATED_DIR}/${NON_ROOT_DIRECTORIES}
    rm -f ${GENERATED_DIR}/${tmp_files}.tar 
    rm -f ${tmp_date_file}
}

pack-patch()
{
    test -d ${GENERATED_DIR}/${PATCH_DIR_NAME} || return 1
    test -f ${GENERATED_DIR}/PATCH.env || return 3

    local tmp_dirs2tar=/tmp/non_root_dirs2tar.${$}
    local cur_dir=${PWD}
    local dir

    cd ${PATCH_RDIR}

    tar \
	--numeric-owner \
	--owner=root --group=root \
	--create --file ../${GENERATED_DIR}/patch.tar \
	apply-patch \
	reboot-patch

    cd ${cur_dir}/${GENERATED_DIR}

    sudo install -d -m 755 -o root -g root apply-patch

    sudo install -m 644 -o root -g root PATCH.env apply-patch/PATCH.env
    sudo tar \
	 --owner=root --group=root \
	 --numeric-owner \
	 --append --file patch.tar \
	 apply-patch/PATCH.env

    if test -s userenv.diff ; then
	sudo install -m 644 -o root -g root userenv.diff apply-patch/userenv.diff
	sudo tar \
	     --owner=root --group=root \
	     --numeric-owner \
	     --append -f patch.tar \
	     apply-patch/userenv.diff
    fi

    if test -f removed-files ; then
	sudo install -m 644 -o root -g root removed-files apply-patch/removed-files
	sudo tar \
	     --owner=root --group=root \
	     --numeric-owner \
	     --append -f patch.tar apply-patch/removed-files
    fi

    sudo tar \
	 --numeric-owner \
	 --append --file patch.tar \
	 ${PATCH_DIR_NAME}

    if test 1 -ne 1 ; then
    while read dir
    do
	echo ${PATCH_DIR_NAME}/${dir}
    done < ${NON_ROOT_DIRECTORIES} > ${tmp_dirs2tar}

    sudo tar \
	 --numeric-owner \
	 --no-recursion \
	 --append --file patch.tar \
	 --files-from=${tmp_dirs2tar}
    rm -f ${tmp_dirs2tar}
    fi

    rm -f patch.tar.{gz,xz}
    case ${PATCH_COMPRESS} in
	xz)
	    sudo xz --memlimit=20% --threads=${WORKING_CPU_NB} patch.tar
	    ;;
	gz)
	    sudo gzip patch.tar
	    ;;
	*)
	    sudo gzip patch.tar
	    ;;
    esac

    sudo rm -rf ${PATCHED_CONTENT} apply-patch
    sudo mv -f ${PATCH_DIR_NAME} ${PATCHED_CONTENT}

    cd ${cur_dir}
}

sign-patch()
{
    test ! -d ${GENERATED_DIR}/${PATCH_DIR_NAME} || return 1
    test -f ${GENERATED_DIR}/patch.tar.${PATCH_COMPRESS} || return 3

    mkdir ${GENERATED_DIR}/${PATCH_DIR_NAME}
    mv -f ${GENERATED_DIR}/patch.tar.${PATCH_COMPRESS} ${GENERATED_DIR}/${PATCH_DIR_NAME}

    openssl dgst -sha1 -sign patch-private-key.pem -out ${GENERATED_DIR}/${PATCH_DIR_NAME}/signature ${GENERATED_DIR}/${PATCH_DIR_NAME}/patch.tar.${PATCH_COMPRESS}

    local cur_dir=${PWD}
    cd ${GENERATED_DIR}

    sudo tar \
	--owner=root --group=root \
	--create --file patch.tar \
	${PATCH_DIR_NAME}

    rm -f patch.tar.{gz,xz}
    case ${PATCH_COMPRESS} in
	xz)
	    sudo xz --memlimit=20% --threads=${WORKING_CPU_NB} patch.tar
	    ;;
	gz)
	    sudo gzip patch.tar
	    ;;
	*)
	    sudo gzip patch.tar
	    ;;
    esac

    rm -f ${PATCH_DIR_NAME}/signature ${PATCH_DIR_NAME}/patch.tar.{gz,xz}
    rmdir ${PATCH_DIR_NAME}

    cd ${cur_dir}
}

install-patch()
{
    test -f ${GENERATED_DIR}/patch.tar.${PATCH_COMPRESS} || return 1
    sudo install -m 644 -o root -g root ${GENERATED_DIR}/patch.tar.${PATCH_COMPRESS} ${TFTPBOOT_DIR}/patch.cgp
}

main()
{
    set-environment || return 11
    clean-old || return 13
    gen-userenv || return 15
    make-diff || return 17
    build-patch || return 19
    pack-patch || return 21
    sign-patch || return 23
    install-patch || return 25
}

# Main()

NON_ROOT_DIRECTORIES=non-root-directories
PATCHED_CONTENT=patch-content

mkdir -p ${FULL_GENERATED_DIR}
ln -sf ${FULL_GENERATED_DIR}
PATCH_COMPRESS=xz

main
