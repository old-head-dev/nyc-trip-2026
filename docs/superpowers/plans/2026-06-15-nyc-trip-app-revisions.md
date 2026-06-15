# NYC Trip 2026 App Revisions — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Apply the approved trip revisions (subway options, taxi-first rides, Day 3 reorder around the 11:30 museum, detailed SoHo/Canal route screens, Brandy Melville) to the existing SwiftUI app, growing it from 31 to 37 screens with all tests green and a Codex adversarial review.

**Architecture:** All trip content lives in one file, `Content/Trip.swift`, as a hardcoded `[Step]` array rendered by a linear paged `TabView`. There is no branching navigation — "optional" screens are ordinary `Step`s the user swipes past. No model, view, or `DeepLinker` changes are needed; every new CTA uses existing `.openInGoogleMaps` / `.openInUber` cases. Content-integrity tests in `TripContentTests.swift` lock the screen count, the Uber destination/coordinate set, the ≤2-CTA and reservation-layout invariants, and auto-derive `dayLabel` correctness from position.

**Tech Stack:** Swift / SwiftUI, Swift Testing (`@Test`), `xcodebuild`, Codex CLI (`codex exec`) for review.

**Workflow note:** Per project preference (memory `feedback_workflow.md`), commit directly to `main`, no PR. Adding screens makes the *old* `count == 31` assertion fail immediately, so intermediate commits (Tasks 2–5) will have a red count test — this is expected; the suite goes green at Task 6. The app is rebuilt onto Katy's phone manually from Xcode only after this is all done, so intermediate states never reach the device.

**Authoritative source of content:** `docs/superpowers/specs/2026-06-15-nyc-trip-app-revisions-design.md`. The verified subway directions and resolved decisions there are the ground truth — this plan transcribes them into Swift.

---

## File Structure

- **Modify:** `NYCTrip2026/NYCTrip2026/Content/Trip.swift` — rewrite `day1`/`day2`/`day3`/`day4` arrays; renumber `id`s 1–35 sequentially; rewrite all `dayLabel`s to new per-day counts. Welcome stays `id: 0`, closing stays `id: 999`.
- **Modify:** `NYCTrip2026/NYCTrip2026Tests/TripContentTests.swift` — update total count 31→37 and the Uber destination/coordinate dictionary (drop Sunday Morning + SoHo, add Museum of Ice Cream).
- **No changes:** `Models/Step.swift`, `Models/DeepLinker.swift`, all Views, `DeepLinkerTests.swift` (its Uber tests use literal fixtures, not Trip content), `StepTests.swift` (its `"Day 1 · 1 of 8"` is a model fixture, not asserted against Trip — leave as-is).

**New `id` map:** Day 1 = 1–9, Day 2 = 10–18, Day 3 = 19–29, Day 4 = 30–35. Total content steps 35 + welcome + closing = 37.

**Reservations to preserve verbatim** (only the Museum changes):
- Jewel check-in: `time: "Check-in after 3pm"`, `address: "11 W 51st St, across from Rockefeller Center"`, `confirmation: "Expedia itinerary #73447998588498"`, `extra: "Superior Room - reserved under Katy Hering"`
- Blue Box: `time: "10:00am (arrive by 10:15)"`, `address: "727 5th Ave - 6th Floor of Tiffany & Co."`, `confirmation: "Reserved under Katy Hering"`, `extra: "Breakfast for 2"`
- Jellycat: `time: "11:50am"`, `address: "30 Rockefeller Plaza, FAO Schwarz building"`, `confirmation: "Booking #351207910"`, `extra: "Arrive 11:30-12:00 (no later than 12:00)"`
- TAO: `time: "6:30pm (must arrive by 6:45)"`, `address: "42 E 58th St"`, `confirmation: "Confirmation #: 2112064704"`, `extra: nil`
- Museum (CHANGED time): `time: "11:30am reservation"`, `address: "558 Broadway, at Prince St (SoHo)"`, `confirmation: "Booking ID: FJ9*YPFVFMP*"`, `extra: "Mobile ticket (email). Waivers are signed."`

---

### Task 1: Update content-integrity tests to the new target

**Files:**
- Modify: `NYCTrip2026/NYCTrip2026Tests/TripContentTests.swift:46-56` (Uber dict) and `:82-85` (count)

- [ ] **Step 1: Update the Uber destination/coordinate dictionary**

Replace the `expected` dictionary (lines 48-56) with — drops Sunday Morning + SoHo (no longer have Uber CTAs), adds the Museum (gains an Uber-backup CTA):

