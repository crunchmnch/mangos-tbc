# ADR 001: Chose CMaNGOS-TBC as server core

## Status
Accepted

## Context
Needed a WoW emulator for a 10-person private TBC server with authentic 2.4.3 mechanics, low-population QoL features, and support for custom hardcore mechanics.

## Decision
Use CMaNGOS-TBC (cmangos/mangos-tbc).

## Reasons
- Authentic 2.4.3 client and mechanics
- AHBot built into core, designed for low-population servers
- Playerbots built into core for filling groups when players are offline
- Actively maintained as of mid-2026
- Simpler, more stable codebase for deep custom mechanics vs. AzerothCore modules
- Closer to TBC Hardcore out of the box, ready for hardcore customization

## Alternatives Rejected
- AzerothCore: WotLK core, richer module ecosystem, but wrong client version and mechanics. Module system benefit doesn't outweigh authenticity cost for this group.

## Consequences
Smaller community and fewer pre-built modules than AzerothCore. Custom mechanics require direct C++ core modifications rather than isolated modules.