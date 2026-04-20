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
vpnsubscr_check_service( );

function vpnsubscr_get_inputs( )
{
    $method = isset( $_SERVER['REQUEST_METHOD']  ) ? $_SERVER['REQUEST_METHOD']  : '';
    $method = filter_var( $method, FILTER_SANITIZE_FULL_SPECIAL_CHARS );

    switch ($method) {
    case 'GET':
        $operation = isset( $_GET[OPERATION] ) ? $_GET[OPERATION] : OPERATION_NEW;
        $username = isset( $_GET[USERNAME] ) ? $_GET[USERNAME] : '';
        $first_name = '';
        $last_name = '';
        $email_address = '';
        $phone = '';
        $device = DEVICE_ANDROID;
        $create_date = 0;
        $alive_date = 0;
        $tls_password = '';
        $operation_status = SUCCESSFUL_OPERATION;
        $service = SUBSCRIBER_STATE_UNKNOWN;
        $requested_status = STATUS_NONE;

        $confirm_cancel = '';
        $check_email = '';
        break;

    case 'POST':
        $operation = isset( $_POST[OPERATION] ) ? $_POST[OPERATION] : OPERATION_NEW;
        $username = isset( $_POST[USERNAME] ) ? $_POST[USERNAME] : '';
        $first_name = isset( $_POST[FIRST_NAME] ) ? $_POST[FIRST_NAME] : '';
        $last_name = isset( $_POST[LAST_NAME] ) ? $_POST[LAST_NAME] : '';
        $email_address = isset( $_POST[EMAIL_ADDRESS] ) ? $_POST[EMAIL_ADDRESS] : '';
        $phone = isset( $_POST[PHONE] ) ? $_POST[PHONE] : '';
        $device = isset( $_POST[DEVICE] ) ? $_POST[DEVICE] : '';
        $create_date = isset( $_POST[CREATE_DATE] ) ? $_POST[CREATE_DATE] : 0;
        $alive_date = isset( $_POST[ALIVE_DATE] ) ? $_POST[ALIVE_DATE] : 0;
        $tls_password = isset( $_POST[TLS_PASSWORD] ) ? $_POST[TLS_PASSWORD] : '';
        $operation_status = isset( $_POST[OPERATION_STATUS] ) ? $_POST[OPERATION_STATUS] : SUCCESSFUL_OPERATION;
        $service = isset( $_POST[SERVICE] ) ? $_POST[SERVICE] : SUBSCRIBER_STATE_UNKNOWN;
        $requested_status = isset( $_POST[REQUESTED_STATUS] ) ? $_POST[REQUESTED_STATUS] : STATUS_NONE;

        $confirm_cancel = isset( $_POST[CONFIRM_CANCEL] ) ? $_POST[CONFIRM_CANCEL] : '';
        $check_email = isset( $_POST[CHECK_EMAIL] ) ? $_POST[CHECK_EMAIL] : '';
        break;
        
    default:
        $operation = OPERATION_NEW;
        $username = '';
        $first_name = '';
        $last_name = '';
        $email_address = '';
        $phone = '';
        $device = DEVICE_ANDROID;
        $create_date = 0;
        $alive_date = 0;
        $tls_password = '';
        $operation_status = SUCCESSFUL_OPERATION;
        $service = SUBSCRIBER_STATE_UNKNOWN;
        $requested_status = STATUS_NONE;

        $confirm_cancel = '';
        $check_email = '';
        
        $method = 'NONE';
        break;
    }

    $operation = filter_var( $operation, FILTER_SANITIZE_FULL_SPECIAL_CHARS );
    $username = filter_var( $username, FILTER_SANITIZE_FULL_SPECIAL_CHARS );
    $first_name = filter_var( $first_name, FILTER_SANITIZE_FULL_SPECIAL_CHARS );
    $last_name = filter_var( $last_name, FILTER_SANITIZE_FULL_SPECIAL_CHARS );
    $email_address = filter_var( $email_address, FILTER_SANITIZE_FULL_SPECIAL_CHARS );
    $phone = filter_var( $phone, FILTER_SANITIZE_FULL_SPECIAL_CHARS );
    $device = filter_var( $device, FILTER_SANITIZE_FULL_SPECIAL_CHARS );
    $create_date = filter_var( $create_date, FILTER_SANITIZE_FULL_SPECIAL_CHARS );
    $alive_date = filter_var( $alive_date, FILTER_SANITIZE_FULL_SPECIAL_CHARS );
    $tls_password = filter_var( $tls_password, FILTER_SANITIZE_FULL_SPECIAL_CHARS );
    $operation_status = filter_var( $operation_status, FILTER_SANITIZE_FULL_SPECIAL_CHARS );
    $service = filter_var( $service, FILTER_SANITIZE_FULL_SPECIAL_CHARS );
    $requested_status = filter_var( $requested_status, FILTER_SANITIZE_FULL_SPECIAL_CHARS );

    $confirm_cancel = filter_var( $confirm_cancel, FILTER_SANITIZE_FULL_SPECIAL_CHARS );
    $check_email = filter_var( $check_email, FILTER_SANITIZE_FULL_SPECIAL_CHARS );

    $operation = vpnsubscr_remove_whitespaces( $operation );
    $username = vpnsubscr_remove_whitespaces( $username );
    $first_name = vpnsubscr_remove_useless_whitespaces( $first_name );
    $last_name = vpnsubscr_remove_useless_whitespaces( $last_name );
    $email_address = vpnsubscr_remove_whitespaces( $email_address );
    $phone = vpnsubscr_remove_useless_whitespaces( $phone );

    if ($device == '') $device = DEVICE_ANDROID;

    $controls = array(
        METHOD => $method,
        OPERATION => $operation,
        REQUESTED_STATUS => $requested_status,
        CONFIRM_CANCEL => $confirm_cancel,
        CHECK_EMAIL => $check_email
    );

    $data = array(
        USERNAME => $username,
        FIRST_NAME => $first_name,
        LAST_NAME => $last_name,
        EMAIL_ADDRESS => $email_address,
        PHONE => $phone,
        DEVICE => $device,
        CREATE_DATE => $create_date,
        ALIVE_DATE => $alive_date,
        TLS_PASSWORD => $tls_password,
        OPERATION_STATUS => $operation_status,
        SERVICE => $service
    );

    return array( CONTROLS => $controls,
                  DATA => $data
    );
}