```swift
        let expected: [String: (latitude: Double, longitude: Double)] = [
            "The Jewel Hotel, 11 W 51st St, New York, NY": (40.7597381, -73.9777528),
            "Via Quadronno, 25 E 73rd St, New York, NY": (40.7727446, -73.9651572),
            "Bethesda Fountain, Central Park, New York, NY": (40.774122, -73.971136),
            "Macy's Herald Square, 151 W 34th St, New York, NY": (40.750797, -73.989578),
            "Museum of Ice Cream, 558 Broadway, New York, NY": (40.7238545, -73.9979167),
            "Penn Station, 31st St & 8th Ave, New York, NY": (40.750568, -73.994235)
        ]
```

- [ ] **Step 2: Update the total-count test (title + assertion)**

Replace lines 82-85:

```swift
    @Test("Total step count is 37 (welcome + 35 + closing)")
    func totalCount() {
        #expect(Trip.allSteps.count == 37)
    }
```

- [ ] **Step 3: Confirm tests now FAIL against unchanged content (defines the target)**

Run: `xcodebuild test -project NYCTrip2026/NYCTrip2026.xcodeproj -scheme NYCTrip2026 -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:NYCTrip2026Tests/TripContentTests 2>&1 | tail -30`
Expected: FAIL — `totalCount` (31 ≠ 37) and `uberCoordinatesMatchDestinations` (Sunday Morning/SoHo still present, Museum absent). This is correct; content tasks below make it pass.

- [ ] **Step 4: Commit**

```bash
git add NYCTrip2026/NYCTrip2026Tests/TripContentTests.swift
git commit -m "test: set content-integrity targets for trip revisions (37 screens, new Uber set)"
```

---

### Task 2: Rewrite Day 1 (cab-first arrival + Penn→hotel subway screen)

**Files:**
- Modify: `NYCTrip2026/NYCTrip2026/Content/Trip.swift` — replace the entire `static let day1: [Step] = [...]` block

- [ ] **Step 1: Replace the `day1` array**

```swift
    static let day1: [Step] = [
        step(id: 1, day: 1, dayLabel: "Day 1 · 1 of 9",
             hero: "sedan_car", title: "Drive to\nMetropark Station",
             subtitle: "~10 hr drive to Iselin, NJ",
             ctas: [.openInGoogleMaps(destination: "Metropark Station, Iselin, NJ", label: "Open in Google Maps")],
             palette: mistBlue),

        step(id: 2, day: 1, dayLabel: "Day 1 · 2 of 9",
             hero: "sedan_car", title: "Park in the Metropark parking garage",
             subtitle: "No ticket required. Just drive in.",
             palette: butterCream),

        step(id: 3, day: 1, dayLabel: "Day 1 · 3 of 9",
             hero: "subway_train", title: "Train to Penn Station",
             subtitle: "Northeast Corridor line ~35-50 min\n\nActivate your tickets at the platform.",
             ctas: [.openNJTransit(label: "Open NJ Transit app")],
             palette: sageCream),

        step(id: 4, day: 1, dayLabel: "Day 1 · 4 of 9",
             hero: "uber_car", title: "Hail a cab to\nThe Jewel Hotel",
             subtitle: "~15 min ride to 11 W 51st St.\nGrab a yellow cab outside Penn — or use Uber as a backup.",
             ctas: [.openInUber(destination: "The Jewel Hotel, 11 W 51st St, New York, NY", latitude: 40.7597381, longitude: -73.9777528, label: "Backup: open Uber")],
             palette: clay),

        step(id: 5, day: 1, dayLabel: "Day 1 · 5 of 9",
             hero: "subway_train", title: "Or take the subway\nto the hotel",
             subtitle: "Inside Penn, follow signs to the 8th Ave A·C·E subway.\n\nTake the uptown E train only (toward Queens) — not the A or C — 4 stops to 5 Av/53 St.\n\nExit toward 5th Ave, walk south to 51st St, turn right.",
             ctas: [.openInGoogleMaps(destination: "The Jewel Hotel, 11 W 51st St, New York, NY", label: "Open hotel in Google Maps")],
             palette: mistBlue),

        step(id: 6, day: 1, dayLabel: "Day 1 · 6 of 9",
             hero: "hotel_building", title: "Check in at\nThe Jewel Hotel",
             reservation: ReservationDetail(
                time: "Check-in after 3pm",
                address: "11 W 51st St, across from Rockefeller Center",
                confirmation: "Expedia itinerary #73447998588498",
                extra: "Superior Room - reserved under Katy Hering"
             ),
             palette: peach),

        step(id: 7, day: 1, dayLabel: "Day 1 · 7 of 9",
             hero: "dinner", title: "Dinner at\nJoe's Pizza",
             subtitle: "~15-20 min walk to 1435 Broadway\n\nWalk to Times Square after... or walk through Times Square to get there",
             ctas: [.openInGoogleMaps(destination: "Joe's Pizza, 1435 Broadway, New York, NY", label: "Open in Google Maps")],
             palette: dustyRose),

        step(id: 8, day: 1, dayLabel: "Day 1 · 8 of 9",
             hero: "times_square", title: "Times Square",
             subtitle: "Very short walk from Joe's.\nBest at night when the lights are full.",
             ctas: [.openInGoogleMaps(destination: "Times Square, New York, NY", label: "Open in Google Maps")],
             palette: butterCream),

        step(id: 9, day: 1, dayLabel: "Day 1 · 9 of 9",
             hero: "hotel_building", title: "Return to\nThe Jewel Hotel",
             subtitle: "Open Google Maps for directions from wherever you are",
             ctas: [.openInGoogleMaps(destination: "The Jewel Hotel, 11 W 51st St, New York, NY", label: "Open in Google Maps")],
             palette: wisteria),
    ]
```

