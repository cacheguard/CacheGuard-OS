--
-- Definition of table `access`
--

DROP TABLE IF EXISTS `access`;
CREATE TABLE IF NOT EXISTS `access` (
    `id` VARCHAR(96) NOT NULL,
    `ip` VARCHAR(15) DEFAULT "0.0.0.0",
    `alive_date` INT(6) DEFAULT 0,
    PRIMARY KEY (`id`)
    );