function vpnsubscr_get_input_state( $controls, $data )
{
    $errors = array( );

    $operation = $controls[OPERATION];
    $requested_status = $controls[REQUESTED_STATUS];
    $confirm_cancel = $controls[CONFIRM_CANCEL];
    $check_email = $controls[CHECK_EMAIL];

    $username = $data[USERNAME];
    $first_name = $data[FIRST_NAME];
    $last_name = $data[LAST_NAME];
    $email_address = $data[EMAIL_ADDRESS];
    $phone = $data[PHONE];
    $device = $data[DEVICE];
    $create_date = $data[CREATE_DATE];
    $alive_date = $data[ALIVE_DATE];
    $tls_password = $data[TLS_PASSWORD];
    $operation_status = $data[OPERATION_STATUS];
    $service = $data[SERVICE];

    $username= strtolower( $username );
    $first_name = ucfirst( strtolower( $first_name ));
    $last_name = ucfirst( strtolower( $last_name ));
    $email_address= strtolower( $email_address );

    switch ($operation) {
    case OPERATION_NEW:
    case OPERATION_EDIT:
        break;

    default:
        array_push( $errors, array( 21, "this is not a valid edition mode." ));
        break;
    }

    if ($username == '') {
        array_push( $errors, array( 23, "please specify a username." ));
    }
    elseif (preg_match ( '/^[a-zA-Z0-9-_]+$/', $username ) == 0) {
        array_push( $errors, array( 25, "please use alphanumeric characters for the username. The dash and underscore characters are also accpeted." ));
    }

    if (preg_match ( '/^[a-zA-Z -]*$/', $first_name ) == 0) {
        array_push( $errors, array( 27, "please use English letters only for the first name." ));
    }

    if (preg_match ( '/^[a-zA-Z -]*$/', $last_name ) == 0) {
        array_push( $errors, array( 29, "please use English letters only for the last name." ));
    }

    switch( $check_email ) {
    case '':
    case 'on':
        break;

    default:
        array_push( $errors, array( 31, "please use the official application form to submit your request." ));
        break;
    }

    if ($email_address == '') {
        array_push( $errors, array( 33, "please specify an email address." ));
    }
    else {
        if ($check_email == 'on') {
            if (!vpnsubscr_is_valid_email( $email_address )) {
                array_push( $errors, array( 35, "Please enter a valid and active email address." ));
            }
        }
        else {
            if (!filter_var( $email_address, FILTER_VALIDATE_EMAIL )) {
                array_push( $errors, array( 37, "Please enter a valid email address." ));
            }
        }
    }

    if ($phone == '') {
        array_push( $errors, array( 39, "please specify a mobile phone number." ));
    }
    elseif (preg_match ( '/^\+[0-9 ]+$/', $phone ) == 0) {
        array_push( $errors, array( 41, "please use an international format (begining with +<country code> and made up of digits and spaces) for the mobile phone number." ));
    }

    switch( $device ) {
    case DEVICE_ANDROID:
    case DEVICE_APPLE:
    case DEVICE_LINUX:
    case DEVICE_WINDOWS:
        break;

    default:
        array_push( $errors, array( 43, "please use the official application form to submit your request." ));
        break;
    }

    if (preg_match ( '/[0-9 ]+$/', $create_date ) == 0) {
        array_push( $errors, array( 45, "please use the official application form to submit your request." ));
    }

    if (preg_match ( '/[0-9 ]+$/', $alive_date ) == 0) {
        array_push( $errors, array( 47, "please use the official application form to submit your request." ));
    }

    switch( $service ) {
    case SUBSCRIBER_STATE_INACTIVE:
    case SUBSCRIBER_STATE_ACTIVATED:
    case SUBSCRIBER_STATE_2REACTIVATE:
    case SUBSCRIBER_STATE_RESET:
    case SUBSCRIBER_STATE_2SUSPEND:
    case SUBSCRIBER_STATE_SUSPENDED:
    case SUBSCRIBER_STATE_2CANCEL:
    case SUBSCRIBER_STATE_CANCELLED:
    case SUBSCRIBER_STATE_UNKNOWN:
        break;

    default:
        array_push( $errors, array( 49, "please use the official application form to submit your request." ));
        break;
    }

    switch( $requested_status ) {
    case STATUS_NONE:
    case STATUS_SUSPEND:
    case STATUS_CANCEL:
    case STATUS_ACTIVATE:
        break;

    default:
        array_push( $errors, array( 51, "please use the official application form to submit your request." ));
        break;
    }

    switch( $confirm_cancel ) {
    case '':
    case 'on':
        break;

    default:
        array_push( $errors, array( 53, "please use the official application form to submit your request." ));
        break;
    }

    if ($requested_status == STATUS_CANCEL and $confirm_cancel != 'on') {
        array_push( $errors, array( 91, "please confirm the cancellation by checking the <u>Confirm Cancellation</u> checkbox." ));
    }

    return $errors;
}

