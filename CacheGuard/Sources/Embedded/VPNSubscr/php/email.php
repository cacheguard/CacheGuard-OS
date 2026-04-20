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

vpnsubscr_check_login( );

function vpnsubscr_get_input_state( $method, $data )
{
    $errors = array( );

    switch ($method) {

    case 'GET':
        return $errors;
        break;

    case 'POST':
        break;

    default:
        array_push( $errors, array( 301, "this HTTP method is not supported." ));
        return $errors;
        break;
    }

    switch ($data[SERVICE_STATE]) {

    case EMAIL_STATE_MODIFIED:
        return $errors;
        break;

    default:
        break;
    }

    $first_name = $data[FIRST_NAME];
    $last_name = $data[LAST_NAME];
    $email_address = $data[EMAIL_ADDRESS];
    $check_email = $data[CHECK_EMAIL];
    $email_server = $data[SERVER];
    $email_port = $data[PORT];
    $email_account = $data[ACCOUNT];
    $email_password = $data[PASSWORD];
    $service_state = $data[SERVICE_STATE];

    $email_address = strtolower( $email_address );
    $email_server = strtolower( $email_server );
    $email_account = strtolower( $email_account );

    if (preg_match ( '/^[a-zA-Z ]*$/', $first_name ) == 0) {
        array_push( $errors, array( 21, "please use English letters only for the first name." ));
    }

    if (preg_match ( '/^[a-zA-Z ]*$/', $last_name ) == 0) {
        array_push( $errors, array( 23, "please use English letters only for the last name." ));
    }

    switch( $check_email ) {
    case '':
    case 'on':
        break;

    default:
        array_push( $errors, array( 25, "please use the official application form to submit your request." ));
        break;
    }

    if ($email_address == '') {
        array_push( $errors, array( 27, "please specify an email address." ));
    }
    else {
        if ($check_email == 'on') {
            if (!vpnsubscr_is_valid_email( $email_address )) {
                array_push( $errors, array( 29, "please enter a valid and active email address." ));
            }
        }
        else {
            if (!filter_var( $email_address, FILTER_VALIDATE_EMAIL )) {
                array_push( $errors, array( 31, "please enter a valid email address." ));
            }
        }
    }

    if ($email_server != '') {
        if (preg_match ( '/^[a-zA-Z0-9]([a-zA-Z0-9])*(\-([a-zA-Z0-9])+)*([.][a-zA-Z0-9]([a-zA-Z0-9])*(\-([a-zA-Z0-9])+)*)*$/', $email_server ) == 0) {
        array_push( $errors, array( 33, "the provided email server name is not valid." ));
        }
    }

    if ($email_port != '') {
        if (preg_match ( '/(^[1-9][0-9]{0,4}|^0)$/', $email_port ) == 0) {
            array_push( $errors, array( 35, "the provided email server port number is not valid." ));
        }
    }

    if ($email_account != '') {
        if (preg_match ( '/^[a-zA-Z0-9_@.-]+$/', $email_account ) == 0) {
            array_push( $errors, array( 37, "please enter a valid email account username." ));
        }
    }

    return $errors;
}

