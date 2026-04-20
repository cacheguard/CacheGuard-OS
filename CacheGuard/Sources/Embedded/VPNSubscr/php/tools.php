<?php

/*
###########################################################################
#
# MODULE:       VPN Subscription
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
*/

require "constant.php";

if (DEBUG_MODE) {
  error_reporting( E_ALL );
  ini_set( "display_errors", 1 );
}
else {
    error_reporting( 0 );
    ini_set( "display_errors", 0 );
}

function vpnsubscr_remove_whitespaces( $string_in )
{
    $whitespaces_filter = '/\s+/';
    $string_out = preg_replace( $whitespaces_filter, '', $string_in );
    return $string_out;
}

function vpnsubscr_remove_useless_whitespaces( $string_in )
{
    $whitespaces_filter = '/\s+/';
    $head_whitespaces_filter = '/^\s+/';
    $tail_whitespaces_filter = '/\s+$/';
    
    $string_out = preg_replace( $head_whitespaces_filter, '', $string_in );
    $string_out = preg_replace( $tail_whitespaces_filter, '', $string_out );
    $string_out = preg_replace( $whitespaces_filter, ' ', $string_out );

    return $string_out;
}

function vpnsubscr_get_devices( )
{
    $devices = array( );

    $devices[DEVICE_ANDROID] = "Android";
    $devices[DEVICE_APPLE] = "Apple";
    $devices[DEVICE_LINUX] = "Linux";
    $devices[DEVICE_WINDOWS] = "Windows";

    return $devices;
}

function vpnsubscr_get_device_name( $device, $cg = false )
{
    $devices = vpnsubscr_get_devices( );
    $name = $devices[$device];

    if ($cg) {
        $name = strtolower( $name );
    }
    
    return $name;
}

function vpnsubscr_get_device_icon( $device )
{
    $devices = vpnsubscr_get_devices( );
    $name = $devices[$device];
    $name = strtolower( $name );
    $icon = "/image/{$name}-logo.png";
    
    return $icon;
}

function vpnsubscr_get_profile_extension( $device )
{
    switch ($device) {

    case DEVICE_ANDROID:
        $extension = 'sswan';
        break;

    case DEVICE_APPLE:
        $extension = 'mobileconfig';
        break;

    case DEVICE_LINUX:
        $extension = 'bash';
        break;

    case DEVICE_WINDOWS:
        $extension = 'ps1';
        break;

    default:
        $extension = '';
        break;
    }

    return $extension;
}

function vpnsubscr_get_profile_link( $username, $device, $brief = true )
{
    $vpn_name = str_replace( ' ', '-', VPN_NAME );
    $device_name = vpnsubscr_get_device_name( $device );
    $device_cg_name = vpnsubscr_get_device_name( $device, true );
    $extension = vpnsubscr_get_profile_extension( $device );
    $profile_file = PROFILE_DIR . "/{$username}_{$vpn_name}.{$extension}";
    $download_title = "Download the $device_name VPN Profile";

    if (file_exists( $profile_file )) {
        if ($brief) {
            $download_icon = vpnsubscr_get_device_icon( $device );
            $profile_link = "<a href='$profile_file'><img width='40' src='$download_icon ' title='$download_title' alt='$download_title' /></a>";
        }
        else {
            $profile_link = "<a href='$profile_file'><img width='40' src='/image/download.png' title='$download_title' alt='$download_title' /> Download</a>";
        }
    }
    else {
        $profile_link = null;
    }

    return $profile_link;
}

function vpnsubscr_get_instructions_link( $username, $to, $brief = true )
{
    $instructions_file = PROFILE_DIR . "/$username.instructions";

    if (file_exists( $instructions_file )) {

        $instructions_title = "Email Instructions to Connect the VPN";
        $subject = "VPN Profile";
        $body = htmlentities( file_get_contents( $instructions_file ));
        $label = $brief ? '' : ' Email';

        $email_link = "<a href='mailto:$to?subject=$subject&body=$body'><img width='40' src='/image/email.png' title='$instructions_title' alt='$instructions_title' />$label</a>";
    }
    else {
        $email_link = null;
    }
    
    return $email_link;
}

function vpnsubscr_get_unexpected_error_message( $internal_message = "" )
{
    $message = "an unexpected error has occurred.";

    if (DEBUG_MODE) {
        if ($internal_message != "") {
            $message .= " The generated internal error description is: $internal_message";
        }
    }

    return $message;
}

