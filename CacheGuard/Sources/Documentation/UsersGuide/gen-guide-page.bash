#!/bin/bash

test -n "${APL}" || exit 1

source CacheGuard.env
source WorkFunctions

# Main()

gen-html-guide()
{
    test -n "${1}" || return 1
    local page=${1}

    page=$(file-basename ${page} .html)
    page=${page//_/ }

    cat << EOF
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
<title>${COMMERCIAL_NAME} User's Guide - ${page^}</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="shortcut icon" type="image/x-image" href="/${DOC_DIR_NAME}/favicon.ico" />
<link rel="stylesheet" type="text/css" href="/${DOC_DIR_NAME}/apl.css" />
EOF
    if test "${page}" == index ; then
	cat << EOF
<link rel="stylesheet" type="text/css" href="/${DOC_DIR_NAME}/jquery_treeview.css" />
<script type="text/javascript" src="/${DOC_DIR_NAME}/js/jquery_min.js"></script>
<script type="text/javascript" src="/${DOC_DIR_NAME}/js/jquery_treeview.js"></script>
<script type="text/javascript" src="/${DOC_DIR_NAME}/js/jquery_persist.js"></script>
EOF
    fi

    cat << EOF
</head>
<body>

EOF

    test "${page}" != index || cat header-index-js

    cat << EOF
<div class='guide'>
<center>
<a href='/${DOC_DIR_NAME}/${DOC_GUIDE_DIR_NAME}/index.html'><img src='/${DOC_DIR_NAME}/${IMAGE_DIR_NAME}/CacheGuardLogo.png' align='left' alt='' title='' border='0' height='65' /></a>
<font size='6' color='firebrick'>${COMMERCIAL_NAME}-OS</font><br />
<a href='/${DOC_DIR_NAME}/${DOC_GUIDE_DIR_NAME}/index.html'><font size=3 color='firebrick'>User's Guide - Version ${OS_GENERATION}-${OS_VERSION}</font></a>
<p><br />
</center>
EOF
}

gen-html-guide "${@}"
