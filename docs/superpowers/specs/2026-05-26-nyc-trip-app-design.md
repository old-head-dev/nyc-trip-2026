# NYC Trip 2026 Companion App — Design Spec

**Date:** 2026-05-26
**Author:** Jon, with Claude
**Status:** Brainstorm output — pending review before plan
**Target ship date:** Installed to Katy's iPhone by 2026-06-14 (one week before trip departure on June 21)

---

## Purpose

A private, single-user SwiftUI app installed directly to Katy's iPhone 15 via Xcode. It walks her step-by-step through the NYC trip (June 21–24, 2026) — one screen per task, minimal words, premium feel. A surprise gift from Jon for Katy + their daughter Jada.

**Not** an app store product. Personal trip companion only.

## Design principles

1. **One screen, one task.** Never two competing actions on the same screen.
2. **Minimal words.** Katy gets overwhelmed easily. Title + brief subtitle + at most one action button.
3. **Easily tappable.** Large hit targets (≥44pt). Generous spacing.
4. **Premium aesthetic.** DM Sans typography, soft pastel-per-screen backgrounds, SF Symbols, coordinated accent colors, polished slide animations.
5. **Predictable navigation.** Linear: Back / Next. Optional steps are still in the flow; tap Next to skip.

## Visual system

### Typography
- **Headlines:** DM Sans 600 (semibold), -0.3 letter-spacing, 22pt
- **Body / subtitle:** DM Sans 400, 13pt, line-height 1.45
- **Step label (eyebrow):** DM Sans 600, 11pt, uppercase, 1.5 letter-spacing
- **CTA button:** DM Sans 600, 14pt

DM Sans is bundled in the app (TTF in `Resources/Fonts/`) and registered via `Info.plist`. Falls back to SF Pro if loading fails.

### Color
- **Each step has its own** `(background, accent, textPrimary, textSecondary)` color set, defined inline in the step's struct.
- Backgrounds are soft pastels (peach, dusty blue, mint, sage, lavender, soft yellow, dusty rose, etc.). Accents are darker tones of the same family.
- Text uses a warm dark color (`#2a2926` or step-specific variant) for high contrast against pastel backgrounds.
- Jon hand-tunes color choices per step at authoring time — no algorithm. Tonal matching encouraged (walks lean sage, drives lean blue, meals lean warm) but not enforced. Repeats across non-adjacent steps are fine.

### Layout (universal)
- Edge-to-edge pastel background (safe-area-respectful).
- Top: step label ("Day 2 · Reservation" or "Day 1 · 2 of 22").
- Center: SF Symbol (large, accent-colored), title (2 lines max), subtitle (2 lines max), optional reservation detail card, optional CTA button.
- Bottom: Back button (left, hidden on first screen), page-dots indicator (center), Next button (right, hidden on last screen).
- 22pt horizontal padding; 28pt top/bottom safe-area-inset padding.
- Slide transition between screens (TabView paged style handles this).

### SF Symbols
Each step has a single SF Symbol. Symbol weight: `.medium`. Size: 56pt. Examples:
- Drive: `car.fill`
- Park: `parkingsign.circle.fill`
- Train: `train.side.front.car`
- Hotel: `bed.double.fill`
- Walk: `figure.walk`
- Coffee: `cup.and.saucer.fill`
- Meal: `fork.knife`
- Shop: `bag.fill`
- Park (the green kind): `tree.fill`
- Heart-ish moments: `sparkles`
- Home: `house.fill`

Final symbol list locked at content-authoring time.

## Architecture

### Tech stack
- **Language:** Swift 5.10+
- **UI:** SwiftUI
- **Target:** iOS 17.0+ (iPhone 15 runs iOS 18+; iOS 17 floor gives headroom)
- **Xcode:** Latest stable on Jon's MacBook Air M5
- **Dependencies:** None. Pure SwiftUI. No SPM packages.
- **Persistence:** `@AppStorage` (UserDefaults under the hood)

### Project structure

