# NYC Trip Plan — HTML Update Handoff
## For a Fresh Claude Session

**Purpose:** All trip decisions have been finalized in a long planning session. This document gives a fresh session everything it needs to edit `index.html` completely and correctly — no research, no questions about decisions already made. The source HTML is at `/mnt/user-data/uploads/nyc-trip-plan.html` (1,132 lines). The output should be a downloadable `index.html` for the user to commit via GitHub Desktop to `https://github.com/old-head-dev/nyc-trip-2026`, which publishes to `https://old-head-dev.github.io/nyc-trip-2026/`.

---

## Trip Overview (Corrected)

- **Travelers:** Wife + 16-year-old daughter (husband/father not going)
- **Dates:** June 21–24, 2026
  - **Sunday June 21:** Drive from Fort Wayne → Park at Metropark (Iselin, NJ) → NJ Transit to NYC Penn Station → check in. **Evening arrival.**
  - **Monday June 22:** Full day (either Day A or Day B — see itinerary)
  - **Tuesday June 23:** Full day (the other day)
  - **Wednesday June 24:** Check out by noon → Penn Station → NJ Transit → drive home
- **Hotel:** The Jewel New York, 11 W 51st St — Check-in 3 PM, Check-out 12 PM (noon)

> **Note:** The original handoff document incorrectly listed June 21 as a Saturday. June 21, 2026 is a Sunday. The HTML currently says "Sunday, June 21" in the Day 1 header — that part is already correct. The drive day section is correct. No date text changes needed in the itinerary headers.

---

## Style Reference (Do Not Change)

```css
--gold: #c9973a
--rust: #b85c38
--sage: #6b7c6e
--ink: #1a1714
--muted: #7a7570
--cream: #f7f3ee
--card: #ffffff
--section-bg: #f0ebe4
--border: #ddd8d0
```
Fonts: `Playfair Display` (headers/names) and `DM Sans` (body).

For the "BOOKED" badge: use `--rust` background with white text.
For new urgent badges (Blue Box): use same pattern as the existing Jellycat time-sensitive badge.

---

## Change 1 — Alerts Banner

**Current:** One alert at line 481 for Jellycat Diner (May 25, 3 PM ET).

**Action:** Add a second alert immediately below the Jellycat alert for Blue Box Café. Use the same `.alert` class and styling.

**New Blue Box alert content:**

```
⚠️  Blue Box Café Reservation — Resy Opens May 23 & 24

Reservations at Tiffany's Blue Box Café open 30 days in advance. 
June 22 opens May 23 · June 23 opens May 24. 
Check Resy (resy.com) first thing in the morning on each date — 
book immediately when slots appear. Book at Tiffany's Blue Box Café, 727 5th Ave.
Breakfast for 2. Calendar reminders already set for May 23 and May 24.
```

---

## Change 2 — Hotel Section

**Current:** Lines 619–764. Entire section titled "Top Hotel Recommendations" with a grid of 11 hotel cards and associated intro text.

**Action:** Replace the entire hotel section with a single "Your Hotel" section. Delete all hotel card HTML and the intro paragraph. Delete the `.hotel-grid`, `.hotel-card`, `.hotel-card.top-pick`, `.hotel-name`, `.hotel-tag`, `.hotel-meta`, `.hotel-price`, `.hotel-why` CSS rules (lines ~256–309) since they are no longer used.

**New section content:**

```
Section label: "Where You're Staying"
Section title: "Your Hotel"
```

Display a single card with a rust-colored "BOOKED ✓" badge. Include:

