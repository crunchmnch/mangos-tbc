# Session Log — Kirby TBC Private Server
Hand this to Claude at the start of every session along with CLAUDE.md and Roadmap.md.
For continuity, paste the most recent session entry (or more if needed) into the chat.

---
## 2026-06-18 — Session 2
### Completed
- Account creation runbook written: docs/runbooks/account-creation.md
- Console access runbook updated: now covers both dev and live environments,
  added account set password command
- Warden disabled on live server (anticheat.conf: Warden.Enable = 0)
  Why: Warden times out sessions on private servers with no valid modules
- Local network play established — Tailscale dropped in favor of LAN-only for now
  Server static IP locked at 192.168.50.209 via ASUS router DHCP reservation
  Windows Firewall rules added for ports 3725 (auth) and 8086 (world) and ICMP
- Live realmlist DB address corrected from Tailscale IP to 192.168.50.209
- Expansion default fixed on live tbcrealmd.account table (ALTER TABLE SET DEFAULT 1)
- Crunch account created on dev, Purim account created on live
- Both players connected and verified in-game on live server
- Hosting discussion: decided on LAN-only for current 3-person test group;
  VPS planned when server opens to wider group
- Log files reviewed: DBErrors, SD2Errors, EventAIErrors all contain upstream
  CMaNGOS script mismatches only — no custom errors, nothing actionable
- Phase 4 death penalty system designed and documented:
  docs/design/001-death-penalty-system.md
- realmd log level bumped to 2 for debugging — left at 2, may revert later

### Open Items
- Play-Live.bat and Play-Dev.bat not committed (live in D:\Games\WoW_KirbyTBC,
  not in repo — intentional)
- Getting started doc for friends — deferred, not needed for current 3-person
  LAN group; revisit when hosting solution changes
- DB administration session runbook not formally written (covered in practice)
- Phase 3 master checklist not yet written
- Today's changes not yet committed to dev branch

### Changes Made This Session (commit these)
- docs/runbooks/account-creation.md — new
- docs/runbooks/console-access.md — updated (dev and live, password command)
- docker/server-live/config/anticheat.conf — Warden.Enable = 0
- docker/server-live/config/realmd.conf — LogLevel = 2, LogFileLevel = 2
- docs/design/001-death-penalty-system.md — new

### Next Session
- Commit all changes from this session
- Phase 3: master checklist document
- Continue Phase 4 design or begin planning Phase 5 implementation of death penalty

---
## 2026-06-18 — Session 1
### Completed
- Phase 2 fully complete
- HeidiSQL installed and connected to dev database
- Backup script — 3-2-1 strategy, dev and live, nightly 4AM via Task Scheduler
- Backup restore tested and proven in-game (Crunch restored successfully)
- server-live stood up, database populated, verified client connection
- Tailscale installed, server at 100.78.207.105
- Play-Live.bat and Play-Dev.bat created in WoW client folder
- Startup and shutdown scripts written and tested
- Runbooks written: backup-restore, server-startup-shutdown
- Expansion default fixed to TBC on both dev and live

### Open Items
- Play-Live.bat and Play-Dev.bat not committed (live in D:\Games\WoW_KirbyTBC,
  not in repo — intentional)
- Getting started document for friends not yet written
- DB administration session runbook not formally written (covered in practice)

### Next Session
- Phase 3: master checklist document
- Write getting started doc for friends (needs: Tailscale invite flow, realmlist
  address, WoW client source)
- Review Roadmap Phase 4 game mechanics design specs