```
NYCTrip2026/
├── NYCTrip2026.xcodeproj
├── NYCTrip2026/
│   ├── App/
│   │   └── NYCTrip2026App.swift      # @main entry
│   ├── Models/
│   │   └── Step.swift                # Step struct + StepKind enum
│   ├── Content/
│   │   └── Trip.swift                # static let allSteps: [Step]
│   ├── Views/
│   │   ├── TripView.swift            # Root — TabView paged container
│   │   ├── StepView.swift            # One step (used for every screen)
│   │   ├── WelcomeView.swift         # First screen (custom layout)
│   │   ├── ClosingView.swift         # Last screen (custom layout)
│   │   ├── ReservationCard.swift     # Optional reservation detail block
│   │   └── NavBar.swift              # Bottom Back/Dots/Next row
│   ├── Theme/
│   │   ├── Color+Palette.swift       # Color extensions for the pastel system
│   │   └── Font+DMSans.swift         # Font convenience accessors
│   ├── Resources/
│   │   ├── Fonts/                    # DM Sans TTFs
│   │   └── Assets.xcassets           # App icon, no other images needed
│   └── Info.plist                    # Includes UIAppFonts entry for DM Sans
└── README.md                         # Install steps for Jon
```

### Core data model

```swift
struct Step: Identifiable {
    let id: Int
    let day: Int          // 1...4; 0 for welcome, 5 for closing
    let dayLabel: String  // e.g., "Day 2 · 6 of 22" or "Welcome" or "Trip complete"
    let symbol: String    // SF Symbol name
    let title: String     // 1-2 lines
    let subtitle: String? // 1-2 lines, optional
    let reservation: ReservationDetail?  // optional booking card
    let ctas: [CTA]       // 0, 1, or 2 buttons (e.g., walk-or-drive)
    let background: Color
    let accent: Color
    let textPrimary: Color
    let textSecondary: Color
}

struct ReservationDetail {
    let time: String       // "10:00 AM" or "Check-in 3:00 PM"
    let address: String    // "727 5th Ave, 5th Floor"
    let confirmation: String?  // "#351207910" or hotel confirmation number — optional
    let extra: String?     // free-form: "Room: King Suite" or "Breakfast for 2" — optional
}

enum CTA {
    case openInGoogleMaps(destination: String?, label: String)  // nil destination = open Maps with no preset
    case openInUber(destination: String, label: String)
    case openMyTix(label: String)                  // opens NJ Transit Mobile app
    case callPhone(number: String, label: String)  // for restaurants if needed
    case openURL(URL, label: String)               // generic escape hatch
}
```

### Navigation

`TripView` uses `TabView(selection: $currentIndex)` with `.tabViewStyle(.page(indexDisplayMode: .never))`. Each tab is a step's view (`WelcomeView`, `StepView(step)`, or `ClosingView`).

- **Next** = `currentIndex += 1` with `.withAnimation(.easeInOut(duration: 0.28))`.
- **Back** = `currentIndex -= 1`.
- **Swipe** = inherited from TabView paged style.
- **Page dots** = custom indicator showing position within current day (not total). Resets visually at each day boundary.

`@AppStorage("lastStepIndex")` stores `currentIndex`. On launch, restore to that value. If `lastStepIndex` exceeds `allSteps.count - 1` (e.g., due to a content rebuild that removes steps), clamp to last.

### Deep links

Built via `UIApplication.shared.open(URL)` with universal links (HTTPS) which auto-route to installed apps when possible:

| CTA case            | URL pattern                                                                 |
|---------------------|-----------------------------------------------------------------------------|
| Google Maps         | `https://www.google.com/maps/dir/?api=1&destination=<URL-encoded address>` |
| Uber                | `https://m.uber.com/ul/?action=setPickup&pickup=my_location&dropoff[formatted_address]=<URL-encoded address>` |
| MyTix (NJ Transit)  | Open the NJ Transit Mobile app via its URL scheme (`njtransit://`). No deep linking to a specific route — just launches the app, she taps to her tickets manually. Jon ensures the app is installed pre-trip. |
| Phone               | `tel:<number>`                                                              |
| Generic             | The URL itself.                                                             |

Universal links open the native app if installed (Google Maps app, Uber app), otherwise the mobile site. For best experience, Jon ensures all three apps are installed on Katy's phone pre-trip: **Google Maps**, **Uber** (with payment method saved), and **NJ Transit Mobile** (with round-trip Metropark↔NY Penn tickets pre-bought).

