<?Php

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

vpnsubscr_check_login( );

function vpnsubscr_get_inputs( )
{
    $data = array( );

    $method = isset( $_SERVER['REQUEST_METHOD']  ) ? $_SERVER['REQUEST_METHOD']  : '';
    $method = filter_var( $method, FILTER_SANITIZE_FULL_SPECIAL_CHARS );

    switch ($method) {

    case 'GET':
        $data[LOGIN_PASSWORD] = '';
        $data[LOGIN_PASSWORD1] = '';
        $data[LOGIN_PASSWORD2] = '';
        break;

    case 'POST':
        $data[LOGIN_PASSWORD] = isset( $_POST[LOGIN_PASSWORD] ) ? $_POST[LOGIN_PASSWORD] : '';
        $data[LOGIN_PASSWORD1] = isset( $_POST[LOGIN_PASSWORD1] ) ? $_POST[LOGIN_PASSWORD1] : '';
        $data[LOGIN_PASSWORD2] = isset( $_POST[LOGIN_PASSWORD2] ) ? $_POST[LOGIN_PASSWORD2] : '';

        foreach ($data as $key => $value) {
            $data[$key] = filter_var( $value, FILTER_SANITIZE_FULL_SPECIAL_CHARS );
        }
        break;
        
    default:
        $method = 'NONE';
        $data[LOGIN_PASSWORD] = '';
        $data[LOGIN_PASSWORD1] = '';
        $data[LOGIN_PASSWORD2] = '';
        break;
    }

    return array( METHOD => $method,
                  DATA => $data
    );
}

function vpnsubscr_get_input_state( $data )
{
    $errors = array( );

    $password = $data[LOGIN_PASSWORD];
    $password1 = $data[LOGIN_PASSWORD1];
    $password2 = $data[LOGIN_PASSWORD2];

    $len = strlen( $password1 );
    if ($len < LOGIN_PASSWORD_MIN_LEN or $len > LOGIN_PASSWORD_MAX_LEN) {
        $min = LOGIN_PASSWORD_MIN_LEN;
        $max = LOGIN_PASSWORD_MAX_LEN;
        array_push( $errors, array( 21, "Your new password must be between $min and $max characters long." ));
    }

    if (preg_match( '/^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#%.\$\&\*-])/', $password1 ) == 0) {
        array_push( $errors, array( 23, "Please use at least one lowercase char, one uppercase char, one digit and one special sign of !@#%.$&*-." ));
    }

    if ($password1 != $password2) {
        array_push( $errors, array( 25, "Your password confirmation does not match your new password." ));
    }

    return $errors;
}