function vpnsubscr_get_subscriber_data( $data )
{
    $errors = array( );
    $username = $data[USERNAME];

    $db_record = vpnsubscr_db_connect( SQLITE3_OPEN_READWRITE );
    $error = $db_record['error'];
    $db = $db_record['link'];

    if ($error != 0) {
        $message = $db_record['message'];
        array_push( $errors, array( $error, $db_record['message'] ));
        return array( ERRORS => $errors, DATA => $data );
    }

    try {
        $query = "SELECT `username`, `email_address`, `first_name`, `last_name`, `phone`, `device`, `create_date`, `alive_date`, `tls_password`, `operation_status`, `service` FROM `subscriber` WHERE `username` = '$username';";
        $statement = $db->prepare( $query );
        $result = $statement->execute( );

        if ($row = $result->fetchArray( )) {
            $data[USERNAME] = $username;
            $data[FIRST_NAME] = $row[FIRST_NAME];
            $data[LAST_NAME] = $row[LAST_NAME];
            $data[EMAIL_ADDRESS] = $row[EMAIL_ADDRESS];
            $data[PHONE] = $row[PHONE];
            $data[DEVICE] = $row[DEVICE];
            $data[CREATE_DATE] = $row[CREATE_DATE];
            $data[ALIVE_DATE] = $row[ALIVE_DATE];
            $data[TLS_PASSWORD] = $row[TLS_PASSWORD];
            $data[OPERATION_STATUS] = $row[OPERATION_STATUS];
            $data[SERVICE] = $row[SERVICE];
        }
        else {
            array_push( $errors, array( 101, "this username does not exist." ));
        }
        $result->finalize( );
    }
    catch (Exception $e) {
        $message = vpnsubscr_get_unexpected_error_message( $e->getMessage( ) );
        array_push( $errors, array( 103, $message ));
    }

    return array( ERRORS => $errors, DATA => $data );
}

