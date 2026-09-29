/*
###########################################################################
#
# MODULE:       GUI
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
*/

initLeftMenu( 'left-menu', 'left-menu-arrow' );
initTopMenu( 'top-menu', 'top-menu-arrow' );

if (typeof animatedcollapse !== "undefined") {
   animatedcollapse.init( );
}

if (typeof ddsmoothmenu !== "undefined") {
    ddsmoothmenu.init({
	mainmenuid: "top-menu",
	orientation: 'h',
	classname: 'ddsmoothmenu',
	method: 'hover',
	contentsource: "markup"
    });
}

if (document.body.dataset.autoLogout !== undefined) {
    $( document ).ready( function () {
	initAutoLogout( );
    } );
}

const aplContextRole = document.body.dataset.aplContextRole;
const webAppName = GUI_MODULE_NAME.toLowerCase( );

if (aplContextRole) {
    if (typeof ddaccordion !== "undefined") {
	ddaccordion.init( {
	    headerclass: "left-menu-" + webAppName + "-" + aplContextRole,
	    contentclass: "left-menu-" + webAppName + "-items",
	    revealtype: "click",
	    mouseoverdelay: 200,
	    collapseprev: true,
	    defaultexpanded: [0],
	    onemustopen: false,
	    animatedefault: false,
	    persiststate: true,
	    toggleclass: ["", "openheader"],
	    togglehtml: ["prefix", "", ""],
	    animatespeed: "fast",
	    oninit:function(headers, expandedindices){
	    },
	    onopenclose:function(header, index, state, isuseractivated){
	    }
	} );

	ddaccordion.init( {
	    headerclass: "left-submenu-" + webAppName + "-" + aplContextRole,
	    contentclass: "left-submenu-" + webAppName + "-items",
	    revealtype: "click",
	    mouseoverdelay: 200,
	    collapseprev: true,
	    defaultexpanded: [],
	    onemustopen: false,
	    animatedefault: false,
	    persiststate: true,
	    toggleclass: ["closedsubheader", "opensubheader"],
	    togglehtml: ["none", "", ""],
	    animatespeed: "fast",
	    oninit:function(headers, expandedindices){
	    },
	    onopenclose:function(header, index, state, isuseractivated){
	    }
	} );

	ddaccordion.init( {
	    headerclass: "board-menu-" + webAppName + "-" + aplContextRole,
	    contentclass: "board-menu-" + webAppName + "-items",
	    revealtype: "click",
	    mouseoverdelay: 200,
	    collapseprev: true,
	    defaultexpanded: [0],
	    onemustopen: false,
	    animatedefault: false,
	    persiststate: true,
	    toggleclass: ["", "openheader"],
	    togglehtml: ["prefix", "", ""],
	    animatespeed: "fast",
	    oninit:function(headers, expandedindices){
	    },
	    onopenclose:function(header, index, state, isuseractivated){
	    }
	} );
    }
}

const leftMenuCookie = document.body.dataset.leftMenuCookie;
if (leftMenuCookie) {
    const status = getCookieValue( leftMenuCookie );
    showHideLeftMenu( 'left-menu', 'left-menu-arrow', status );
}

const topMenuCookie = document.body.dataset.topMenuCookie;
if (topMenuCookie) {
    const status = getCookieValue( topMenuCookie );
    showHideTopMenu( 'top-menu', 'top-menu-arrow', status );
}

document.querySelectorAll( '[data-init-update-report]' ).forEach( function( element ) {
    updateReport( element.dataset.initUpdateReport,
		  Number( element.dataset.force),
		  element.dataset.argType || "",
		  element.dataset.argValue || ""
		);

} );

document.querySelectorAll( '[data-init-update-log]' ).forEach( function( element ) {
    updateLog( element.dataset.initUpdateLog, Number( element.dataset.force ));
} );

document.querySelectorAll( '[data-init-update-audit-log]' ).forEach( function( element ) {
    updateAuditLog( element.dataset.initUpdateAuditLog, Number( element.dataset.force ));
} );

