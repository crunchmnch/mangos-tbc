# Runbook: Database Setup (Fresh Build)

Use this when rebuilding the databases from scratch.

## Prerequisites

- Database container running: `docker compose up -d database`
- All source repositories cloned locally:
  - `D:\Projects\mangos-tbc` (core repo)
  - `D:\Projects\tbc-db` (world content)
  - `D:\Projects\playerbots` (bot SQL)

## CRITICAL: SQL Application Method

**Never pipe large SQL files through PowerShell.** Silent truncation occurs
with files over ~1MB. Always copy into the container and apply from inside.

```powershell
# Copy files in
docker cp "D:\path\to\file.sql" mangos-tbc-dev-database-1:/tmp/file.sql

# Apply from inside
docker exec -it mangos-tbc-dev-database-1 bash
mysql -uroot -pmangos <dbname> < /tmp/file.sql
```

For folders, copy the entire folder:

```powershell
docker cp "D:\path\to\folder" mangos-tbc-dev-database-1:/tmp/folder
```

## Step 1: Create Databases

```powershell
docker cp "D:\Projects\mangos-tbc\sql\create\db_create_mysql.sql" mangos-tbc-dev-database-1:/tmp/
docker exec mangos-tbc-dev-database-1 mysql -uroot -pmangos -e "source /tmp/db_create_mysql.sql"
```

Verify: `docker exec mangos-tbc-dev-database-1 mysql -uroot -pmangos -e "SHOW DATABASES;"`
Expected: tbcrealmd, tbcmangos, tbccharacters, tbclogs

## Step 2: Copy All SQL Into Container

```powershell
docker cp "D:\Projects\mangos-tbc\sql\base" mangos-tbc-dev-database-1:/tmp/mangos_base
docker cp "D:\Projects\mangos-tbc\sql\scriptdev2" mangos-tbc-dev-database-1:/tmp/mangos_scriptdev2
docker cp "D:\Projects\tbc-db\Full_DB\TBCDB_1.10.0_ReturnOfTheVengeance.sql" mangos-tbc-dev-database-1:/tmp/tbc_fulldb.sql
docker cp "D:\Projects\tbc-db\Updates" mangos-tbc-dev-database-1:/tmp/tbc_updates
docker cp "D:\Projects\tbc-db\ACID\acid_tbc.sql" mangos-tbc-dev-database-1:/tmp/acid_tbc.sql
docker cp "D:\Projects\tbc-db\locales" mangos-tbc-dev-database-1:/tmp/tbc_locales
docker cp "D:\Projects\playerbots\sql\characters" mangos-tbc-dev-database-1:/tmp/playerbots_characters
docker cp "D:\Projects\playerbots\sql\world\tbc" mangos-tbc-dev-database-1:/tmp/playerbots_world_tbc
```

## Step 3: Apply All SQL (from inside container)

```powershell
docker exec -it mangos-tbc-dev-database-1 bash
```

Run each block in order:

```bash
# Core schema
mysql -uroot -pmangos tbcrealmd < /tmp/mangos_base/realmd.sql
mysql -uroot -pmangos tbccharacters < /tmp/mangos_base/characters.sql
mysql -uroot -pmangos tbclogs < /tmp/mangos_base/logs.sql
mysql -uroot -pmangos tbcmangos < /tmp/mangos_base/mangos.sql

# ScriptDev2
mysql -uroot -pmangos tbcmangos < /tmp/mangos_scriptdev2/scriptdev2.sql
mysql -uroot -pmangos tbcmangos < /tmp/mangos_scriptdev2/spell.sql

# DBC data (original, then CMaNGOS fixes)
mysql -uroot -pmangos tbcmangos < /tmp/mangos_base/dbc/original_data/CombatCondition.sql
mysql -uroot -pmangos tbcmangos < /tmp/mangos_base/dbc/original_data/DungeonEncounter.sql
mysql -uroot -pmangos tbcmangos < /tmp/mangos_base/dbc/original_data/FactionStore.sql
mysql -uroot -pmangos tbcmangos < /tmp/mangos_base/dbc/original_data/Spell.sql
mysql -uroot -pmangos tbcmangos < /tmp/mangos_base/dbc/original_data/SpellCone.sql
mysql -uroot -pmangos tbcmangos < /tmp/mangos_base/dbc/original_data/UnitCondition.sql
mysql -uroot -pmangos tbcmangos < /tmp/mangos_base/dbc/original_data/WorldStateExpression.sql
mysql -uroot -pmangos tbcmangos < /tmp/mangos_base/dbc/cmangos_fixes/Spell.sql
mysql -uroot -pmangos tbcmangos < /tmp/mangos_base/dbc/cmangos_fixes/SpellCone.sql

# AHBot commands
mysql -uroot -pmangos tbcmangos < /tmp/mangos_base/ahbot/mangos_command_ahbot.sql

# World content (Full_DB — large file, takes several minutes)
mysql -uroot -pmangos tbcmangos < /tmp/tbc_fulldb.sql

# DBC Spell files MUST be re-applied after Full_DB (Full_DB resets spell_template)
mysql -uroot -pmangos tbcmangos < /tmp/mangos_base/dbc/original_data/Spell.sql
mysql -uroot -pmangos tbcmangos < /tmp/mangos_base/dbc/cmangos_fixes/Spell.sql

# TBC-DB updates
for f in $(find /tmp/tbc_updates -maxdepth 1 -name "*.sql" | sort); do echo "Applying $f"; mysql -uroot -pmangos tbcmangos < "$f"; done
for f in $(find /tmp/tbc_updates/Instances -name "*.sql" | sort); do echo "Applying $f"; mysql -uroot -pmangos tbcmangos < "$f"; done

# ACID (creature EventAI scripts)
mysql -uroot -pmangos tbcmangos < /tmp/acid_tbc.sql

# Locales (English server — skip Chinese/German/Russian subfolders)
mysql -uroot -pmangos tbcmangos < /tmp/tbc_locales/BroadcastTextLocales.sql
mysql -uroot -pmangos tbcmangos < /tmp/tbc_locales/OtherLocales.sql
mysql -uroot -pmangos tbcmangos < /tmp/tbc_locales/OtherLocales_cmangos_fixes.sql

# Playerbots
for f in /tmp/playerbots_characters/*.sql; do echo "Applying $f"; mysql -uroot -pmangos tbccharacters < "$f"; done
for f in /tmp/playerbots_world_tbc/*.sql; do echo "Applying $f"; mysql -uroot -pmangos tbcmangos < "$f"; done
```

## Step 4: Apply Custom Migrations

```bash
# Run from inside container
mysql -uroot -pmangos tbcmangos < /tmp/... # copy and apply each file in custom/sql/migrations/ in order
```

Or from PowerShell:

```powershell
docker cp "D:\Projects\mangos-tbc\custom\sql\migrations" mangos-tbc-dev-database-1:/tmp/migrations
docker exec -it mangos-tbc-dev-database-1 bash
for f in $(find /tmp/migrations -name "*.sql" | sort); do echo "Applying $f"; mysql -uroot -pmangos tbcmangos < "$f"; done
```

## Step 5: Configure Realmlist

```powershell
docker exec mangos-tbc-dev-database-1 mysql -uroot -pmangos tbcrealmd -e "UPDATE realmlist SET name='Kirby TBC Dev', address='127.0.0.1' WHERE id=1;"
```

## Verification Checklist

Run from inside the container:

```bash
mysql -uroot -pmangos tbcmangos -e "SELECT COUNT(*) AS spell_template FROM spell_template;"      # ~29339
mysql -uroot -pmangos tbcmangos -e "SELECT COUNT(*) AS creature_template FROM creature_template;" # ~18799
mysql -uroot -pmangos tbcmangos -e "SELECT COUNT(*) AS item_template FROM item_template;"         # ~30396
mysql -uroot -pmangos tbcmangos -e "SELECT COUNT(*) AS quest_template FROM quest_template;"       # ~6599
mysql -uroot -pmangos tbcmangos -e "SELECT COUNT(*) AS creature FROM creature;"                   # ~109352
mysql -uroot -pmangos tbcmangos -e "SELECT COUNT(*) AS locales_creature FROM locales_creature;"   # ~18814
mysql -uroot -pmangos tbcmangos -e "SELECT COUNT(*) AS creature_ai_scripts FROM creature_ai_scripts;" # ~19364
mysql -uroot -pmangos tbcmangos -e "SELECT entry, name FROM creature_template WHERE entry=22917;" # Illidan Stormrage
mysql -uroot -pmangos tbcmangos -e "SELECT * FROM db_version;"                                    # TBC-DB 1.10.0
mysql -uroot -pmangos tbccharacters -e "SHOW TABLES LIKE 'ai_playerbot%';" | wc -l               # 11 tables
```

## Known Schema Issues (Already Fixed by Migrations)

- `locales_gameobject.castbarcaption_loc1-8` must be renamed to `opening_text_loc1-8`
  → Fixed by migration 001
- `locales_gameobject` missing `closing_text_loc1-8` columns
  → Fixed by migration 002
- ACID must be applied separately — not included in tbc-db Full_DB
  → Documented in migration 003