function vpnsubscr_get_subscriber( )
{
    $input = vpnsubscr_get_inputs( );
    $data = $input[DATA];
    $controls = $input[CONTROLS];

    $method = $controls[METHOD];
    $operation = $controls[OPERATION];

    $username = $data[USERNAME];

    switch ($method) {
    case 'GET':
    if ($operation == OPERATION_EDIT) {    
        $subscriber = vpnsubscr_get_subscriber_data( $data );

        $errors = $subscriber[ERRORS];
        $data = $subscriber[DATA];

        $controls = array(
            METHOD => 'GET',
            OPERATION => OPERATION_EDIT,
            REQUESTED_STATUS => STATUS_NONE,
            CONFIRM_CANCEL => '',
            CHECK_EMAIL => ''
        );
    }
    else {
        $errors = array( );
    }
    break;

    case 'POST':
        $errors = vpnsubscr_get_input_state( $controls, $data );
        break;

    default:
        $errors = array( );
        break;
    }
    
    return array( ERRORS => $errors,
                  CONTROLS => $controls,
                  DATA => $data
    );
}

function vpnsubscr_get_allowed_new_service( $requested_status, $service )
{
    $new_service = NULL;

    switch ($requested_status) {

    case STATUS_NONE:
        break;

    case STATUS_SUSPEND:
        if ($service == SUBSCRIBER_STATE_ACTIVATED) {
            $new_service = SUBSCRIBER_STATE_2SUSPEND;
        }
        break;

    case STATUS_ACTIVATE:
        if ($service == SUBSCRIBER_STATE_SUSPENDED) {
            $new_service = SUBSCRIBER_STATE_2REACTIVATE;
        }
        break;

    case STATUS_CANCEL:
        if ($service == SUBSCRIBER_STATE_ACTIVATED or $service == SUBSCRIBER_STATE_SUSPENDED) {
            $new_service = SUBSCRIBER_STATE_2CANCEL;
        }
        break;

    default:
        break;
    }

    return $new_service;
}