document.addEventListener( 'click', function( event ) {
    const element = event.target.closest(
        '.animatedcollapse, [data-action]'
    );

    if (!element) {
        return false;
    }

    var args

    if ( !( element instanceof HTMLInputElement && element.type === 'checkbox' ) ) {
	event.preventDefault( );
    }

    if (element.classList.contains( 'animatedcollapse' )) {
        animatedcollapse.show( element.dataset.board );
        return true;
    }

    const network_utilities_working_icon = 'working-bar.gif';
    const network_utilities_display_zone_class = 'diagnostic-tools-msg';

    switch (element.dataset.action) {

    case 'goto-top-window':
	gotoTopWindow( );
	break;

    case 'toggle-zone':
        toggleZone(element.dataset.zone);
        break;

    case 'hide-zone':
        hideZone(element.dataset.zone);
        break;

    case 'close-zone':
	hideZone( element.dataset.zone );
	break;

    case 'update-log':
	updateLog( element.dataset.updatePage, 1 );
	break;

    case 'activate-post-buttons':
	activatePostButtons( );
	break;

    case 'deactivate-post-buttons':
	deactivatePostButtons( );
	break;

    case 'agree-license':
	agreeLicense( element.dataset.value );
	break;

    case 'toggle-selection':
	toggleSelection( element.dataset.class, element.dataset.state1, element.dataset.state2 );
	break;

    case 'get-latest-version':
	getLatestVersion( element.dataset.url, element.dataset.targetId );
	break;

    case 'submit-page':
	doClickButton( element.dataset.button );
        break;

    case 'previous-page':
    case 'next-page':
	{
	    const selectedPage = document.getElementById( SELECTED_PAGE_ID );
	    const recordsPerPage = document.getElementById( RECORDS_PPAGE_ID );
	    const previousButton = document.getElementById( PREVIOUS_PAGE_ID );
	    const nextButton = document.getElementById( NEXT_PAGE_ID );
	    const tableInit = document.querySelector( '[data-init-table-form]' );
	    const pages = tableInit ? parseInt( tableInit.dataset.pages, 10 ) : 1;
	    const orientation = element.dataset.action === 'previous-page' ? 'previous' : 'next';

	    initPageSelectionBrowseCB(selectedPage, recordsPerPage, previousButton, nextButton, pages, orientation );
	};
	break;

    case 'set-select-country-options':
    case 'set-select-guard-rule-options':
	args = JSON.parse( element.dataset.actionArgs || '[]' );
	setSelectOptions( ...args.slice( 0, 2 ));
	setSelectOptions( ...args.slice( -2 ));
	break;

    case 'set-select-guard-policy-options':
	args = JSON.parse( element.dataset.actionArgs || '[]' );
	setSelectOptions( ...args.slice( 0, 3 ));
	setSelectOptions( ...args.slice( -3 ));	
	break;

    case 'update-report':
	updateReport( element.dataset.updatePage, 1,
		      element.dataset.argType || "",
		      element.dataset.argValue || ""
		    );
	break;

    case 'reset-table-changes':
	args = JSON.parse( element.dataset.actionArgs || '[]' );
	resetTableChanges( args );
	break;

    case 'add-table-records':
	addTableRecords(
            element.dataset.table,
            element.dataset.listType,
            parseInt( element.dataset.maxRecords, 10 ));
	break;

    case 'delete-table-record':
	deleteTableRecord( element.dataset.listId, element.dataset.recordClass, element.dataset.deleteId );
	break;

    case 'delete-table-records':
	deleteTableSelectedRecords(
            element.dataset.listType,
            element.dataset.table );
	break;

    case 'remove-record':
	removeRecord( parseInt( element.dataset.recordCursor, 10 ) );
	break;

    case 'move-up-table-record':
	moveUpTableRecord( element.dataset.tableId, element.dataset.recordClass	);
	break;

    case 'move-down-table-record':
	moveDownTableRecord( element.dataset.tableId, element.dataset.recordClass );
	break;

    case 'toggle-selections-table-records':
	toggleSelectionsTableRecords( );
	break

    case 'insert-table-records':
	insertTableRecords( element.dataset.tableId, element.dataset.listId, element.dataset.recordClass, parseInt(element.dataset.maxRecords, 10 ));
	break;

    case 'move-up-table-record':
	moveUpTableRecord( element.dataset.tableId, element.dataset.recordClass );
	break;

    case 'move-down-table-record':
	moveDownTableRecord( element.dataset.tableId, element.dataset.recordClass );
	break;

    case 'update-table-buttons':
	updateTableButtons( );
	break;

    case 'copy-pre-to-clipboard':
	copyPreToClipboard( element.dataset.preId, element.id );
	break;

    case 'copy-to-clipboard':
	copyToClipboard( element.dataset.textAreaId, element.id, element.dataset.content );
	break;

    case 'collapse-check-zone':
	collapseCheckZone( element.id, element.dataset.zoneId );
	break;

    case 'send-phone-number':
	sendPhoneNumber( element.dataset.application, element.dataset.phoneId, element.dataset.message );
	break;

    case 'mosaic-reset-save':
	mosaicResetSave( element.dataset.id );
	break;

    case 'mosaic-save':
	mosaicSave( element.dataset.id );
	break;

    case 'mosaic-show':
        mosaicShow( element.dataset.parentId, element.dataset.page,
		    function( content ) {
			activateContent( content, element.dataset.page );
		    } );
	break;

    case 'ping':
	gotoTopWindow( );
	setIconImage( element.dataset.toolReportId, network_utilities_working_icon, network_utilities_display_zone_class );
	ping( element.dataset.toolReportId, element.dataset.hostId );
	break;

    case 'traceroute':
	gotoTopWindow( );
	setIconImage( element.dataset.toolReportId, network_utilities_working_icon, network_utilities_display_zone_class );
	traceroute( element.dataset.toolReportId, element.dataset.hostId, element.dataset.protocolId );
	break;

    case 'ip-neighbour':
	gotoTopWindow( );
	setIconImage( element.dataset.toolReportId, network_utilities_working_icon, network_utilities_display_zone_class );
	ipNeighbour( element.dataset.toolReportId );
	break;

    case 'ntp-update':
	setIconImage( element.dataset.toolReportId, network_utilities_working_icon, network_utilities_display_zone_class );
	ajaxpage( GUI_DIR + "/ntp-update" + GUI_EXTENSION, element.dataset.toolReportId );
	break;

    case 'snmp-trap-test':
	setIconImage( element.dataset.toolReportId, network_utilities_working_icon, network_utilities_display_zone_class );
	ajaxpage( GUI_DIR + "/admin-snmp-trap-test" + GUI_EXTENSION, element.dataset.toolReportId );
	break;

    case 'syslog-test':
	setIconImage( element.dataset.toolReportId, network_utilities_working_icon, network_utilities_display_zone_class );
	ajaxpage( GUI_DIR + "/log-syslog-test" + GUI_EXTENSION, element.dataset.toolReportId );
	break;

    case 'send-email':
	gotoTopWindow( );
	setIconImage( element.dataset.toolReportId, network_utilities_working_icon, network_utilities_display_zone_class );
	sendEmail( element.dataset.toolReportId, element.dataset.emailId );
	break;

    case 'authenticate-ldap-test':
	gotoTopWindow( );
	setIconImage( element.dataset.toolReportId, network_utilities_working_icon, network_utilities_display_zone_class );
	authenticateLDAPTest( element.dataset.toolReportId, 'login', 'password' );
	break;

    case 'ldap-search':
	gotoTopWindow( );
	setIconImage( element.dataset.toolReportId, network_utilities_working_icon, network_utilities_display_zone_class );
	LDAPSearch( element.dataset.toolReportId, 'filter' );
	break;

    case 'show-kerberos-keytab':
	gotoTopWindow( );
	setIconImage( element.dataset.toolReportId, network_utilities_working_icon, network_utilities_display_zone_class );
	showKerberosKeytab( element.dataset.toolReportId );
	break;

    case 'sticky-lb-select':
	stickyLBSelectCB( element.id, element.dataset.modeId, element.dataset.cookieId );
	break;

    case 'patch-operation-auto-load':
	patchOperationAutoLoadCB( element.id, element.dataset.protocolId, element.dataset.serverId, element.dataset.filenameId );
	break;

    case 'pie-toggle':
	togglePieSlice( element.dataset.pieId, element.dataset.pieName );
	break;

    case 'bar-toggle':
	toggleBar( element.dataset.barId, element.dataset.barName );
	break;

    case 'graph-toggle':
	toggleGraphSeries( element.dataset.graphId, element.dataset.graphName );
	break;

    case 'request-logout':
	requestLogout( );
	break;

    case 'update-audit-log':
	updateAuditLog( element.dataset.updatePage );
	break;

    default:
	return false;
	break;
    }

    return true;
} );