- [ ] **Step 2: Build to verify it compiles**

Run: `xcodebuild build -project NYCTrip2026/NYCTrip2026.xcodeproj -scheme NYCTrip2026 -destination 'platform=iOS Simulator,name=iPhone 15' 2>&1 | tail -5`
Expected: `** BUILD SUCCEEDED **`

- [ ] **Step 3: Commit**

```bash
git add NYCTrip2026/NYCTrip2026/Content/Trip.swift
git commit -m "feat: Day 1 — cab-first arrival + Penn→hotel subway screen (9 screens)"
```

---

### Task 3: Rewrite Day 2 (add Brandy Melville, cab-or-Uber relabels)

**Files:**
- Modify: `NYCTrip2026/NYCTrip2026/Content/Trip.swift` — replace the entire `static let day2: [Step] = [...]` block

- [ ] **Step 1: Replace the `day2` array**

```swift
    static let day2: [Step] = [
        step(id: 10, day: 2, dayLabel: "Day 2 · 1 of 9",
             hero: "breakfast", title: "Breakfast at\nBlue Box Café",
             subtitle: "8-min walk from the hotel.",
             reservation: ReservationDetail(
                time: "10:00am (arrive by 10:15)",
                address: "727 5th Ave - 6th Floor of Tiffany & Co.",
                confirmation: "Reserved under Katy Hering",
                extra: "Breakfast for 2"
             ),
             ctas: [.openInGoogleMaps(destination: "Tiffany & Co., 727 5th Ave, New York, NY", label: "Open in Google Maps")],
             palette: cream),

        step(id: 11, day: 2, dayLabel: "Day 2 · 2 of 9",
             hero: "jellycat", title: "Jellycat Diner\nat FAO Schwarz",
             subtitle: "10-min walk from Breakfast.",
             reservation: ReservationDetail(
                time: "11:50am",
                address: "30 Rockefeller Plaza, FAO Schwarz building",
                confirmation: "Booking #351207910",
                extra: "Arrive 11:30-12:00 (no later than 12:00)"
             ),
             ctas: [.openInGoogleMaps(destination: "FAO Schwarz, 30 Rockefeller Plaza, New York, NY", label: "Open in Google Maps")],
             palette: blush),

        step(id: 12, day: 2, dayLabel: "Day 2 · 3 of 9",
             hero: "train_station", title: "Visit Grand\nCentral Terminal",
             subtitle: "15-min walk from Jellycat\n(or skip ahead to Brandy Melville)",
             ctas: [.openInGoogleMaps(destination: "Grand Central Terminal, 89 E 42nd St, New York, NY", label: "Open in Google Maps")],
             palette: butterCream),

        step(id: 13, day: 2, dayLabel: "Day 2 · 4 of 9",
             hero: "nyc_shopping", title: "Brandy Melville",
             subtitle: "1172 3rd Ave (68th & 3rd), Upper East Side\n~15-min walk up from Grand Central, or a short cab.",
             ctas: [.openInGoogleMaps(destination: "Brandy Melville, 1172 3rd Ave, New York, NY", label: "Open in Google Maps")],
             palette: dustyRose),

        step(id: 14, day: 2, dayLabel: "Day 2 · 5 of 9",
             hero: "lunch", title: "OPTIONAL: Lunch at\nVia Quadronno",
             subtitle: "25 E 73rd St\n(steps from Central Park east entrance)",
             ctas: [.openInUber(destination: "Via Quadronno, 25 E 73rd St, New York, NY", latitude: 40.7727446, longitude: -73.9651572, label: "Cab or Uber")],
             palette: clay),

        step(id: 15, day: 2, dayLabel: "Day 2 · 6 of 9",
             hero: "central_park_spring", title: "Visit Central Park",
             subtitle: "(or skip back to the Upper East Side)\n\nDepending where you are,\nwalk (Google Maps) or grab a cab / Uber.",
             ctas: [
                .openInGoogleMaps(destination: "Bethesda Fountain, Central Park, New York, NY", label: "Walk it (Google Maps)"),
                .openInUber(destination: "Bethesda Fountain, Central Park, New York, NY", latitude: 40.774122, longitude: -73.971136, label: "Cab or Uber")
             ],
             palette: sageCream),

        step(id: 16, day: 2, dayLabel: "Day 2 · 7 of 9",
             hero: "nyc_shopping", title: "Herald Square\n& Macy's",
             subtitle: "Cab or Uber from Central Park\nor 20-min walk from Grand Central.",
             ctas: [
                .openInGoogleMaps(destination: "Macy's Herald Square, 151 W 34th St, New York, NY", label: "Walk it (Google Maps)"),
                .openInUber(destination: "Macy's Herald Square, 151 W 34th St, New York, NY", latitude: 40.750797, longitude: -73.989578, label: "Cab or Uber")
             ],
             palette: dustyRose),

        step(id: 17, day: 2, dayLabel: "Day 2 · 8 of 9",
             hero: "hotel_building", title: "Back to hotel\nbefore dinner",
             subtitle: "25-minute walk from Macy's\nor grab a cab / Uber.",
             ctas: [
                .openInGoogleMaps(destination: "The Jewel Hotel, 11 W 51st St, New York, NY", label: "Walk it (Google Maps)"),
                .openInUber(destination: "The Jewel Hotel, 11 W 51st St, New York, NY", latitude: 40.7597381, longitude: -73.9777528, label: "Cab or Uber")
             ],
             palette: wisteria),

        step(id: 18, day: 2, dayLabel: "Day 2 · 9 of 9",
             hero: "dinner", title: "Dinner at\nTAO Uptown",
             subtitle: "~13-min walk from hotel.",
             reservation: ReservationDetail(
                time: "6:30pm (must arrive by 6:45)",
                address: "42 E 58th St",
                confirmation: "Confirmation #: 2112064704",
                extra: nil
             ),
             ctas: [.openInGoogleMaps(destination: "TAO Uptown, 42 E 58th St, New York, NY", label: "Open in Google Maps")],
             palette: dustyRose),
    ]
```