### Welcome screen

Custom layout (not a generic StepView):

```
Day 0 · pastel: soft peach background

         [sparkles symbol]

         Katy and Jada...

         Welcome to your
         NYC trip!

         June 21–24, 2026

         [Begin]   <— gold/accent pill button
```

No Back button. Next button is replaced by a wider "Begin" pill.

### Closing screen

Custom layout (not a generic StepView):

```
Day 5 · pastel: soft lavender background

         [heart.fill or sparkles]

         Welcome home!

         Hope you loved every minute. ✨

         [no buttons]
```

Tapping anywhere does nothing — the trip is done. Re-opening the app returns here (via `@AppStorage`). Katy can swipe back to revisit earlier screens at any time.

### Step content (preliminary list, final at authoring)

Estimated **~29 step screens** + Welcome + Closing = **~31 screens total**. Subject to refinement when Jon authors content.

**Optional-step convention:** steps that are skippable (e.g., Via Quadronno lunch) prefix the title with `OPTIONAL:` in the same color as the rest of the title — no separate badge. The user simply taps Next to skip; they're still in the linear flow.

**Day 1 — Drive day (Sunday, June 21)**
1. **Drive to Metropark Station** · CTA: Open in Google Maps (Iselin, NJ).
2. **Park at Metropark** · No CTA. Subtitle reminds: NexPass reads the plate automatically — no ticket to deal with.
3. **Take the train to NY Penn** · CTA: Open MyTix. Subtitle: Northeast Corridor line · activate ticket at the platform.
4. **Uber to The Jewel** · CTA: Open in Uber (destination = 11 W 51st St).
5. **Check in at The Jewel** · Reservation Card: confirmation # (TBD), room type (TBD), check-in 3:00 PM. No CTA.
6. **Dinner at Joe's Pizza** · CTA: Open in Google Maps (1435 Broadway).
7. **Times Square first look** · CTA: Open in Google Maps (Times Square).
8. **Return to The Jewel** · CTA: Open in Google Maps (11 W 51st St). For when they're done wandering.

**Day 2 — Midtown / Central Park / TAO (Monday, June 22)**
9. **Breakfast at Blue Box Café** · Reservation Card: 10:00 AM, 727 5th Ave 5th Fl, breakfast for 2. CTA: Open in Google Maps.
10. **Jellycat at FAO Schwarz** · Reservation Card: 11:50 AM, 30 Rockefeller Plaza, Booking #351207910. CTA: Open in Google Maps.
11. **Visit Grand Central Terminal** · CTA: Open in Google Maps (89 E 42nd St).
12. **OPTIONAL: Lunch at Via Quadronno** · CTA: Open in Google Maps (25 E 73rd St). Tap Next to skip.
13. **Walk Central Park** (Bow Bridge → Bethesda) · TWO CTAs: Open in Google Maps · Walk  /  Open in Uber · Drive.
14. **Herald Square + Macy's** · CTA: Open in Uber (151 W 34th St).
15. **Back to hotel · Freshen up** · TWO CTAs: Open in Google Maps · Walk  /  Open in Uber · Drive.
16. **Dinner at TAO Uptown** · Reservation Card: 6:30 PM, 42 E 58th St. CTA: Open in Google Maps.

**Day 3 — Downtown / SoHo (Tuesday, June 23)**
17. **Breakfast at Sunday Morning** · CTA: Open in Uber (29 W 25th St).
18. **SoHo shopping** · CTA: Open in Uber (SoHo, Broadway & Spring St). Walk once arrived.
19. **Canal Street** · CTA: Open in Google Maps (Canal St, Chinatown).
20. **Lunch at Jack's Wife Freda** · CTA: Open in Google Maps (226 Lafayette St).
21. **Museum of Ice Cream** · Reservation Card: time set by ticket purchase, 558 Broadway. CTA: Open in Google Maps.
22. **Uber back to hotel** · CTA: Open in Uber (11 W 51st St).
23. **Evening walk · 5th Ave & Madison** · No CTA. Subtitle: stroll the storefronts at dusk.
24. **Dinner — pick a spot near the hotel** · CTA: Open Google Maps (no destination preset — she can search/wander).