function vpnsubscr_subscriber_write_db( $controls, $data )
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

    $operation = $controls[OPERATION];
    $requested_status = $controls[REQUESTED_STATUS];

    $username = $data[USERNAME];
    $email_address = $data[EMAIL_ADDRESS];
    $first_name = $data[FIRST_NAME];
    $last_name = $data[LAST_NAME];
    $phone = $data[PHONE];
    $device = $data[DEVICE];

    try {
        $query = "SELECT COUNT(*) AS `count` FROM `subscriber` WHERE `username` = '$username';";
        $statement = $db->prepare( $query );
        $result = $statement->execute( );

        $row = $result->fetchArray( );
        $count = $row['count'];

        if ($count == 1) {
            if ($operation == OPERATION_NEW) {
                $message = "this username already exists. Please enter another username.";
                array_push( $errors, array( 201, $message ));
            }
            else {
                
                $service = $data[SERVICE];
                $new_service = vpnsubscr_get_allowed_new_service( $requested_status, $service );

                if (! is_null( $new_service )) {
                    $new_service = ", `service` = '$new_service'";
                }

                $query = "UPDATE `subscriber` SET `email_address` = '$email_address', `first_name` = '$first_name', `last_name` = '$last_name', `phone` = '$phone'$new_service WHERE `username` = '$username';";

                $statement = $db->prepare( $query );
                $result = $statement->execute( );
                $result->finalize( );
                $state = WRITE_UPDATE;
            }
        }
        else {
            $query = "SELECT COUNT(*) AS `count` FROM `subscriber`";
            $statement = $db->prepare( $query );
            $result = $statement->execute( );

            $count = 0;
            $row = $result->fetchArray( );
            $count = $row['count'];

            if ($count == (CANCELLED_FACTOR * MAX_SUBSCRIBERS)) {
                $message = "the DB maximum capacity has been reached.";
                array_push( $errors, array( 203, $message ));
                return array( 'state' => $state, ERRORS => $errors );
            }

            $cancelled = SUBSCRIBER_STATE_CANCELLED;
            $query = "SELECT COUNT(*) AS `count` FROM `subscriber` WHERE `service` <> $cancelled;";
            $statement = $db->prepare( $query );
            $result = $statement->execute( );

            $count = 0;
            $row = $result->fetchArray( );
            $count = $row['count'];

            if ($count == MAX_SUBSCRIBERS) {
                $message = "the maximum number of subscriber has been reached. To create new subscribers you are invited to reset your service.";
                array_push( $errors, array( 205, $message ));
                return array( 'state' => $state, ERRORS => $errors );
            }

            $time = time( );
            $row = "'$username', '$email_address', '$email_address', '$first_name', '$last_name', '$phone', '$device', '$time'";

            $query = "INSERT INTO `subscriber` (`username`, `email_address`, `previous_email_address`, `first_name`, `last_name`, `phone`, `device`, `create_date`) VALUES ($row);";

            $statement = $db->prepare( $query );
            $result = $statement->execute( );
            $result->finalize( );
            $state = WRITE_INSERT;
        }
    }
    catch (Exception $e) {
        $message = vpnsubscr_get_unexpected_error_message( $e->getMessage( ));
        array_push( $errors, array( 209, $message ));
        return array( 'state' => $state, ERRORS => $errors );
    }

    return array( 'state' => $state, ERRORS => $errors );
}

function vpnsubscr_print_device_options( $selected_device = NULL )
{
    $devices = vpnsubscr_get_devices( );
    $length = count( $devices );
    
    for ($i=0 ; $i < $length ; $i++) {
        $display = $devices[$i];

        if ($i == $selected_device) {
            $selected_html = " selected";
        }
        else {
            $selected_html = '';
        }
        echo "  <option id='device_$i' name='device_$i' value='$i'$selected_html>$display</option>\n";
    }
}

function vpnsubscr_print_status_options( $service, $selected_status )
{
    $requested_status[STATUS_NONE] = '';
    $requested_status[STATUS_SUSPEND] = "Suspend";
    $requested_status[STATUS_ACTIVATE] = "Reactivate";
    $requested_status[STATUS_CANCEL] = "Cancel";

    switch ($service) {

    case SUBSCRIBER_STATE_ACTIVATED:
    case SUBSCRIBER_STATE_2REACTIVATE:
        $options = array( STATUS_NONE, STATUS_SUSPEND, STATUS_CANCEL );
        break;

    case SUBSCRIBER_STATE_2SUSPEND:
    case SUBSCRIBER_STATE_SUSPENDED:
        $options = array( STATUS_NONE, STATUS_ACTIVATE, STATUS_CANCEL );
        break;

    case SUBSCRIBER_STATE_2CANCEL:
        $options = array( STATUS_NONE, STATUS_ACTIVATE, STATUS_SUSPEND );
        break;

    default:
        $options = array( );
        break;
    }

    foreach ($options as $option) {
        $title = $requested_status[$option];
        if ($option == $selected_status) {
            $selected_html = " selected";
        }
        else {
            $selected_html = '';
        }
        echo "  <option id='status_$option' name='status_$option' value='$option'$selected_html>$title</option>\n";
    }
}

