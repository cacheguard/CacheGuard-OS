#!/bin/bash

###########################################################################
#
# MODULE:       Build
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
<html lang="en">
<head>
<title>${COMMERCIAL_NAME} User's Guide - ${page^}</title>
<meta charset="UTF-8" />
<link rel="shortcut icon" type="image/x-image" href="/favicon.ico" />
<script type="text/javascript" src="/${DOC_DIR_NAME}/js/treeview-${GUI_FE_VERSION}.js"></script>
<link rel="stylesheet" type="text/css" href="/${DOC_DIR_NAME}/treeview-${GUI_FE_VERSION}.css" />
<link rel="stylesheet" type="text/css" href="/${DOC_DIR_NAME}/apl-${GUI_FE_VERSION}.css" />
</head>
<body>
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
