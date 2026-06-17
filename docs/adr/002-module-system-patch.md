# ADR 002: Adopted cmangos-modules system via patch

## Status
Accepted

## Context
Need a module system to access existing CMaNGOS modules (particularly the 
Hardcore module as a foundation for custom mechanics) without abandoning 
the official CMaNGOS-TBC lineage.

## Decision
Apply the flekz-games/cmangos-modules tbc.patch to our fork of cmangos/mangos-tbc.

## Reasons
- Stays on official CMaNGOS master as upstream — never on a secondary fork
- Grants access to the full cmangos-modules ecosystem:
  - Hardcore (all cores) — foundation for our custom death system
  - Dual Spec (TBC) — QoL for small group
  - Achievements (TBC) — optional quality of life
  - Transmog (all cores) — optional
  - Immersive (all cores) — optional
- Hardcore module serves as working reference before writing custom mechanics
- Modules toggle via .conf without recompiling

## Alternatives Rejected
- flekz-games/mangos-tbc modules branch: easier integration but means syncing 
  against a secondary fork instead of official CMaNGOS. Rejected.
- Custom C++ without module system: maximum control but no reference 
  implementations, no reuse. Rejected as premature given available modules.

## Consequences
- Patch must be verified after every upstream CMaNGOS sync (documented in runbook)
- flekz-games/cmangos-modules is an additional dependency to monitor for updates
- cmake gains BUILD_MODULES=ON flag plus per-module flags (e.g. BUILD_MODULE_HARDCORE=ON)
- Modules live as submodules in src/modules/ — each is a separate git submodule