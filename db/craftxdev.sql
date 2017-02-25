# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 127.0.0.1 (MySQL 5.7.17-0ubuntu0.16.04.1)
# Database: craftxdev
# Generation Time: 2017-02-24 22:36:07 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table cx_assetindexdata
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_assetindexdata`;

CREATE TABLE `cx_assetindexdata` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sessionId` varchar(36) NOT NULL DEFAULT '',
  `volumeId` int(11) NOT NULL,
  `offset` int(11) NOT NULL,
  `uri` text,
  `size` bigint(20) unsigned DEFAULT NULL,
  `timestamp` datetime DEFAULT NULL,
  `recordId` int(11) DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_assetindexdata_sessionId_volumeId_offset_unq_idx` (`sessionId`,`volumeId`,`offset`),
  KEY `cx_assetindexdata_volumeId_fk` (`volumeId`),
  CONSTRAINT `cx_assetindexdata_volumeId_fk` FOREIGN KEY (`volumeId`) REFERENCES `cx_volumes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table cx_assets
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_assets`;

CREATE TABLE `cx_assets` (
  `id` int(11) NOT NULL,
  `volumeId` int(11) DEFAULT NULL,
  `folderId` int(11) NOT NULL,
  `filename` varchar(255) NOT NULL,
  `kind` varchar(50) NOT NULL DEFAULT 'unknown',
  `width` int(11) unsigned DEFAULT NULL,
  `height` int(11) unsigned DEFAULT NULL,
  `size` bigint(20) unsigned DEFAULT NULL,
  `focalPoint` varchar(20) DEFAULT NULL,
  `dateModified` datetime DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_assets_filename_folderId_unq_idx` (`filename`,`folderId`),
  KEY `cx_assets_folderId_fk` (`folderId`),
  KEY `cx_assets_volumeId_fk` (`volumeId`),
  CONSTRAINT `cx_assets_folderId_fk` FOREIGN KEY (`folderId`) REFERENCES `cx_volumefolders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cx_assets_id_fk` FOREIGN KEY (`id`) REFERENCES `cx_elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cx_assets_volumeId_fk` FOREIGN KEY (`volumeId`) REFERENCES `cx_volumes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table cx_assettransformindex
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_assettransformindex`;

