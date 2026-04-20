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

require "tools.php";
require "2fa-tools.php";

use OTPHP\InternalClock;
use OTPHP\TOTP;

vpnsubscr_check_login( );

function vpnsubscr_get_2fa_emergency_code( )
{
    $len = 8;
    $base = "0123456789";

    $max = strlen( $base ) - 1;
    $code = "";
    mt_srand( ( double )microtime( true ) * 1000000 );

    while (strlen( $code) < $len )
        $code .= substr( $base, mt_rand( 0, $max ), 1 ) ;
    
    return $code;
}

function vpnsubscr_get_2fa_emergency_codes( $n = 8 )
{
    $i = 0;
    $codes = array( );

    while ($i < $n) {
        $code = vpnsubscr_get_2fa_emergency_code( );
        if (!in_array( $code, $codes )) {
            $codes[$i] = $code;
            $i++;
        }
    }

    sort( $codes );

    return $codes;
}

function vpnsubscr_get_inputs( )
{
    $data = array( );

    $method = isset( $_SERVER['REQUEST_METHOD']  ) ? $_SERVER['REQUEST_METHOD']  : '';
    $method = filter_var( $method, FILTER_SANITIZE_FULL_SPECIAL_CHARS );

    switch ($method) {

    case 'GET':
        $data[MFA_STATE] = 'off';
        break;

    case 'POST':
        $data[MFA_STATE] = isset( $_POST[MFA_STATE] ) ? $_POST[MFA_STATE] : 'off';

        if (isset( $_POST['token'] )) {
            $data['token'] = $_POST['token'];
        }

        foreach ($data as $key => $value) {
            $data[$key] = filter_var( $value, FILTER_SANITIZE_FULL_SPECIAL_CHARS );
        }
        break;
        
    default:
        $method = 'NONE';
        $data[MFA_STATE] = 'off';
        break;
    }

    return array( METHOD => $method,
                  DATA => $data
    );
}

function vpnsubscr_get_input_state( $data )
{
    $errors = array( );

    switch ($data[MFA_STATE]) {
    case 'on':
    case 'off':
        break;

    default:
        array_push( $errors, array( 21, "this is not a valid 2FA state." ));
    }

    return $errors;
}

function vpnsubscr_get_2fa_form( )
{
    $input = vpnsubscr_get_inputs( );
    $data = $input[DATA];
    $method = $input[METHOD];
    $errors = array( );
    $codes = array( );

    switch ($method) {

    case 'GET':
    case 'POST':
        $errors = vpnsubscr_get_input_state( $data );
        break;

    default:
        array_push( $errors, array( 31, "this HTTP method is not supported." ));
        break;
    }

    if (!empty( $errors )) {
        return array( ERRORS => $errors,
                      METHOD => $method,
                      DATA => $data
        );
    }

    $db_record = vpnsubscr_db_connect( );
    $error = $db_record['error'];
    $message = $db_record['message'];
    $db = $db_record['link'];

    if ($error != 0) {
        array_push( $errors, array( $error, $message ));
        return array( ERRORS => $errors,
                      METHOD => $method,
                      DATA => $data
        );
    }

    $username = $_SESSION['username'];

    try {
        $db->enableExceptions( true );
        $query = "SELECT `domain_name` FROM `setup` WHERE `id` =  '0';";
        $statement = $db->prepare( $query );
        $result = $statement->execute( );
        $row = $result->fetchArray( );
        $data[PRIVATE_DOMAIN_NAME] = $row[PRIVATE_DOMAIN_NAME];

        $query = "SELECT `mfa_state`, `mfa_secret` FROM `administrator` WHERE `username` = '$username';";
        $statement = $db->prepare( $query );
        $result = $statement->execute( );
        $row = $result->fetchArray( );

        $data[MFA_SECRET] = $row[MFA_SECRET];
        $data[MFA_DB_STATE] = $row[MFA_STATE];

        if (empty( $data[MFA_SECRET] )) {
            $clock = new InternalClock( );
            $otp = TOTP::generate( $clock );
            $data[MFA_SECRET] = $otp->getSecret( );
        }

        if ($method == 'POST') {
            switch ($data[MFA_STATE]) {
            case 'off':
                $data[MFA_STATE] = 0;
                break;

            case 'on':
                if ($data[MFA_DB_STATE] != 2) {
                    $data[MFA_STATE] = 1;
                }
                else {
                    $data[MFA_STATE] = 2;
                }
                break;

            default:
                break;
            }
        }
        else {
            $data[MFA_STATE] = $row[MFA_STATE];
        }

        $query = "SELECT `code` FROM `mfa_emergency` WHERE `username` = '$username' ORDER BY `code` ASC;";
        $statement = $db->prepare( $query );
        $result = $statement->execute( );

        while ($row = $result->fetchArray( )) {
            array_push( $codes, $row['code'] );
        }
        $data[MFA_EMERGENCIES] = $codes;

        $result->finalize( );
    }
    catch (Exception $e) {
        $code = 101;
        $message = vpnsubscr_get_unexpected_error_message( $e->getMessage( ));
        array_push( $errors, array( $code, $message ));
        return array( ERRORS => $errors,
                      METHOD => $method,
                      DATA => $data
        );
    }

    return array( ERRORS => $errors,
                  METHOD => $method,
                  DATA => $data
    );
}

