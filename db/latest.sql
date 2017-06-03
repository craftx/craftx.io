#
# SQL Export
# Created by Querious (1068)
# Created: June 3, 2017 at 8:11:21 AM CDT
# Encoding: Unicode (UTF-8)
#


SET @PREVIOUS_FOREIGN_KEY_CHECKS = @@FOREIGN_KEY_CHECKS;
SET FOREIGN_KEY_CHECKS = 0;


DROP TABLE IF EXISTS `cx_widgets`;
DROP TABLE IF EXISTS `cx_volumefolders`;
DROP TABLE IF EXISTS `cx_volumes`;
DROP TABLE IF EXISTS `cx_userpreferences`;
DROP TABLE IF EXISTS `cx_userpermissions_users`;
DROP TABLE IF EXISTS `cx_users`;
DROP TABLE IF EXISTS `cx_userpermissions_usergroups`;
DROP TABLE IF EXISTS `cx_userpermissions`;
DROP TABLE IF EXISTS `cx_usergroups_users`;
DROP TABLE IF EXISTS `cx_usergroups`;
DROP TABLE IF EXISTS `cx_tokens`;
DROP TABLE IF EXISTS `cx_templatecachequeries`;
DROP TABLE IF EXISTS `cx_templatecacheelements`;
DROP TABLE IF EXISTS `cx_templatecaches`;
DROP TABLE IF EXISTS `cx_tasks`;
DROP TABLE IF EXISTS `cx_tags`;
DROP TABLE IF EXISTS `cx_taggroups`;
DROP TABLE IF EXISTS `cx_systemsettings`;
DROP TABLE IF EXISTS `cx_systemmessages`;
DROP TABLE IF EXISTS `cx_structureelements`;
DROP TABLE IF EXISTS `cx_structures`;
DROP TABLE IF EXISTS `cx_sites`;
DROP TABLE IF EXISTS `cx_shunnedmessages`;
DROP TABLE IF EXISTS `cx_sessions`;
DROP TABLE IF EXISTS `cx_sections_i18n`;
DROP TABLE IF EXISTS `cx_sections`;
DROP TABLE IF EXISTS `cx_searchindex`;
DROP TABLE IF EXISTS `cx_routes`;
DROP TABLE IF EXISTS `cx_relations`;
DROP TABLE IF EXISTS `cx_migrations`;
DROP TABLE IF EXISTS `cx_plugins`;
DROP TABLE IF EXISTS `cx_matrixcontent_technologies`;
DROP TABLE IF EXISTS `cx_matrixcontent_hero`;
DROP TABLE IF EXISTS `cx_matrixcontent_features`;
DROP TABLE IF EXISTS `cx_matrixblocks`;
DROP TABLE IF EXISTS `cx_matrixblocktypes`;
DROP TABLE IF EXISTS `cx_info`;
DROP TABLE IF EXISTS `cx_globalsets`;
DROP TABLE IF EXISTS `cx_fieldlayoutfields`;
DROP TABLE IF EXISTS `cx_fields`;
DROP TABLE IF EXISTS `cx_fieldlayouttabs`;
DROP TABLE IF EXISTS `cx_fieldgroups`;
DROP TABLE IF EXISTS `cx_entryversions`;
DROP TABLE IF EXISTS `cx_entrytypes`;
DROP TABLE IF EXISTS `cx_fieldlayouts`;
DROP TABLE IF EXISTS `cx_entrydrafts`;
DROP TABLE IF EXISTS `cx_entries`;
DROP TABLE IF EXISTS `cx_elements_i18n`;
DROP TABLE IF EXISTS `cx_elementindexsettings`;
DROP TABLE IF EXISTS `cx_deprecationerrors`;
DROP TABLE IF EXISTS `cx_content`;
DROP TABLE IF EXISTS `cx_categorygroups_i18n`;
DROP TABLE IF EXISTS `cx_categories`;
DROP TABLE IF EXISTS `cx_categorygroups`;
DROP TABLE IF EXISTS `cx_assettransforms`;
DROP TABLE IF EXISTS `cx_assettransformindex`;
DROP TABLE IF EXISTS `cx_assets`;
DROP TABLE IF EXISTS `cx_elements`;
DROP TABLE IF EXISTS `cx_assetindexdata`;


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


CREATE TABLE `cx_elements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `archived` tinyint(1) NOT NULL DEFAULT '0',
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  `fieldLayoutId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cx_elements_type_idx` (`type`),
  KEY `cx_elements_enabled_idx` (`enabled`),
  KEY `cx_elements_archived_dateCreated_idx` (`archived`,`dateCreated`),
  KEY `cx_elements_fieldLayoutId_fk` (`fieldLayoutId`),
  CONSTRAINT `cx_elements_fieldLayoutId_fk` FOREIGN KEY (`fieldLayoutId`) REFERENCES `cx_fieldlayouts` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8;


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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;


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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;


CREATE TABLE `cx_content` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `elementId` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  `field_markdown` text,
  `field_lead` text,
  `field_text` text,
  `field_dateTime` datetime DEFAULT NULL,
  `field_hangoutDateTime` datetime DEFAULT NULL,
  `field_hangoutTopic` text,
  `field_hangoutNotes` text,
  `field_hangoutLink` text,
  `field_firstName` text,
  `field_lastName` text,
  `field_primaryWebsite` text,
  `field_slackUsername` text,
  `field_twitterUsername` text,
  `field_githubUsername` text,
  `field_role` text,
  `field_company` text,
  `field_hangoutStream` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_content_elementId_siteId_unq_idx` (`elementId`,`siteId`),
  KEY `cx_content_siteId_fk` (`siteId`),
  KEY `cx_content_title_fk` (`title`),
  CONSTRAINT `cx_content_elementId_fk` FOREIGN KEY (`elementId`) REFERENCES `cx_elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cx_content_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `cx_sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8;


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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;


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
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8;


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


CREATE TABLE `cx_fieldlayouts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `cx_fieldlayouts_type_idx` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8;


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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;


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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;


CREATE TABLE `cx_fieldgroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_fieldgroups_name_unq_idx` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;


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
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8;


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
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8;


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
) ENGINE=InnoDB AUTO_INCREMENT=327 DEFAULT CHARSET=utf8;


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
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8;


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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;


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


CREATE TABLE `cx_matrixcontent_features` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `elementId` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  `field_feature_featureLead` text,
  `field_feature_featureText` text,
  `field_feature_featureImagePath` text,
  `field_feature_featureCtaText` text,
  `field_feature_featureCtaUrl` text,
  `field_feature_featureCtaIconClasses` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_matrixcontent_features_elementId_siteId_idx` (`elementId`,`siteId`),
  KEY `cx_matrixcontent_features_siteId_fk` (`siteId`),
  CONSTRAINT `cx_matrixcontent_features_elementId_fk` FOREIGN KEY (`elementId`) REFERENCES `cx_elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cx_matrixcontent_features_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `cx_sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;


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
  `field_hero_heroCtaUrl` text,
  `field_hero_heroCtaIconClasses` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_matrixcontent_hero_elementId_siteId_idx` (`elementId`,`siteId`),
  KEY `cx_matrixcontent_hero_siteId_fk` (`siteId`),
  CONSTRAINT `cx_matrixcontent_hero_elementId_fk` FOREIGN KEY (`elementId`) REFERENCES `cx_elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cx_matrixcontent_hero_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `cx_sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;


CREATE TABLE `cx_matrixcontent_technologies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `elementId` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  `field_technology_technologyName` text,
  `field_technology_technologyUrl` text,
  `field_technology_technologyImagePath` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_matrixcontent_technologies_elementId_siteId_idx` (`elementId`,`siteId`),
  KEY `cx_matrixcontent_technologies_siteId_fk` (`siteId`),
  CONSTRAINT `cx_matrixcontent_technologies_elementId_fk` FOREIGN KEY (`elementId`) REFERENCES `cx_elements` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cx_matrixcontent_technologies_siteId_fk` FOREIGN KEY (`siteId`) REFERENCES `cx_sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;


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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;


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
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8;


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
) ENGINE=InnoDB AUTO_INCREMENT=538 DEFAULT CHARSET=utf8;


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


CREATE TABLE `cx_searchindex` (
  `elementId` int(11) NOT NULL,
  `attribute` varchar(25) NOT NULL,
  `fieldId` int(11) NOT NULL,
  `siteId` int(11) NOT NULL,
  `keywords` text NOT NULL,
  PRIMARY KEY (`elementId`,`attribute`,`fieldId`,`siteId`),
  FULLTEXT KEY `cx_searchindex_keywords_idx` (`keywords`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;


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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;


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
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;


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


CREATE TABLE `cx_structures` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `maxLevels` smallint(6) unsigned DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;


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
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;


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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;


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
) ENGINE=InnoDB AUTO_INCREMENT=161 DEFAULT CHARSET=utf8;


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


CREATE TABLE `cx_templatecacheelements` (
  `cacheId` int(11) NOT NULL,
  `elementId` int(11) NOT NULL,
  KEY `cx_templatecacheelements_cacheId_fk` (`cacheId`),
  KEY `cx_templatecacheelements_elementId_fk` (`elementId`),
  CONSTRAINT `cx_templatecacheelements_cacheId_fk` FOREIGN KEY (`cacheId`) REFERENCES `cx_templatecaches` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cx_templatecacheelements_elementId_fk` FOREIGN KEY (`elementId`) REFERENCES `cx_elements` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


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
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;


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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;


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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;


CREATE TABLE `cx_userpermissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime NOT NULL,
  `uid` char(36) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cx_userpermissions_name_unq_idx` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8;


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
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8;


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


