# === Kirby TBC Backup Script ===
# Dumps all four databases from both dev and live to two local drives and syncs to Google Drive via rclone.
# Intended to run nightly via Windows Task Scheduler.

$Servers = @(
    @{
        Name         = "dev"
        Container    = "mangos-tbc-dev-database-1"
        BackupRoots  = @("C:\Backups\mangos-tbc\dev", "D:\Backups\mangos-tbc\dev")
    },
    @{
        Name         = "live"
        Container    = "mangos-tbc-live-database-1"
        BackupRoots  = @("C:\Backups\mangos-tbc\live", "D:\Backups\mangos-tbc\live")
    }
)

$MysqlUser   = "root"
$MysqlPass   = "mangos"
$Databases   = @("tbcrealmd", "tbcmangos", "tbccharacters", "tbclogs")
$Timestamp   = Get-Date -Format "yyyy-MM-dd"
$LogFile     = "C:\Backups\mangos-tbc\backup.log"

function Write-Log {
    param([string]$Message)
    $Entry = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $Message"
    Write-Output $Entry
    Add-Content -Path $LogFile -Value $Entry
}

Write-Log "=== Backup started ==="

foreach ($Server in $Servers) {
    $ServerName  = $Server.Name
    $Container   = $Server.Container
    $BackupRoots = $Server.BackupRoots

    Write-Log "--- Backing up $ServerName ---"

    # === Create dated folders ===
    foreach ($Root in $BackupRoots) {
        $Dir = "$Root\$Timestamp"
        if (-not (Test-Path $Dir)) {
            New-Item -ItemType Directory -Path $Dir -Force | Out-Null
        }
    }

    # === Dump each database ===
    foreach ($DB in $Databases) {
        $Filename = "$Timestamp-$DB.sql.gz"
        $TmpPath  = "/tmp/$Filename"

        Write-Log "Dumping $ServerName/$DB..."

        $DumpCmd = "mysqldump -u$MysqlUser -p$MysqlPass --single-transaction --routines --triggers --databases $DB | gzip > $TmpPath"
        docker exec $Container bash -c $DumpCmd

        if ($LASTEXITCODE -ne 0) {
            Write-Log "ERROR: Dump of $ServerName/$DB failed."
            continue
        }

        foreach ($Root in $BackupRoots) {
            $Dest = "$Root\$Timestamp\$Filename"
            docker cp "$($Container):$TmpPath" $Dest
            Write-Log "Saved $ServerName/$DB to $Dest"
        }

        docker exec $Container bash -c "rm $TmpPath"
    }

    # === Retention cleanup ===
    foreach ($Root in $BackupRoots) {
        Write-Log "Running retention cleanup on $Root..."

        $AllDirs = Get-ChildItem -Path $Root -Directory | Sort-Object Name

        foreach ($Dir in $AllDirs) {
            try {
                $DirDate = [datetime]::ParseExact($Dir.Name, "yyyy-MM-dd", $null)
            } catch {
                continue
            }

            $AgeDays = ((Get-Date) - $DirDate).Days

            if ($AgeDays -le 7) { continue }
            if ($AgeDays -le 28 -and $DirDate.DayOfWeek -eq [DayOfWeek]::Sunday) { continue }

            Write-Log "Deleting old backup: $($Dir.FullName)"
            Remove-Item -Path $Dir.FullName -Recurse -Force
        }
    }

    Write-Log "--- $ServerName backup complete ---"
}

# === Sync to Google Drive ===
Write-Log "Syncing to Google Drive..."

$LocalSource = "C:\Backups\mangos-tbc"
$RemoteDest  = "kirbyTBC-gdrive:kirby-tbc-backups"

rclone sync $LocalSource $RemoteDest --log-file $LogFile --log-level INFO

if ($LASTEXITCODE -ne 0) {
    Write-Log "ERROR: Google Drive sync failed."
} else {
    Write-Log "Google Drive sync complete."
}

Write-Log "=== Backup finished ==="