- **Hotel name:** The Jewel New York *(link to: https://www.thejewelny.com/)*
- **Address:** 11 W 51st St, New York, NY 10019 *(link to Google Maps)*
- **Check-in:** 3:00 PM · **Check-out:** 12:00 PM (noon)
- **Location context:** Directly across from Rockefeller Center. Times Square is a 5-min walk. Blue Box Café at Tiffany's is a 4-min walk. 5th Avenue is 1 block east. Radio City Music Hall is steps away.
- **Amenities worth noting:** Complimentary cappuccino and bottled water in lobby · Free WiFi · 24-hour gym · Baggage storage available (useful on check-out day if they want to explore before the train) · On-site restaurant · No pool.
- **Practical note:** If arriving before 3 PM, front desk can hold bags — don't wait in the lobby; go explore and return at check-in time.

Use the gold border style similar to old "top-pick" hotel cards, but replace the gold badge with a rust "✓ Booked" badge. Keep it clean and simple — one card, not a grid.

---

## Change 3 — Pre-Trip Checklist (Reservations Section)

**Current location:** Lines 522–539. The "Reservations Required" card has three items: Jellycat Diner, Serendipity 3, and Central Park Carriage (optional).

**Action:** Add two new items to this card.

**Add after Jellycat Diner item:**

```
Blue Box Café at Tiffany's          [Time-Sensitive badge]
resy.com · 727 5th Ave, 5th Floor · Breakfast experience for 2.
June 22 slot opens May 23 · June 23 slot opens May 24.
Check Resy first thing in the morning on each date. Book immediately — limited availability.
Calendar reminders already set.
```

**Add after Serendipity 3 item (or as a new item in the Tickets section — see Change 4):**

```
Museum of Ice Cream Tickets         [Required — not optional]
museumoficecream.com · 558 Broadway, SoHo
~$38–42/person. Advance tickets required — sells out, especially in summer.
Buy before the trip. Book for the SoHo day (June 22 or 23).
```

**Also update the Serendipity 3 item** — current text says "June 23 mid-afternoon (~2:30 PM)" but the day is now flexible. Change to: *"Book for whichever day is the Central Park/Midtown day (June 22 or 23). Reserve as soon as 30–60 days out opens on Resy."*

---

## Change 4 — Tickets Section

**Current location:** Lines 541–554. Two items: Broadway Show (optional) and NJ Transit Train Tickets.

**Action:** Add Museum of Ice Cream as a required (not optional) item. Move it to the top of the list with a "Required" badge. See content above in Change 3.

---

## Change 5 — Getting Around NYC Card

**Current location:** Line 595–599. Says: *"All core stops cluster within a 2-mile Midtown radius — walkable between most. Use Uber for Chelsea Market (further south) and anything after 10 PM."*

**Action:** Chelsea Market is no longer on the itinerary. Update to:

```
All core Midtown stops are walkable. Use Uber for the SoHo/Canal Street day 
(~25–30 min south of the hotel) and anything after 10 PM. 
Budget $15–25 per Uber trip within Midtown; $20–30 for the SoHo run.
```

---

## Change 6 — Itinerary Section (Major Rewrite)

The itinerary needs significant restructuring. The hotel is now confirmed (at 51st & 6th, directly across from Rockefeller Center), the day structure has changed, and new restaurants/experiences have been added.

### Day 1 — Sunday June 21 (Arrival)

**Day header:** Keep "Drive Day · Arrive & Orient / Sunday, June 21" — already correct.

**Timeline items to update:**

- **Check-in item (currently line 801–804):** Update to: *"Uber from Penn Station to The Jewel New York, 11 W 51st St (~10 min, $15–20). Check-in at 3 PM. If arriving before 3 PM, front desk holds bags — drop them and head out. You're directly across from Rockefeller Center; Times Square is a 5-min walk west."*

- **Times Square item (7–8 PM):** No change needed.

**Food section — Day 1:**
- ☕ Breakfast (Road): Keep as-is (Starbucks drive-through)
- 🥪 Lunch (Road): Keep as-is (Pennsylvania/Ohio sit-down stop)
- 🍔 Dinner: **Change from Ellen's Stardust Diner to Joe's Pizza.** After a long travel day, keep it simple and iconic. New content:

```
🍕 Dinner — Joe's Pizza
Several locations near Times Square. The most convenient: 
1435 Broadway (at Times Square). Original NYC slice joint — 
thin crust, perfectly executed, cash or card, ~$3–5/slice. 
No reservations, no wait, grab-and-go or eat at the counter. 
Perfect low-effort first night in the city. 
Get slices, walk Times Square, call it an early night.
```

---

### Day 2 — Monday June 22 — INTERCHANGEABLE

### Day 3 — Tuesday June 23 — INTERCHANGEABLE

**IMPORTANT — How to present Days 2 and 3:**

These two days are designed to be swapped depending on whether Blue Box Café is secured. Present them as labeled "Day A" and "Day B" with a callout note at the top of the itinerary section (before Day 1) explaining the logic:

```
📅 Note on Day Order
The two full days (June 22 and 23) are intentionally interchangeable. 
If Blue Box Café at Tiffany's is booked for June 22, that becomes the 
Central Park/Midtown day. If it's booked for June 23, swap the days. 
Both days are fully planned — the order depends on reservation availability.
```

Then label Day 2 as: **"Day A — Downtown · SoHo · Canal Street"**
And Day 3 as: **"Day B — Midtown · Central Park · TAO Uptown"**

With a sub-note on each: *"Order depends on Blue Box Café reservation — see note above."*

---

### Day A — Downtown · SoHo · Canal Street
*(Monday June 22 OR Tuesday June 23)*

**Day header:** "Downtown · SoHo · Canal Street / Monday June 22 OR Tuesday June 23 (see note)"

**Timeline:**

```
8:30–9:30 AM  |  Breakfast — Sunday Morning
               29 W 25th St location. ~$12–15 Uber from hotel (10 min).
               Famous for their cinnamon rolls — this is the reason to go.
               Casual, relaxed, excellent coffee. Set the downtown day off right.

10 AM–12 PM   |  SoHo Shopping
               Explore Broadway, Spring St, Prince St. Teen-friendly stores:
               Aritzia, Free People, Brandy Melville, Anthropologie, plus 
               boutiques and local shops. Cobblestone streets, great energy.
               This is real NYC shopping — not a tourist trap.

12–1 PM       |  Canal Street
               ~11-min walk from SoHo core. Chinatown market vibe — 
               knockoff bags, sunglasses, chaotic and loud but completely 
               safe during the day. Vendors are persistent but not threatening. 
               Fun experience; keep a light grip on bags.

1–2 PM        |  Lunch — SoHo/Nolita
               Explore and pick. Suggested fallback if they want a recommendation:
               Jack's Wife Freda, 226 Lafayette St. Mediterranean-influenced 
               American food, relaxed atmosphere, highly reviewed, good for 
               a mom + teen. No need to pre-book at lunch.

2:30–4 PM     |  🍦 Museum of Ice Cream           [Advance Tickets Required]
               558 Broadway, SoHo. ~$38–42/person. 
               Interactive immersive experience — the sprinkle pool is the famous one.
               Tickets sell out in summer; buy before the trip at museumoficecream.com.
               Allow 60–90 min inside.

4:30 PM       |  Uber Back to Midtown
               ~$20–25, 25 min from SoHo. Freshen up at hotel.

5:30–7 PM     |  5th Avenue & Madison Avenue — Evening Walk
               4-min walk from hotel. Tiffany's (727 5th Ave), Bergdorf Goodman,
               Saks Fifth Avenue. Window shopping — iconic storefronts at dusk.
               Madison Ave runs parallel one block east — same vibe, slightly
               less crowded. Blue Box Café is at 727 5th Ave if they want to
               peek at the building (even without a reservation, the exterior
               and Tiffany's store itself is worth the stop).

7:30 PM       |  Dinner — Ellen's Stardust Diner
               1650 Broadway at 51st St · Times Square.
               Singing waitstaff — aspiring Broadway performers who belt 
               show tunes while serving your food. Perfect energy after a 
               full downtown day. No reservations; arrive by 6:30–7 PM to 
               avoid a long wait. Diner food — burgers, milkshakes, classic 
               American. ~$20–30/person.
```

**Food summary card — Day A:**
- ☕ Breakfast: Sunday Morning (29 W 25th St) — cinnamon rolls, $12–15 Uber from hotel
- 🥗 Lunch: Jack's Wife Freda, 226 Lafayette St, SoHo — Mediterranean-American, casual, ~$20–30/person
- 🍦 Mid-afternoon: Museum of Ice Cream — not a food stop, it's the experience
- 🎤 Dinner: Ellen's Stardust Diner, 1650 Broadway — singing waitstaff, ~$20–30/person

---

### Day B — Midtown · Central Park · TAO Uptown
*(The other full day — Monday June 22 OR Tuesday June 23)*

**Day header:** "Central Park · Midtown · TAO Uptown / [date depends on reservation]"

**Timeline:**

```
8:30–9:30 AM  |  Breakfast — Blue Box Café at Tiffany's    [If Reserved]
               727 5th Ave, 5th Floor · 4-min walk from hotel.
               The "Breakfast at Tiffany's" experience — the daughter's request.
               Book on Resy (opens May 23 for June 22, May 24 for June 23).
               Confirm reservation before the trip.
               
               IF NOT BOOKED: Local coffee shop breakfast instead.
               Recommended: Bluestone Lane (multiple Midtown locations — 
               nearest at 30 Rockefeller Plaza) or Gregory's Coffee.
               Quality NYC coffee shop experience, ~$10–15/person.

10 AM–11 AM   |  Grand Central Terminal                    [Free]
               ~15-min walk east from hotel (or short Uber).
               Main Concourse celestial ceiling, the Whispering Gallery 
               (find two opposite corners near the Oyster Bar and whisper — 
               you'll hear each other), Grand Central Market gourmet food hall.
               45 min here is enough.

11 AM–1 PM    |  🪼 Jellycat Experience at FAO Schwarz      [Reservation Required]
               30 Rockefeller Plaza, 1st floor.
               Staff "cook" your order of Jellycat stuffed animals in a 
               diner-themed setup. Budget ~$70+/person for the plush toys.
               Book May 25 at 3 PM ET on faoschwarz.com/pages/reservations.
               Calendar reminder already set.

1–2 PM        |  Herald Square & Macy's                   [Free]
               10-min walk from Rockefeller. The original Macy's flagship 
               (34th St, 11 floors) — world's largest department store. 
               Budget shopping on 34th St nearby.

2:30–4 PM     |  🌿 Central Park
               Walk: Bethesda Fountain → Bow Bridge → Strawberry Fields → The Mall.
               June is beautiful — green, full, comfortable morning temps.
               Enter at 59th St & 5th Ave (south end). Plan 1.5–2 hrs.
               
               Optional add-on: Central Park Carriage Ride         [Pre-Book]
               NYC Royal Carriage, nycroyalcarriage.com. Meet at 59th & 5th.
               45-min tour $150/carriage (not per person). 
               Morning slot preferred in June heat.
               Note: horses don't operate above 89°F — check forecast.

4–5 PM        |  Lunch — Via Quadronno
               25 E 73rd St · Steps from the east side of Central Park, 
               near the Met. Italian café — house-made pastas, panini, 
               gelato. The Infatuation's top pick for east-side Central Park lunch.
               Been there since 1999. Casual, no rush, ~$20–30/person.

5:30 PM       |  🍨 Serendipity 3 — Afternoon Treat        [Reserve on Resy]
               225 E 60th St · 15-min walk south from Via Quadronno.
               Dessert experience, not a meal — the Frrrozen Hot Chocolate 
               is the reason to go. Reserve on Resy for ~2:30–3 PM time slot
               so there's no summer wait. ~$20–30/person for drinks and dessert.
               Original location is the one to go to.

7:30 PM       |  🥢 Dinner — TAO Uptown                    [Reserve on OpenTable]
               42 E 58th St · 10-min walk or short Uber from Serendipity.
               Dramatic pan-Asian restaurant — towering Buddha, reflective pool,
               genuinely great food. One of the coolest dining rooms in Midtown.
               This is the "nice dinner" — they can dress up.
               Reserve well in advance on OpenTable. ~$40–60/person.
               If doing a Broadway show this evening, eat at 5:30 PM instead.
```

**Food summary card — Day B:**
- ☕ Breakfast: Blue Box Café (if booked) OR Bluestone Lane/Gregory's Coffee
- 🍝 Lunch: Via Quadronno, 25 E 73rd St — Italian café near Central Park, ~$20–30/person
- 🍨 Treat: Serendipity 3 — Frrrozen Hot Chocolate (dessert only), ~$20–30/person
- 🥢 Dinner: TAO Uptown, 42 E 58th St — the nice dinner, dress up, ~$40–60/person

---

### Day 4 — Wednesday June 24 (Checkout)

**Day header:** Keep "Check Out & Drive Home / Wednesday, June 24"

**Update the timeline:**

- **8–9 AM — Breakfast:** Replace the current Junior's/bagel cart suggestion with:
```
Liberty Bagels
Multiple Midtown locations — nearest to The Jewel is on 7th Ave 
around 50th–51st St area. Classic NY bagel, quick, portable.
Perfect send-off breakfast before the drive.
~$8–12/person. Eat in or grab and go.
```

- **Check-out note:** The Jewel's checkout is noon. If they want to do a brief morning stroll before checkout, hotel will hold bags. Target: bags at the desk by 11:30 AM, Uber to Penn Station by 11:45 AM.

- **Penn Station timing:** Update to: *"Target Penn Station no later than 11 AM to clear NJ before afternoon traffic builds. ~45 min back to Metropark. Pick up car, depart NJ by noon."*

- Keep the drive home entry as-is.

---

## Change 7 — Safety Notes

**Current:** "The entire itinerary — Times Square, 5th Ave, Rockefeller, Central Park, Herald Square, Grand Central — is in one of the most heavily policed tourist corridors on earth."

**Update to add SoHo and the hotel neighborhood:**
```
The entire itinerary — Times Square, 5th Ave, Rockefeller Center, Central Park, 
Herald Square, Grand Central, and SoHo — covers some of the most heavily 
policed and tourist-trafficked areas in the world. Their hotel on 51st & 6th 
is in the heart of this corridor. Extremely safe during the day and evening. 
No concerns for this itinerary as planned.
```

**After-dark card** — update Chelsea Market reference to SoHo:
```
Times Square and Midtown are well-lit and busy until midnight. 
Stick to main streets after 10 PM. Use Uber for any return trip from 
SoHo/downtown and anything after 10 PM — don't walk 30 blocks at night.
```

---

## Change 8 — Booking Checklist

Replace all current items with the following (in this order):

```
✓  BOOKED — The Jewel New York, 11 W 51st St, New York, NY 10019
   Check-in June 21 at 3 PM · Check-out June 24 at 12 PM (noon)
   [style this as already-completed — strikethrough or filled checkbox with green/confirmed styling]

□  May 23 (morning) — Blue Box Café on Resy for June 22 breakfast    [Time-Sensitive]
   resy.com → Tiffany Blue Box Café, 727 5th Ave, 5th Floor. Breakfast for 2.
   Calendar reminder set.

□  May 24 (morning) — Blue Box Café on Resy for June 23 breakfast (backup)    [Time-Sensitive]
   Same as above. Only needed if June 22 slot not available.
   Calendar reminder set.

□  May 25, 3 PM ET — Jellycat Diner at FAO Schwarz    [Urgent · Sells Out]
   faoschwarz.com/pages/reservations · Two devices, refresh at exactly 3:00 PM.
   $70+/person. Calendar reminder already set.

□  Now — Museum of Ice Cream tickets    [Required · Sells Out in Summer]
   museumoficecream.com · 558 Broadway, SoHo · ~$38–42/person.
   Book for whichever day is the SoHo day (June 22 or 23).

□  Now — TAO Uptown dinner reservation    [Reserve ASAP]
   OpenTable · 42 E 58th St · Book for the Central Park day evening (June 22 or 23).
   Fills up weeks out in June.

□  Now — Serendipity 3 reservation on Resy
   resy.com · 225 E 60th St · Book for the Central Park day (~2:30–3 PM slot).
   Book as soon as 30–60 days out opens on the platform.

□  Before June 21 — NexPass app (nexusparkingsystems.com)
   Register license plate for Metropark parking. 5 min setup.

□  Before leaving — NJ Transit app
   Free, iOS. Create account. Use MyTix for Northeast Corridor tickets.
   Also download DepartureVision for live train departures.

□  Optional — Broadway Show
   & Juliet or SIX recommended. Broadway.com or TodayTix app.
   Best for whichever evening works. TKTS booth in Times Square sells 
   day-of discounts at noon if deciding last minute.

□  Optional — Central Park Carriage Ride
   nycroyalcarriage.com · 45-min tour ~$150/carriage · 
   Book for Central Park morning (June 22 or 23). Doesn't run above 89°F.
```

---

## CSS Cleanup

Remove these unused CSS classes after deleting the hotel grid:
- `.hotel-grid` (line ~256)
- `.hotel-card` (line ~260)
- `.hotel-card.top-pick` (line ~270)
- `.hotel-name` (line ~274)
- `.hotel-tag` (line ~280)
- `.hotel-tag.mid` (line ~291)
- `.hotel-meta` (line ~292)
- `.hotel-price` (line ~298)
- `.hotel-why` (line ~304)

The new hotel section can use existing `.logistic-card` or `.safety-card` patterns, or a new simple card style with a rust "BOOKED ✓" badge.

---

## Things NOT to Change

- Hero section (stats: 3 Nights / ~640 Miles Each Way / 2 Travelers)
- Drive & Park Strategy section — keep as-is
- NJ Transit logistic card — keep as-is
- June 24 Return logistic card — keep as-is (minor Penn Station timing edit only, per above)
- Broadway Show section — keep as-is
- Apps to Download section — keep as-is
- Physical Prep section — keep as-is

---

## Delivery

Produce a complete downloadable `index.html` file. Do not show code in chat. The user will drag it into GitHub Desktop and commit it to the repo directly.

---

*Handoff prepared May 2026. All decisions final. No research needed. Execute only.*
