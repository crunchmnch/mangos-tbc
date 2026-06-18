# Session Log — Kirby TBC Private Server

Hand this to Claude at the start of every session along with CLAUDE.md and Roadmap.md.

---

## 2026-06-18

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
- Play-Live.bat and Play-Dev.bat not committed (live in D:\Games\WoW_KirbyTBC, not in repo — intentional)
- Getting started document for friends not yet written
- DB administration session runbook not formally written (covered in practice)

### Next Session
- Phase 3: master checklist document
- Write getting started doc for friends (needs: Tailscale invite flow, realmlist address, WoW client source)
- Review Roadmap Phase 4 game mechanics design specs