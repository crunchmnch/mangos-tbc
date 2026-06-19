# ROADMAP.md — Kirby TBC Private Server

Infrastructure before features. Each phase must be stable before moving on.

## Phase 1: Foundation ✓
- [x] Platform decision — CMaNGOS-TBC chosen over AzerothCore
- [x] Git repository — fork, upstream remote, branch strategy, folder structure
- [x] Docker dev environment — build from fork, three containers running
- [x] Database setup — all four databases populated and verified
- [x] Client connection verified — login, character creation, world entry
- [x] Core documentation — CLAUDE.md, runbooks, ADRs

## Phase 2: Server Administration (Next Session)
- [x] Backup strategy — nightly mysqldump, rclone to cloud, tested restore procedure
      Why: characters database is irreplaceable; hardware failure is a real risk
- [x] server-live setup — production instance, separate volume, separate config
      Why: never develop on the live server; friends connect here only
- [x] Tailscale — private network overlay for friend connections
      Why: no port forwarding, stable IPs, works on dynamic home internet
- [x] DB administration session — HeidiSQL best practices, safe change workflow
      Why: most custom work happens in the DB; bad habits cause permanent damage

## Phase 3: Project Management
- [ ] Master checklist document — everything to do and why, non-verbose
      Why: single source of truth for project status across sessions

## Phase 4: Game Mechanics Design
- [ ] Death penalty system spec — "hard(ish)core": level loss, gold loss (can go
      negative, blocking repair/flight/AH), full durability drain on death.
      Penalties double per death, reset weekly. Class abilities (soulstone,
      battle-rez, divine intervention, reincarnation) prevent stat penalties
      but increase the death counter. See docs/design/ for full spec.
- [ ] Unlock system spec — Outlands unlock, XP acceleration, account-level flags
- [ ] Custom questline spec — 55+ questline design, rewards, implementation path
- [ ] DB schema design — account_progression_flags table, all mechanics read from it

## Phase 5: Implementation
- [ ] Hardcore death system — C++ hooks, block all resurrection paths
- [ ] Unlock system — zone entry events, account-level DB flags
- [ ] Custom questline — NPCs, objectives, script triggers
- [ ] Playtesting with friend group

## Notes
- server-live is not stood up until Phase 2 is complete
- No custom C++ until Phase 3 checklist exists
- Design docs in docs/design/ before any Phase 5 implementation begins