# Session Handoff — 2026-06-15 (v2 revisions + layout pass)

## Final Status

The NYC Trip 2026 app's **v2 revisions are complete, verified, and pushed**. `main` is in sync with `origin/main` (`59bb163`). Working tree clean except Xcode's `UserInterfaceState.xcuserstate` (untracked noise — ignore).

Build green, full `xcodebuild test` suite passing on the **iPhone 17 Pro** simulator (the old `iPhone 15` sim referenced in v1 docs no longer exists — use iPhone 17 Pro).

**Remaining work is on-device only**: Jon is testing v2 on Katy's iPhone and will open a fresh session if more fixes are needed.

## What changed this session

Two phases, both on `main`:

**1. Content revisions** (per `docs/superpowers/plans/2026-06-15-nyc-trip-app-revisions.md`, spec at `docs/superpowers/specs/2026-06-15-nyc-trip-app-revisions-design.md`):
- 5 swipe-past **subway-option screens** (Penn→hotel, hotel→Sunday Morning, →Museum, Canal→hotel, hotel→Penn) with verified routes (E/F tunnel swap, R/W-only to Prince St, 5 Av/53 St morning closure).
- **Taxi-first** ride model ("Hail a cab" primary, Uber = "Backup: open Uber" / "Cab or Uber").
- Day 3 breakfast: **walk + Starbucks** options; **Museum → 11:30am**; **detailed SoHo/Canal** route screens; **Brandy Melville** added to Day 2.
- Screen count **31 → 37**. Two Codex `codex exec` adversarial rounds (7 findings, all resolved + confirmed). Reviews saved in `docs/superpowers/reviews/`.

**2. Layout pass** (from Katy's walkthrough — all verified screen-by-screen in the simulator):
- **Truncation fix**: long subtitles were shrinking because `StepView`'s shared `Text` uses `minimumScaleFactor` + a low `lineLimit`. Raised `lineLimit` 5→11 / floor 0.7→0.85, and added a **`Step.hidesHero`** flag that removes the hero image on the 5 subway screens + SoHo + Canal so full text renders at the base 19pt.
- Adopted a **Sunday-verified Penn→hotel** subway copy (E to 5 Av/53 St, toward Queens/Jamaica Center, 20–25 min with luggage). The E is 24/7 so Sunday is fine; weekday 5 Av/53 St closure doesn't apply Sunday.
- Fixed a truncated CTA label: "Walk there (Google Maps)" → "Walk it (Google Maps)".
- Day 3 order: **Museum is 3 of 11, its subway screen is 4 of 11** (a swap was tried then reverted at Jon's request). Every leg now reads "swipe forward for subway instructions."
- Added a **DEBUG-only `START_INDEX` env override** in `TripView` for simulator layout verification: `SIMCTL_CHILD_START_INDEX=N xcrun simctl launch booted com.jonathanhering.NYCTrip2026` jumps straight to a screen (`#if DEBUG`, never ships). In this app `Trip.allSteps` index == step id for ids 0–35.

## Pending (Jon's actions)

1. **On-device test** v2 on Katy's iPhone: Xcode → her phone → ⌘R. Swipe all 37 screens; confirm footers count …of 9/9/11/6, subway screens read fully (no truncation), Museum shows 11:30am at 3 of 11, Day-4 Penn subway shows both entrance buttons.
2. **Pre-trip**: install Google Maps / Uber / NJ Transit Mobile on Katy's phone; buy round-trip Metropark↔NY Penn MyTix tickets in advance.
3. **Check mta.info weekend advisories for Sun 6/21** — the only residual subway risk (Day 1 E leg is on a weekend; the E sometimes gets rerouted for planned weekend work).

## Key references

- `docs/LEARNINGS.md` — SwiftUI / Xcode / **simulator** gotchas (the `minimumScaleFactor` shrink, the `SIMCTL_CHILD_` deterministic-launch technique, the screenshot-dialog `simctl erase` fix).
- Content lives entirely in `NYCTrip2026/NYCTrip2026/Content/Trip.swift`; layout in `Views/StepView.swift`; model flag in `Models/Step.swift`.

## Starter prompt

```text
NYC Trip 2026 companion iOS app — v2 revisions + layout pass complete and pushed (main @ 59bb163), 2026-06-15.

Read first: HANDOFF.md

Status: 37 screens, tests green on iPhone 17 Pro sim, all subway/route screens verified untruncated in the simulator. Remaining work is on-device testing on Katy's iPhone.

If Jon reports an on-device display issue: reproduce it in the simulator first via
  SIMCTL_CHILD_START_INDEX=<id> xcrun simctl launch booted com.jonathanhering.NYCTrip2026
(allSteps index == step id), screenshot with `xcrun simctl io booted screenshot`, then fix in Trip.swift / StepView.swift.
```