document.addEventListener( 'submit', function( event ) {
    const form = event.target;

    if (form.dataset.download === 'true') {
        return true;
    }

    if ( !form.dataset.postButtonId ) {
        return false;
    }

    event.preventDefault( );

    postContent(
        form.id,
        form.dataset.postConfirmation === 'true'
    );

} );

document.addEventListener( 'change', function( event ) {

    const element = event.target.closest( '[data-action]' );

    if (!element) {
        return false;
    }

    if (!element.dataset.action) {
	return false;
    }

    switch (webAppName) {

    case 'administration':

	switch (element.dataset.action) {

	case 'page-selection':
        case 'records-per-page':
	    {
		const selectedPage = document.getElementById( SELECTED_PAGE_ID );
		const recordsPerPage = document.getElementById( RECORDS_PPAGE_ID );
		const previousButton = document.getElementById( PREVIOUS_PAGE_ID );
		const nextButton = document.getElementById( NEXT_PAGE_ID );
		const tableInit = document.querySelector( '[data-init-table-form]' );
		const pages = tableInit ? parseInt( tableInit.dataset.pages, 10 ) : 1;
		const operation = element.dataset.action === 'page-selection' ? 'select' : 'records';

		initPageSelectionBrowseCB( selectedPage, recordsPerPage, previousButton, nextButton, pages, operation );
	    }
	    break;

	case 'waf-rweb-custom-show-rules':
	    showWAFRules( element.dataset.page, element.dataset.targetId );
	    break;

	case 'waf-rweb-custom-operation-select':
	    customWAFActionSelectCB( element.dataset.operationId, element.dataset.protocolId, element.dataset.serverId, element.dataset.filenameId, element.dataset.mode );
	    break;

	case 'select-url-list-auto-protocol':
	    selectURLListAutoProtocolCB( element.id, element.dataset.fileServerId, element.dataset.filenameId );
	    break;

	case 'select-all-the-same':
	    selectAllTheSameCB( element.dataset.class, element.dataset.class );
	    break;

	case 'select-url-list-auto-all-protocol':
	    selectURLListAutoAllProtocolCB(
		element.dataset.type,
		element.dataset.protocolClass,
		element.dataset.fileServerClass,
		element.dataset.filenameClass
	    );
	    break;

	case 'manager-select-context':
	    managerSelectContextCB( element.id );
	    break;

	case 'ajax-update-deny-url':
	    AJAX_updateDenyURL( element.id );
	    break;

	case 'set-calendar-day':
	    setCalendarDay( 'year', 'month', 'day' );
	    break;

	case 'target-gateway-select':
	    targetGatewaySelectCB( element.dataset.scopeSelectionId, element.dataset.gatewaySelectionId );
	    break;

	case 'print-tls':
	    printTLS( element.dataset.url, element.dataset.componentId, element.dataset.contentId );
	    break;

	case 'antivirus-whitelist-operation':
	    antivirusWhitelistOperationSelectCB( element.dataset.operationId, element.dataset.protocolId, element.dataset.serverId, element.dataset.filenameId );
	    break;

	case 'ssh-operation':
	    SSHOperationSelectCB( element.dataset.operationId, element.dataset.keyTypeId, element.dataset.protocolId, element.dataset.serverId, element.dataset.filenameId );
	    break;

	case 'ipsec-vpn-access-conf':
	    IPsecVPNAccessConfSelectCB( element.dataset.systemId, element.dataset.tlsId, element.dataset.contentId );
	    break;

	case 'access-ipsec-vpn-protocol':
	    accessIPsecVPNProtocolSelectCB( element.dataset.protocolId, element.dataset.serverId, element.dataset.nameId, element.dataset.targetId );
	    break;

	case 'url-list-content':
	    URLListContentSelectCB( element.dataset.operationId, element.dataset.protocolId, element.dataset.serverId, element.dataset.filenameId, element.dataset.verifyId );
	    break;

	case 'backup-operation':
	    backupOperationSelectCB( element.dataset.operationId, element.dataset.protocolId, element.dataset.serverId, element.dataset.filenameId );
	    break;

	case 'vpn-ipsec-site-settings':
	    VPNIPsecSiteSettingsCB( element.dataset.authenticateId, element.dataset.idBasedId, element.dataset.tlsIdId, element.dataset.dnFqdnId, element.dataset.pskId );
	    break;

	case 'dynamic-dns':
	    dynamicDNSSelectCB( element.dataset.stateId, element.dataset.providerId, element.dataset.hostnameId, element.dataset.usernameId, element.dataset.passwordId, element.dataset.providerWebsiteId );
	    break;

	case 'admin-snmp-certificate':
	    adminSNMPCertificateSelectCB( element.dataset.operationId, element.dataset.protocolId, element.dataset.serverId, element.dataset.filenameId );
	    break;

	case 'file-operation':
	    fileOperationSelectCB( element.dataset.operationId, element.dataset.protocolId, element.dataset.serverId, element.dataset.directoryId, element.dataset.titleId );
	    break;

	case 'registration-action':
	    registrationActionSelectCB( element.dataset.actionId, element.dataset.osKeyId );
	    break;

	case 'registration-mode':
	    registrationModeSelectCB( element.dataset.mode, element.dataset.link, element.dataset.email );
	    break;

	case 'configuration-load-save':
	    configurationLoadSaveSelectCB( element.dataset.operation, element.dataset.version, element.dataset.server, element.dataset.filename );
	    break;

	case 'tls-component':
	    TLSComponentSelectCB( element.dataset.componentId, element.dataset.operationId, element.dataset.daysId, element.dataset.ocspId, element.dataset.url, element.dataset.contentId );
	    break;

	case 'tls-operation':
	    TLSOperationSelectCB( element.dataset.componentId, element.dataset.operationId, element.dataset.daysId, element.dataset.ocspId );
	    break;

	case 'cache-size':
	    cacheSizeCB( element.dataset.state, element.dataset.bigobjectMin, element.dataset.bigobjectMax );
	    break;

	case 'vpn-ipsec-authenticate':
	    VPNIPsecAuthenticateSelectCB( element.dataset.methodId, element.dataset.autoPskId, element.dataset.pskId, element.dataset.tlsIdId, element.dataset.usedIdId );
	    break;
	    
	case 'vpnipsec-site':
	    var selectId = element.id;
	    var range = selectId.substring( selectId.lastIndexOf( "_" ) + 1 );

	    var authenticateId = element.dataset.authenticatePrefixId + '_' + range;
	    var tlsAuthenticateId = element.dataset.tlsAuthenticatePrefixId + '_' + range;
	    var tlsId = element.dataset.tlsPrefixId + '_' + range;
	    var pskDnFqdnId = element.dataset.pskDnFqdnPrefixId + '_' + range;

	    VPNIPsecSiteCB( authenticateId, tlsAuthenticateId, tlsId, pskDnFqdnId );
	    break;

	case 'snmp-trap-select-version':
	    var selectId = element.id;
	    var range = selectId.substring( selectId.lastIndexOf( "_" ) + 1 );

	    var versionId = element.dataset.versionPrefixId + '_' + range;
	    var userId = element.dataset.userPrefixId + '_' + range;
	    var hashId = element.dataset.hashPrefixId + '_' + range;
	    var encId = element.dataset.encPrefixId + '_' + range;
	    var privacyId = element.dataset.privacyPrefixId + '_' + range;

	    snmpTrapSelectVersionCB( versionId, userId, hashId, encId, privacyId );
	    break;

	case 'firewall-select':
	    var selectId = element.id;
	    var range = selectId.substring( selectId.lastIndexOf( "_" ) + 1 );

	    var actionId = element.dataset.actionPrefixId + '_' + range;
	    var protocolId = element.dataset.protocolPrefixId + '_' + range;
	    var dstPortsId = element.dataset.dstPortsPrefixId + '_' + range;
	    var srcNatIpId = element.dataset.srcNatIpPrefixId + '_' + range;
	    var dstNatIpId = element.dataset.dstNatIpPrefixId + '_' + range;
	    var dstPatPortId = element.dataset.dstPatPortPrefixId + '_' + range;

	    firewallSelectCB( actionId, protocolId, dstPortsId, srcNatIpId, dstNatIpId, dstPatPortId );
	    break;

	case 'authenticate-kerberos-ad':
	    authenticateKerberosADSelectCB( element.id, element.dataset.rdnId, element.dataset.loginId, element.dataset.password1Id, element.dataset.password2Id );
	    break;

	case 'ip-external-mode':
	    ipExternalModeCB( element.id,
			      element.dataset.ipId,
			      element.dataset.mkId,
			      element.dataset.pppoeServiceNameId,
			      element.dataset.pppoeUsernameId,
			      element.dataset.pppoePasswordId );
	    break;

        default:
	    break;
        }
	break;

    case 'auditing':
	switch (element.dataset.action) {

	case 'update-audit-log':
	    var updatePage = element.dataset.action;
	    updateAuditLog( updatePage, element.dataset.force );
	    break;

	case 'show-audit-log':
	    showAuditLog( element.dataset.siteName, element.dataset.force );
	    break;

	default:
	    break;
	}
	break;

    default:
	break;
    }

    return true;
    
} );

