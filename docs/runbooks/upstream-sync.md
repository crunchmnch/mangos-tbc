# Runbook: Upstream CMaNGOS Sync

## When to run
- Monthly, or when upstream fixes something you specifically want
- Never reactively during an active play session

## Prerequisites
- All custom work committed and pushed
- Dev server stopped
- You are on the dev branch

## Steps

1. Fetch upstream changes without merging
   git fetch upstream

2. Check what's coming in before touching anything
   git log dev..upstream/master --oneline

3. Merge upstream into dev
   git merge upstream/master

4. Resolve any conflicts
   - Pay close attention to any file that contains a // === CUSTOM === block
   - These are your modifications — preserve them while incorporating upstream changes
   - See: conflict resolution notes below

5. Verify the module system patch is intact
   - Check that #ifdef ENABLE_MODULES blocks still exist in key files
   - Spot check: src/game/Entities/Player.cpp, src/game/Spells/Spell.cpp
   - If blocks are missing or broken, the upstream changes overwrote patch hooks
   - Fix: check if flekz-games has updated their tbc.patch and re-apply as needed
     https://github.com/flekz-games/cmangos-modules/blob/main/patches/tbc.patch

6. Build on dev Docker instance and verify server starts cleanly

7. Test basic in-game functionality before merging to master

8. Merge dev to master only after successful test
   git checkout master
   git merge dev
   git push origin master
   git checkout dev

## Conflict resolution notes
- git conflicts show <<<<<<< ours (your code) vs >>>>>>> theirs (upstream)
- Accept Both Changes when both sides need to survive (most common)
- Accept Incoming when upstream rewrote something you hadn't touched
- Never accept ours blindly on files you know upstream improved
- When in doubt, Accept Both and review the result manually

## After sync
- Update the server on the live instance only after dev is confirmed stable
- Note the sync in a commit message: "Upstream sync YYYY-MM-DD"