- [ ] **Step 2: Build to verify it compiles**

Run: `xcodebuild build -project NYCTrip2026/NYCTrip2026.xcodeproj -scheme NYCTrip2026 -destination 'platform=iOS Simulator,name=iPhone 15' 2>&1 | tail -5`
Expected: `** BUILD SUCCEEDED **`

- [ ] **Step 3: Commit**

```bash
git add NYCTrip2026/NYCTrip2026/Content/Trip.swift
git commit -m "feat: Day 2 — add Brandy Melville (UES), relabel rides cab-or-Uber (9 screens)"
```

---

### Task 4: Rewrite Day 3 (the big reorder — breakfast/Starbucks, museum 11:30, subway screens, detailed SoHo/Canal)

**Files:**
- Modify: `NYCTrip2026/NYCTrip2026/Content/Trip.swift` — replace the entire `static let day3: [Step] = [...]` block

- [ ] **Step 1: Replace the `day3` array**

```swift
    static let day3: [Step] = [
        step(id: 19, day: 3, dayLabel: "Day 3 · 1 of 11",
             hero: "breakfast", title: "Cinnamon rolls at\nSunday Morning",
             subtitle: "11 W 25th St · about a 25-min walk, or take the subway (next screen).\n\nNot feeling the walk? Grab Starbucks near the hotel instead.",
             ctas: [
                .openInGoogleMaps(destination: "Sunday Morning Bakehouse, 11 W 25th St, New York, NY 10010", label: "Walk there (Google Maps)"),
                .openInGoogleMaps(destination: "Starbucks, 1290 Sixth Avenue, New York, NY", label: "Starbucks instead")
             ],
             palette: butterCream),

        step(id: 20, day: 3, dayLabel: "Day 3 · 2 of 11",
             hero: "subway_train", title: "Subway option:\nhotel → Sunday Morning",
             subtitle: "Walk to 47–50 Sts–Rockefeller Center (6th Ave).\n\nTake a downtown F or M train only — not B or D — 3 stops to 23 St.\n\nWalk north to 25th St, turn right.",
             ctas: [.openInGoogleMaps(destination: "47-50 Sts–Rockefeller Center Station, New York, NY", label: "Open station in Google Maps")],
             palette: mistBlue),

        step(id: 21, day: 3, dayLabel: "Day 3 · 3 of 11",
             hero: "ice_cream_cone", title: "Museum of\nIce Cream",
             subtitle: "Hail a cab from breakfast — or take the subway (next screen).",
             reservation: ReservationDetail(
                time: "11:30am reservation",
                address: "558 Broadway, at Prince St (SoHo)",
                confirmation: "Booking ID: FJ9*YPFVFMP*",
                extra: "Mobile ticket (email). Waivers are signed."
             ),
             ctas: [.openInUber(destination: "Museum of Ice Cream, 558 Broadway, New York, NY", latitude: 40.7238545, longitude: -73.9979167, label: "Backup: open Uber")],
             palette: dustyRose),

        step(id: 22, day: 3, dayLabel: "Day 3 · 4 of 11",
             hero: "subway_train", title: "Subway option:\nto the museum",
             subtitle: "Take the downtown R or W train only to Prince St — NOT the N or Q (they skip Prince St). The museum is steps from the exit.\n\nFrom Sunday Morning, board at 23 St. From the hotel/Starbucks, board at 49 St.",
             ctas: [
                .openInGoogleMaps(destination: "23 St Station (R/W), Broadway & W 23rd St, New York, NY", label: "From breakfast: 23 St"),
                .openInGoogleMaps(destination: "49 St Station (R/W), W 49th St & 7th Ave, New York, NY", label: "From the hotel: 49 St")
             ],
             palette: mistBlue),

        step(id: 23, day: 3, dayLabel: "Day 3 · 5 of 11",
             hero: "lunch", title: "OPTIONAL: Lunch at\nJack's Wife Freda",
             subtitle: "226 Lafayette St · steps from the museum.\nMediterranean-American, casual.",
             ctas: [.openInGoogleMaps(destination: "Jack's Wife Freda, 226 Lafayette St, New York, NY", label: "Open in Google Maps")],
             palette: cream),

        step(id: 24, day: 3, dayLabel: "Day 3 · 6 of 11",
             hero: "nyc_shopping", title: "SoHo shopping",
             subtitle: "Start around Prince & Mercer. Walk Prince → Greene → Spring → Wooster — the classic cobblestone boutique blocks — dipping over to Broadway for the bigger stores.\n\nWorth a look: Aritzia (560 Broadway), MoMA Design Store (81 Spring), Mure + Grand (155 Spring), Pearl River Mart (452 Broadway).",
             ctas: [.openInGoogleMaps(destination: "Prince St & Mercer St, New York, NY", label: "Open start point in Maps")],
             palette: blush),

        step(id: 25, day: 3, dayLabel: "Day 3 · 7 of 11",
             hero: "nyc_shopping", title: "Canal Street",
             subtitle: "Start at Broadway & Canal, then walk east on Canal toward Lafayette/Centre.\n\nThe classic busy-Canal stretch — crowded sidewalks, souvenir shops, bargain finds. A fun browse more than serious shopping.",
             ctas: [.openInGoogleMaps(destination: "Canal St & Broadway, New York, NY", label: "Open start point in Maps")],
             palette: clay),

        step(id: 26, day: 3, dayLabel: "Day 3 · 8 of 11",
             hero: "hotel_building", title: "Hail a cab\nback to the hotel",
             subtitle: "Freshen up before evening.\nGrab a yellow cab — or use Uber as a backup.",
             ctas: [.openInUber(destination: "The Jewel Hotel, 11 W 51st St, New York, NY", latitude: 40.7597381, longitude: -73.9777528, label: "Backup: open Uber")],
             palette: wisteria),

        step(id: 27, day: 3, dayLabel: "Day 3 · 9 of 11",
             hero: "subway_train", title: "Subway option:\nCanal St → hotel",
             subtitle: "At Broadway & Canal, take an uptown N, R, or W train to 49 St — not the Q.\n\nExit at 7th Ave & 49th, walk north to 51st St, turn right.",
             ctas: [.openInGoogleMaps(destination: "Canal St Station, Broadway & Canal St, New York, NY", label: "Open station in Google Maps")],
             palette: mistBlue),

        step(id: 28, day: 3, dayLabel: "Day 3 · 10 of 11",
             hero: "fifth_ave_sign", title: "Evening walk\n5th Ave & Madison Ave",
             subtitle: "2-min walk from hotel.\n(or skip ahead to dinner)",
             palette: peach),

        step(id: 29, day: 3, dayLabel: "Day 3 · 11 of 11",
             hero: "dinner", title: "Dinner time",
             subtitle: "(or skip back to 5th Ave and Madison Ave)",
             ctas: [.openInGoogleMaps(destination: nil, label: "Open Google Maps")],
             palette: clay),
    ]
```

