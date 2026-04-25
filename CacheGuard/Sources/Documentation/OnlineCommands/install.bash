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

source CacheGuard.env

gen-index-html-top()
{
    echo '<!DOCTYPE html>'
    echo '<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">'
    echo
    echo '<head>'
    echo "<title>${COMMERCIAL_NAME} OS Command Line Manual</title>"
    echo "<link rel='stylesheet' type='text/css' href='/${DOC_DIR_NAME}/apl.css' />"
    echo '</head>'
    echo
    echo '<body bgcolor="#ffffff">'
    echo "<a href=index.html><img src='/${DOC_DIR_NAME}/${IMAGE_DIR_NAME}/CacheGuardLogo.png' alt='' border='0' align='left' height='65' /></a>"
    echo '<center>'
    echo "<font size=6 COLOR='firebrick'>"
    echo "${COMMERCIAL_NAME} OS"
    echo '</font>'
    echo '<br />'
    echo "<font size=3 color='firebrick'>"
    echo "Command Line Manual - Version ${OS_GENERATION}-${OS_VERSION}"
    echo '</font>'
    echo '</center>'
    echo '<p />'
    echo '<br />'
    echo '<table cellspacing="0" cellpadding="0" cols="2" width="70%" style="margin:20px;">'
}

gen-core-index-html()
{
    local command=${1}
    local summary=${2}

      echo "<tr>"
      echo "<td width=25%>"
      echo "<strong>"
      echo "<a href=\"${command}.html\">${command}</a>"
      echo "</strong>"
      echo "</td>"
      echo "<td width=75%>${summary}</td>"
      echo "</tr>"
}

gen-index-html-bottom()
{
    echo '</table>'
    cat ../${GENERATED_DIR}/copyright
    echo '</body>'
    echo '</html>'
}

gen-core-index-man()
{
    local command=${1}
    local summary=${2}
    
    echo "\fB${command}\fR - ${summary}"
    echo
}

gen-index()
{
    local command_name summary

    gen-index-html-top > ${GENERATED_DIR}/index.html
    rm -f ${GENERATED_DIR}/help.1.commands.new

    for command_name in ${COMMANDS}
    do
	summary=$(head -1 ${command_name}.1)
	gen-core-index-html ${command_name} "${summary}" >> ${GENERATED_DIR}/index.html
	gen-core-index-man ${command_name} "${summary}" >> ${GENERATED_DIR}/help.1.commands.new
    done
    
    gen-index-html-bottom >> ${GENERATED_DIR}/index.html

    if test -f ${GENERATED_DIR}/help.1.commands.old ; then
	diff -q ${GENERATED_DIR}/help.1.commands.old ${GENERATED_DIR}/help.1.commands.new > /dev/null 2>&1
	test ${?} -eq 0 || cp -f ${GENERATED_DIR}/help.1.commands.new ${GENERATED_DIR}/help.1.commands
    else
	cp -f ${GENERATED_DIR}/help.1.commands.new ${GENERATED_DIR}/help.1.commands.old
	cp -f ${GENERATED_DIR}/help.1.commands.new ${GENERATED_DIR}/help.1.commands
    fi
}

gen-files()
{
    gen-index
}

# Main()

mkdir -p ${FULL_GENERATED_DIR}
ln -sf ${FULL_GENERATED_DIR}

gen-files
make --quiet
