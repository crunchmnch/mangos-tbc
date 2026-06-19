# 001 — Death Penalty System

## Vision

Dying is painful but recoverable. Penalties accumulate and compound, encouraging
careful play and character shelving decisions. Nothing is permanently lost except
gold debt, which carries forward indefinitely. The system is designed to be tuned
through playtesting without recompiling.

## Core Mechanic

A single shared **death counter** drives all penalties. The counter increases on
every death — including "saved" deaths where a class ability prevented stat loss
(see Class Abilities below). The counter decays over time toward a configurable
floor and can be fully reset on a weekly schedule.

All penalty types ride this shared counter. Their individual severity is tuned
independently via scalars.

## Penalty Types

### XP / Level Loss
- Player loses levels on death, scaled by the current counter value
- Floor: level 1 (cannot go below)
- Lost levels are not restored by decay or reset — must be re-earned

### Gold Loss
- Player loses gold on death, scaled by the current counter value
- Supports a flat amount, a percentage of current gold, or both simultaneously
- Gold can go negative, blocking repair, flight paths, and auction house use
- Negative gold debt is not restored by decay or reset — must be earned back
- Players may use alts or receive help from other players to recover

### Durability Drain
- Full durability drain on death when enabled
- No scalar — it is always full drain or disabled

## Counter Behavior

Two progression modes, configurable:

**Exponential:** counter multiplier doubles on each death (1x → 2x → 4x → 8x...)

**Linear:** counter multiplier increases by a fixed amount on each death
(1x → 1.5x → 2x → 2.5x...)

Both modes are designed to make repeated deaths within a short window increasingly
painful, encouraging players to shelf a character rather than keep pushing.

## Relief Mechanics

All relief mechanics are independently configurable and can be combined or disabled.

### Decay
The counter multiplier erodes toward the floor over real time. Rate is configurable
in multiplier-reduction-per-day. Ticks on a configurable interval (e.g. hourly).
The multiplier never decays below the configured floor.

### Weekly Reset
The counter resets fully on a configured day and hour (UTC). Can be disabled
independently of decay.

### Floor
The floor controls the minimum multiplier value after full decay. At 1.0, the
minimum penalty is always the base penalty. At 0.0, the multiplier can decay to
zero, making the next death after full decay free — but the counter still increments
from that death, so subsequent deaths hurt again.

## Class Abilities

Soulstone, battle-rez, divine intervention, and reincarnation prevent stat
penalties (XP loss, gold loss, durability drain) on the death they are used.
However, the death counter **still increments**. This means saved deaths make
future deaths more expensive.

Players are explicitly informed of this mechanic. Using a class ability is a
deliberate tradeoff, not a free escape.

## Configuration Schema

```
# Shared death counter
DeathPenalty.Counter.Mode = exponential     # exponential | linear
DeathPenalty.Counter.Base = 2.0             # exponential: multiplier doubles | linear: adds this
DeathPenalty.Counter.Floor = 1.0            # 1.0 = no free deaths, 0.0 = allow free deaths
DeathPenalty.Counter.Cap = -1               # -1 = unlimited

# Decay
DeathPenalty.Decay.Enabled = 1
DeathPenalty.Decay.RatePerDay = 0.2         # multiplier reduction per day
DeathPenalty.Decay.Interval = 3600          # tick frequency in seconds

# Weekly reset
DeathPenalty.Reset.Enabled = 1
DeathPenalty.Reset.Day = 1                  # 0=Sunday through 6=Saturday
DeathPenalty.Reset.Hour = 6                 # hour of reset (UTC)

# XP / level loss
DeathPenalty.XP.Enabled = 1
DeathPenalty.XP.BaseLoss = 1.0              # levels lost at 1x multiplier
DeathPenalty.XP.Scalar = 1.0               # amplify or dampen relative to counter

# Gold loss
DeathPenalty.Gold.Enabled = 1
DeathPenalty.Gold.BaseLoss.Flat = 1000      # gold lost at 1x multiplier
DeathPenalty.Gold.BaseLoss.Percent = 0.0    # % of current gold lost at 1x (0.0 = disabled)
DeathPenalty.Gold.Scalar = 1.0             # amplify or dampen relative to counter
DeathPenalty.Gold.AllowNegative = 1
DeathPenalty.Gold.NegativeFloor = -1        # -1 = unlimited debt, positive = floor in gold

# Durability
DeathPenalty.Durability.Enabled = 1        # full drain on death when enabled
```

## Debuff

A persistent aura is applied to the character on death and removed on weekly reset
(or when decay reaches floor, if reset is disabled). The aura is visible to the
player and to other players, communicating current penalty state. Implementation
details to be determined in Phase 5.

## Open Questions (deferred to Phase 5)

- Exact C++ hooks for death events and resurrection interception
- DB schema for storing counter value and timestamp per character
- How the debuff aura encodes and displays current penalty state
- Whether decay ticks server-side on a timer or is calculated on-demand at death time

## Status

Design complete. Implementation deferred to Phase 5.
Last updated: 2026-06-18