function vpnsubscr_check_authenticated_session( )
{
    session_start( );
    $state = isset( $_SESSION['login'] ) && $_SESSION['login'] != '';
    return $state;
}

function vpnsubscr_check_login()
{
    if (!vpnsubscr_check_authenticated_session( )) {
        header( "Location: /login.php" );
    }
}

function vpnsubscr_print_error( $code, $message )
{
    echo "<div style='margin-top:10px;'>ERROR " . $code . ": " . $message . "</div>\n";
}

function vpnsubscr_print_all_errors( $errors )
{
    echo "<div class='box-error'>\n";
    foreach ($errors as $message) {
        vpnsubscr_print_error( $message[0], $message[1] );
    }
    echo "</div>\n";
}

function vpnsubscr_get_mail_data( $fp, $timeout )
{
    stream_set_timeout( $fp, $timeout );
    $data = fgets( $fp, 256 );
    return $data;
}

function vpnsubscr_send_mail_command( $fp, $out, $timeout )
{
    fwrite( $fp, $out . "\r\n" );
    return vpnsubscr_get_mail_data( $fp, $timeout );
}

function vpnsubscr_get_org_name( )
{
    return VPN_NAME;
}

function vpnsubscr_get_contact_to( $first, $last, $email )
{
    if ($last == "") {
        if ($first == "") {
            return $email;
        }
        else {
            return "$first &lt;$email&gt;";
        }
    }
    else {
        if ($first == "") {
            return "$last &lt;$email&gt;";
        }
        else {
            return "$first $last &lt;$email&gt;";
        }
    }
}

function vpnsubscr_get_contact_name( $first, $last, $email )
{
    if ($last == "") {
        if ($first == "") {
            return $email;
        }
        else {
            return $first;
        }
    }
    else {
        if ($first == "") {
            return $last;
        }
        else {
            return "$first $last";
        }
    }
}

function vpnsubscr_get_visible_contact_to( $name, $email )
{
    if (empty( $name )) {
        return $email;
    }
    else {
        return $name;
    }
}

function vpnsubscr_get_whatsapp_phone( $phone )
{
    $phone = vpnsubscr_remove_whitespaces( $phone );
    $phone = preg_replace( '/^00/', '', $phone );
    $phone = preg_replace( '/[+-]/', '', $phone );

    return $phone;
}

function vpnsubscr_get_encoded( $string )
{
    $encoded_string = '';
    $len = strlen( $string );

    for ($i=0 ; $i < $len ; $i++) {
        $encoded_string .= '%' . dechex( ord( substr( $string, $i, 1 )));
    }

    return $encoded_string;
}

function vpnsubscr_subscriber_service_icon( $service, $alive_date)
{
    switch ($service) {

    case SUBSCRIBER_STATE_INACTIVE:
        $icon = "working.gif";
        $title = "Creation in Progress";
        break;

    case SUBSCRIBER_STATE_ACTIVATED:
        if ($alive_date == 0) {
            $icon = "ok.png";
            $title = "Subscriber Created";
        }
        else {
            $icon = "connected.png";
            $title = "Has Connected";
        }
        break;

    case SUBSCRIBER_STATE_RESET:
        $icon = "working.gif";
        $title = "Resetting in Progress";
        break;

    case SUBSCRIBER_STATE_2SUSPEND:
        $icon = "working.gif";
        $title = "Suspension in Progress";
        break;

    case SUBSCRIBER_STATE_SUSPENDED:
        $icon = "suspended.png";
        $title = "Suspended";
        break;

    case SUBSCRIBER_STATE_2REACTIVATE:
        $icon = "working.gif";
        $title = "Reactivation in Progress";
        break;

    case SUBSCRIBER_STATE_2CANCEL:
        $icon = "working.gif";
        $title = "Cancellation in Progress";
        break;

    case SUBSCRIBER_STATE_CANCELLED:
        $icon = "cancelled.png";
        $title = "Cancelled";
        break;

    case SUBSCRIBER_STATE_UNKNOWN:
        $icon = "warning.png";
        $title = "Unknown";
        break;

    default:
        $icon = "warning.png";
        $title = "Unknown";
        break;
    }

    $img = "<img src='/image/$icon' title='$title' alt='$title' />";

    return $img;
}