function vpnsubscr_write_db( $data )
{
    $errors = array( );
    $state = WRITE_NONE;

    $mfa_state = $data[MFA_STATE];
    $mfa_db_state = $data[MFA_DB_STATE];

    if ($mfa_state == 1 and $mfa_db_state == 2) {
        return array( 'state' => $state,
                      ERRORS => $errors,
                      DATA => $data
        );
    }

    $db_record = vpnsubscr_db_connect( SQLITE3_OPEN_READWRITE );
    $error = $db_record['error'];
    $message = $db_record['message'];
    $db = $db_record['link'];

    if ($error != 0) {
        array_push( $errors, array( $error, $message ));
        return array( 'state' => $state,
                      ERRORS => $errors,
                      DATA => $data
        );
    }

    $username = $_SESSION['username'];
    $mfa_secret = $data[MFA_SECRET];
    $mfa_emergencies = $data[MFA_EMERGENCIES];

    switch ($mfa_state) {
    case 0:
        $mfa_secret = '';
        break;

    case 1:
        if (isset( $data['token'] )) {
            $token = $data['token'];
            $token_len = strlen( $token );

            if ($token_len < 6 or $token_len > 8) {
                array_push( $errors, array( 201, "this is not a valid varification code." ));
            }
            elseif (preg_match ( '/^[0-9]+$/', $token ) == 0) {
                array_push( $errors, array( 203, "this is not a valid varification code." ));
            }
            else {
                $clock = new InternalClock( );
                $otp = TOTP::createFromSecret( $mfa_secret, $clock );  
                if ($otp->verify( $token )) {
                    $mfa_state = 2;
                    $data[MFA_STATE] = $mfa_state;
                }
                else {
                    $error = 205;
                    $message = "the entered verification code is not valid.";
                    array_push( $errors, array( $error, $message ));
                }
            }
        }
        break;

    case 2:
        break;

    default:
        break;
    }

    if ($errors) {
        return array( 'state' => $state,
                      ERRORS => $errors,
                      DATA => $data
        );
    }

    $queries = array( );
    $index = 0;
    $queries[$index] = "UPDATE `administrator` SET `mfa_state` = '$mfa_state', `mfa_secret` = '$mfa_secret' WHERE `username` = '$username';";
    $index++;
    $queries[$index] = "DELETE FROM `mfa_timestamp` WHERE `username` = '$username';";
    $index++;

    switch ($mfa_state) {
    case 0:
        $queries[$index] = "DELETE FROM `mfa_emergency` WHERE `username` = '$username';";
        $index++;
        break;

    case 1:
        if (empty( $mfa_emergencies )) {
            $mfa_emergencies = vpnsubscr_get_2fa_emergency_codes( );
            $data[MFA_EMERGENCIES] = $mfa_emergencies;

            foreach ($mfa_emergencies as $code) {
                $queries[$index] = "INSERT INTO `mfa_emergency`(`username`, `code`) VALUES ('$username', '$code');";
                $index++;
            }
        }
        break;

    case 2:
        if (isset( $data['token'] )) {
            $time = time( );
            $step_now = intdiv( $time, TWO_FACTOR_AUTHENTICATION_STEP_SIZE );
            $queries[$index] = "INSERT INTO `mfa_timestamp`(`username`, `step_time`) VALUES ('$username', '$step_now');";
            $index++;
        }
        break;

    default:
        break;
    }

    try {
        $db->enableExceptions( true );
        foreach ($queries as $query) {
            $statement = $db->prepare( $query );
            $result = $statement->execute( );
            $result->finalize( );
        }
    }
    catch (Exception $e) {
        $message = vpnsubscr_get_unexpected_error_message( $e->getMessage( ));
        array_push( $errors, array( 203, $message ));
        return array( 'state' => $state,
                      ERRORS => $errors,
                      DATA => $data
        );
    }

    return array( 'state' => WRITE_UPDATE,
                  ERRORS => $errors,
                  DATA => $data
    );
}

