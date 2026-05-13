# NYC Trip Plan — Hotel Booking Handoff

## Purpose

This document is for a future Claude session. The user has booked a hotel for the NYC trip and wants the HTML trip plan updated to reflect the specific hotel. The session should take the booked hotel details provided by the user and apply all relevant updates to `index.html`.

---

## Trip Overview

- **Travelers:** Wife + 16-year-old daughter (husband/father not going)
- **Dates:** June 21–24, 2026 (Saturday check-in, Tuesday check-out — 3 nights)
- **Arrival/departure:** NJ Transit from Metropark Station (Iselin, NJ) to NYC Penn Station/Moynihan Hall
- **Base:** Midtown Manhattan

---

## The HTML File

The live trip plan is published at:
**`https://old-head-dev.github.io/nyc-trip-2026/`**

The source file is `index.html` in the GitHub repo:
**`https://github.com/old-head-dev/nyc-trip-2026`**

The user works on a **MacBook Air M5** and uses **GitHub Desktop** to commit and push changes. Provide updated HTML as a downloadable file — do not just show code in the chat.

---

## What the User Will Provide

When starting the future session, the user will share:

1. **Hotel name**
2. **Full address** (including cross streets if known)
3. **Confirmed room type** (e.g., two double beds, two queen beds, suite)
4. **Nightly rate** and whether any mandatory fees apply
5. **Check-in time**
6. **Any notable amenities** (breakfast included, rooftop, gym, etc.)
7. **Neighborhood** (e.g., Midtown East, Times Square, Murray Hill)

---

## What Needs to Be Updated in the HTML

### 1. Hotel Recommendations Section
- Mark the booked hotel as **BOOKED** — visually distinguish it from the other options (e.g., different border color, a "✓ Booked" badge replacing the tag label)
- Update the hotel-why text for the booked hotel to past tense / confirmation language
- The other 10 hotels can remain as reference but should be visually de-emphasized or retain their current format

### 2. Booking Checklist
- The hotel checklist item (currently: *"Now — Hotel for June 21–24..."*) should be updated to show the booked hotel name, price, and a checkmark/strikethrough to indicate it's done

### 3. Day 1 Itinerary — Arrival
- The "Check In to Hotel" timeline item currently says: *"Check into your hotel — drop bags, freshen up, orient to the neighborhood."*
- Update with the **specific hotel name and address**
- Add neighborhood context (e.g., *"You're in Midtown East — Grand Central is a 7-minute walk"*)
- If the hotel has a notable amenity relevant to arrival (rooftop bar, restaurant, etc.), mention it as a first-night option

### 4. Day 4 Itinerary — Checkout
- The "Check Out & Breakfast" item currently says: *"Grab breakfast near the hotel before checkout."*
- Update with a **specific breakfast recommendation** near the booked hotel's actual address (currently suggests Junior's at Broadway & 45th — this may or may not be appropriate depending on where the hotel is)
- Update checkout logistics if relevant (e.g., if hotel is far from Penn Station, note Uber time/cost)

### 5. Getting Around Section
- The logistic card *"Getting Around NYC"* mentions the itinerary clusters within a 2-mile Midtown radius
- If the booked hotel is at the edge of that radius (e.g., Murray Hill at 37th St), update the walking guidance accordingly
- Update any specific distance references if they're materially different from a Times Square baseline

### 6. Safety Notes
- The neighborhood reality card says *"The entire itinerary — Times Square, 5th Ave, Rockefeller, Central Park, Herald Square, Grand Central — is in one of the most heavily policed tourist corridors on earth."*
- If the hotel is in a neighborhood not listed (e.g., Murray Hill), add it to that sentence so the wife knows her immediate surroundings are equally safe

### 7. Hero Stats (Optional)
- Currently shows: 3 Nights / ~640 Miles Each Way / 2 Travelers
- No change needed unless the user wants to add the hotel name somewhere in the hero

---

## Top 11 Hotel Reference (Already Researched)

Do not re-research these hotels. All research is complete. The list below is reference only in case the session needs to understand which hotel was booked and what is already known about it.