function vpnsubscr_operation_status_icon( $status )
{
    switch ($status) {

    case SUCCESSFUL_OPERATION:
        return '';
        break;

    case FAILED_OPERATION:
        $icon = "ko.png";
        $title = "Last Operation Failed";
        break;

    default:
        return '';
        break;
    }

    $img = "<a href='report.php'><img src='/image/$icon' title='$title' alt='$title' /></a>";

    return $img;
}

function vpnsubscr_subscriber_get_password_icons( $username, $name, $phone, $tls_password )
{
    if ($tls_password == "") {
        return NOT_AVAILABLE;
    }

    $org_name = vpnsubscr_get_org_name( );
    // $sms = "Dear $name, your $org_name certificate password is: $tls_password";
    $sms = "$tls_password";

    $text_area_id = 'clipboard-text-area';
    $clipboard_icon = 'clipboard.png';
    $clipboard_icon_id = $username . '-clipboard-copy';
    $clipboard_title = "Copy Password to Clipboard";
    $clipboard_js = "copyToClipboard( \"$text_area_id\", \"$clipboard_icon_id\", \"$tls_password\" );";
    $clipboard_icon = "<img id='$clipboard_icon_id' onclick='$clipboard_js' src='/image/$clipboard_icon' title='$clipboard_title' alt='$clipboard_title' />";

    $whatsapp_icon = 'whatsapp.png';
    $whatsapp_title = "Send Password to $phone via WhatsApp&trade;";
    $whatsapp_phone = vpnsubscr_get_whatsapp_phone( $phone );

    $whatsapp_sms = vpnsubscr_get_encoded( $sms );
    $whatsapp_link = WHATSAPP_URL . "$whatsapp_phone?text=$whatsapp_sms";
    $whatsapp_icon = "<a href='$whatsapp_link' target='_blank'><img src='/image/$whatsapp_icon' title='$whatsapp_title' alt='$whatsapp_title' /></a>";

    $icons = "{$whatsapp_icon}{$clipboard_icon}";

    return $icons;
}

function vpnsubscr_is_valid_email( $email, $timeout = 60, $connect_timeout = 5 )
{
    // valid email address syntax
    if (!filter_var( $email, FILTER_VALIDATE_EMAIL )) {
        return FALSE;
    }
   
    $mailparts = explode( "@", $email, 2 );
    $hostname = $mailparts[1];
    $mxs = array();

    // get mx addresses by getmxrr
    $b_mx_avail = getmxrr( $hostname, $mx_records, $mx_weight );
    if (!$b_mx_avail) {
        return FALSE;
    }

    // copy mx records and weight into array $mxs
    for ($i=0 ; $i<count( $mx_records ) ; $i++) {
        $mxs[$mx_records[$i]] = $mx_weight[$i];
    }

    // sort array mxs to get servers with highest prio
    ksort( $mxs, SORT_NUMERIC );
    reset( $mxs );

    foreach ($mxs as $mx_host => $mx_weight) {
        // try connection on port 25

        $fp = @fsockopen( $mx_host, 25, $errno, $errstr, $connect_timeout );

        if (!$fp) {
            continue;
        }

        // wait on receiving the ready message
        $ms_resp = vpnsubscr_get_mail_data( $fp, $timeout );
        if (substr( $ms_resp, 0, 3) != "220") {
            fclose( $fp );
            continue;
        }

        // say HELO to mailserver
        $ms_resp = vpnsubscr_send_mail_command( $fp, "HELO " . PUBLIC_DOMAIN_NAME, $timeout );
        $code = substr( $ms_resp, 0, 3 );
        if ($code != "220" && $code != "250") {
            fclose( $fp );
            continue;
        }

        // initialize sending mail
        $ms_resp = vpnsubscr_send_mail_command( $fp, "MAIL FROM:<" . FROM_EMAIL . ">", $timeout );
        if (substr( $ms_resp, 0, 3) != "250") {
            fclose( $fp );
            continue;
        }

        // initialize sending mail
        $ms_resp = vpnsubscr_send_mail_command( $fp, "RCPT TO:<" . $email . ">", $timeout );
        if (substr( $ms_resp, 0, 3) != "250") {
            fclose( $fp );
            continue;
        }

        // quit mail server connection
        $ms_resp = vpnsubscr_send_mail_command( $fp, "QUIT", $timeout );
        fclose( $fp );
        return TRUE;
    }
    return FALSE;
}

