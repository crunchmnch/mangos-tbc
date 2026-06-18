-- Migration: 001
-- Purpose: Rename castbarcaption_loc1-8 to opening_text_loc1-8 in locales_gameobject
-- Reason: Compiled binary expects opening_text column names. tbc-db update 0698
--         attempted this rename but base mangos.sql still uses old column names.
-- See: docs/adr/002-module-system-patch.md

ALTER TABLE `locales_gameobject` CHANGE `castbarcaption_loc1` `opening_text_loc1` varchar(100) NOT NULL DEFAULT '';
ALTER TABLE `locales_gameobject` CHANGE `castbarcaption_loc2` `opening_text_loc2` varchar(100) NOT NULL DEFAULT '';
ALTER TABLE `locales_gameobject` CHANGE `castbarcaption_loc3` `opening_text_loc3` varchar(100) NOT NULL DEFAULT '';
ALTER TABLE `locales_gameobject` CHANGE `castbarcaption_loc4` `opening_text_loc4` varchar(100) NOT NULL DEFAULT '';
ALTER TABLE `locales_gameobject` CHANGE `castbarcaption_loc5` `opening_text_loc5` varchar(100) NOT NULL DEFAULT '';
ALTER TABLE `locales_gameobject` CHANGE `castbarcaption_loc6` `opening_text_loc6` varchar(100) NOT NULL DEFAULT '';
ALTER TABLE `locales_gameobject` CHANGE `castbarcaption_loc7` `opening_text_loc7` varchar(100) NOT NULL DEFAULT '';
ALTER TABLE `locales_gameobject` CHANGE `castbarcaption_loc8` `opening_text_loc8` varchar(100) NOT NULL DEFAULT '';