| Rank | Hotel | Address | Price | Effective | Stars | Google |
|------|-------|---------|-------|-----------|-------|--------|
| 1 | EVEN Hotel Midtown East by IHG | 221 E 44th St | $327 | $327 | ⭐⭐⭐⭐⭐ | 4.2 |
| 2 | Fitzpatrick Grand Central | 141 E 44th St | $305 | $305 | ⭐⭐⭐⭐⭐ | 4.3 |
| 3 | Shelburne Sonesta New York | 303 Lexington Ave @ 37th | $271 | ~$313 w/ $42 fee | ⭐⭐⭐⭐⭐ | 4.2 |
| 4 | 3 West Club | 3 W 51st St | $332 | $332 | ⭐⭐⭐⭐⭐ | 4.4 |
| 5 | Hilton New York Times Square | 234 W 42nd St | $327 | $327 | ⭐⭐⭐⭐ | 4.1 |
| 6 | HGI Times Square South | W 37th St area | $346 | $346+ | ⭐⭐⭐⭐ | 4.2 |
| 7 | HGI Midtown Park Ave | 45 E 33rd St | $346 | $346+ | ⭐⭐⭐⭐ | 4.2 |
| 8 | Hampton Inn Times Square Central | 220 W 41st St | $333 | $333 | ⭐⭐⭐ | 4.3 |
| 9 | Holiday Inn Times Square | W 48th St area | $295 | $295 | ⭐⭐⭐⭐ | 4.1 |
| 10 | BW Premier Empire State | Midtown | $328 | $328 | ⭐⭐⭐ | 4.3 |
| 11 | BW Premier Herald Square | 50 W 36th St | $253 | $253 | ⭐⭐⭐ | 4.4 |

**Key notes on specific hotels:**
- **Shelburne Sonesta (#3):** Mandatory $42/night Hotel Facilities Fee — confirm it is captured in the booking total. Murray Hill neighborhood.
- **3 West Club (#4):** Only 28 rooms — if booked, availability was the primary uncertainty going in. Historic 1921 suffragette-founded building, steps from Rockefeller Center.
- **Hilton Times Square (#5):** All rooms start on 22nd floor. 4.1 is borderline per original criteria but confirmed and accepted.
- **HGI properties (#6, #7):** Verify no mandatory destination fee was added at check-in.
- **Hampton Inn (#8):** Only hotel in the list with complimentary hot breakfast included.
- **BW Herald Square (#11):** $253 and Google 4.4 — best pure value if two-bed config confirmed.

---

## Itinerary Context for the Updating Session

The itinerary is built around these anchor locations:
- **Day 1:** Times Square / Broadway area (evening arrival and orientation)
- **Day 2:** 5th Avenue → Rockefeller Center → Top of the Rock → Times Square → Broadway show (optional)
- **Day 3:** Central Park → Upper East Side → Serendipity 3 → Chelsea Market
- **Day 4:** Checkout → Penn Station → NJ Transit → drive home

Walking distances and Uber recommendations in the HTML are currently written from a general Midtown baseline. If the booked hotel is in Murray Hill (37th & Lex) or Midtown East (44th St), the updating session should adjust any walking time or transit references that would be materially different — particularly for Day 1 arrival orientation and Day 4 Penn Station departure.

---

## Style Reference

The HTML uses these CSS variables — maintain them in any added content:
- `--gold: #c9973a` — section labels, highlights, top-pick borders
- `--rust: #b85c38` — urgent/alert elements
- `--sage: #6b7c6e` — secondary tags, optional badges
- `--ink: #1a1714` — primary text
- `--muted: #7a7570` — secondary/descriptive text
- `--cream: #f7f3ee` — page background
- Fonts: `Playfair Display` (headers/names) and `DM Sans` (body)

For a "BOOKED" badge, suggest using the rust color (`--rust`) with white text, consistent with the urgent/confirmed styling used elsewhere in the document.

---

*Handoff prepared May 2026. Research complete. Hotel booking pending.*