function vpnsubscr_db_connect( $mode = SQLITE3_OPEN_READONLY )
{
    $message = '';
    $error = 0;
    $db = NULL;

    try {
        $db = new SQLite3( DB_FILE, $mode );
        $db->enableExceptions( true );
    }
    catch (Exception $e) {
        $error = 11;
        $message = vpnsubscr_get_unexpected_error_message( $e->getMessage( ) );
        return array( 'error' => $error, 'message' => $message, 'link' => $db );
    }

    return array( 'error' => $error,
                  'message' => $message,
                  'link' => $db );
}

function vpnsubscr_get_setup_data( )
{
    $errors = array( );
    $data = array( );

    $data[SERVICE_NAME] = VPN_NAME;
    $data[PRIVATE_DOMAIN_NAME] = DEFAULT_PRIVATE_DOMAIN_NAME;
    $data[TIMEZONE] = DEFAULT_TIMEZONE;
    $data[VPN_ADDRESS] = '';
    $data[SERVICE_STATE] = SETUP_STATE_UNKNOWN;

    $db_record = vpnsubscr_db_connect( SQLITE3_OPEN_READWRITE );
    $error = $db_record['error'];
    $message = $db_record['message'];
    $db = $db_record['link'];

    if ($error != 0) {
        array_push( $errors, array( $error, $message ));
        return array( ERRORS => $errors,
                      DATA => $data
        );
    }

    try {
        $db = $db_record['link'];
        $query = "SELECT COUNT(*) AS `count` FROM `setup` WHERE `id` = '0' AND `service` <> 0;";
        $statement = $db->prepare( $query );
        $result = $statement->execute( );

        $row = $result->fetchArray( );
        $count = $row['count'];

        switch ($count) {
        case 0:
            $result->finalize( );
            $data[SERVICE_STATE] = SETUP_STATE_INEXISTANT;
            return array( ERRORS => $errors,
                          DATA => $data
            );
            break;

        case 1:
            break;

        default:
            $result->finalize( );
            array_push( $errors, array( 13, "the setup is inconsistent." ));
            return array( ERRORS => $errors,
                          DATA => $data
            );
            break;
        }

        $query = "SELECT * FROM `setup` WHERE `id` =  '0';";
        $statement = $db->prepare( $query );
        $result = $statement->execute( );
        $row = $result->fetchArray( );

        $data[SERVICE_NAME] = $row[SERVICE_NAME];
        $data[PRIVATE_DOMAIN_NAME] = $row[PRIVATE_DOMAIN_NAME];
        $data[TIMEZONE] = $row[TIMEZONE];
        $data[VPN_ADDRESS] = $row[VPN_ADDRESS];
        $data[SERVICE_STATE] = $row[SERVICE_STATE];

        $result->finalize( );

        return array( ERRORS => $errors,
                      DATA => $data
        );
    }
    catch (Exception $e) {

        $message = vpnsubscr_get_unexpected_error_message( $e->getMessage( ));
        array_push( $errors, array( $error, $message ));

        return array( ERRORS => $errors,
                      DATA => $data
        );
    }
}

function vpnsubscr_check_service( )
{
    $setup = vpnsubscr_get_setup_data( );
    $errors = $setup[ERRORS];

    if ($errors) {
        foreach ($errors as $message) {
            vpnsubscr_print_error( $message[0], $message[1] );
            exit( 0);
        }
    }

    $data = $setup[DATA];

    switch ($data[SERVICE_STATE]) {
    case SETUP_STATE_ACTIVATED:
        return true;
        break;

    case SETUP_STATE_RESET:
    case SETUP_STATE_RESET_FAILED:
        header( "Location: reset.php" );
        return true;
        break;

    default:
        header( "Location: setup.php" );
        return true;
        break;
    }

    return true;
}

function vpnsubscr_display_setup_help( $operation, $service_state )
{
    $message = "Fill out the form below to setup your service as a VPN provider. Please note that your Service Identity and Private Domain names can only be set during the first setup or by resetting your service.";

    switch ($service_state) {

    case SETUP_STATE_INEXISTANT:
    case SETUP_STATE_INIT_FAILED:

        switch ($operation) {
        case 'reset':
            $message = "The service has never been setup before. Please make a first setup to initialise the service at [<a href='setup.php'>SETUP</a>].";
            break;

        default:
            break;
        }
        break;

    case SETUP_STATE_INITIALISED:
    case SETUP_STATE_MODIFIED:

        $message = "A setup configuration request is in progress. Please wait for its termination before any further requests.";
        break;

    case SETUP_STATE_FAILED:
        switch ($operation) {
        case 'reset':
            $message = "The service reset is unavailable because the first setup operation has failed. Please make a first setup to initialise the service at [<a href='setup.php'>SETUP</a>].";
            break;

        default:
            break;
        }
        break;

    case SETUP_STATE_RESET:

        $message = "A service reset request is in progress. Please wait for its termination before any further requests.";
        break;

    default:

        switch ($operation) {
        case 'reset':
            $message = "<span style='color:firebrick;font-weight:bold;'>Caution</span>: by resetting the service, subscribers will receive new connection instructions by email. If you still want to reset the service, fill out the form below and validate your choice.</span>";
            break;

        default:
            break;
        }
        break;
    }

    echo "<div class='box-help'>$message</div>";
}

