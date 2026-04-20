--
-- Definition of table `setup`
--

DROP TABLE IF EXISTS `setup`;
CREATE TABLE IF NOT EXISTS `setup` (
    `id` TINYINT DEFAULT 0,
    `service_name` VARCHAR(32) NOT NULL,
    `previous_service_name` VARCHAR(32) NOT NULL,
    `domain_name` VARCHAR(64) DEFAULT "",
    `timezone` VARCHAR(48) DEFAULT "",
    `vpn_address` VARCHAR(64) DEFAULT "",
    `ip` VARCHAR(15) DEFAULT "",
    `service` TINYINT DEFAULT 0,
    PRIMARY KEY (`id`)
    );

--
-- Definition of table `email`
--

DROP TABLE IF EXISTS `email`;
CREATE TABLE IF NOT EXISTS `email` (
    `id` TINYINT DEFAULT 0,
    `first_name` VARCHAR(64) DEFAULT "",
    `last_name` VARCHAR(64) DEFAULT "",
    `email_address` VARCHAR(64) DEFAULT "",
    `server` VARCHAR(64) DEFAULT "",
    `port` INT(6) DEFAULT 587,
    `account` VARCHAR(64) DEFAULT "",
    `password` VARCHAR(128) DEFAULT "",
    `service` TINYINT DEFAULT 0,
    PRIMARY KEY (`id`)
    );

--
-- Definition of table `subscriber`
--

DROP TABLE IF EXISTS `subscriber`;
CREATE TABLE IF NOT EXISTS `subscriber` (
    `username` VARCHAR(32) NOT NULL,
    `email_address` VARCHAR(64) NOT NULL,
    `previous_email_address` VARCHAR(64) NOT NULL,
    `first_name` VARCHAR(64) DEFAULT "",
    `last_name` VARCHAR(64) DEFAULT "",
    `phone` VARCHAR(20) NOT NULL,
    `device` TINYINT DEFAULT 0,
    `create_date` INT(6) DEFAULT 0,
    `alive_date` INT(6) DEFAULT 0,
    `tls_password` VARCHAR(128) DEFAULT "",
    `operation_status` TINYINT DEFAULT 0,
    `service` TINYINT DEFAULT 0,
    PRIMARY KEY (`username`)
    );

CREATE INDEX `email_address` ON `subscriber`( `email_address` );
CREATE INDEX `previous_email_address` ON `subscriber`( `previous_email_address` );
CREATE INDEX `service` ON `subscriber`( `service` );

--
-- Definition of table `administrator`
--

DROP TABLE IF EXISTS `administrator`;
CREATE TABLE IF NOT EXISTS `administrator` (
    `username` VARCHAR(32) NOT NULL,
    `password` VARCHAR(64) NOT NULL DEFAULT '',
    `mfa_state` TINYINT DEFAULT 0,
    `mfa_secret` VARCHAR(128) DEFAULT '',
    PRIMARY KEY (`username`)
    );

--
-- Definition of table `mfa_timestamp`
--

DROP TABLE IF EXISTS `mfa_timestamp`;
CREATE TABLE IF NOT EXISTS `mfa_timestamp` (
    `username` VARCHAR(32) NOT NULL,
    `step_time` INT(6) DEFAULT 0,
    PRIMARY KEY (`username`, `step_time`)
    );

--
-- Definition of table `mfa_emergency`
--

DROP TABLE IF EXISTS `mfa_emergency`;
CREATE TABLE IF NOT EXISTS `mfa_emergency` (
    `username` VARCHAR(32) NOT NULL,
    `code` VARCHAR(8) DEFAULT '00000000',
    PRIMARY KEY (`username`, `code`)
    );