- [ ] **Step 2: Build to verify it compiles**

Run: `xcodebuild build -project NYCTrip2026/NYCTrip2026.xcodeproj -scheme NYCTrip2026 -destination 'platform=iOS Simulator,name=iPhone 15' 2>&1 | tail -5`
Expected: `** BUILD SUCCEEDED **`

- [ ] **Step 3: Commit**

```bash
git add NYCTrip2026/NYCTrip2026/Content/Trip.swift
git commit -m "feat: Day 3 — reorder around 11:30 museum, breakfast/Starbucks, subway + detailed SoHo/Canal (11 screens)"
```

---

### Task 5: Rewrite Day 4 (cab to Penn + two-CTA Penn subway screen)

**Files:**
- Modify: `NYCTrip2026/NYCTrip2026/Content/Trip.swift` — replace the entire `static let day4: [Step] = [...]` block

- [ ] **Step 1: Replace the `day4` array**

```swift
    static let day4: [Step] = [
        step(id: 30, day: 4, dayLabel: "Day 4 · 1 of 6",
             hero: "breakfast", title: "Breakfast at\nLiberty Bagels",
             subtitle: "~7-min walk from hotel.",
             ctas: [.openInGoogleMaps(destination: "Liberty Bagels Grand Central, 5 E 47th St, New York, NY", label: "Open in Google Maps")],
             palette: butterCream),

        step(id: 31, day: 4, dayLabel: "Day 4 · 2 of 6",
             hero: "hotel_building", title: "Back to hotel\nto check out",
             subtitle: "Checkout by 12pm.",
             ctas: [.openInGoogleMaps(destination: "The Jewel Hotel, 11 W 51st St, New York, NY", label: "Open in Google Maps")],
             palette: peach),

        step(id: 32, day: 4, dayLabel: "Day 4 · 3 of 6",
             hero: "uber_car", title: "Hail a cab to\nPenn Station",
             subtitle: "Too far to walk with bags (~30 min).\nGrab a yellow cab — or use Uber as a backup.",
             ctas: [.openInUber(destination: "Penn Station, 31st St & 8th Ave, New York, NY", latitude: 40.750568, longitude: -73.994235, label: "Backup: open Uber")],
             palette: clay),

        step(id: 33, day: 4, dayLabel: "Day 4 · 4 of 6",
             hero: "subway_train", title: "Subway option:\nhotel → Penn Station",
             subtitle: "Walk to 5 Av/53 St (E/F). Take the downtown E train only (toward World Trade Center) — not the F — 4 stops to 34 St–Penn Station.\n\nWeekday mornings 6:30–10:30am the 5 Av/53 St entrance is closed for repairs — enter at 7 Av (53rd & 7th) instead.",
             ctas: [
                .openInGoogleMaps(destination: "7 Av Station, W 53rd St & 7th Ave, New York, NY", label: "Before 10:30am: 7 Av"),
                .openInGoogleMaps(destination: "5 Av/53 St Station, New York, NY", label: "After 10:30am: 5 Av/53 St")
             ],
             palette: mistBlue),

        step(id: 34, day: 4, dayLabel: "Day 4 · 5 of 6",
             hero: "subway_train", title: "Take the train\nto Metropark",
             subtitle: "Northeast Corridor line ~35-50 min\n\nActivate your tickets at the platform.",
             ctas: [.openNJTransit(label: "Open NJ Transit app")],
             palette: sageCream),

        step(id: 35, day: 4, dayLabel: "Day 4 · 6 of 6",
             hero: "sedan_car", title: "~10 hr drive home",
             subtitle: "NexPass reads your license plate on the way out - no ticket, don't need to pay.",
             ctas: [.openInGoogleMaps(destination: "16206 Gemma Pass, Huntertown, IN", label: "Open in Google Maps")],
             palette: mistBlue),
    ]
```