function vpnsubscr_display_footer()
{
    $org_name = vpnsubscr_get_org_name( );
    $years = YEARS;
    $company = COMPANY;

    echo <<< EOT
<p><center><strong>$org_name</strong> is based upon a dedicated <a href="https://www.cacheguard.com/" target="_blank">CacheGuard</a> Gateway.</center><br />
<div style="clear:left;"></div>
<footer>
<div class='box-copyright'>
Copyright (C) $years $company - All rights reserved
</div>
</footer>

EOT;
}

function vpnsubscr_display_header( $logout = true )
{
    $org_name = vpnsubscr_get_org_name( );

    if ($logout) {
        $title = 'Logout';
        $logout_html = "<div class='box-logout'><a href='/logout.php'><img src='/image/logout.png' title='$title' alt='$title' /></a></div>\n";
        $logout_html .= "<div style='clear:left;'></div>";
        $logout_html .= "<script type='text/javascript'>printmenu( );</script>";
    }
    else {
        $logout_html="<div style='clear:left;'></div><br />";
    }

    echo <<< EOT
<div class='box-header'><a href="/"><strong>$org_name</strong></a></div>
$logout_html

EOT;
}

function vpnsubscr_print_recaptcha( )
{
    if (GOOGLE_RECAPTCHA_PRIVATE_KEY == '' or GOOGLE_RECAPTCHA_PUBLIC_KEY == '') {
        return false;
    }

    $key = GOOGLE_RECAPTCHA_PUBLIC_KEY;
    echo <<< EOT
<tr>
<td>CAPTCHA</td>
<td>
    <div class='g-recaptcha' style='margin:0; margin-top:5px;' data-sitekey='$key'></div>
</td>
</tr>

EOT;
}

function cg_check_recaptcha( )
{
    if (GOOGLE_RECAPTCHA_PRIVATE_KEY == '' or GOOGLE_RECAPTCHA_PUBLIC_KEY == '') return true;

    $method = isset( $_SERVER['REQUEST_METHOD'] ) ? $_SERVER['REQUEST_METHOD'] : '';
    $method = filter_var( $method, FILTER_SANITIZE_STRING );

    switch ($method) {

    case 'GET':
        return true;
        break;

    case 'POST':
        break;

    default:
        return false;
        break;
    }

    $recaptcha_verify_url = 'https://www.google.com/recaptcha/api/siteverify';

	$recaptcha_data = array(
		'secret' => GOOGLE_RECAPTCHA_PRIVATE_KEY,
		'response' => $_POST['g-recaptcha-response']
	);

	$recaptcha_options = array(
		'http' => array(
			'method' => 'POST',
            'header' => 'Content-type:application/x-www-form-urlencoded',
			'content' => http_build_query( $recaptcha_data )
		)
	);

    if (SSL_MEDIATION_MODE) {
        $recaptcha_options = array_merge( $recaptcha_options,
                                          array(
                                              'ssl' => array(
                                                  'cafile' => CA_FILE,
                                                  'verify_peer' => TRUE )));
    }

    $recaptcha_context = stream_context_create( $recaptcha_options );
	$recaptcha_verify = file_get_contents( $recaptcha_verify_url, false, $recaptcha_context );
	$recaptcha_success = json_decode( $recaptcha_verify );

    return $recaptcha_success->success;
}

function vpnsubscr_get_unavailable_message( $alive_date, $service )
{
    if ($alive_date == 0) {
        if ($service == SUBSCRIBER_STATE_CANCELLED) {
            $message = PURGED;
        }
        else {
            $message = NOT_AVAILABLE;
        }
    }
    else {
        $message = PURGED;
    }

    return $message;
}

?>
