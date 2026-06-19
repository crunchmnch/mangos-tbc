# Runbook: Mangosd Console Access

## Prerequisites
- mangosd container running and fully loaded ("World initialized" in logs)
- `stdin_open: true` and `tty: true` present in compose.yml mangosd service
- `Console.Enable = 1` in the environment's mangosd.conf
- Standalone PowerShell window (not VSCode terminal — VSCode intercepts Ctrl+P)

## Attaching to the Console

**Dev:**
```powershell
cd D:\Projects\mangos-tbc\docker\server-dev
docker compose attach mangosd
```

**Live:**
```powershell
cd D:\Projects\mangos-tbc\docker\server-live
docker compose attach mangosd
```

The screen will go blank. This is normal — type your command and press Enter.
You will see output after each command.

## Detaching Safely
Press Ctrl+P, release, then immediately press Ctrl+Q.
**Never press Ctrl+C** — this kills the mangosd process entirely.

## Common Commands
```
# Account management
account create <username> <password>
account set gmlevel <username> <level> -1    # level 3 = full admin
account set addon <username> 1               # 1 = TBC expansion access
account set password <username> <password> <password>

# Server info
server info
server motd

# Player management (while logged in)
.gm on
.gm off
.tele <location>

# Resurrection (tech death policy)
.revive                                      # revive targeted player
.character resurrect <name>                  # resurrect offline character
```

## Important Notes
- Always run from the directory matching the environment you want to manage — dev and live are separate.
- If `docker compose restart` was run after editing compose.yml, the tty
  settings may not have applied. Run `docker compose up -d --force-recreate`
  to ensure they take effect.
- VSCode integrated terminal intercepts Ctrl+P and Ctrl+Q. Always use a
  standalone PowerShell window from the Start menu.
- Ra (Remote Access) on port 3443 is an alternative but requires an existing
  admin account to authenticate first.