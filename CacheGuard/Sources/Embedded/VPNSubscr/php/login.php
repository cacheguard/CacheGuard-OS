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

function vpnsubscr_login( )
{
    if ($_SERVER['REQUEST_METHOD'] != 'POST') {
        if (vpnsubscr_check_authenticated_session( )) {
            header( "Location: index.php" );
            exit( 0 );
        }
        return array( 'state' => 0, 'message' =>  '' );
    }
    else {
        if (!cg_check_recaptcha( )) {
            return array( 'state' => 101, 'message' => "The reCAPTCHA wasn't entered correctly. Please try again." );
        }
    }

    $db_record = vpnsubscr_db_connect( SQLITE3_OPEN_READWRITE );
    $error = $db_record['error'];
    $message = $db_record['message'];
    $db = $db_record['link'];

    if ($error != 0) {
        return array( 'state' => $error, 'message' => $message );
    }

    if (isset( $_POST['username'] ) and isset( $_POST['password'] )) {
        $username = substr( filter_var( $_POST['username'], FILTER_SANITIZE_FULL_SPECIAL_CHARS ), 0, 16 );
        $password = substr( filter_var( $_POST['password'], FILTER_SANITIZE_FULL_SPECIAL_CHARS ), 0, 48 );

        $sha1_password = sha1( $password . "\n" );

        try {
            $db->enableExceptions( true );
            $query = "SELECT COUNT(*) AS `count` FROM `administrator` WHERE `username` = '$username' AND `password` = '$sha1_password';";
            $statement = $db->prepare( $query );
            $result = $statement->execute( );

            $count = 0;
            $row = $result->fetchArray( );
            $count = $row['count'];

            $result->finalize( );
        }
        catch (Exception $e) {
            $code = 103;
            $message = vpnsubscr_get_unexpected_error_message( $e->getMessage( ));
            return array( 'state' => $code, 'message' =>  $message );
        }

        if ($count == 1) {
            try {
                $data = array( );
                $data[MFA_STATE] = 0;
            
                $db->enableExceptions( true );
                $query = "SELECT mfa_state FROM `administrator` WHERE `username` = '$username';";
                $statement = $db->prepare( $query );
                $result = $statement->execute( );

                $row = $result->fetchArray( );
                $data[MFA_STATE] = $row[MFA_STATE];

                $result->finalize( );
            }
            catch (Exception $e) {
                $code = 105;
                $message = vpnsubscr_get_unexpected_error_message( $e->getMessage( ));
                return array( 'state' => $code, 'message' =>  $message );
            }

            if ($data[MFA_STATE] != 2) {
                session_start( );
                $_SESSION['login'] = 'yes';
                $_SESSION['username'] = $username;
                header( "Location: index.php");
                exit( 0 );
            }
            else {
                session_start( );
                $_SESSION['username'] = $username;

                $code = 2;
                $message = '';
                return array( 'state' => $code, 'message' =>  $message );
            }
        }
        else {
            sleep( 3 );
            return array( 'state' => 107, 'message' =>  "login failed." );
        }
    }
    else {
        if (isset( $_POST['token'] )) {
            session_start( );
            if (isset( $_SESSION['username'])) {
                $username = $_SESSION['username'];
            }
            else {
                exit( 0 );
            }

            $token = substr( filter_var( $_POST['token'], FILTER_SANITIZE_FULL_SPECIAL_CHARS ), 0, 8 );
            $token_len = strlen( $token );

            switch ($token_len) {
            case 6:
            case 8:
                    break;
            default:
                return array( 'state' => 201, 'message' =>  "wrong token." );
                break;
            }

            $data = array( );
            $data[MFA_SECRET] = '';

            try {
                $db->enableExceptions( true );

                switch ($token_len) {

                case 8:
                    $query = "SELECT COUNT(*) AS `count` FROM `mfa_emergency` WHERE `username` = '$username' and `code` = '$token';";
                    $statement = $db->prepare( $query );
                    $result = $statement->execute( );
                    $count = 0;
                    $row = $result->fetchArray( );
                    $count = $row['count'];
                    $result->finalize( );

                    if ($count == 1) {
                        $query = "DELETE FROM `mfa_emergency` WHERE `username` = '$username' and `code` = '$token';";
                        $statement = $db->prepare( $query );
                        $result = $statement->execute( );
                        $row = $result->fetchArray( );
                        $result->finalize( );

                        $_SESSION['login'] = 'yes';
                        header( "Location: index.php");
                        exit( 0 );
                    }
                    else {
                        return array( 'state' => 203, 'message' =>  "wrong token." );
                    }
                    break;

                case 6:
                    $query = "SELECT `mfa_secret` FROM `administrator` WHERE `username` = '$username';";
                    $statement = $db->prepare( $query );
                    $result = $statement->execute( );

                    $row = $result->fetchArray( );
                    $result->finalize( );
                    $data[MFA_SECRET] = $row[MFA_SECRET];

                    $clock = new InternalClock( );
                    $otp = TOTP::createFromSecret( $data[MFA_SECRET], $clock );

                    if ($otp->verify( $token )) {
                        $time = time( );
                        $step_now = intdiv( $time, TWO_FACTOR_AUTHENTICATION_STEP_SIZE );
                        $min_step_time = $step_now - TWO_FACTOR_AUTHENTICATION_WINDOW_SIZE;
                        $query = "SELECT `step_time` FROM `mfa_timestamp` WHERE `username` = '$username' ORDER BY `step_time` ASC;";
                        $statement = $db->prepare( $query );
                        $result = $statement->execute( );

                        while ($row = $result->fetchArray( )) {
                            if ($row['step_time'] >= $step_now) {
                                return array( 'state' => 205, 'message' =>  "wrong token." );
                            }
                        }

                        $index = 0;
                        $queries = array( );                        

                        $queries[$index] = "DELETE FROM `mfa_timestamp` WHERE `username` = '$username' and `step_time` <= $min_step_time;";
                        $index++;

                        $queries[$index] = "INSERT INTO `mfa_timestamp`(`username`, `step_time`) VALUES ('$username', '$step_now');";
                        $index++;

                        foreach ($queries as $query) {
                            $statement = $db->prepare( $query );
                            $result = $statement->execute( );
                            $result->finalize( );
                        }

                        $_SESSION['login'] = 'yes';
                        header( "Location: index.php");
                        exit( 0 );
                    }
                    else {
                        return array( 'state' => 207, 'message' =>  "wrong token." );
                    }
                    break;

                default:
                    break;
                }
            }
            catch (Exception $e) {
                $code = 209;
                $message = vpnsubscr_get_unexpected_error_message( $e->getMessage( ));
                return array( 'state' => $code, 'message' =>  $message );
            }
        }
        else {
            exit( 0 );
        }
    }
}