function vpnsubscr_get_email_data( )
{
    $errors = array( );
    $data = array( );

    $data[FIRST_NAME] = '';
    $data[LAST_NAME] = '';
    $data[EMAIL_ADDRESS] = '';
    $data[SERVER] = '';
    $data[PORT] = '';
    $data[ACCOUNT] = '';
    $data[PASSWORD] = '';
    $data[SERVICE_STATE] = EMAIL_STATE_UNKNOWN;

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
        $query = "SELECT COUNT(*) AS `count` FROM `email` WHERE `id` = '0';";
        $statement = $db->prepare( $query );
        $result = $statement->execute( );

        $row = $result->fetchArray( );
        $count = $row['count'];

        switch ($count) {
        case 0:
            $result->finalize( );
            $data[SERVICE_STATE] = EMAIL_STATE_INEXISTANT;
            return array( ERRORS => $errors,
                          DATA => $data
            );
            break;

        case 1:
            break;

        default:
            $result->finalize( );
            array_push( $errors, array( 13, "the email settings is inconsistent." ));
            return array( ERRORS => $errors,
                          DATA => $data
            );
            break;
        }

        $query = "SELECT * FROM `email` WHERE `id` =  '0';";
        $statement = $db->prepare( $query );
        $result = $statement->execute( );
        $row = $result->fetchArray( );

        $data[FIRST_NAME] = $row[FIRST_NAME];
        $data[LAST_NAME] = $row[LAST_NAME];
        $data[EMAIL_ADDRESS] = $row[EMAIL_ADDRESS];
        $data[SERVER] = $row[SERVER];
        $data[PORT] = $row[PORT];
        $data[ACCOUNT] = $row[ACCOUNT];
        $data[PASSWORD] = base64_decode( $row[PASSWORD] );
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

function vpnsubscr_get_email( )
{
    $email = vpnsubscr_get_email_data( );

    $method = isset( $_SERVER['REQUEST_METHOD']  ) ? $_SERVER['REQUEST_METHOD']  : '';
    $method = filter_var( $method, FILTER_SANITIZE_FULL_SPECIAL_CHARS );

    switch ($method) {

    case 'GET':
        $errors = $email[ERRORS];
        $data = $email[DATA];
        if ($data[PORT] == '') $data[PORT] = DEFAULT_EMAIL_PORT;
        $data[CHECK_EMAIL] = '';
        break;

    case 'POST':
        $data[FIRST_NAME] = isset( $_POST[FIRST_NAME] ) ? $_POST[FIRST_NAME] : '';
        $data[LAST_NAME] = isset( $_POST[LAST_NAME] ) ? $_POST[LAST_NAME] : '';
        $data[EMAIL_ADDRESS] = isset( $_POST[EMAIL_ADDRESS] ) ? $_POST[EMAIL_ADDRESS] : '';
        $data[CHECK_EMAIL] = isset( $_POST[CHECK_EMAIL] ) ? $_POST[CHECK_EMAIL] : '';
        $data[SERVER] = isset( $_POST[SERVER] ) ? $_POST[SERVER] : '';
        $data[PORT] = isset( $_POST[PORT] ) ? $_POST[PORT] : DEFAULT_PORT;
        $data[ACCOUNT] = isset( $_POST[ACCOUNT] ) ? $_POST[ACCOUNT] : '';
        $data[PASSWORD] = isset( $_POST[PASSWORD] ) ? $_POST[PASSWORD] : '';

        foreach ($data as $key => $value) {
            $data[$key] = filter_var( $value, FILTER_SANITIZE_FULL_SPECIAL_CHARS );
        }

        $data[SERVICE_STATE] = $email[DATA][SERVICE_STATE];

        $errors = vpnsubscr_get_input_state( $method, $data );
        break;

    default:
        $method = 'NONE';
        break;
    }

    return array(
        METHOD => $method,
        ERRORS => $errors,
        DATA => $data
    );
}

function vpnsubscr_submit_setup( $data )
{
    $errors = array( );
    $service = EMAIL_STATE_UNKNOWN;

    $db_record = vpnsubscr_db_connect( SQLITE3_OPEN_READWRITE );
    $error = $db_record['error'];
    $message = $db_record['message'];
    $db = $db_record['link'];

    if ($error != 0) {
        array_push( $errors, array( $error, $message ));
        return array( SERVICE_STATE => $service, ERRORS => $errors );
    }

    $first_name = $data[FIRST_NAME];
    $last_name = $data[LAST_NAME];
    $email_address = $data[EMAIL_ADDRESS];
    $email_server = $data[SERVER];
    $email_port = $data[PORT];
    $email_account = $data[ACCOUNT];
    $email_password = $data[PASSWORD];
    $service = $data[SERVICE_STATE];

    $encoded_password = base64_encode( $email_password );

    $service = EMAIL_STATE_MODIFIED;
    $query = "UPDATE `email` SET `first_name` = '$first_name', `last_name` = '$last_name', `email_address` = '$email_address', `server` = '$email_server', `port` = '$email_port', `account` = '$email_account', `password` = '$encoded_password', `service` = '$service' WHERE `id` = '0';";

    try {
        $statement = $db->prepare( $query );
        $result = $statement->execute( );
        $result->finalize( );
        
    }
    catch (Exception $e) {
        $message = vpnsubscr_get_unexpected_error_message( $e->getMessage( ));
        array_push( $errors, array( 101, $message ));
        return array( SERVICE_STATE => $service, ERRORS => $errors );
    }

    return array( SERVICE_STATE => $service, ERRORS => $errors );
}

function vpnsubscr_display_title( )
{
    $refresh_title = 'Refresh';
    $refresh_icon = " <a href='email.php'><img src='/image/refresh.png' title='$refresh_title' alt='$refresh_title' /></a>";

    echo "Email Settings $refresh_icon";
}

function vpnsubscr_display_email_help( $service_state )
{
    switch ($service_state) {

    case EMAIL_STATE_INEXISTANT:
    case EMAIL_STATE_FAILED:
    case EMAIL_STATE_ACTIVATED:

        $message = "Fill out the form below to configure your email settings. Setting an email account allows the application to automatically send VPN profiles (or scripts) to subscribers.";
        break;

    case EMAIL_STATE_MODIFIED:
        $message = "An email settings request is in progress. Please wait for its termination before any further requests.";
        break;

    default:
        $message = '';
        break;
    }

    echo "<div class='box-help'>$message</div>";
}

function vpnsubscr_display_form( $email )
{
    $input_size = 28;
    $input_maxlength = 64;
    $select_width = '306px';

    $method = $email[METHOD];
    $errors = $email[ERRORS];
    $data = $email[DATA];

    if ($method == 'POST' and !$errors) {
        $result = vpnsubscr_submit_setup( $data );
        $errors = $result[ERRORS];
        $data[SERVICE_STATE] = $result[SERVICE_STATE];
    }

    $first_name = $data[FIRST_NAME];
    $last_name = $data[LAST_NAME];
    $email_address = $data[EMAIL_ADDRESS];
    $check_email = $data[CHECK_EMAIL];
    $email_server = $data[SERVER];
    $email_port = $data[PORT];
    $email_account = $data[ACCOUNT];
    $email_password = $data[PASSWORD];
    $service_state = $data[SERVICE_STATE];

    $first_name_id = FIRST_NAME;
    $last_name_id = LAST_NAME;
    $email_address_id = EMAIL_ADDRESS;
    $check_email_id = CHECK_EMAIL;
    $email_server_id = SERVER;
    $email_port_id = PORT;
    $email_account_id = ACCOUNT;
    $email_password_id = PASSWORD;

    $first_name_id_html = "id='$first_name_id' name='$first_name_id'";
    $last_name_id_html = "id='$last_name_id' name='$last_name_id'";
    $email_address_id_html = "id='$email_address_id' name='$email_address_id'";
    $check_email_id_html = "id='$check_email_id' name='$check_email_id'";
    $email_server_id_html = "id='$email_server_id' name='$email_server_id'";
    $email_port_id_html = "id='$email_port_id' name='$email_port_id'";
    $email_account_id_html = "id='$email_account_id' name='$email_account_id'";
    $email_password_id_html = "id='$email_password_id' name='$email_password_id'";

    $mandatory = "<font color='firebrick'> *</font>";

    vpnsubscr_display_email_help( $service_state );
    echo "<form name='submit-vpnsubscr-form' id='submit-vpnsubscr-form' action='/email.php' method='POST'>\n";
    vpnsubscr_print_all_errors( $errors );

    echo "<center>\n";
    echo "<table class='box-form'>\n";

    echo "<tr class='separator'><td><strong>Administrator Details</strong></td><td></td></tr>\n";

    echo "<tr><td>First Name</td><td>";
    switch ($service_state) {
    case EMAIL_STATE_MODIFIED:
        $visible_first_name = empty( $first_name ) ? NOT_SET : $first_name;
        echo "$visible_first_name";
        break;
    default:
        if ($method == 'GET' or $errors) {
            echo "<input maxlength='$input_maxlength' size='$input_size' value='$first_name' $first_name_id_html />\n";
        }
        elseif ($method == "POST") {
            echo "<input type='hidden' value='$first_name' $first_name_id_html />$first_name\n";
        }
        break;
    }
    echo "</td></tr>\n";

    echo "<tr><td>Last Name</td><td>";
    switch ($service_state) {
    case EMAIL_STATE_MODIFIED:
        $visible_last_name = empty( $last_name ) ? NOT_SET : $last_name;
        echo "$visible_last_name";
        break;
    default:
        if ($method == 'GET' or $errors) {
            echo "<input maxlength='$input_maxlength' size='$input_size' value='$last_name' $last_name_id_html />\n";
        }
        elseif ($method == "POST") {
            echo "<input type='hidden' value='$last_name' $last_name_id_html />$last_name\n";
        }
        break;
    }
    echo "</td></tr>\n";

    echo "<tr><td>Email Address</td><td>";
    switch ($service_state) {
    case EMAIL_STATE_MODIFIED:
        echo "$email_address";
        break;
    default:
        if ($method == 'GET' or $errors) {
            echo "<input maxlength='$input_maxlength' size='$input_size' value='$email_address' $email_address_id_html />$mandatory\n";
        }
        elseif ($method == "POST") {
            $visible_email_address = empty( $email_address ) ? NOT_SET : $email_address;
            echo "<input type='hidden' value='$email_address' $email_address_id_html />$visible_email_address\n";
        }
        break;
    }
    echo "</td></tr>\n";

    switch ($service_state) {
    case EMAIL_STATE_MODIFIED:
        break;
    default:
        if ($method == 'GET' or $errors) {
            $checked = ($check_email == 'on') ? ' checked' : '';
            echo "<tr><td><label for='$check_email_id'>Check Email Address</label></td>";
            echo "<td>";
            echo "<input$checked type='checkbox' $check_email_id_html />";
            echo "</td></tr>\n";
        }
        break;
    }

    echo "<tr class='separator'><td><strong>Email Server Settings</strong></td><td></td></tr>\n";

    echo "<tr><td>Email State</td><td>";

    switch ($service_state) {

    case EMAIL_STATE_INEXISTANT:
        $title = 'Incomplete Settings';
        $icon = 'unknown.png';
        $log = false;
        break;

    case EMAIL_STATE_MODIFIED:
        $icon = 'working.gif';
        $title = 'Email Settings Ongoing';
        $log = false;
        break;

    case EMAIL_STATE_FAILED:
        $icon = 'ko.png';
        $title = 'Faulty Email Settings';
        $log = true;
        break;

    default:
        $icon = 'ok.png';
        $title = 'Setup Done';
        $log = false;
        break;
    }
    if ($log) {
        echo "<a href='report.php'><img src='/image/$icon' title='$title' alt='$title' /></a>";
    }
    else {
        echo "<img src='/image/$icon' title='$title' alt='$title' />";
    }
    echo "</td></tr>\n";

    echo "<tr><td>Server Name</td><td>";
    switch ($service_state) {
    case EMAIL_STATE_MODIFIED:
        $visible_email_server = empty( $email_server ) ? NOT_SET : $email_server;
        echo "$visible_email_server";
        break;
    default:
        if ($method == 'GET' or $errors) {
            echo "<input maxlength='$input_maxlength' size='$input_size' value='$email_server' $email_server_id_html />\n";
        }
        elseif ($method == "POST") {
            echo "<input type='hidden' value='$email_server' $email_server_id_html />$email_server\n";
        }
        break;
    }
    echo "</td></tr>\n";

    echo "<tr><td>Server Port</td><td>";
    switch ($service_state) {
    case EMAIL_STATE_MODIFIED:
        echo "$email_port";
        break;
    default:
        if ($method == 'GET' or $errors) {
            echo "<input maxlength='5' size='5' value='$email_port' $email_port_id_html />\n";
        }
        elseif ($method == "POST") {
            echo "<input type='hidden' value='$email_port' $email_port_id_html />$email_port\n";
        }
        break;
    }
    echo "</td></tr>\n";

    echo "<tr><td>Account Username</td><td>";
    switch ($service_state) {
    case EMAIL_STATE_MODIFIED:
        $visible_email_account = empty( $email_account ) ? NOT_SET : $email_account;
        echo "$visible_email_account";
        break;
    default:
        if ($method == 'GET' or $errors) {
            echo "<input maxlength='$input_maxlength' size='$input_size' value='$email_account' $email_account_id_html />\n";
        }
        elseif ($method == "POST") {
            echo "<input type='hidden' value='$email_account' $email_account_id_html />$email_account\n";
        }
        break;
    }
    echo "</td></tr>\n";

    echo "<tr><td>Account Password</td><td>";

    $hidden = HIDDEN;

    switch ($service_state) {
    case EMAIL_STATE_MODIFIED:
        echo "$hidden";
        break;
    default:
        if ($method == 'GET' or $errors) {
            echo "<input maxlength='$input_maxlength' size='$input_size' value='$email_password' type='password' $email_password_id_html />";
        }
        elseif ($method == "POST") {
            echo "<input type='hidden' value='$email_password' $email_password_id_html />$hidden";
        }
        break;
    }
    echo "</td></tr>\n";

    switch ($service_state) {
    case EMAIL_STATE_MODIFIED:
        break;

    default:
        echo "<tr><td></td><td><input class='valid-button' type='submit' value='Validate' /></td></tr>\n";
        break;
    }

    echo <<< EOT
</table>
</center>

EOT;
    switch ($service_state) {
    case EMAIL_STATE_MODIFIED:
        break;

    default:
        echo "</form>\n";
    }
}

// Main( )

$EMAIL = vpnsubscr_get_email( );

?>
<!DOCTYPE html>
<html>
  <head>
    <title><?php echo vpnsubscr_get_org_name( ); ?> Email Settings</title>

    <link rel="shortcut icon" type="image/x-image" href="/favicon.ico" />
    <link rel="stylesheet" type="text/css" href="/chromestyle.css" />
    <link rel="stylesheet" type="text/css" href="/style.css" />

    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="robots" content="noindex, nofollow, noarchive, noarchive, nosnippet, noodp, noydir" />
    <meta name="description" content="This page allows you to manage VPN subscribers." />

    <script type="text/javascript" src="/js/chrome.js"></script>
    <script type="text/javascript" src="/js/vpnsubscr.js"></script>
    <script type="text/javascript" src="/js/printmenu.js"></script>
    <script type="text/javascript" src="/js/logout.js"></script>
  </head>

  <body>
    <?php vpnsubscr_display_header( ); ?>
    <div class='box-centered-container'>
      <div class='box-centered-nested'>
	<div class='page-title'>Setup &gt; <?php vpnsubscr_display_title( ); ?></div>
	<?php vpnsubscr_display_form( $EMAIL ); ?>
      </div>
    </div>
    <?php vpnsubscr_display_footer( ); ?>
  </body>
</html>