function vpnsubscr_display_form( $subscriber )
{
    $input_size = 28;
    $input_maxlength = 64;
    $select_width = '140px';
    $width = '140px';

    $data = $subscriber[DATA];
    $controls = $subscriber[CONTROLS];
    $method = $controls[METHOD];

    if ($method == 'POST') {

        $errors = $subscriber[ERRORS];

        if (!$errors) {

            $result = vpnsubscr_subscriber_write_db( $controls, $data );
            $errors = $result[ERRORS];
            $write_state = $result['state'];

            if (!$errors) {
                $subscriber = vpnsubscr_get_subscriber_data( $data );

                $errors = $subscriber[ERRORS];
                $data = $subscriber[DATA];
                $controls[OPERATION] = OPERATION_EDIT;
            }
        }
    }
    elseif ($method == 'GET') {
        $errors = $subscriber[ERRORS];
    }
    else {
        $errors = array( );
        array_push( $errors, array( 301, "this HTTP method is not supported." ));
    }

    $operation = $controls[OPERATION];
    $requested_status = $controls[REQUESTED_STATUS];
    $confirm_cancel = $controls[CONFIRM_CANCEL];
    $check_email = $controls[CHECK_EMAIL];

    $username = $data[USERNAME];
    $first_name = $data[FIRST_NAME];
    $last_name = $data[LAST_NAME];
    $email_address = $data[EMAIL_ADDRESS];
    $phone = $data[PHONE];
    $device = $data[DEVICE];
    $create_date = $data[CREATE_DATE];
    $alive_date = $data[ALIVE_DATE];
    $tls_password = $data[TLS_PASSWORD];
    $operation_status = $data[OPERATION_STATUS];
    $service = $data[SERVICE];

    $operation_id = OPERATION;
    $requested_status_id = REQUESTED_STATUS;
    $confirm_cancel_id = CONFIRM_CANCEL;
    $check_email_id = CHECK_EMAIL;

    $username_id = USERNAME;
    $first_name_id = FIRST_NAME;
    $last_name_id = LAST_NAME;
    $email_address_id = EMAIL_ADDRESS;
    $phone_id = PHONE;
    $device_id = DEVICE;
    $create_date_id = CREATE_DATE;
    $alive_date_id = ALIVE_DATE;
    $tls_password_id = TLS_PASSWORD;
    $operation_status_id = OPERATION_STATUS;
    $service_id = SERVICE;

    $operation_id_html = "id='$operation_id' name='$operation_id'";
    $requested_status_id_html = "id='$requested_status_id' name='$requested_status_id'";
    $confirm_cancel_id_html = "id='$confirm_cancel_id' name='$confirm_cancel_id'";
    $check_email_id_html = "id='$check_email_id' name='$check_email_id'";

    $username_id_html = "id='$username_id' name='$username_id'";
    $first_name_id_html = "id='$first_name_id' name='$first_name_id'";
    $last_name_id_html = "id='$last_name_id' name='$last_name_id'";
    $email_address_id_html = "id='$email_address_id' name='$email_address_id'";
    $phone_id_html = "id='$phone_id' name='$phone_id'";
    $device_id_html = "id='$device_id' name='$device_id'";
    $create_date_id_html = "id='$create_date_id' name='$create_date_id'";
    $alive_date_id_html = "id='$alive_date_id' name='$alive_date_id'";
    $tls_password_id_html = "id='$tls_password_id' name='$tls_password_id'";
    $operation_status_id_html = "id='$operation_status_id' name='$operation_status_id'";
    $service_id_html = "id='$service_id' name='$service_id'";

    $mandatory = "<font color='firebrick'> *</font>";
    $new_button = "<div class='box-shortcut'><a href='subscriber.php'><input class='valid-button' type='submit' value='New' /></a></div>";
    $new = '';

    if ($method == 'POST' && !$errors) {
        switch ($write_state) {

        case WRITE_UPDATE:
            $help_message = "The subscriber account has been successfully updated.";
            $new = $new_button;
            break;

        case WRITE_INSERT:
            $help_message = "The subscriber account creation has been successfully requested. Please wait for its activation and then WhatsApp its associated user certificate password.";
            $new = $new_button;
            break;

        default:
            break;
        }
    }
    else {
        switch ($operation) {
        case OPERATION_NEW:
            $help_message = "Fill out the form below and validate to create a new subscriber account. Please note that usernames should be unique.";
            break;

        case OPERATION_EDIT:
            $help_message = "Update the subscriber account details and validate.";
            $new = $new_button;
            break;

        default:
            $help_message = '';
            break;
        }
    }
    
    echo <<< EOT
<div class="box-help">
$help_message
</div>

$new

<form name="submit-vpnsubscr-form" id="submit-vpn-form" action="/subscriber.php" method="POST">
<input type='hidden' value='$operation' $operation_id_html />

EOT;
    vpnsubscr_print_all_errors( $errors );

    echo "<center>\n";
    echo "<table class='box-form'>\n";

    echo "<tr><td>Username</td>";
    echo "<td>";

    if ($operation == OPERATION_NEW) {
        echo "<input maxlength='$input_maxlength' size='$input_size' value='$username' $username_id_html />$mandatory";
    }
    else {
        if (empty( $username )) {
            $visible_username = "<i>&lt;not specified&gt;</i>";
        }
        else {
            $visible_username = $username;
        }
        echo "<input type='hidden' value='$username' $username_id_html /><strong>$visible_username</strong>";
    }
    echo "</td></tr>\n";

    echo "<tr><td>Device OS</td>";
    echo "<td>";
    if ($operation == OPERATION_NEW) {
        echo "<select style='width:$width;' value='$device' $device_id_html>";
        vpnsubscr_print_device_options( $device );
        echo "</select>$mandatory";
    }
    else {
        $device_name = vpnsubscr_get_device_name( $device );
        $device_icon = vpnsubscr_get_device_icon( $device );
        echo "<input type='hidden' value='$device' $device_id_html /><img src='$device_icon' title='' alt='' /> $device_name";
    }
    echo "</td></tr>";

    if ($operation == OPERATION_EDIT) {

        $formatted_create_date = date( "d M Y H:i:s", $create_date );
        $name = vpnsubscr_get_contact_name( $first_name, $last_name, $email_address );

        $service_icon = vpnsubscr_subscriber_service_icon( $service, $alive_date );
        $operation_status_icon = vpnsubscr_operation_status_icon( $operation_status );
        $to = vpnsubscr_get_contact_to( $first_name, $last_name, $email_address );
        $visible_to = vpnsubscr_get_visible_contact_to( $name, $email_address );

        echo "<tr><td>Current Status</td>";
        echo "<td>";
        echo "<input type='hidden' value='$service' $service_id_html />$service_icon";
        echo "<input type='hidden' value='$operation_status' $operation_status_id_html />$operation_status_icon";
        echo "<input type='hidden' value='$tls_password' $tls_password_id_html />";
        echo "</td></tr>\n";

        if ($alive_date == 0) {

            $formatted_alive_date = NOT_AVAILABLE;
        }
        else {
            $formatted_alive_date = date( "d M Y H:i:s", $alive_date );
        }

        if ($tls_password != '') {
            $download_profile_link = vpnsubscr_get_profile_link( $username, $device, false );
            $instructions_link = vpnsubscr_get_instructions_link( $username, $to, false );
            $password_icons = vpnsubscr_subscriber_get_password_icons( $username, $name, $phone, $tls_password );

            echo "<tr><td>VPN Profile</td>";
            echo "<td>$download_profile_link</td>";
            echo "</tr>\n";

            echo "<tr><td>Email Instructions</td>";
            echo "<td>$instructions_link</td>";
            echo "</tr>\n";

            echo "<tr><td>Certificate Password</td>";
            echo "<td>$password_icons</td>";
            echo "</tr>\n";
        }

        echo "<tr><td>Creation Date</td>";
        echo "<td>";
        echo "<input type='hidden' value='$create_date' $create_date_id_html />$formatted_create_date";
        echo "</td></tr>\n";

        echo "<tr><td>Alive Check Date</td>";
        echo "<td>";
        echo "<input type='hidden' value='$alive_date' $alive_date_id_html />$formatted_alive_date";
        echo "</td></tr>\n";

        echo "<tr><td>Subscriber Contact</td>";
        echo "<td><a href='mailto:$to'>$visible_to</a></td>";
        echo "</tr>\n";

        switch ($service) {

        case SUBSCRIBER_STATE_ACTIVATED:
        case SUBSCRIBER_STATE_SUSPENDED:

            echo "<tr><td>Modify Status</td>";
            echo "<td>";
            echo "<select style='width:$select_width;' value='$requested_status' $requested_status_id_html>";
            vpnsubscr_print_status_options( $service, $requested_status );
            echo "</select>";
            echo "</td></tr>\n";

            echo "<tr><td><label for='$confirm_cancel_id'>Confirm Cancellation</label></td>";
            echo "<td>";
            echo "<input type='checkbox' $confirm_cancel_id_html />";
            echo "</td></tr>\n";
            break;

        default:
            break;
        }
    }

    echo "<tr><td>First Name</td>";
    echo "<td>";
    echo "<input maxlength='$input_maxlength' size='$input_size' value='$first_name' $first_name_id_html />";
    echo "</td></tr>\n";

    echo "<tr><td>Last Name</td>";
    echo "<td>";
    echo "<input maxlength='$input_maxlength' size='$input_size' value='$last_name' $last_name_id_html />";
    echo "</td></tr>\n";

    echo "<tr><td>Email Address</td>";
    echo "<td>";
    echo "<input maxlength='$input_maxlength' size='$input_size' value='$email_address' $email_address_id_html />$mandatory";
    echo "</td></tr>\n";

    $checked = ($check_email == 'on') ? ' checked' : '';

    echo "<tr><td><label for='$check_email_id'>Check Email Address</label></td>";
    echo "<td>";
    echo "<input$checked type='checkbox' $check_email_id_html />";
    echo "</td></tr>\n";

    echo "<tr><td>WhatsApp Number</td>";
    echo "<td>";
    echo "<input maxlength='24' size='$input_size' value='$phone' $phone_id_html />$mandatory";
    echo "</td></tr>\n";

    if ($method == 'POST' or !$errors) {
        echo "<tr><td></td><td><input class='valid-button' style='width:$width;' type='submit' value='Validate' /></td></tr>\n";
    }
    echo <<< EOT
</table>
</center>
</form>

EOT;
}