function vpnsubscr_display_login( $login_record )
{
    switch ($login_record['state']) {
    case 0:
    case 2:
        break;

    default:
        echo "<div class='box-error'>\n";
        vpnsubscr_print_error( $login_record['state'], $login_record['message'] );
        echo "</div>\n";
        break;
    }

    echo "<table>\n";

    switch ($login_record['state']) {

    case 2:
        $focus_id = 'token';
        echo <<< EOT
	  <tr>
	    <td>Verification Code</td>
	    <td><input name='token' type='text' id='$focus_id' size='11' maxlength='8' value='' autocomplete='off' /></td>
	  </tr>
EOT;
        break;

    default:
        $focus_id = 'username';
        echo <<< EOT
	  <tr>
	    <td>Username</td>
	    <td><input name='username' type='text' id='$focus_id' size='24' maxlength='48' value='' autocomplete='off' /></td>
	  </tr>
	  <tr>
	    <td>Password</td>
	    <td><input name='password' type='password' id='password' size='24' maxlength='48'  autocomplete='off' /></td>
	  </tr>
EOT;
        vpnsubscr_print_recaptcha( );
        break;
    }

    echo <<< EOT
        <tr>
	    <td></td>
	    <td><input class='valid-button' type='submit' name='submit' value="Login" /></td>
	  </tr>
    </table>
    <script type='text/javascript'>document.getElementById( '{$focus_id}' ).focus( );</script>
EOT;
}

$login_record = vpnsubscr_login( );

?>
<!DOCTYPE html>
<html>
  <head>
    <title>Login to <?php echo vpnsubscr_get_org_name( ); ?></title>

    <link rel="shortcut icon" type="image/x-image" href="/image/favicon.ico" />
    <link rel="stylesheet" type="text/css" href="/chromestyle.css" />
    <link rel="stylesheet" type="text/css" href="/style.css" />

    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="robots" content="noindex, nofollow, noarchive, noarchive, nosnippet, noodp, noydir" />
    <meta name="description" content="This page allows you to login to the VPN management application." />

    <?php
      if (GOOGLE_RECAPTCHA_PRIVATE_KEY != '' and GOOGLE_RECAPTCHA_PUBLIC_KEY != '') {
          echo "    <script type='text/javascript' src='https://www.google.com/recaptcha/api.js'></script>";
      }
    ?>
    <script type="text/javascript" src="/js/chrome.js"></script>
  </head>

  <body>
    <?php vpnsubscr_display_header( false ); ?>
    <form name='login' method='post' action="login.php">
    <center>
    <?php vpnsubscr_display_login( $login_record ); ?>
    </center>
    </form>
    <?php vpnsubscr_display_footer( ); ?>
  </body>
</html>
