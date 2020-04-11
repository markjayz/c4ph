--
-- Table structure for table `parties`
--
DROP TABLE IF EXISTS `parties`;
CREATE TABLE `parties` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` enum('user','organization') NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  `is_active` smallint NOT NULL DEFAULT '1',
  `is_verified` smallint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  INDEX `parties_type_idx` (`type`),
  INDEX `parties_created_at_idx` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `countries`
--
DROP TABLE IF EXISTS `countries`;
CREATE TABLE `countries` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` char(2) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `countries_code_uk` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `currencies`
--
DROP TABLE IF EXISTS `currencies`;
CREATE TABLE `currencies` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` char(3) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `currencies_code_uk` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `contact_types`
--
DROP TABLE IF EXISTS `contact_types`;
CREATE TABLE `contact_types` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `contact_types_name_uk` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `addresses`
--
DROP TABLE IF EXISTS `addresses`;
CREATE TABLE `addresses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `party_id` int NOT NULL,
  `type` enum('home','work') NOT NULL,
  `street` text,
  `district` text,
  `city` text,
  `state` text,
  `postal_code` text,
  `region` text,
  `country_id` int NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `addresses_party_id_fk` FOREIGN KEY (`party_id`) REFERENCES `parties` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT `addresses_counry_id_fk` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION,
  INDEX `addresses_party_id_idx` (`party_id`),
  INDEX `addresses_type_idx` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `contacts`
--
DROP TABLE IF EXISTS `contacts`;
CREATE TABLE `contacts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `party_id` int NOT NULL,
  `contact_type_id` int NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `details` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `contacts_party_id_contact_type_id_details_uk` (`party_id`,`contact_type_id`,`details`),
  CONSTRAINT `contacts_party_id_fk` FOREIGN KEY (`party_id`) REFERENCES `parties` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT `contacts_contact_type_id_fk` FOREIGN KEY (`contact_type_id`) REFERENCES `contact_types` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `organizations`
--
DROP TABLE IF EXISTS `organizations`;
CREATE TABLE `organizations` (
  `party_id` int NOT NULL,
  `type` enum('supplier','hospital') NOT NULL,
  `code` varchar(50) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`party_id`),
  UNIQUE KEY `organizations_type_name_uk` (`type`,`code`),
  INDEX `organizations_name_idx` (`name`),
  CONSTRAINT `organizations_party_id_fk` FOREIGN KEY (`party_id`) REFERENCES `parties` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `products`
--
DROP TABLE IF EXISTS `products`;
CREATE TABLE `products` (
  `id` int NOT NULL AUTO_INCREMENT,
  `party_id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `inventory_level` int NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `products_party_id_fk` (`party_id`),
  INDEX `products_name_idx` (`name`),
  INDEX `products_created_at_idx` (`created_at`),
  CONSTRAINT `products_party_id_fk` FOREIGN KEY (`party_id`) REFERENCES `organizations` (`party_id`) ON UPDATE NO ACTION ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `pricing`
--
DROP TABLE IF EXISTS `pricing`;
CREATE TABLE `pricing` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `currency_id` int NOT NULL,
  `amount` decimal(14,2) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `pricing_product_id_currency_id_idx` (`product_id`,`currency_id`),
  CONSTRAINT `pricing_product_id_fk` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT `pricing_currency_id_fk` FOREIGN KEY (`currency_id`) REFERENCES `currencies` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Temporary view structure for view `v_hospitals`
--
DROP VIEW IF EXISTS `v_hospitals`;
CREATE VIEW `v_hospitals` AS
SELECT
  `p`.`id` AS `party_id`,
  `p`.`created_at` AS `created_at`,
  `p`.`is_active` AS `is_active`,
  `p`.`is_verified` AS `is_verified`,
  `o`.`code` AS `code`,
  `o`.`name` AS `name`
FROM `organizations` `o`
JOIN `parties` `p` ON `p`.`id` = `o`.`party_id`
WHERE `p`.`type` = 'organization' AND `o`.`type` = 'hospital'
ORDER BY
  `p`.`created_at` DESC,
  `p`.`id` DESC;

--
-- Temporary view structure for view `v_suppliers`
--
DROP VIEW IF EXISTS `v_suppliers`;
CREATE VIEW `v_suppliers` AS
SELECT
  `p`.`id` AS `party_id`,
  `p`.`created_at` AS `created_at`,
  `p`.`is_active` AS `is_active`,
  `p`.`is_verified` AS `is_verified`,
  `o`.`code` AS `code`,
  `o`.`name` AS `name`
FROM `organizations` `o`
JOIN `parties` `p` on `p`.`id` = `o`.`party_id`
WHERE `p`.`type` = 'organization' AND `o`.`type` = 'supplier'
ORDER BY
  `p`.`created_at` DESC,
  `p`.`id` DESC;

--
-- Temporary view structure for view `v_contacts`
--
DROP VIEW IF EXISTS `v_contacts`;
CREATE VIEW `v_contacts` AS
SELECT
  `c`.`id` AS `id`,
  `c`.`party_id` AS `party_id`,
  `c`.`name` AS `name`,
  `c`.`details` AS `details`,
  `ct`.`name` AS `type`,
  `c`.`created_at` AS `created_at`
FROM `contacts` `c`
JOIN `contact_types` `ct` on `ct`.`id` = `c`.`contact_type_id`
ORDER BY
  `c`.`party_id`,
  `ct`.`name`;

--
-- Temporary view structure for view `v_products`
--
DROP VIEW IF EXISTS `v_products`;
CREATE VIEW `v_products` AS
SELECT
  `p`.`id` AS `id`,
  `p`.`party_id` AS `party_id`,
  `p`.`name` AS `name`,
  `p`.`inventory_level` AS `inventory_level`,
  `p`.`created_at` AS `created_at`,
  `p`.`updated_at` AS `updated_at`,
  json_objectagg(`c`.`code`,`r`.`amount`) AS `pricing`
FROM `products` `p`
JOIN `pricing` `r` ON `r`.`product_id` = `p`.`id`
JOIN `currencies` `c` ON `c`.`id` = `r`.`currency_id`
GROUP BY
  `p`.`id`
ORDER BY
  `p`.`created_at` DESC,
  `p`.`id` DESC;

INSERT INTO countries (code, name) VALUES ('PH', 'Philippines');
INSERT INTO currencies (code, name) VALUES ('PHP', 'Philippine peso');
INSERT INTO currencies (code, name) VALUES ('USD', 'United States dollar');

INSERT INTO contact_types (name) VALUES ('mobile');
INSERT INTO contact_types (name) VALUES ('phone');
INSERT INTO contact_types (name) VALUES ('skype');
INSERT INTO contact_types (name) VALUES ('web');
INSERT INTO contact_types (name) VALUES ('facebook');
INSERT INTO contact_types (name) VALUES ('viber');
INSERT INTO contact_types (name) VALUES ('whatsapp');
INSERT INTO contact_types (name) VALUES ('email');