function vpnsubscr_get_pform( )
{
    $input = vpnsubscr_get_inputs( );
    $data = $input[DATA];
    $method = $input[METHOD];

    switch ($method) {

    case 'POST':
        $errors = vpnsubscr_get_input_state( $data );
        break;

    default:
        $errors = array( );
        break;
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

    $db_record = vpnsubscr_db_connect( SQLITE3_OPEN_READWRITE );
    $error = $db_record['error'];
    $message = $db_record['message'];
    $db = $db_record['link'];

    if ($error != 0) {
        array_push( $errors, array( $error, $message ));
        return array( 'state' => $state, ERRORS => $errors );
    }

    $username = $_SESSION['username'];
    $password = $data[LOGIN_PASSWORD];
    $password1 = $data[LOGIN_PASSWORD1];

    $sha1_password = sha1( $password . "\n" );
    $sha1_password1 = sha1( $password1 . "\n" );

    try {
        $query = "SELECT COUNT(*) AS `count` FROM `administrator` WHERE `username` = '$username' AND `password` = '$sha1_password';";
        $statement = $db->prepare( $query );
        $result = $statement->execute( );

        $row = $result->fetchArray( );
        $count = $row['count'];

        if ($count != 1) {
            $message = "your input current password is not valid.";
            sleep( 3 );
            array_push( $errors, array( 201, $message ));
        }
        else {
            $query = "UPDATE administrator SET `password` = '$sha1_password1' WHERE `username` = '$username';";
            $statement = $db->prepare( $query );
            $result = $statement->execute( );

            $statement = $db->prepare( $query );
            $result = $statement->execute( );
            $result->finalize( );
            $state = WRITE_UPDATE;
        }
    }
    catch (Exception $e) {
        $message = vpnsubscr_get_unexpected_error_message( $e->getMessage( ));
        array_push( $errors, array( 209, $message ));
        return array( 'state' => $state, ERRORS => $errors );
    }

    return array( 'state' => $state, ERRORS => $errors );
}

function vpnsubscr_display_form( $record )
{
    $input_size = 28;
    $input_maxlength = 48;

    $method = $record[METHOD];
    $data = $record[DATA];

    $write_state = WRITE_NONE;

    if ($method == 'POST') {

        $errors = $record[ERRORS];

        if (!$errors) {

            $result = vpnsubscr_write_db( $data );
            $errors = $result[ERRORS];
            $write_state = $result['state'];
        }
    }
    elseif ($method == 'GET') {
        $errors = $record[ERRORS];
    }
    else {
        $errors = array( );
        array_push( $errors, array( 301, "this HTTP method is not supported." ));
    }

    $help_message = "Use this form to modify your login password.";

    if ($method == 'POST' && !$errors) {
        switch ($write_state) {

        case WRITE_UPDATE:
            $help_message = "Your login password has been successfully updated. Please <a href='login.php'>Login</a> using your new password.";
            session_destroy();
            break;

        default:
            break;
        }
    }

    echo <<< EOT
<div class="box-help">
$help_message
</div>

EOT;

    if ($write_state == WRITE_UPDATE) {
        return true;
    }

    vpnsubscr_print_all_errors( $errors );

    echo <<< EOT
<form name="submit-vpnsubscr-form" id="submit-vpn-form" action="/password.php" method="POST">
<center>
<table class='box-form'>

EOT;

    $mandatory = "<font color='firebrick'> *</font>";

    $password = $data[LOGIN_PASSWORD];
    $password1 = $data[LOGIN_PASSWORD2];
    $password2 = $data[LOGIN_PASSWORD2];

    $password_id = LOGIN_PASSWORD;
    $password1_id = LOGIN_PASSWORD1;
    $password2_id = LOGIN_PASSWORD2;

    $password_id_html = "id='$password_id' name='$password_id'";
    $password1_id_html = "id='$password1_id' name='$password1_id'";
    $password2_id_html = "id='$password2_id' name='$password2_id'";

    $col_width = 200;
    $login = $_SESSION['username'];
    $hidden = HIDDEN;

    echo "<tr><td width='$col_width'><strong>Login Username</td><td><strong>$login</strong></td></tr>\n";

    echo "<tr><td>Current Password</td><td>";
    echo "<input maxlength='$input_maxlength' size='$input_size' type='password' value='' $password_id_html />$mandatory\n";
    echo "</td></tr>\n";

    echo "<tr><td>New Password</td><td>";
    echo "<input maxlength='$input_maxlength' size='$input_size' type='password' value='' $password1_id_html />$mandatory\n";
    echo "</td></tr>\n";

    echo "<tr><td>Confirm Password</td><td>";
    echo "<input maxlength='$input_maxlength' size='$input_size' type='password' value='' $password2_id_html />$mandatory\n";
    echo "</td></tr>\n";

    echo "<tr><td></td><td><input class='valid-button' type='submit' value='Validate' /></td></tr>\n";

    echo <<< EOT
</table>
</center>
</form>

EOT;
}

// Main( )

$PFORM = vpnsubscr_get_pform( );

?>
<!DOCTYPE html>
<html>
  <head>
    <title>Login to <?php echo vpnsubscr_get_org_name( ); ?> Login Password Modification</title>

    <link rel="shortcut icon" type="image/x-image" href="/image/favicon.ico" />
    <link rel="stylesheet" type="text/css" href="/chromestyle.css" />
    <link rel="stylesheet" type="text/css" href="/style.css" />

    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="robots" content="noindex, nofollow, noarchive, noarchive, nosnippet, noodp, noydir" />
    <meta name="description" content="This page allows you to modify your password to login to the VPN management application." />

    <script type="text/javascript" src="/js/chrome.js"></script>
    <script type="text/javascript" src="/js/vpnsubscr.js"></script>
    <script type="text/javascript" src="/js/printmenu.js"></script>
    <script type="text/javascript" src="/js/logout.js"></script>
  </head>

  <body>
    <?php vpnsubscr_display_header( ); ?>
    <div class='box-centered-container'>
      <div class='box-centered-nested'>
	<div class='page-title'>Account &gt; Login Password</div>
	<?php vpnsubscr_display_form( $PFORM ); ?>
      </div>
    </div>
    <?php vpnsubscr_display_footer( ); ?>
  </body>
</html>
