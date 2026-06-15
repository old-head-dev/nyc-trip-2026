# NYC Trip 2026 — App Revisions Design

**Date:** 2026-06-15
**Status:** Awaiting user review
**Scope:** Content/structure revisions to the existing SwiftUI app after Katy walked through v1. No architecture changes.

## Trip dates (confirmed day-of-week, matters for subway service)

- **Day 1 — Sun Jun 21** (arrival)
- **Day 2 — Mon Jun 22**
- **Day 3 — Tue Jun 23**
- **Day 4 — Wed Jun 24** (departure)

Only Day 1's subway leg falls on a weekend (Sunday). It uses the **E train**, which runs 7 days/week, so weekend-only service gaps (the W train) don't affect it. Day 3 and Day 4 legs are weekdays = full service. **Action: verify mta.info "Weekender" for Sun 6/21 before the trip** — that's the one residual subway risk research can't lock down in advance.

## Goals

1. Add **subway** as an option on specific legs, via dedicated swipe-past screens.
2. Reframe rides: **hail a yellow cab is the primary plan; Uber is the backup.**
3. Add a **walking** option + a **Starbucks** alternative to the Day 3 breakfast.
4. **Move Museum of Ice Cream to 11:30am** and reorder Day 3 around it.
5. Add **detailed SoHo and Canal Street** shopping-route screens.
6. Add **Brandy Melville** to Day 2 (Upper East Side).

## Architecture (unchanged)

Linear paged `TabView` of `Step`s defined in `Content/Trip.swift`. There is **no branching navigation** — "optional" screens are just screens the user swipes *past*. Subway screens, the Starbucks alternative, etc. are all ordinary `Step`s. The `Step` model, `StepView`, `DeepLinker`, and CTA types are reused as-is. No new types needed; all CTAs use existing `.openInGoogleMaps` / `.openInUber` cases.

**Screen-count impact:** 31 → **37** screens (Welcome + Day1 9 + Day2 9 + Day3 11 + Day4 6 + Closing).

## Cross-cutting change: taxi-first ride treatment

Every screen that currently offers Uber changes so the **primary action is hailing a yellow cab** (a physical action, described in copy) and **Uber is a clearly-labeled backup button** (keeps the existing `.openInUber` deep link with its verified coordinates).

- **Dedicated ride screens** (single mode): headline becomes "Hail a yellow cab to X"; the one CTA is relabeled **"Backup: open Uber."**
- **Two-mode walk/ride screens** (Day 2): the ride button is relabeled **"Cab or Uber"** (still deep-links to Uber as the bookable fallback); the "Walk it (Google Maps)" button is unchanged. Layout cap of 2 CTAs is respected.

## Cross-cutting pattern: subway screens

Each subway leg adds one dedicated `Step` placed adjacent to that leg's existing screen. Plain-language, reassuring instructions in the subtitle; `subway_train` hero (reused); a Google Maps CTA to the relevant station. She swipes to it if taking the subway, past it otherwise.

All routes below are **drafts pending user verification** (subway accuracy is the highest-stakes content in the app).

### The six subway legs

**A) Penn Station → The Jewel Hotel** — *Day 1, Sun*
> Inside Penn, follow signs to the **8th Ave "A C E"** subway. Take the **uptown E train** (toward Queens) **3 stops to 5 Av/53 St.** Exit and walk south on 5th Ave to 51st St, turn right — the hotel is mid-block. ~15–20 min.
> CTA: *Open in Google Maps → The Jewel Hotel, 11 W 51st St, New York, NY* (for the short walk from the exit; she's already inside Penn so the boarding station needs no link).

**B) The Jewel Hotel → Sunday Morning Bakehouse** — *Day 3, Tue*
> Walk to **47–50 Sts–Rockefeller Center** (6th Ave). Take a **downtown F or M train 3 stops to 23 St.** Exit at 23rd & 6th, walk north to 25th St, turn right — bakery is mid-block. ~15 min.
> CTA: *Open in Google Maps → 47-50 Sts–Rockefeller Center (B/D/F/M), New York, NY*

