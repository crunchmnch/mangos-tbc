# Runbook: Backup and Restore

## Backup Script

Location: `scripts/backup-databases.ps1`
Schedule: Nightly at 4AM via Windows Task Scheduler
Log: `C:\Backups\mangos-tbc\backup.log`

### What it does
- Dumps all four databases from both dev and live to both local drives (C: and D:)
- Syncs C: backup to Google Drive via rclone
- Enforces retention: 7 daily backups, 4 weekly (Sunday) backups

### Backup locations
| Location | Dev Path | Live Path |
|---|---|---|
| Local (C:) | `C:\Backups\mangos-tbc\dev\YYYY-MM-DD\` | `C:\Backups\mangos-tbc\live\YYYY-MM-DD\` |
| Local (D:) | `D:\Backups\mangos-tbc\dev\YYYY-MM-DD\` | `D:\Backups\mangos-tbc\live\YYYY-MM-DD\` |
| Cloud | `kirbyTBC-gdrive:kirby-tbc-backups\dev\` | `kirbyTBC-gdrive:kirby-tbc-backups\live\` |

### Running manually
From any PowerShell window:
```powershell
& "D:\Projects\mangos-tbc\scripts\backup-databases.ps1"
```

## Restore Procedure

Use this when a database is corrupted or accidentally dropped.

### Prerequisites
- Database container must be running
- Know which date's backup you want to restore from
- Check `C:\Backups\mangos-tbc\backup.log` to confirm that backup completed successfully

### Step 1 — Choose your backup
```powershell
Get-ChildItem "C:\Backups\mangos-tbc\dev\"
Get-ChildItem "C:\Backups\mangos-tbc\live\"
```
Pick the dated folder you want. Use the most recent unless you have a reason not to.

### Step 2 — Copy backup file into container
Replace `YYYY-MM-DD` and `DBNAME` with actual values:
```powershell
# For dev:
docker cp "C:\Backups\mangos-tbc\dev\YYYY-MM-DD\YYYY-MM-DD-DBNAME.sql.gz" mangos-tbc-dev-database-1:/tmp/restore.sql.gz

# For live:
docker cp "C:\Backups\mangos-tbc\live\YYYY-MM-DD\YYYY-MM-DD-DBNAME.sql.gz" mangos-tbc-live-database-1:/tmp/restore.sql.gz
```

### Step 3 — Restore the database
```powershell
# Dev:
docker exec mangos-tbc-dev-database-1 bash -c "zcat /tmp/restore.sql.gz | mysql -uroot -pmangos"

# Live:
docker exec mangos-tbc-live-database-1 bash -c "zcat /tmp/restore.sql.gz | mysql -uroot -pmangos"
```
This drops and recreates the database automatically. No manual steps needed.

### Step 4 — Verify
Run these in HeidiSQL against the restored database:

**tbccharacters**
```sql
SELECT guid, name, race, class, level FROM characters;
```
Confirm your characters are present.

**tbcmangos**
```sql
SELECT COUNT(*) FROM creature_template;  -- expect ~18799
SELECT COUNT(*) FROM spell_template;     -- expect ~29339
SELECT COUNT(*) FROM item_template;      -- expect ~30396
```

**tbcrealmd**
```sql
SELECT * FROM realmlist;
```
Confirm realm name and address are correct.

### Step 5 — Test login
Log into the game client and confirm characters are present and the world loads.

## Tested
- 2026-06-18: Full drop and restore of tbccharacters verified. Crunch (guid 1)
  confirmed present in-game after restore.