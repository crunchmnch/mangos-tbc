-- Migration: 002
-- Purpose: Add closing_text_loc1-8 columns to locales_gameobject
-- Reason: Compiled binary expects these columns. They were not present in base
--         mangos.sql. Added as companion to migration 001 (opening_text rename).
-- See: docs/design/ (future hardcore design docs)

ALTER TABLE `locales_gameobject` ADD COLUMN `closing_text_loc1` varchar(100) NOT NULL DEFAULT '';
ALTER TABLE `locales_gameobject` ADD COLUMN `closing_text_loc2` varchar(100) NOT NULL DEFAULT '';
ALTER TABLE `locales_gameobject` ADD COLUMN `closing_text_loc3` varchar(100) NOT NULL DEFAULT '';
ALTER TABLE `locales_gameobject` ADD COLUMN `closing_text_loc4` varchar(100) NOT NULL DEFAULT '';
ALTER TABLE `locales_gameobject` ADD COLUMN `closing_text_loc5` varchar(100) NOT NULL DEFAULT '';
ALTER TABLE `locales_gameobject` ADD COLUMN `closing_text_loc6` varchar(100) NOT NULL DEFAULT '';
ALTER TABLE `locales_gameobject` ADD COLUMN `closing_text_loc7` varchar(100) NOT NULL DEFAULT '';
ALTER TABLE `locales_gameobject` ADD COLUMN `closing_text_loc8` varchar(100) NOT NULL DEFAULT '';