function vpnsubscr_display_title( $subscriber )
{
    $errors = $subscriber[ERRORS];
    $controls = $subscriber[CONTROLS];
    $data = $subscriber[DATA];

    $method = $controls[METHOD];
    $operation = $controls[OPERATION];
    $username = $data[USERNAME];

    $new_title = "New Subscriber";

    $title = 'Refresh';
    $edit_operation = OPERATION_EDIT;
    $refresh_icon = " <a href='subscriber.php?operation=$edit_operation&username=$username'><img src='/image/refresh.png' title='$title' alt='$title' /></a>";
    $update_title = "<a href='subscribers.php'>All Subscribers</a> &gt; Subscriber [$username] $refresh_icon";

    switch ($method) {

    case 'GET':
    if (empty( $username )) {
        $title = $new_title;
    }
    else {
        if ($operation == OPERATION_NEW) {
            $title = $new_title;
        }
        else {
            $title = $update_title;
        }
    }
    break;

    case 'POST':
        if (empty( $username )) {
        $title = $new_title;
    }
    else {
        if ($operation == OPERATION_NEW) {
            if ($errors) {
                $title = $new_title;
            }
            else {
                $title = $update_title;
            }
        }
        else {
            $title = $update_title;
        }
    }
        break;

    default:
        $title = $new_title;
        break;
    }

    echo $title;
}

