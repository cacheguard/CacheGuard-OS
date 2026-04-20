--
-- Definition of table `country`
--

DROP TABLE IF EXISTS `country`;
CREATE TABLE IF NOT EXISTS `country` (
    `code` VARCHAR(2) NOT NULL,
    `name` VARCHAR(48) NOT NULL,
    PRIMARY KEY (`code`)
    );

--
-- Definition of table `waf_reputation_country`
--

-- reputation: FALSE --> OK (good reputation)
-- 	       TRUE  --> K0 (bad  reputation)

DROP TABLE IF EXISTS `waf_reputation_country`;
CREATE TABLE IF NOT EXISTS `waf_reputation_country` (
    `country` VARCHAR(2) NOT NULL,
    `reputation` BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (`country`)
    );
