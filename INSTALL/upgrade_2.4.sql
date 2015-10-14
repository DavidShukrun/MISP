-- Copyright (c) 2009 www.cryer.co.uk
-- Script is free to use provided this copyright header is included.
drop procedure if exists AddColumnUnlessExists;
delimiter '//'

create procedure AddColumnUnlessExists(
	IN dbName tinytext,
	IN tableName tinytext,
	IN fieldName tinytext,
	IN fieldDef text)
begin
	IF NOT EXISTS (
		SELECT * FROM information_schema.COLUMNS
		WHERE column_name=fieldName
		and table_name=tableName
		and table_schema=dbName
		)
	THEN
		set @ddl=CONCAT('ALTER TABLE ',dbName,'.',tableName,
			' ADD COLUMN ',fieldName,' ',fieldDef);
		prepare stmt from @ddl;
		execute stmt;
	END IF;
end;
//

delimiter ';'

call AddColumnUnlessExists(Database(), 'attributes', 'sharing_group_id', 'INT( 11 ) NOT NULL DEFAULT 0');

call AddColumnUnlessExists(Database(), 'events', 'sharing_group_id', 'INT( 11 ) NOT NULL DEFAULT 0');
call AddColumnUnlessExists(Database(), 'events', 'org_id', 'INT( 11 ) NOT NULL DEFAULT 0');
call AddColumnUnlessExists(Database(), 'events', 'orgc_id', 'INT( 11 ) NOT NULL DEFAULT 0');

call AddColumnUnlessExists(Database(), 'jobs', 'org_id', 'INT( 11 ) NOT NULL DEFAULT 0');
call AddColumnUnlessExists(Database(), 'jobs', 'date_created', 'datetime NOT NULL');
call AddColumnUnlessExists(Database(), 'jobs', 'date_modified', 'datetime NOT NULL');

call AddColumnUnlessExists(Database(), 'roles', 'perm_sharing_group', 'TINYINT( 1 ) NOT NULL DEFAULT 0');

call AddColumnUnlessExists(Database(), 'servers', 'pull_rules', 'TEXT( 11 ) COLLATE utf8_bin NOT NULL');
call AddColumnUnlessExists(Database(), 'servers', 'push_rules', 'TEXT( 11 ) COLLATE utf8_bin NOT NULL');
call AddColumnUnlessExists(Database(), 'servers', 'org_id', 'INT( 11 ) NOT NULL DEFAULT 0');
call AddColumnUnlessExists(Database(), 'servers', 'remote_org_id', 'INT( 11 ) NOT NULL DEFAULT 0');


call AddColumnUnlessExists(Database(), 'shadow_attributes', 'org_id', 'INT( 11 ) NOT NULL DEFAULT 0');
call AddColumnUnlessExists(Database(), 'shadow_attributes', 'event_org_id', 'INT( 11 ) NOT NULL DEFAULT 0');

call AddColumnUnlessExists(Database(), 'tags', 'exportable', 'TINYINT( 1 ) NOT NULL DEFAULT 0');

call AddColumnUnlessExists(Database(), 'threads', 'org_id', 'INT( 11 ) NOT NULL DEFAULT 0');
call AddColumnUnlessExists(Database(), 'threads', 'sharing_group_id', 'INT( 11 ) NOT NULL DEFAULT 0');

call AddColumnUnlessExists(Database(), 'users', 'org_id', 'INT( 11 ) NOT NULL DEFAULT 0');
call AddColumnUnlessExists(Database(), 'users', 'server_id', 'INT( 11 ) NOT NULL DEFAULT 0');

call AddColumnUnlessExists(Database(), 'correlations', 'org_id', 'INT( 11 ) NOT NULL DEFAULT 0');
call AddColumnUnlessExists(Database(), 'correlations', 'distribution', 'tinyint( 4 ) NOT NULL DEFAULT 0');
call AddColumnUnlessExists(Database(), 'correlations', 'a_distribution', 'tinyint( 4 ) NOT NULL DEFAULT 0');
call AddColumnUnlessExists(Database(), 'correlations', 'sharing_group_id', 'INT( 11 ) NOT NULL DEFAULT 0');
call AddColumnUnlessExists(Database(), 'correlations', 'a_sharing_group_id', 'INT( 11 ) NOT NULL DEFAULT 0');

CREATE TABLE IF NOT EXISTS `organisations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_bin NOT NULL,
  `date_created` datetime NOT NULL,
  `date_modified` datetime NOT NULL,
  `description` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `type` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `nationality` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `sector` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `created_by` int(11) NOT NULL,
  `uuid` varchar(40) COLLATE utf8_bin NOT NULL,
  `contacts` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `local` tinyint(1) NOT NULL DEFAULT '0',
  `landingpage` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `uuid` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `sharing_group_servers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sharing_group_id` int(11) NOT NULL,
  `server_id` int(11) NOT NULL,
  `all_orgs` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `sharing_group_orgs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sharing_group_id` int(11) NOT NULL,
  `org_id` int(11) NOT NULL,
  `extend` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `sharing_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `releasability` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `uuid` varchar(40) COLLATE utf8_bin NOT NULL,
  `organisation_uuid` varchar(40) COLLATE utf8_bin NOT NULL,
  `org_id` int(11) NOT NULL,
  `active` tinyint(1) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `local` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