document.addEventListener( 'mouseover', function( event ) {

    const element = event.target.closest( '[data-action]' );

    if ( !element ) {
        return;
    }

    switch ( element.dataset.action ) {

    case 'show-min-max-tooltip':
        showMinMaxToolTip(
            parseInt( element.dataset.min, 10 ),
            parseInt( element.dataset.max, 10 )
        );
        break;

    case 'show-time-tooltip':
	showTimeToolTip( element.id );
	break;

    case 'show-tooltip':
	ddrivetip( element.dataset.tip );
	break;

    case 'pie-hover':
	hoverPieSlice( element.dataset.pieId, element.dataset.pieName );
	break;

    case 'bar-hover':
	hoverBar( element.dataset.barId, element.dataset.barName );
	break;

    default:
	break;
    }
} );

document.addEventListener( 'mouseout', function( event ) {

    const element = event.target.closest( '[data-action]' );

    if ( !element ) {
        return false;
    }

    switch ( element.dataset.action ) {

    case 'show-min-max-tooltip':
        hideMinMaxToolTip( );
        break;

    case 'show-tooltip':
	hideddrivetip( );
	break;

    case 'pie-hover':
	unhoverPieSlice( element.dataset.pieId );
	break;

    case 'bar-hover':
	unhoverBar( element.dataset.barId );
	break;

    case 'graph-hover':
	unhoverGraph( element.dataset.graphId );
	break;

    default:
	break;
    }
} );

