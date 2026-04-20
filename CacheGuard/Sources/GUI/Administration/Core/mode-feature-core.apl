#!/bin/bash

###########################################################################
#
# MODULE:       GUI
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

show-feature-form()
{
    local width=400 i=0

    itemWidth[0]=90
    itemWidth[1]=10

    itemTitle[${i}]="" ; ((i++))
    itemTitle[${i}]="Anonymous browsing" ; ((i++))
    itemTitle[${i}]="Antivirus" ; ((i++))
    itemTitle[${i}]="Firewall" ; ((i++))
    itemTitle[${i}]="Forward Web Proxy" ; ((i++))
    itemTitle[${i}]="HTTP Compression" ; ((i++))
    itemTitle[${i}]="OCSP Server" ; ((i++))
    itemTitle[${i}]="Reverse Web Proxy" ; ((i++))
    itemTitle[${i}]="SSL Mediation" ; ((i++))
    itemTitle[${i}]="Traffic Logging" ; ((i++))
    itemTitle[${i}]="URL Guarding" ; ((i++))
    itemTitle[${i}]="IPsec VPN" ; ((i++))
    itemTitle[${i}]="Web Access Authentication" ; ((i++))
    itemTitle[${i}]="Web Application Firewall" ; ((i++))
    itemTitle[${i}]="Web Caching" ; ((i++))

    i=0

    itemID[${i}]="dummy" ; ((i++))
    itemID[${i}]="mode_anonymous" ; ((i++))
    itemID[${i}]="mode_av" ; ((i++))
    itemID[${i}]="mode_firewall" ; ((i++))
    itemID[${i}]="mode_web" ; ((i++))
    itemID[${i}]="mode_compress" ; ((i++))
    itemID[${i}]="mode_ocsp" ; ((i++))    
    itemID[${i}]="mode_rweb" ; ((i++))
    itemID[${i}]="mode_sslmediate" ; ((i++))
    itemID[${i}]="mode_log" ; ((i++))
    itemID[${i}]="mode_guard" ; ((i++))
    itemID[${i}]="mode_vpnipsec" ; ((i++))
    itemID[${i}]="mode_authenticate" ; ((i++))
    itemID[${i}]="mode_waf" ; ((i++))    
    itemID[${i}]="mode_cache" ; ((i++))

    i=0

    blankItemContent[${i}]="value='on'" ; ((i++))
    blankItemContent[${i}]="type='checkbox'$(checked ${ANONYMOUS_MODE})" ; ((i++))
    blankItemContent[${i}]="type='checkbox'$(checked ${AV_MODE})" ; ((i++))    
    blankItemContent[${i}]="type='checkbox'$(checked ${FIREWALL_MODE})" ; ((i++))
    blankItemContent[${i}]="type='checkbox'$(checked ${WEB_MODE})" ; ((i++))
    blankItemContent[${i}]="type='checkbox'$(checked ${COMPRESS_MODE})" ; ((i++))
    blankItemContent[${i}]="type='checkbox'$(checked ${OCSP_MODE})" ; ((i++))
    blankItemContent[${i}]="type='checkbox'$(checked ${RWEB_MODE})" ; ((i++))
    blankItemContent[${i}]="type='checkbox'$(checked ${SSLMEDIATE_MODE})" ; ((i++))
    blankItemContent[${i}]="type='checkbox'$(checked ${LOG_MODE})" ; ((i++))
    blankItemContent[${i}]="type='checkbox'$(checked ${GUARD_MODE})" ; ((i++))
    blankItemContent[${i}]="type='checkbox'$(checked ${VPN_IPSEC_MODE})" ; ((i++))
    blankItemContent[${i}]="type='checkbox'$(checked ${AUTHENTICATE_MODE})" ; ((i++))
    blankItemContent[${i}]="type='checkbox'$(checked ${WAF_MODE})" ; ((i++))
    blankItemContent[${i}]="type='checkbox'$(checked ${CACHE_MODE})" ; ((i++))

    shortcutMenuItem[0]="mode-network"
    shortcutMenuTitle[0]="Network Modes & Services"

    itemForm[0]="hidden"

    show-title "Function Modes & Features" "enabled" "mode"
    show-shortcuts-menu
    show-form "${width}"
}

# Main()

show-feature-form