CREATE TABLE `cx_assettransformindex` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `assetId` int(11) NOT NULL,
  `filename` varchar(255) DEFAULT NULL,
  `format` varchar(255) DEFAULT NULL,
  `location` varchar(255) NOT NULL,
  `volumeId` int(11) DEFAULT NULL,
  `fileExists` tinyint(1) NOT NULL DEFAULT '0',
  `inProgress` tinyint(1) NOT NULL DEFAULT '0',
  `dateIndexed` datetime DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `cx_assettransformindex_volumeId_assetId_location_idx` (`volumeId`,`assetId`,`location`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table cx_assettransforms
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_assettransforms`;

CREATE TABLE `cx_assettransforms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `mode` enum('stretch','fit','crop') NOT NULL DEFAULT 'crop',
  `position` enum('top-left','top-center','top-right','center-left','center-center','center-right','bottom-left','bottom-center','bottom-right') NOT NULL DEFAULT 'center-center',
  `width` int(11) unsigned DEFAULT NULL,
  `height` int(11) unsigned DEFAULT NULL,
  `format` varchar(255) DEFAULT NULL,
  `quality` int(11) DEFAULT NULL,
  `dimensionChangeTime` datetime DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_assettransforms_name_unq_idx` (`name`),
  UNIQUE KEY `cx_assettransforms_handle_unq_idx` (`handle`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table cx_categories
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_categories`;

CREATE TABLE `cx_categories` (
  `id` int(11) NOT NULL,
  `groupId` int(11) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `cx_categories_groupId_fk` (`groupId`),
  CONSTRAINT `cx_categories_groupId_fk` FOREIGN KEY (`groupId`) REFERENCES `cx_categorygroups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cx_categories_id_fk` FOREIGN KEY (`id`) REFERENCES `cx_elements` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table cx_categorygroups
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_categorygroups`;

CREATE TABLE `cx_categorygroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `structureId` int(11) NOT NULL,
  `fieldLayoutId` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_categorygroups_name_unq_idx` (`name`),
  UNIQUE KEY `cx_categorygroups_handle_unq_idx` (`handle`),
  KEY `cx_categorygroups_structureId_fk` (`structureId`),
  KEY `cx_categorygroups_fieldLayoutId_fk` (`fieldLayoutId`),
  CONSTRAINT `cx_categorygroups_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `cx_fieldlayouts` (`id`) ON DELETE SET NULL,
  CONSTRAINT `cx_categorygroups_structureId_fk` FOREIGN KEY (`structureId`) REFERENCES `cx_structures` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table cx_categorygroups_i18n
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_categorygroups_i18n`;

CREATE TABLE `cx_categorygroups_i18n` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `groupId` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `hasUrls` tinyint(1) NOT NULL DEFAULT '1',
  `uriFormat` text,
  `template` varchar(500) DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_categorygroups_i18n_groupId_siteId_unq_idx` (`groupId`,`siteId`),
  KEY `cx_categorygroups_i18n_siteId_fk` (`siteId`),
  CONSTRAINT `cx_categorygroups_i18n_groupId_fk` FOREIGN KEY (`groupId`) REFERENCES `cx_categorygroups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cx_categorygroups_i18n_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `cx_sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table cx_content
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_content`;

CREATE TABLE `cx_content` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `elementId` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  `field_headline` varchar(255) DEFAULT NULL,
  `field_subheadline` varchar(255) DEFAULT NULL,
  `field_markdown` text,
  `field_description` text,
  `field_billingAddress` text,
  `field_billingCity` text,
  `field_billingState` text,
  `field_billingZip` text,
  `field_billingCountry` text,
  `field_customerId` text,
  `field_billingEmail` text,
  `field_billingCountryCode` varchar(255) DEFAULT NULL,
  `field_subscriptionId` text,
  `field_subscriptionJson` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_content_elementId_siteId_unq_idx` (`elementId`,`siteId`),
  KEY `cx_content_siteId_fk` (`siteId`),
  KEY `cx_content_title_fk` (`title`),
  CONSTRAINT `cx_content_elementId_fk` FOREIGN KEY (`elementId`) REFERENCES `cx_elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cx_content_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `cx_sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cx_content` WRITE;
/*!40000 ALTER TABLE `cx_content` DISABLE KEYS */;

INSERT INTO `cx_content` (`id`, `elementId`, `siteId`, `title`, `dateCreated`, `dateUpdated`, `uid`, `field_headline`, `field_subheadline`, `field_markdown`, `field_description`, `field_billingAddress`, `field_billingCity`, `field_billingState`, `field_billingZip`, `field_billingCountry`, `field_customerId`, `field_billingEmail`, `field_billingCountryCode`, `field_subscriptionId`, `field_subscriptionJson`)
VALUES
	(1,1,1,NULL,'2017-02-06 18:39:45','2017-02-13 04:35:16','733fd721-e25d-49fc-a09b-41c6cc4692af',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
	(2,2,1,'Homepage','2017-02-06 18:57:45','2017-02-07 05:30:57','fd1f3cbe-c14f-4317-a064-a644d62374cc','Craft Training for Busy Developers','',NULL,'',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
	(3,3,1,NULL,'2017-02-18 01:30:24','2017-02-23 04:24:10','fc944bf9-f4e3-4029-80cc-ded78e17cae1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'cus_A8eIEbktjRp3Tb',NULL,NULL,'sub_A8eIjgpyQDec67',NULL);

/*!40000 ALTER TABLE `cx_content` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cx_deprecationerrors
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_deprecationerrors`;

CREATE TABLE `cx_deprecationerrors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL,
  `fingerprint` varchar(255) NOT NULL,
  `lastOccurrence` datetime NOT NULL,
  `file` varchar(255) NOT NULL,
  `line` smallint(6) unsigned NOT NULL,
  `class` varchar(255) DEFAULT NULL,
  `method` varchar(255) DEFAULT NULL,
  `template` varchar(500) DEFAULT NULL,
  `templateLine` smallint(6) unsigned DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  `traces` text,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_deprecationerrors_key_fingerprint_unq_idx` (`key`,`fingerprint`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cx_deprecationerrors` WRITE;
/*!40000 ALTER TABLE `cx_deprecationerrors` DISABLE KEYS */;

INSERT INTO `cx_deprecationerrors` (`id`, `key`, `fingerprint`, `lastOccurrence`, `file`, `line`, `class`, `method`, `template`, `templateLine`, `message`, `traces`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,'getCsrfInput','/home/vagrant/craftx.dev/templates/signup.html','2017-02-24 02:00:56','/home/vagrant/craftx.dev/vendor/craftcms/cms/src/web/twig/Extension.php',813,'craft\\web\\twig\\Extension','getCsrfInput','/home/vagrant/craftx.dev/templates/signup.html',NULL,'getCsrfInput() has been deprecated. Use csrfInput() instead.','[{\"objectClass\":\"craft\\\\services\\\\Deprecator\",\"file\":\"/home/vagrant/craftx.dev/vendor/craftcms/cms/src/web/twig/Extension.php\",\"line\":813,\"class\":\"craft\\\\services\\\\Deprecator\",\"method\":\"log\",\"args\":\"\\\"getCsrfInput\\\", \\\"getCsrfInput() has been deprecated. Use csrfInput() instead.\\\"\"},{\"objectClass\":\"craft\\\\web\\\\twig\\\\Extension\",\"file\":\"/home/vagrant/craftx.dev/storage/runtime/compiled_templates/38/38c220ded7c756bda655ce8723f179e122bed7a8e59689fc375a4848c0ed1230.php\",\"line\":40,\"class\":\"craft\\\\web\\\\twig\\\\Extension\",\"method\":\"getCsrfInput\",\"args\":null},{\"objectClass\":\"__TwigTemplate_12b002a15fd334babbf854b87dcd548a2fcafa3cbd3ab080d663cb9565a98f89\",\"file\":\"/home/vagrant/craftx.dev/vendor/twig/twig/lib/Twig/Template.php\",\"line\":393,\"class\":\"__TwigTemplate_12b002a15fd334babbf854b87dcd548a2fcafa3cbd3ab080d663cb9565a98f89\",\"method\":\"doDisplay\",\"args\":\"[\\\"view\\\" => craft\\\\web\\\\View, \\\"SORT_ASC\\\" => 4, \\\"SORT_DESC\\\" => 3, \\\"POS_HEAD\\\" => 1, ...], []\"},{\"objectClass\":\"__TwigTemplate_12b002a15fd334babbf854b87dcd548a2fcafa3cbd3ab080d663cb9565a98f89\",\"file\":\"/home/vagrant/craftx.dev/vendor/craftcms/cms/src/web/twig/Template.php\",\"line\":51,\"class\":\"Twig_Template\",\"method\":\"displayWithErrorHandling\",\"args\":\"[\\\"view\\\" => craft\\\\web\\\\View, \\\"SORT_ASC\\\" => 4, \\\"SORT_DESC\\\" => 3, \\\"POS_HEAD\\\" => 1, ...], []\"},{\"objectClass\":\"__TwigTemplate_12b002a15fd334babbf854b87dcd548a2fcafa3cbd3ab080d663cb9565a98f89\",\"file\":\"/home/vagrant/craftx.dev/vendor/twig/twig/lib/Twig/Template.php\",\"line\":364,\"class\":\"craft\\\\web\\\\twig\\\\Template\",\"method\":\"displayWithErrorHandling\",\"args\":\"[\\\"view\\\" => craft\\\\web\\\\View, \\\"SORT_ASC\\\" => 4, \\\"SORT_DESC\\\" => 3, \\\"POS_HEAD\\\" => 1, ...], []\"},{\"objectClass\":\"__TwigTemplate_12b002a15fd334babbf854b87dcd548a2fcafa3cbd3ab080d663cb9565a98f89\",\"file\":\"/home/vagrant/craftx.dev/vendor/craftcms/cms/src/web/twig/Template.php\",\"line\":32,\"class\":\"Twig_Template\",\"method\":\"display\",\"args\":\"[], []\"},{\"objectClass\":\"__TwigTemplate_12b002a15fd334babbf854b87dcd548a2fcafa3cbd3ab080d663cb9565a98f89\",\"file\":\"/home/vagrant/craftx.dev/vendor/twig/twig/lib/Twig/Template.php\",\"line\":372,\"class\":\"craft\\\\web\\\\twig\\\\Template\",\"method\":\"display\",\"args\":\"[]\"},{\"objectClass\":\"__TwigTemplate_12b002a15fd334babbf854b87dcd548a2fcafa3cbd3ab080d663cb9565a98f89\",\"file\":\"/home/vagrant/craftx.dev/vendor/twig/twig/lib/Twig/Environment.php\",\"line\":288,\"class\":\"Twig_Template\",\"method\":\"render\",\"args\":\"[]\"},{\"objectClass\":\"craft\\\\web\\\\twig\\\\Environment\",\"file\":\"/home/vagrant/craftx.dev/vendor/craftcms/cms/src/web/View.php\",\"line\":242,\"class\":\"Twig_Environment\",\"method\":\"render\",\"args\":\"\\\"signup\\\", []\"},{\"objectClass\":\"craft\\\\web\\\\View\",\"file\":\"/home/vagrant/craftx.dev/vendor/craftcms/cms/src/web/View.php\",\"line\":274,\"class\":\"craft\\\\web\\\\View\",\"method\":\"renderTemplate\",\"args\":\"\\\"signup\\\", []\"},{\"objectClass\":\"craft\\\\web\\\\View\",\"file\":\"/home/vagrant/craftx.dev/vendor/craftcms/cms/src/web/Controller.php\",\"line\":100,\"class\":\"craft\\\\web\\\\View\",\"method\":\"renderPageTemplate\",\"args\":\"\\\"signup\\\", []\"},{\"objectClass\":\"craft\\\\controllers\\\\TemplatesController\",\"file\":\"/home/vagrant/craftx.dev/vendor/craftcms/cms/src/controllers/TemplatesController.php\",\"line\":56,\"class\":\"craft\\\\web\\\\Controller\",\"method\":\"renderTemplate\",\"args\":\"\\\"signup\\\", []\"},{\"objectClass\":\"craft\\\\controllers\\\\TemplatesController\",\"file\":null,\"line\":null,\"class\":\"craft\\\\controllers\\\\TemplatesController\",\"method\":\"actionRender\",\"args\":\"\\\"signup\\\", []\"},{\"objectClass\":null,\"file\":\"/home/vagrant/craftx.dev/vendor/yiisoft/yii2/base/InlineAction.php\",\"line\":57,\"class\":null,\"method\":\"call_user_func_array\",\"args\":\"[craft\\\\controllers\\\\TemplatesController, \\\"actionRender\\\"], [\\\"signup\\\", []]\"},{\"objectClass\":\"yii\\\\base\\\\InlineAction\",\"file\":\"/home/vagrant/craftx.dev/vendor/yiisoft/yii2/base/Controller.php\",\"line\":156,\"class\":\"yii\\\\base\\\\InlineAction\",\"method\":\"runWithParams\",\"args\":\"[\\\"template\\\" => \\\"signup\\\"]\"},{\"objectClass\":\"craft\\\\controllers\\\\TemplatesController\",\"file\":\"/home/vagrant/craftx.dev/vendor/yiisoft/yii2/base/Module.php\",\"line\":523,\"class\":\"yii\\\\base\\\\Controller\",\"method\":\"runAction\",\"args\":\"\\\"render\\\", [\\\"template\\\" => \\\"signup\\\"]\"},{\"objectClass\":\"craft\\\\web\\\\Application\",\"file\":\"/home/vagrant/craftx.dev/vendor/craftcms/cms/src/web/Application.php\",\"line\":329,\"class\":\"yii\\\\base\\\\Module\",\"method\":\"runAction\",\"args\":\"\\\"templates/render\\\", [\\\"template\\\" => \\\"signup\\\"]\"},{\"objectClass\":\"craft\\\\web\\\\Application\",\"file\":\"/home/vagrant/craftx.dev/vendor/yiisoft/yii2/web/Application.php\",\"line\":102,\"class\":\"craft\\\\web\\\\Application\",\"method\":\"runAction\",\"args\":\"\\\"templates/render\\\", [\\\"template\\\" => \\\"signup\\\"]\"},{\"objectClass\":\"craft\\\\web\\\\Application\",\"file\":\"/home/vagrant/craftx.dev/vendor/craftcms/cms/src/web/Application.php\",\"line\":210,\"class\":\"yii\\\\web\\\\Application\",\"method\":\"handleRequest\",\"args\":\"craft\\\\web\\\\Request\"},{\"objectClass\":\"craft\\\\web\\\\Application\",\"file\":\"/home/vagrant/craftx.dev/vendor/yiisoft/yii2/base/Application.php\",\"line\":380,\"class\":\"craft\\\\web\\\\Application\",\"method\":\"handleRequest\",\"args\":\"craft\\\\web\\\\Request\"},{\"objectClass\":\"craft\\\\web\\\\Application\",\"file\":\"/home/vagrant/craftx.dev/web/index.php\",\"line\":21,\"class\":\"yii\\\\base\\\\Application\",\"method\":\"run\",\"args\":null}]','2017-02-23 19:27:56','2017-02-24 02:00:56','a267a437-e970-48c8-b37d-cae154b7b0ba');

/*!40000 ALTER TABLE `cx_deprecationerrors` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cx_elementindexsettings
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_elementindexsettings`;

CREATE TABLE `cx_elementindexsettings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL,
  `settings` text,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_elementindexsettings_type_unq_idx` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table cx_elements
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_elements`;

CREATE TABLE `cx_elements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `archived` tinyint(1) NOT NULL DEFAULT '0',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `cx_elements_type_idx` (`type`),
  KEY `cx_elements_enabled_idx` (`enabled`),
  KEY `cx_elements_archived_dateCreated_idx` (`archived`,`dateCreated`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cx_elements` WRITE;
/*!40000 ALTER TABLE `cx_elements` DISABLE KEYS */;

INSERT INTO `cx_elements` (`id`, `type`, `enabled`, `archived`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,'craft\\elements\\User',1,0,'2017-02-06 18:39:45','2017-02-13 04:35:16','8f9b3b5a-a4c8-40c5-970a-01394dc85b8a'),
	(2,'craft\\elements\\Entry',1,0,'2017-02-06 18:57:45','2017-02-07 05:30:57','ed27feb3-0e3f-457b-be29-6a7d20af0a51'),
	(3,'craft\\elements\\User',1,0,'2017-02-18 01:29:14','2017-02-23 04:24:10','6b6a037c-c82e-43bc-afb4-f7c86856ca45');

/*!40000 ALTER TABLE `cx_elements` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cx_elements_i18n
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_elements_i18n`;

CREATE TABLE `cx_elements_i18n` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `elementId` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `slug` varchar(255) DEFAULT NULL,
  `uri` varchar(255) DEFAULT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_elements_i18n_elementId_siteId_unq_idx` (`elementId`,`siteId`),
  UNIQUE KEY `cx_elements_i18n_uri_siteId_unq_idx` (`uri`,`siteId`),
  KEY `cx_elements_i18n_siteId_fk` (`siteId`),
  KEY `cx_elements_i18n_slug_siteId_idx` (`slug`,`siteId`),
  KEY `cx_elements_i18n_enabled_idx` (`enabled`),
  CONSTRAINT `cx_elements_i18n_elementId_fk` FOREIGN KEY (`elementId`) REFERENCES `cx_elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cx_elements_i18n_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `cx_sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cx_elements_i18n` WRITE;
/*!40000 ALTER TABLE `cx_elements_i18n` DISABLE KEYS */;

INSERT INTO `cx_elements_i18n` (`id`, `elementId`, `siteId`, `slug`, `uri`, `enabled`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,1,1,'',NULL,1,'2017-02-06 18:39:45','2017-02-13 04:35:16','9504a134-b2e6-46af-b4aa-74c9b71c7b77'),
	(2,2,1,'homepage','__home__',1,'2017-02-06 18:57:45','2017-02-07 05:30:57','5283df6e-7b1f-456c-ae86-5e3974e90a16'),
	(3,3,1,'',NULL,1,'2017-02-18 01:30:24','2017-02-23 04:24:10','d7effd95-63bb-4be4-a3a6-5f621dcfc327');

/*!40000 ALTER TABLE `cx_elements_i18n` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cx_emailmessages
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_emailmessages`;

CREATE TABLE `cx_emailmessages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `language` varchar(255) NOT NULL,
  `key` varchar(255) NOT NULL,
  `subject` text NOT NULL,
  `body` text NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_emailmessages_key_language_unq_idx` (`key`,`language`),
  KEY `cx_emailmessages_language_idx` (`language`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table cx_entries
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_entries`;

CREATE TABLE `cx_entries` (
  `id` int(11) NOT NULL,
  `sectionId` int(11) NOT NULL,
  `typeId` int(11) NOT NULL,
  `authorId` int(11) DEFAULT NULL,
  `postDate` datetime DEFAULT NULL,
  `expiryDate` datetime DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `cx_entries_postDate_idx` (`postDate`),
  KEY `cx_entries_expiryDate_idx` (`expiryDate`),
  KEY `cx_entries_authorId_fk` (`authorId`),
  KEY `cx_entries_sectionId_fk` (`sectionId`),
  KEY `cx_entries_typeId_fk` (`typeId`),
  CONSTRAINT `cx_entries_authorId_fk` FOREIGN KEY (`authorId`) REFERENCES `cx_users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cx_entries_id_fk` FOREIGN KEY (`id`) REFERENCES `cx_elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cx_entries_sectionId_fk` FOREIGN KEY (`sectionId`) REFERENCES `cx_sections` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cx_entries_typeId_fk` FOREIGN KEY (`typeId`) REFERENCES `cx_entrytypes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cx_entries` WRITE;
/*!40000 ALTER TABLE `cx_entries` DISABLE KEYS */;

INSERT INTO `cx_entries` (`id`, `sectionId`, `typeId`, `authorId`, `postDate`, `expiryDate`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(2,1,1,NULL,'2017-02-06 23:59:44',NULL,'2017-02-06 18:57:45','2017-02-07 05:30:57','2466f0af-20d8-4705-bd99-e780840f65f0');

/*!40000 ALTER TABLE `cx_entries` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cx_entrydrafts
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_entrydrafts`;

CREATE TABLE `cx_entrydrafts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entryId` int(11) NOT NULL,
  `sectionId` int(11) NOT NULL,
  `creatorId` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `notes` text,
  `data` mediumtext NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `cx_entrydrafts_sectionId_fk` (`sectionId`),
  KEY `cx_entrydrafts_entryId_siteId_idx` (`entryId`,`siteId`),
  KEY `cx_entrydrafts_siteId_fk` (`siteId`),
  KEY `cx_entrydrafts_creatorId_fk` (`creatorId`),
  CONSTRAINT `cx_entrydrafts_creatorId_fk` FOREIGN KEY (`creatorId`) REFERENCES `cx_users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cx_entrydrafts_entryId_fk` FOREIGN KEY (`entryId`) REFERENCES `cx_entries` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cx_entrydrafts_sectionId_fk` FOREIGN KEY (`sectionId`) REFERENCES `cx_sections` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cx_entrydrafts_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `cx_sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table cx_entrytypes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_entrytypes`;

CREATE TABLE `cx_entrytypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sectionId` int(11) NOT NULL,
  `fieldLayoutId` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `hasTitleField` tinyint(1) NOT NULL DEFAULT '1',
  `titleLabel` varchar(255) DEFAULT 'Title',
  `titleFormat` varchar(255) DEFAULT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_entrytypes_name_sectionId_unq_idx` (`name`,`sectionId`),
  UNIQUE KEY `cx_entrytypes_handle_sectionId_unq_idx` (`handle`,`sectionId`),
  KEY `cx_entrytypes_sectionId_fk` (`sectionId`),
  KEY `cx_entrytypes_fieldLayoutId_fk` (`fieldLayoutId`),
  CONSTRAINT `cx_entrytypes_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `cx_fieldlayouts` (`id`) ON DELETE SET NULL,
  CONSTRAINT `cx_entrytypes_sectionId_fk` FOREIGN KEY (`sectionId`) REFERENCES `cx_sections` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cx_entrytypes` WRITE;
/*!40000 ALTER TABLE `cx_entrytypes` DISABLE KEYS */;

INSERT INTO `cx_entrytypes` (`id`, `sectionId`, `fieldLayoutId`, `name`, `handle`, `hasTitleField`, `titleLabel`, `titleFormat`, `sortOrder`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,1,3,'Homepage','homepage',0,NULL,'{section.name|raw}',1,'2017-02-06 18:57:45','2017-02-07 05:18:54','5c2f8151-f389-4dc0-9a0a-c0596ca9686f'),
	(2,2,2,'Courses','courses',1,'Title',NULL,1,'2017-02-07 05:14:04','2017-02-07 05:14:04','bba6caa7-209e-4ad0-b1a7-1d324ac0e62e');

/*!40000 ALTER TABLE `cx_entrytypes` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cx_entryversions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_entryversions`;

CREATE TABLE `cx_entryversions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entryId` int(11) NOT NULL,
  `sectionId` int(11) NOT NULL,
  `creatorId` int(11) DEFAULT NULL,
  `siteId` int(11) NOT NULL,
  `num` smallint(6) unsigned NOT NULL,
  `notes` text,
  `data` mediumtext NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `cx_entryversions_sectionId_fk` (`sectionId`),
  KEY `cx_entryversions_entryId_siteId_idx` (`entryId`,`siteId`),
  KEY `cx_entryversions_siteId_fk` (`siteId`),
  KEY `cx_entryversions_creatorId_fk` (`creatorId`),
  CONSTRAINT `cx_entryversions_creatorId_fk` FOREIGN KEY (`creatorId`) REFERENCES `cx_users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `cx_entryversions_entryId_fk` FOREIGN KEY (`entryId`) REFERENCES `cx_entries` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cx_entryversions_sectionId_fk` FOREIGN KEY (`sectionId`) REFERENCES `cx_sections` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cx_entryversions_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `cx_sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table cx_fieldgroups
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_fieldgroups`;

CREATE TABLE `cx_fieldgroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_fieldgroups_name_unq_idx` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cx_fieldgroups` WRITE;
/*!40000 ALTER TABLE `cx_fieldgroups` DISABLE KEYS */;

INSERT INTO `cx_fieldgroups` (`id`, `name`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,'Shared','2017-02-07 05:14:22','2017-02-07 05:14:22','799c0f93-61ee-404c-b178-c8c8e7f66e24'),
	(2,'Users','2017-02-13 04:28:10','2017-02-13 04:28:10','8f5381cc-ddb6-4446-9b1f-056b27030357');

/*!40000 ALTER TABLE `cx_fieldgroups` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cx_fieldlayoutfields
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_fieldlayoutfields`;

CREATE TABLE `cx_fieldlayoutfields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `layoutId` int(11) NOT NULL,
  `tabId` int(11) NOT NULL,
  `fieldId` int(11) NOT NULL,
  `required` tinyint(1) NOT NULL DEFAULT '0',
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_fieldlayoutfields_layoutId_fieldId_unq_idx` (`layoutId`,`fieldId`),
  KEY `cx_fieldlayoutfields_sortOrder_idx` (`sortOrder`),
  KEY `cx_fieldlayoutfields_tabId_fk` (`tabId`),
  KEY `cx_fieldlayoutfields_fieldId_fk` (`fieldId`),
  CONSTRAINT `cx_fieldlayoutfields_fieldId_fk` FOREIGN KEY (`fieldId`) REFERENCES `cx_fields` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cx_fieldlayoutfields_layoutId_fk` FOREIGN KEY (`layoutId`) REFERENCES `cx_fieldlayouts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cx_fieldlayoutfields_tabId_fk` FOREIGN KEY (`tabId`) REFERENCES `cx_fieldlayouttabs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cx_fieldlayoutfields` WRITE;
/*!40000 ALTER TABLE `cx_fieldlayoutfields` DISABLE KEYS */;

INSERT INTO `cx_fieldlayoutfields` (`id`, `layoutId`, `tabId`, `fieldId`, `required`, `sortOrder`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,3,1,1,0,1,'2017-02-07 05:18:54','2017-02-07 05:18:54','4c7d5c0c-da6b-4cc7-abfd-71ce806ee49b'),
	(2,3,1,2,0,2,'2017-02-07 05:18:54','2017-02-07 05:18:54','6baa0da8-d059-4898-8b14-f705906aa8f7'),
	(3,3,1,4,0,3,'2017-02-07 05:18:54','2017-02-07 05:18:54','4019dffe-f63b-464f-80b9-24406cee2071'),
	(12,5,3,10,0,1,'2017-02-18 00:47:28','2017-02-18 00:47:28','32d73d73-4aa9-439a-9c56-d805544d181f'),
	(13,5,3,13,0,2,'2017-02-18 00:47:28','2017-02-18 00:47:28','6fb73787-a219-472a-a600-0e3cbdbde0ca'),
	(14,5,3,11,0,3,'2017-02-18 00:47:28','2017-02-18 00:47:28','df9c43fd-c8cf-4b95-8d63-4a1531145d56'),
	(15,5,3,12,0,4,'2017-02-18 00:47:28','2017-02-18 00:47:28','de878b50-8cd5-4f08-8546-89b43c346a8b'),
	(16,5,3,9,0,5,'2017-02-18 00:47:28','2017-02-18 00:47:28','aabe2324-5561-49fc-9faa-c624b0d4690a'),
	(17,5,3,5,0,6,'2017-02-18 00:47:28','2017-02-18 00:47:28','cc806d8f-00f6-4a69-8a12-d4af4a64c8d3'),
	(18,5,3,6,0,7,'2017-02-18 00:47:28','2017-02-18 00:47:28','4d89cf40-094c-4df7-831b-e5eb954789f4'),
	(19,5,3,7,0,8,'2017-02-18 00:47:28','2017-02-18 00:47:28','49a39ccf-7b3d-42f2-a41a-efa641c22b38'),
	(20,5,3,8,0,9,'2017-02-18 00:47:28','2017-02-18 00:47:28','d82a28fb-e19d-4b69-af94-e51ce14f132a');

/*!40000 ALTER TABLE `cx_fieldlayoutfields` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cx_fieldlayouts
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_fieldlayouts`;

CREATE TABLE `cx_fieldlayouts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `cx_fieldlayouts_type_idx` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cx_fieldlayouts` WRITE;
/*!40000 ALTER TABLE `cx_fieldlayouts` DISABLE KEYS */;

INSERT INTO `cx_fieldlayouts` (`id`, `type`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(2,'craft\\elements\\Entry','2017-02-07 05:14:04','2017-02-07 05:14:04','01e7a04d-1849-4164-a4c1-eb3790fe783d'),
	(3,'craft\\elements\\Entry','2017-02-07 05:18:54','2017-02-07 05:18:54','a00e2306-fcf8-437e-a0e9-f756e52f1dac'),
	(5,'craft\\elements\\User','2017-02-18 00:47:28','2017-02-18 00:47:28','77a30258-8017-40fa-bd2c-e8add2acc4c2');

/*!40000 ALTER TABLE `cx_fieldlayouts` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cx_fieldlayouttabs
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_fieldlayouttabs`;

CREATE TABLE `cx_fieldlayouttabs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `layoutId` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `cx_fieldlayouttabs_sortOrder_idx` (`sortOrder`),
  KEY `cx_fieldlayouttabs_layoutId_fk` (`layoutId`),
  CONSTRAINT `cx_fieldlayouttabs_layoutId_fk` FOREIGN KEY (`layoutId`) REFERENCES `cx_fieldlayouts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cx_fieldlayouttabs` WRITE;
/*!40000 ALTER TABLE `cx_fieldlayouttabs` DISABLE KEYS */;

INSERT INTO `cx_fieldlayouttabs` (`id`, `layoutId`, `name`, `sortOrder`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,3,'Content',1,'2017-02-07 05:18:54','2017-02-07 05:18:54','ff749ef5-b53c-4711-9bd7-7159af58dd5a'),
	(3,5,'Profile',1,'2017-02-18 00:47:28','2017-02-18 00:47:28','d61fe623-02bd-470a-af91-ddd554807acf');

/*!40000 ALTER TABLE `cx_fieldlayouttabs` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cx_fields
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_fields`;

CREATE TABLE `cx_fields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `groupId` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `handle` varchar(64) NOT NULL,
  `context` varchar(255) NOT NULL DEFAULT 'global',
  `instructions` text,
  `translationMethod` enum('none','language','site','custom') NOT NULL DEFAULT 'none',
  `translationKeyFormat` text,
  `type` varchar(255) NOT NULL,
  `settings` text,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_fields_handle_context_unq_idx` (`handle`,`context`),
  KEY `cx_fields_groupId_fk` (`groupId`),
  KEY `cx_fields_context_idx` (`context`),
  CONSTRAINT `cx_fields_groupId_fk` FOREIGN KEY (`groupId`) REFERENCES `cx_fieldgroups` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cx_fields` WRITE;
/*!40000 ALTER TABLE `cx_fields` DISABLE KEYS */;

INSERT INTO `cx_fields` (`id`, `groupId`, `name`, `handle`, `context`, `instructions`, `translationMethod`, `translationKeyFormat`, `type`, `settings`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,1,'Headline','headline','global','','none',NULL,'craft\\fields\\PlainText','{\"placeholder\":\"\",\"multiline\":\"\",\"initialRows\":\"4\",\"maxLength\":\"100\"}','2017-02-07 05:14:37','2017-02-07 05:14:52','5e07797f-48f5-4fbc-9b25-ef8266c2f024'),
	(2,1,'Subheadline','subheadline','global','','none',NULL,'craft\\fields\\PlainText','{\"placeholder\":\"\",\"multiline\":\"\",\"initialRows\":\"4\",\"maxLength\":\"255\"}','2017-02-07 05:15:04','2017-02-07 05:15:04','2257f3e5-54f7-40be-8f28-0648ab06f4b6'),
	(3,1,'Markdown','markdown','global','','none',NULL,'selvinortiz\\doxter\\fields\\DoxterField','{\"tabSize\":2,\"indentWithTabs\":false,\"enableLineWrapping\":true,\"enableSpellChecker\":false}','2017-02-07 05:15:25','2017-02-07 05:15:25','5f019cad-79cb-464d-b8d0-10603a397974'),
	(4,1,'Description','description','global','','none',NULL,'selvinortiz\\doxter\\fields\\DoxterField','{\"tabSize\":2,\"indentWithTabs\":false,\"enableLineWrapping\":true,\"enableSpellChecker\":false}','2017-02-07 05:18:00','2017-02-07 05:18:00','6cb8897e-6aba-4477-aaf1-747474bccfc3'),
	(5,2,'Billing Address','billingAddress','global','','none',NULL,'craft\\fields\\PlainText','{\"placeholder\":\"\",\"multiline\":\"\",\"initialRows\":\"4\",\"maxLength\":\"\"}','2017-02-13 04:28:49','2017-02-13 04:28:49','f5b83d0a-eb48-416f-be61-81c75bd412fd'),
	(6,2,'Billing City','billingCity','global','','none',NULL,'craft\\fields\\PlainText','{\"placeholder\":\"\",\"multiline\":\"\",\"initialRows\":\"4\",\"maxLength\":\"\"}','2017-02-13 04:29:25','2017-02-13 04:29:25','1fcab1b3-b537-473d-a503-8bb295226692'),
	(7,2,'Billing State','billingState','global','','none',NULL,'craft\\fields\\PlainText','{\"placeholder\":\"\",\"multiline\":\"\",\"initialRows\":\"4\",\"maxLength\":\"\"}','2017-02-13 04:29:41','2017-02-13 04:29:41','4131115c-cfb9-4592-a08c-81dfaf9509fb'),
	(8,2,'Billing Zip','billingZip','global','','none',NULL,'craft\\fields\\PlainText','{\"placeholder\":\"\",\"multiline\":\"\",\"initialRows\":\"4\",\"maxLength\":\"\"}','2017-02-13 04:31:31','2017-02-13 04:31:31','b1246329-88a6-49e1-8e19-bbaf0011ac18'),
	(9,2,'Billing Country','billingCountry','global','','none',NULL,'craft\\fields\\PlainText','{\"placeholder\":\"\",\"multiline\":\"\",\"initialRows\":\"4\",\"maxLength\":\"\"}','2017-02-13 04:31:50','2017-02-13 04:31:50','bc36bf11-888b-4f8d-98ce-93d0656daafc'),
	(10,2,'Customer ID','customerId','global','Customer ID issued by Stripe','none',NULL,'craft\\fields\\PlainText','{\"placeholder\":\"\",\"multiline\":\"\",\"initialRows\":\"4\",\"maxLength\":\"\"}','2017-02-13 04:32:44','2017-02-18 00:44:51','5597d2b6-95cf-46fa-a07a-d347ba918b3a'),
	(11,2,'Billing Email','billingEmail','global','Should be the customer email in Stripe','none',NULL,'craft\\fields\\PlainText','{\"placeholder\":\"\",\"multiline\":\"\",\"initialRows\":\"4\",\"maxLength\":\"\"}','2017-02-13 04:33:03','2017-02-13 04:34:05','4e2f40a2-8c04-42aa-aa66-2d92bb2428cb'),
	(12,2,'Billing Country Code','billingCountryCode','global','','none',NULL,'craft\\fields\\PlainText','{\"placeholder\":\"\",\"multiline\":\"\",\"initialRows\":\"4\",\"maxLength\":\"2\"}','2017-02-13 04:34:43','2017-02-13 04:34:43','197c65c9-4344-4077-9034-21f9eaff08b3'),
	(13,2,'Subscription ID','subscriptionId','global','Subscription ID issued by Stripe','none',NULL,'craft\\fields\\PlainText','{\"placeholder\":\"\",\"multiline\":\"\",\"initialRows\":\"4\",\"maxLength\":\"\"}','2017-02-18 00:46:33','2017-02-18 00:46:33','4b9fd993-c34a-4070-8e5b-b528f926e4d9'),
	(14,1,'Subscription JSON','subscriptionJson','global','JSON data received during subscription','none',NULL,'craft\\fields\\PlainText','{\"placeholder\":\"\",\"multiline\":\"\",\"initialRows\":\"4\",\"maxLength\":\"\"}','2017-02-18 00:49:40','2017-02-18 00:57:30','24e95252-e513-4cde-a6d8-b57be72fc42f');

/*!40000 ALTER TABLE `cx_fields` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cx_globalsets
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_globalsets`;

CREATE TABLE `cx_globalsets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `fieldLayoutId` int(11) DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_globalsets_name_unq_idx` (`name`),
  UNIQUE KEY `cx_globalsets_handle_unq_idx` (`handle`),
  KEY `cx_globalsets_fieldLayoutId_fk` (`fieldLayoutId`),
  CONSTRAINT `cx_globalsets_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `cx_fieldlayouts` (`id`) ON DELETE SET NULL,
  CONSTRAINT `cx_globalsets_id_fk` FOREIGN KEY (`id`) REFERENCES `cx_elements` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table cx_info
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_info`;

CREATE TABLE `cx_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `version` varchar(50) NOT NULL,
  `schemaVersion` varchar(15) NOT NULL,
  `edition` smallint(6) unsigned NOT NULL,
  `timezone` varchar(30) DEFAULT NULL,
  `on` tinyint(1) NOT NULL DEFAULT '0',
  `maintenance` tinyint(1) NOT NULL DEFAULT '0',
  `fieldVersion` char(12) NOT NULL DEFAULT '000000000000',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cx_info` WRITE;
/*!40000 ALTER TABLE `cx_info` DISABLE KEYS */;

INSERT INTO `cx_info` (`id`, `version`, `schemaVersion`, `edition`, `timezone`, `on`, `maintenance`, `fieldVersion`, `dateCreated`, `dateUpdated`, `uid`, `name`)
VALUES
	(1,'3.0.0-beta.4','3.0.32',2,'America/Chicago',1,0,'lGOLyJrwRN81','2017-02-06 18:39:45','2017-02-18 00:57:30','eaa61c2b-4f72-44a5-9c9a-1b9911d37734','Craft X');

/*!40000 ALTER TABLE `cx_info` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cx_matrixblocks
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_matrixblocks`;

CREATE TABLE `cx_matrixblocks` (
  `id` int(11) NOT NULL,
  `ownerId` int(11) NOT NULL,
  `ownerSiteId` int(11) DEFAULT NULL,
  `fieldId` int(11) NOT NULL,
  `typeId` int(11) NOT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `cx_matrixblocks_ownerId_fk` (`ownerId`),
  KEY `cx_matrixblocks_fieldId_fk` (`fieldId`),
  KEY `cx_matrixblocks_typeId_fk` (`typeId`),
  KEY `cx_matrixblocks_sortOrder_idx` (`sortOrder`),
  KEY `cx_matrixblocks_ownerSiteId_fk` (`ownerSiteId`),
  CONSTRAINT `cx_matrixblocks_fieldId_fk` FOREIGN KEY (`fieldId`) REFERENCES `cx_fields` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cx_matrixblocks_id_fk` FOREIGN KEY (`id`) REFERENCES `cx_elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cx_matrixblocks_ownerId_fk` FOREIGN KEY (`ownerId`) REFERENCES `cx_elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cx_matrixblocks_ownerSiteId_fk` FOREIGN KEY (`ownerSiteId`) REFERENCES `cx_sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `cx_matrixblocks_typeId_fk` FOREIGN KEY (`typeId`) REFERENCES `cx_matrixblocktypes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table cx_matrixblocktypes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_matrixblocktypes`;

CREATE TABLE `cx_matrixblocktypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fieldId` int(11) NOT NULL,
  `fieldLayoutId` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_matrixblocktypes_name_fieldId_unq_idx` (`name`,`fieldId`),
  UNIQUE KEY `cx_matrixblocktypes_handle_fieldId_unq_idx` (`handle`,`fieldId`),
  KEY `cx_matrixblocktypes_fieldId_fk` (`fieldId`),
  KEY `cx_matrixblocktypes_fieldLayoutId_fk` (`fieldLayoutId`),
  CONSTRAINT `cx_matrixblocktypes_fieldId_fk` FOREIGN KEY (`fieldId`) REFERENCES `cx_fields` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cx_matrixblocktypes_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `cx_fieldlayouts` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table cx_migrations
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_migrations`;

CREATE TABLE `cx_migrations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pluginId` int(11) DEFAULT NULL,
  `type` enum('app','plugin','content') NOT NULL DEFAULT 'app',
  `name` varchar(255) NOT NULL,
  `applyTime` datetime NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `cx_migrations_pluginId_fk` (`pluginId`),
  KEY `cx_migrations_type_pluginId_idx` (`type`,`pluginId`),
  CONSTRAINT `cx_migrations_pluginId_fk` FOREIGN KEY (`pluginId`) REFERENCES `cx_plugins` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cx_migrations` WRITE;
/*!40000 ALTER TABLE `cx_migrations` DISABLE KEYS */;

INSERT INTO `cx_migrations` (`id`, `pluginId`, `type`, `name`, `applyTime`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,NULL,'app','Install','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','abccfa7e-27b7-4cc9-afb6-0c19dcc45435'),
	(2,NULL,'app','m150403_183908_migrations_table_changes','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','5aab0a07-9e7e-49a1-bc76-0a70f07ace48'),
	(3,NULL,'app','m150403_184247_plugins_table_changes','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','e8cfe0d8-23e0-45bc-b755-0750d56e3fe5'),
	(4,NULL,'app','m150403_184533_field_version','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','a5495214-9961-4969-80b7-81fdd605362e'),
	(5,NULL,'app','m150403_184729_type_columns','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','f168cbd9-e88f-4298-9938-50224948b5f4'),
	(6,NULL,'app','m150403_185142_volumes','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','9ca223d3-4fd6-4b3f-8934-88b22349cccf'),
	(7,NULL,'app','m150428_231346_userpreferences','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','3addd587-9b41-416f-a467-116d53a56072'),
	(8,NULL,'app','m150519_150900_fieldversion_conversion','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','67446cd3-e6c2-45e6-ac46-43bf3863bdd0'),
	(9,NULL,'app','m150617_213829_update_email_settings','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','7efdd03b-e38c-49e4-9940-93026ad7f825'),
	(10,NULL,'app','m150721_124739_templatecachequeries','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','74e40dd4-09f2-4117-841e-7cd64ae1b7e6'),
	(11,NULL,'app','m150724_140822_adjust_quality_settings','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','23f88548-2535-489f-97bd-e19e2b0088ea'),
	(12,NULL,'app','m150815_133521_last_login_attempt_ip','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','10b311a0-d1c7-4b25-8830-45fccb67e3d9'),
	(13,NULL,'app','m151002_095935_volume_cache_settings','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','2edb7a50-4e65-4d63-bd30-9a9ac0b82cd7'),
	(14,NULL,'app','m151005_142750_volume_s3_storage_settings','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','af8fed60-8232-40e3-be54-fbfb18d916a0'),
	(15,NULL,'app','m151016_133600_delete_asset_thumbnails','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','09a34ed3-b54f-4dfd-9454-e811b5af344f'),
	(16,NULL,'app','m151209_000000_move_logo','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','d9d460af-2f95-47eb-adb5-d1ccc6e6c05d'),
	(17,NULL,'app','m151211_000000_rename_fileId_to_assetId','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','83f10622-b23a-472b-8487-0dee9ae39d6e'),
	(18,NULL,'app','m151215_000000_rename_asset_permissions','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','3ed85d66-68a9-4698-9cd0-0ba2af0adabf'),
	(19,NULL,'app','m160707_000000_rename_richtext_assetsource_setting','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','1bfd8164-4ab1-4b27-8721-d928926aeecb'),
	(20,NULL,'app','m160708_185142_volume_hasUrls_setting','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','971306d6-753f-45e2-a0a9-75362f3a731e'),
	(21,NULL,'app','m160714_000000_increase_max_asset_filesize','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','ec245779-e880-416c-a4a3-a60b76702f1f'),
	(22,NULL,'app','m160727_194637_column_cleanup','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','8cf1c50e-10c7-48df-89e6-d587ae83eec5'),
	(23,NULL,'app','m160804_110002_userphotos_to_assets','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','1fbe8177-5ef3-406b-9497-81cb0ceb982f'),
	(24,NULL,'app','m160807_144858_sites','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','04c2b2e3-cdde-475f-8f42-b439285137ad'),
	(25,NULL,'app','m160817_161600_move_assets_cache','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','1a2195e7-7c75-4c1e-bff7-af8eca13448c'),
	(26,NULL,'app','m160829_000000_pending_user_content_cleanup','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','6fd8a7ea-d97a-40af-8e4d-8ba331e9b603'),
	(27,NULL,'app','m160830_000000_asset_index_uri_increase','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','54629aef-dbe7-4856-a82b-d4fea00052ea'),
	(28,NULL,'app','m160912_230520_require_entry_type_id','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','393c203b-2cb2-453e-9ac8-172da61d5229'),
	(29,NULL,'app','m160913_134730_require_matrix_block_type_id','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','872a3d5d-74bb-46f5-94a3-ce1fcdbfc76d'),
	(30,NULL,'app','m160920_174553_matrixblocks_owner_site_id_nullable','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','fd3b8e92-9a03-4aeb-86ac-c85e5c684f11'),
	(31,NULL,'app','m160920_231045_usergroup_handle_title_unique','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','c0b57d07-5dc1-4399-b780-2395d6603835'),
	(32,NULL,'app','m160925_113941_route_uri_parts','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','57bbfe0d-3097-4896-b9fc-ac847ce1295a'),
	(33,NULL,'app','m161006_205918_schemaVersion_not_null','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','6fb7b430-0779-42ab-b5ec-3e730465ccb9'),
	(34,NULL,'app','m161007_130653_update_email_settings','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','aab18131-dac6-43c7-8a5f-0e24fcb16a94'),
	(35,NULL,'app','m161013_175052_newParentId','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','78c09e49-0b9b-4b62-818e-00354af9d4ab'),
	(36,NULL,'app','m161021_102916_fix_recent_entries_widgets','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','fd86ba2e-eb11-40b8-976a-6a3218720cef'),
	(37,NULL,'app','m161021_182140_rename_get_help_widget','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','a8177e1a-49fe-42b9-8228-c2d13b5e082c'),
	(38,NULL,'app','m161025_000000_fix_char_columns','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','8d8c157a-e0c1-4d0d-8653-73c5d4a7779d'),
	(39,NULL,'app','m161029_124145_email_message_languages','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','0dad8743-a724-4e71-8e8d-c9ec20c88e38'),
	(40,NULL,'app','m161108_000000_new_version_format','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','54430c52-0589-4e9d-8b33-ff3871d2f2ef'),
	(41,NULL,'app','m161109_000000_index_shuffle','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','2f48cefe-f133-4487-815f-ecf952bd7544'),
	(42,NULL,'app','m161122_185500_no_craft_app','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','5e6329a4-acbd-404c-a113-dfe3c0a4c8b5'),
	(43,NULL,'app','m161125_150752_clear_urlmanager_cache','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','db1745ef-c96a-47d7-a90f-9ad0a0cd7cbd'),
	(44,NULL,'app','m161220_000000_volumes_hasurl_notnull','2017-02-06 18:39:46','2017-02-06 18:39:46','2017-02-06 18:39:46','2d2adad6-fd8a-41e7-86f3-7a321694c752'),
	(45,NULL,'app','m170114_161144_udates_permission','2017-02-06 18:39:46','2017-02-06 18:39:46','2017-02-06 18:39:46','09b07934-1260-4e2b-8b10-1b746eaa731b'),
	(46,NULL,'app','m170120_000000_schema_cleanup','2017-02-06 18:39:46','2017-02-06 18:39:46','2017-02-06 18:39:46','56acfac8-1921-4bcf-86ee-fc59dccf4f66'),
	(47,NULL,'app','m170126_000000_assets_focal_point','2017-02-06 18:39:46','2017-02-06 18:39:46','2017-02-06 18:39:46','76895f19-2492-41d6-8e8b-b5f58cbd72c3'),
	(48,NULL,'app','m170206_142126_system_name','2017-02-10 19:25:09','2017-02-10 19:25:09','2017-02-10 19:25:09','a5d37c08-df66-45e8-b933-cab697d58a2c'),
	(49,NULL,'app','m170217_044740_category_branch_limits','2017-02-17 23:50:03','2017-02-17 23:50:03','2017-02-17 23:50:03','35812039-5dba-4b46-87f1-0c1a1e82cff1');

/*!40000 ALTER TABLE `cx_migrations` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cx_plugins
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_plugins`;

CREATE TABLE `cx_plugins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `handle` varchar(150) NOT NULL,
  `version` varchar(15) NOT NULL,
  `schemaVersion` varchar(15) NOT NULL,
  `licenseKey` char(24) DEFAULT NULL,
  `licenseKeyStatus` enum('valid','invalid','mismatched','unknown') NOT NULL DEFAULT 'unknown',
  `enabled` tinyint(1) NOT NULL DEFAULT '0',
  `settings` text,
  `installDate` datetime NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_plugins_handle_unq_idx` (`handle`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cx_plugins` WRITE;
/*!40000 ALTER TABLE `cx_plugins` DISABLE KEYS */;

INSERT INTO `cx_plugins` (`id`, `handle`, `version`, `schemaVersion`, `licenseKey`, `licenseKeyStatus`, `enabled`, `settings`, `installDate`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,'doxter','3.0.6','3.0.0',NULL,'unknown',1,NULL,'2017-02-07 04:03:12','2017-02-07 04:03:12','2017-02-17 23:50:21','ecdf53eb-7e70-4cc1-b7f2-69b75c4dbc13'),
	(2,'swipe','1.0.0','1.0.0',NULL,'unknown',1,NULL,'2017-02-10 19:25:16','2017-02-10 19:25:16','2017-02-17 23:50:21','3954142a-2a74-431a-81c4-b16ef4e334cd');

/*!40000 ALTER TABLE `cx_plugins` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cx_relations
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_relations`;

CREATE TABLE `cx_relations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fieldId` int(11) NOT NULL,
  `sourceId` int(11) NOT NULL,
  `sourceSiteId` int(11) DEFAULT NULL,
  `targetId` int(11) NOT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_relations_fieldId_sourceId_sourceSiteId_targetId_unq_idx` (`fieldId`,`sourceId`,`sourceSiteId`,`targetId`),
  KEY `cx_relations_sourceId_fk` (`sourceId`),
  KEY `cx_relations_targetId_fk` (`targetId`),
  KEY `cx_relations_sourceSiteId_fk` (`sourceSiteId`),
  CONSTRAINT `cx_relations_fieldId_fk` FOREIGN KEY (`fieldId`) REFERENCES `cx_fields` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cx_relations_sourceId_fk` FOREIGN KEY (`sourceId`) REFERENCES `cx_elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cx_relations_sourceSiteId_fk` FOREIGN KEY (`sourceSiteId`) REFERENCES `cx_sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `cx_relations_targetId_fk` FOREIGN KEY (`targetId`) REFERENCES `cx_elements` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table cx_routes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_routes`;

CREATE TABLE `cx_routes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `siteId` int(11) DEFAULT NULL,
  `uriParts` varchar(255) NOT NULL,
  `uriPattern` varchar(255) NOT NULL,
  `template` varchar(500) NOT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_routes_uriPattern_unq_idx` (`uriPattern`),
  KEY `cx_routes_siteId_fk` (`siteId`),
  CONSTRAINT `cx_routes_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `cx_sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table cx_searchindex
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_searchindex`;

CREATE TABLE `cx_searchindex` (
  `elementId` int(11) NOT NULL,
  `attribute` varchar(25) NOT NULL,
  `fieldId` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `keywords` text NOT NULL,
  PRIMARY KEY (`elementId`,`attribute`,`fieldId`,`siteId`),
  FULLTEXT KEY `cx_searchindex_keywords_idx` (`keywords`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

LOCK TABLES `cx_searchindex` WRITE;
/*!40000 ALTER TABLE `cx_searchindex` DISABLE KEYS */;

INSERT INTO `cx_searchindex` (`elementId`, `attribute`, `fieldId`, `siteId`, `keywords`)
VALUES
	(1,'username',0,1,' selvinortiz '),
	(1,'firstname',0,1,' selvin '),
	(1,'lastname',0,1,' ortiz '),
	(1,'fullname',0,1,' selvin ortiz '),
	(1,'email',0,1,' selvin craftx io '),
	(1,'slug',0,1,''),
	(2,'slug',0,1,' homepage '),
	(2,'title',0,1,' homepage '),
	(2,'field',1,1,' craft training for busy developers '),
	(2,'field',2,1,''),
	(2,'field',4,1,''),
	(3,'field',10,1,' cus_a8eiebktjrp3tb '),
	(3,'field',13,1,' sub_a8eijgpyqdec67 '),
	(3,'field',11,1,''),
	(3,'field',12,1,''),
	(3,'field',9,1,''),
	(3,'field',5,1,''),
	(3,'field',6,1,''),
	(3,'field',7,1,''),
	(3,'field',8,1,''),
	(3,'username',0,1,' selvin selvin co '),
	(3,'firstname',0,1,' selvin '),
	(3,'lastname',0,1,' ortiz '),
	(3,'fullname',0,1,' selvin ortiz '),
	(3,'email',0,1,' selvin selvin co '),
	(3,'slug',0,1,'');

/*!40000 ALTER TABLE `cx_searchindex` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cx_sections
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_sections`;

CREATE TABLE `cx_sections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `structureId` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `type` enum('single','channel','structure') NOT NULL DEFAULT 'channel',
  `enableVersioning` tinyint(1) NOT NULL DEFAULT '0',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_sections_handle_unq_idx` (`handle`),
  UNIQUE KEY `cx_sections_name_unq_idx` (`name`),
  KEY `cx_sections_structureId_fk` (`structureId`),
  CONSTRAINT `cx_sections_structureId_fk` FOREIGN KEY (`structureId`) REFERENCES `cx_structures` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cx_sections` WRITE;
/*!40000 ALTER TABLE `cx_sections` DISABLE KEYS */;

INSERT INTO `cx_sections` (`id`, `structureId`, `name`, `handle`, `type`, `enableVersioning`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,NULL,'Homepage','homepage','single',0,'2017-02-06 18:57:45','2017-02-06 18:57:45','6f4ca3af-f6ea-4aa0-b25c-1a697f0225f1'),
	(2,NULL,'Courses','courses','channel',0,'2017-02-07 05:14:04','2017-02-07 05:14:04','afe81c2c-c2cc-41ef-b726-2858db2dfe08');

/*!40000 ALTER TABLE `cx_sections` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cx_sections_i18n
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_sections_i18n`;

CREATE TABLE `cx_sections_i18n` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sectionId` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `enabledByDefault` tinyint(1) NOT NULL DEFAULT '1',
  `hasUrls` tinyint(1) NOT NULL DEFAULT '1',
  `uriFormat` text,
  `template` varchar(500) DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_sections_i18n_sectionId_siteId_unq_idx` (`sectionId`,`siteId`),
  KEY `cx_sections_i18n_siteId_fk` (`siteId`),
  CONSTRAINT `cx_sections_i18n_sectionId_fk` FOREIGN KEY (`sectionId`) REFERENCES `cx_sections` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cx_sections_i18n_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `cx_sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cx_sections_i18n` WRITE;
/*!40000 ALTER TABLE `cx_sections_i18n` DISABLE KEYS */;

INSERT INTO `cx_sections_i18n` (`id`, `sectionId`, `siteId`, `enabledByDefault`, `hasUrls`, `uriFormat`, `template`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,1,1,1,1,'__home__','index','2017-02-06 18:57:45','2017-02-06 23:59:44','7544fcbf-9302-4044-b213-89fa766f1286'),
	(2,2,1,1,1,'courses/{slug}','courses/_entry','2017-02-07 05:14:04','2017-02-07 05:14:04','41d432bc-46cb-436d-9cbc-075a043f8470');

/*!40000 ALTER TABLE `cx_sections_i18n` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cx_sessions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_sessions`;

CREATE TABLE `cx_sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `token` char(100) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `cx_sessions_uid_idx` (`uid`),
  KEY `cx_sessions_token_idx` (`token`),
  KEY `cx_sessions_dateUpdated_idx` (`dateUpdated`),
  KEY `cx_sessions_userId_fk` (`userId`),
  CONSTRAINT `cx_sessions_userId_fk` FOREIGN KEY (`userId`) REFERENCES `cx_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cx_sessions` WRITE;
/*!40000 ALTER TABLE `cx_sessions` DISABLE KEYS */;

INSERT INTO `cx_sessions` (`id`, `userId`, `token`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,1,'p0LVU-_07ZUJdh_JGVpakXYQYIzLhqEApCxQg5b4BZdYYhvP2RzR36l0UTrXwlaPeGiSCI-6SdrtwyyiFhclMbaJR_z6Guawnqkd','2017-02-06 23:54:19','2017-02-07 02:07:30','be03a40a-c990-4ecc-806c-3cd38480273e'),
	(2,1,'qWpu17cuAtw5-zA12eNKy2fG_GZGHw01mocf7sBOe5qqtr3_A0atNrvoeBmD0RnP5_9z_X7SEnukkkFs6wc1QRMuuCOtpf8dgTxF','2017-02-07 03:53:45','2017-02-07 04:07:36','977f4875-ea65-4664-a5b5-adca9854cf11'),
	(3,1,'qf0t1fiusgf-nc7fLP7Dn6hSkn6wsGXo-Xf2Xh0qoppHl8cwzicM1xKcVrLQ5iaiEzYSjibj2db_7roIi3iFiDt_WGtIs9_MDj_e','2017-02-07 05:13:35','2017-02-07 05:31:16','74e68c1d-3586-4326-a90a-50587a7f7ef9'),
	(5,1,'rxjm49_XJnSC5vZwhVvjILtjzW7BlQCBSaRCZo4iVU8V6T4Ix8zo3hlYAXeSe7TRHp_UaykcLZnJokglPPMle8ZQ7g8MO4thDaV_','2017-02-11 03:42:22','2017-02-11 03:47:59','03c6b384-8bc9-449a-a756-7602d3025f14'),
	(6,1,'8frYGtEccGxg2UlSzsH-CqcgErXkZUxYkbPNwepG-_isMcBHeYeijovM-W8kuSEGtS1DR96VEDG4d8Xq_IYzxaj_tI3Lf29Wp5N1','2017-02-13 04:22:59','2017-02-13 04:37:19','977cdb4f-a754-4829-aa4d-ccf21824513c'),
	(7,1,'U1noLV4rAJ497QSHMtY7Rh-AdXlbaFM7-De327o8cpxFgPQfiG2KNZ7adDGDgekCLzeN1hy54o9cXemX0s0g9ZYs7708GtiRWKGM','2017-02-13 06:15:52','2017-02-13 06:15:52','81103b06-681d-4064-b289-7392650a5f06'),
	(8,1,'a47N530MG1bDfBwg9ZvUXcq2uGS3rtKVqkhrkQwTImE944Zb1pOvT6ScWDXBxelUr9PYwEhuFxV0tLx8jhqKEZ6R2KeVRqBlJdbc','2017-02-13 07:10:58','2017-02-13 07:31:05','9ceac91a-9f69-46d4-8ef1-f5c3c85ab77b'),
	(10,1,'f0SsTvAn9ptioDYrYbEncTN2gRp9NNgS1G8WPUjhn2PSMwPSDRW_ReIjYDEE73Hspyj2o2loHt7yhhPKdwA9taeOz8SU2eZizbBZ','2017-02-16 04:01:06','2017-02-16 04:03:42','75d7bd5d-8591-4ac4-8bbe-a20682328209'),
	(14,1,'20geVmBlM_SIRPdYmLiyxXUotWAEV2jRIcWp3e9lxRMTJf-75kW7JjClne1eeb5r9pbNX8wzkfINQklJooO3OIyU9_tuhFqnv8Gg','2017-02-18 01:31:40','2017-02-18 02:08:20','3389e6ce-6408-41b0-9118-e9da2ae66e65'),
	(15,3,'JEhuZ7AybXhRKCWH8efoAgt_ZxCygb3QPJ5uqZYgteouij0Je4RXXfa4Lj_ualYhOVLV8yHc_0t4pluGbpofoLxx0pwgWmtDcTI0','2017-02-23 04:24:34','2017-02-23 04:52:48','ce77a4fa-592c-4407-95dd-24238fed688b');

/*!40000 ALTER TABLE `cx_sessions` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cx_shunnedmessages
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_shunnedmessages`;

CREATE TABLE `cx_shunnedmessages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `message` varchar(255) NOT NULL,
  `expiryDate` datetime DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_shunnedmessages_userId_message_unq_idx` (`userId`,`message`),
  CONSTRAINT `cx_shunnedmessages_userId_fk` FOREIGN KEY (`userId`) REFERENCES `cx_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table cx_sites
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_sites`;

CREATE TABLE `cx_sites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `language` varchar(12) NOT NULL,
  `hasUrls` tinyint(1) NOT NULL DEFAULT '0',
  `baseUrl` varchar(255) DEFAULT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_sites_handle_unq_idx` (`handle`),
  KEY `cx_sites_sortOrder_idx` (`sortOrder`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cx_sites` WRITE;
/*!40000 ALTER TABLE `cx_sites` DISABLE KEYS */;

INSERT INTO `cx_sites` (`id`, `name`, `handle`, `language`, `hasUrls`, `baseUrl`, `sortOrder`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,'Craft X','default','en-US',1,'http://{siteUrl}/',1,'2017-02-06 18:39:45','2017-02-06 18:39:45','2919439f-9a4e-4fee-aa13-334959abcfe0');

/*!40000 ALTER TABLE `cx_sites` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cx_structureelements
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_structureelements`;

CREATE TABLE `cx_structureelements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `structureId` int(11) NOT NULL,
  `elementId` int(11) DEFAULT NULL,
  `root` int(11) unsigned DEFAULT NULL,
  `lft` int(11) unsigned NOT NULL,
  `rgt` int(11) unsigned NOT NULL,
  `level` smallint(6) unsigned NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_structureelements_structureId_elementId_unq_idx` (`structureId`,`elementId`),
  KEY `cx_structureelements_root_idx` (`root`),
  KEY `cx_structureelements_lft_idx` (`lft`),
  KEY `cx_structureelements_rgt_idx` (`rgt`),
  KEY `cx_structureelements_level_idx` (`level`),
  KEY `cx_structureelements_elementId_fk` (`elementId`),
  CONSTRAINT `cx_structureelements_elementId_fk` FOREIGN KEY (`elementId`) REFERENCES `cx_elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cx_structureelements_structureId_fk` FOREIGN KEY (`structureId`) REFERENCES `cx_structures` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table cx_structures
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_structures`;

CREATE TABLE `cx_structures` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `maxLevels` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table cx_systemsettings
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_systemsettings`;

CREATE TABLE `cx_systemsettings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category` varchar(15) NOT NULL,
  `settings` text,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_systemsettings_category_unq_idx` (`category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cx_systemsettings` WRITE;
/*!40000 ALTER TABLE `cx_systemsettings` DISABLE KEYS */;

INSERT INTO `cx_systemsettings` (`id`, `category`, `settings`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,'email','{\"fromEmail\":\"support@craftx.io\",\"fromName\":\"Craft X\",\"template\":\"\",\"transportType\":\"craft\\\\mail\\\\transportadapters\\\\Smtp\",\"transportSettings\":{\"host\":\"email-smtp.us-west-2.amazonaws.com\",\"port\":\"587\",\"useAuthentication\":\"1\",\"username\":\"AKIAIEWSWLZUUCXCH2KA\",\"password\":\"Ajm0cYgkvNJNAA2qEPqDeTmKsaxS/tmFml8o6YdWOxFT\",\"encryptionMethod\":\"tls\",\"timeout\":\"10\"}}','2017-02-06 18:39:45','2017-02-18 01:53:15','4525a971-81ae-42b5-9d4a-5acf34858293'),
	(2,'mailer','{\"class\":\"craft\\\\mail\\\\Mailer\",\"from\":{\"selvin@craftx.io\":\"Craft X\"},\"transport\":{\"class\":\"Swift_MailTransport\"}}','2017-02-06 18:39:45','2017-02-06 18:39:45','b7448476-6236-46f1-ad36-f0992fc3f5bc'),
	(3,'users','{\"requireEmailVerification\":false,\"allowPublicRegistration\":true,\"defaultGroup\":\"1\",\"photoVolumeId\":null}','2017-02-13 06:23:39','2017-02-13 06:23:39','4c6b2690-22ed-4939-9129-bb876eb7be07');

/*!40000 ALTER TABLE `cx_systemsettings` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cx_taggroups
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_taggroups`;

CREATE TABLE `cx_taggroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `fieldLayoutId` int(11) DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_taggroups_name_unq_idx` (`name`),
  UNIQUE KEY `cx_taggroups_handle_unq_idx` (`handle`),
  KEY `cx_taggroups_fieldLayoutId_fk` (`fieldLayoutId`),
  CONSTRAINT `cx_taggroups_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `cx_fieldlayouts` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table cx_tags
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_tags`;

CREATE TABLE `cx_tags` (
  `id` int(11) NOT NULL,
  `groupId` int(11) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `cx_tags_groupId_fk` (`groupId`),
  CONSTRAINT `cx_tags_groupId_fk` FOREIGN KEY (`groupId`) REFERENCES `cx_taggroups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cx_tags_id_fk` FOREIGN KEY (`id`) REFERENCES `cx_elements` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table cx_tasks
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_tasks`;

CREATE TABLE `cx_tasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `root` int(11) unsigned DEFAULT NULL,
  `lft` int(11) unsigned NOT NULL,
  `rgt` int(11) unsigned NOT NULL,
  `level` smallint(6) unsigned NOT NULL,
  `currentStep` int(11) unsigned DEFAULT NULL,
  `totalSteps` int(11) unsigned DEFAULT NULL,
  `status` enum('pending','error','running') DEFAULT NULL,
  `type` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `settings` mediumtext NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `cx_tasks_root_idx` (`root`),
  KEY `cx_tasks_lft_idx` (`lft`),
  KEY `cx_tasks_rgt_idx` (`rgt`),
  KEY `cx_tasks_level_idx` (`level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table cx_templatecacheelements
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_templatecacheelements`;

CREATE TABLE `cx_templatecacheelements` (
  `cacheId` int(11) NOT NULL,
  `elementId` int(11) NOT NULL,
  KEY `cx_templatecacheelements_cacheId_fk` (`cacheId`),
  KEY `cx_templatecacheelements_elementId_fk` (`elementId`),
  CONSTRAINT `cx_templatecacheelements_cacheId_fk` FOREIGN KEY (`cacheId`) REFERENCES `cx_templatecaches` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cx_templatecacheelements_elementId_fk` FOREIGN KEY (`elementId`) REFERENCES `cx_elements` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table cx_templatecachequeries
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_templatecachequeries`;

CREATE TABLE `cx_templatecachequeries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cacheId` int(11) NOT NULL,
  `type` varchar(255) NOT NULL,
  `query` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `cx_templatecachequeries_cacheId_fk` (`cacheId`),
  KEY `cx_templatecachequeries_type_idx` (`type`),
  CONSTRAINT `cx_templatecachequeries_cacheId_fk` FOREIGN KEY (`cacheId`) REFERENCES `cx_templatecaches` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table cx_templatecaches
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_templatecaches`;

CREATE TABLE `cx_templatecaches` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `siteId` int(11) NOT NULL,
  `cacheKey` varchar(255) NOT NULL,
  `path` varchar(255) DEFAULT NULL,
  `expiryDate` datetime NOT NULL,
  `body` mediumtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `cx_templatecaches_expiryDate_cacheKey_siteId_path_idx` (`expiryDate`,`cacheKey`,`siteId`,`path`),
  KEY `cx_templatecaches_siteId_fk` (`siteId`),
  CONSTRAINT `cx_templatecaches_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `cx_sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table cx_tokens
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_tokens`;

CREATE TABLE `cx_tokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `token` char(32) NOT NULL,
  `route` text,
  `usageLimit` smallint(6) unsigned DEFAULT NULL,
  `usageCount` smallint(6) unsigned DEFAULT NULL,
  `expiryDate` datetime NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_tokens_token_unq_idx` (`token`),
  KEY `cx_tokens_expiryDate_idx` (`expiryDate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table cx_usergroups
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_usergroups`;

CREATE TABLE `cx_usergroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_usergroups_handle_unq_idx` (`handle`),
  UNIQUE KEY `cx_usergroups_name_unq_idx` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cx_usergroups` WRITE;
/*!40000 ALTER TABLE `cx_usergroups` DISABLE KEYS */;

INSERT INTO `cx_usergroups` (`id`, `name`, `handle`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,'Subscribed','subscribed','2017-02-13 06:23:01','2017-02-13 06:23:01','ca47480f-4d59-4043-af6b-67d0311fe1d4');

/*!40000 ALTER TABLE `cx_usergroups` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cx_usergroups_users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_usergroups_users`;

CREATE TABLE `cx_usergroups_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `groupId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_usergroups_users_groupId_userId_unq_idx` (`groupId`,`userId`),
  KEY `cx_usergroups_users_userId_fk` (`userId`),
  CONSTRAINT `cx_usergroups_users_groupId_fk` FOREIGN KEY (`groupId`) REFERENCES `cx_usergroups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cx_usergroups_users_userId_fk` FOREIGN KEY (`userId`) REFERENCES `cx_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table cx_userpermissions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_userpermissions`;

CREATE TABLE `cx_userpermissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_userpermissions_name_unq_idx` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table cx_userpermissions_usergroups
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_userpermissions_usergroups`;

CREATE TABLE `cx_userpermissions_usergroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `permissionId` int(11) NOT NULL,
  `groupId` int(11) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_userpermissions_usergroups_permissionId_groupId_unq_idx` (`permissionId`,`groupId`),
  KEY `cx_userpermissions_usergroups_groupId_fk` (`groupId`),
  CONSTRAINT `cx_userpermissions_usergroups_groupId_fk` FOREIGN KEY (`groupId`) REFERENCES `cx_usergroups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cx_userpermissions_usergroups_permissionId_fk` FOREIGN KEY (`permissionId`) REFERENCES `cx_userpermissions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table cx_userpermissions_users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_userpermissions_users`;

CREATE TABLE `cx_userpermissions_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `permissionId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_userpermissions_users_permissionId_userId_unq_idx` (`permissionId`,`userId`),
  KEY `cx_userpermissions_users_userId_fk` (`userId`),
  CONSTRAINT `cx_userpermissions_users_permissionId_fk` FOREIGN KEY (`permissionId`) REFERENCES `cx_userpermissions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cx_userpermissions_users_userId_fk` FOREIGN KEY (`userId`) REFERENCES `cx_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table cx_userpreferences
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_userpreferences`;

CREATE TABLE `cx_userpreferences` (
  `userId` int(11) NOT NULL AUTO_INCREMENT,
  `preferences` text,
  PRIMARY KEY (`userId`),
  CONSTRAINT `cx_userpreferences_userId_fk` FOREIGN KEY (`userId`) REFERENCES `cx_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cx_userpreferences` WRITE;
/*!40000 ALTER TABLE `cx_userpreferences` DISABLE KEYS */;

INSERT INTO `cx_userpreferences` (`userId`, `preferences`)
VALUES
	(1,'{\"language\":null,\"weekStartDay\":\"0\",\"enableDebugToolbarForSite\":false,\"enableDebugToolbarForCp\":false}');

/*!40000 ALTER TABLE `cx_userpreferences` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cx_users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_users`;

CREATE TABLE `cx_users` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `photoId` int(11) DEFAULT NULL,
  `firstName` varchar(100) DEFAULT NULL,
  `lastName` varchar(100) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) DEFAULT NULL,
  `admin` tinyint(1) NOT NULL DEFAULT '0',
  `client` tinyint(1) NOT NULL DEFAULT '0',
  `locked` tinyint(1) NOT NULL DEFAULT '0',
  `suspended` tinyint(1) NOT NULL DEFAULT '0',
  `pending` tinyint(1) NOT NULL DEFAULT '0',
  `archived` tinyint(1) NOT NULL DEFAULT '0',
  `lastLoginDate` datetime DEFAULT NULL,
  `lastLoginAttemptIp` varchar(45) DEFAULT NULL,
  `invalidLoginWindowStart` datetime DEFAULT NULL,
  `invalidLoginCount` smallint(6) unsigned DEFAULT NULL,
  `lastInvalidLoginDate` datetime DEFAULT NULL,
  `lockoutDate` datetime DEFAULT NULL,
  `verificationCode` varchar(255) DEFAULT NULL,
  `verificationCodeIssuedDate` datetime DEFAULT NULL,
  `unverifiedEmail` varchar(255) DEFAULT NULL,
  `passwordResetRequired` tinyint(1) NOT NULL DEFAULT '0',
  `lastPasswordChangeDate` datetime DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_users_username_unq_idx` (`username`),
  UNIQUE KEY `cx_users_email_unq_idx` (`email`),
  KEY `cx_users_uid_idx` (`uid`),
  KEY `cx_users_verificationCode_idx` (`verificationCode`),
  KEY `cx_users_photoId_fk` (`photoId`),
  CONSTRAINT `cx_users_id_fk` FOREIGN KEY (`id`) REFERENCES `cx_elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cx_users_photoId_fk` FOREIGN KEY (`photoId`) REFERENCES `cx_assets` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cx_users` WRITE;
/*!40000 ALTER TABLE `cx_users` DISABLE KEYS */;

INSERT INTO `cx_users` (`id`, `username`, `photoId`, `firstName`, `lastName`, `email`, `password`, `admin`, `client`, `locked`, `suspended`, `pending`, `archived`, `lastLoginDate`, `lastLoginAttemptIp`, `invalidLoginWindowStart`, `invalidLoginCount`, `lastInvalidLoginDate`, `lockoutDate`, `verificationCode`, `verificationCodeIssuedDate`, `unverifiedEmail`, `passwordResetRequired`, `lastPasswordChangeDate`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,'selvinortiz',NULL,'Selvin','Ortiz','selvin@craftx.io','$2y$13$lpMCTvAg0o/B.7enJrbT.OuB4zToqUGASlsZsfFE8vf94dzoxGbEu',1,0,0,0,0,0,'2017-02-23 02:46:55','192.168.10.1',NULL,NULL,NULL,NULL,'$2y$13$Ep8xb9FBK0d3.6CK6lz/7.Sm8uXAnaG8lc/ZczWBdXIFQjpSNr7bC','2017-02-23 04:00:08',NULL,0,'2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-23 04:00:08','6dd21ec5-be58-47c4-9c4e-4f04346dd128'),
	(3,'selvin-selvinco',NULL,'Selvin','Ortiz','selvin@selvin.co','$2y$13$Sslt7yvMuB2eV0jKxhMrJeUWWeYVGukE2jCnXjM.P/I6vNeviqNv2',0,0,0,0,0,0,'2017-02-23 19:26:26','192.168.10.1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2017-02-23 04:24:10','2017-02-18 01:30:24','2017-02-23 19:26:26','08ba55cf-b8f7-4b94-b43f-d335ed2dacfa');

/*!40000 ALTER TABLE `cx_users` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table cx_volumefolders
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_volumefolders`;

CREATE TABLE `cx_volumefolders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parentId` int(11) DEFAULT NULL,
  `volumeId` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `path` varchar(255) DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_volumefolders_name_parentId_volumeId_unq_idx` (`name`,`parentId`,`volumeId`),
  KEY `cx_volumefolders_parentId_fk` (`parentId`),
  KEY `cx_volumefolders_volumeId_fk` (`volumeId`),
  CONSTRAINT `cx_volumefolders_parentId_fk` FOREIGN KEY (`parentId`) REFERENCES `cx_volumefolders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cx_volumefolders_volumeId_fk` FOREIGN KEY (`volumeId`) REFERENCES `cx_volumes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table cx_volumes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_volumes`;

CREATE TABLE `cx_volumes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fieldLayoutId` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `handle` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL,
  `hasUrls` tinyint(1) NOT NULL DEFAULT '1',
  `url` varchar(255) DEFAULT NULL,
  `settings` text,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_volumes_name_unq_idx` (`name`),
  UNIQUE KEY `cx_volumes_handle_unq_idx` (`handle`),
  KEY `cx_volumes_fieldLayoutId_fk` (`fieldLayoutId`),
  CONSTRAINT `cx_volumes_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `cx_fieldlayouts` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table cx_widgets
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cx_widgets`;

CREATE TABLE `cx_widgets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `type` varchar(255) NOT NULL,
  `sortOrder` smallint(6) unsigned DEFAULT NULL,
  `colspan` tinyint(1) NOT NULL DEFAULT '0',
  `settings` text,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `cx_widgets_userId_fk` (`userId`),
  CONSTRAINT `cx_widgets_userId_fk` FOREIGN KEY (`userId`) REFERENCES `cx_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `cx_widgets` WRITE;
/*!40000 ALTER TABLE `cx_widgets` DISABLE KEYS */;

INSERT INTO `cx_widgets` (`id`, `userId`, `type`, `sortOrder`, `colspan`, `settings`, `enabled`, `dateCreated`, `dateUpdated`, `uid`)
VALUES
	(1,1,'craft\\widgets\\RecentEntries',NULL,0,'{\"section\":\"*\",\"siteId\":\"1\",\"limit\":10}',1,'2017-02-06 18:47:24','2017-02-06 18:47:24','936f422c-de0f-4856-ba85-c3d2f1910316'),
	(2,1,'craft\\widgets\\CraftSupport',NULL,0,'[]',1,'2017-02-06 18:47:24','2017-02-06 18:47:24','5cbb24e0-1200-4fd4-9a22-a6d0ff6ed0c6'),
	(3,1,'craft\\widgets\\Updates',NULL,0,'[]',1,'2017-02-06 18:47:24','2017-02-06 18:47:24','d2e06d28-8b9e-42a1-b121-43f96de01209'),
	(4,1,'craft\\widgets\\Feed',NULL,0,'{\"url\":\"https://craftcms.com/news.rss\",\"title\":\"Craft News\",\"limit\":5}',1,'2017-02-06 18:47:24','2017-02-06 18:47:24','54331635-6276-4083-9291-a51b5adbf160');

/*!40000 ALTER TABLE `cx_widgets` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