- [ ] **Step 2: Build to verify it compiles**

Run: `xcodebuild build -project NYCTrip2026/NYCTrip2026.xcodeproj -scheme NYCTrip2026 -destination 'platform=iOS Simulator,name=iPhone 15' 2>&1 | tail -5`
Expected: `** BUILD SUCCEEDED **`

- [ ] **Step 3: Commit**

```bash
git add NYCTrip2026/NYCTrip2026/Content/Trip.swift
git commit -m "feat: Day 4 — cab-first to Penn + two-CTA Penn subway screen (6 screens)"
```

---

### Task 6: Full test suite green

**Files:** none (verification)

- [ ] **Step 1: Run the full test suite**

Run: `xcodebuild test -project NYCTrip2026/NYCTrip2026.xcodeproj -scheme NYCTrip2026 -destination 'platform=iOS Simulator,name=iPhone 15' 2>&1 | tail -40`
Expected: `** TEST SUCCEEDED **`. In particular `totalCount` (37), `uberCoordinatesMatchDestinations` (6-destination set matches), `dayLabelsMatchPosition` (auto-derived 9/9/11/6), `atMostTwoCTAs`, and `reservationAndTwoCTAsExclusive` all pass.

- [ ] **Step 2: If anything fails, fix and re-run (max 3 attempts before escalating)**

