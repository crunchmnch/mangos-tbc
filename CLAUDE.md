# CLAUDE.md — Kirby TBC Private Server

CMaNGOS-TBC (C++) WoW 2.4.3 emulator. Private 10-person server with custom
hardcore mechanics. Windows 11 host. Docker build and deployment.

## ⏸️ PROJECT PAUSED (2026-06-18)
Development paused to evaluate AzerothCore as an alternative to CMaNGOS-TBC.
See SESSION-LOG.md "Session 3" entry for full context and resume instructions.
Do not resume CMaNGOS-TBC work or begin AzerothCore work without discussing
with the user first.

## Agent Rules

- **Never build Docker images without being asked.** Builds take 15-30 minutes.
- **Never run `docker compose down` on server-live without being asked.**
- **Never modify files in `/doc/` or `/sql/`** — CMaNGOS upstream, do not touch.
- **Never edit a migration file after it has been committed.** Write a new one.
- **Never run git commands that modify repo state** (commit, branch, merge, push,
  reset) unless explicitly asked. Read-only git (status, diff, log) is fine.
- **Always ask rather than infer** when design intent is unclear.
- **Always include code examples** when discussing C++ — admin has minimal
  programming experience.
- Reference online CMaNGOS-TBC documentation rather than making assumptions
- Prefer slow and safe over fast and risky.
- Keep markdown files non-verbose and factual.

## Build

Run from `docker/server-dev/`:

```powershell
docker compose build 2>&1 | Tee-Object -FilePath build.log
```

Dockerfile at `docker/Dockerfile` compiles CMaNGOS from this repo's source
using Ubuntu 22.04. Output images: `mangos-tbc-dev-mangosd`,
`mangos-tbc-dev-realmd`.

## Docker Operations

Run from `docker/server-dev/` or `docker/server-live/`:

```powershell
docker compose up -d                        # Start
docker compose down                         # Stop
docker compose logs -f                      # Follow logs
docker compose up -d --build                # Rebuild and restart
docker compose up -d --force-recreate       # Apply compose.yml changes
```

**IMPORTANT:** `docker compose restart` does NOT apply compose.yml changes.
Always use `--force-recreate` when compose.yml has been edited.

Dev ports: auth `127.0.0.1:3724`, world `127.0.0.1:8085`,
MySQL `127.0.0.1:3307`
HeidiSQL: host `127.0.0.1`, port `3307`, user `root`, pass `mangos`

## Console Access

See: [docs/runbooks/console-access.md](docs/runbooks/console-access.md)

Quick reference — from `docker/server-dev/`, open a standalone PowerShell
(not VSCode terminal):

```powershell
docker compose attach mangosd
```

Detach: Ctrl+P then Ctrl+Q. Never Ctrl+C (kills the server).
Requires `stdin_open: true` and `tty: true` in compose.yml (already set).

## Repository Layout

```
/src/                         CMaNGOS C++ source (modify with custom blocks)
/sql/                         CMaNGOS upstream SQL (do not modify)
/doc/                         CMaNGOS upstream docs (do not modify)
/custom/sql/install/          Custom table definitions, run once on fresh builds
/custom/sql/migrations/       Numbered sequential DB changes, never edit after commit
/custom/config/               Custom configuration overrides
/docker/Dockerfile            Build definition
/docker/server-dev/           Dev environment (compose.yml, config/, logs/)
/docker/server-live/          Live environment (compose.yml, config/, logs/)
/docs/adr/                    Architecture Decision Records
/docs/runbooks/               Operational procedures
/docs/design/                 Game mechanic specifications
```

## Databases

| Name            | Purpose                                 |
|-----------------|-----------------------------------------|
| `tbcrealmd`     | Accounts, realm list (LoginDatabase)    |
| `tbcmangos`     | World/static content (WorldDatabase)    |
| `tbccharacters` | Per-character state (CharacterDatabase) |
| `tbclogs`       | Server logs (LogsDatabase)              |

## SQL Changes

**CRITICAL:** Never pipe large SQL files through PowerShell — silent truncation
occurs. Always copy files into the container and apply from inside.

```powershell
docker cp "path\to\file.sql" mangos-tbc-dev-database-1:/tmp/file.sql
docker exec -it mangos-tbc-dev-database-1 bash
# then inside: mysql -uroot -pmangos <dbname> < /tmp/file.sql
```

Migration files live in `custom/sql/migrations/`, numbered sequentially,
never edited after commit. To reverse, write a new migration.

## Active Modules

Toggled via .conf files in `docker/server-dev/config/`. No recompile needed.

- AHBot — `ahbot.conf`
- AI PlayerBot — `aiplayerbot.conf` (currently disabled: `AiPlayerbot.Enabled=0`)
- Anticheat — `anticheat.conf`

Module system: flekz-games/cmangos-modules tbc.patch (see ADR 002).
Verify patch integrity after every upstream sync (see upstream sync runbook).

## Custom Code Convention

All modifications to CMaNGOS source files must use this comment block:

```cpp
// === CUSTOM: [brief description] ===
// Reason: [why this change exists]
// See: [docs/design/relevant-doc.md]
... modified code ...
// === END CUSTOM ===
```

## Branch Strategy

- `master` — production; reflects server-live. Never commit directly.
- `dev` — all development. Always work here.
- Feature branches off dev for multi-session work:
  `feature/hardcore-death-system`

Flow: feature → dev → master. Never sideways, never backwards.

Upstream remote push is intentionally disabled:
`git remote set-url --push upstream DISABLED`

## Server Hardware

- CPU: 16 logical cores
- RAM: 31 GB
- Recommended `MapUpdate.Threads` in mangosd.conf: 4

## Key Documents

- [ADR 001: Chose CMaNGOS-TBC](docs/adr/001-chose-cmangos-tbc.md)
- [ADR 002: Module system patch](docs/adr/002-module-system-patch.md)
- [Runbook: Upstream Sync](docs/runbooks/upstream-sync.md)
- [Runbook: Console Access](docs/runbooks/console-access.md)
- [Runbook: Database Setup](docs/runbooks/database-setup.md)