**Day 4 — Drive home (Wednesday, June 24)**
25. **Breakfast at Liberty Bagels** · CTA: Open in Google Maps.
26. **Back to The Jewel · Check out** · CTA: Open in Google Maps (11 W 51st St). Subtitle: checkout by 12:00 PM (noon).
27. **Uber to Penn Station** · CTA: Open in Uber (NY Penn Station).
28. **Take the train to Metropark** · CTA: Open MyTix. Subtitle: Northeast Corridor line · activate ticket at the platform.
29. **Drive home to Fort Wayne** · CTA: Open in Google Maps (home address). Subtitle: NexPass reads the plate on the way out — no parking ticket to pay.

Welcome and Closing bookend these. Final order/count finalized at authoring.

### Reservation card

When a step has a `ReservationDetail`, a card renders below the subtitle showing time, address, confirmation number (if any), and an `extra` line for room type / party size / etc. Card style: white-with-soft-shadow on the pastel background, rounded 14pt, small accent dot. Confirmation number is tappable to copy to clipboard with a brief haptic feedback + "Copied" toast.

Used by: Check-in at The Jewel, Blue Box Café, Jellycat at FAO Schwarz, TAO Uptown, Museum of Ice Cream.

### Accessibility

- Dynamic Type support: titles use `.title2`-equivalent scaling, body uses `.body`-equivalent. We define custom DM Sans modifiers that scale with `@ScaledMetric`.
- VoiceOver: every step reads as "Step N of M, [title], [subtitle]. [CTA label]. Swipe right for next, left for previous."
- Color contrast: all foreground/background pairs verified ≥4.5:1 (WCAG AA) at authoring time.

### Persistence rules

- `@AppStorage("lastStepIndex")` — `Int`, default 0. Updated on every page change.
- That's the only persisted state. No analytics, no logging, no crash reporting.

### App icon

Custom icon — soft peach background with a small SF-Symbol-style sparkles or heart mark in gold. To be designed at build time (Jon picks; placeholder OK at first install).

## Deployment

- **Bundle ID:** TBD by Jon at project setup (suggested: `com.<his-prefix>.nyctrip2026`). Uses his existing paid Apple Developer team.
- **Signing:** Jon's paid Apple Developer team. No App Store submission.
- **Install procedure:**
  1. Plug Katy's iPhone 15 into MacBook Air via USB-C.
  2. Open `NYCTrip2026.xcodeproj` in Xcode.
  3. Select Katy's device from the destination dropdown.
  4. Click Run. First time: Katy taps "Trust this computer" on her phone.
  5. App installs and lives on her phone for 1 year before re-signing.
- **Install date:** Target 2026-06-14 (one week before June 21 trip). No mid-trip re-install needed.
- **Distribution:** No TestFlight, no Ad Hoc, no Enterprise. Just Xcode → device.

## Out of scope (explicitly not building)

- Real-time location features / "are we there yet" geofencing
- Notifications / reminders
- Photos / memories capture
- Multi-user sync
- App Store submission
- Analytics / telemetry
- Network calls of any kind (the app is 100% offline except for deep-link handoffs)
- Daughter Jada's phone — single device only
- Pre-trip checklist functionality (that's the HTML site's job)
- Backwards-compatibility for older iOS

## Risks & open questions

1. **MyTix URL scheme** — `njtransit://` should launch the NJ Transit Mobile app. Verify at implementation time. Worst case the button does nothing if the app isn't installed; Jon installs it pre-trip so this should not surface in practice.
2. **DM Sans font licensing** — DM Sans is Open Font License (free for commercial and personal use). Confirm at bundle time.
3. **Universal link routing** — Google Maps and Uber universal HTTPS links assume iOS routes them to installed apps. iOS 17 should but verify on Katy's device early.
4. **Dynamic Type extreme sizes** — very large accessibility text may break the 2-line title constraint. Author titles short enough to survive at `.accessibility3` scale.
5. **Trip details may change** — if reservations get updated after install, requires re-installing. Acceptable cost given 1-year cert window.

---

## Approval gate

This spec is the design contract. Once Jon approves, we move to **writing-plans** (the implementation plan), then implementation. Any structural change after approval requires re-opening this spec.