Common culprits: a `dayLabel` count typo (test names the bad step id), a stray Uber destination string mismatch (test names the destination), or a duplicate `id`. The Simulator can throw a transient `Busy`/preflight error on the first launch — an immediate retry is expected per the prior session's experience, not a real failure.

- [ ] **Step 3: Commit (only if Step 2 made changes)**

```bash
git add -A NYCTrip2026/
git commit -m "fix: bring trip-revision content tests green"
```

---

### Task 7: Codex adversarial code review via `codex exec`

**Files:** none (review). Follows CLAUDE.md Codex gotchas: prompt via **stdin** (argv hangs/breaks on long or `---`-prefixed prompts), `--sandbox read-only` (review needs no writes), and a hard timeout via `perl -e 'alarm N; exec ...'` (macOS has no `timeout`).

- [ ] **Step 1: Confirm Codex CLI is available**

Run: `which codex && codex --version`
Expected: a path and version. If missing, stop and tell Jon to install/auth Codex (v1 used it, so it should be present).

- [ ] **Step 2: Capture the full diff to a file for the reviewer**

Run:
```bash
git diff d7e3b10..HEAD -- NYCTrip2026/ docs/superpowers/specs/2026-06-15-nyc-trip-app-revisions-design.md > /tmp/nyc-revisions-review.diff
wc -l /tmp/nyc-revisions-review.diff
```
(`d7e3b10` is "Finalize NYC trip app" — the last pre-revision content commit. If history differs, use `git log --oneline` to find the commit just before Task 1.)

- [ ] **Step 3: Run the adversarial review (stdin prompt, read-only sandbox, 10-min hard cap)**

```bash
perl -e 'alarm 600; exec @ARGV' codex exec --sandbox read-only - <<'PROMPT'
You are doing an ADVERSARIAL code review of revisions to a SwiftUI iOS app that is a personal NYC trip guide (a gift). The change adds subway options, a taxi-first ride model, reorders Day 3 around an 11:30am museum reservation, and adds detailed SoHo/Canal and Brandy Melville screens.

Read the diff at /tmp/nyc-revisions-review.diff and the design spec at docs/superpowers/specs/2026-06-15-nyc-trip-app-revisions-design.md. The Swift content lives in NYCTrip2026/NYCTrip2026/Content/Trip.swift; the content tests in NYCTrip2026/NYCTrip2026Tests/TripContentTests.swift.

Review for, in priority order:
1. SUBWAY ACCURACY: does each subway screen's instruction match the verified routes in the spec exactly (train letters, direction, stop counts, boarding stations, the R/W-only-to-Prince-St rule, the E/F Day-4 detail, the morning-closure note)? Flag ANY discrepancy between Trip.swift and the spec.
2. CONTENT INTEGRITY: unique ids 1–35, dayLabels matching per-day counts (9/9/11/6), no step with >2 CTAs, no reservation step with >1 CTA, every Uber destination present in the test's expected dict and vice-versa (the set must match exactly).
3. CORRECTNESS: typos, wrong addresses vs the spec, broken \n line breaks, a CTA pointing at the wrong place, palette assignments that put identical backgrounds on adjacent screens.
4. ANYTHING that would confuse or mislead Katy (a mother + daughter new to NYC) while navigating.

Do NOT rewrite code. Output a numbered list of findings, each with: file:line, severity (blocker/should-fix/nit), what's wrong, and the suggested fix. If you find nothing in a category, say so explicitly.

Before finishing, double-check the subway facts against the spec one more time and list anything you might have skimmed.
PROMPT
```
Expected: a numbered findings list (or "no issues" per category). If `perl` reports the alarm fired (process killed at 600s), re-run; if it hangs again, fall back to a shorter scoped prompt (subway accuracy only).