document.addEventListener( "mousemove", function( event ) {
    var target = event.target;

    if ( !target || target.nodeType !== 1 )
        return;

    var element = target.closest( '[data-action="graph-hover"]' );

    if ( !element )
        return;

    hoverGraph( event, element );
} );

document.addEventListener( 'keydown', function( event ) {
    const element = event.target;

    if ( !( element instanceof HTMLElement ) ) {
        return false;
        }
    
    const actions = ( element.dataset.action || '' ).split( /\s+/ );

    if ( event.key === 'Enter' ) {
        if ( actions.includes( 'click-on-enter' ) ) {
            event.preventDefault();
            document.getElementById( element.dataset.buttonId )?.click();
        }
	else {
            if ( actions.includes( 'ignore-enter' ) ) {
                event.preventDefault();
            }
	}
    }
} );

document.addEventListener( 'blur', function( event ) {

    const target = event.target;

    if ( typeof target.closest !== 'function' ) {
        return false;
    }

    const element = target.closest( '[data-action]' );

    if ( !element ) {
        return false;
    }

    const actions = ( element.dataset.action || '' ).split( /\s+/ );

    if ( actions.includes( 'check-input' ) ) {

        const checkFunction = window[element.dataset.checkFunction];

        if ( typeof checkFunction === 'function' ) {
            checkFunction( element.id );
        }
    }
}, true );

activateContent( );