CREATE TABLE `cx_userpreferences` (
  `userId` int(11) NOT NULL AUTO_INCREMENT,
  `preferences` text,
  PRIMARY KEY (`userId`),
  CONSTRAINT `cx_userpreferences_userId_fk` FOREIGN KEY (`userId`) REFERENCES `cx_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8;


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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;


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
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8;


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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;




SET FOREIGN_KEY_CHECKS = @PREVIOUS_FOREIGN_KEY_CHECKS;


SET @PREVIOUS_FOREIGN_KEY_CHECKS = @@FOREIGN_KEY_CHECKS;
SET FOREIGN_KEY_CHECKS = 0;


LOCK TABLES `cx_assetindexdata` WRITE;
ALTER TABLE `cx_assetindexdata` DISABLE KEYS;
ALTER TABLE `cx_assetindexdata` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_elements` WRITE;
ALTER TABLE `cx_elements` DISABLE KEYS;
INSERT INTO `cx_elements` (`id`, `type`, `enabled`, `archived`, `dateCreated`, `dateUpdated`, `uid`, `fieldLayoutId`) VALUES 
	(1,'craft\\elements\\User',1,0,'2017-02-06 18:39:45','2017-06-03 12:58:46','8f9b3b5a-a4c8-40c5-970a-01394dc85b8a',27),
	(2,'craft\\elements\\Entry',1,0,'2017-02-06 18:57:45','2017-06-03 12:32:51','ed27feb3-0e3f-457b-be29-6a7d20af0a51',18),
	(4,'craft\\elements\\MatrixBlock',1,0,'2017-03-05 05:52:42','2017-06-03 12:32:51','c2197b23-31fb-46cb-af30-77c78184d21e',17),
	(5,'craft\\elements\\MatrixBlock',1,0,'2017-03-05 05:52:42','2017-06-03 12:32:51','cc2de781-41ee-49c7-83ee-2b959c519595',16),
	(6,'craft\\elements\\MatrixBlock',1,0,'2017-03-05 05:52:42','2017-06-03 12:32:51','29ffa80a-a8b6-4487-9d51-56249ce6b29f',16),
	(7,'craft\\elements\\MatrixBlock',1,0,'2017-03-05 05:52:42','2017-06-03 12:32:51','dbc1ed27-8205-49a4-915e-cadd95227eab',16),
	(25,'craft\\elements\\Asset',1,0,'2017-04-08 06:07:47','2017-05-02 03:08:27','f3187e5a-0111-4718-81fb-c7f22f4d6acd',28),
	(26,'craft\\elements\\Asset',1,0,'2017-04-08 06:08:27','2017-05-02 03:08:28','d0ce5043-01a0-4ada-b11b-947548b61122',28),
	(28,'craft\\elements\\Entry',1,0,'2017-04-26 05:02:36','2017-05-30 04:34:08','c9438402-1769-4ccf-a4e6-351c5fdbfcbf',29),
	(29,'craft\\elements\\Entry',1,0,'2017-04-26 17:31:08','2017-05-30 04:34:08','61e9eaf8-4887-4cf4-a82b-cce5287f5efa',29),
	(32,'craft\\elements\\Entry',1,0,'2017-04-27 20:59:45','2017-05-22 04:23:21','ea347230-8948-4cd9-b89a-15de0e83bf18',30),
	(33,'craft\\elements\\Entry',1,0,'2017-04-27 21:01:21','2017-05-22 04:23:21','278e0ee3-5734-4818-9365-f4ea9e1fd5a6',30),
	(34,'craft\\elements\\Entry',1,0,'2017-04-27 21:07:23','2017-05-22 04:23:21','5b96bd46-cdbc-40ae-81ad-ea945cedcd9b',30),
	(35,'craft\\elements\\Entry',1,0,'2017-04-27 21:09:02','2017-05-22 04:23:21','010c8f9d-3cb4-4744-941f-9a2c8c3b0aa6',30),
	(36,'craft\\elements\\Entry',1,0,'2017-04-27 21:10:56','2017-05-22 04:23:21','4e3f1dce-a4ec-4ecf-8fd2-648de1467b8a',30),
	(37,'craft\\elements\\Entry',1,0,'2017-04-28 16:10:51','2017-05-30 04:34:08','3cddd561-a351-42ea-9344-2c94970e5be4',29),
	(38,'craft\\elements\\Entry',1,0,'2017-04-28 16:46:35','2017-05-22 04:23:21','66fa4aeb-cfcf-4db4-9df6-6c6d89fd2c16',30),
	(39,'craft\\elements\\Category',1,0,'2017-04-28 20:02:32','2017-04-28 20:02:32','3789316a-6338-4769-90d3-decedd08d023',31),
	(40,'craft\\elements\\Category',1,0,'2017-04-28 20:02:45','2017-04-28 20:02:45','a629fe34-00b6-4e33-a294-8f4d7b980b40',31),
	(41,'craft\\elements\\Category',1,0,'2017-04-28 20:05:02','2017-04-28 20:05:02','a3ada639-34a2-4106-a659-7dc3620bb263',31),
	(42,'craft\\elements\\Category',1,0,'2017-04-28 20:05:13','2017-04-28 20:05:13','5787b5da-c6c4-4219-b024-557d7cac0ef1',31),
	(43,'craft\\elements\\Entry',1,0,'2017-05-02 19:30:22','2017-05-30 04:34:08','c069ea13-0f6b-494c-8e5a-58d0929d2f7e',29),
	(44,'craft\\elements\\Entry',1,0,'2017-05-03 12:13:03','2017-05-22 04:23:21','e185cc65-52ee-4fe8-8b97-81d46d9592e5',30),
	(45,'craft\\elements\\Entry',1,0,'2017-05-03 12:30:00','2017-05-22 04:23:21','78592aca-7943-49f5-8a99-91ac56e82e3a',30),
	(50,'craft\\elements\\GlobalSet',1,0,'2017-05-08 20:49:37','2017-05-15 23:57:54','ed2e2bd0-bdce-44de-8805-1713252d34d2',32),
	(51,'craft\\elements\\Category',1,0,'2017-05-11 15:48:44','2017-05-11 15:48:44','4818ce7b-cab2-465b-9155-8c7d3892aa5a',31),
	(52,'craft\\elements\\Entry',1,0,'2017-05-11 16:04:56','2017-05-30 04:34:08','e37078fd-48ba-4bc0-8ad5-1db4cae7fa0b',29),
	(53,'craft\\elements\\Entry',1,0,'2017-05-11 16:06:14','2017-05-22 04:23:21','3434ebee-b65b-421a-b5d4-f806aa96df6c',30),
	(57,'craft\\elements\\Asset',1,0,'2017-05-12 16:55:13','2017-06-03 11:09:12','c78f791f-aa12-40ee-96b9-89b5c3e221ca',33),
	(58,'craft\\elements\\MatrixBlock',1,0,'2017-05-13 22:28:19','2017-06-03 12:32:51','e8d2479a-33f5-4dbe-ba63-bb00029d3e8c',34),
	(59,'craft\\elements\\MatrixBlock',1,0,'2017-05-13 22:28:19','2017-06-03 12:32:51','ed4860e6-bbaf-4599-ab73-2a5c6f5d618d',34),
	(60,'craft\\elements\\MatrixBlock',1,0,'2017-05-13 22:28:19','2017-06-03 12:32:51','9176647f-1444-43c9-910a-f3ebda2f24a9',34),
	(61,'craft\\elements\\MatrixBlock',1,0,'2017-05-13 22:28:19','2017-06-03 12:32:51','95c4981d-f3fd-4059-a8ec-38f03dde3146',34),
	(62,'craft\\elements\\MatrixBlock',1,0,'2017-05-13 22:28:19','2017-06-03 12:32:51','deb6a605-d549-4629-8db3-069486db3844',34),
	(63,'craft\\elements\\MatrixBlock',1,0,'2017-05-13 22:28:19','2017-06-03 12:32:51','38cd53bd-9c13-492d-b1ae-c1a59fa178f1',34),
	(64,'craft\\elements\\MatrixBlock',1,0,'2017-05-13 22:42:03','2017-06-03 12:32:51','67051150-9528-4fe1-97b5-3196af6e4e67',34),
	(65,'craft\\elements\\MatrixBlock',1,0,'2017-05-13 22:42:03','2017-06-03 12:32:51','aee0de2b-95b2-44da-ab8f-53f2038dde11',34),
	(66,'craft\\elements\\MatrixBlock',1,0,'2017-05-13 22:42:03','2017-06-03 12:32:51','72e17d0a-5809-433e-b659-cf6991909e7f',34),
	(67,'craft\\elements\\Entry',1,0,'2017-05-16 00:16:27','2017-05-22 04:23:21','77ef7cac-e4bf-44f9-94a0-4afb3745cd5f',30),
	(68,'craft\\elements\\Category',1,0,'2017-05-16 02:13:47','2017-05-19 12:50:44','23083157-f911-4eb8-b1e4-73a39f6dbf59',31),
	(69,'craft\\elements\\Entry',1,0,'2017-05-16 02:14:45','2017-06-02 00:54:15','48421589-0623-4598-8688-902f7a11b325',29),
	(70,'craft\\elements\\Asset',1,0,'2017-05-16 03:15:14','2017-06-03 11:09:12','9bfc9c66-8378-406b-8682-2d13ee372808',33),
	(71,'craft\\elements\\Category',1,0,'2017-05-16 16:53:38','2017-05-16 16:53:38','cf803573-750d-4a26-a03b-0df71c1b66d1',31),
	(72,'craft\\elements\\Category',1,0,'2017-05-19 12:33:53','2017-05-19 13:02:17','8c8ae0a8-39ae-484a-9b34-97e6ebc0bae2',31),
	(74,'craft\\elements\\Entry',1,0,'2017-05-19 12:50:18','2017-05-30 04:34:08','6915df49-7fa3-4f0a-a034-98eec03b5706',29),
	(75,'craft\\elements\\Asset',1,0,'2017-05-19 13:08:31','2017-06-03 11:09:12','3bf9b369-9aa8-4456-b60b-22b841b36965',33),
	(76,'craft\\elements\\Asset',1,0,'2017-05-22 03:52:17','2017-06-03 11:09:12','57f46e70-3694-4e8e-9318-1c50b67e5ac5',35),
	(77,'craft\\elements\\Entry',1,0,'2017-05-22 03:53:09','2017-05-22 05:17:22','c7202873-2532-4950-bd13-80049524e305',30),
	(78,'craft\\elements\\Asset',1,0,'2017-05-22 04:09:46','2017-06-03 11:09:12','8df50098-e33c-4785-928e-4d648de00a8d',35),
	(79,'craft\\elements\\Asset',1,0,'2017-05-22 04:14:02','2017-06-03 11:09:12','de4eef09-5b86-4a24-b73d-9d7fca529680',35),
	(80,'craft\\elements\\MatrixBlock',1,0,'2017-05-24 07:25:01','2017-06-03 12:32:51','f65aeb02-6e7b-49ec-b59e-f67f3d9eacd3',34),
	(81,'craft\\elements\\Asset',1,0,'2017-06-01 23:27:50','2017-06-03 11:09:12','cccc7c57-7a7c-4534-8ba2-002dfd5cd504',33),
	(82,'craft\\elements\\Entry',1,0,'2017-06-01 23:35:15','2017-06-02 00:46:56','aa9019d2-1392-430e-839d-0da0abeb64ce',29),
	(83,'craft\\elements\\Asset',1,0,'2017-06-01 23:42:49','2017-06-03 11:09:12','1d1ceb8e-33a2-427e-8efc-582520e00663',35),
	(84,'craft\\elements\\Entry',1,0,'2017-06-01 23:43:08','2017-06-01 23:43:45','46a3853d-bc97-4466-8d01-f9c4d13e9825',30);
ALTER TABLE `cx_elements` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_assets` WRITE;
ALTER TABLE `cx_assets` DISABLE KEYS;
INSERT INTO `cx_assets` (`id`, `volumeId`, `folderId`, `filename`, `kind`, `width`, `height`, `size`, `focalPoint`, `dateModified`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(57,3,27,'Brandon-Kelly.jpg','image',1920,1080,309383,NULL,'2017-05-16 03:37:33','2017-05-12 16:55:13','2017-06-03 11:09:12','9887f31d-8c33-48b1-a5ed-451c4b1abd8c'),
	(70,3,27,'Wade-Anderson.jpg','image',1920,1080,227640,NULL,'2017-05-16 03:29:29','2017-05-16 03:15:14','2017-06-03 11:09:12','516895a3-0b07-470b-88f2-eb91c813b6dc'),
	(75,3,27,'Gary-Hockin.jpg','image',1920,1080,312566,NULL,'2017-05-19 13:08:31','2017-05-19 13:08:31','2017-06-03 11:09:12','4129bb9c-a481-432a-95a5-2eab778a2d33'),
	(76,4,28,'Wade-Anderson.jpg','image',512,512,29253,NULL,'2017-05-22 03:52:17','2017-05-22 03:52:17','2017-06-03 11:09:12','b46867d4-c0f8-4384-975c-17eba31242e4'),
	(78,4,28,'Gary-Hockin.jpg','image',512,512,46204,NULL,'2017-05-22 04:09:46','2017-05-22 04:09:46','2017-06-03 11:09:12','00047bbe-a35a-4d45-bdb3-1ebf572b2d0a'),
	(79,4,28,'Brandon-Kelly.jpg','image',500,500,33418,NULL,'2017-05-28 02:26:18','2017-05-22 04:14:02','2017-06-03 11:09:12','21622a75-2c96-45ff-b1fb-81e416d2f213'),
	(81,3,27,'Wes-Bos.jpg','image',1920,1080,324776,NULL,'2017-06-01 23:57:10','2017-06-01 23:27:50','2017-06-03 11:09:12','94f86259-b363-4cce-91ff-8aaef3e4a155'),
	(83,4,28,'Wes-Bos.jpg','image',512,512,59153,NULL,'2017-06-01 23:42:49','2017-06-01 23:42:49','2017-06-03 11:09:12','2d0f4b4d-b4d5-4465-b736-7927419c3d07');
ALTER TABLE `cx_assets` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_assettransformindex` WRITE;
ALTER TABLE `cx_assettransformindex` DISABLE KEYS;
ALTER TABLE `cx_assettransformindex` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_assettransforms` WRITE;
ALTER TABLE `cx_assettransforms` DISABLE KEYS;
ALTER TABLE `cx_assettransforms` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_categorygroups` WRITE;
ALTER TABLE `cx_categorygroups` DISABLE KEYS;
INSERT INTO `cx_categorygroups` (`id`, `structureId`, `fieldLayoutId`, `name`, `handle`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(1,2,31,'Hangouts','hangouts','2017-04-28 20:02:13','2017-04-28 20:02:13','000fc199-e04a-4414-aac3-cc7e838dc053');
ALTER TABLE `cx_categorygroups` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_categories` WRITE;
ALTER TABLE `cx_categories` DISABLE KEYS;
INSERT INTO `cx_categories` (`id`, `groupId`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(39,1,'2017-04-28 20:02:32','2017-04-28 20:02:32','08895a73-b28c-4619-be08-55d9fc2817b1'),
	(40,1,'2017-04-28 20:02:45','2017-04-28 20:02:45','c6b273b2-d416-4950-aef8-035fce4f7d7e'),
	(41,1,'2017-04-28 20:05:02','2017-04-28 20:05:02','1838ceb8-0771-4949-9a7b-d62a2a3667dc'),
	(42,1,'2017-04-28 20:05:13','2017-04-28 20:05:13','3d378e1a-e356-4d81-8e93-359de7979817'),
	(51,1,'2017-05-11 15:48:44','2017-05-11 15:48:44','dec80939-a2fc-41b1-b12a-297e3845df66'),
	(68,1,'2017-05-16 02:13:47','2017-05-19 12:50:44','c78c02a5-b625-40f1-89cb-488979ca8ae4'),
	(71,1,'2017-05-16 16:53:38','2017-05-16 16:53:38','e0ca50d4-9665-43d5-90c3-a8276590d119'),
	(72,1,'2017-05-19 12:33:53','2017-05-19 13:02:17','865cfef9-1945-4396-bd67-92614c0bb2e9');
ALTER TABLE `cx_categories` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_categorygroups_i18n` WRITE;
ALTER TABLE `cx_categorygroups_i18n` DISABLE KEYS;
INSERT INTO `cx_categorygroups_i18n` (`id`, `groupId`, `siteId`, `hasUrls`, `uriFormat`, `template`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(1,1,1,0,NULL,NULL,'2017-04-28 20:02:13','2017-04-28 20:02:13','bd1aa5ff-7d68-49af-8551-5ac685f9ab0b');
ALTER TABLE `cx_categorygroups_i18n` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_content` WRITE;
ALTER TABLE `cx_content` DISABLE KEYS;
INSERT INTO `cx_content` (`id`, `elementId`, `siteId`, `title`, `dateCreated`, `dateUpdated`, `uid`, `field_markdown`, `field_lead`, `field_text`, `field_dateTime`, `field_hangoutDateTime`, `field_hangoutTopic`, `field_hangoutNotes`, `field_hangoutLink`, `field_firstName`, `field_lastName`, `field_primaryWebsite`, `field_slackUsername`, `field_twitterUsername`, `field_githubUsername`, `field_role`, `field_company`, `field_hangoutStream`) VALUES 
	(1,1,1,NULL,'2017-02-06 18:39:45','2017-06-03 12:58:46','733fd721-e25d-49fc-a09b-41c6cc4692af',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
	(2,2,1,'Homepage','2017-02-06 18:57:45','2017-06-03 12:32:51','fd1f3cbe-c14f-4317-a064-a644d62374cc',NULL,'Unofficial Craft CMS Community','CraftX is an open source website and a community building experiment.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
	(19,25,1,'01-Setting-Up-For-Local-Dev-H264','2017-04-08 06:07:47','2017-05-02 03:08:27','128e98de-5cac-4d93-8617-906a5bea7ae4',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
	(20,26,1,'Craftx-Horizontal','2017-04-08 06:08:27','2017-05-02 03:08:28','a19e3efd-e5c9-4bc2-9a1f-ca0ab658bfff',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
	(22,28,1,'Tools and Workflows','2017-04-26 05:02:36','2017-05-30 04:34:08','8fa5a5f3-9d29-43b3-8e8e-9c1575afb54a',NULL,NULL,NULL,NULL,'2017-04-20 17:00:00','Productivity/automation tools and workflows are one of my favorite topics.\r\n\r\nIf you\'ve got a favorite tool or workflow you\'d like to share, or if you\'re interested in being part of the discussion, please join us.\r\n\r\nJohn Morton will share interesting stats about [CLL] and Jalen Davenport will get us started with a couple of demos of his favorite productivity tools. &#x1f525;\r\n\r\n[cll]:http://craftlinklist.com "Craft Link List"','I had a good time on this hangout.  \r\nThank you to everyone that joined and a special thanks to John and Jalen for sharing cool stuff.\r\n\r\nHere are the links to some of the tools we talked about &#x1f389;\r\n\r\nhttp://sipapp.io → Awesome Color Picker  \r\nhttp://cmder.net → Console Emulator for Windows  \r\nhttps://hyper.is → Console Emulator for Mac / iTerm2 Alternative  \r\nhttps://crema.co → Where I get my coffee beans  \r\nhttps://github.com/lra/mackup → App Settings Sync  \r\nhttps://github.com/b4b4r07/enhancd → `CD` on Steroids  \r\nhttps://github.com/oh-my-fish/oh-my-fish → Oh My ZSH Fork  \r\n\r\nWe discussed a few others but this is all I compiled. I hope you can join the next **CraftX Hangout**. &#x1f609;','https://zoom.us/j/961667767',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
	(23,29,1,'Design and Productivity Apps','2017-04-26 17:31:08','2017-05-30 04:34:08','a2cf5231-8e67-4982-9c73-6c426d1c66b1',NULL,NULL,NULL,NULL,'2017-04-27 17:00:00','We pick up where we left off on the [previous hangout]({entry:28:url}) with productivity tools, but we also hope to explore design apps.\r\n\r\nMany of us focus most of our time on the frontend or backend, but some of us do a little bit of everything, including design work.\r\n\r\nIf you\'ve been thinking about ditching Adobe and checking out [Sketch], [Affinity] or another design tool, this may be the hangout for you. You\'re welcome to participate in the conversation or just sit back and listen as we ramble on.\r\n\r\n[Sketch]: https://www.sketchapp.com/\r\n[Affinity Designer]: https://affinity.serif.com/en-us/designer/\r\n','It was great to see [Bryan] showcase his use of [Affinity Designer] for creating _high fidelity mockups_. A showcase that brought on a deeper discussion about designing in the browser and [Nathaniel] doing a demo of a framework they\'ve been developing at his agency for prototyping with reusable components. Their framework --not yet open source-- is based on [Fractal] by [Clearleft] and there is [an official blog post](https://clearleft.com/posts/395) you can read to learn more about it.\r\n\r\nAs a rehabilitated Adobe Illustrator user who has become productive with [Sketch], I was interested to see if Affinity Designer had any features or workflows that would make me want to jump ship. I came out of the meeting feeling like I really needed to give it another try.\r\n\r\nHere is why Affinity Designer seems like a great Sketch alternative:\r\n\r\n- Unlimited undo &#x1f631;\r\n- Windows and Mac\r\n- No subscription model ricing &#x1f4b0;\r\n- Incredible zoom capabilities\r\n- Can open `.ai` and `.psd` files\r\n- Unified file format\r\n\r\nThis list is not exhaustive and it\'s not meant to offend Sketch users (like myself), it\'s just what I took away from our discussion.\r\n\r\nOne great thing about Sketch that I didn\'t know, is that is has a really nice [Sketch Gulp Plugin] that you can use in your build process. I thought this was really cool and I\'m wondering if there is an equivalent for Affinity Designer.\r\n\r\nWe also touched lightly on frelancing but we\'ll get much deeper on that subject on the next hangout.\r\n\r\n[Fractal]: http://fractal.build/\r\n[Clearleft]: https://clearleft.com/\r\n[Bryan]: {entry:34:primaryWebsite}\r\n[Nathaniel]: {entry:36:primaryWebsite}\r\n[Sketch]: https://www.sketchapp.com/\r\n[Sketch Gulp Plugin]: https://github.com/cognitom/gulp-sketch/\r\n[Affinity Designer]: https://affinity.serif.com/en-us/designer/\r\n','https://zoom.us/j/279673275',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
	(26,32,1,'Jalen Davenport','2017-04-27 20:59:45','2017-05-22 04:23:21','c5406d88-1064-473a-8acc-7c4ceac90818',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Jalen','Davenport','http://dominion-designs.com/','jalenconner','','',NULL,NULL,NULL),
	(27,33,1,'John Morton','2017-04-27 21:01:21','2017-05-22 04:23:21','5df2e143-f54c-45b4-bb06-28ad8619cde3',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'John','Morton','https://jmx2.com/','johnfmorton','','',NULL,NULL,NULL),
	(28,34,1,'Bryan Garrant','2017-04-27 21:07:23','2017-05-22 04:23:21','06429c23-da33-4f40-b7f6-771a16abe51d',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Bryan','Garrant','https://www.garrant.com/','bgarrant','','',NULL,NULL,NULL),
	(29,35,1,'Selvin Ortiz','2017-04-27 21:09:02','2017-05-22 04:23:21','4431550a-d754-4b7e-bd39-0b6426e097af',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Selvin','Ortiz','https://twitter.com/selvinortiz','selvinortiz','selvinortiz','selvinortiz',NULL,NULL,NULL),
	(30,36,1,'Nathaniel Hammond','2017-04-27 21:10:56','2017-05-22 04:23:21','9061fe5a-33e8-43a2-b139-7cddb616445f',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Nathaniel','Hammond','http://n43.me/','nfourtythree','','',NULL,NULL,NULL),
	(31,37,1,'Getting Better at the Freelancing Thing','2017-04-28 16:10:51','2017-05-30 04:34:08','5aa484b6-795c-4679-ba8d-d5c7bf8916cf',NULL,NULL,NULL,NULL,'2017-05-02 17:00:00','Let\'s talk about the business side of being _self-employed_ and how we can get better at finding the right projects and the right clients to work with.','In this hangout we heard from some freelancers and business owners on how they tackle networking, client acquisition, and balance that with onboarding automation and personal development.\r\n\r\n## Networking\r\nNetworking is not just about who you know, but who knows you – and how to get yourself known by the people that matter. Going to a tech conference like Peers can be great, but if you only network with the people that do what you do, you’re not necessarily expanding your network to people you can do business with. Try going to events that have nothing to do with development to meet potential clients.\r\n\r\n## Incentives to refer you\r\nConsider giving out discount cards for say, 20%, and giving out another one for that person to give to someone else too. [Selvin]({entry:35:primaryWebsite}) used to customise the business cards he gave out to go to a landing page specific to the event he was at.\r\n\r\n## Remember to say no\r\nWhether it’s because you’ve got too much work on, or because the client isn’t right, or there are red flags, remember to say no to projects that aren’t right. If the project is too small and you’ve been wanting to do more work in a specific area, consider turning down the project and spend that time instead learning a new technology or some way to improve yourself (provided that you couldn’t learn that new tech on the project being offered).\r\n\r\n## Presenting yourself as a freelancer or a business\r\nWe heard both sides of the argument for presenting yourself as a freelancer or as a business entity. Some prefer to sell themselves and their personality, as the client hires them rather than a business, but we also discussed how ‘freelancer’ can be seen as unreliable or a potential weak point. Whichever stance you take, be sure to own it and be certain about how you present yourself.\r\n\r\n## Reliable income\r\nWhen it comes to income that isn’t project based, some alternative ideas to just exchanging time for dollars:\r\n\r\n- Trading work for equity in the company (particularly for startups)\r\n- Side projects\r\n- Subscription based services\r\n- Commercial plugin development\r\n\r\n## Improving your business\r\n[Gui]({entry:45:primaryWebsite}) talked about how he reached out to people that were doing things well in branding, presentation, websites etc and met with them to discuss how they ran their businesses. This not only helps to gain knowledge in how successful business are run, but also makes a lot of connections.\r\n\r\n---\r\n\r\n✏️ Notes by [Daryl Knight]({entry:38:primaryWebsite})','https://zoom.us/j/289656504',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
	(32,38,1,'Daryl Knight','2017-04-28 16:46:35','2017-05-22 04:23:21','3e26a7d1-13a2-4782-bbf9-b5fae72a8740',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Daryl','Knight','http://codeknight.co.uk/','darylknight','','',NULL,NULL,NULL),
	(33,39,1,'Productivity','2017-04-28 20:02:32','2017-04-28 20:02:32','d6211c68-9fb8-4724-86d8-a3fa4837538b',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
	(34,40,1,'Freelancing','2017-04-28 20:02:45','2017-04-28 20:02:45','d485a03f-d647-491b-9fc6-aca9c2e03b8d',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
	(35,41,1,'Design','2017-04-28 20:05:02','2017-04-28 20:05:02','fca9bc12-4492-46a2-8cd7-a3245da3bddb',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
	(36,42,1,'Development','2017-04-28 20:05:13','2017-04-28 20:05:13','04dd953e-96bc-490b-a8ce-b82e31cd9661',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
	(37,43,1,'Estimating and Pricing Web Projects','2017-05-02 19:30:22','2017-05-30 04:34:08','0390403b-3a43-4344-9872-17c4b310dd39',NULL,NULL,NULL,NULL,'2017-05-11 17:00:00','On the heels of the [last hangout]({entry:37:url}), we\'ve decided to do a follow up on _estimating and pricing_.','We went in depth on the techniques we use to estimate and price projects. We also touched base on the _sales funnel_, _communication boundaries_, and a few other important topics.\r\n\r\nThe lack of context makes it hard to summarize what we learned and provide meaninful notes. I think I can at least share some links that I collected from the chat and that were covered in the hangout.\r\n\r\n## From Ben P.\r\n1. https://www.stevepavlina.com/blog/2008/05/how-to-make-accurate-time-estimates\r\n1. https://www.amazon.com/How-Measure-Anything-Intangibles-Business/dp/1118539273\r\n\r\n> Book (2) gets into some technical stuff but also has a good intro to calibrating your estimation technique and how to think about an estimates confidence interval\r\n\r\n\r\n## From Bryan G.\r\n1. http://blog.teamtreehouse.com/calculate-hourly-freelance-rates-web-design-development-work\r\n1.  https://www.entrepreneur.com/article/271068\r\n\r\n## Random\r\n- https://www.youtube.com/user/patrickbetdavid\r\n\r\n## Tidbits\r\n> These are probably not as useful without proper context but I think they still provide a little nugget of wisdom.\r\n\r\n_"If you can\'t accurately estimate how long something will take, you can\'t accurately predict how much to charge for it"_\r\n\r\n_"If your budget is less than 5k and you’re not used to using the term “Ongoing costs”, consider Wix"_\r\n\r\n_"One of the biggest things for estimating, is if you have a large project, try to chop it up in to smaller chunks and estimate them individually. Figure out the hourly after that, then add padding."_\r\n\r\n_"Pricing an odd amount like £10,125 is 10% more likely to get accepted than £10,000"_\r\n\r\n_"A large part of being able to \'seduce\' clients is confidence. Not only having good estimates, but you need to be confident in your quote and be able to explain why it\'s worth that"_\r\n\r\n_"We’ve found a lot more success in selling a process and deliverables than pure hourly rates"_\r\n\r\n_"We break estimates in to two numbers – the first is a wild guess, the second is something we’re willing to commit to, which is usually a discovery phase and gives more knowledge about how to estimate the first number"_\r\n\r\n_"Almost every project above 5k requires a more in depth discovery phase"_\r\n\r\n_"Always be open to changing the scope, but make sure you have laid down the pricing to go with those changes"_\r\n\r\n_"You can\'t price based on the client, you need to price based on how much you\'re happy doing the work for"_\r\n\r\n_"To get better at estimating, you need to be tracking everything you do"_\r\n\r\n\r\n> If you have related links or resources that you\'d like to share or ideas for the next hangout, drop me on note on [Slack](https://craftcms.slack.com/messages/{entry:35:slackUsername}) or [Twitter](https://twitter.com/{entry:35:twitterUsername})\r\n','https://zoom.us/j/456325753',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
	(38,44,1,'Ben Parizek','2017-05-03 12:13:03','2017-05-22 04:23:21','d30f049b-99e2-4fa6-9053-2151afc2f27a',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Ben','Parizek','https://barrelstrengthdesign.com/','benparizek','','',NULL,NULL,NULL),
	(39,45,1,'Gui Rams','2017-05-03 12:30:00','2017-05-22 04:23:21','c707c778-09f2-45f3-a8b2-4b160c4f2f40',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Gui','Rams','https://github.com/gui-gui/','','','',NULL,NULL,NULL),
	(44,50,1,NULL,'2017-05-08 20:49:37','2017-05-15 23:57:54','47131660-b0a6-41a0-8f55-4e9925b36dbf','<!-- @general -->\r\n[cll]: http://craftlinklist.com "Craft Link List"\r\n[crema]: https://crema.co "Great Coffee"\r\n[clearleft]: https://clearleft.com/\r\n[fractal]: http://fractal.build/\r\n\r\n<!-- @users -->\r\n[daryl]: {entry:38:primaryWebsite}\r\n[bryan]: {entry:34:primaryWebsite}\r\n[jalen]: {entry:32:primaryWebsite}\r\n[nathaniel]: {entry:36:primaryWebsite}\r\n\r\n<!-- @ditors -->\r\n[vscode]: https://code.visualstudio.com "VS Code"\r\n\r\n<!-- @tools -->\r\n[sip]: http://sipapp.io "Awesome Color Picker for Mac"\r\n[cmder]: http://cmder.net "Console Emulator for Windows"\r\n[hyper]: https://hyper.is "Console Emulator for Mac"\r\n[mackup]: https://github.com/lra/mackup "MackUp"\r\n[enhancd]: https://github.com/b4b4r07/enhancd "Enhancd"\r\n[ohmyfish]: https://github.com/oh-my-fish/oh-my-fish "Oh My Fish"\r\n[sketch]: https://www.sketchapp.com/\r\n[sketch gulp plugin]: https://github.com/cognitom/gulp-sketch/\r\n[affinity designer]: https://affinity.serif.com/en-us/designer/\r\n',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
	(45,51,1,'Craft CMS','2017-05-11 15:48:44','2017-05-11 15:48:44','e31a911e-4ed1-4f94-a37d-7dc88580eec1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
	(46,52,1,'Craft 3 Plugin Store','2017-05-11 16:04:56','2017-05-30 04:34:08','eeab8255-5725-4b66-8641-e2267ba4646e',NULL,NULL,NULL,NULL,'2017-05-11 20:00:00','Initial plans for the Craft 3 Plugin Store were announced yesterday and the news have generated mixed reactions. Brandon is joining us to talk about it in more detail.','We were joined by Brandon, Leslie, Brad, and Luke from [Pixel & Tonic](http://pixelandtonic.com) to talk about the plugin store in more detail, and to get a better understanding of the pricing model that they are proposing.\r\n\r\nBelow, is a recording of the meeting, **raw** and **uncut**. Chat transcript was recorded along, in _real-time_ &#x1f631;\r\n\r\nI\'ll try to add notes as they become available &#x1f680;\r\n\r\n## TL;DR by Matt Stein\r\n> My **tl;dr** was that we _should_ be using composer and we _should_ be building ongoing support into web projects and not passing off unplanned support or technical debt to sink P&T. We\'re all discussing this _because_ P&T isn\'t making room for stale, unsupported plugins in its plans for the store.\r\n\r\n[youtube src=nPnHiqF_LFU]\r\n\r\n---\r\n\r\n&#x1f50a; You can also find the [MP3 shared in Dropbox](https://www.dropbox.com/s/l0u5858jx77hkln/Craft-3-Plugin-Store.mp3?dl=0)','https://zoom.us/j/699830106',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
	(47,53,1,'Brandon Kelly','2017-05-11 16:06:14','2017-05-22 04:23:21','64eebb31-2019-44e9-a67d-a3d5a9479f1f',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Brandon','Kelly','https://twitter.com/brandonkelly','brandonkelly','brandonkelly','brandonkelly','Founder and CEO','Pixel & Tonic',NULL),
	(51,57,1,'Brandon Kelly','2017-05-12 16:55:13','2017-06-03 11:09:12','b3c3365a-f52b-4376-a963-c549b77b3e24',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
	(52,67,1,'Wade Anderson','2017-05-16 00:16:27','2017-05-22 04:23:21','891260e4-305e-41f1-9d50-d546568fa229',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Wade','Anderson','https://medium.com/@waderyan_','','waderyan_','waderyan','Product Manager','Microsoft®',NULL),
	(53,68,1,'Tools','2017-05-16 02:13:47','2017-05-19 12:50:44','08a694f9-fa01-4a8d-a67e-12fd74bbd984',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
	(54,69,1,'The Case for VS Code','2017-05-16 02:14:45','2017-06-02 00:54:15','2d478d22-bf8c-45c6-940d-20535e2131e8',NULL,NULL,NULL,NULL,'2017-06-06 17:00:00','[VS Code][vscode] is a powerful code editor. If you haven\'t tried it, we\'ll let [Wade Anderson][wade] tell you why you should. He is a Product Manger at [Microsoft][microsoft] and works on VS Code.\r\n\r\nHe is also a great communicator and presenter. I\'m really excited to have him on the show. Below are a couple of his talks if you\'d like to get up to speed on VS Code.\r\n\r\n&#x1f449; Don\'t forget to add this hangout to your calendar.\r\n\r\n## VS Code: Tips and Tricks\r\n[youtube src=fkM9jCRBwSs]\r\n\r\n---\r\n\r\n## VS Code: Last Editor You\'ll Ever Need\r\n[youtube src=OnkYnm-WiVo]\r\n\r\n[wade]: https://medium.com/@waderyan_ "Wade Anderson"\r\n[vscode]: https://code.visualstudio.com "VS Code"\r\n[microsoft]: https://www.microsoft.com "Microsot"','','https://zoom.us/j/195404140',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'w8zeXocOx7k'),
	(55,70,1,'Wade Anderson','2017-05-16 03:15:14','2017-06-03 11:09:12','8c9d5e17-c776-465d-9b80-d1537939d6c5',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
	(56,71,1,'VS Code','2017-05-16 16:53:38','2017-05-16 16:53:38','aaffa396-bd2b-41d3-a7b1-b39bea1ff748',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
	(57,72,1,'PhpStorm','2017-05-19 12:33:53','2017-05-19 13:02:17','9ee52b15-4d1a-4213-b266-54638c5631af',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
	(59,74,1,'Taking PHP & Craft By Storm','2017-05-19 12:50:18','2017-05-30 04:34:08','d13f5200-5604-436e-9419-97af297de8bd',NULL,NULL,NULL,NULL,'2017-05-25 17:00:00','[Gary Hockin] is a Developer Advocate for [PhpStorm] at [JetBrains] and a prolific technical writer and educator. He will be joining us to talk about how PhpStorm can help us speed up our PHP and Craft CMS development workflow.\r\n\r\nCheck out the videos below to learn more about Gary and tweet [@GeeH] letting him know you\'re looking forward to this hangout ;)\r\n\r\n## Interviewing Gary Hockin from JetBrains\r\n\r\n[youtube src=85m1mQE9pDk]\r\n\r\n## What\'s New in PhpStorm 2017.1\r\n\r\n[youtube src=lL2RFnlNCPk]\r\n\r\n[JetBrains]: https://www.jetbrains.com/\r\n[Gary Hockin]: https://blog.hock.in/\r\n[PhpStorm]: https://www.jetbrains.com/phpstorm/\r\n[@GeeH]: https://twitter.com/GeeH','','https://zoom.us/j/304873613',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
	(60,75,1,'Gary Hockin','2017-05-19 13:08:31','2017-06-03 11:09:12','1966ca50-b1d5-4cae-8524-19e3d12e0b54',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
	(61,76,1,'Wade Anderson','2017-05-22 03:52:17','2017-06-03 11:09:12','73daa328-6379-4f35-b496-2441bc752970',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
	(62,77,1,'Gary Hockin','2017-05-22 03:53:09','2017-05-22 05:17:22','33984e96-2bb0-4e8b-9e18-a0e0871b002e',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Gary','Hockin','https://blog.hock.in/','','GeeH','geeh','Developer Advocate for PhpStorm','JetBrains',NULL),
	(63,78,1,'Gary Hockin','2017-05-22 04:09:46','2017-06-03 11:09:12','b4d6f5b6-8e1f-42db-b04e-8b318056c8ea',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
	(64,79,1,'Brandon Kelly','2017-05-22 04:14:02','2017-06-03 11:09:12','327e539b-7aa7-4115-9f01-71f9c092caaa',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
	(65,81,1,'Wes Bos','2017-06-01 23:27:50','2017-06-03 11:09:12','760f3b92-4446-41a3-ba97-bfe0a1a7ceed',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
	(66,82,1,'Learning and Teaching Web Technologies','2017-06-01 23:35:15','2017-06-02 00:46:56','7035d4de-5448-497e-be65-b5fbcecf1110',NULL,NULL,NULL,NULL,'2017-06-22 17:00:00','[Wes Bos](http://wesbos.com) is at the forefront of web technologies. He is one of the most well liked instructors and conference speakers.\r\n\r\nWes is also a hugely productive educational content creator and very good at marketing his products.\r\n\r\nOn this hangout, I hope to learn more about how he stays on top of Javascript/HTML5/CSS3, the tools he uses in his workflow, and how he approaches learning and teaching about the web.\r\n\r\nIf you aren\'t familiar with Wes and his work (unlikely &#x1f609;), check out a couple of the videos below.\r\n\r\n## Modern Workflow and Tooling\r\n\r\n[youtube src=CiMGKZpnHQE]\r\n\r\n## Start Using ES6 Today\r\n\r\n[youtube src=493p5FSFHz8]\r\n\r\n## Free Courses by Wes\r\n- https://javascript30.com\r\n- https://masteringmarkdown.com','','https://zoom.us/j/526300477',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Rip6RIYDf7U'),
	(67,83,1,'Wes Bos','2017-06-01 23:42:49','2017-06-03 11:09:12','b6f90de4-707a-4bc1-8679-964d707e4de4',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
	(68,84,1,'Wes Bos','2017-06-01 23:43:08','2017-06-01 23:43:45','d73ab3f7-0e53-4332-9510-3dd23a3dd397',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Wes','Bos','http://wesbos.com','','wesbos','wesbos','Designer, Developer & Entrepreneur.','HackerYou / WesBos.com',NULL);
ALTER TABLE `cx_content` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_deprecationerrors` WRITE;
ALTER TABLE `cx_deprecationerrors` DISABLE KEYS;
INSERT INTO `cx_deprecationerrors` (`id`, `key`, `fingerprint`, `lastOccurrence`, `file`, `line`, `class`, `method`, `template`, `templateLine`, `message`, `traces`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(2,'DateTime::uiTimestamp()','craft\\helpers\\Template:267','2017-06-03 13:05:19','/home/vagrant/craftx.dev/vendor/craftcms/cms/src/helpers/Template.php',267,'craft\\helpers\\Template','_dateTimeAttribute',NULL,NULL,'DateTime::uiTimestamp() is deprecated. Use the |timestamp(\'short\') filter instead.','[{"objectClass":"craft\\\\services\\\\Deprecator","file":"/home/vagrant/craftx.dev/vendor/craftcms/cms/src/helpers/Template.php","line":267,"class":"craft\\\\services\\\\Deprecator","method":"log","args":"\\"DateTime::uiTimestamp()\\", \\"DateTime::uiTimestamp() is deprecated. Use the |timestamp(\'short...\\""},{"objectClass":null,"file":"/home/vagrant/craftx.dev/vendor/craftcms/cms/src/helpers/Template.php","line":70,"class":"craft\\\\helpers\\\\Template","method":"_dateTimeAttribute","args":"DateTime, \\"uiTimestamp\\", \\"method\\""},{"objectClass":null,"file":"/home/vagrant/craftx.dev/storage/runtime/compiled_templates/36/3608d724284e56d11612b94780d04cb237ed4ce10088b1221ea872679bf7f05a.php","line":47,"class":"craft\\\\helpers\\\\Template","method":"attribute","args":"craft\\\\web\\\\twig\\\\Environment, Twig_Source, DateTime, \\"uiTimestamp\\", ..."},{"objectClass":"__TwigTemplate_8d81d3a5ca69bb5ff9654fdf1be8f9d405fd0b43eb01e0a7f85bdab2ac4dde4b","file":"/home/vagrant/craftx.dev/vendor/twig/twig/lib/Twig/Template.php","line":389,"class":"__TwigTemplate_8d81d3a5ca69bb5ff9654fdf1be8f9d405fd0b43eb01e0a7f85bdab2ac4dde4b","method":"doDisplay","args":"[\\"sectionHandle\\" => \\"people\\", \\"entryId\\" => 45, \\"draftId\\" => null, \\"versionId\\" => null, ...], []"},{"objectClass":"__TwigTemplate_8d81d3a5ca69bb5ff9654fdf1be8f9d405fd0b43eb01e0a7f85bdab2ac4dde4b","file":"/home/vagrant/craftx.dev/vendor/craftcms/cms/src/web/twig/Template.php","line":51,"class":"Twig_Template","method":"displayWithErrorHandling","args":"[\\"sectionHandle\\" => \\"people\\", \\"entryId\\" => 45, \\"draftId\\" => null, \\"versionId\\" => null, ...], []"},{"objectClass":"__TwigTemplate_8d81d3a5ca69bb5ff9654fdf1be8f9d405fd0b43eb01e0a7f85bdab2ac4dde4b","file":"/home/vagrant/craftx.dev/vendor/twig/twig/lib/Twig/Template.php","line":366,"class":"craft\\\\web\\\\twig\\\\Template","method":"displayWithErrorHandling","args":"[\\"sectionHandle\\" => \\"people\\", \\"entryId\\" => 45, \\"draftId\\" => null, \\"versionId\\" => null, ...], []"},{"objectClass":"__TwigTemplate_8d81d3a5ca69bb5ff9654fdf1be8f9d405fd0b43eb01e0a7f85bdab2ac4dde4b","file":"/home/vagrant/craftx.dev/vendor/craftcms/cms/src/web/twig/Template.php","line":32,"class":"Twig_Template","method":"display","args":"[\\"sectionHandle\\" => \\"people\\", \\"entryId\\" => 45, \\"draftId\\" => null, \\"versionId\\" => null, ...], []"},{"objectClass":"__TwigTemplate_8d81d3a5ca69bb5ff9654fdf1be8f9d405fd0b43eb01e0a7f85bdab2ac4dde4b","file":"/home/vagrant/craftx.dev/storage/runtime/compiled_templates/5e/5ed23c3fdc1da822217e90c851b50d832fc5296b32add176782afcff16db42f8.php","line":71,"class":"craft\\\\web\\\\twig\\\\Template","method":"display","args":"[\\"sectionHandle\\" => \\"people\\", \\"entryId\\" => 45, \\"draftId\\" => null, \\"versionId\\" => null, ...]","template":"entries/_revisions","templateLine":20},{"objectClass":"__TwigTemplate_7e9512f9827ababda89fa3bbd861269891a676c98f38c16beb574351943b1d0a","file":"/home/vagrant/craftx.dev/vendor/twig/twig/lib/Twig/Template.php","line":188,"class":"__TwigTemplate_7e9512f9827ababda89fa3bbd861269891a676c98f38c16beb574351943b1d0a","method":"block_pageTitle","args":"[\\"sectionHandle\\" => \\"people\\", \\"entryId\\" => 45, \\"draftId\\" => null, \\"versionId\\" => null, ...], [\\"head\\" => [__TwigTemplate_36360c1a5d842292912fac4c49b21d788d0ee7e355c3bf59e3631526bb001cf0, \\"block_head\\"], \\"body\\" => [__TwigTemplate_d6a5261bbe5b2ed5ae8e4c5b635e288ff1e3994ead1ef8c6f0f4087055ca9146, \\"block_body\\"], \\"foot\\" => [__TwigTemplate_39f998e5693d6022fb55dd0439c547ab2877667e5674e36ab7ba8341c1fe6d88, \\"block_foot\\"], \\"saveButton\\" => [__TwigTemplate_7e9512f9827ababda89fa3bbd861269891a676c98f38c16beb574351943b1d0a, \\"block_saveButton\\"], ...]"},{"objectClass":"__TwigTemplate_d6a5261bbe5b2ed5ae8e4c5b635e288ff1e3994ead1ef8c6f0f4087055ca9146","file":"/home/vagrant/craftx.dev/storage/runtime/compiled_templates/69/690e2704bae408488a2fd57979b83af43d086c3472bbc45cc73a55a7eabc1fe2.php","line":696,"class":"Twig_Template","method":"displayBlock","args":"\\"pageTitle\\", [\\"sectionHandle\\" => \\"people\\", \\"entryId\\" => 45, \\"draftId\\" => null, \\"versionId\\" => null, ...], [\\"head\\" => [__TwigTemplate_36360c1a5d842292912fac4c49b21d788d0ee7e355c3bf59e3631526bb001cf0, \\"block_head\\"], \\"body\\" => [__TwigTemplate_d6a5261bbe5b2ed5ae8e4c5b635e288ff1e3994ead1ef8c6f0f4087055ca9146, \\"block_body\\"], \\"foot\\" => [__TwigTemplate_39f998e5693d6022fb55dd0439c547ab2877667e5674e36ab7ba8341c1fe6d88, \\"block_foot\\"], \\"saveButton\\" => [__TwigTemplate_7e9512f9827ababda89fa3bbd861269891a676c98f38c16beb574351943b1d0a, \\"block_saveButton\\"], ...]","template":"_layouts/cp","templateLine":280},{"objectClass":"__TwigTemplate_d6a5261bbe5b2ed5ae8e4c5b635e288ff1e3994ead1ef8c6f0f4087055ca9146","file":"/home/vagrant/craftx.dev/vendor/twig/twig/lib/Twig/Template.php","line":188,"class":"__TwigTemplate_d6a5261bbe5b2ed5ae8e4c5b635e288ff1e3994ead1ef8c6f0f4087055ca9146","method":"block_pageHeader","args":"[\\"sectionHandle\\" => \\"people\\", \\"entryId\\" => 45, \\"draftId\\" => null, \\"versionId\\" => null, ...], [\\"head\\" => [__TwigTemplate_36360c1a5d842292912fac4c49b21d788d0ee7e355c3bf59e3631526bb001cf0, \\"block_head\\"], \\"body\\" => [__TwigTemplate_d6a5261bbe5b2ed5ae8e4c5b635e288ff1e3994ead1ef8c6f0f4087055ca9146, \\"block_body\\"], \\"foot\\" => [__TwigTemplate_39f998e5693d6022fb55dd0439c547ab2877667e5674e36ab7ba8341c1fe6d88, \\"block_foot\\"], \\"saveButton\\" => [__TwigTemplate_7e9512f9827ababda89fa3bbd861269891a676c98f38c16beb574351943b1d0a, \\"block_saveButton\\"], ...]"},{"objectClass":"__TwigTemplate_d6a5261bbe5b2ed5ae8e4c5b635e288ff1e3994ead1ef8c6f0f4087055ca9146","file":"/home/vagrant/craftx.dev/storage/runtime/compiled_templates/69/690e2704bae408488a2fd57979b83af43d086c3472bbc45cc73a55a7eabc1fe2.php","line":518,"class":"Twig_Template","method":"displayBlock","args":"\\"pageHeader\\", [\\"sectionHandle\\" => \\"people\\", \\"entryId\\" => 45, \\"draftId\\" => null, \\"versionId\\" => null, ...], [\\"head\\" => [__TwigTemplate_36360c1a5d842292912fac4c49b21d788d0ee7e355c3bf59e3631526bb001cf0, \\"block_head\\"], \\"body\\" => [__TwigTemplate_d6a5261bbe5b2ed5ae8e4c5b635e288ff1e3994ead1ef8c6f0f4087055ca9146, \\"block_body\\"], \\"foot\\" => [__TwigTemplate_39f998e5693d6022fb55dd0439c547ab2877667e5674e36ab7ba8341c1fe6d88, \\"block_foot\\"], \\"saveButton\\" => [__TwigTemplate_7e9512f9827ababda89fa3bbd861269891a676c98f38c16beb574351943b1d0a, \\"block_saveButton\\"], ...]","template":"_layouts/cp","templateLine":277},{"objectClass":"__TwigTemplate_d6a5261bbe5b2ed5ae8e4c5b635e288ff1e3994ead1ef8c6f0f4087055ca9146","file":"/home/vagrant/craftx.dev/vendor/twig/twig/lib/Twig/Template.php","line":188,"class":"__TwigTemplate_d6a5261bbe5b2ed5ae8e4c5b635e288ff1e3994ead1ef8c6f0f4087055ca9146","method":"block_body","args":"[\\"sectionHandle\\" => \\"people\\", \\"entryId\\" => 45, \\"draftId\\" => null, \\"versionId\\" => null, ...], [\\"head\\" => [__TwigTemplate_36360c1a5d842292912fac4c49b21d788d0ee7e355c3bf59e3631526bb001cf0, \\"block_head\\"], \\"body\\" => [__TwigTemplate_d6a5261bbe5b2ed5ae8e4c5b635e288ff1e3994ead1ef8c6f0f4087055ca9146, \\"block_body\\"], \\"foot\\" => [__TwigTemplate_39f998e5693d6022fb55dd0439c547ab2877667e5674e36ab7ba8341c1fe6d88, \\"block_foot\\"], \\"saveButton\\" => [__TwigTemplate_7e9512f9827ababda89fa3bbd861269891a676c98f38c16beb574351943b1d0a, \\"block_saveButton\\"], ...]"},{"objectClass":"__TwigTemplate_36360c1a5d842292912fac4c49b21d788d0ee7e355c3bf59e3631526bb001cf0","file":"/home/vagrant/craftx.dev/storage/runtime/compiled_templates/7e/7ecd3276eb6d55203aee5606ee2c7a3981b25d76f98f5e01571b3195e08803f7.php","line":51,"class":"Twig_Template","method":"displayBlock","args":"\\"body\\", [\\"sectionHandle\\" => \\"people\\", \\"entryId\\" => 45, \\"draftId\\" => null, \\"versionId\\" => null, ...], [\\"head\\" => [__TwigTemplate_36360c1a5d842292912fac4c49b21d788d0ee7e355c3bf59e3631526bb001cf0, \\"block_head\\"], \\"body\\" => [__TwigTemplate_d6a5261bbe5b2ed5ae8e4c5b635e288ff1e3994ead1ef8c6f0f4087055ca9146, \\"block_body\\"], \\"foot\\" => [__TwigTemplate_39f998e5693d6022fb55dd0439c547ab2877667e5674e36ab7ba8341c1fe6d88, \\"block_foot\\"], \\"saveButton\\" => [__TwigTemplate_7e9512f9827ababda89fa3bbd861269891a676c98f38c16beb574351943b1d0a, \\"block_saveButton\\"], ...]","template":"_layouts/base","templateLine":32},{"objectClass":"__TwigTemplate_36360c1a5d842292912fac4c49b21d788d0ee7e355c3bf59e3631526bb001cf0","file":"/home/vagrant/craftx.dev/vendor/twig/twig/lib/Twig/Template.php","line":389,"class":"__TwigTemplate_36360c1a5d842292912fac4c49b21d788d0ee7e355c3bf59e3631526bb001cf0","method":"doDisplay","args":"[\\"sectionHandle\\" => \\"people\\", \\"entryId\\" => 45, \\"draftId\\" => null, \\"versionId\\" => null, ...], [\\"head\\" => [__TwigTemplate_36360c1a5d842292912fac4c49b21d788d0ee7e355c3bf59e3631526bb001cf0, \\"block_head\\"], \\"body\\" => [__TwigTemplate_d6a5261bbe5b2ed5ae8e4c5b635e288ff1e3994ead1ef8c6f0f4087055ca9146, \\"block_body\\"], \\"foot\\" => [__TwigTemplate_39f998e5693d6022fb55dd0439c547ab2877667e5674e36ab7ba8341c1fe6d88, \\"block_foot\\"], \\"saveButton\\" => [__TwigTemplate_7e9512f9827ababda89fa3bbd861269891a676c98f38c16beb574351943b1d0a, \\"block_saveButton\\"], ...]"},{"objectClass":"__TwigTemplate_36360c1a5d842292912fac4c49b21d788d0ee7e355c3bf59e3631526bb001cf0","file":"/home/vagrant/craftx.dev/vendor/craftcms/cms/src/web/twig/Template.php","line":51,"class":"Twig_Template","method":"displayWithErrorHandling","args":"[\\"sectionHandle\\" => \\"people\\", \\"entryId\\" => 45, \\"draftId\\" => null, \\"versionId\\" => null, ...], [\\"head\\" => [__TwigTemplate_36360c1a5d842292912fac4c49b21d788d0ee7e355c3bf59e3631526bb001cf0, \\"block_head\\"], \\"body\\" => [__TwigTemplate_d6a5261bbe5b2ed5ae8e4c5b635e288ff1e3994ead1ef8c6f0f4087055ca9146, \\"block_body\\"], \\"foot\\" => [__TwigTemplate_39f998e5693d6022fb55dd0439c547ab2877667e5674e36ab7ba8341c1fe6d88, \\"block_foot\\"], \\"saveButton\\" => [__TwigTemplate_7e9512f9827ababda89fa3bbd861269891a676c98f38c16beb574351943b1d0a, \\"block_saveButton\\"], ...]"},{"objectClass":"__TwigTemplate_36360c1a5d842292912fac4c49b21d788d0ee7e355c3bf59e3631526bb001cf0","file":"/home/vagrant/craftx.dev/vendor/twig/twig/lib/Twig/Template.php","line":366,"class":"craft\\\\web\\\\twig\\\\Template","method":"displayWithErrorHandling","args":"[\\"sectionHandle\\" => \\"people\\", \\"entryId\\" => 45, \\"draftId\\" => null, \\"versionId\\" => null, ...], [\\"head\\" => [__TwigTemplate_36360c1a5d842292912fac4c49b21d788d0ee7e355c3bf59e3631526bb001cf0, \\"block_head\\"], \\"body\\" => [__TwigTemplate_d6a5261bbe5b2ed5ae8e4c5b635e288ff1e3994ead1ef8c6f0f4087055ca9146, \\"block_body\\"], \\"foot\\" => [__TwigTemplate_39f998e5693d6022fb55dd0439c547ab2877667e5674e36ab7ba8341c1fe6d88, \\"block_foot\\"], \\"saveButton\\" => [__TwigTemplate_7e9512f9827ababda89fa3bbd861269891a676c98f38c16beb574351943b1d0a, \\"block_saveButton\\"], ...]"},{"objectClass":"__TwigTemplate_36360c1a5d842292912fac4c49b21d788d0ee7e355c3bf59e3631526bb001cf0","file":"/home/vagrant/craftx.dev/vendor/craftcms/cms/src/web/twig/Template.php","line":32,"class":"Twig_Template","method":"display","args":"[\\"sectionHandle\\" => \\"people\\", \\"entryId\\" => 45, \\"draftId\\" => null, \\"versionId\\" => null, ...], [\\"foot\\" => [__TwigTemplate_39f998e5693d6022fb55dd0439c547ab2877667e5674e36ab7ba8341c1fe6d88, \\"block_foot\\"], \\"saveButton\\" => [__TwigTemplate_7e9512f9827ababda89fa3bbd861269891a676c98f38c16beb574351943b1d0a, \\"block_saveButton\\"], \\"containerAttributes\\" => [__TwigTemplate_d6a5261bbe5b2ed5ae8e4c5b635e288ff1e3994ead1ef8c6f0f4087055ca9146, \\"block_containerAttributes\\"], \\"body\\" => [__TwigTemplate_d6a5261bbe5b2ed5ae8e4c5b635e288ff1e3994ead1ef8c6f0f4087055ca9146, \\"block_body\\"], ...]"},{"objectClass":"__TwigTemplate_36360c1a5d842292912fac4c49b21d788d0ee7e355c3bf59e3631526bb001cf0","file":"/home/vagrant/craftx.dev/storage/runtime/compiled_templates/f6/f68a8967919c034dd9daa4ed0349ea57abc319fadcccfd13ccec39a6bc1d47cb.php","line":36,"class":"craft\\\\web\\\\twig\\\\Template","method":"display","args":"[\\"sectionHandle\\" => \\"people\\", \\"entryId\\" => 45, \\"draftId\\" => null, \\"versionId\\" => null, ...], [\\"foot\\" => [__TwigTemplate_39f998e5693d6022fb55dd0439c547ab2877667e5674e36ab7ba8341c1fe6d88, \\"block_foot\\"], \\"saveButton\\" => [__TwigTemplate_7e9512f9827ababda89fa3bbd861269891a676c98f38c16beb574351943b1d0a, \\"block_saveButton\\"], \\"containerAttributes\\" => [__TwigTemplate_d6a5261bbe5b2ed5ae8e4c5b635e288ff1e3994ead1ef8c6f0f4087055ca9146, \\"block_containerAttributes\\"], \\"body\\" => [__TwigTemplate_d6a5261bbe5b2ed5ae8e4c5b635e288ff1e3994ead1ef8c6f0f4087055ca9146, \\"block_body\\"], ...]","template":"_layouts/base","templateLine":7},{"objectClass":"__TwigTemplate_39f998e5693d6022fb55dd0439c547ab2877667e5674e36ab7ba8341c1fe6d88","file":"/home/vagrant/craftx.dev/vendor/twig/twig/lib/Twig/Template.php","line":389,"class":"__TwigTemplate_39f998e5693d6022fb55dd0439c547ab2877667e5674e36ab7ba8341c1fe6d88","method":"doDisplay","args":"[\\"sectionHandle\\" => \\"people\\", \\"entryId\\" => 45, \\"draftId\\" => null, \\"versionId\\" => null, ...], [\\"foot\\" => [__TwigTemplate_39f998e5693d6022fb55dd0439c547ab2877667e5674e36ab7ba8341c1fe6d88, \\"block_foot\\"], \\"saveButton\\" => [__TwigTemplate_7e9512f9827ababda89fa3bbd861269891a676c98f38c16beb574351943b1d0a, \\"block_saveButton\\"], \\"containerAttributes\\" => [__TwigTemplate_d6a5261bbe5b2ed5ae8e4c5b635e288ff1e3994ead1ef8c6f0f4087055ca9146, \\"block_containerAttributes\\"], \\"body\\" => [__TwigTemplate_d6a5261bbe5b2ed5ae8e4c5b635e288ff1e3994ead1ef8c6f0f4087055ca9146, \\"block_body\\"], ...]"},{"objectClass":"__TwigTemplate_39f998e5693d6022fb55dd0439c547ab2877667e5674e36ab7ba8341c1fe6d88","file":"/home/vagrant/craftx.dev/vendor/craftcms/cms/src/web/twig/Template.php","line":51,"class":"Twig_Template","method":"displayWithErrorHandling","args":"[\\"sectionHandle\\" => \\"people\\", \\"entryId\\" => 45, \\"draftId\\" => null, \\"versionId\\" => null, ...], [\\"foot\\" => [__TwigTemplate_39f998e5693d6022fb55dd0439c547ab2877667e5674e36ab7ba8341c1fe6d88, \\"block_foot\\"], \\"saveButton\\" => [__TwigTemplate_7e9512f9827ababda89fa3bbd861269891a676c98f38c16beb574351943b1d0a, \\"block_saveButton\\"], \\"containerAttributes\\" => [__TwigTemplate_d6a5261bbe5b2ed5ae8e4c5b635e288ff1e3994ead1ef8c6f0f4087055ca9146, \\"block_containerAttributes\\"], \\"body\\" => [__TwigTemplate_d6a5261bbe5b2ed5ae8e4c5b635e288ff1e3994ead1ef8c6f0f4087055ca9146, \\"block_body\\"], ...]"},{"objectClass":"__TwigTemplate_39f998e5693d6022fb55dd0439c547ab2877667e5674e36ab7ba8341c1fe6d88","file":"/home/vagrant/craftx.dev/vendor/twig/twig/lib/Twig/Template.php","line":366,"class":"craft\\\\web\\\\twig\\\\Template","method":"displayWithErrorHandling","args":"[\\"sectionHandle\\" => \\"people\\", \\"entryId\\" => 45, \\"draftId\\" => null, \\"versionId\\" => null, ...], [\\"foot\\" => [__TwigTemplate_39f998e5693d6022fb55dd0439c547ab2877667e5674e36ab7ba8341c1fe6d88, \\"block_foot\\"], \\"saveButton\\" => [__TwigTemplate_7e9512f9827ababda89fa3bbd861269891a676c98f38c16beb574351943b1d0a, \\"block_saveButton\\"], \\"containerAttributes\\" => [__TwigTemplate_d6a5261bbe5b2ed5ae8e4c5b635e288ff1e3994ead1ef8c6f0f4087055ca9146, \\"block_containerAttributes\\"], \\"body\\" => [__TwigTemplate_d6a5261bbe5b2ed5ae8e4c5b635e288ff1e3994ead1ef8c6f0f4087055ca9146, \\"block_body\\"], ...]"},{"objectClass":"__TwigTemplate_39f998e5693d6022fb55dd0439c547ab2877667e5674e36ab7ba8341c1fe6d88","file":"/home/vagrant/craftx.dev/vendor/craftcms/cms/src/web/twig/Template.php","line":32,"class":"Twig_Template","method":"display","args":"[\\"sectionHandle\\" => \\"people\\", \\"entryId\\" => 45, \\"draftId\\" => null, \\"versionId\\" => null, ...], [\\"saveButton\\" => [__TwigTemplate_7e9512f9827ababda89fa3bbd861269891a676c98f38c16beb574351943b1d0a, \\"block_saveButton\\"], \\"containerAttributes\\" => [__TwigTemplate_d6a5261bbe5b2ed5ae8e4c5b635e288ff1e3994ead1ef8c6f0f4087055ca9146, \\"block_containerAttributes\\"], \\"body\\" => [__TwigTemplate_d6a5261bbe5b2ed5ae8e4c5b635e288ff1e3994ead1ef8c6f0f4087055ca9146, \\"block_body\\"], \\"pageHeader\\" => [__TwigTemplate_d6a5261bbe5b2ed5ae8e4c5b635e288ff1e3994ead1ef8c6f0f4087055ca9146, \\"block_pageHeader\\"], ...]"},{"objectClass":"__TwigTemplate_39f998e5693d6022fb55dd0439c547ab2877667e5674e36ab7ba8341c1fe6d88","file":"/home/vagrant/craftx.dev/storage/runtime/compiled_templates/69/690e2704bae408488a2fd57979b83af43d086c3472bbc45cc73a55a7eabc1fe2.php","line":85,"class":"craft\\\\web\\\\twig\\\\Template","method":"display","args":"[\\"sectionHandle\\" => \\"people\\", \\"entryId\\" => 45, \\"draftId\\" => null, \\"versionId\\" => null, ...], [\\"saveButton\\" => [__TwigTemplate_7e9512f9827ababda89fa3bbd861269891a676c98f38c16beb574351943b1d0a, \\"block_saveButton\\"], \\"containerAttributes\\" => [__TwigTemplate_d6a5261bbe5b2ed5ae8e4c5b635e288ff1e3994ead1ef8c6f0f4087055ca9146, \\"block_containerAttributes\\"], \\"body\\" => [__TwigTemplate_d6a5261bbe5b2ed5ae8e4c5b635e288ff1e3994ead1ef8c6f0f4087055ca9146, \\"block_body\\"], \\"pageHeader\\" => [__TwigTemplate_d6a5261bbe5b2ed5ae8e4c5b635e288ff1e3994ead1ef8c6f0f4087055ca9146, \\"block_pageHeader\\"], ...]","template":"_layouts/basecp","templateLine":33},{"objectClass":"__TwigTemplate_d6a5261bbe5b2ed5ae8e4c5b635e288ff1e3994ead1ef8c6f0f4087055ca9146","file":"/home/vagrant/craftx.dev/vendor/twig/twig/lib/Twig/Template.php","line":389,"class":"__TwigTemplate_d6a5261bbe5b2ed5ae8e4c5b635e288ff1e3994ead1ef8c6f0f4087055ca9146","method":"doDisplay","args":"[\\"sectionHandle\\" => \\"people\\", \\"entryId\\" => 45, \\"draftId\\" => null, \\"versionId\\" => null, ...], [\\"saveButton\\" => [__TwigTemplate_7e9512f9827ababda89fa3bbd861269891a676c98f38c16beb574351943b1d0a, \\"block_saveButton\\"], \\"containerAttributes\\" => [__TwigTemplate_d6a5261bbe5b2ed5ae8e4c5b635e288ff1e3994ead1ef8c6f0f4087055ca9146, \\"block_containerAttributes\\"], \\"body\\" => [__TwigTemplate_d6a5261bbe5b2ed5ae8e4c5b635e288ff1e3994ead1ef8c6f0f4087055ca9146, \\"block_body\\"], \\"pageHeader\\" => [__TwigTemplate_d6a5261bbe5b2ed5ae8e4c5b635e288ff1e3994ead1ef8c6f0f4087055ca9146, \\"block_pageHeader\\"], ...]"},{"objectClass":"__TwigTemplate_d6a5261bbe5b2ed5ae8e4c5b635e288ff1e3994ead1ef8c6f0f4087055ca9146","file":"/home/vagrant/craftx.dev/vendor/craftcms/cms/src/web/twig/Template.php","line":51,"class":"Twig_Template","method":"displayWithErrorHandling","args":"[\\"sectionHandle\\" => \\"people\\", \\"entryId\\" => 45, \\"draftId\\" => null, \\"versionId\\" => null, ...], [\\"saveButton\\" => [__TwigTemplate_7e9512f9827ababda89fa3bbd861269891a676c98f38c16beb574351943b1d0a, \\"block_saveButton\\"], \\"containerAttributes\\" => [__TwigTemplate_d6a5261bbe5b2ed5ae8e4c5b635e288ff1e3994ead1ef8c6f0f4087055ca9146, \\"block_containerAttributes\\"], \\"body\\" => [__TwigTemplate_d6a5261bbe5b2ed5ae8e4c5b635e288ff1e3994ead1ef8c6f0f4087055ca9146, \\"block_body\\"], \\"pageHeader\\" => [__TwigTemplate_d6a5261bbe5b2ed5ae8e4c5b635e288ff1e3994ead1ef8c6f0f4087055ca9146, \\"block_pageHeader\\"], ...]"},{"objectClass":"__TwigTemplate_d6a5261bbe5b2ed5ae8e4c5b635e288ff1e3994ead1ef8c6f0f4087055ca9146","file":"/home/vagrant/craftx.dev/vendor/twig/twig/lib/Twig/Template.php","line":366,"class":"craft\\\\web\\\\twig\\\\Template","method":"displayWithErrorHandling","args":"[\\"sectionHandle\\" => \\"people\\", \\"entryId\\" => 45, \\"draftId\\" => null, \\"versionId\\" => null, ...], [\\"saveButton\\" => [__TwigTemplate_7e9512f9827ababda89fa3bbd861269891a676c98f38c16beb574351943b1d0a, \\"block_saveButton\\"], \\"containerAttributes\\" => [__TwigTemplate_d6a5261bbe5b2ed5ae8e4c5b635e288ff1e3994ead1ef8c6f0f4087055ca9146, \\"block_containerAttributes\\"], \\"body\\" => [__TwigTemplate_d6a5261bbe5b2ed5ae8e4c5b635e288ff1e3994ead1ef8c6f0f4087055ca9146, \\"block_body\\"], \\"pageHeader\\" => [__TwigTemplate_d6a5261bbe5b2ed5ae8e4c5b635e288ff1e3994ead1ef8c6f0f4087055ca9146, \\"block_pageHeader\\"], ...]"},{"objectClass":"__TwigTemplate_d6a5261bbe5b2ed5ae8e4c5b635e288ff1e3994ead1ef8c6f0f4087055ca9146","file":"/home/vagrant/craftx.dev/vendor/craftcms/cms/src/web/twig/Template.php","line":32,"class":"Twig_Template","method":"display","args":"[\\"sectionHandle\\" => \\"people\\", \\"entryId\\" => 45, \\"draftId\\" => null, \\"versionId\\" => null, ...], [\\"pageTitle\\" => [__TwigTemplate_7e9512f9827ababda89fa3bbd861269891a676c98f38c16beb574351943b1d0a, \\"block_pageTitle\\"], \\"saveButton\\" => [__TwigTemplate_7e9512f9827ababda89fa3bbd861269891a676c98f38c16beb574351943b1d0a, \\"block_saveButton\\"], \\"main\\" => [__TwigTemplate_7e9512f9827ababda89fa3bbd861269891a676c98f38c16beb574351943b1d0a, \\"block_main\\"]]"},{"objectClass":"__TwigTemplate_d6a5261bbe5b2ed5ae8e4c5b635e288ff1e3994ead1ef8c6f0f4087055ca9146","file":"/home/vagrant/craftx.dev/storage/runtime/compiled_templates/5e/5ed23c3fdc1da822217e90c851b50d832fc5296b32add176782afcff16db42f8.php","line":56,"class":"craft\\\\web\\\\twig\\\\Template","method":"display","args":"[\\"sectionHandle\\" => \\"people\\", \\"entryId\\" => 45, \\"draftId\\" => null, \\"versionId\\" => null, ...], [\\"pageTitle\\" => [__TwigTemplate_7e9512f9827ababda89fa3bbd861269891a676c98f38c16beb574351943b1d0a, \\"block_pageTitle\\"], \\"saveButton\\" => [__TwigTemplate_7e9512f9827ababda89fa3bbd861269891a676c98f38c16beb574351943b1d0a, \\"block_saveButton\\"], \\"main\\" => [__TwigTemplate_7e9512f9827ababda89fa3bbd861269891a676c98f38c16beb574351943b1d0a, \\"block_main\\"]]","template":"_layouts/cp","templateLine":116},{"objectClass":"__TwigTemplate_7e9512f9827ababda89fa3bbd861269891a676c98f38c16beb574351943b1d0a","file":"/home/vagrant/craftx.dev/vendor/twig/twig/lib/Twig/Template.php","line":389,"class":"__TwigTemplate_7e9512f9827ababda89fa3bbd861269891a676c98f38c16beb574351943b1d0a","method":"doDisplay","args":"[\\"sectionHandle\\" => \\"people\\", \\"entryId\\" => 45, \\"draftId\\" => null, \\"versionId\\" => null, ...], [\\"pageTitle\\" => [__TwigTemplate_7e9512f9827ababda89fa3bbd861269891a676c98f38c16beb574351943b1d0a, \\"block_pageTitle\\"], \\"saveButton\\" => [__TwigTemplate_7e9512f9827ababda89fa3bbd861269891a676c98f38c16beb574351943b1d0a, \\"block_saveButton\\"], \\"main\\" => [__TwigTemplate_7e9512f9827ababda89fa3bbd861269891a676c98f38c16beb574351943b1d0a, \\"block_main\\"]]"},{"objectClass":"__TwigTemplate_7e9512f9827ababda89fa3bbd861269891a676c98f38c16beb574351943b1d0a","file":"/home/vagrant/craftx.dev/vendor/craftcms/cms/src/web/twig/Template.php","line":51,"class":"Twig_Template","method":"displayWithErrorHandling","args":"[\\"sectionHandle\\" => \\"people\\", \\"entryId\\" => 45, \\"draftId\\" => null, \\"versionId\\" => null, ...], [\\"pageTitle\\" => [__TwigTemplate_7e9512f9827ababda89fa3bbd861269891a676c98f38c16beb574351943b1d0a, \\"block_pageTitle\\"], \\"saveButton\\" => [__TwigTemplate_7e9512f9827ababda89fa3bbd861269891a676c98f38c16beb574351943b1d0a, \\"block_saveButton\\"], \\"main\\" => [__TwigTemplate_7e9512f9827ababda89fa3bbd861269891a676c98f38c16beb574351943b1d0a, \\"block_main\\"]]"},{"objectClass":"__TwigTemplate_7e9512f9827ababda89fa3bbd861269891a676c98f38c16beb574351943b1d0a","file":"/home/vagrant/craftx.dev/vendor/twig/twig/lib/Twig/Template.php","line":366,"class":"craft\\\\web\\\\twig\\\\Template","method":"displayWithErrorHandling","args":"[\\"sectionHandle\\" => \\"people\\", \\"entryId\\" => 45, \\"draftId\\" => null, \\"versionId\\" => null, ...], [\\"pageTitle\\" => [__TwigTemplate_7e9512f9827ababda89fa3bbd861269891a676c98f38c16beb574351943b1d0a, \\"block_pageTitle\\"], \\"saveButton\\" => [__TwigTemplate_7e9512f9827ababda89fa3bbd861269891a676c98f38c16beb574351943b1d0a, \\"block_saveButton\\"], \\"main\\" => [__TwigTemplate_7e9512f9827ababda89fa3bbd861269891a676c98f38c16beb574351943b1d0a, \\"block_main\\"]]"},{"objectClass":"__TwigTemplate_7e9512f9827ababda89fa3bbd861269891a676c98f38c16beb574351943b1d0a","file":"/home/vagrant/craftx.dev/vendor/craftcms/cms/src/web/twig/Template.php","line":32,"class":"Twig_Template","method":"display","args":"[\\"sectionHandle\\" => \\"people\\", \\"entryId\\" => 45, \\"draftId\\" => null, \\"versionId\\" => null, ...], []"},{"objectClass":"__TwigTemplate_7e9512f9827ababda89fa3bbd861269891a676c98f38c16beb574351943b1d0a","file":"/home/vagrant/craftx.dev/vendor/twig/twig/lib/Twig/Template.php","line":374,"class":"craft\\\\web\\\\twig\\\\Template","method":"display","args":"[\\"sectionHandle\\" => \\"people\\", \\"entryId\\" => 45, \\"draftId\\" => null, \\"versionId\\" => null, ...]"},{"objectClass":"__TwigTemplate_7e9512f9827ababda89fa3bbd861269891a676c98f38c16beb574351943b1d0a","file":"/home/vagrant/craftx.dev/vendor/twig/twig/lib/Twig/Environment.php","line":288,"class":"Twig_Template","method":"render","args":"[\\"sectionHandle\\" => \\"people\\", \\"entryId\\" => 45, \\"draftId\\" => null, \\"versionId\\" => null, ...]"},{"objectClass":"craft\\\\web\\\\twig\\\\Environment","file":"/home/vagrant/craftx.dev/vendor/craftcms/cms/src/web/View.php","line":259,"class":"Twig_Environment","method":"render","args":"\\"entries/_edit\\", [\\"sectionHandle\\" => \\"people\\", \\"entryId\\" => 45, \\"draftId\\" => null, \\"versionId\\" => null, ...]"},{"objectClass":"craft\\\\web\\\\View","file":"/home/vagrant/craftx.dev/vendor/craftcms/cms/src/web/View.php","line":301,"class":"craft\\\\web\\\\View","method":"renderTemplate","args":"\\"entries/_edit\\", [\\"sectionHandle\\" => \\"people\\", \\"entryId\\" => 45, \\"draftId\\" => null, \\"versionId\\" => null, ...]"},{"objectClass":"craft\\\\web\\\\View","file":"/home/vagrant/craftx.dev/vendor/craftcms/cms/src/web/Controller.php","line":101,"class":"craft\\\\web\\\\View","method":"renderPageTemplate","args":"\\"entries/_edit\\", [\\"sectionHandle\\" => \\"people\\", \\"entryId\\" => 45, \\"draftId\\" => null, \\"versionId\\" => null, ...]"},{"objectClass":"craft\\\\controllers\\\\EntriesController","file":"/home/vagrant/craftx.dev/vendor/craftcms/cms/src/controllers/EntriesController.php","line":357,"class":"craft\\\\web\\\\Controller","method":"renderTemplate","args":"\\"entries/_edit\\", [\\"sectionHandle\\" => \\"people\\", \\"entryId\\" => 45, \\"draftId\\" => null, \\"versionId\\" => null, ...]"},{"objectClass":"craft\\\\controllers\\\\EntriesController","file":null,"line":null,"class":"craft\\\\controllers\\\\EntriesController","method":"actionEditEntry","args":"\\"people\\", 45, null, null, ..."},{"objectClass":null,"file":"/home/vagrant/craftx.dev/vendor/yiisoft/yii2/base/InlineAction.php","line":57,"class":null,"method":"call_user_func_array","args":"[craft\\\\controllers\\\\EntriesController, \\"actionEditEntry\\"], [\\"people\\", \\"45\\", null, null, ...]"},{"objectClass":"yii\\\\base\\\\InlineAction","file":"/home/vagrant/craftx.dev/vendor/yiisoft/yii2/base/Controller.php","line":156,"class":"yii\\\\base\\\\InlineAction","method":"runWithParams","args":"[\\"sectionHandle\\" => \\"people\\", \\"entryId\\" => \\"45\\", \\"slug\\" => \\"-gui-rams\\"]"},{"objectClass":"craft\\\\controllers\\\\EntriesController","file":"/home/vagrant/craftx.dev/vendor/yiisoft/yii2/base/Module.php","line":523,"class":"yii\\\\base\\\\Controller","method":"runAction","args":"\\"edit-entry\\", [\\"sectionHandle\\" => \\"people\\", \\"entryId\\" => \\"45\\", \\"slug\\" => \\"-gui-rams\\"]"},{"objectClass":"craft\\\\web\\\\Application","file":"/home/vagrant/craftx.dev/vendor/craftcms/cms/src/web/Application.php","line":246,"class":"yii\\\\base\\\\Module","method":"runAction","args":"\\"entries/edit-entry\\", [\\"sectionHandle\\" => \\"people\\", \\"entryId\\" => \\"45\\", \\"slug\\" => \\"-gui-rams\\"]"},{"objectClass":"craft\\\\web\\\\Application","file":"/home/vagrant/craftx.dev/vendor/yiisoft/yii2/web/Application.php","line":102,"class":"craft\\\\web\\\\Application","method":"runAction","args":"\\"entries/edit-entry\\", [\\"sectionHandle\\" => \\"people\\", \\"entryId\\" => \\"45\\", \\"slug\\" => \\"-gui-rams\\"]"},{"objectClass":"craft\\\\web\\\\Application","file":"/home/vagrant/craftx.dev/vendor/craftcms/cms/src/web/Application.php","line":211,"class":"yii\\\\web\\\\Application","method":"handleRequest","args":"craft\\\\web\\\\Request"},{"objectClass":"craft\\\\web\\\\Application","file":"/home/vagrant/craftx.dev/vendor/yiisoft/yii2/base/Application.php","line":380,"class":"craft\\\\web\\\\Application","method":"handleRequest","args":"craft\\\\web\\\\Request"},{"objectClass":"craft\\\\web\\\\Application","file":"/home/vagrant/craftx.dev/web/index.php","line":21,"class":"yii\\\\base\\\\Application","method":"run","args":null}]','2017-06-03 13:05:19','2017-06-03 13:05:19','9c323037-3b25-4e3c-8be7-9f6f3a287942');
ALTER TABLE `cx_deprecationerrors` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_elementindexsettings` WRITE;
ALTER TABLE `cx_elementindexsettings` DISABLE KEYS;
ALTER TABLE `cx_elementindexsettings` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_elements_i18n` WRITE;
ALTER TABLE `cx_elements_i18n` DISABLE KEYS;
INSERT INTO `cx_elements_i18n` (`id`, `elementId`, `siteId`, `slug`, `uri`, `enabled`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(1,1,1,'',NULL,1,'2017-02-06 18:39:45','2017-06-03 12:58:46','9504a134-b2e6-46af-b4aa-74c9b71c7b77'),
	(2,2,1,'homepage','__home__',1,'2017-02-06 18:57:45','2017-06-03 12:32:51','5283df6e-7b1f-456c-ae86-5e3974e90a16'),
	(4,4,1,NULL,NULL,1,'2017-03-05 05:52:42','2017-06-03 12:32:51','0cdc23ab-7302-4134-9493-21b97cd2459a'),
	(5,5,1,NULL,NULL,1,'2017-03-05 05:52:42','2017-06-03 12:32:51','fce317c9-5809-4cff-a4e7-5d7c3c8e4c77'),
	(6,6,1,NULL,NULL,1,'2017-03-05 05:52:42','2017-06-03 12:32:51','99e6eb9a-4c4e-4cbd-9628-d068e5eb657c'),
	(7,7,1,NULL,NULL,1,'2017-03-05 05:52:42','2017-06-03 12:32:51','35184b9d-ae82-4c6b-9200-f43027abdb16'),
	(25,25,1,NULL,NULL,1,'2017-04-08 06:07:47','2017-05-02 03:08:27','b4fc1190-f33d-465a-a461-00f8165293ad'),
	(26,26,1,NULL,NULL,1,'2017-04-08 06:08:27','2017-05-02 03:08:28','fae40c9e-7deb-4b31-93ea-45e127654f2b'),
	(28,28,1,'tools-and-workflows','hangouts/tools-and-workflows',1,'2017-04-26 05:02:36','2017-05-30 04:34:08','39c52c7d-f782-498b-a503-ec44538dfcdc'),
	(29,29,1,'design-and-productivity-apps','hangouts/design-and-productivity-apps',1,'2017-04-26 17:31:08','2017-05-30 04:34:08','9ed04a0d-240d-40f1-a0d3-a1c4f97d5c58'),
	(32,32,1,'jalen-davenport',NULL,1,'2017-04-27 20:59:45','2017-05-22 04:23:21','63dd3127-7e61-4263-8569-f4f393f76d2d'),
	(33,33,1,'john-morton',NULL,1,'2017-04-27 21:01:21','2017-05-22 04:23:21','a5d18976-8224-4f95-af81-8c6c34f0f171'),
	(34,34,1,'jalen-davenport',NULL,1,'2017-04-27 21:07:23','2017-05-22 04:23:21','2035e2a2-c0fc-48e3-a78e-e42ff1faae28'),
	(35,35,1,'selvin-ortiz',NULL,1,'2017-04-27 21:09:02','2017-05-22 04:23:21','228eccd5-04dd-45c7-aa69-8d5e86ec6a48'),
	(36,36,1,'nathaniel-hammond',NULL,1,'2017-04-27 21:10:56','2017-05-22 04:23:21','7dd3a169-7dd7-4af6-9d87-b1881e0425c7'),
	(37,37,1,'getting-better-at-the-freelancing-thing','hangouts/getting-better-at-the-freelancing-thing',1,'2017-04-28 16:10:51','2017-05-30 04:34:08','1b9a4265-f706-46d4-87c5-0841a6b471aa'),
	(38,38,1,'daryl-knight',NULL,1,'2017-04-28 16:46:35','2017-05-22 04:23:21','a33a3cbd-04f3-4cff-9e25-360b36349e48'),
	(39,39,1,'productivity',NULL,1,'2017-04-28 20:02:32','2017-04-28 20:02:32','540c63e4-e5ac-4df9-864e-1593578a0923'),
	(40,40,1,'freelancing',NULL,1,'2017-04-28 20:02:45','2017-04-28 20:02:45','c5d74b79-4e5b-4ed7-9cea-400e6e594b5b'),
	(41,41,1,'design',NULL,1,'2017-04-28 20:05:02','2017-04-28 20:05:25','6efb2004-657f-41da-b494-b37e74fe2482'),
	(42,42,1,'development',NULL,1,'2017-04-28 20:05:13','2017-04-28 20:05:25','dd723892-0be9-4cb1-9e22-d4fa2786db11'),
	(43,43,1,'estimating-and-pricing-web-projects','hangouts/estimating-and-pricing-web-projects',1,'2017-05-02 19:30:22','2017-05-30 04:34:08','c80cce5b-0677-48db-a4cb-483bab1a2ae2'),
	(44,44,1,'ben-parizek',NULL,1,'2017-05-03 12:13:03','2017-05-22 04:23:21','dc6f9de1-4e47-45de-a8da-f02810b8e3ce'),
	(45,45,1,'gui-rams',NULL,1,'2017-05-03 12:30:00','2017-05-22 04:23:21','d20e3e42-f994-4e7f-b20c-95f4deb15733'),
	(50,50,1,NULL,NULL,1,'2017-05-08 20:49:37','2017-05-15 23:57:54','bbd984b2-873f-4775-9636-5db729900f45'),
	(51,51,1,'craft-cms',NULL,1,'2017-05-11 15:48:44','2017-05-11 16:04:57','5715491f-13bb-4ceb-905c-ff69f73aaf33'),
	(52,52,1,'craft-3-plugin-store','hangouts/craft-3-plugin-store',1,'2017-05-11 16:04:56','2017-05-30 04:34:08','689697b6-ea4b-463f-b4e0-3116a1600bea'),
	(53,53,1,'brandon-kelly',NULL,1,'2017-05-11 16:06:14','2017-05-22 04:23:21','7f184ca8-2eda-46d7-a425-ffdd9e00fbd1'),
	(57,57,1,NULL,NULL,1,'2017-05-12 16:55:13','2017-06-03 11:09:12','290940a4-5c34-4a43-b6d1-c10794e4a13c'),
	(58,58,1,NULL,NULL,1,'2017-05-13 22:28:19','2017-06-03 12:32:51','be5841f0-8496-4073-bf8c-e012f0df94ab'),
	(59,59,1,NULL,NULL,1,'2017-05-13 22:28:19','2017-06-03 12:32:51','6e06950c-8ad4-4b7b-9d87-a42c3d5ca1e6'),
	(60,60,1,NULL,NULL,1,'2017-05-13 22:28:19','2017-06-03 12:32:51','2edc835e-a924-4bc6-b06b-9dbf4cfcb033'),
	(61,61,1,NULL,NULL,1,'2017-05-13 22:28:19','2017-06-03 12:32:51','8f4596d7-16ec-4c0c-8a3c-af85a05b0ed4'),
	(62,62,1,NULL,NULL,1,'2017-05-13 22:28:19','2017-06-03 12:32:51','068f43cd-d2cc-4607-877c-3af1634f9167'),
	(63,63,1,NULL,NULL,1,'2017-05-13 22:28:19','2017-06-03 12:32:51','e9fbfb4c-1cf1-4689-832a-7a2195353bd3'),
	(64,64,1,NULL,NULL,1,'2017-05-13 22:42:03','2017-06-03 12:32:51','c3a70e72-6bd9-490e-9bc7-4f8b44a22577'),
	(65,65,1,NULL,NULL,1,'2017-05-13 22:42:03','2017-06-03 12:32:51','45738684-8d87-4f25-b642-d2a7bb9e313c'),
	(66,66,1,NULL,NULL,1,'2017-05-13 22:42:03','2017-06-03 12:32:51','3f903948-dd21-4f56-9844-ee2cbf8a18e1'),
	(67,67,1,'wade-anderson',NULL,1,'2017-05-16 00:16:27','2017-05-22 04:23:21','95d9fcd7-78a7-4eb9-b593-593bd89501fd'),
	(68,68,1,'editors',NULL,1,'2017-05-16 02:13:47','2017-05-19 12:50:44','8b5a7339-25a8-449f-b81f-195a149e409e'),
	(69,69,1,'the-case-for-vs-code','hangouts/the-case-for-vs-code',1,'2017-05-16 02:14:45','2017-06-02 00:54:15','cff4265a-29cc-4e00-bc29-cb62ea6e374e'),
	(70,70,1,NULL,NULL,1,'2017-05-16 03:15:14','2017-06-03 11:09:12','ebae523e-5413-4898-84da-f99c606aa9cc'),
	(71,71,1,'vs-code',NULL,1,'2017-05-16 16:53:38','2017-05-16 16:53:43','c5209c36-77c9-402e-a7e3-8f8a35fd1067'),
	(72,72,1,'phpstorm',NULL,1,'2017-05-19 12:33:53','2017-05-19 13:02:17','b21a55cb-14e6-4979-96c1-b3a3003f0598'),
	(74,74,1,'taking-php-and-craft-by-storm','hangouts/taking-php-and-craft-by-storm',1,'2017-05-19 12:50:18','2017-05-30 04:34:08','e1979ba2-f59c-41ca-8e26-86b757a9a6f0'),
	(75,75,1,NULL,NULL,1,'2017-05-19 13:08:31','2017-06-03 11:09:12','4412d60a-5bac-412d-94f6-76eb682f5e53'),
	(76,76,1,NULL,NULL,1,'2017-05-22 03:52:17','2017-06-03 11:09:12','adcd3e37-48cc-4d08-b111-348081ef90e5'),
	(77,77,1,'gary-hockin',NULL,1,'2017-05-22 03:53:09','2017-05-22 05:17:22','55062bd2-74ff-4be7-96c9-760d3e6a8e44'),
	(78,78,1,NULL,NULL,1,'2017-05-22 04:09:46','2017-06-03 11:09:12','92d4502c-c23a-43b5-8375-00dfdf00102e'),
	(79,79,1,NULL,NULL,1,'2017-05-22 04:14:02','2017-06-03 11:09:12','0beae063-23e2-4259-ade3-262e18808627'),
	(80,80,1,NULL,NULL,1,'2017-05-24 07:25:01','2017-06-03 12:32:51','47afd21a-45db-41ef-b1c1-1cc533e2f1b7'),
	(81,81,1,NULL,NULL,1,'2017-06-01 23:27:50','2017-06-03 11:09:12','0c1ff03a-3f09-4de6-9f27-eed11f1a9d1c'),
	(82,82,1,'learning-and-teaching-web-technologies','hangouts/learning-and-teaching-web-technologies',1,'2017-06-01 23:35:15','2017-06-02 00:46:56','96aceb97-b3f1-478d-88a8-33e475264c01'),
	(83,83,1,NULL,NULL,1,'2017-06-01 23:42:49','2017-06-03 11:09:12','bfc15066-5de7-4cb5-b5f4-bc90bd0ccf95'),
	(84,84,1,'wes-bos',NULL,1,'2017-06-01 23:43:08','2017-06-01 23:43:45','c26545b6-c583-420d-877c-a4cca23b59b0');
ALTER TABLE `cx_elements_i18n` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_entries` WRITE;
ALTER TABLE `cx_entries` DISABLE KEYS;
INSERT INTO `cx_entries` (`id`, `sectionId`, `typeId`, `authorId`, `postDate`, `expiryDate`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(2,1,1,NULL,'2017-06-03 12:32:51',NULL,'2017-02-06 18:57:45','2017-06-03 12:32:51','2466f0af-20d8-4705-bd99-e780840f65f0'),
	(28,5,6,1,'2017-04-19 17:00:00',NULL,'2017-04-26 05:02:36','2017-05-30 04:34:08','363e0746-d813-4379-88bc-0d84e6931616'),
	(29,5,6,1,'2017-04-26 17:00:00',NULL,'2017-04-26 17:31:08','2017-05-30 04:34:08','7367278a-30e9-4e43-a85e-1eca574f4461'),
	(32,6,7,1,'2017-04-27 20:59:00',NULL,'2017-04-27 20:59:45','2017-05-22 04:23:21','e5350d53-0c67-466d-903b-d578c28ecfea'),
	(33,6,7,1,'2017-04-27 21:01:00',NULL,'2017-04-27 21:01:21','2017-05-22 04:23:21','11b89641-a95d-465a-9274-7f92b176c80f'),
	(34,6,7,1,'2017-04-27 20:59:00',NULL,'2017-04-27 21:07:23','2017-05-22 04:23:21','59cfbdb0-5b9d-4318-9d21-165c7d12c694'),
	(35,6,7,1,'2017-04-27 21:09:00',NULL,'2017-04-27 21:09:02','2017-05-22 04:23:21','7b0157bb-517e-4eb3-82cf-e717cf11b7a1'),
	(36,6,7,1,'2017-04-27 21:10:00',NULL,'2017-04-27 21:10:56','2017-05-22 04:23:21','deeae61a-9134-46cd-8104-cea2d7131d48'),
	(37,5,6,1,'2017-04-28 23:12:00',NULL,'2017-04-28 16:10:51','2017-05-30 04:34:08','4a07d620-9dc8-4bce-b1a0-29e33d03405e'),
	(38,6,7,1,'2017-04-28 16:46:35',NULL,'2017-04-28 16:46:35','2017-05-22 04:23:21','4e0d69f0-d6f7-441e-be19-d5fea8461919'),
	(43,5,6,1,'2017-05-02 19:30:00',NULL,'2017-05-02 19:30:22','2017-05-30 04:34:08','b7919193-533d-4d79-9920-6aec913f3e27'),
	(44,6,7,1,'2017-05-03 12:13:03',NULL,'2017-05-03 12:13:03','2017-05-22 04:23:21','753c6ad7-f2a5-49be-8e98-6eb1aba746b0'),
	(45,6,7,1,'2017-05-03 12:30:00',NULL,'2017-05-03 12:30:00','2017-05-22 04:23:21','7a16aaae-4771-4acc-b6c2-fc6172000147'),
	(52,5,6,1,'2017-05-11 16:07:00',NULL,'2017-05-11 16:04:56','2017-05-30 04:34:08','f0656083-15bc-4003-a9ce-2080550b15b2'),
	(53,6,7,1,'2017-05-11 16:06:00',NULL,'2017-05-11 16:06:14','2017-05-22 04:23:21','c7b5d319-ed28-4a06-b5c0-ba6b76a28649'),
	(67,6,7,1,'2017-05-16 00:16:00',NULL,'2017-05-16 00:16:27','2017-05-22 04:23:21','058b5e14-7929-4802-8d72-2393322207dd'),
	(69,5,6,1,'2017-05-16 16:50:00',NULL,'2017-05-16 02:14:45','2017-06-02 00:54:15','e4272c12-07c1-4bd2-94cc-458582b591ee'),
	(74,5,6,1,'2017-05-19 13:12:00',NULL,'2017-05-19 12:50:18','2017-05-30 04:34:08','d79df67f-f52d-4415-bd6c-713cdd0863fa'),
	(77,6,7,1,'2017-05-16 00:16:00',NULL,'2017-05-22 03:53:09','2017-05-22 05:17:22','ab272bc8-84a3-4491-82b2-e4509f0a2f55'),
	(82,5,6,1,'2017-06-02 00:18:00',NULL,'2017-06-01 23:35:15','2017-06-02 00:46:56','7b73f4d8-a897-4904-b5dd-b53a46492f83'),
	(84,6,7,1,'2017-06-01 23:43:45',NULL,'2017-06-01 23:43:08','2017-06-01 23:43:45','84a94264-5d6c-4833-a531-a57ff0d3c6d6');
ALTER TABLE `cx_entries` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_entrydrafts` WRITE;
ALTER TABLE `cx_entrydrafts` DISABLE KEYS;
ALTER TABLE `cx_entrydrafts` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_fieldlayouts` WRITE;
ALTER TABLE `cx_fieldlayouts` DISABLE KEYS;
INSERT INTO `cx_fieldlayouts` (`id`, `type`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(16,'craft\\elements\\MatrixBlock','2017-03-05 06:17:53','2017-05-13 22:19:26','9a0118ae-4100-4374-b399-15875aa7c4e2'),
	(17,'craft\\elements\\MatrixBlock','2017-03-06 06:25:51','2017-05-12 17:19:05','e5348576-0b50-4a96-b4c0-a957204ba9c7'),
	(18,'craft\\elements\\Entry','2017-03-06 06:28:43','2017-05-13 22:22:35','54aa87dc-f052-437f-8af8-2d27d589fc41'),
	(22,'craft\\elements\\Asset','2017-03-06 17:12:42','2017-05-12 04:46:26','80662f76-4104-4119-bba8-7eb9adcffdd9'),
	(27,'craft\\elements\\User','2017-03-07 04:59:15','2017-03-07 04:59:15','aec4f7cd-1bb4-4af4-96b8-f8f9649b487b'),
	(28,'craft\\elements\\Asset','2017-04-06 16:41:46','2017-05-07 17:14:36','ca90c57c-8390-4520-a540-5ad253885b97'),
	(29,'craft\\elements\\Entry','2017-04-23 21:07:18','2017-05-30 04:34:08','074ca22e-d4bb-49d8-8a3a-ab97d643a82a'),
	(30,'craft\\elements\\Entry','2017-04-27 20:44:56','2017-05-22 04:23:21','749773de-2dca-4737-870f-9dd18d026605'),
	(31,'craft\\elements\\Category','2017-04-28 20:02:13','2017-04-28 20:02:13','59375a0f-1e1a-4097-b2fe-1d8293d23b9d'),
	(32,'craft\\elements\\GlobalSet','2017-05-08 20:49:37','2017-05-08 20:49:37','049e0085-734f-479d-83d1-bc9575898e82'),
	(33,'craft\\elements\\Asset','2017-05-12 04:42:11','2017-05-12 18:03:45','126a14f6-8495-4e95-8a4a-0f906958eede'),
	(34,'craft\\elements\\MatrixBlock','2017-05-13 22:21:05','2017-05-13 22:21:05','c7e1da6b-3920-4ec2-810d-660f0edb5a6c'),
	(35,'craft\\elements\\Asset','2017-05-22 03:39:15','2017-05-22 03:39:15','d8992d54-af82-43f6-9455-6056995f3a64');
ALTER TABLE `cx_fieldlayouts` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_entrytypes` WRITE;
ALTER TABLE `cx_entrytypes` DISABLE KEYS;
INSERT INTO `cx_entrytypes` (`id`, `sectionId`, `fieldLayoutId`, `name`, `handle`, `hasTitleField`, `titleLabel`, `titleFormat`, `sortOrder`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(1,1,18,'Homepage','homepage',1,'Name',NULL,1,'2017-02-06 18:57:45','2017-05-13 22:22:35','5c2f8151-f389-4dc0-9a0a-c0596ca9686f'),
	(6,5,29,'Hangouts','hangouts',1,'Title',NULL,1,'2017-04-23 21:07:18','2017-05-30 04:34:08','ab70dfd3-becb-414b-9d18-b0eb753086ea'),
	(7,6,30,'People','people',0,NULL,'{firstName} {lastName}',1,'2017-04-27 20:44:56','2017-05-22 04:23:21','7b0341c9-2615-445f-b6ee-912a008b88d8');
ALTER TABLE `cx_entrytypes` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_entryversions` WRITE;
ALTER TABLE `cx_entryversions` DISABLE KEYS;
ALTER TABLE `cx_entryversions` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_fieldgroups` WRITE;
ALTER TABLE `cx_fieldgroups` DISABLE KEYS;
INSERT INTO `cx_fieldgroups` (`id`, `name`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(1,'Shared','2017-02-07 05:14:22','2017-02-07 05:14:22','799c0f93-61ee-404c-b178-c8c8e7f66e24'),
	(3,'Homepage','2017-03-05 04:31:11','2017-03-05 04:31:11','96fab19c-20cb-41e9-96f7-15cde27c09d4'),
	(5,'Hangouts','2017-04-23 21:21:35','2017-04-23 21:21:35','ef2dbc0b-f686-4005-b441-0a5b0b835ea9'),
	(7,'People','2017-04-27 20:45:11','2017-04-27 21:03:54','5a43d1a7-c0b5-40c5-adc0-3f489010d2ad');
ALTER TABLE `cx_fieldgroups` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_fieldlayouttabs` WRITE;
ALTER TABLE `cx_fieldlayouttabs` DISABLE KEYS;
INSERT INTO `cx_fieldlayouttabs` (`id`, `layoutId`, `name`, `sortOrder`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(21,27,'Profile',1,'2017-03-07 04:59:15','2017-03-07 04:59:15','648668c3-0bd6-4557-8ce8-220770f1d627'),
	(50,32,'Content',1,'2017-05-08 20:49:37','2017-05-08 20:49:37','14d4d39f-d93c-4891-9df0-0839e9015acc'),
	(54,17,'Content',1,'2017-05-12 17:19:05','2017-05-12 17:19:05','6f400589-6e95-4eb4-baee-a8e8ac4f072b'),
	(56,16,'Content',1,'2017-05-13 22:19:26','2017-05-13 22:19:26','2ceff437-cf51-4510-a20b-b55fd67e2429'),
	(57,34,'Content',1,'2017-05-13 22:21:05','2017-05-13 22:21:05','8ca6ffa5-1306-44fa-8a68-04d05b2dd58f'),
	(58,18,'Content',1,'2017-05-13 22:22:35','2017-05-13 22:22:35','3cc85364-0624-498d-a599-7987c1b075c8'),
	(62,30,'People',1,'2017-05-22 04:23:21','2017-05-22 04:23:21','634bc381-2c98-4946-bf9d-9046291cbe01'),
	(65,29,'Hangouts',1,'2017-05-30 04:34:08','2017-05-30 04:34:08','2eb40ae4-ea1e-47e5-8ab1-8f40ce07a0ca');
ALTER TABLE `cx_fieldlayouttabs` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_fields` WRITE;
ALTER TABLE `cx_fields` DISABLE KEYS;
INSERT INTO `cx_fields` (`id`, `groupId`, `name`, `handle`, `context`, `instructions`, `translationMethod`, `translationKeyFormat`, `type`, `settings`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(3,1,'Markdown','markdown','global','','none',NULL,'selvinortiz\\doxter\\fields\\DoxterField','{"tabSize":2,"indentWithTabs":false,"enableLineWrapping":true,"enableSpellChecker":false}','2017-02-07 05:15:25','2017-02-07 05:15:25','5f019cad-79cb-464d-b8d0-10603a397974'),
	(17,3,'Features','features','global','','site',NULL,'craft\\fields\\Matrix','{"maxBlocks":"","localizeBlocks":false}','2017-03-05 04:50:56','2017-05-13 22:19:26','84e13bf7-b56d-470d-97af-97f24826b912'),
	(18,NULL,'Feature Lead','featureLead','matrixBlockType:1','','none',NULL,'craft\\fields\\PlainText','{"placeholder":"Weekly Hangouts","multiline":"","initialRows":"4","charLimit":"","columnType":"text"}','2017-03-05 04:50:56','2017-05-13 22:19:26','4ea651b7-d653-45f7-a713-abbfb1318b51'),
	(19,NULL,'Feature Text','featureText','matrixBlockType:1','','none',NULL,'craft\\fields\\PlainText','{"placeholder":"Join our weekly hangouts where we talk about Craft CMS, design, freelancing and more. Eavesdropping allowed ;)","multiline":"1","initialRows":"3","charLimit":"","columnType":"text"}','2017-03-05 04:50:56','2017-05-13 22:19:26','5f256135-443c-4bf3-9ef4-e4527d64b3f4'),
	(28,3,'Hero','hero','global','','site',NULL,'craft\\fields\\Matrix','{"maxBlocks":"1","localizeBlocks":false}','2017-03-05 05:02:55','2017-05-12 17:19:05','f6e64b0e-e5c2-4511-a6a7-9296d022ffed'),
	(29,NULL,'Hero Lead','heroLead','matrixBlockType:3','','none',NULL,'craft\\fields\\PlainText','{"placeholder":"","multiline":"","initialRows":"4","charLimit":"","columnType":"text"}','2017-03-05 05:02:55','2017-05-12 17:19:05','7b687433-c5e0-476c-80ea-cd714576e861'),
	(30,NULL,'Hero Text','heroText','matrixBlockType:3','','none',NULL,'craft\\fields\\PlainText','{"placeholder":"","multiline":"","initialRows":"4","charLimit":"","columnType":"text"}','2017-03-05 05:02:55','2017-05-12 17:19:05','365932be-65a2-4c96-a4b7-d08934c55b1c'),
	(31,NULL,'Hero CTA Text','heroCtaText','matrixBlockType:3','','none',NULL,'craft\\fields\\PlainText','{"placeholder":"","multiline":"","initialRows":"4","charLimit":"","columnType":"text"}','2017-03-05 05:02:55','2017-05-12 17:19:05','2464b465-225b-45ca-a0c6-6506d08cbd6d'),
	(32,1,'Lead','lead','global','','none',NULL,'craft\\fields\\PlainText','{"placeholder":"","multiline":"","initialRows":"4","charLimit":"","columnType":"text"}','2017-03-06 06:27:13','2017-03-06 06:27:13','c50ebf6d-9b16-4835-916a-ec28810f3e99'),
	(33,1,'Text','text','global','','none',NULL,'craft\\fields\\PlainText','{"placeholder":"","multiline":"","initialRows":"4","charLimit":"","columnType":"text"}','2017-03-06 06:27:31','2017-03-06 06:27:31','856b5cdf-0a53-41c7-b172-42d700ba27ac'),
	(39,1,'Date/Time','dateTime','global','','none',NULL,'craft\\fields\\Date','{"showDate":true,"showTime":true,"minuteIncrement":"60"}','2017-04-23 21:52:05','2017-04-23 21:52:05','241c7175-9965-48e5-917e-a9ce742c19ed'),
	(40,5,'Hangout Date/Time','hangoutDateTime','global','','none',NULL,'craft\\fields\\Date','{"showDate":true,"showTime":true,"minuteIncrement":"60"}','2017-04-26 02:47:05','2017-04-26 02:47:05','5a1eea7d-51d6-479e-a94b-a2961aca28be'),
	(41,5,'Hangout Topic','hangoutTopic','global','','none',NULL,'selvinortiz\\doxter\\fields\\DoxterField','{"tabSize":2,"indentWithTabs":false,"enableLineWrapping":true,"enableSpellChecker":false}','2017-04-26 02:47:27','2017-04-26 02:47:27','b0319cd0-c9e3-48e2-b517-f35e8bfbe2c5'),
	(42,5,'Hangout Notes','hangoutNotes','global','','none',NULL,'selvinortiz\\doxter\\fields\\DoxterField','{"tabSize":2,"indentWithTabs":false,"enableLineWrapping":true,"enableSpellChecker":false}','2017-04-26 02:47:44','2017-04-26 02:47:44','78b8833e-3311-4d3a-b196-1bf43bdbf000'),
	(44,5,'Hangout Link','hangoutLink','global','','none',NULL,'craft\\fields\\PlainText','{"placeholder":"","multiline":"","initialRows":"4","charLimit":"255","columnType":"text"}','2017-04-26 05:12:34','2017-04-26 05:12:34','ce93f638-56e7-47b2-b113-79dbc78009d7'),
	(45,7,'First Name','firstName','global','','none',NULL,'craft\\fields\\PlainText','{"placeholder":"","multiline":"","initialRows":"4","charLimit":"","columnType":"text"}','2017-04-27 20:45:35','2017-04-27 21:04:09','0c9cbfea-33cf-483f-b959-1c7748de5200'),
	(46,7,'Last Name','lastName','global','','none',NULL,'craft\\fields\\PlainText','{"placeholder":"","multiline":"","initialRows":"4","charLimit":"","columnType":"text"}','2017-04-27 20:45:46','2017-04-27 21:04:15','be604f68-1cfa-4b99-9f38-a04262addce2'),
	(52,7,'Primary Website','primaryWebsite','global','','none',NULL,'craft\\fields\\PlainText','{"placeholder":"","multiline":"","initialRows":"4","charLimit":"","columnType":"text"}','2017-04-28 15:17:34','2017-04-28 15:21:45','fc4c2290-c62d-4138-a232-7ce08c4be782'),
	(53,7,'Slack Username','slackUsername','global','','none',NULL,'craft\\fields\\PlainText','{"placeholder":"","multiline":"","initialRows":"4","charLimit":"","columnType":"text"}','2017-04-28 15:17:46','2017-04-28 15:19:13','ee639384-4622-4ed9-be6c-44702a8d5db9'),
	(54,7,'Twitter Username','twitterUsername','global','','none',NULL,'craft\\fields\\PlainText','{"placeholder":"","multiline":"","initialRows":"4","charLimit":"","columnType":"text"}','2017-04-28 15:17:56','2017-04-28 15:18:21','c8f436c7-c4c3-4ee6-9c03-24aad1a7fe16'),
	(55,7,'Github Username','githubUsername','global','','none',NULL,'craft\\fields\\PlainText','{"placeholder":"","multiline":"","initialRows":"4","charLimit":"","columnType":"text"}','2017-04-28 15:18:08','2017-04-28 15:18:08','3bd87f54-7015-43c6-8428-1982ff25f0ab'),
	(56,5,'Hangout Categories','hangoutCategories','global','','site',NULL,'craft\\fields\\Categories','{"branchLimit":"2","sources":"*","source":"group:1","targetSiteId":null,"viewMode":null,"limit":null,"selectionLabel":"Add a category","localizeRelations":false}','2017-04-28 20:03:58','2017-04-28 20:11:15','51b361ba-7cf5-46c1-954d-d46c20dc688a'),
	(57,NULL,'Hero CTA URL','heroCtaUrl','matrixBlockType:3','','none',NULL,'craft\\fields\\PlainText','{"placeholder":"","multiline":"","initialRows":"4","charLimit":"","columnType":"text"}','2017-05-05 02:06:24','2017-05-12 17:19:05','1cd737f7-1d5d-4db7-b575-c46e20182e1a'),
	(58,NULL,'Feature Image Path','featureImagePath','matrixBlockType:1','','none',NULL,'craft\\fields\\PlainText','{"placeholder":"/dist/images/weekly-hangouts.svg","multiline":"","initialRows":"4","charLimit":"","columnType":"text"}','2017-05-05 02:08:29','2017-05-13 22:19:26','5a4f7345-6d8d-4d3e-9454-c39e1994b5db'),
	(60,5,'Hangout Image','hangoutImage','global','','site',NULL,'craft\\fields\\Assets','{"useSingleFolder":"1","defaultUploadLocationSource":"folder:1","defaultUploadLocationSubpath":"","singleUploadLocationSource":"folder:24","singleUploadLocationSubpath":"images","restrictFiles":"1","allowedKinds":["image"],"sources":"*","source":null,"targetSiteId":null,"viewMode":"large","limit":"1","selectionLabel":"Add image","localizeRelations":false}','2017-05-12 16:53:26','2017-05-22 04:30:35','a9c9cea4-1277-4e6e-85b8-e3c660bc183f'),
	(61,NULL,'Hero CTA Icon Classes','heroCtaIconClasses','matrixBlockType:3','','none',NULL,'craft\\fields\\PlainText','{"placeholder":"fa-heart-o","multiline":"","initialRows":"4","charLimit":"","columnType":"text"}','2017-05-12 17:19:05','2017-05-12 17:19:05','4301faca-b494-4e85-ba71-a397f3bd13e9'),
	(62,NULL,'Feature CTA Text','featureCtaText','matrixBlockType:1','','none',NULL,'craft\\fields\\PlainText','{"placeholder":"Latest Hangouts","multiline":"","initialRows":"4","charLimit":"","columnType":"text"}','2017-05-13 04:18:54','2017-05-13 22:19:26','1c9e1063-060d-41de-97d3-75454c393b80'),
	(63,NULL,'Feature CTA URL','featureCtaUrl','matrixBlockType:1','','none',NULL,'craft\\fields\\PlainText','{"placeholder":"/hangouts","multiline":"","initialRows":"4","charLimit":"","columnType":"text"}','2017-05-13 04:18:54','2017-05-13 22:19:26','6fd7fa3f-5a48-47ae-b880-9d49fc861699'),
	(64,NULL,'Feature CTA Icon Classes','featureCtaIconClasses','matrixBlockType:1','','none',NULL,'craft\\fields\\PlainText','{"placeholder":"fa-comments-o","multiline":"","initialRows":"4","charLimit":"","columnType":"text"}','2017-05-13 04:18:54','2017-05-13 22:19:26','e047e7da-d0e5-4bbb-affa-acb1001cc208'),
	(65,3,'Technologies','technologies','global','','site',NULL,'craft\\fields\\Matrix','{"maxBlocks":"","localizeBlocks":false}','2017-05-13 22:21:04','2017-05-13 22:21:04','a73563a9-a629-4ba2-89ed-3b34a5ca2e69'),
	(66,NULL,'Technology Name','technologyName','matrixBlockType:4','','none',NULL,'craft\\fields\\PlainText','{"placeholder":"Vue 2","multiline":"","initialRows":"4","charLimit":"","columnType":"text"}','2017-05-13 22:21:05','2017-05-13 22:21:05','822875e5-8eaa-444c-9154-9f3d74f2b22b'),
	(67,NULL,'Technology URL','technologyUrl','matrixBlockType:4','','none',NULL,'craft\\fields\\PlainText','{"placeholder":"http://vuejs.org/","multiline":"","initialRows":"4","charLimit":"","columnType":"text"}','2017-05-13 22:21:05','2017-05-13 22:21:05','cdff39c6-3554-4139-99c4-38502ffff8af'),
	(68,NULL,'Technology Image Path','technologyImagePath','matrixBlockType:4','','none',NULL,'craft\\fields\\PlainText','{"placeholder":"/dist/images/technology/vue.svg","multiline":"","initialRows":"4","charLimit":"","columnType":"text"}','2017-05-13 22:21:05','2017-05-13 22:21:05','54c646bb-5954-40e8-9d93-56cea5af97ce'),
	(69,7,'Photo','photo','global','','site',NULL,'craft\\fields\\Assets','{"useSingleFolder":"1","defaultUploadLocationSource":"folder:1","defaultUploadLocationSubpath":"","singleUploadLocationSource":"folder:28","singleUploadLocationSubpath":"","restrictFiles":"1","allowedKinds":["image"],"sources":"*","source":null,"targetSiteId":null,"viewMode":"large","limit":"1","selectionLabel":"Add Photo","localizeRelations":false}','2017-05-22 03:41:08','2017-05-22 03:41:08','b643d195-18c1-4e73-9b8a-0cd0136ae85c'),
	(70,7,'Role','role','global','','none',NULL,'craft\\fields\\PlainText','{"placeholder":"","multiline":"","initialRows":"4","charLimit":"","columnType":"text"}','2017-05-22 04:15:08','2017-05-22 04:15:08','f229de65-a63c-4bd5-98a2-af03701a3b31'),
	(71,7,'Company','company','global','','none',NULL,'craft\\fields\\PlainText','{"placeholder":"","multiline":"","initialRows":"4","charLimit":"","columnType":"text"}','2017-05-22 04:15:37','2017-05-22 04:15:37','f07f9fdc-4895-4e0e-bafc-382f2f6758a8'),
	(72,5,'Hangout Guest','hangoutGuest','global','','site',NULL,'craft\\fields\\Entries','{"sources":["section:6"],"source":null,"targetSiteId":null,"viewMode":null,"limit":"1","selectionLabel":"Add guest","localizeRelations":false}','2017-05-22 04:26:15','2017-05-22 04:26:15','212ee644-e533-4c9b-9dea-73c57870e5fd'),
	(73,5,'Hangout Stream','hangoutStream','global','','none',NULL,'craft\\fields\\PlainText','{"placeholder":"","multiline":"","initialRows":"4","charLimit":"","columnType":"text"}','2017-05-30 04:30:16','2017-05-30 04:30:16','734b6b10-7d30-4d56-8f41-79ed0136795e');
ALTER TABLE `cx_fields` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_fieldlayoutfields` WRITE;
ALTER TABLE `cx_fieldlayoutfields` DISABLE KEYS;
INSERT INTO `cx_fieldlayoutfields` (`id`, `layoutId`, `tabId`, `fieldId`, `required`, `sortOrder`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(214,32,50,3,0,1,'2017-05-08 20:49:37','2017-05-08 20:49:37','086b47cc-dcbc-4ec4-a5a7-08f127ea388d'),
	(243,17,54,29,1,1,'2017-05-12 17:19:05','2017-05-12 17:19:05','02580a46-b1e2-4b4d-926f-4a559b98195b'),
	(244,17,54,30,1,2,'2017-05-12 17:19:06','2017-05-12 17:19:06','1f64eb67-821a-4e32-96d4-33103e6e34ed'),
	(245,17,54,31,1,3,'2017-05-12 17:19:06','2017-05-12 17:19:06','adf53a51-2807-424c-9926-04a8460661af'),
	(246,17,54,57,1,4,'2017-05-12 17:19:06','2017-05-12 17:19:06','2e8be9dc-df1d-4f54-8ba7-da66ecf680b3'),
	(247,17,54,61,0,5,'2017-05-12 17:19:06','2017-05-12 17:19:06','0c5d10d7-1715-479e-a21f-eb24e09061c6'),
	(254,16,56,18,1,1,'2017-05-13 22:19:26','2017-05-13 22:19:26','88fde05c-8cac-47d4-918a-9ce5ae0c4f6d'),
	(255,16,56,19,1,2,'2017-05-13 22:19:26','2017-05-13 22:19:26','746f4b9e-33be-4b39-bdf9-29f93289fc9d'),
	(256,16,56,58,1,3,'2017-05-13 22:19:26','2017-05-13 22:19:26','a76192ff-ac76-4623-8215-12d30e49305a'),
	(257,16,56,62,0,4,'2017-05-13 22:19:26','2017-05-13 22:19:26','36cc4833-097c-4d95-8175-bacc182995c2'),
	(258,16,56,63,0,5,'2017-05-13 22:19:26','2017-05-13 22:19:26','5db9cd1f-9df0-445f-8d34-cad9a0f4fa95'),
	(259,16,56,64,0,6,'2017-05-13 22:19:26','2017-05-13 22:19:26','c22e54f6-631c-45d7-9015-3c47ad89ca9a'),
	(260,34,57,66,1,1,'2017-05-13 22:21:05','2017-05-13 22:21:05','2da0fbdf-7a20-4e0b-9f0d-1a8799b3b92b'),
	(261,34,57,67,1,2,'2017-05-13 22:21:05','2017-05-13 22:21:05','64c98aa1-6b04-4936-a0b8-a812f6a22b5f'),
	(262,34,57,68,1,3,'2017-05-13 22:21:05','2017-05-13 22:21:05','921c5eac-b49a-4978-aa7c-b5d6969906ce'),
	(263,18,58,32,0,1,'2017-05-13 22:22:35','2017-05-13 22:22:35','33909f96-0f5c-4d6e-b5c3-b3ed27f85a2e'),
	(264,18,58,33,0,2,'2017-05-13 22:22:35','2017-05-13 22:22:35','3dd87f4d-66d3-403e-a9dc-516a67156111'),
	(265,18,58,28,0,3,'2017-05-13 22:22:35','2017-05-13 22:22:35','470a6d21-f037-406b-8976-586378ccf3bb'),
	(266,18,58,17,0,4,'2017-05-13 22:22:35','2017-05-13 22:22:35','28567333-72a5-46bb-bc1a-b43bef06223f'),
	(267,18,58,65,0,5,'2017-05-13 22:22:35','2017-05-13 22:22:35','3055ab2a-2821-4bd3-a450-f62f3cc18aaa'),
	(290,30,62,69,0,1,'2017-05-22 04:23:21','2017-05-22 04:23:21','e678a9c3-274d-4334-80a0-dde4340e4511'),
	(291,30,62,45,0,2,'2017-05-22 04:23:21','2017-05-22 04:23:21','4d58d246-0b07-4766-8ed6-6ead6d3d5e0a'),
	(292,30,62,46,0,3,'2017-05-22 04:23:21','2017-05-22 04:23:21','77b22778-7928-4f32-afff-e6bf84a59311'),
	(293,30,62,70,0,4,'2017-05-22 04:23:21','2017-05-22 04:23:21','22033570-ac44-444c-94a7-b04532482123'),
	(294,30,62,71,0,5,'2017-05-22 04:23:21','2017-05-22 04:23:21','7f713128-f82b-4adb-b9cd-a573bdf40f3a'),
	(295,30,62,52,0,6,'2017-05-22 04:23:21','2017-05-22 04:23:21','f5fcfccf-c2de-4d4a-8893-2d2c5a2988a3'),
	(296,30,62,53,0,7,'2017-05-22 04:23:21','2017-05-22 04:23:21','1d750139-719d-413d-a60b-7c0aae80ae1e'),
	(297,30,62,55,0,8,'2017-05-22 04:23:21','2017-05-22 04:23:21','996d5f2e-3487-4499-8e70-3254ea206201'),
	(298,30,62,54,0,9,'2017-05-22 04:23:21','2017-05-22 04:23:21','c417d286-7b25-4777-a106-53708854f8d3'),
	(319,29,65,72,0,1,'2017-05-30 04:34:08','2017-05-30 04:34:08','657ceb11-c703-4fa8-b5de-51660c958641'),
	(320,29,65,56,0,2,'2017-05-30 04:34:08','2017-05-30 04:34:08','c2fb5663-e3f4-46c6-814c-f06391437562'),
	(321,29,65,60,0,3,'2017-05-30 04:34:08','2017-05-30 04:34:08','28bbd012-756c-44e6-a90e-f9d100be360e'),
	(322,29,65,40,0,4,'2017-05-30 04:34:08','2017-05-30 04:34:08','0bc2a8b0-4f5a-46f5-b0fa-d11bce122a94'),
	(323,29,65,73,0,5,'2017-05-30 04:34:08','2017-05-30 04:34:08','11d85e66-b193-4fa9-92cc-79d54409eef1'),
	(324,29,65,44,0,6,'2017-05-30 04:34:08','2017-05-30 04:34:08','2e4587f5-fcbc-4a38-bc6e-7331cae920f9'),
	(325,29,65,41,0,7,'2017-05-30 04:34:08','2017-05-30 04:34:08','cea75055-9a53-4f0c-8bd6-1b99ea644ed5'),
	(326,29,65,42,0,8,'2017-05-30 04:34:08','2017-05-30 04:34:08','14b928f6-fc06-428b-8baa-eb6b4c913926');
ALTER TABLE `cx_fieldlayoutfields` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_globalsets` WRITE;
ALTER TABLE `cx_globalsets` DISABLE KEYS;
INSERT INTO `cx_globalsets` (`id`, `name`, `handle`, `fieldLayoutId`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(50,'Reference Links','referenceLinks',32,'2017-05-08 20:49:37','2017-05-08 20:49:37','7b6da23a-7c18-4622-bb9e-aee67197605e');
ALTER TABLE `cx_globalsets` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_info` WRITE;
ALTER TABLE `cx_info` DISABLE KEYS;
INSERT INTO `cx_info` (`id`, `version`, `schemaVersion`, `edition`, `timezone`, `on`, `maintenance`, `fieldVersion`, `dateCreated`, `dateUpdated`, `uid`, `name`) VALUES 
	(1,'3.0.0-beta.19','3.0.42',2,'America/Chicago',1,0,'oOzPuYt1bM8F','2017-02-06 18:39:45','2017-06-03 13:01:44','eaa61c2b-4f72-44a5-9c9a-1b9911d37734','CraftX');
ALTER TABLE `cx_info` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_matrixblocktypes` WRITE;
ALTER TABLE `cx_matrixblocktypes` DISABLE KEYS;
INSERT INTO `cx_matrixblocktypes` (`id`, `fieldId`, `fieldLayoutId`, `name`, `handle`, `sortOrder`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(1,17,16,'Feature','feature',1,'2017-03-05 04:50:56','2017-05-13 22:19:26','6b537673-6a61-47eb-b8fe-4b72fd92a457'),
	(3,28,17,'Hero','hero',1,'2017-03-05 05:02:55','2017-05-12 17:19:06','dc7681ea-75e7-4f8d-aa43-77ffe553d063'),
	(4,65,34,'technology','technology',1,'2017-05-13 22:21:05','2017-05-13 22:21:05','b1e8aa1c-ef2c-44fa-b968-902ac1f30a50');
ALTER TABLE `cx_matrixblocktypes` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_matrixblocks` WRITE;
ALTER TABLE `cx_matrixblocks` DISABLE KEYS;
INSERT INTO `cx_matrixblocks` (`id`, `ownerId`, `ownerSiteId`, `fieldId`, `typeId`, `sortOrder`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(4,2,NULL,28,3,1,'2017-03-05 05:52:42','2017-06-03 12:32:51','57f6d04c-5711-42d4-a21b-0c2692630af8'),
	(5,2,NULL,17,1,1,'2017-03-05 05:52:42','2017-06-03 12:32:51','c1ffe741-acef-423f-b759-74de0ede4a26'),
	(6,2,NULL,17,1,2,'2017-03-05 05:52:42','2017-06-03 12:32:51','3ab2bfab-50fc-4503-a4f0-da177044d92e'),
	(7,2,NULL,17,1,3,'2017-03-05 05:52:42','2017-06-03 12:32:51','993bcce5-45f9-45ac-b580-8595666d8902'),
	(58,2,NULL,65,4,1,'2017-05-13 22:28:19','2017-06-03 12:32:51','59085b29-e940-4295-aae1-c700914494b4'),
	(59,2,NULL,65,4,2,'2017-05-13 22:28:19','2017-06-03 12:32:51','2f9447a8-1791-4889-8c28-a20a9d4270a6'),
	(60,2,NULL,65,4,3,'2017-05-13 22:28:19','2017-06-03 12:32:51','b1a1092c-dd7b-4c90-bc5c-ae8bcfad1170'),
	(61,2,NULL,65,4,4,'2017-05-13 22:28:19','2017-06-03 12:32:51','8f6a24b9-31c9-43fa-9426-816fd05b7c68'),
	(62,2,NULL,65,4,5,'2017-05-13 22:28:19','2017-06-03 12:32:51','fafac225-9f45-4884-83df-b913491dfa79'),
	(63,2,NULL,65,4,6,'2017-05-13 22:28:19','2017-06-03 12:32:51','89e303de-3775-4d6b-80c1-29a024522ef1'),
	(64,2,NULL,65,4,7,'2017-05-13 22:42:03','2017-06-03 12:32:51','d3355bee-195e-4012-8e4e-a060b2778898'),
	(65,2,NULL,65,4,8,'2017-05-13 22:42:03','2017-06-03 12:32:51','8b687787-5134-4b29-a50d-f498d89df887'),
	(66,2,NULL,65,4,9,'2017-05-13 22:42:03','2017-06-03 12:32:51','40a5385b-aaf6-41f6-bc5c-7bee67d3c3a4'),
	(80,2,NULL,65,4,10,'2017-05-24 07:25:01','2017-06-03 12:32:51','82e35106-bc09-4d23-841d-353210a354c1');
ALTER TABLE `cx_matrixblocks` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_matrixcontent_features` WRITE;
ALTER TABLE `cx_matrixcontent_features` DISABLE KEYS;
INSERT INTO `cx_matrixcontent_features` (`id`, `elementId`, `siteId`, `dateCreated`, `dateUpdated`, `uid`, `field_feature_featureLead`, `field_feature_featureText`, `field_feature_featureImagePath`, `field_feature_featureCtaText`, `field_feature_featureCtaUrl`, `field_feature_featureCtaIconClasses`) VALUES 
	(1,5,1,'2017-03-05 05:52:42','2017-06-03 12:32:51','9d4ce59e-4807-461b-8422-7f30eb9426ad','Open Source','The source code for this entire website and its plugins is available on Github. We are friendly to first-time contributors.','/dist/images/open-source.svg','','',''),
	(2,6,1,'2017-03-05 05:52:42','2017-06-03 12:32:51','cc2f3782-10db-4c01-bd66-ed7e5d2721cf','Lively Hangouts','Join our lively hangouts where we talk about Craft CMS, design, freelancing and more. Eavesdropping allowed ;)','/dist/images/weekly-hangouts.svg','Latest Hangouts','/hangouts','fa-comments-o'),
	(3,7,1,'2017-03-05 05:52:42','2017-06-03 12:32:51','3b78108b-7420-402b-9eff-eb07e2ed3d5c','Developer Spotlight','Tell us about your Craft CMS plugins, projects, articles, and ideas. We\'ll give them a place to shine and you, the credit your deserve.','/dist/images/developer-spotlight.svg','','','');
ALTER TABLE `cx_matrixcontent_features` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_matrixcontent_hero` WRITE;
ALTER TABLE `cx_matrixcontent_hero` DISABLE KEYS;
INSERT INTO `cx_matrixcontent_hero` (`id`, `elementId`, `siteId`, `dateCreated`, `dateUpdated`, `uid`, `field_hero_heroLead`, `field_hero_heroText`, `field_hero_heroCtaText`, `field_hero_heroCtaUrl`, `field_hero_heroCtaIconClasses`) VALUES 
	(1,4,1,'2017-03-05 05:52:42','2017-06-03 12:32:51','efcb74c9-e1d6-4fa3-9e8f-382b7cd0ba1c','Unofficial Craft CMS Community','CraftX is an open source website built on Craft 3, and a friendly community of Web Professionals who care about their Craft.','Follow us on Twitter','https://twitter.com/craftxio','fa-twitter');
ALTER TABLE `cx_matrixcontent_hero` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_matrixcontent_technologies` WRITE;
ALTER TABLE `cx_matrixcontent_technologies` DISABLE KEYS;
INSERT INTO `cx_matrixcontent_technologies` (`id`, `elementId`, `siteId`, `dateCreated`, `dateUpdated`, `uid`, `field_technology_technologyName`, `field_technology_technologyUrl`, `field_technology_technologyImagePath`) VALUES 
	(1,58,1,'2017-05-13 22:28:19','2017-06-03 12:32:51','a7c9dbec-3b77-4f6b-9e52-ba28f7f7705a','Craft CMS','https://craftcms.com','/dist/images/technologies/craftcms.svg'),
	(2,59,1,'2017-05-13 22:28:19','2017-06-03 12:32:51','143fb372-4363-4c91-9604-bf57e576bf0c','Vue 2','http://vuejs.org/','/dist/images/technologies/vue.svg'),
	(3,60,1,'2017-05-13 22:28:19','2017-06-03 12:32:51','c77aa637-aac9-4500-b9ec-1d7d296a792d','Bulma','http://bulma.io','/dist/images/technologies/bulma.svg'),
	(4,61,1,'2017-05-13 22:28:19','2017-06-03 12:32:51','d47d1faa-1879-4559-b334-f56e4bc9e9bc','Webpack 2','https://webpack.github.io/','/dist/images/technologies/webpack.svg'),
	(5,62,1,'2017-05-13 22:28:19','2017-06-03 12:32:51','ded02d51-e79e-404e-9c39-59387552daf8','Gulp','http://gulpjs.com/','/dist/images/technologies/gulp.svg'),
	(6,63,1,'2017-05-13 22:28:19','2017-06-03 12:32:51','5906b64c-2ed5-4f3d-8b97-c282633689fc','Yarn','https://yarnpkg.com/en/','/dist/images/technologies/yarn.svg'),
	(7,64,1,'2017-05-13 22:42:03','2017-06-03 12:32:51','dabb823b-3657-4ea3-8a1d-599c72526138','Vultr','http://www.vultr.com/?ref=6960328','/dist/images/technologies/vultr.svg'),
	(8,65,1,'2017-05-13 22:42:03','2017-06-03 12:32:51','247f0fc2-7615-49e0-b7da-9e8fcbd2e55e','CloudFlare','https://www.cloudflare.com','/dist/images/technologies/cloudflare.svg'),
	(9,66,1,'2017-05-13 22:42:03','2017-06-03 12:32:51','276c5b4f-6602-4f30-8bd8-dc1991a3ded2','Forge','https://forge.laravel.com','/dist/images/technologies/forge.svg'),
	(10,80,1,'2017-05-24 07:25:01','2017-06-03 12:32:51','924d637c-5da9-4434-b8a8-8f1ea4ae5c16','YouTube','https://www.youtube.com','/dist/images/technologies/youtube.svg');
ALTER TABLE `cx_matrixcontent_technologies` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_plugins` WRITE;
ALTER TABLE `cx_plugins` DISABLE KEYS;
INSERT INTO `cx_plugins` (`id`, `handle`, `version`, `schemaVersion`, `licenseKey`, `licenseKeyStatus`, `enabled`, `settings`, `installDate`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(1,'doxter','3.1.3','3.0.0',NULL,'unknown',1,NULL,'2017-02-07 04:03:12','2017-02-07 04:03:12','2017-06-03 13:10:12','ecdf53eb-7e70-4cc1-b7f2-69b75c4dbc13'),
	(2,'swipe','1.0.0','1.0.0',NULL,'unknown',1,NULL,'2017-02-10 19:25:16','2017-02-10 19:25:16','2017-06-03 13:10:12','3954142a-2a74-431a-81c4-b16ef4e334cd'),
	(3,'awss3','1.0.3','1.0.0',NULL,'unknown',1,NULL,'2017-03-15 21:17:24','2017-03-15 21:17:24','2017-06-03 13:10:12','bcf8e73c-9daf-4f44-996a-fc972862a6d7'),
	(4,'hangouts','1.0.0','1.0.0',NULL,'unknown',1,NULL,'2017-04-26 02:40:54','2017-04-26 02:40:54','2017-06-03 13:10:12','40b875ed-96f0-4a85-8f25-ee05d54c27b5');
ALTER TABLE `cx_plugins` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_migrations` WRITE;
ALTER TABLE `cx_migrations` DISABLE KEYS;
INSERT INTO `cx_migrations` (`id`, `pluginId`, `type`, `name`, `applyTime`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
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
	(49,NULL,'app','m170217_044740_category_branch_limits','2017-02-17 23:50:03','2017-02-17 23:50:03','2017-02-17 23:50:03','35812039-5dba-4b46-87f1-0c1a1e82cff1'),
	(50,NULL,'app','m170223_224012_plain_text_settings','2017-02-25 02:52:37','2017-02-25 02:52:37','2017-02-25 02:52:37','9cb50189-75d0-483b-9970-bc03f9557fc0'),
	(51,NULL,'app','m170217_120224_asset_indexing_columns','2017-03-04 05:19:08','2017-03-04 05:19:08','2017-03-04 05:19:08','30a74c51-aec0-43bf-8f80-f7111e3fd9f1'),
	(52,NULL,'app','m170227_120814_focal_point_percentage','2017-03-04 05:19:08','2017-03-04 05:19:08','2017-03-04 05:19:08','6376d714-bacf-4b2d-ae7a-f0c0dd3062f0'),
	(53,NULL,'app','m170228_171113_system_messages','2017-03-04 05:19:09','2017-03-04 05:19:09','2017-03-04 05:19:09','8b2ee32f-f938-4d61-960a-c7b420c0c66f'),
	(54,NULL,'app','m170303_140500_asset_field_source_settings','2017-03-15 21:16:52','2017-03-15 21:16:52','2017-03-15 21:16:52','e5ba4a99-28fa-4193-bb5a-677dc4ed9075'),
	(55,NULL,'app','m170306_150500_asset_temporary_uploads','2017-03-15 21:16:52','2017-03-15 21:16:52','2017-03-15 21:16:52','7fe65679-9dc4-4eba-be37-a846aae43956'),
	(56,3,'plugin','Install','2017-03-15 21:17:24','2017-03-15 21:17:24','2017-03-15 21:17:24','71298a62-e849-4ba2-a433-97bacdc13690'),
	(57,NULL,'app','m170322_204706_element_field_layout_ids','2017-04-04 23:40:20','2017-04-04 23:40:20','2017-04-04 23:40:20','2b821458-0c0e-46f3-b9b9-cc5d944de321'),
	(58,NULL,'app','m170405_132309_element_field_layout_ids','2017-04-08 05:46:12','2017-04-08 05:46:12','2017-04-08 05:46:12','0ba675d8-0f57-45ea-9136-929c65a08c86'),
	(59,NULL,'app','m160707_000001_rename_richtext_assetsource_setting','2017-04-20 04:07:54','2017-04-20 04:07:54','2017-04-20 04:07:54','48de4a82-c1fd-473d-933a-df7a0c6bf0d6'),
	(60,NULL,'app','m170414_162429_rich_text_config_setting','2017-04-20 04:07:54','2017-04-20 04:07:54','2017-04-20 04:07:54','bb987437-806d-4b3b-9a3e-df92b45d7597'),
	(61,NULL,'app','m170523_190652_element_field_layout_ids','2017-06-03 10:58:11','2017-06-03 10:58:11','2017-06-03 10:58:11','2399d10f-e5b4-4ae1-bd54-13f97edf9725');
ALTER TABLE `cx_migrations` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_relations` WRITE;
ALTER TABLE `cx_relations` DISABLE KEYS;
INSERT INTO `cx_relations` (`id`, `fieldId`, `sourceId`, `sourceSiteId`, `targetId`, `sortOrder`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(387,69,67,NULL,76,1,'2017-05-22 04:23:21','2017-05-22 04:23:21','bc82566c-7b4f-45c0-a5d3-bf3a56a2dd4f'),
	(389,69,53,NULL,79,1,'2017-05-22 04:23:21','2017-05-22 04:23:21','06eb790c-8157-4dcc-af71-659bae0b4fd9'),
	(473,69,77,NULL,78,1,'2017-05-22 05:17:22','2017-05-22 05:17:22','d6f0cb05-70fb-413e-bf85-5bf53be39cd7'),
	(494,72,74,NULL,77,1,'2017-05-30 04:34:08','2017-05-30 04:34:08','a75c85cd-99f8-4151-8cde-3db29da66387'),
	(495,56,74,NULL,68,1,'2017-05-30 04:34:08','2017-05-30 04:34:08','2d5964a0-7a60-43f5-8a0d-d036e37fe89c'),
	(496,56,74,NULL,72,2,'2017-05-30 04:34:08','2017-05-30 04:34:08','11e6c642-1a9a-40ef-9604-c97f51a244e9'),
	(497,60,74,NULL,75,1,'2017-05-30 04:34:08','2017-05-30 04:34:08','1cc2cb62-854a-4065-bbaa-9795b5e30e89'),
	(502,72,52,NULL,53,1,'2017-05-30 04:34:08','2017-05-30 04:34:08','159c6814-5a61-4f0e-a8c7-680ea3cc0db1'),
	(503,56,52,NULL,51,1,'2017-05-30 04:34:08','2017-05-30 04:34:08','e878ea10-2bb4-45cd-ae82-0255e535063f'),
	(504,60,52,NULL,57,1,'2017-05-30 04:34:08','2017-05-30 04:34:08','b113f5bf-f1a3-46e4-abb4-d36d95867714'),
	(505,56,43,NULL,40,1,'2017-05-30 04:34:08','2017-05-30 04:34:08','837ac2ba-c433-464f-85d1-d73506c755b9'),
	(506,56,37,NULL,40,1,'2017-05-30 04:34:08','2017-05-30 04:34:08','63015020-e198-4f41-af6c-32eb93b0f658'),
	(507,56,29,NULL,39,1,'2017-05-30 04:34:08','2017-05-30 04:34:08','605a4503-ffc8-45bf-b508-8892018d3855'),
	(508,56,29,NULL,41,2,'2017-05-30 04:34:08','2017-05-30 04:34:08','58e84d2c-d846-4ba9-8d57-646bfe7f799a'),
	(509,56,28,NULL,39,1,'2017-05-30 04:34:08','2017-05-30 04:34:08','e5a17c02-0eac-47e1-9044-eec6fd0fb27a'),
	(515,69,84,NULL,83,1,'2017-06-01 23:43:45','2017-06-01 23:43:45','cc7dd3d4-4d6a-4a9d-83cc-1a701ba78003'),
	(532,72,82,NULL,84,1,'2017-06-02 00:46:56','2017-06-02 00:46:56','fa7bb5d5-b361-484c-88ef-485dae717e62'),
	(533,60,82,NULL,81,1,'2017-06-02 00:46:56','2017-06-02 00:46:56','77b3c10a-86d1-48d7-a572-8d11a9154d8a'),
	(534,72,69,NULL,67,1,'2017-06-02 00:54:15','2017-06-02 00:54:15','00cf864e-ec68-4990-8689-06db91d66b27'),
	(535,56,69,NULL,68,1,'2017-06-02 00:54:15','2017-06-02 00:54:15','8d48cb46-8699-4acf-b272-7c526f34c0e8'),
	(536,56,69,NULL,71,2,'2017-06-02 00:54:15','2017-06-02 00:54:15','a304b059-4042-47c3-b226-3bb6d5f8c746'),
	(537,60,69,NULL,70,1,'2017-06-02 00:54:15','2017-06-02 00:54:15','e9c8a2db-f44d-49af-9d6c-a61a794099d6');
ALTER TABLE `cx_relations` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_routes` WRITE;
ALTER TABLE `cx_routes` DISABLE KEYS;
ALTER TABLE `cx_routes` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_searchindex` WRITE;
ALTER TABLE `cx_searchindex` DISABLE KEYS;
INSERT INTO `cx_searchindex` (`elementId`, `attribute`, `fieldId`, `siteId`, `keywords`) VALUES 
	(57,'filename',0,1,' brandon kelly jpg '),
	(57,'extension',0,1,' jpg '),
	(57,'kind',0,1,' image '),
	(57,'slug',0,1,''),
	(57,'title',0,1,' brandon kelly '),
	(70,'filename',0,1,' wade anderson jpg '),
	(70,'extension',0,1,' jpg '),
	(70,'kind',0,1,' image '),
	(70,'slug',0,1,''),
	(70,'title',0,1,' wade anderson '),
	(75,'filename',0,1,' gary hockin jpg '),
	(75,'extension',0,1,' jpg '),
	(75,'kind',0,1,' image '),
	(75,'slug',0,1,''),
	(75,'title',0,1,' gary hockin '),
	(76,'filename',0,1,' wade anderson jpg '),
	(76,'extension',0,1,' jpg '),
	(76,'kind',0,1,' image '),
	(76,'slug',0,1,''),
	(76,'title',0,1,' wade anderson '),
	(78,'filename',0,1,' gary hockin jpg '),
	(78,'extension',0,1,' jpg '),
	(78,'kind',0,1,' image '),
	(78,'slug',0,1,''),
	(78,'title',0,1,' gary hockin '),
	(79,'filename',0,1,' brandon kelly jpg '),
	(79,'extension',0,1,' jpg '),
	(79,'kind',0,1,' image '),
	(79,'slug',0,1,''),
	(79,'title',0,1,' brandon kelly '),
	(81,'filename',0,1,' wes bos jpg '),
	(81,'extension',0,1,' jpg '),
	(81,'kind',0,1,' image '),
	(81,'slug',0,1,''),
	(81,'title',0,1,' wes bos '),
	(83,'filename',0,1,' wes bos jpg '),
	(83,'extension',0,1,' jpg '),
	(83,'kind',0,1,' image '),
	(83,'slug',0,1,''),
	(83,'title',0,1,' wes bos '),
	(39,'slug',0,1,' productivity '),
	(39,'title',0,1,' productivity '),
	(40,'slug',0,1,' freelancing '),
	(40,'title',0,1,' freelancing '),
	(41,'slug',0,1,' design '),
	(41,'title',0,1,' design '),
	(42,'slug',0,1,' development '),
	(42,'title',0,1,' development '),
	(51,'slug',0,1,' craft cms '),
	(51,'title',0,1,' craft cms '),
	(68,'slug',0,1,' editors '),
	(68,'title',0,1,' tools '),
	(71,'slug',0,1,' vs code '),
	(71,'title',0,1,' vs code '),
	(72,'slug',0,1,' phpstorm '),
	(72,'title',0,1,' phpstorm '),
	(2,'slug',0,1,' homepage '),
	(2,'title',0,1,' homepage '),
	(2,'field',32,1,' unofficial craft cms community '),
	(2,'field',33,1,' craftx is an open source website and a community building experiment '),
	(2,'field',28,1,' fa twitter follow us on twitter https twitter com craftxio unofficial craft cms community craftx is an open source website built on craft 3 and a friendly community of web professionals who care about their craft '),
	(2,'field',17,1,' dist images open source svg open source the source code for this entire website and its plugins is available on github we are friendly to first time contributors fa comments o latest hangouts hangouts dist images weekly hangouts svg lively hangouts join our lively hangouts where we talk about craft cms design freelancing and more eavesdropping allowed dist images developer spotlight svg developer spotlight tell us about your craft cms plugins projects articles and ideas we ll give them a place to shine and you the credit your deserve '),
	(2,'field',65,1,' dist images technologies craftcms svg craft cms https craftcms com dist images technologies vue svg vue 2 http vuejs org dist images technologies bulma svg bulma http bulma io dist images technologies webpack svg webpack 2 https webpack github io dist images technologies gulp svg gulp http gulpjs com dist images technologies yarn svg yarn https yarnpkg com en dist images technologies vultr svg vultr http www vultr com ref=6960328 dist images technologies cloudflare svg cloudflare https www cloudflare com dist images technologies forge svg forge https forge laravel com dist images technologies youtube svg youtube https www youtube com '),
	(28,'slug',0,1,' tools and workflows '),
	(28,'title',0,1,' tools and workflows '),
	(28,'field',72,1,''),
	(28,'field',56,1,' productivity '),
	(28,'field',60,1,''),
	(28,'field',40,1,''),
	(28,'field',73,1,''),
	(28,'field',44,1,' https zoom us j 961667767 '),
	(28,'field',41,1,' productivity automation tools and workflows are one of my favorite topics if youve got a favorite tool or workflow youd like to share or if youre interested in being part of the discussion please join us john morton will share interesting stats about cll and jalen davenport will get us started with a couple of demos of his favorite productivity tools '),
	(28,'field',42,1,' i had a good time on this hangout thank you to everyone that joined and a special thanks to john and jalen for sharing cool stuff here are the links to some of the tools we talked about http sipapp io awesome color picker http cmder net console emulator for windows https hyper is console emulator for mac iterm2 alternative https crema co where i get my coffee beans https github com lra mackup app settings sync https github com b4b4r07 enhancd cd on steroids https github com oh my fish oh my fish oh my zsh fork we discussed a few others but this is all i compiled i hope you can join the next craftx hangout '),
	(29,'slug',0,1,' design and productivity apps '),
	(29,'title',0,1,' design and productivity apps '),
	(29,'field',72,1,''),
	(29,'field',56,1,' productivity design '),
	(29,'field',60,1,''),
	(29,'field',40,1,''),
	(29,'field',73,1,''),
	(29,'field',44,1,' https zoom us j 279673275 '),
	(29,'field',41,1,' we pick up where we left off on the previous hangout with productivity tools but we also hope to explore design apps many of us focus most of our time on the frontend or backend but some of us do a little bit of everything including design work if youve been thinking about ditching adobe and checking out sketch affinity or another design tool this may be the hangout for you youre welcome to participate in the conversation or just sit back and listen as we ramble on '),
	(29,'field',42,1,' it was great to see bryan showcase his use of affinity designer for creating high fidelity mockups a showcase that brought on a deeper discussion about designing in the browser and nathaniel doing a demo of a framework theyve been developing at his agency for prototyping with reusable components their framework not yet open source is based on fractal by clearleft and there is an official blog post you can read to learn more about it as a rehabilitated adobe illustrator user who has become productive with sketch i was interested to see if affinity designer had any features or workflows that would make me want to jump ship i came out of the meeting feeling like i really needed to give it another try here is why affinity designer seems like a great sketch alternative unlimited undo windows and mac no subscription model ricing incredible zoom capabilities can open ai and psd files unified file format this list is not exhaustive and its not meant to offend sketch users like myself its just what i took away from our discussion one great thing about sketch that i didnt know is that is has a really nice sketch gulp plugin that you can use in your build process i thought this was really cool and im wondering if there is an equivalent for affinity designer we also touched lightly on frelancing but well get much deeper on that subject on the next hangout '),
	(32,'slug',0,1,' jalen davenport '),
	(32,'title',0,1,' jalen davenport '),
	(32,'field',69,1,''),
	(32,'field',45,1,' jalen '),
	(32,'field',46,1,' davenport '),
	(32,'field',70,1,''),
	(32,'field',71,1,''),
	(32,'field',52,1,' http dominion designs com '),
	(32,'field',53,1,' jalenconner '),
	(32,'field',55,1,''),
	(32,'field',54,1,''),
	(33,'slug',0,1,' john morton '),
	(33,'title',0,1,' john morton '),
	(33,'field',69,1,''),
	(33,'field',45,1,' john '),
	(33,'field',46,1,' morton '),
	(33,'field',70,1,''),
	(33,'field',71,1,''),
	(33,'field',52,1,' https jmx2 com '),
	(33,'field',53,1,' johnfmorton '),
	(33,'field',55,1,''),
	(33,'field',54,1,''),
	(34,'slug',0,1,' jalen davenport '),
	(34,'title',0,1,' bryan garrant '),
	(34,'field',69,1,''),
	(34,'field',45,1,' bryan '),
	(34,'field',46,1,' garrant '),
	(34,'field',70,1,''),
	(34,'field',71,1,''),
	(34,'field',52,1,' https www garrant com '),
	(34,'field',53,1,' bgarrant '),
	(34,'field',55,1,''),
	(34,'field',54,1,''),
	(35,'slug',0,1,' selvin ortiz '),
	(35,'title',0,1,' selvin ortiz '),
	(35,'field',69,1,''),
	(35,'field',45,1,' selvin '),
	(35,'field',46,1,' ortiz '),
	(35,'field',70,1,''),
	(35,'field',71,1,''),
	(35,'field',52,1,' https twitter com selvinortiz '),
	(35,'field',53,1,' selvinortiz '),
	(35,'field',55,1,' selvinortiz '),
	(35,'field',54,1,' selvinortiz '),
	(36,'slug',0,1,' nathaniel hammond '),
	(36,'title',0,1,' nathaniel hammond '),
	(36,'field',69,1,''),
	(36,'field',45,1,' nathaniel '),
	(36,'field',46,1,' hammond '),
	(36,'field',70,1,''),
	(36,'field',71,1,''),
	(36,'field',52,1,' http n43 me '),
	(36,'field',53,1,' nfourtythree '),
	(36,'field',55,1,''),
	(36,'field',54,1,''),
	(37,'slug',0,1,' getting better at the freelancing thing '),
	(37,'title',0,1,' getting better at the freelancing thing '),
	(37,'field',72,1,''),
	(37,'field',56,1,' freelancing '),
	(37,'field',60,1,''),
	(37,'field',40,1,''),
	(37,'field',73,1,''),
	(37,'field',44,1,' https zoom us j 289656504 '),
	(37,'field',41,1,' lets talk about the business side of being self employed and how we can get better at finding the right projects and the right clients to work with '),
	(37,'field',42,1,' in this hangout we heard from some freelancers and business owners on how they tackle networking client acquisition and balance that with onboarding automation and personal development networking networking is not just about who you know but who knows you and how to get yourself known by the people that matter going to a tech conference like peers can be great but if you only network with the people that do what you do you re not necessarily expanding your network to people you can do business with try going to events that have nothing to do with development to meet potential clients incentives to refer you consider giving out discount cards for say 20% and giving out another one for that person to give to someone else too selvin used to customise the business cards he gave out to go to a landing page specific to the event he was at remember to say no whether it s because you ve got too much work on or because the client isn t right or there are red flags remember to say no to projects that aren t right if the project is too small and you ve been wanting to do more work in a specific area consider turning down the project and spend that time instead learning a new technology or some way to improve yourself provided that you couldn t learn that new tech on the project being offered presenting yourself as a freelancer or a business we heard both sides of the argument for presenting yourself as a freelancer or as a business entity some prefer to sell themselves and their personality as the client hires them rather than a business but we also discussed how freelancer can be seen as unreliable or a potential weak point whichever stance you take be sure to own it and be certain about how you present yourself reliable income when it comes to income that isn t project based some alternative ideas to just exchanging time for dollars trading work for equity in the company particularly for startups side projects subscription based services commercial plugin development improving your business gui talked about how he reached out to people that were doing things well in branding presentation websites etc and met with them to discuss how they ran their businesses this not only helps to gain knowledge in how successful business are run but also makes a lot of connections ✏️ notes by daryl knight '),
	(38,'slug',0,1,' daryl knight '),
	(38,'title',0,1,' daryl knight '),
	(38,'field',69,1,''),
	(38,'field',45,1,' daryl '),
	(38,'field',46,1,' knight '),
	(38,'field',70,1,''),
	(38,'field',71,1,''),
	(38,'field',52,1,' http codeknight co uk '),
	(38,'field',53,1,' darylknight '),
	(38,'field',55,1,''),
	(38,'field',54,1,''),
	(43,'slug',0,1,' estimating and pricing web projects '),
	(43,'title',0,1,' estimating and pricing web projects '),
	(43,'field',72,1,''),
	(43,'field',56,1,' freelancing '),
	(43,'field',60,1,''),
	(43,'field',40,1,''),
	(43,'field',73,1,''),
	(43,'field',44,1,' https zoom us j 456325753 '),
	(43,'field',41,1,' on the heels of the last hangout weve decided to do a follow up on estimating and pricing '),
	(43,'field',42,1,' we went in depth on the techniques we use to estimate and price projects we also touched base on the sales funnel communication boundaries and a few other important topics the lack of context makes it hard to summarize what we learned and provide meaninful notes i think i can at least share some links that i collected from the chat and that were covered in the hangout from ben p https www stevepavlina com blog 2008 05 how to make accurate time estimates https www amazon com how measure anything intangibles business dp 1118539273 book 2 gets into some technical stuff but also has a good intro to calibrating your estimation technique and how to think about an estimates confidence interval from bryan g http blog teamtreehouse com calculate hourly freelance rates web design development work https www entrepreneur com article 271068 random https www youtube com user patrickbetdavid tidbits these are probably not as useful without proper context but i think they still provide a little nugget of wisdom if you cant accurately estimate how long something will take you cant accurately predict how much to charge for it if your budget is less than 5k and you re not used to using the term ongoing costs consider wix one of the biggest things for estimating is if you have a large project try to chop it up in to smaller chunks and estimate them individually figure out the hourly after that then add padding pricing an odd amount like 10 125 is 10% more likely to get accepted than 10 000 a large part of being able to seduce clients is confidence not only having good estimates but you need to be confident in your quote and be able to explain why its worth that we ve found a lot more success in selling a process and deliverables than pure hourly rates we break estimates in to two numbers the first is a wild guess the second is something we re willing to commit to which is usually a discovery phase and gives more knowledge about how to estimate the first number almost every project above 5k requires a more in depth discovery phase always be open to changing the scope but make sure you have laid down the pricing to go with those changes you cant price based on the client you need to price based on how much youre happy doing the work for to get better at estimating you need to be tracking everything you do if you have related links or resources that youd like to share or ideas for the next hangout drop me on note on slack or twitter '),
	(44,'slug',0,1,' ben parizek '),
	(44,'title',0,1,' ben parizek '),
	(44,'field',69,1,''),
	(44,'field',45,1,' ben '),
	(44,'field',46,1,' parizek '),
	(44,'field',70,1,''),
	(44,'field',71,1,''),
	(44,'field',52,1,' https barrelstrengthdesign com '),
	(44,'field',53,1,' benparizek '),
	(44,'field',55,1,''),
	(44,'field',54,1,''),
	(45,'slug',0,1,' gui rams '),
	(45,'title',0,1,' gui rams '),
	(45,'field',69,1,''),
	(45,'field',45,1,' gui '),
	(45,'field',46,1,' rams '),
	(45,'field',70,1,''),
	(45,'field',71,1,''),
	(45,'field',52,1,' https github com gui gui '),
	(45,'field',53,1,''),
	(45,'field',55,1,''),
	(45,'field',54,1,''),
	(52,'slug',0,1,' craft 3 plugin store '),
	(52,'title',0,1,' craft 3 plugin store '),
	(52,'field',72,1,' brandon kelly '),
	(52,'field',56,1,' craft cms '),
	(52,'field',60,1,' brandon kelly '),
	(52,'field',40,1,''),
	(52,'field',73,1,''),
	(52,'field',44,1,' https zoom us j 699830106 '),
	(52,'field',41,1,' initial plans for the craft 3 plugin store were announced yesterday and the news have generated mixed reactions brandon is joining us to talk about it in more detail '),
	(52,'field',42,1,' we were joined by brandon leslie brad and luke from pixel tonic to talk about the plugin store in more detail and to get a better understanding of the pricing model that they are proposing below is a recording of the meeting raw and uncut chat transcript was recorded along in real time ill try to add notes as they become available tl dr by matt stein my tl dr was that we should be using composer and we should be building ongoing support into web projects and not passing off unplanned support or technical debt to sink pt were all discussing this because pt isnt making room for stale unsupported plugins in its plans for the store you can also find the mp3 shared in dropbox '),
	(53,'slug',0,1,' brandon kelly '),
	(53,'title',0,1,' brandon kelly '),
	(53,'field',69,1,' brandon kelly '),
	(53,'field',45,1,' brandon '),
	(53,'field',46,1,' kelly '),
	(53,'field',70,1,' founder and ceo '),
	(53,'field',71,1,' pixel tonic '),
	(53,'field',52,1,' https twitter com brandonkelly '),
	(53,'field',53,1,' brandonkelly '),
	(53,'field',55,1,' brandonkelly '),
	(53,'field',54,1,' brandonkelly '),
	(67,'slug',0,1,' wade anderson '),
	(67,'title',0,1,' wade anderson '),
	(67,'field',69,1,' wade anderson '),
	(67,'field',45,1,' wade '),
	(67,'field',46,1,' anderson '),
	(67,'field',70,1,' product manager '),
	(67,'field',71,1,' microsoft '),
	(67,'field',52,1,' https medium com waderyan_ '),
	(67,'field',53,1,''),
	(67,'field',55,1,' waderyan '),
	(67,'field',54,1,' waderyan_ '),
	(69,'slug',0,1,' the case for vs code '),
	(69,'title',0,1,' the case for vs code '),
	(69,'field',72,1,' wade anderson '),
	(69,'field',56,1,' tools vs code '),
	(69,'field',60,1,' wade anderson '),
	(69,'field',40,1,''),
	(69,'field',73,1,' w8zexocox7k '),
	(69,'field',44,1,' https zoom us j 195404140 '),
	(69,'field',41,1,' vs code is a powerful code editor if you havent tried it well let wade anderson tell you why you should he is a product manger at microsoft and works on vs code he is also a great communicator and presenter im really excited to have him on the show below are a couple of his talks if youd like to get up to speed on vs code dont forget to add this hangout to your calendar vs code tips and tricks vs code last editor youll ever need '),
	(69,'field',42,1,''),
	(74,'slug',0,1,' taking php and craft by storm '),
	(74,'title',0,1,' taking php craft by storm '),
	(74,'field',72,1,' gary hockin '),
	(74,'field',56,1,' tools phpstorm '),
	(74,'field',60,1,' gary hockin '),
	(74,'field',40,1,''),
	(74,'field',73,1,''),
	(74,'field',44,1,' https zoom us j 304873613 '),
	(74,'field',41,1,' gary hockin is a developer advocate for phpstorm at jetbrains and a prolific technical writer and educator he will be joining us to talk about how phpstorm can help us speed up our php and craft cms development workflow check out the videos below to learn more about gary and tweet geeh letting him know youre looking forward to this hangout interviewing gary hockin from jetbrains whats new in phpstorm 2017 1 '),
	(74,'field',42,1,''),
	(77,'slug',0,1,' gary hockin '),
	(77,'title',0,1,' gary hockin '),
	(77,'field',69,1,' gary hockin '),
	(77,'field',45,1,' gary '),
	(77,'field',46,1,' hockin '),
	(77,'field',70,1,' developer advocate for phpstorm '),
	(77,'field',71,1,' jetbrains '),
	(77,'field',52,1,' https blog hock in '),
	(77,'field',53,1,''),
	(77,'field',55,1,' geeh '),
	(77,'field',54,1,' geeh '),
	(82,'slug',0,1,' learning and teaching web technologies '),
	(82,'title',0,1,' learning and teaching web technologies '),
	(82,'field',72,1,' wes bos '),
	(82,'field',56,1,''),
	(82,'field',60,1,' wes bos '),
	(82,'field',40,1,''),
	(82,'field',73,1,' rip6riydf7u '),
	(82,'field',44,1,' https zoom us j 526300477 '),
	(82,'field',41,1,' wes bos is at the forefront of web technologies he is one of the most well liked instructors and conference speakers wes is also a hugely productive educational content creator and very good at marketing his products on this hangout i hope to learn more about how he stays on top of javascript html5 css3 the tools he uses in his workflow and how he approaches learning and teaching about the web if you arent familiar with wes and his work unlikely check out a couple of the videos below modern workflow and tooling start using es6 today free courses by wes https javascript30 com https masteringmarkdown com '),
	(82,'field',42,1,''),
	(84,'slug',0,1,' wes bos '),
	(84,'title',0,1,' wes bos '),
	(84,'field',69,1,' wes bos '),
	(84,'field',45,1,' wes '),
	(84,'field',46,1,' bos '),
	(84,'field',70,1,' designer developer entrepreneur '),
	(84,'field',71,1,' hackeryou wesbos com '),
	(84,'field',52,1,' http wesbos com '),
	(84,'field',53,1,''),
	(84,'field',55,1,' wesbos '),
	(84,'field',54,1,' wesbos '),
	(50,'slug',0,1,''),
	(50,'field',3,1,''),
	(4,'slug',0,1,''),
	(4,'field',29,1,' unofficial craft cms community '),
	(4,'field',30,1,' craftx is an open source website built on craft 3 and a friendly community of web professionals who care about their craft '),
	(4,'field',31,1,' follow us on twitter '),
	(4,'field',57,1,' https twitter com craftxio '),
	(4,'field',61,1,' fa twitter '),
	(5,'slug',0,1,''),
	(5,'field',18,1,' open source '),
	(5,'field',19,1,' the source code for this entire website and its plugins is available on github we are friendly to first time contributors '),
	(5,'field',58,1,' dist images open source svg '),
	(5,'field',62,1,''),
	(5,'field',63,1,''),
	(5,'field',64,1,''),
	(6,'slug',0,1,''),
	(6,'field',18,1,' lively hangouts '),
	(6,'field',19,1,' join our lively hangouts where we talk about craft cms design freelancing and more eavesdropping allowed '),
	(6,'field',58,1,' dist images weekly hangouts svg '),
	(6,'field',62,1,' latest hangouts '),
	(6,'field',63,1,' hangouts '),
	(6,'field',64,1,' fa comments o '),
	(7,'slug',0,1,''),
	(7,'field',18,1,' developer spotlight '),
	(7,'field',19,1,' tell us about your craft cms plugins projects articles and ideas we ll give them a place to shine and you the credit your deserve '),
	(7,'field',58,1,' dist images developer spotlight svg '),
	(7,'field',62,1,''),
	(7,'field',63,1,''),
	(7,'field',64,1,''),
	(58,'slug',0,1,''),
	(58,'field',66,1,' craft cms '),
	(58,'field',67,1,' https craftcms com '),
	(58,'field',68,1,' dist images technologies craftcms svg '),
	(59,'slug',0,1,''),
	(59,'field',66,1,' vue 2 '),
	(59,'field',67,1,' http vuejs org '),
	(59,'field',68,1,' dist images technologies vue svg '),
	(60,'slug',0,1,''),
	(60,'field',66,1,' bulma '),
	(60,'field',67,1,' http bulma io '),
	(60,'field',68,1,' dist images technologies bulma svg '),
	(61,'slug',0,1,''),
	(61,'field',66,1,' webpack 2 '),
	(61,'field',67,1,' https webpack github io '),
	(61,'field',68,1,' dist images technologies webpack svg '),
	(62,'slug',0,1,''),
	(62,'field',66,1,' gulp '),
	(62,'field',67,1,' http gulpjs com '),
	(62,'field',68,1,' dist images technologies gulp svg '),
	(63,'slug',0,1,''),
	(63,'field',66,1,' yarn '),
	(63,'field',67,1,' https yarnpkg com en '),
	(63,'field',68,1,' dist images technologies yarn svg '),
	(64,'slug',0,1,''),
	(64,'field',66,1,' vultr '),
	(64,'field',67,1,' http www vultr com ref=6960328 '),
	(64,'field',68,1,' dist images technologies vultr svg '),
	(65,'slug',0,1,''),
	(65,'field',66,1,' cloudflare '),
	(65,'field',67,1,' https www cloudflare com '),
	(65,'field',68,1,' dist images technologies cloudflare svg '),
	(66,'slug',0,1,''),
	(66,'field',66,1,' forge '),
	(66,'field',67,1,' https forge laravel com '),
	(66,'field',68,1,' dist images technologies forge svg '),
	(80,'slug',0,1,''),
	(80,'field',66,1,' youtube '),
	(80,'field',67,1,' https www youtube com '),
	(80,'field',68,1,' dist images technologies youtube svg '),
	(1,'username',0,1,' craftx '),
	(1,'firstname',0,1,' craftx '),
	(1,'lastname',0,1,''),
	(1,'fullname',0,1,' craftx '),
	(1,'email',0,1,' support craftx io '),
	(1,'slug',0,1,'');
ALTER TABLE `cx_searchindex` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_sections` WRITE;
ALTER TABLE `cx_sections` DISABLE KEYS;
INSERT INTO `cx_sections` (`id`, `structureId`, `name`, `handle`, `type`, `enableVersioning`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(1,NULL,'Homepage','homepage','single',0,'2017-02-06 18:57:45','2017-02-06 18:57:45','6f4ca3af-f6ea-4aa0-b25c-1a697f0225f1'),
	(5,NULL,'Hangouts','hangouts','channel',0,'2017-04-23 21:07:18','2017-04-23 21:07:18','146aa555-2a51-423b-b841-3cac0060721e'),
	(6,NULL,'People','people','channel',0,'2017-04-27 20:44:56','2017-04-27 21:03:14','3bb733ca-c2f7-4340-9720-f2df7804053a');
ALTER TABLE `cx_sections` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_sections_i18n` WRITE;
ALTER TABLE `cx_sections_i18n` DISABLE KEYS;
INSERT INTO `cx_sections_i18n` (`id`, `sectionId`, `siteId`, `enabledByDefault`, `hasUrls`, `uriFormat`, `template`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(1,1,1,1,1,'__home__','index','2017-02-06 18:57:45','2017-02-06 23:59:44','7544fcbf-9302-4044-b213-89fa766f1286'),
	(5,5,1,0,1,'hangouts/{slug}','hangouts/_entry','2017-04-23 21:07:18','2017-04-23 21:07:18','57ca3a20-9c4d-4fff-872e-d4201363e545'),
	(6,6,1,1,0,NULL,NULL,'2017-04-27 20:44:56','2017-04-27 21:03:14','0db9b1dc-4712-4778-b52b-1c554f08259b');
ALTER TABLE `cx_sections_i18n` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_sessions` WRITE;
ALTER TABLE `cx_sessions` DISABLE KEYS;
INSERT INTO `cx_sessions` (`id`, `userId`, `token`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(15,1,'q-GMYVxiSeH5YR5Kt7PoCtP-QAyduBYr1yJ3sg_KzatQeaqWC6bSgzbUjuescu3JFsEPvO1WPEbhdGCD1eUrFkkYp8ENsz2LMeSL','2017-05-16 16:53:12','2017-05-16 16:53:47','9438c21c-e779-4f4f-ad04-a43e2032e6fd'),
	(16,1,'LkWie17UhrOIiqWaCn9VApOS2xVjQxpuE8wBy44iDSnfABYLD0cAf7a9p5wq126Im7gGGHS_wCPa_Osg8xbVzLU5sDqdt8K_HjJP','2017-05-16 17:12:07','2017-05-16 17:12:08','9f19f87e-8652-43d3-9b5f-f8844736598c'),
	(17,1,'cAHo6WzHv5MNkcyDXS_SF6x0GaVpW0Aw2iXAG2N_2wpG9Xl2U3oAi4msf-fzYkVafiBKIPE414cwpR2C556JRdDWfewwueKGi0Oe','2017-05-16 19:38:49','2017-05-16 19:47:29','44734796-2243-4fa2-801c-2d24227b0baa');
ALTER TABLE `cx_sessions` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_shunnedmessages` WRITE;
ALTER TABLE `cx_shunnedmessages` DISABLE KEYS;
ALTER TABLE `cx_shunnedmessages` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_sites` WRITE;
ALTER TABLE `cx_sites` DISABLE KEYS;
INSERT INTO `cx_sites` (`id`, `name`, `handle`, `language`, `hasUrls`, `baseUrl`, `sortOrder`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(1,'CraftX','default','en-US',1,'http://{siteUrl}',1,'2017-02-06 18:39:45','2017-03-06 07:16:08','2919439f-9a4e-4fee-aa13-334959abcfe0');
ALTER TABLE `cx_sites` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_structures` WRITE;
ALTER TABLE `cx_structures` DISABLE KEYS;
INSERT INTO `cx_structures` (`id`, `maxLevels`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(2,NULL,'2017-04-28 20:02:13','2017-04-28 20:02:13','4feabcf1-416a-4b89-8bd1-30e5a8081337');
ALTER TABLE `cx_structures` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_structureelements` WRITE;
ALTER TABLE `cx_structureelements` DISABLE KEYS;
INSERT INTO `cx_structureelements` (`id`, `structureId`, `elementId`, `root`, `lft`, `rgt`, `level`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(6,2,NULL,6,1,18,0,'2017-04-28 20:02:32','2017-05-19 12:33:53','18e051f4-df2e-4f2c-9772-200b898c971f'),
	(7,2,39,6,2,3,1,'2017-04-28 20:02:32','2017-04-28 20:02:32','7d0b9082-f0f4-4660-a558-186fb93930cc'),
	(8,2,40,6,4,5,1,'2017-04-28 20:02:45','2017-04-28 20:02:45','b967ce6c-cd31-4feb-8c9f-22b88277624d'),
	(9,2,41,6,6,7,1,'2017-04-28 20:05:02','2017-04-28 20:05:02','72b394b2-59ec-4446-b139-f5c9baa5a541'),
	(10,2,42,6,8,9,1,'2017-04-28 20:05:13','2017-04-28 20:05:13','15b28533-dbd6-4ddd-9b12-1ab8cd5f524c'),
	(13,2,51,6,10,11,1,'2017-05-11 15:48:44','2017-05-11 15:48:44','f2ecfddb-1b7f-4e55-b49c-4e2266ce61c4'),
	(14,2,68,6,12,13,1,'2017-05-16 02:13:47','2017-05-16 02:13:47','06180f71-4e1c-4fb1-9157-17204e99dc03'),
	(15,2,71,6,14,15,1,'2017-05-16 16:53:38','2017-05-16 16:53:38','88fcffc7-89dc-4a62-9383-565c81860e82'),
	(16,2,72,6,16,17,1,'2017-05-19 12:33:53','2017-05-19 12:33:53','6088a174-0b42-4107-9af5-b43465db7032');
ALTER TABLE `cx_structureelements` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_systemmessages` WRITE;
ALTER TABLE `cx_systemmessages` DISABLE KEYS;
INSERT INTO `cx_systemmessages` (`id`, `language`, `key`, `subject`, `body`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(1,'en-US','test_email','Email Settings','Hi, this email confirms that your settings are properly set up.','2017-03-03 07:40:19','2017-03-03 07:40:19','45ba3fbf-869b-4e9d-af83-b1a4297a3a2f'),
	(2,'en-US','verify_new_email','Verify your new email address','{{link}}','2017-03-06 20:39:55','2017-03-06 20:39:55','e89d5ad6-99e6-4d82-8dbf-f9f3f0b5f4eb');
ALTER TABLE `cx_systemmessages` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_systemsettings` WRITE;
ALTER TABLE `cx_systemsettings` DISABLE KEYS;
INSERT INTO `cx_systemsettings` (`id`, `category`, `settings`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(1,'email','{"fromEmail":"support@craftx.io","fromName":"CraftX","template":"_special/email","transportType":"craft\\\\mail\\\\transportadapters\\\\Smtp","transportSettings":{"host":"hidden.host","port":"587","useAuthentication":"1","username":"hidden","password":"secret","encryptionMethod":"tls","timeout":"30"}}','2017-02-06 18:39:45','2017-06-03 13:04:36','4525a971-81ae-42b5-9d4a-5acf34858293'),
	(2,'mailer','{"class":"craft\\\\mail\\\\Mailer","from":{"selvin@craftx.io":"Craft X"},"transport":{"class":"Swift_MailTransport"}}','2017-02-06 18:39:45','2017-02-06 18:39:45','b7448476-6236-46f1-ad36-f0992fc3f5bc'),
	(3,'users','{"requireEmailVerification":true,"allowPublicRegistration":true,"defaultGroup":"2","photoVolumeId":null}','2017-02-13 06:23:39','2017-03-03 07:32:21','4c6b2690-22ed-4939-9129-bb876eb7be07');
ALTER TABLE `cx_systemsettings` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_taggroups` WRITE;
ALTER TABLE `cx_taggroups` DISABLE KEYS;
ALTER TABLE `cx_taggroups` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_tags` WRITE;
ALTER TABLE `cx_tags` DISABLE KEYS;
ALTER TABLE `cx_tags` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_tasks` WRITE;
ALTER TABLE `cx_tasks` DISABLE KEYS;
ALTER TABLE `cx_tasks` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_templatecaches` WRITE;
ALTER TABLE `cx_templatecaches` DISABLE KEYS;
ALTER TABLE `cx_templatecaches` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_templatecacheelements` WRITE;
ALTER TABLE `cx_templatecacheelements` DISABLE KEYS;
ALTER TABLE `cx_templatecacheelements` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_templatecachequeries` WRITE;
ALTER TABLE `cx_templatecachequeries` DISABLE KEYS;
ALTER TABLE `cx_templatecachequeries` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_tokens` WRITE;
ALTER TABLE `cx_tokens` DISABLE KEYS;
INSERT INTO `cx_tokens` (`id`, `token`, `route`, `usageLimit`, `usageCount`, `expiryDate`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(11,'aKlYGOw3tk8LzG0LM_zhlOsWWhlG58M8','["entries/view-shared-entry",{"entryId":82,"siteId":1}]',NULL,NULL,'2017-06-02 23:45:54','2017-06-01 23:45:54','2017-06-01 23:45:54','5f7b341f-1f40-4ae9-957e-415591fb2e46');
ALTER TABLE `cx_tokens` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_usergroups` WRITE;
ALTER TABLE `cx_usergroups` DISABLE KEYS;
ALTER TABLE `cx_usergroups` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_usergroups_users` WRITE;
ALTER TABLE `cx_usergroups_users` DISABLE KEYS;
ALTER TABLE `cx_usergroups_users` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_userpermissions` WRITE;
ALTER TABLE `cx_userpermissions` DISABLE KEYS;
INSERT INTO `cx_userpermissions` (`id`, `name`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(1,'accesssitewhensystemisoff','2017-05-02 20:43:49','2017-05-02 20:43:49','e3baab6b-e2ff-474d-90e3-75760f056dd3'),
	(2,'accesscpwhensystemisoff','2017-05-02 20:43:49','2017-05-02 20:43:49','fa7b3e22-ea1e-4e74-ab97-bb6821ad9106'),
	(3,'performupdates','2017-05-02 20:43:49','2017-05-02 20:43:49','81eaabe5-c3fb-4305-a6cd-19674a995523'),
	(4,'accessplugin-swipe','2017-05-02 20:43:49','2017-05-02 20:43:49','38fbb48b-c322-4f74-aee8-ddab9860b49d'),
	(5,'accesscp','2017-05-02 20:43:49','2017-05-02 20:43:49','5e56f960-0905-4542-9a32-14260e54e260'),
	(6,'createentries:4','2017-05-02 20:43:49','2017-05-02 20:43:49','ecb09455-8e60-4945-bb91-2f3b59170c79'),
	(7,'publishentries:4','2017-05-02 20:43:49','2017-05-02 20:43:49','ea7e3951-ee18-4cbf-b0f9-4c3e821c00e2'),
	(8,'deleteentries:4','2017-05-02 20:43:49','2017-05-02 20:43:49','412dc8b4-b2bc-4f50-83c0-1af38234daff'),
	(9,'publishpeerentries:4','2017-05-02 20:43:49','2017-05-02 20:43:49','7a7d1c74-2a76-413f-bece-90e859cb3367'),
	(10,'deletepeerentries:4','2017-05-02 20:43:49','2017-05-02 20:43:49','891cdae5-5236-4dbc-b583-d37e65705682'),
	(11,'editpeerentries:4','2017-05-02 20:43:49','2017-05-02 20:43:49','2f2c608e-5867-466e-9783-9417c2600174'),
	(12,'publishpeerentrydrafts:4','2017-05-02 20:43:49','2017-05-02 20:43:49','77d14f50-79f6-4dd4-8444-72533506555f'),
	(13,'deletepeerentrydrafts:4','2017-05-02 20:43:49','2017-05-02 20:43:49','b7d1d79d-4035-46e7-bbe4-7b95be047486'),
	(14,'editpeerentrydrafts:4','2017-05-02 20:43:49','2017-05-02 20:43:49','cf7d5d4d-cc60-4098-a3c2-4e3e098ca498'),
	(15,'editentries:4','2017-05-02 20:43:49','2017-05-02 20:43:49','4ca50644-f893-40e8-8eb4-5f8d70277265'),
	(16,'createentries:5','2017-05-02 20:43:49','2017-05-02 20:43:49','ce0f05da-d083-4195-9542-0be1b5cfdeb0'),
	(17,'publishentries:5','2017-05-02 20:43:49','2017-05-02 20:43:49','a9614a2e-3fe9-4b16-8005-acdbc36d8913'),
	(18,'deleteentries:5','2017-05-02 20:43:49','2017-05-02 20:43:49','8c004aea-16d3-4152-90dc-359e2c7ba5f8'),
	(19,'publishpeerentries:5','2017-05-02 20:43:49','2017-05-02 20:43:49','b64f0ac0-05dd-4090-95cd-08a82857924f'),
	(20,'deletepeerentries:5','2017-05-02 20:43:49','2017-05-02 20:43:49','23a60d63-6e56-4381-83e1-1664392da1c4'),
	(21,'editpeerentries:5','2017-05-02 20:43:49','2017-05-02 20:43:49','5fa703d4-0a36-4303-9885-27e848530963'),
	(22,'publishpeerentrydrafts:5','2017-05-02 20:43:49','2017-05-02 20:43:49','47eca52a-593f-447d-816b-d862ba395fb8'),
	(23,'deletepeerentrydrafts:5','2017-05-02 20:43:49','2017-05-02 20:43:49','75a3107a-e0e7-46ac-a08d-4c891418f01c'),
	(24,'editpeerentrydrafts:5','2017-05-02 20:43:49','2017-05-02 20:43:49','9258f8c7-c8cd-4a87-b6d5-c8faad7ba226'),
	(25,'editentries:5','2017-05-02 20:43:49','2017-05-02 20:43:49','4407ff27-0ca2-4530-b4ef-a6fef11aa666'),
	(26,'publishentries:1','2017-05-02 20:43:49','2017-05-02 20:43:49','6bebbf5a-0224-47c9-a198-982a4f050c50'),
	(27,'publishpeerentrydrafts:1','2017-05-02 20:43:49','2017-05-02 20:43:49','cf890c64-386d-464d-af07-e2e2480ce8c3'),
	(28,'deletepeerentrydrafts:1','2017-05-02 20:43:49','2017-05-02 20:43:49','056cda54-56cb-433f-8e2d-5cc071c1ae2b'),
	(29,'editpeerentrydrafts:1','2017-05-02 20:43:49','2017-05-02 20:43:49','ea0d9025-e2f6-4bf1-9e3c-4b74ac1be400'),
	(30,'editentries:1','2017-05-02 20:43:49','2017-05-02 20:43:49','86f4abda-f18d-4b79-8db2-19b6d5b6bb19'),
	(31,'createentries:6','2017-05-02 20:43:49','2017-05-02 20:43:49','230b2c73-8db4-413a-8962-ad44323a5c5f'),
	(32,'publishentries:6','2017-05-02 20:43:49','2017-05-02 20:43:49','3741b8e7-a9ab-4957-bccf-d9931856c977'),
	(33,'deleteentries:6','2017-05-02 20:43:49','2017-05-02 20:43:49','e58d6746-2825-4a91-84b5-9736d55df6d8'),
	(34,'publishpeerentries:6','2017-05-02 20:43:49','2017-05-02 20:43:49','c83bc0a8-ad3a-49a0-902f-920555028a54'),
	(35,'deletepeerentries:6','2017-05-02 20:43:49','2017-05-02 20:43:49','6668948b-f113-4d33-981c-0b29615988c7'),
	(36,'editpeerentries:6','2017-05-02 20:43:49','2017-05-02 20:43:49','8c88aae8-862d-4c9d-8fcb-27b7db7d7eb8'),
	(37,'publishpeerentrydrafts:6','2017-05-02 20:43:49','2017-05-02 20:43:49','71a834f2-b6d4-458d-9522-8ad04511edee'),
	(38,'deletepeerentrydrafts:6','2017-05-02 20:43:49','2017-05-02 20:43:49','5a228042-bb87-4511-8dec-0e3f7f21fe27'),
	(39,'editpeerentrydrafts:6','2017-05-02 20:43:49','2017-05-02 20:43:49','9a9406d3-7c7a-4f25-929a-63700db862b6'),
	(40,'editentries:6','2017-05-02 20:43:49','2017-05-02 20:43:49','8125f3ef-5328-4a62-859e-cfb02c5ff31c'),
	(41,'editcategories:1','2017-05-02 20:43:49','2017-05-02 20:43:49','078f25a2-ec17-452e-9a78-0191ca8feba6'),
	(42,'saveassetinvolume:1','2017-05-02 20:43:49','2017-05-02 20:43:49','5139e6ce-9e16-44e1-8d7e-1bd6dbc18167'),
	(43,'createfoldersinvolume:1','2017-05-02 20:43:49','2017-05-02 20:43:49','a5e4b192-f6cc-4921-9060-ec699f446b3d'),
	(44,'deletefilesandfoldersinvolume:1','2017-05-02 20:43:49','2017-05-02 20:43:49','f794abcd-9bbd-4974-a258-e6668004325b'),
	(45,'viewvolume:1','2017-05-02 20:43:49','2017-05-02 20:43:49','9627c230-0030-43c3-8c9b-33e1a2e7e5ba'),
	(46,'utility:search-indexes','2017-05-02 20:43:49','2017-05-02 20:43:49','493565fd-de90-4cee-9aed-2d4ce62794e7'),
	(47,'utility:asset-indexes','2017-05-02 20:43:49','2017-05-02 20:43:49','23d93af3-dea1-4436-b2b0-1ff5d9b79af9'),
	(48,'utility:clear-caches','2017-05-02 20:43:49','2017-05-02 20:43:49','4db5e3dd-ac3f-4c51-9233-59db666469bb'),
	(49,'utility:db-backup','2017-05-02 20:43:49','2017-05-02 20:43:49','b7a603de-0726-4879-8ad6-05a7f69c20b8');
ALTER TABLE `cx_userpermissions` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_userpermissions_usergroups` WRITE;
ALTER TABLE `cx_userpermissions_usergroups` DISABLE KEYS;
ALTER TABLE `cx_userpermissions_usergroups` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_users` WRITE;
ALTER TABLE `cx_users` DISABLE KEYS;
INSERT INTO `cx_users` (`id`, `username`, `photoId`, `firstName`, `lastName`, `email`, `password`, `admin`, `client`, `locked`, `suspended`, `pending`, `archived`, `lastLoginDate`, `lastLoginAttemptIp`, `invalidLoginWindowStart`, `invalidLoginCount`, `lastInvalidLoginDate`, `lockoutDate`, `verificationCode`, `verificationCodeIssuedDate`, `unverifiedEmail`, `passwordResetRequired`, `lastPasswordChangeDate`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(1,'craftx',NULL,'CraftX','','support@craftx.io','$2y$13$JV1Ecmc/hN9vc2GsYO5sEOYkDvRaSlWEquP.94ERadU.8hgLG2Zxe',1,0,0,0,0,0,'2017-06-03 12:56:18','192.168.10.1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'2017-06-03 12:58:46','2017-02-06 18:39:45','2017-06-03 12:58:46','6dd21ec5-be58-47c4-9c4e-4f04346dd128');
ALTER TABLE `cx_users` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_userpermissions_users` WRITE;
ALTER TABLE `cx_userpermissions_users` DISABLE KEYS;
ALTER TABLE `cx_userpermissions_users` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_userpreferences` WRITE;
ALTER TABLE `cx_userpreferences` DISABLE KEYS;
INSERT INTO `cx_userpreferences` (`userId`, `preferences`) VALUES 
	(1,'{"language":null,"weekStartDay":"0","enableDebugToolbarForSite":true,"enableDebugToolbarForCp":true}');
ALTER TABLE `cx_userpreferences` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_volumes` WRITE;
ALTER TABLE `cx_volumes` DISABLE KEYS;
INSERT INTO `cx_volumes` (`id`, `fieldLayoutId`, `name`, `handle`, `type`, `hasUrls`, `url`, `settings`, `sortOrder`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(3,33,'Hangouts','hangouts','craft\\volumes\\Local',1,'/assets/hangouts','{"path":"assets/hangouts"}',3,'2017-05-12 04:42:11','2017-05-12 18:03:45','ddec9121-353a-40a2-a5d5-921a29e2a8b6'),
	(4,35,'People','people','craft\\volumes\\Local',1,'https://craftx.io/assets/people/','{"path":"/home/forge/craftx.io/web/assets/people"}',4,'2017-05-22 03:39:15','2017-05-22 03:39:15','be0d9a8f-a6a0-4f36-b1c2-c831be23441c');
ALTER TABLE `cx_volumes` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_volumefolders` WRITE;
ALTER TABLE `cx_volumefolders` DISABLE KEYS;
INSERT INTO `cx_volumefolders` (`id`, `parentId`, `volumeId`, `name`, `path`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(2,NULL,NULL,'Temporary source',NULL,'2017-04-04 23:41:58','2017-04-04 23:41:58','f3445fd1-5b7b-4a4a-898c-89de6dc7c910'),
	(3,2,NULL,'user_1','user_1/','2017-04-04 23:41:58','2017-04-04 23:41:58','6d69743c-4e55-43cf-a360-d3997f21151d'),
	(24,NULL,3,'Hangouts','','2017-05-12 04:42:11','2017-05-12 04:42:11','88dc5a30-7502-4932-9583-0557d15a5e7c'),
	(27,24,3,'images','images/','2017-05-12 16:55:49','2017-05-12 16:55:49','0c0805b7-5f7e-4ff8-84cb-90ada4af4875'),
	(28,NULL,4,'People','','2017-05-22 03:39:15','2017-05-22 03:39:15','aaf01265-8269-4c25-917e-e8ebcc09b8d7');
ALTER TABLE `cx_volumefolders` ENABLE KEYS;
UNLOCK TABLES;


LOCK TABLES `cx_widgets` WRITE;
ALTER TABLE `cx_widgets` DISABLE KEYS;
INSERT INTO `cx_widgets` (`id`, `userId`, `type`, `sortOrder`, `colspan`, `settings`, `enabled`, `dateCreated`, `dateUpdated`, `uid`) VALUES 
	(1,1,'craft\\widgets\\RecentEntries',2,1,'{"section":"5","siteId":"1","limit":"10"}',1,'2017-02-06 18:47:24','2017-05-03 12:06:10','936f422c-de0f-4856-ba85-c3d2f1910316'),
	(2,1,'craft\\widgets\\CraftSupport',NULL,0,'[]',0,'2017-02-06 18:47:24','2017-05-03 12:03:34','5cbb24e0-1200-4fd4-9a22-a6d0ff6ed0c6'),
	(3,1,'craft\\widgets\\Updates',NULL,0,'[]',0,'2017-02-06 18:47:24','2017-05-03 12:03:44','d2e06d28-8b9e-42a1-b121-43f96de01209'),
	(4,1,'craft\\widgets\\Feed',3,0,'{"url":"https://craftcms.com/news.rss","title":"Craft News","limit":5}',1,'2017-02-06 18:47:24','2017-05-03 12:04:49','54331635-6276-4083-9291-a51b5adbf160'),
	(5,1,'craft\\widgets\\QuickPost',1,2,'{"section":"5","entryType":"","fields":["72","56","60","40","73","44","41","42"]}',1,'2017-05-03 12:04:30','2017-06-01 23:26:33','4b5c27ab-0674-4c1e-b1cc-a56ceed7d9ab');
ALTER TABLE `cx_widgets` ENABLE KEYS;
UNLOCK TABLES;




SET FOREIGN_KEY_CHECKS = @PREVIOUS_FOREIGN_KEY_CHECKS;