- [ ] **Step 4: Save the review output**

Paste/redirect Codex's output into `docs/superpowers/reviews/2026-06-15-codex-review-1.md` for the record.

```bash
mkdir -p docs/superpowers/reviews
# (write Codex output into the file, then:)
git add docs/superpowers/reviews/2026-06-15-codex-review-1.md
git commit -m "docs: Codex adversarial review of trip revisions (round 1)"
```

---

### Task 8: Triage and address Codex findings

**Files:** likely `Content/Trip.swift` and/or `TripContentTests.swift`

- [ ] **Step 1: Triage each finding** using the `superpowers:receiving-code-review` discipline — verify against the spec/codebase before accepting. Subway-fact findings: confirm against the spec's verified routes (the spec wins; if Codex disputes a verified route, re-check the source before changing). Push back in writing on anything incorrect rather than blindly applying.

- [ ] **Step 2: Apply accepted fixes** one at a time.

- [ ] **Step 3: Re-run the full suite**

Run: `xcodebuild test -project NYCTrip2026/NYCTrip2026.xcodeproj -scheme NYCTrip2026 -destination 'platform=iOS Simulator,name=iPhone 15' 2>&1 | tail -40`
Expected: `** TEST SUCCEEDED **`

- [ ] **Step 4: Commit**

```bash
git add -A NYCTrip2026/
git commit -m "fix: address Codex review findings on trip revisions"
```

---

### Task 9: Confirmation review + done

**Files:** none

- [ ] **Step 1: Codex confirmation pass** — re-run the Task 7 command (regenerate the diff first) limited to: "confirm the previously-raised findings are resolved and no regressions were introduced." Save to `docs/superpowers/reviews/2026-06-15-codex-review-2.md` and commit.

- [ ] **Step 2: Final full test run** to confirm green.

Run: `xcodebuild test -project NYCTrip2026/NYCTrip2026.xcodeproj -scheme NYCTrip2026 -destination 'platform=iOS Simulator,name=iPhone 15' 2>&1 | tail -20`
Expected: `** TEST SUCCEEDED **`

- [ ] **Step 3: Report to Jon — on-device verification is the real gate.** A green build/test is necessary, not sufficient (CLAUDE.md Principle 3). Hand Jon this manual checklist to run on Katy's iPhone after he rebuilds from Xcode:
  - Swipe through all 37 screens; each day's "N of M" footer counts correctly (…of 9, 9, 11, 6).
  - Day 1: "Hail a cab" Uber backup opens Uber to The Jewel Hotel; the Penn→hotel subway screen reads correctly.
  - Day 3: museum shows 11:30am; "to the museum" subway screen shows both boarding-point buttons; SoHo/Canal screens read as walking routes.
  - Day 4: the Penn subway screen shows both the "Before 10:30am: 7 Av" and "After 10:30am: 5 Av/53 St" buttons.
  - Spot-check 2–3 Google Maps CTAs (Brandy Melville, Starbucks, a subway station) open Maps to the right place.

---

## Self-Review (completed by plan author)

**Spec coverage:** subway legs A–E → Tasks 2/4/5 (screens id 5, 20, 22, 27, 33); taxi-first → id 4, 14/15/16/17, 21, 26, 32; Day 3 reorder + 11:30 museum → Task 4; Starbucks alt → id 19; detailed SoHo/Canal → id 24/25; Brandy Melville → id 13; test updates → Task 1; Codex review → Tasks 7–9. All spec sections mapped.

**Placeholder scan:** no TBD/TODO; every step has complete Swift or an exact command.

**Type consistency:** all CTAs use existing `.openInGoogleMaps(destination:label:)`, `.openInUber(destination:latitude:longitude:label:)`, `.openNJTransit(label:)`; `step(...)` factory signature matches `Trip.swift`; `ReservationDetail` field order matches the model.

**Known intermediate-red note:** the `count == 37` assertion (Task 1) fails until Task 5 completes — documented in the workflow note above; full green at Task 6.
