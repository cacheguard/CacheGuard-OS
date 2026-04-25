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
source WorkFunctions

set-environment()
{
    unset https_proxy
    unset HTTPS_PROXY

    CLI_DIR=CLI
    GUIDE_DIR=GUIDE

    mkdir -p ${GENERATED_DIR}/${CLI_DIR}
    mkdir -p ${GENERATED_DIR}/${GUIDE_DIR}
}

gen-cli()
{
    local groff_file
    local com

    wkhtmltopdf --quiet https://${NETWORK_WEBSITE}/${DOC_DIR_NAME}/${DOC_COMMAND_DIR_NAME}/index.html ${GENERATED_DIR}/${CLI_DIR}/aaa-index.pdf 2> /dev/null
    gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=${GENERATED_DIR}/${CLI_DIR}/aaa-index-gs.pdf ${GENERATED_DIR}/${CLI_DIR}/aaa-index.pdf
    for groff_file in ../OnlineCommands/*.1
    do
	com=$(file-basename ${groff_file} .1)
	wkhtmltopdf --quiet https://${NETWORK_WEBSITE}/${DOC_DIR_NAME}/${DOC_COMMAND_DIR_NAME}/${com}.html ${GENERATED_DIR}/${CLI_DIR}/${com}.pdf 2> /dev/null
	gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=${GENERATED_DIR}/${CLI_DIR}/${com}-gs.pdf ${GENERATED_DIR}/${CLI_DIR}/${com}.pdf
    done

    gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=${GENERATED_DIR}/${COMMERCIAL_NAME}-CLI-Manual.pdf ${GENERATED_DIR}/${CLI_DIR}/*-gs.pdf
    ln -sf ${CLI_DIR}/license.pdf ${GENERATED_DIR}/${COMMERCIAL_NAME}-OS-License-Agreement.pdf
}

gen-guide()
{
    local guides="index overview changelogs installation admin_interface monitoring logging os admin_user features configuration clock_ntp network_configuration transparent ssl_mediation authentication guarding antivirus security optimisation reverse_mode waf manager"

    local guide pdf_guides

    for guide in ${guides}
    do
	pdf_guides="${pdf_guides} ${GENERATED_DIR}/${GUIDE_DIR}/${guide}-gs.pdf"
    done
    pdf_guides=${pdf_guides:1}

    for guide in ${guides}
    do
	wkhtmltopdf --quiet https://${NETWORK_WEBSITE}/${DOC_DIR_NAME}/${DOC_GUIDE_DIR_NAME}/${guide}.html ${GENERATED_DIR}/${GUIDE_DIR}/${guide}.pdf 2> /dev/null
    done

    for guide in ${guides}
    do
	gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=${GENERATED_DIR}/${GUIDE_DIR}/${guide}-gs.pdf ${GENERATED_DIR}/${GUIDE_DIR}/${guide}.pdf
    done
    
    gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=${GENERATED_DIR}/${COMMERCIAL_NAME}-Users-Guide.pdf ${pdf_guides}
}

# Main()

mkdir -p ${FULL_GENERATED_DIR}
ln -sf ${FULL_GENERATED_DIR}

set-environment
gen-cli
gen-guide
