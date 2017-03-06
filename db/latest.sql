-- MySQL dump 10.16  Distrib 10.1.17-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: devcraftxio
-- ------------------------------------------------------
-- Server version	10.1.17-MariaDB-1~xenial

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cx_assetindexdata`
--

DROP TABLE IF EXISTS `cx_assetindexdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cx_assetindexdata` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sessionId` varchar(36) NOT NULL DEFAULT '',
  `volumeId` int(11) NOT NULL,
  `uri` text,
  `size` bigint(20) unsigned DEFAULT NULL,
  `timestamp` datetime DEFAULT NULL,
  `recordId` int(11) DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  `inProgress` tinyint(1) DEFAULT '0',
  `completed` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `cx_assetindexdata_volumeId_fk` (`volumeId`),
  KEY `cx_assetindexdata_sessionId_volumeId_idx` (`sessionId`,`volumeId`),
  CONSTRAINT `cx_assetindexdata_volumeId_fk` FOREIGN KEY (`volumeId`) REFERENCES `cx_volumes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_assetindexdata`
--

LOCK TABLES `cx_assetindexdata` WRITE;
/*!40000 ALTER TABLE `cx_assetindexdata` DISABLE KEYS */;
/*!40000 ALTER TABLE `cx_assetindexdata` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_assets`
--

DROP TABLE IF EXISTS `cx_assets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cx_assets` (
  `id` int(11) NOT NULL,
  `volumeId` int(11) DEFAULT NULL,
  `folderId` int(11) NOT NULL,
  `filename` varchar(255) NOT NULL,
  `kind` varchar(50) NOT NULL DEFAULT 'unknown',
  `width` int(11) unsigned DEFAULT NULL,
  `height` int(11) unsigned DEFAULT NULL,
  `size` bigint(20) unsigned DEFAULT NULL,
  `focalPoint` varchar(13) DEFAULT NULL,
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_assets`
--

LOCK TABLES `cx_assets` WRITE;
/*!40000 ALTER TABLE `cx_assets` DISABLE KEYS */;
/*!40000 ALTER TABLE `cx_assets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_assettransformindex`
--

DROP TABLE IF EXISTS `cx_assettransformindex`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_assettransformindex`
--

LOCK TABLES `cx_assettransformindex` WRITE;
/*!40000 ALTER TABLE `cx_assettransformindex` DISABLE KEYS */;
/*!40000 ALTER TABLE `cx_assettransformindex` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_assettransforms`
--

DROP TABLE IF EXISTS `cx_assettransforms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_assettransforms`
--

LOCK TABLES `cx_assettransforms` WRITE;
/*!40000 ALTER TABLE `cx_assettransforms` DISABLE KEYS */;
/*!40000 ALTER TABLE `cx_assettransforms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_categories`
--

DROP TABLE IF EXISTS `cx_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_categories`
--

LOCK TABLES `cx_categories` WRITE;
/*!40000 ALTER TABLE `cx_categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `cx_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_categorygroups`
--

DROP TABLE IF EXISTS `cx_categorygroups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_categorygroups`
--

LOCK TABLES `cx_categorygroups` WRITE;
/*!40000 ALTER TABLE `cx_categorygroups` DISABLE KEYS */;
/*!40000 ALTER TABLE `cx_categorygroups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_categorygroups_i18n`
--

DROP TABLE IF EXISTS `cx_categorygroups_i18n`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_categorygroups_i18n`
--

LOCK TABLES `cx_categorygroups_i18n` WRITE;
/*!40000 ALTER TABLE `cx_categorygroups_i18n` DISABLE KEYS */;
/*!40000 ALTER TABLE `cx_categorygroups_i18n` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_content`
--

DROP TABLE IF EXISTS `cx_content`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cx_content` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `elementId` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  `field_markdown` text,
  `field_billingAddress1` text,
  `field_billingCity` text,
  `field_billingState` text,
  `field_billingZip` text,
  `field_billingCountry` text,
  `field_customerId` text,
  `field_billingEmail` text,
  `field_billingCountryCode` varchar(255) DEFAULT NULL,
  `field_subscriptionId` text,
  `field_subscriptionJson` text,
  `field_billingAddress2` text,
  `field_lead` text,
  `field_text` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_content_elementId_siteId_unq_idx` (`elementId`,`siteId`),
  KEY `cx_content_siteId_fk` (`siteId`),
  KEY `cx_content_title_fk` (`title`),
  CONSTRAINT `cx_content_elementId_fk` FOREIGN KEY (`elementId`) REFERENCES `cx_elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cx_content_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `cx_sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_content`
--

LOCK TABLES `cx_content` WRITE;
/*!40000 ALTER TABLE `cx_content` DISABLE KEYS */;
INSERT INTO `cx_content` VALUES (1,1,1,NULL,'2017-02-06 18:39:45','2017-03-06 06:05:18','733fd721-e25d-49fc-a09b-41c6cc4692af',NULL,'','','','','','','','','',NULL,NULL,NULL,NULL),(2,2,1,'Homepage','2017-02-06 18:57:45','2017-03-06 06:32:08','fd1f3cbe-c14f-4317-a064-a644d62374cc',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Craft Training for Busy Developers','Master Craft CMS through carefully crafted screencasts, produced and presented by an industry veteran.'),(3,3,1,NULL,'2017-02-18 01:30:24','2017-02-23 04:24:10','fc944bf9-f4e3-4029-80cc-ded78e17cae1',NULL,NULL,NULL,NULL,NULL,NULL,'cus_A8eIEbktjRp3Tb',NULL,NULL,'sub_A8eIjgpyQDec67',NULL,NULL,NULL,NULL),(4,10,1,'Announcing CraftX','2017-03-06 19:52:53','2017-03-06 20:05:46','dde3969d-0a6d-442c-ad4f-34b5ca2cc297','# It\'s (almost) here\r\nAfter announcing CraftX in slack, having nothing to share, I was overwhelmed by the response from the community. That positive feedback, led me to setting aside a few days to focus on this project, get the site (MVP at this point) up, and start producing content.\r\n\r\nIt has been an amazing journey alrady, and I haven\'t even started. If I fail, I will be happy that, at least, CraftX did not die as an idea.\r\n\r\nAnyway!\r\n\r\n## What is it?\r\nCraftX is membership based website where I distribute premium training content for Craft CMS, in the form of screencasts.\r\n\r\n## Who is it for?\r\nCraftX is for _Busy Developers_ like you, who want to master Craft CMS without wasting time.\r\n\r\n## How much will it cost?\r\nI\'m leaning on the community to come up with something that is fair to you, and sustainable for me.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Craft Training for Busy Developers');
/*!40000 ALTER TABLE `cx_content` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_deprecationerrors`
--

DROP TABLE IF EXISTS `cx_deprecationerrors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_deprecationerrors`
--

LOCK TABLES `cx_deprecationerrors` WRITE;
/*!40000 ALTER TABLE `cx_deprecationerrors` DISABLE KEYS */;
/*!40000 ALTER TABLE `cx_deprecationerrors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_elementindexsettings`
--

DROP TABLE IF EXISTS `cx_elementindexsettings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_elementindexsettings`
--

LOCK TABLES `cx_elementindexsettings` WRITE;
/*!40000 ALTER TABLE `cx_elementindexsettings` DISABLE KEYS */;
/*!40000 ALTER TABLE `cx_elementindexsettings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_elements`
--

DROP TABLE IF EXISTS `cx_elements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_elements`
--

LOCK TABLES `cx_elements` WRITE;
/*!40000 ALTER TABLE `cx_elements` DISABLE KEYS */;
INSERT INTO `cx_elements` VALUES (1,'craft\\elements\\User',1,0,'2017-02-06 18:39:45','2017-03-06 06:05:18','8f9b3b5a-a4c8-40c5-970a-01394dc85b8a'),(2,'craft\\elements\\Entry',1,0,'2017-02-06 18:57:45','2017-03-06 06:32:08','ed27feb3-0e3f-457b-be29-6a7d20af0a51'),(3,'craft\\elements\\User',1,0,'2017-02-18 01:29:14','2017-02-23 04:24:10','6b6a037c-c82e-43bc-afb4-f7c86856ca45'),(4,'craft\\elements\\MatrixBlock',1,0,'2017-03-05 05:52:42','2017-03-06 06:32:08','c2197b23-31fb-46cb-af30-77c78184d21e'),(5,'craft\\elements\\MatrixBlock',1,0,'2017-03-05 05:52:42','2017-03-06 06:32:08','cc2de781-41ee-49c7-83ee-2b959c519595'),(6,'craft\\elements\\MatrixBlock',1,0,'2017-03-05 05:52:42','2017-03-06 06:32:08','29ffa80a-a8b6-4487-9d51-56249ce6b29f'),(7,'craft\\elements\\MatrixBlock',1,0,'2017-03-05 05:52:42','2017-03-06 06:32:08','dbc1ed27-8205-49a4-915e-cadd95227eab'),(8,'craft\\elements\\MatrixBlock',1,0,'2017-03-05 05:52:42','2017-03-06 06:32:08','b91d48c8-ae5e-40b6-acfd-bde5ea53af35'),(9,'craft\\elements\\MatrixBlock',1,0,'2017-03-05 06:03:15','2017-03-06 06:32:08','34b6271e-38c2-4bad-a919-d0510e322a04'),(10,'craft\\elements\\Entry',1,0,'2017-03-06 19:52:53','2017-03-06 20:05:46','d7a8319c-a221-4558-8592-d0fda2e50842');
/*!40000 ALTER TABLE `cx_elements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_elements_i18n`
--

DROP TABLE IF EXISTS `cx_elements_i18n`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_elements_i18n`
--

LOCK TABLES `cx_elements_i18n` WRITE;
/*!40000 ALTER TABLE `cx_elements_i18n` DISABLE KEYS */;
INSERT INTO `cx_elements_i18n` VALUES (1,1,1,'',NULL,1,'2017-02-06 18:39:45','2017-03-06 06:05:18','9504a134-b2e6-46af-b4aa-74c9b71c7b77'),(2,2,1,'homepage','__home__',1,'2017-02-06 18:57:45','2017-03-06 06:32:08','5283df6e-7b1f-456c-ae86-5e3974e90a16'),(3,3,1,'',NULL,1,'2017-02-18 01:30:24','2017-02-23 04:24:10','d7effd95-63bb-4be4-a3a6-5f621dcfc327'),(4,4,1,NULL,NULL,1,'2017-03-05 05:52:42','2017-03-06 06:32:08','0cdc23ab-7302-4134-9493-21b97cd2459a'),(5,5,1,NULL,NULL,1,'2017-03-05 05:52:42','2017-03-06 06:32:08','fce317c9-5809-4cff-a4e7-5d7c3c8e4c77'),(6,6,1,NULL,NULL,1,'2017-03-05 05:52:42','2017-03-06 06:32:08','99e6eb9a-4c4e-4cbd-9628-d068e5eb657c'),(7,7,1,NULL,NULL,1,'2017-03-05 05:52:42','2017-03-06 06:32:08','35184b9d-ae82-4c6b-9200-f43027abdb16'),(8,8,1,NULL,NULL,1,'2017-03-05 05:52:42','2017-03-06 06:32:08','9e2b1646-bb32-4f4b-873c-6e1c5fd67d29'),(9,9,1,NULL,NULL,1,'2017-03-05 06:03:15','2017-03-06 06:32:08','d13f3a50-c65c-47b1-a9e3-da75777a2a17'),(10,10,1,'announcing-craftx','blog/announcing-craftx',1,'2017-03-06 19:52:53','2017-03-06 20:05:46','8fbb0662-4318-4973-bc40-388a6e448592');
/*!40000 ALTER TABLE `cx_elements_i18n` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_entries`
--

DROP TABLE IF EXISTS `cx_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_entries`
--

LOCK TABLES `cx_entries` WRITE;
/*!40000 ALTER TABLE `cx_entries` DISABLE KEYS */;
INSERT INTO `cx_entries` VALUES (2,1,1,NULL,'2017-03-06 06:32:08',NULL,'2017-02-06 18:57:45','2017-03-06 06:32:08','2466f0af-20d8-4705-bd99-e780840f65f0'),(10,4,4,1,'2017-03-06 19:52:00',NULL,'2017-03-06 19:52:53','2017-03-06 20:05:46','7522a1c6-736b-493f-ab47-3a6377cc3196');
/*!40000 ALTER TABLE `cx_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_entrydrafts`
--

DROP TABLE IF EXISTS `cx_entrydrafts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_entrydrafts`
--

LOCK TABLES `cx_entrydrafts` WRITE;
/*!40000 ALTER TABLE `cx_entrydrafts` DISABLE KEYS */;
/*!40000 ALTER TABLE `cx_entrydrafts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_entrytypes`
--

DROP TABLE IF EXISTS `cx_entrytypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_entrytypes`
--

LOCK TABLES `cx_entrytypes` WRITE;
/*!40000 ALTER TABLE `cx_entrytypes` DISABLE KEYS */;
INSERT INTO `cx_entrytypes` VALUES (1,1,18,'Homepage','homepage',1,'Name',NULL,1,'2017-02-06 18:57:45','2017-03-06 06:28:43','5c2f8151-f389-4dc0-9a0a-c0596ca9686f'),(3,3,24,'Series','series',1,'Title',NULL,1,'2017-03-06 17:08:44','2017-03-06 19:44:01','20a84e1f-e1ae-44d4-8d53-3fd5e8f71660'),(4,4,26,'Blog','blog',1,'Title',NULL,1,'2017-03-06 17:09:13','2017-03-06 19:44:50','8e6fb78e-cd97-43ba-a44d-82bf857eaf16'),(5,3,25,'Episode','episode',1,'Title',NULL,2,'2017-03-06 19:44:34','2017-03-06 19:44:34','1b852c17-5923-4657-b2c7-de7c68f7f474');
/*!40000 ALTER TABLE `cx_entrytypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_entryversions`
--

DROP TABLE IF EXISTS `cx_entryversions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_entryversions`
--

LOCK TABLES `cx_entryversions` WRITE;
/*!40000 ALTER TABLE `cx_entryversions` DISABLE KEYS */;
INSERT INTO `cx_entryversions` VALUES (1,10,4,1,1,1,'','{\"typeId\":4,\"authorId\":\"1\",\"title\":\"Announcing CraftX™\",\"slug\":\"announcing-craftx\",\"postDate\":1488829973,\"expiryDate\":null,\"enabled\":true,\"newParentId\":null,\"fields\":{\"3\":\"# It\'s (almost) here\\r\\nAfter announcing CraftX in slack, having nothing to share, I was overwhelmed by the response from the community. That positive feedback, led me to setting aside a few days to focus on this project, get the site (MVP at this point) up, and start producing content.\\r\\n\\r\\nIt has been an amazing journey alrady, and I haven\'t even started. If I fail, I will be happy that, at least, CraftX did not die as an idea.\\r\\n\\r\\nAnyway!\\r\\n\\r\\n## What is it?\\r\\nA membership based website to access premium training content, delivered as screencasts.\\r\\n\\r\\n## Who is it for?\\r\\n_Busy Developers_ like you, who want to master Craft CMS without wasting time.\\r\\n\\r\\n## How much will it cost?\\r\\nI\'m leaning on the community to come up with something that is fair to you, and sustainable for me.\",\"33\":\"Craft Training for Busy Developers\"}}','2017-03-06 19:52:53','2017-03-06 19:52:53','b518cffc-8f94-403a-8a09-55279c31ec7e'),(2,10,4,1,1,2,'','{\"typeId\":\"4\",\"authorId\":\"1\",\"title\":\"Announcing CraftX\",\"slug\":\"announcing-craftx\",\"postDate\":1488829920,\"expiryDate\":null,\"enabled\":true,\"newParentId\":null,\"fields\":{\"3\":\"# It\'s (almost) here\\r\\nAfter announcing CraftX in slack, having nothing to share, I was overwhelmed by the response from the community. That positive feedback, led me to setting aside a few days to focus on this project, get the site (MVP at this point) up, and start producing content.\\r\\n\\r\\nIt has been an amazing journey alrady, and I haven\'t even started. If I fail, I will be happy that, at least, CraftX did not die as an idea.\\r\\n\\r\\nAnyway!\\r\\n\\r\\n## What is it?\\r\\nCraftX is membership based website where I distribute premium training content for Craft CMS, in the form of screencasts.\\r\\n\\r\\n## Who is it for?\\r\\nCraftX is for _Busy Developers_ like you, who want to master Craft CMS without wasting time.\\r\\n\\r\\n## How much will it cost?\\r\\nI\'m leaning on the community to come up with something that is fair to you, and sustainable for me.\",\"33\":\"Craft Training for Busy Developers\"}}','2017-03-06 20:05:46','2017-03-06 20:05:46','9a96a826-011f-431f-a334-eb657af00e77');
/*!40000 ALTER TABLE `cx_entryversions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_fieldgroups`
--

DROP TABLE IF EXISTS `cx_fieldgroups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cx_fieldgroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_fieldgroups_name_unq_idx` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_fieldgroups`
--

LOCK TABLES `cx_fieldgroups` WRITE;
/*!40000 ALTER TABLE `cx_fieldgroups` DISABLE KEYS */;
INSERT INTO `cx_fieldgroups` VALUES (1,'Shared','2017-02-07 05:14:22','2017-02-07 05:14:22','799c0f93-61ee-404c-b178-c8c8e7f66e24'),(2,'Users','2017-02-13 04:28:10','2017-02-13 04:28:10','8f5381cc-ddb6-4446-9b1f-056b27030357'),(3,'Homepage','2017-03-05 04:31:11','2017-03-05 04:31:11','96fab19c-20cb-41e9-96f7-15cde27c09d4');
/*!40000 ALTER TABLE `cx_fieldgroups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_fieldlayoutfields`
--

DROP TABLE IF EXISTS `cx_fieldlayoutfields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=86 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_fieldlayoutfields`
--

LOCK TABLES `cx_fieldlayoutfields` WRITE;
/*!40000 ALTER TABLE `cx_fieldlayoutfields` DISABLE KEYS */;
INSERT INTO `cx_fieldlayoutfields` VALUES (21,6,4,10,0,1,'2017-03-03 07:29:16','2017-03-03 07:29:16','26a1782a-07d3-4aca-b748-dc3dd731bdd4'),(22,6,4,13,0,2,'2017-03-03 07:29:16','2017-03-03 07:29:16','a00a6ccf-0705-4d9a-a5f8-a38f22840dbb'),(23,6,4,11,0,3,'2017-03-03 07:29:16','2017-03-03 07:29:16','b5534b3d-b4f6-494b-9d34-eada8e42e6b7'),(24,6,4,12,0,4,'2017-03-03 07:29:16','2017-03-03 07:29:16','9680b5c6-c7ca-4e96-9d78-bb9f990ca3f0'),(25,6,4,9,0,5,'2017-03-03 07:29:16','2017-03-03 07:29:16','5dd5a74d-6be4-40be-ad2d-8e01ab999b2b'),(26,6,4,5,0,6,'2017-03-03 07:29:16','2017-03-03 07:29:16','c6e487b5-4da2-4664-b936-fe1f8089a8a5'),(27,6,4,6,0,7,'2017-03-03 07:29:16','2017-03-03 07:29:16','98b89802-cfa3-4bd1-9b9d-d6f7b89683be'),(28,6,4,7,0,8,'2017-03-03 07:29:16','2017-03-03 07:29:16','aa56e9d3-df49-4254-bff2-45db0c40da41'),(29,6,4,8,0,9,'2017-03-03 07:29:16','2017-03-03 07:29:16','f0a4ee2f-b336-496f-83a6-393f420457a2'),(56,14,12,22,1,1,'2017-03-05 05:03:45','2017-03-05 05:03:45','e5481c57-7fcd-430a-911b-cb16675fef53'),(57,14,12,23,1,2,'2017-03-05 05:03:45','2017-03-05 05:03:45','801de0ed-ae80-4015-9591-9b577fc308eb'),(58,14,12,24,0,3,'2017-03-05 05:03:45','2017-03-05 05:03:45','db785766-8b82-46d7-9350-8c2fdeea4393'),(59,14,12,25,0,4,'2017-03-05 05:03:45','2017-03-05 05:03:45','663b3528-c347-4fd1-9238-575b72e3a85f'),(60,14,12,26,1,5,'2017-03-05 05:03:45','2017-03-05 05:03:45','765de32c-9b2a-4d1f-b119-2b057fec3d66'),(61,14,12,27,0,6,'2017-03-05 05:03:45','2017-03-05 05:03:45','f4166e4e-94da-4dd9-bc4c-0ef76149b505'),(65,16,14,18,1,1,'2017-03-05 06:17:53','2017-03-05 06:17:53','9bd2693e-7309-413d-9c38-bdc42168cd8d'),(66,16,14,19,1,2,'2017-03-05 06:17:53','2017-03-05 06:17:53','9b6dedac-d5fd-4bd1-9600-fe08ccd570e7'),(67,16,14,20,1,3,'2017-03-05 06:17:53','2017-03-05 06:17:53','2889c7ab-0db1-4830-b649-5fe7f74d6b42'),(68,17,15,29,1,1,'2017-03-06 06:25:51','2017-03-06 06:25:51','40527b40-31ad-4082-b581-93d7718a7088'),(69,17,15,30,1,2,'2017-03-06 06:25:51','2017-03-06 06:25:51','b190148e-b06c-4648-b32a-91ddf5294d94'),(70,17,15,31,1,3,'2017-03-06 06:25:51','2017-03-06 06:25:51','d6061d11-2224-478a-87e7-deaca1bc6913'),(71,18,16,32,0,1,'2017-03-06 06:28:43','2017-03-06 06:28:43','bbe94976-5b75-4687-8580-e5163c2acec1'),(72,18,16,33,0,2,'2017-03-06 06:28:43','2017-03-06 06:28:43','75d10de1-e715-4bc1-be62-4c62fc30e4e2'),(73,18,16,28,0,3,'2017-03-06 06:28:43','2017-03-06 06:28:43','1fbedf44-1132-44c9-bd00-850e64e36aa2'),(74,18,16,17,0,4,'2017-03-06 06:28:43','2017-03-06 06:28:43','45c89e09-a0de-4d9d-889c-04855e903a4a'),(75,18,16,21,0,5,'2017-03-06 06:28:43','2017-03-06 06:28:43','f24ac2c5-7a32-4202-bd67-15925570119a'),(78,24,18,32,0,1,'2017-03-06 19:44:01','2017-03-06 19:44:01','0bcf6739-84a4-43b8-a6dc-ef28139ff585'),(79,24,18,33,0,2,'2017-03-06 19:44:01','2017-03-06 19:44:01','27b8b59c-fe1d-4d76-b592-1fce340d0267'),(80,24,18,3,0,3,'2017-03-06 19:44:01','2017-03-06 19:44:01','caf147ed-dd5d-4ed8-bd04-87fb33084bc1'),(81,25,19,32,0,1,'2017-03-06 19:44:34','2017-03-06 19:44:34','016f28ab-8982-466a-970e-4371de3edb95'),(82,25,19,33,0,2,'2017-03-06 19:44:34','2017-03-06 19:44:34','dc17c583-3364-4aba-a293-38aac981a2c8'),(83,25,19,3,0,3,'2017-03-06 19:44:34','2017-03-06 19:44:34','cb4a9745-1fc7-48f2-95e0-bbd299d39616'),(84,26,20,33,0,1,'2017-03-06 19:44:50','2017-03-06 19:44:50','f134c082-1e27-45d2-bac8-0da60ff6bd92'),(85,26,20,3,0,2,'2017-03-06 19:44:50','2017-03-06 19:44:50','0663ef9f-e7cf-4941-a177-bbaa7d12bb9b');
/*!40000 ALTER TABLE `cx_fieldlayoutfields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_fieldlayouts`
--

DROP TABLE IF EXISTS `cx_fieldlayouts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cx_fieldlayouts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `cx_fieldlayouts_type_idx` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_fieldlayouts`
--

LOCK TABLES `cx_fieldlayouts` WRITE;
/*!40000 ALTER TABLE `cx_fieldlayouts` DISABLE KEYS */;
INSERT INTO `cx_fieldlayouts` VALUES (6,'craft\\elements\\User','2017-03-03 07:29:16','2017-03-03 07:29:16','c710ff40-fdeb-4c1f-b091-4f728bfabbc8'),(14,'craft\\elements\\MatrixBlock','2017-03-05 05:03:45','2017-03-05 05:03:45','aceb2822-0e14-4baf-b094-d57bbaa94e6b'),(16,'craft\\elements\\MatrixBlock','2017-03-05 06:17:53','2017-03-05 06:17:53','9a0118ae-4100-4374-b399-15875aa7c4e2'),(17,'craft\\elements\\MatrixBlock','2017-03-06 06:25:51','2017-03-06 06:25:51','e5348576-0b50-4a96-b4c0-a957204ba9c7'),(18,'craft\\elements\\Entry','2017-03-06 06:28:43','2017-03-06 06:28:43','54aa87dc-f052-437f-8af8-2d27d589fc41'),(22,'craft\\elements\\Asset','2017-03-06 17:12:42','2017-03-06 17:12:42','80662f76-4104-4119-bba8-7eb9adcffdd9'),(24,'craft\\elements\\Entry','2017-03-06 19:44:01','2017-03-06 19:44:01','4930d398-9588-4994-a84f-9c87504e5c26'),(25,'craft\\elements\\Entry','2017-03-06 19:44:34','2017-03-06 19:44:34','2339dff9-867f-4071-9068-a642cbc159bd'),(26,'craft\\elements\\Entry','2017-03-06 19:44:50','2017-03-06 19:44:50','59ef2d31-d737-4042-9980-a11e1e13917b');
/*!40000 ALTER TABLE `cx_fieldlayouts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_fieldlayouttabs`
--

DROP TABLE IF EXISTS `cx_fieldlayouttabs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_fieldlayouttabs`
--

LOCK TABLES `cx_fieldlayouttabs` WRITE;
/*!40000 ALTER TABLE `cx_fieldlayouttabs` DISABLE KEYS */;
INSERT INTO `cx_fieldlayouttabs` VALUES (4,6,'Profile',1,'2017-03-03 07:29:16','2017-03-03 07:29:16','25573aeb-e9e8-4f49-a0ea-105e50ffd131'),(12,14,'Content',1,'2017-03-05 05:03:45','2017-03-05 05:03:45','e662f5b1-02f4-41c3-a7e3-6ac1fef40547'),(14,16,'Content',1,'2017-03-05 06:17:53','2017-03-05 06:17:53','360a81e8-3240-49fb-b128-bbdc8267c440'),(15,17,'Content',1,'2017-03-06 06:25:51','2017-03-06 06:25:51','8ab0530f-f030-4611-92bf-5a699c36a5f5'),(16,18,'Content',1,'2017-03-06 06:28:43','2017-03-06 06:28:43','4bbe0bae-0426-48d2-b3bb-1b45d748913c'),(18,24,'Content',1,'2017-03-06 19:44:01','2017-03-06 19:44:01','46303f7c-b5f1-4dac-bc37-597ff85c9641'),(19,25,'Content',1,'2017-03-06 19:44:34','2017-03-06 19:44:34','367aa06a-7501-4100-b709-ec748639c0fa'),(20,26,'Content',1,'2017-03-06 19:44:50','2017-03-06 19:44:50','51a383e5-912b-4eff-b8d7-13ec02691698');
/*!40000 ALTER TABLE `cx_fieldlayouttabs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_fields`
--

DROP TABLE IF EXISTS `cx_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_fields`
--

LOCK TABLES `cx_fields` WRITE;
/*!40000 ALTER TABLE `cx_fields` DISABLE KEYS */;
INSERT INTO `cx_fields` VALUES (3,1,'Markdown','markdown','global','','none',NULL,'selvinortiz\\doxter\\fields\\DoxterField','{\"tabSize\":2,\"indentWithTabs\":false,\"enableLineWrapping\":true,\"enableSpellChecker\":false}','2017-02-07 05:15:25','2017-02-07 05:15:25','5f019cad-79cb-464d-b8d0-10603a397974'),(5,2,'Billing Address 1','billingAddress1','global','','none',NULL,'craft\\fields\\PlainText','{\"placeholder\":\"\",\"multiline\":\"\",\"initialRows\":\"4\",\"charLimit\":\"\",\"columnType\":\"text\"}','2017-02-13 04:28:49','2017-03-04 06:00:03','f5b83d0a-eb48-416f-be61-81c75bd412fd'),(6,2,'Billing City','billingCity','global','','none',NULL,'craft\\fields\\PlainText','{\"placeholder\":\"\",\"multiline\":\"\",\"initialRows\":\"4\",\"charLimit\":\"\",\"columnType\":\"text\"}','2017-02-13 04:29:25','2017-02-25 02:52:37','1fcab1b3-b537-473d-a503-8bb295226692'),(7,2,'Billing State','billingState','global','','none',NULL,'craft\\fields\\PlainText','{\"placeholder\":\"\",\"multiline\":\"\",\"initialRows\":\"4\",\"charLimit\":\"\",\"columnType\":\"text\"}','2017-02-13 04:29:41','2017-02-25 02:52:37','4131115c-cfb9-4592-a08c-81dfaf9509fb'),(8,2,'Billing Zip','billingZip','global','','none',NULL,'craft\\fields\\PlainText','{\"placeholder\":\"\",\"multiline\":\"\",\"initialRows\":\"4\",\"charLimit\":\"\",\"columnType\":\"text\"}','2017-02-13 04:31:31','2017-02-25 02:52:37','b1246329-88a6-49e1-8e19-bbaf0011ac18'),(9,2,'Billing Country','billingCountry','global','','none',NULL,'craft\\fields\\PlainText','{\"placeholder\":\"\",\"multiline\":\"\",\"initialRows\":\"4\",\"charLimit\":\"\",\"columnType\":\"text\"}','2017-02-13 04:31:50','2017-02-25 02:52:37','bc36bf11-888b-4f8d-98ce-93d0656daafc'),(10,2,'Customer ID','customerId','global','Customer ID issued by Stripe','none',NULL,'craft\\fields\\PlainText','{\"placeholder\":\"\",\"multiline\":\"\",\"initialRows\":\"4\",\"charLimit\":\"\",\"columnType\":\"text\"}','2017-02-13 04:32:44','2017-02-25 02:52:37','5597d2b6-95cf-46fa-a07a-d347ba918b3a'),(11,2,'Billing Email','billingEmail','global','Should be the customer email in Stripe','none',NULL,'craft\\fields\\PlainText','{\"placeholder\":\"\",\"multiline\":\"\",\"initialRows\":\"4\",\"charLimit\":\"\",\"columnType\":\"text\"}','2017-02-13 04:33:03','2017-02-25 02:52:37','4e2f40a2-8c04-42aa-aa66-2d92bb2428cb'),(12,2,'Billing Country Code','billingCountryCode','global','','none',NULL,'craft\\fields\\PlainText','{\"placeholder\":\"\",\"multiline\":\"\",\"initialRows\":\"4\",\"charLimit\":\"2\",\"columnType\":\"string\"}','2017-02-13 04:34:43','2017-02-25 02:52:37','197c65c9-4344-4077-9034-21f9eaff08b3'),(13,2,'Subscription ID','subscriptionId','global','Subscription ID issued by Stripe','none',NULL,'craft\\fields\\PlainText','{\"placeholder\":\"\",\"multiline\":\"\",\"initialRows\":\"4\",\"charLimit\":\"\",\"columnType\":\"text\"}','2017-02-18 00:46:33','2017-02-25 02:52:37','4b9fd993-c34a-4070-8e5b-b528f926e4d9'),(14,2,'Subscription JSON','subscriptionJson','global','JSON data received during subscription','none',NULL,'craft\\fields\\PlainText','{\"placeholder\":\"\",\"multiline\":\"\",\"initialRows\":\"4\",\"charLimit\":\"\",\"columnType\":\"text\"}','2017-02-18 00:49:40','2017-03-06 06:28:14','24e95252-e513-4cde-a6d8-b57be72fc42f'),(16,2,'Billing Address 2','billingAddress2','global','','none',NULL,'craft\\fields\\PlainText','{\"placeholder\":\"\",\"multiline\":\"\",\"initialRows\":\"4\",\"charLimit\":\"\",\"columnType\":\"text\"}','2017-03-04 05:59:46','2017-03-04 05:59:46','4c39ed1c-e395-42f1-adb8-c4ceea6d5cb4'),(17,3,'Features','features','global','','none',NULL,'craft\\fields\\Matrix','{\"maxBlocks\":\"\",\"localizeBlocks\":false}','2017-03-05 04:50:56','2017-03-05 06:17:53','84e13bf7-b56d-470d-97af-97f24826b912'),(18,NULL,'Feature Lead','featureLead','matrixBlockType:1','','none',NULL,'craft\\fields\\PlainText','{\"placeholder\":\"\",\"multiline\":\"\",\"initialRows\":\"4\",\"charLimit\":\"\",\"columnType\":\"text\"}','2017-03-05 04:50:56','2017-03-05 06:17:53','4ea651b7-d653-45f7-a713-abbfb1318b51'),(19,NULL,'Feature Text','featureText','matrixBlockType:1','','none',NULL,'craft\\fields\\PlainText','{\"placeholder\":\"\",\"multiline\":\"\",\"initialRows\":\"4\",\"charLimit\":\"\",\"columnType\":\"text\"}','2017-03-05 04:50:56','2017-03-05 06:17:53','5f256135-443c-4bf3-9ef4-e4527d64b3f4'),(20,NULL,'Feature Icon Class','featureIconClass','matrixBlockType:1','','none',NULL,'craft\\fields\\PlainText','{\"placeholder\":\"\",\"multiline\":\"\",\"initialRows\":\"4\",\"charLimit\":\"\",\"columnType\":\"text\"}','2017-03-05 04:50:56','2017-03-05 06:17:53','6e1b32c7-f82b-4b59-8add-750475489d87'),(21,3,'Shouts','shouts','global','','none',NULL,'craft\\fields\\Matrix','{\"maxBlocks\":\"\",\"localizeBlocks\":false}','2017-03-05 04:56:08','2017-03-05 05:03:45','c4a0f9f0-3d5a-45ac-8e71-f24fff451ad0'),(22,NULL,'Shout Text','shoutText','matrixBlockType:2','','none',NULL,'craft\\fields\\PlainText','{\"placeholder\":\"\",\"multiline\":\"\",\"initialRows\":\"4\",\"charLimit\":\"\",\"columnType\":\"text\"}','2017-03-05 04:56:08','2017-03-05 05:03:45','5d5d5eca-1226-4511-9221-080db92eb2b6'),(23,NULL,'Shout Author Name','shoutAuthorName','matrixBlockType:2','','none',NULL,'craft\\fields\\PlainText','{\"placeholder\":\"\",\"multiline\":\"\",\"initialRows\":\"4\",\"charLimit\":\"\",\"columnType\":\"text\"}','2017-03-05 04:56:08','2017-03-05 05:03:45','28876336-fb61-43d8-b548-73af363ac271'),(24,NULL,'Shout Author URL','shoutAuthorUrl','matrixBlockType:2','','none',NULL,'craft\\fields\\PlainText','{\"placeholder\":\"\",\"multiline\":\"\",\"initialRows\":\"4\",\"charLimit\":\"\",\"columnType\":\"text\"}','2017-03-05 04:56:09','2017-03-05 05:03:45','75161c72-d1b9-48a1-9761-8f8eb2fcd6d2'),(25,NULL,'Shout Author Role','shoutAuthorRole','matrixBlockType:2','','none',NULL,'craft\\fields\\PlainText','{\"placeholder\":\"\",\"multiline\":\"\",\"initialRows\":\"4\",\"charLimit\":\"\",\"columnType\":\"text\"}','2017-03-05 04:56:09','2017-03-05 05:03:45','e0fdfb8a-9d7a-4807-9448-a4fbed9fb379'),(26,NULL,'Shout Author Company','shoutAuthorCompany','matrixBlockType:2','','none',NULL,'craft\\fields\\PlainText','{\"placeholder\":\"\",\"multiline\":\"\",\"initialRows\":\"4\",\"charLimit\":\"\",\"columnType\":\"text\"}','2017-03-05 04:56:09','2017-03-05 05:03:45','84e36666-16ab-41f6-9194-2afd3fc6d762'),(27,NULL,'Shout Author Company URL','shoutAuthorCompanyUrl','matrixBlockType:2','','none',NULL,'craft\\fields\\PlainText','{\"placeholder\":\"\",\"multiline\":\"\",\"initialRows\":\"4\",\"charLimit\":\"\",\"columnType\":\"text\"}','2017-03-05 04:56:09','2017-03-05 05:03:45','475d3e9c-7c17-483e-b6dc-dc28168cc8da'),(28,3,'Hero','hero','global','','none',NULL,'craft\\fields\\Matrix','{\"maxBlocks\":\"1\",\"localizeBlocks\":false}','2017-03-05 05:02:55','2017-03-06 06:25:51','f6e64b0e-e5c2-4511-a6a7-9296d022ffed'),(29,NULL,'Hero Lead','heroLead','matrixBlockType:3','','none',NULL,'craft\\fields\\PlainText','{\"placeholder\":\"\",\"multiline\":\"\",\"initialRows\":\"4\",\"charLimit\":\"\",\"columnType\":\"text\"}','2017-03-05 05:02:55','2017-03-06 06:25:51','7b687433-c5e0-476c-80ea-cd714576e861'),(30,NULL,'Hero Text','heroText','matrixBlockType:3','','none',NULL,'craft\\fields\\PlainText','{\"placeholder\":\"\",\"multiline\":\"\",\"initialRows\":\"4\",\"charLimit\":\"\",\"columnType\":\"text\"}','2017-03-05 05:02:55','2017-03-06 06:25:51','365932be-65a2-4c96-a4b7-d08934c55b1c'),(31,NULL,'Hero CTA Text','heroCtaText','matrixBlockType:3','','none',NULL,'craft\\fields\\PlainText','{\"placeholder\":\"\",\"multiline\":\"\",\"initialRows\":\"4\",\"charLimit\":\"\",\"columnType\":\"text\"}','2017-03-05 05:02:55','2017-03-06 06:25:51','2464b465-225b-45ca-a0c6-6506d08cbd6d'),(32,1,'Lead','lead','global','','none',NULL,'craft\\fields\\PlainText','{\"placeholder\":\"\",\"multiline\":\"\",\"initialRows\":\"4\",\"charLimit\":\"\",\"columnType\":\"text\"}','2017-03-06 06:27:13','2017-03-06 06:27:13','c50ebf6d-9b16-4835-916a-ec28810f3e99'),(33,1,'Text','text','global','','none',NULL,'craft\\fields\\PlainText','{\"placeholder\":\"\",\"multiline\":\"\",\"initialRows\":\"4\",\"charLimit\":\"\",\"columnType\":\"text\"}','2017-03-06 06:27:31','2017-03-06 06:27:31','856b5cdf-0a53-41c7-b172-42d700ba27ac');
/*!40000 ALTER TABLE `cx_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_globalsets`
--

DROP TABLE IF EXISTS `cx_globalsets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_globalsets`
--

LOCK TABLES `cx_globalsets` WRITE;
/*!40000 ALTER TABLE `cx_globalsets` DISABLE KEYS */;
/*!40000 ALTER TABLE `cx_globalsets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_info`
--

DROP TABLE IF EXISTS `cx_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_info`
--

LOCK TABLES `cx_info` WRITE;
/*!40000 ALTER TABLE `cx_info` DISABLE KEYS */;
INSERT INTO `cx_info` VALUES (1,'3.0.0-beta.6','3.0.36',2,'America/Chicago',1,0,'JTLApy4waSHQ','2017-02-06 18:39:45','2017-03-06 06:28:14','eaa61c2b-4f72-44a5-9c9a-1b9911d37734','CraftX');
/*!40000 ALTER TABLE `cx_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_matrixblocks`
--

DROP TABLE IF EXISTS `cx_matrixblocks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_matrixblocks`
--

LOCK TABLES `cx_matrixblocks` WRITE;
/*!40000 ALTER TABLE `cx_matrixblocks` DISABLE KEYS */;
INSERT INTO `cx_matrixblocks` VALUES (4,2,NULL,28,3,1,'2017-03-05 05:52:42','2017-03-06 06:32:08','57f6d04c-5711-42d4-a21b-0c2692630af8'),(5,2,NULL,17,1,1,'2017-03-05 05:52:42','2017-03-06 06:32:08','c1ffe741-acef-423f-b759-74de0ede4a26'),(6,2,NULL,17,1,2,'2017-03-05 05:52:42','2017-03-06 06:32:08','3ab2bfab-50fc-4503-a4f0-da177044d92e'),(7,2,NULL,17,1,3,'2017-03-05 05:52:42','2017-03-06 06:32:08','993bcce5-45f9-45ac-b580-8595666d8902'),(8,2,NULL,21,2,1,'2017-03-05 05:52:42','2017-03-06 06:32:08','ac8ae166-56a3-48ff-b68d-74cb1bad6e4f'),(9,2,NULL,21,2,2,'2017-03-05 06:03:15','2017-03-06 06:32:08','f77d07ca-3370-4b72-b999-fd2c6cf08ae1');
/*!40000 ALTER TABLE `cx_matrixblocks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_matrixblocktypes`
--

DROP TABLE IF EXISTS `cx_matrixblocktypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_matrixblocktypes`
--

LOCK TABLES `cx_matrixblocktypes` WRITE;
/*!40000 ALTER TABLE `cx_matrixblocktypes` DISABLE KEYS */;
INSERT INTO `cx_matrixblocktypes` VALUES (1,17,16,'Feature','feature',1,'2017-03-05 04:50:56','2017-03-05 06:17:53','6b537673-6a61-47eb-b8fe-4b72fd92a457'),(2,21,14,'Shout','shout',1,'2017-03-05 04:56:08','2017-03-05 05:03:45','5e99e250-7662-4be9-a496-12f847d5a0af'),(3,28,17,'Hero','hero',1,'2017-03-05 05:02:55','2017-03-06 06:25:51','dc7681ea-75e7-4f8d-aa43-77ffe553d063');
/*!40000 ALTER TABLE `cx_matrixblocktypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_matrixcontent_features`
--

DROP TABLE IF EXISTS `cx_matrixcontent_features`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cx_matrixcontent_features` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `elementId` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  `field_feature_featureLead` text,
  `field_feature_featureText` text,
  `field_feature_featureIconClass` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_matrixcontent_features_elementId_siteId_idx` (`elementId`,`siteId`),
  KEY `cx_matrixcontent_features_siteId_fk` (`siteId`),
  CONSTRAINT `cx_matrixcontent_features_elementId_fk` FOREIGN KEY (`elementId`) REFERENCES `cx_elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cx_matrixcontent_features_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `cx_sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_matrixcontent_features`
--

LOCK TABLES `cx_matrixcontent_features` WRITE;
/*!40000 ALTER TABLE `cx_matrixcontent_features` DISABLE KEYS */;
INSERT INTO `cx_matrixcontent_features` VALUES (1,5,1,'2017-03-05 05:52:42','2017-03-06 06:32:08','9d4ce59e-4807-461b-8422-7f30eb9426ad','Clear Code','No squinting. Just large, beautiful text and consice snippets for maximun readability.','clear-code'),(2,6,1,'2017-03-05 05:52:42','2017-03-06 06:32:08','cc2f3782-10db-4c01-bd66-ed7e5d2721cf','Clean Sound','No pops, hiss or monotone. Just clean, normalized audio for smooth, distraction free listening.','clean-sound'),(3,7,1,'2017-03-05 05:52:42','2017-03-06 06:32:08','3b78108b-7420-402b-9eff-eb07e2ed3d5c','Quick Pace','No dozing off. Lessons are optimized to get you writing code and mastering Craft as quickly as possible.','quick-pace');
/*!40000 ALTER TABLE `cx_matrixcontent_features` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_matrixcontent_hero`
--

DROP TABLE IF EXISTS `cx_matrixcontent_hero`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cx_matrixcontent_hero` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `elementId` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  `field_hero_heroLead` text,
  `field_hero_heroText` text,
  `field_hero_heroCtaText` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_matrixcontent_hero_elementId_siteId_idx` (`elementId`,`siteId`),
  KEY `cx_matrixcontent_hero_siteId_fk` (`siteId`),
  CONSTRAINT `cx_matrixcontent_hero_elementId_fk` FOREIGN KEY (`elementId`) REFERENCES `cx_elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cx_matrixcontent_hero_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `cx_sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_matrixcontent_hero`
--

LOCK TABLES `cx_matrixcontent_hero` WRITE;
/*!40000 ALTER TABLE `cx_matrixcontent_hero` DISABLE KEYS */;
INSERT INTO `cx_matrixcontent_hero` VALUES (1,4,1,'2017-03-05 05:52:42','2017-03-06 06:32:08','efcb74c9-e1d6-4fa3-9e8f-382b7cd0ba1c','Craft Training for Busy Developers','Professionally crafted screencasts to help you master Craft CMS','Start Crafting Now');
/*!40000 ALTER TABLE `cx_matrixcontent_hero` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_matrixcontent_shouts`
--

DROP TABLE IF EXISTS `cx_matrixcontent_shouts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cx_matrixcontent_shouts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `elementId` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  `field_shout_shoutText` text,
  `field_shout_shoutAuthorName` text,
  `field_shout_shoutAuthorUrl` text,
  `field_shout_shoutAuthorRole` text,
  `field_shout_shoutAuthorCompany` text,
  `field_shout_shoutAuthorCompanyUrl` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_matrixcontent_shouts_elementId_siteId_idx` (`elementId`,`siteId`),
  KEY `cx_matrixcontent_shouts_siteId_fk` (`siteId`),
  CONSTRAINT `cx_matrixcontent_shouts_elementId_fk` FOREIGN KEY (`elementId`) REFERENCES `cx_elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cx_matrixcontent_shouts_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `cx_sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_matrixcontent_shouts`
--

LOCK TABLES `cx_matrixcontent_shouts` WRITE;
/*!40000 ALTER TABLE `cx_matrixcontent_shouts` DISABLE KEYS */;
INSERT INTO `cx_matrixcontent_shouts` VALUES (1,8,1,'2017-03-05 05:52:42','2017-03-06 06:32:08','f12d8e85-5320-4f0a-81db-1e1ce7002bf8','Selvin has a great way of explaining complex topics and a true love for teaching.','Selvin Ortiz','https://selvinortiz.com','Web Developer','Selvin CO','https://selvin.co'),(2,9,1,'2017-03-05 06:03:15','2017-03-06 06:32:08','1ff40a66-d5d7-4844-8a17-1ea8092a17ff','I really love the way the courses are laid out and how each lesson is taught.','Penny Ortiz','','','Penny Ortiz Photography','');
/*!40000 ALTER TABLE `cx_matrixcontent_shouts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_migrations`
--

DROP TABLE IF EXISTS `cx_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_migrations`
--

LOCK TABLES `cx_migrations` WRITE;
/*!40000 ALTER TABLE `cx_migrations` DISABLE KEYS */;
INSERT INTO `cx_migrations` VALUES (1,NULL,'app','Install','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','abccfa7e-27b7-4cc9-afb6-0c19dcc45435'),(2,NULL,'app','m150403_183908_migrations_table_changes','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','5aab0a07-9e7e-49a1-bc76-0a70f07ace48'),(3,NULL,'app','m150403_184247_plugins_table_changes','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','e8cfe0d8-23e0-45bc-b755-0750d56e3fe5'),(4,NULL,'app','m150403_184533_field_version','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','a5495214-9961-4969-80b7-81fdd605362e'),(5,NULL,'app','m150403_184729_type_columns','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','f168cbd9-e88f-4298-9938-50224948b5f4'),(6,NULL,'app','m150403_185142_volumes','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','9ca223d3-4fd6-4b3f-8934-88b22349cccf'),(7,NULL,'app','m150428_231346_userpreferences','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','3addd587-9b41-416f-a467-116d53a56072'),(8,NULL,'app','m150519_150900_fieldversion_conversion','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','67446cd3-e6c2-45e6-ac46-43bf3863bdd0'),(9,NULL,'app','m150617_213829_update_email_settings','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','7efdd03b-e38c-49e4-9940-93026ad7f825'),(10,NULL,'app','m150721_124739_templatecachequeries','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','74e40dd4-09f2-4117-841e-7cd64ae1b7e6'),(11,NULL,'app','m150724_140822_adjust_quality_settings','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','23f88548-2535-489f-97bd-e19e2b0088ea'),(12,NULL,'app','m150815_133521_last_login_attempt_ip','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','10b311a0-d1c7-4b25-8830-45fccb67e3d9'),(13,NULL,'app','m151002_095935_volume_cache_settings','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','2edb7a50-4e65-4d63-bd30-9a9ac0b82cd7'),(14,NULL,'app','m151005_142750_volume_s3_storage_settings','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','af8fed60-8232-40e3-be54-fbfb18d916a0'),(15,NULL,'app','m151016_133600_delete_asset_thumbnails','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','09a34ed3-b54f-4dfd-9454-e811b5af344f'),(16,NULL,'app','m151209_000000_move_logo','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','d9d460af-2f95-47eb-adb5-d1ccc6e6c05d'),(17,NULL,'app','m151211_000000_rename_fileId_to_assetId','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','83f10622-b23a-472b-8487-0dee9ae39d6e'),(18,NULL,'app','m151215_000000_rename_asset_permissions','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','3ed85d66-68a9-4698-9cd0-0ba2af0adabf'),(19,NULL,'app','m160707_000000_rename_richtext_assetsource_setting','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','1bfd8164-4ab1-4b27-8721-d928926aeecb'),(20,NULL,'app','m160708_185142_volume_hasUrls_setting','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','971306d6-753f-45e2-a0a9-75362f3a731e'),(21,NULL,'app','m160714_000000_increase_max_asset_filesize','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','ec245779-e880-416c-a4a3-a60b76702f1f'),(22,NULL,'app','m160727_194637_column_cleanup','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','8cf1c50e-10c7-48df-89e6-d587ae83eec5'),(23,NULL,'app','m160804_110002_userphotos_to_assets','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','1fbe8177-5ef3-406b-9497-81cb0ceb982f'),(24,NULL,'app','m160807_144858_sites','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','04c2b2e3-cdde-475f-8f42-b439285137ad'),(25,NULL,'app','m160817_161600_move_assets_cache','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','1a2195e7-7c75-4c1e-bff7-af8eca13448c'),(26,NULL,'app','m160829_000000_pending_user_content_cleanup','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','6fd8a7ea-d97a-40af-8e4d-8ba331e9b603'),(27,NULL,'app','m160830_000000_asset_index_uri_increase','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','54629aef-dbe7-4856-a82b-d4fea00052ea'),(28,NULL,'app','m160912_230520_require_entry_type_id','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','393c203b-2cb2-453e-9ac8-172da61d5229'),(29,NULL,'app','m160913_134730_require_matrix_block_type_id','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','872a3d5d-74bb-46f5-94a3-ce1fcdbfc76d'),(30,NULL,'app','m160920_174553_matrixblocks_owner_site_id_nullable','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','fd3b8e92-9a03-4aeb-86ac-c85e5c684f11'),(31,NULL,'app','m160920_231045_usergroup_handle_title_unique','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','c0b57d07-5dc1-4399-b780-2395d6603835'),(32,NULL,'app','m160925_113941_route_uri_parts','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','57bbfe0d-3097-4896-b9fc-ac847ce1295a'),(33,NULL,'app','m161006_205918_schemaVersion_not_null','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','6fb7b430-0779-42ab-b5ec-3e730465ccb9'),(34,NULL,'app','m161007_130653_update_email_settings','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','aab18131-dac6-43c7-8a5f-0e24fcb16a94'),(35,NULL,'app','m161013_175052_newParentId','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','78c09e49-0b9b-4b62-818e-00354af9d4ab'),(36,NULL,'app','m161021_102916_fix_recent_entries_widgets','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','fd86ba2e-eb11-40b8-976a-6a3218720cef'),(37,NULL,'app','m161021_182140_rename_get_help_widget','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','a8177e1a-49fe-42b9-8228-c2d13b5e082c'),(38,NULL,'app','m161025_000000_fix_char_columns','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','8d8c157a-e0c1-4d0d-8653-73c5d4a7779d'),(39,NULL,'app','m161029_124145_email_message_languages','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','0dad8743-a724-4e71-8e8d-c9ec20c88e38'),(40,NULL,'app','m161108_000000_new_version_format','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','54430c52-0589-4e9d-8b33-ff3871d2f2ef'),(41,NULL,'app','m161109_000000_index_shuffle','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','2f48cefe-f133-4487-815f-ecf952bd7544'),(42,NULL,'app','m161122_185500_no_craft_app','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','5e6329a4-acbd-404c-a113-dfe3c0a4c8b5'),(43,NULL,'app','m161125_150752_clear_urlmanager_cache','2017-02-06 18:39:45','2017-02-06 18:39:45','2017-02-06 18:39:45','db1745ef-c96a-47d7-a90f-9ad0a0cd7cbd'),(44,NULL,'app','m161220_000000_volumes_hasurl_notnull','2017-02-06 18:39:46','2017-02-06 18:39:46','2017-02-06 18:39:46','2d2adad6-fd8a-41e7-86f3-7a321694c752'),(45,NULL,'app','m170114_161144_udates_permission','2017-02-06 18:39:46','2017-02-06 18:39:46','2017-02-06 18:39:46','09b07934-1260-4e2b-8b10-1b746eaa731b'),(46,NULL,'app','m170120_000000_schema_cleanup','2017-02-06 18:39:46','2017-02-06 18:39:46','2017-02-06 18:39:46','56acfac8-1921-4bcf-86ee-fc59dccf4f66'),(47,NULL,'app','m170126_000000_assets_focal_point','2017-02-06 18:39:46','2017-02-06 18:39:46','2017-02-06 18:39:46','76895f19-2492-41d6-8e8b-b5f58cbd72c3'),(48,NULL,'app','m170206_142126_system_name','2017-02-10 19:25:09','2017-02-10 19:25:09','2017-02-10 19:25:09','a5d37c08-df66-45e8-b933-cab697d58a2c'),(49,NULL,'app','m170217_044740_category_branch_limits','2017-02-17 23:50:03','2017-02-17 23:50:03','2017-02-17 23:50:03','35812039-5dba-4b46-87f1-0c1a1e82cff1'),(50,NULL,'app','m170223_224012_plain_text_settings','2017-02-25 02:52:37','2017-02-25 02:52:37','2017-02-25 02:52:37','9cb50189-75d0-483b-9970-bc03f9557fc0'),(51,NULL,'app','m170217_120224_asset_indexing_columns','2017-03-04 05:19:08','2017-03-04 05:19:08','2017-03-04 05:19:08','30a74c51-aec0-43bf-8f80-f7111e3fd9f1'),(52,NULL,'app','m170227_120814_focal_point_percentage','2017-03-04 05:19:08','2017-03-04 05:19:08','2017-03-04 05:19:08','6376d714-bacf-4b2d-ae7a-f0c0dd3062f0'),(53,NULL,'app','m170228_171113_system_messages','2017-03-04 05:19:09','2017-03-04 05:19:09','2017-03-04 05:19:09','8b2ee32f-f938-4d61-960a-c7b420c0c66f');
/*!40000 ALTER TABLE `cx_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_plugins`
--

DROP TABLE IF EXISTS `cx_plugins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_plugins`
--

LOCK TABLES `cx_plugins` WRITE;
/*!40000 ALTER TABLE `cx_plugins` DISABLE KEYS */;
INSERT INTO `cx_plugins` VALUES (1,'doxter','3.0.6','3.0.0',NULL,'unknown',1,NULL,'2017-02-07 04:03:12','2017-02-07 04:03:12','2017-03-06 06:15:46','ecdf53eb-7e70-4cc1-b7f2-69b75c4dbc13'),(2,'swipe','1.0.0','1.0.0',NULL,'unknown',1,NULL,'2017-02-10 19:25:16','2017-02-10 19:25:16','2017-03-06 06:15:46','3954142a-2a74-431a-81c4-b16ef4e334cd');
/*!40000 ALTER TABLE `cx_plugins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_relations`
--

DROP TABLE IF EXISTS `cx_relations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_relations`
--

LOCK TABLES `cx_relations` WRITE;
/*!40000 ALTER TABLE `cx_relations` DISABLE KEYS */;
/*!40000 ALTER TABLE `cx_relations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_routes`
--

DROP TABLE IF EXISTS `cx_routes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_routes`
--

LOCK TABLES `cx_routes` WRITE;
/*!40000 ALTER TABLE `cx_routes` DISABLE KEYS */;
/*!40000 ALTER TABLE `cx_routes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_searchindex`
--

DROP TABLE IF EXISTS `cx_searchindex`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cx_searchindex` (
  `elementId` int(11) NOT NULL,
  `attribute` varchar(25) NOT NULL,
  `fieldId` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `keywords` text NOT NULL,
  PRIMARY KEY (`elementId`,`attribute`,`fieldId`,`siteId`),
  FULLTEXT KEY `cx_searchindex_keywords_idx` (`keywords`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_searchindex`
--

LOCK TABLES `cx_searchindex` WRITE;
/*!40000 ALTER TABLE `cx_searchindex` DISABLE KEYS */;
INSERT INTO `cx_searchindex` VALUES (1,'username',0,1,' selvinortiz '),(1,'firstname',0,1,' selvin '),(1,'lastname',0,1,' ortiz '),(1,'fullname',0,1,' selvin ortiz '),(1,'email',0,1,' selvin craftx io '),(1,'slug',0,1,''),(2,'slug',0,1,' homepage '),(2,'title',0,1,' homepage '),(2,'field',1,1,' craft training for busy developers '),(2,'field',2,1,' master craft cms and start crafting a better web '),(2,'field',4,1,''),(3,'field',10,1,' cus_a8eiebktjrp3tb '),(3,'field',13,1,' sub_a8eijgpyqdec67 '),(3,'field',11,1,''),(3,'field',12,1,''),(3,'field',9,1,''),(3,'field',5,1,''),(3,'field',6,1,''),(3,'field',7,1,''),(3,'field',8,1,''),(3,'username',0,1,' selvin selvin co '),(3,'firstname',0,1,' selvin '),(3,'lastname',0,1,' ortiz '),(3,'fullname',0,1,' selvin ortiz '),(3,'email',0,1,' selvin selvin co '),(3,'slug',0,1,''),(2,'field',17,1,' clear code clear code no squinting just large beautiful text and consice snippets for maximun readability clean sound clean sound no pops hiss or monotone just clean normalized audio for smooth distraction free listening quick pace quick pace no dozing off lessons are optimized to get you writing code and mastering craft as quickly as possible '),(2,'field',21,1,' selvin co https selvin co selvin ortiz web developer https selvinortiz com selvin has a great way of explaining complex topics and a true love for teaching penny ortiz photography penny ortiz i really love the way the courses are laid out and how each lesson is taught '),(2,'field',28,1,' start crafting now craft training for busy developers professionally crafted screencasts to help you master craft cms '),(1,'field',10,1,''),(4,'field',29,1,' craft training for busy developers '),(4,'field',30,1,' professionally crafted screencasts to help you master craft cms '),(4,'field',31,1,' start crafting now '),(4,'slug',0,1,''),(5,'field',18,1,' clear code '),(5,'field',19,1,' no squinting just large beautiful text and consice snippets for maximun readability '),(5,'field',20,1,' clear code '),(5,'slug',0,1,''),(6,'field',18,1,' clean sound '),(6,'field',19,1,' no pops hiss or monotone just clean normalized audio for smooth distraction free listening '),(6,'field',20,1,' clean sound '),(6,'slug',0,1,''),(7,'field',18,1,' quick pace '),(7,'field',19,1,' no dozing off lessons are optimized to get you writing code and mastering craft as quickly as possible '),(7,'field',20,1,' quick pace '),(7,'slug',0,1,''),(8,'field',22,1,' selvin has a great way of explaining complex topics and a true love for teaching '),(8,'field',23,1,' selvin ortiz '),(8,'field',24,1,' https selvinortiz com '),(8,'field',25,1,' web developer '),(8,'field',26,1,' selvin co '),(8,'field',27,1,' https selvin co '),(8,'slug',0,1,''),(9,'field',22,1,' i really love the way the courses are laid out and how each lesson is taught '),(9,'field',23,1,' penny ortiz '),(9,'field',24,1,''),(9,'field',25,1,''),(9,'field',26,1,' penny ortiz photography '),(9,'field',27,1,''),(9,'slug',0,1,''),(1,'field',13,1,''),(1,'field',11,1,''),(1,'field',12,1,''),(1,'field',9,1,''),(1,'field',5,1,''),(1,'field',6,1,''),(1,'field',7,1,''),(1,'field',8,1,''),(2,'field',32,1,' craft training for busy developers '),(2,'field',33,1,' master craft cms through carefully crafted screencasts produced and presented by an industry veteran '),(10,'field',33,1,' craft training for busy developers '),(10,'field',3,1,' its almost here after announcing craftx in slack having nothing to share i was overwhelmed by the response from the community that positive feedback led me to setting aside a few days to focus on this project get the site mvp at this point up and start producing content it has been an amazing journey alrady and i havent even started if i fail i will be happy that at least craftx did not die as an idea anyway what is it craftx is membership based website where i distribute premium training content for craft cms in the form of screencasts who is it for craftx is for busy developers like you who want to master craft cms without wasting time how much will it cost im leaning on the community to come up with something that is fair to you and sustainable for me '),(10,'slug',0,1,' announcing craftx '),(10,'title',0,1,' announcing craftx ');
/*!40000 ALTER TABLE `cx_searchindex` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_sections`
--

DROP TABLE IF EXISTS `cx_sections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_sections`
--

LOCK TABLES `cx_sections` WRITE;
/*!40000 ALTER TABLE `cx_sections` DISABLE KEYS */;
INSERT INTO `cx_sections` VALUES (1,NULL,'Homepage','homepage','single',0,'2017-02-06 18:57:45','2017-02-06 18:57:45','6f4ca3af-f6ea-4aa0-b25c-1a697f0225f1'),(3,1,'Series','series','structure',1,'2017-03-06 17:08:44','2017-03-06 18:03:42','219320bb-42a2-4b61-af10-fc4eb0bb1d68'),(4,NULL,'Blog','blog','channel',1,'2017-03-06 17:09:13','2017-03-06 17:09:13','599f5da3-13be-4487-b8c6-4152f1b27c0f');
/*!40000 ALTER TABLE `cx_sections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_sections_i18n`
--

DROP TABLE IF EXISTS `cx_sections_i18n`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_sections_i18n`
--

LOCK TABLES `cx_sections_i18n` WRITE;
/*!40000 ALTER TABLE `cx_sections_i18n` DISABLE KEYS */;
INSERT INTO `cx_sections_i18n` VALUES (1,1,1,1,1,'__home__','index','2017-02-06 18:57:45','2017-02-06 23:59:44','7544fcbf-9302-4044-b213-89fa766f1286'),(3,3,1,1,1,'series/{slug}','series/_entry','2017-03-06 17:08:44','2017-03-06 18:03:42','786a072c-7bcc-45e3-abae-f2d38d4daf73'),(4,4,1,1,1,'blog/{slug}','blog/_entry','2017-03-06 17:09:13','2017-03-06 17:09:13','cb0149df-b84d-47da-94f9-5289ec081d34');
/*!40000 ALTER TABLE `cx_sections_i18n` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_sessions`
--

DROP TABLE IF EXISTS `cx_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_sessions`
--

LOCK TABLES `cx_sessions` WRITE;
/*!40000 ALTER TABLE `cx_sessions` DISABLE KEYS */;
INSERT INTO `cx_sessions` VALUES (1,1,'p0LVU-_07ZUJdh_JGVpakXYQYIzLhqEApCxQg5b4BZdYYhvP2RzR36l0UTrXwlaPeGiSCI-6SdrtwyyiFhclMbaJR_z6Guawnqkd','2017-02-06 23:54:19','2017-02-07 02:07:30','be03a40a-c990-4ecc-806c-3cd38480273e'),(2,1,'qWpu17cuAtw5-zA12eNKy2fG_GZGHw01mocf7sBOe5qqtr3_A0atNrvoeBmD0RnP5_9z_X7SEnukkkFs6wc1QRMuuCOtpf8dgTxF','2017-02-07 03:53:45','2017-02-07 04:07:36','977f4875-ea65-4664-a5b5-adca9854cf11'),(3,1,'qf0t1fiusgf-nc7fLP7Dn6hSkn6wsGXo-Xf2Xh0qoppHl8cwzicM1xKcVrLQ5iaiEzYSjibj2db_7roIi3iFiDt_WGtIs9_MDj_e','2017-02-07 05:13:35','2017-02-07 05:31:16','74e68c1d-3586-4326-a90a-50587a7f7ef9'),(5,1,'rxjm49_XJnSC5vZwhVvjILtjzW7BlQCBSaRCZo4iVU8V6T4Ix8zo3hlYAXeSe7TRHp_UaykcLZnJokglPPMle8ZQ7g8MO4thDaV_','2017-02-11 03:42:22','2017-02-11 03:47:59','03c6b384-8bc9-449a-a756-7602d3025f14'),(6,1,'8frYGtEccGxg2UlSzsH-CqcgErXkZUxYkbPNwepG-_isMcBHeYeijovM-W8kuSEGtS1DR96VEDG4d8Xq_IYzxaj_tI3Lf29Wp5N1','2017-02-13 04:22:59','2017-02-13 04:37:19','977cdb4f-a754-4829-aa4d-ccf21824513c'),(7,1,'U1noLV4rAJ497QSHMtY7Rh-AdXlbaFM7-De327o8cpxFgPQfiG2KNZ7adDGDgekCLzeN1hy54o9cXemX0s0g9ZYs7708GtiRWKGM','2017-02-13 06:15:52','2017-02-13 06:15:52','81103b06-681d-4064-b289-7392650a5f06'),(8,1,'a47N530MG1bDfBwg9ZvUXcq2uGS3rtKVqkhrkQwTImE944Zb1pOvT6ScWDXBxelUr9PYwEhuFxV0tLx8jhqKEZ6R2KeVRqBlJdbc','2017-02-13 07:10:58','2017-02-13 07:31:05','9ceac91a-9f69-46d4-8ef1-f5c3c85ab77b'),(10,1,'f0SsTvAn9ptioDYrYbEncTN2gRp9NNgS1G8WPUjhn2PSMwPSDRW_ReIjYDEE73Hspyj2o2loHt7yhhPKdwA9taeOz8SU2eZizbBZ','2017-02-16 04:01:06','2017-02-16 04:03:42','75d7bd5d-8591-4ac4-8bbe-a20682328209'),(14,1,'20geVmBlM_SIRPdYmLiyxXUotWAEV2jRIcWp3e9lxRMTJf-75kW7JjClne1eeb5r9pbNX8wzkfINQklJooO3OIyU9_tuhFqnv8Gg','2017-02-18 01:31:40','2017-02-18 02:08:20','3389e6ce-6408-41b0-9118-e9da2ae66e65'),(15,3,'JEhuZ7AybXhRKCWH8efoAgt_ZxCygb3QPJ5uqZYgteouij0Je4RXXfa4Lj_ualYhOVLV8yHc_0t4pluGbpofoLxx0pwgWmtDcTI0','2017-02-23 04:24:34','2017-02-23 04:52:48','ce77a4fa-592c-4407-95dd-24238fed688b');
/*!40000 ALTER TABLE `cx_sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_shunnedmessages`
--

DROP TABLE IF EXISTS `cx_shunnedmessages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_shunnedmessages`
--

LOCK TABLES `cx_shunnedmessages` WRITE;
/*!40000 ALTER TABLE `cx_shunnedmessages` DISABLE KEYS */;
/*!40000 ALTER TABLE `cx_shunnedmessages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_sites`
--

DROP TABLE IF EXISTS `cx_sites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_sites`
--

LOCK TABLES `cx_sites` WRITE;
/*!40000 ALTER TABLE `cx_sites` DISABLE KEYS */;
INSERT INTO `cx_sites` VALUES (1,'CraftX','default','en-US',1,'http://{siteUrl}',1,'2017-02-06 18:39:45','2017-03-06 07:16:08','2919439f-9a4e-4fee-aa13-334959abcfe0');
/*!40000 ALTER TABLE `cx_sites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_structureelements`
--

DROP TABLE IF EXISTS `cx_structureelements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_structureelements`
--

LOCK TABLES `cx_structureelements` WRITE;
/*!40000 ALTER TABLE `cx_structureelements` DISABLE KEYS */;
/*!40000 ALTER TABLE `cx_structureelements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_structures`
--

DROP TABLE IF EXISTS `cx_structures`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cx_structures` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `maxLevels` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_structures`
--

LOCK TABLES `cx_structures` WRITE;
/*!40000 ALTER TABLE `cx_structures` DISABLE KEYS */;
INSERT INTO `cx_structures` VALUES (1,2,'2017-03-06 17:08:44','2017-03-06 18:03:42','5153078c-1ec8-40dd-90f6-6e8f22955a57');
/*!40000 ALTER TABLE `cx_structures` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_systemmessages`
--

DROP TABLE IF EXISTS `cx_systemmessages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cx_systemmessages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `language` varchar(255) NOT NULL,
  `key` varchar(255) NOT NULL,
  `subject` text NOT NULL,
  `body` text NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_systemmessages_key_language_unq_idx` (`key`,`language`),
  KEY `cx_systemmessages_language_idx` (`language`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_systemmessages`
--

LOCK TABLES `cx_systemmessages` WRITE;
/*!40000 ALTER TABLE `cx_systemmessages` DISABLE KEYS */;
INSERT INTO `cx_systemmessages` VALUES (1,'en-US','test_email','Email Settings','Hi, this email confirms that your settings are properly set up.','2017-03-03 07:40:19','2017-03-03 07:40:19','45ba3fbf-869b-4e9d-af83-b1a4297a3a2f');
/*!40000 ALTER TABLE `cx_systemmessages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_systemsettings`
--

DROP TABLE IF EXISTS `cx_systemsettings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cx_systemsettings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category` varchar(15) NOT NULL,
  `settings` text,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_systemsettings_category_unq_idx` (`category`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_systemsettings`
--

LOCK TABLES `cx_systemsettings` WRITE;
/*!40000 ALTER TABLE `cx_systemsettings` DISABLE KEYS */;
INSERT INTO `cx_systemsettings` VALUES (1,'email','{\"fromEmail\":\"support@craftx.io\",\"fromName\":\"CraftX\",\"template\":\"_special/email\",\"transportType\":\"craft\\\\mail\\\\transportadapters\\\\Smtp\",\"transportSettings\":{\"host\":\"email-smtp.us-west-2.amazonaws.com\",\"port\":\"587\",\"useAuthentication\":\"1\",\"username\":\"AKIAIEWSWLZUUCXCH2KA\",\"password\":\"Ajm0cYgkvNJNAA2qEPqDeTmKsaxS/tmFml8o6YdWOxFT\",\"encryptionMethod\":\"tls\",\"timeout\":\"10\"}}','2017-02-06 18:39:45','2017-03-03 07:38:50','4525a971-81ae-42b5-9d4a-5acf34858293'),(2,'mailer','{\"class\":\"craft\\\\mail\\\\Mailer\",\"from\":{\"selvin@craftx.io\":\"Craft X\"},\"transport\":{\"class\":\"Swift_MailTransport\"}}','2017-02-06 18:39:45','2017-02-06 18:39:45','b7448476-6236-46f1-ad36-f0992fc3f5bc'),(3,'users','{\"requireEmailVerification\":true,\"allowPublicRegistration\":true,\"defaultGroup\":\"2\",\"photoVolumeId\":null}','2017-02-13 06:23:39','2017-03-03 07:32:21','4c6b2690-22ed-4939-9129-bb876eb7be07');
/*!40000 ALTER TABLE `cx_systemsettings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_taggroups`
--

DROP TABLE IF EXISTS `cx_taggroups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_taggroups`
--

LOCK TABLES `cx_taggroups` WRITE;
/*!40000 ALTER TABLE `cx_taggroups` DISABLE KEYS */;
/*!40000 ALTER TABLE `cx_taggroups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_tags`
--

DROP TABLE IF EXISTS `cx_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_tags`
--

LOCK TABLES `cx_tags` WRITE;
/*!40000 ALTER TABLE `cx_tags` DISABLE KEYS */;
/*!40000 ALTER TABLE `cx_tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_tasks`
--

DROP TABLE IF EXISTS `cx_tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_tasks`
--

LOCK TABLES `cx_tasks` WRITE;
/*!40000 ALTER TABLE `cx_tasks` DISABLE KEYS */;
/*!40000 ALTER TABLE `cx_tasks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_templatecacheelements`
--

DROP TABLE IF EXISTS `cx_templatecacheelements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cx_templatecacheelements` (
  `cacheId` int(11) NOT NULL,
  `elementId` int(11) NOT NULL,
  KEY `cx_templatecacheelements_cacheId_fk` (`cacheId`),
  KEY `cx_templatecacheelements_elementId_fk` (`elementId`),
  CONSTRAINT `cx_templatecacheelements_cacheId_fk` FOREIGN KEY (`cacheId`) REFERENCES `cx_templatecaches` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cx_templatecacheelements_elementId_fk` FOREIGN KEY (`elementId`) REFERENCES `cx_elements` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_templatecacheelements`
--

LOCK TABLES `cx_templatecacheelements` WRITE;
/*!40000 ALTER TABLE `cx_templatecacheelements` DISABLE KEYS */;
/*!40000 ALTER TABLE `cx_templatecacheelements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_templatecachequeries`
--

DROP TABLE IF EXISTS `cx_templatecachequeries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_templatecachequeries`
--

LOCK TABLES `cx_templatecachequeries` WRITE;
/*!40000 ALTER TABLE `cx_templatecachequeries` DISABLE KEYS */;
/*!40000 ALTER TABLE `cx_templatecachequeries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_templatecaches`
--

DROP TABLE IF EXISTS `cx_templatecaches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_templatecaches`
--

LOCK TABLES `cx_templatecaches` WRITE;
/*!40000 ALTER TABLE `cx_templatecaches` DISABLE KEYS */;
/*!40000 ALTER TABLE `cx_templatecaches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_tokens`
--

DROP TABLE IF EXISTS `cx_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_tokens`
--

LOCK TABLES `cx_tokens` WRITE;
/*!40000 ALTER TABLE `cx_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `cx_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_usergroups`
--

DROP TABLE IF EXISTS `cx_usergroups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_usergroups`
--

LOCK TABLES `cx_usergroups` WRITE;
/*!40000 ALTER TABLE `cx_usergroups` DISABLE KEYS */;
INSERT INTO `cx_usergroups` VALUES (2,'Developers','developers','2017-03-03 07:32:05','2017-03-03 07:32:05','ebe0b2dc-2991-4991-a39a-6f0ab0b00095');
/*!40000 ALTER TABLE `cx_usergroups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_usergroups_users`
--

DROP TABLE IF EXISTS `cx_usergroups_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_usergroups_users`
--

LOCK TABLES `cx_usergroups_users` WRITE;
/*!40000 ALTER TABLE `cx_usergroups_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `cx_usergroups_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_userpermissions`
--

DROP TABLE IF EXISTS `cx_userpermissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cx_userpermissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_userpermissions_name_unq_idx` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_userpermissions`
--

LOCK TABLES `cx_userpermissions` WRITE;
/*!40000 ALTER TABLE `cx_userpermissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `cx_userpermissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_userpermissions_usergroups`
--

DROP TABLE IF EXISTS `cx_userpermissions_usergroups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_userpermissions_usergroups`
--

LOCK TABLES `cx_userpermissions_usergroups` WRITE;
/*!40000 ALTER TABLE `cx_userpermissions_usergroups` DISABLE KEYS */;
/*!40000 ALTER TABLE `cx_userpermissions_usergroups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_userpermissions_users`
--

DROP TABLE IF EXISTS `cx_userpermissions_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_userpermissions_users`
--

LOCK TABLES `cx_userpermissions_users` WRITE;
/*!40000 ALTER TABLE `cx_userpermissions_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `cx_userpermissions_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_userpreferences`
--

DROP TABLE IF EXISTS `cx_userpreferences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cx_userpreferences` (
  `userId` int(11) NOT NULL AUTO_INCREMENT,
  `preferences` text,
  PRIMARY KEY (`userId`),
  CONSTRAINT `cx_userpreferences_userId_fk` FOREIGN KEY (`userId`) REFERENCES `cx_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_userpreferences`
--

LOCK TABLES `cx_userpreferences` WRITE;
/*!40000 ALTER TABLE `cx_userpreferences` DISABLE KEYS */;
INSERT INTO `cx_userpreferences` VALUES (1,'{\"language\":null,\"weekStartDay\":\"0\",\"enableDebugToolbarForSite\":true,\"enableDebugToolbarForCp\":true}');
/*!40000 ALTER TABLE `cx_userpreferences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_users`
--

DROP TABLE IF EXISTS `cx_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_users`
--

LOCK TABLES `cx_users` WRITE;
/*!40000 ALTER TABLE `cx_users` DISABLE KEYS */;
INSERT INTO `cx_users` VALUES (1,'selvinortiz',NULL,'Selvin','Ortiz','selvin@craftx.io','$2y$13$lpMCTvAg0o/B.7enJrbT.OuB4zToqUGASlsZsfFE8vf94dzoxGbEu',1,0,0,0,0,0,'2017-03-06 19:41:54','50.188.56.107',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2017-02-06 18:39:45','2017-02-06 18:39:45','2017-03-06 19:41:54','6dd21ec5-be58-47c4-9c4e-4f04346dd128'),(3,'selvin-selvinco',NULL,'Selvin','Ortiz','selvin@selvin.co','$2y$13$Sslt7yvMuB2eV0jKxhMrJeUWWeYVGukE2jCnXjM.P/I6vNeviqNv2',0,0,0,0,0,0,'2017-02-23 19:26:26','192.168.10.1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2017-02-23 04:24:10','2017-02-18 01:30:24','2017-02-23 19:26:26','08ba55cf-b8f7-4b94-b43f-d335ed2dacfa');
/*!40000 ALTER TABLE `cx_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_volumefolders`
--

DROP TABLE IF EXISTS `cx_volumefolders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_volumefolders`
--

LOCK TABLES `cx_volumefolders` WRITE;
/*!40000 ALTER TABLE `cx_volumefolders` DISABLE KEYS */;
INSERT INTO `cx_volumefolders` VALUES (1,NULL,1,'Blog','','2017-03-06 17:12:42','2017-03-06 17:12:42','765132af-b54e-413c-b40f-a14b9c2f52d3');
/*!40000 ALTER TABLE `cx_volumefolders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_volumes`
--

DROP TABLE IF EXISTS `cx_volumes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_volumes`
--

LOCK TABLES `cx_volumes` WRITE;
/*!40000 ALTER TABLE `cx_volumes` DISABLE KEYS */;
INSERT INTO `cx_volumes` VALUES (1,22,'Blog','blog','craft\\volumes\\Local',1,'/blog/','{\"path\":\"{sitePath}/blog\"}',1,'2017-03-06 17:12:42','2017-03-06 17:12:42','8754cc4e-3197-4570-a19b-df1234721dd6');
/*!40000 ALTER TABLE `cx_volumes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cx_widgets`
--

DROP TABLE IF EXISTS `cx_widgets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cx_widgets`
--

LOCK TABLES `cx_widgets` WRITE;
/*!40000 ALTER TABLE `cx_widgets` DISABLE KEYS */;
INSERT INTO `cx_widgets` VALUES (1,1,'craft\\widgets\\RecentEntries',NULL,0,'{\"section\":\"*\",\"siteId\":\"1\",\"limit\":10}',1,'2017-02-06 18:47:24','2017-02-06 18:47:24','936f422c-de0f-4856-ba85-c3d2f1910316'),(2,1,'craft\\widgets\\CraftSupport',NULL,0,'[]',1,'2017-02-06 18:47:24','2017-02-06 18:47:24','5cbb24e0-1200-4fd4-9a22-a6d0ff6ed0c6'),(3,1,'craft\\widgets\\Updates',NULL,0,'[]',1,'2017-02-06 18:47:24','2017-02-06 18:47:24','d2e06d28-8b9e-42a1-b121-43f96de01209'),(4,1,'craft\\widgets\\Feed',NULL,0,'{\"url\":\"https://craftcms.com/news.rss\",\"title\":\"Craft News\",\"limit\":5}',1,'2017-02-06 18:47:24','2017-02-06 18:47:24','54331635-6276-4083-9291-a51b5adbf160');
/*!40000 ALTER TABLE `cx_widgets` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-03-06 14:05:56