**C) → Museum of Ice Cream** (serves both breakfast paths) — *Day 3, Tue*
> Take the **downtown N or R (yellow) train on Broadway to Prince St** — the museum is steps from the exit. **From Sunday Morning, board at 28 St. From the hotel/Starbucks, board at 49 St.** Same line, same direction. ~15–20 min.
> CTAs (2): *From breakfast → 28 St Station (R/W), Broadway, NY* · *From the hotel → 49 St Station (N/R/W), New York, NY*

**D) Canal St → The Jewel Hotel** — *Day 3, Tue*
> At Broadway & Canal, take the **uptown N or R train to 49 St** (~6 stops). Exit at 7th Ave & 49th, walk north to 51st, turn right. ~22–25 min. *(Use N or R specifically — not the Q.)*
> CTA: *Open in Google Maps → Canal St Station (N/R), Broadway, New York, NY*

**E) The Jewel Hotel → Penn Station** — *Day 4, Wed*
> Walk to **5 Av/53 St** (E/M). Take a **downtown E train 3 stops to 34 St–Penn Station** — it drops you right inside the Penn complex. ~15–20 min.
> CTA: *Open in Google Maps → 5 Av/53 St Station (E/M), New York, NY*

## Full screen sequence

Legend: **[NEW]** added · **[CHG]** changed · **[OPT]** swipe-past optional · *(unch)* unchanged

### Day 1 — Sun Jun 21 (9 screens)
1. Drive to Metropark *(unch)*
2. Park in garage *(unch)*
3. Train to Penn Station — NJ Transit *(unch)*
4. **[CHG]** **Hail a cab to The Jewel Hotel** — subtitle notes ~15 min ride; CTA *Backup: open Uber* (existing hotel coords)
5. **[NEW][OPT]** Subway: Penn → The Jewel Hotel (Leg A)
6. Check in at The Jewel Hotel (reservation) *(unch)*
7. Dinner at Joe's Pizza *(unch)*
8. Times Square *(unch)*
9. Return to The Jewel Hotel *(unch)*

### Day 2 — Mon Jun 22 (9 screens)
1. Breakfast at Blue Box Café (reservation) *(unch)*
2. Jellycat Diner at FAO Schwarz (reservation) *(unch)*
3. Grand Central Terminal *(unch)*
4. **[NEW]** **Brandy Melville** — 1172 3rd Ave (68th & 3rd, UES). Slots here: coming north from Grand Central you reach Brandy (68th) before Via Quadronno (73rd) before the park. CTA: *Open in Google Maps* (walk) — UES is walkable from Grand Central, or a short cab.
5. **[CHG]** (optional) Lunch at Via Quadronno — ride button relabeled *Cab or Uber*
6. **[CHG]** Central Park — *Walk it (Maps)* / *Cab or Uber*
7. **[CHG]** Herald Square & Macy's — *Walk it (Maps)* / *Cab or Uber*
8. **[CHG]** Back to hotel before dinner — *Walk it (Maps)* / *Cab or Uber*
9. Dinner at TAO Uptown (reservation) *(unch)*

### Day 3 — Tue Jun 23 (11 screens) — reordered around the 11:30 museum
1. **[CHG]** Breakfast — **Sunday Morning** (cinnamon rolls). CTAs (2): *Walk there (Maps)* · *Starbucks instead (Maps)*. Subtitle: ~25-min walk or take the subway (next screen). *(No cab CTA here — walk/subway/Starbucks cover it within the 2-CTA cap.)*
2. **[NEW][OPT]** Subway: Hotel → Sunday Morning (Leg B)
3. **[CHG][moved]** **Museum of Ice Cream — 11:30am** (reservation, time updated). Subtitle: hail a cab (or subway, next screen). CTA: *Backup: open Uber*. *(Reservation + 1 CTA = within layout rules.)*
4. **[NEW][OPT]** Subway → Museum of Ice Cream (Leg C, two boarding points)
5. **[CHG][moved]** (optional) Lunch — Jack's Wife Freda, 226 Lafayette (steps from the museum). CTA: *Open in Google Maps*
6. **[CHG][detailed]** **SoHo shopping** — see route below. CTA: *Open in Google Maps* → start point
7. **[CHG][detailed]** **Canal Street** — see route below. CTA: *Open in Google Maps* → Pearl River Mart / Canal & Broadway
8. **[CHG]** Back to the hotel — **Hail a cab**; CTA *Backup: open Uber* (existing hotel coords)
9. **[NEW][OPT]** Subway: Canal St → Hotel (Leg D)
10. Evening walk, 5th & Madison *(unch)*
11. Dinner *(unch — still open-ended)*