function vpnsubscr_display_help( $method, $mfa_state, $write_state, $errors )
{
    $mfa_message = "In order to activate the 2FA, please scan the following QR code with your Authenticator App and then submit a first Verification Code (provided by your App).<p>Think about saving emergency codes displayed below in a safe place. You can use them instead of a Verification Code in case where your Authenticator App would not be available.";

    switch ($method) {
    case 'GET':
        if ($mfa_state== 1) {
            $help_message = $mfa_message;
        }
        else {
            $help_message = "Use this form to setup the 2FA (Two Factor Authentication).";
        }
        break;

    case 'POST':
        if ($mfa_state == 1) {
            $help_message = $mfa_message;
        }
        else {
            if (!$errors && $write_state == WRITE_UPDATE) {
                $help_message = "The 2FA state has been successfully updated.";
            }
            else {
                $help_message = $mfa_message;
            }
        }
        break;

    default:
        return false;
        break;
    }

    echo "<div class='box-help'>$help_message</div>";

    return true;
}

function vpnsubscr_display_form( $record )
{
    $method = $record[METHOD];
    $data = $record[DATA];
    $mfa_state = $data[MFA_STATE];
    $mfa_emergencies = $data[MFA_EMERGENCIES];
    
    $write_state = WRITE_NONE;

    if ($method == 'POST') {

        $errors = $record[ERRORS];

        if (!$errors) {
            $result = vpnsubscr_write_db( $data );
            $write_state = $result['state'];
            $errors = $result[ERRORS];
            $data = $result[DATA];
            $mfa_state = $data[MFA_STATE];
            $mfa_emergencies = $data[MFA_EMERGENCIES];
        }
    }
    elseif ($method == 'GET') {
        $errors = $record[ERRORS];
    }
    else {
        $errors = array( );
        array_push( $errors, array( 301, "this HTTP method is not supported." ));
    }

    vpnsubscr_display_help( $method, $mfa_state, $write_state, $errors );

    if ($write_state == WRITE_UPDATE && $mfa_state != 1) {
        return true;
    }

    vpnsubscr_print_all_errors( $errors );

    $enabled_check = $mfa_state == 0 ? '' : ' checked';
    $disabled_check = $mfa_state != 0 ? '' : ' checked';
    $timecontainer_id = 'timecontainer';
    $timezone = new DateTimeZone( date_default_timezone_get( ));
    $date = new DateTime( 'now', $timezone );
    $date_seconds = $date->format( 'U' );
    $offset_mn = $date->getOffset( ) / 60;

    if ($mfa_state == 1) {
        $app_name = COMMERCIAL_NAME;
        $org_name = vpnsubscr_get_org_name( );
        $username = $_SESSION['username'];
        $domainname = $data[PRIVATE_DOMAIN_NAME];
        $secret = $data[MFA_SECRET];

        $mfa_init_url = "otpauth://totp/$org_name:$username@$domainname?secret=$secret&issuer=$app_name";
        echo <<< EOT
<center>
<span id='qrcode'></span>
</center>
<script type='text/javascript'>
var qrcode = new QRCode( document.getElementById( 'qrcode' ), {
text: "$mfa_init_url",
width: 95, 
height: 95, 
colorDark: 'FireBrick',
colorLight: 'White',
correctLevel: QRCode.CorrectLevel.M
} );
</script>
EOT;
    }
    echo <<< EOT
<div class='box-field'>
Local Time: <span id='$timecontainer_id'></span>
</div>

<script type='text/javascript'>
new showLocalTime( '$timecontainer_id', $date_seconds, $offset_mn, 'short');
</script>

<form name="submit-vpnsubscr-form" id="submit-vpn-form" action="/2fa.php" method="POST">
<center>
<table class='box-form'>

<tr>
<td width='95%'><label for='mfa_on'>Enable 2FA (Two Factor Authentication)</label></td>
<td width='5%' align='center'><input style='margin:0; margin-top:5px;' type='radio' id='mfa_on' name='mfa_state' value='on'$enabled_check /></td>
</tr>

<tr>
<td><label for='mfa_off'>Disable 2FA (Two Factor Authentication)</label></td>
<td align='center'><input style='margin:0; margin-top:5px;' type='radio' id='mfa_off' name='mfa_state' value='off'$disabled_check /></td>
</tr>
EOT;
    if ($mfa_state == 1) {
        $mfa_emergencies_html = implode( '<br />', $mfa_emergencies );
        echo <<< EOT

<tr>
<td>Verification Code</td>
<td><center><input name='token' maxlength='8' size='8' value='' autocomplete='off' /></center></td>
</tr>

<tr>
<td>Emergency Codes</td>
<td><center>$mfa_emergencies_html</center></td>
EOT;
    }
    echo <<< EOT
</tr>

<tr>
<td></td><td align='right'><input class='valid-button' type='submit' value='Validate' /></td>
</tr>
</table>
</center>
</form>
EOT;
}