// Main( )

$SUBSCRIBER = vpnsubscr_get_subscriber( );

?>
<!DOCTYPE html>
<html>
  <head>
    <title><?php echo vpnsubscr_get_org_name( ); ?> Subscriber</title>
    
    <link rel="shortcut icon" type="image/x-image" href="/image/favicon.ico" />
    <link rel="stylesheet" type="text/css" href="/chromestyle.css" />
    <link rel="stylesheet" type="text/css" href="/style.css" />
    
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="robots" content="noindex, nofollow, noarchive, noarchive, nosnippet, noodp, noydir" >
    <meta name="description" content="This page allows you to manage a VPN subscriber." />

    <script type="text/javascript" src="/js/chrome.js"></script>
    <script type="text/javascript" src="/js/vpnsubscr.js"></script>
    <script type="text/javascript" src="/js/printmenu.js"></script>
    <script type="text/javascript" src="/js/logout.js"></script>
  </head>

  <body>
    <?php vpnsubscr_display_header( ); ?>
    <div class='box-centered-container'>
      <div class='box-centered-nested'>
	<div class='page-title'>Subscribers &gt; <?php vpnsubscr_display_title( $SUBSCRIBER ); ?></div>
	<?php vpnsubscr_display_form( $SUBSCRIBER ); ?>
      </div>
    </div>
    <?php vpnsubscr_display_footer( ); ?>
  </body>
</html>