### Day 4 — Wed Jun 24 (6 screens)
1. Breakfast at Liberty Bagels *(unch)*
2. Back to hotel to check out *(unch)*
3. **[CHG]** **Hail a cab to Penn Station** — CTA *Backup: open Uber* (existing Penn coords)
4. **[NEW][OPT]** Subway: Hotel → Penn Station (Leg E)
5. Take the train to Metropark — NJ Transit *(unch)*
6. ~10 hr drive home *(unch)*

## Shopping-route screen content (drafts)

**SoHo screen** (condensed from research; verified addresses):
> Start around **Prince & Mercer**, walk Prince → Greene → Spring → Wooster, dipping to Broadway for the big stores.
> Priority stops: **Aritzia** (560 Broadway — *relocated, use 560 not 524*), **MoMA Design Store** (81 Spring St), **Mure + Grand** (155 Spring St), **Pearl River Mart** (452 Broadway). **Supreme** now at 190 Bowery if it matters.
> Maps CTA → start point near Prince & Mercer (or Aritzia, 560 Broadway).

**Canal Street screen:**
> Start at **Broadway & Canal**, hit **Pearl River Mart** (452 Broadway — a few blocks north of Canal; the old Canal storefront is gone, this is the only location), then walk **east on Canal toward Lafayette/Centre** for the classic busy-Canal browse (souvenirs, accessories — fun to walk more than serious shopping).
> Maps CTA → Pearl River Mart, 452 Broadway (or Canal & Broadway).

## Open decisions for the user (surfaced by research)

1. **Which Starbucks?** Closest is **30 Rockefeller Plaza** (across 51st St, but it's a below-ground concourse store) vs. street-level **1290 Sixth Ave** (~3 blocks, easier to spot). Recommend **1290 Sixth Ave** for findability by someone new to the area. *Your call.*
2. **Kith** — the SoHo flagship reopened **men's-only**. For a mother/daughter afternoon, recommend **dropping it** from the SoHo list. *Your call.*
3. **Mure + Grand** confirmed real (boutique). Including the SoHo location (155 Spring St). OK?
4. **Pearl River Mart on the Canal leg** — there is no separate Canal storefront anymore; only 452 Broadway. Spec routes the Canal screen there. OK?

## Testing impact

- `TripContentTests` total-count assertion **31 → 37**.
- `dayLabelsMatchPosition` auto-derives "Day X · N of M" from position, so it self-corrects as long as the `Day X · N of M` format is preserved. All `dayLabel` strings get rewritten to the new per-day counts (Day1 …of 9, Day2 …of 9, Day3 …of 11, Day4 …of 6).
- CTA caps: every new/changed screen respects ≤2 CTAs, and ≤1 CTA when a reservation is present (verified screen-by-screen above).
- `DeepLinkerTests` / `TripContentTests` Uber-coordinate locks: existing Uber coords are **reused unchanged** (hotel, Penn). New subway CTAs are `.openInGoogleMaps` with station strings — no new coordinates to lock. New Maps destinations (Brandy Melville, Jack's Wife Freda, SoHo/Canal stores, Starbucks) are string-based.
- Re-run full `xcodebuild test`; build green + tests passing is necessary-not-sufficient — final check is on Katy's iPhone.

## Out of scope (explicitly)

- Real photographs of destinations — deferred to a later pass per user; illustrated heroes stay for now.
- The HTML trip-planning site (`index.html`, `nyc-trip-plan.html`) — untouched.
- Day 3 dinner remains open-ended (no change requested).