// Main( )

$TWOFAFORM = vpnsubscr_get_2fa_form( );

?>
<!DOCTYPE html>
<html>
  <head>
    <title>Login to <?php echo vpnsubscr_get_org_name( ); ?> 2FA Setup</title>

    <link rel="shortcut icon" type="image/x-image" href="/image/favicon.ico" />
    <link rel="stylesheet" type="text/css" href="/chromestyle.css" />
    <link rel="stylesheet" type="text/css" href="/style.css" />

    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="robots" content="noindex, nofollow, noarchive, noarchive, nosnippet, noodp, noydir" />
    <meta name="description" content="This page allows you to setup the 2FA to login to the VPN management application." />

    <script type="text/javascript" src="/js/localTime.js"></script>
    <script type="text/javascript" src="/js/qrcode.min.js"></script>
    <script type="text/javascript" src="/js/chrome.js"></script>
    <script type="text/javascript" src="/js/vpnsubscr.js"></script>
    <script type="text/javascript" src="/js/printmenu.js"></script>
    <script type="text/javascript" src="/js/logout.js"></script>
  </head>

  <body>
    <?php vpnsubscr_display_header( ); ?>
    <div class='box-centered-container'>
      <div class='box-centered-nested'>
	<div class='page-title'>Account &gt; 2FA Setup</div>
	<?php vpnsubscr_display_form( $TWOFAFORM ); ?>
      </div>
    </div>
    <?php vpnsubscr_display_footer( ); ?>
  </body>
</html>
