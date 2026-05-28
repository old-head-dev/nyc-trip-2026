# NYC Trip 2026 Companion App — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:subagent-driven-development` (recommended) or `superpowers:executing-plans` to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build and install a private SwiftUI companion app on Katy's iPhone 15 that walks her through the NYC trip (June 21–24, 2026) one task at a time with premium aesthetics and minimal cognitive load.

**Architecture:** Single-target SwiftUI app, iOS 17.0+. `TabView` with `.page` style as the root container, `@AppStorage` for last-step persistence, hardcoded `Step` array as content, deep links to Google Maps / Uber / NJ Transit Mobile via URL schemes and universal links. Custom illustrated hero artwork (15 PNGs) per step instead of SF Symbols. No third-party dependencies.

**Tech Stack:** Swift 5.10+, SwiftUI, Swift Testing (for unit tests), DM Sans (bundled TTFs), custom hero PNG artwork (bundled), Xcode latest stable.

**Spec:** `docs/superpowers/specs/2026-05-26-nyc-trip-app-design.md` — read this first if you haven't.

**Bundle ID:** `com.jonathanhering.NYCTrip2026` (Jonathan Hering's paid Apple Developer team).

**Target install date:** 2026-06-14 (one week before trip departure).

---

## Revision history

- **2026-05-26** — Initial plan (commit `947d9b4`). SF Symbol per step, 10-pastel rainbow palette, placeholder app icon.
- **2026-05-27** — Major revision: locked in `assets/icon.png` as final app icon; replaced SF Symbols with 14 custom illustrated hero PNGs (+ icon as welcome/closing hero); retuned palette from 10 rainbow pastels to 9 warm-family pastels (7 warm + 2 dusty-cool accents) for tonal unity with hero artwork; baked in concrete bundle ID. Asset catalog import added as Task 3.

---

## Skills to invoke during execution

- **`swiftui-pro`** — review every view file before committing; ensures modern API usage, no `Color.gray` placeholders, proper `@Observable`/`@State` boundaries.
- **`swift-testing-pro`** — use the new `@Test` / `#expect` macros (not XCTest) for all test code in this plan.
- **`swift-concurrency-pro`** — relevant if you touch `UIApplication.shared.open` callsites or any async work.
- **`/codex:review --adversarial`** — runs at three checkpoint gates in this plan.

---

## Asset inventory

Source assets live at the repo root (outside the Xcode project):

```
assets/
├── icon.png                          1024×1024 — used as AppIcon AND welcome/closing hero
└── screen heros/
    ├── breakfast.png                 600×600 — breakfasts (Blue Box, Sunday Morning, Liberty Bagels)
    ├── lunch.png                     600×600 — lunches (Via Quadronno OPTIONAL, Jack's Wife Freda)
    ├── dinner.png                    600×600 — dinners (Joe's Pizza, TAO Uptown, Day 3 pick)
    ├── hotel_building.png            600×600 — Jewel check-in, returns, check-out
    ├── sedan_car.png                 600×600 — drive day (Fort Wayne ↔ Metropark)
    ├── uber_car.png                  600×600 — Uber rides in-city
    ├── train_station.png             600×600 — Grand Central Terminal
    ├── subway_train.png              600×600 — NJ Transit train (Penn ↔ Metropark)
    ├── jellycat.png                  600×600 — Jellycat Diner at FAO Schwarz
    ├── central_park_spring.png       600×600 — Central Park walk
    ├── times_square.png              600×600 — Times Square first look
    ├── nyc_shopping.png              600×600 — Macy's, SoHo, Canal Street
    ├── fifth_ave_sign.png            600×600 — 5th Ave & Madison evening walk
    └── ice_cream_cone.png            600×600 — Museum of Ice Cream
```

All PNGs verified RGBA, real PNG format (not JPEG-in-PNG). Heroes have soft feathered/transparent edges that composite onto any pastel background. The icon's alpha channel is fully opaque (no real transparency) — flatten to RGB at AppIcon import time per the CLAUDE.md alpha-strip gotcha.

---

## Hero → Step mapping (final)

| # | Step | Hero | Palette |
|---|---|---|---|
| 0 | Welcome | `icon` | peach |
| 1 | Drive to Metropark | `sedan_car` | mist_blue |
| 2 | Park at Metropark | `sedan_car` | butter_cream |
| 3 | Train to NY Penn | `subway_train` | sage_cream |
| 4 | Uber to The Jewel | `uber_car` | clay |
| 5 | Check in at The Jewel | `hotel_building` | peach |
| 6 | Dinner at Joe's Pizza | `dinner` | dusty_rose |
| 7 | Times Square first look | `times_square` | butter_cream |
| 8 | Return to The Jewel | `hotel_building` | wisteria |
| 9 | Breakfast at Blue Box Café | `breakfast` | cream |
| 10 | Jellycat at FAO Schwarz | `jellycat` | blush |
| 11 | Visit Grand Central Terminal | `train_station` | butter_cream |
| 12 | OPTIONAL: Lunch at Via Quadronno | `lunch` | clay |
| 13 | Walk Central Park | `central_park_spring` | sage_cream |
| 14 | Herald Square & Macy's | `nyc_shopping` | dusty_rose |
| 15 | Back to hotel · Freshen up | `hotel_building` | wisteria |
| 16 | Dinner at TAO Uptown | `dinner` | dusty_rose |
| 17 | Breakfast at Sunday Morning | `breakfast` | butter_cream |
| 18 | SoHo shopping | `nyc_shopping` | blush |
| 19 | Canal Street | `nyc_shopping` | clay |
| 20 | Lunch at Jack's Wife Freda | `lunch` | cream |
| 21 | Museum of Ice Cream | `ice_cream_cone` | dusty_rose |
| 22 | Uber back to the hotel | `uber_car` | wisteria |
| 23 | Evening walk · 5th Ave & Madison | `fifth_ave_sign` | mist_blue |
| 24 | Dinner — pick a spot near hotel | `dinner` | clay |
| 25 | Breakfast at Liberty Bagels | `breakfast` | butter_cream |
| 26 | Back to The Jewel · Check out | `hotel_building` | peach |
| 27 | Uber to Penn Station | `uber_car` | clay |
| 28 | Train to Metropark | `subway_train` | sage_cream |
| 29 | Drive home to Fort Wayne | `sedan_car` | mist_blue |
| 30 | Closing — Welcome home | `icon` | peach |

Hero reuse: `icon` ×2, `sedan_car` ×3, `uber_car` ×3, `subway_train` ×2, `train_station` ×1, `hotel_building` ×4, `breakfast` ×3, `lunch` ×2, `dinner` ×3, `jellycat` ×1, `central_park_spring` ×1, `times_square` ×1, `nyc_shopping` ×3, `fifth_ave_sign` ×1, `ice_cream_cone` ×1. **Total: 31 steps using 15 unique assets.**

Palette frequency: peach ×4 (intentional bookend anchor: welcome, check-in, check-out, closing), blush ×2, dusty_rose ×4, clay ×5, cream ×2, butter_cream ×5, sage_cream ×3, mist_blue ×3, wisteria ×3.

---

## Color palette (revised — warm family)

All 9 palettes share a single design language: dusty, painterly, warm. Two cool palettes (`mist_blue`, `wisteria`) carry the same dusty undertone so they read as siblings, not outliers. All step backgrounds use a uniform warm-dark text color (`#2a2622`) and warm taupe secondary (`#6b5d52`) — palettes only vary `background` and `accent`. Accents are dark enough to support white text on the CTA pill (verified ≥4.5:1 against `#ffffff`).

| Token | Background | Accent | Used for (vibe) |
|---|---|---|---|
| `peach` | `#fbe9dc` | `#b85c38` | Welcome / closing / hotel check-in/out — matches icon |
| `blush` | `#f6e2d8` | `#b56b58` | Jellycat, SoHo — soft pink moments |
| `dusty_rose` | `#f0d3d8` | `#9c4a64` | Dinners, Macy's, Ice Cream — richer warm pink |
| `clay` | `#ecd9c8` | `#a05b2e` | Uber rides, Italian lunch, Canal Street, downtown dinner |
| `cream` | `#f8eedd` | `#8a6f3a` | Lighter breakfasts/lunches (Blue Box, Jack's Wife Freda) |
| `butter_cream` | `#f4e9cf` | `#9a7a2c` | Golden-hour beats: parking, Times Square, Grand Central, bakeries |
| `sage_cream` | `#e0e3d4` | `#5e6c4a` | Train rides, Central Park — quiet/nature |
| `mist_blue` | `#d8dfe5` | `#4d6a82` | Driving (1, 29), 5th Ave at dusk — journey/dusk moments |
| `wisteria` | `#dcd5dd` | `#6b5e75` | End-of-day hotel returns (8, 15, 22) — calm wind-down |

Universal text colors:
- `textPrimary`: `#2a2622` (warm near-black)
- `textSecondary`: `#6b5d52` (warm taupe)

---

## File Structure

```
NYCTrip2026/
├── NYCTrip2026.xcodeproj
├── NYCTrip2026/
│   ├── App/
│   │   └── NYCTrip2026App.swift          # @main entry
│   ├── Models/
│   │   ├── Step.swift                    # Step + ReservationDetail + CTA (hero: String)
│   │   └── DeepLinker.swift              # URL construction + open()
│   ├── Content/
│   │   └── Trip.swift                    # static let allSteps: [Step]
│   ├── Views/
│   │   ├── TripView.swift                # Root container
│   │   ├── StepView.swift                # Generic step renderer
│   │   ├── WelcomeView.swift             # Custom welcome layout
│   │   ├── ClosingView.swift             # Custom closing layout
│   │   ├── ReservationCard.swift         # Booking detail block
│   │   ├── NavBar.swift                  # Bottom Back/Dots/Next
│   │   └── CTAButton.swift               # Single CTA button label
│   ├── Theme/
│   │   ├── Color+Hex.swift               # Hex-string Color init
│   │   ├── Color+Tokens.swift            # Universal textPrimary/textSecondary
│   │   └── Font+DMSans.swift             # Font helpers
│   ├── Resources/
│   │   ├── Fonts/                        # DM Sans TTFs (4 files)
│   │   └── Assets.xcassets/
│   │       ├── AppIcon.appiconset/       # 1024×1024 (alpha-stripped icon.png)
│   │       ├── AccentColor.colorset/     # Xcode-default (unused at runtime)
│   │       ├── icon.imageset/            # Welcome/closing hero
│   │       ├── breakfast.imageset/
│   │       ├── central_park_spring.imageset/
│   │       ├── dinner.imageset/
│   │       ├── fifth_ave_sign.imageset/
│   │       ├── hotel_building.imageset/
│   │       ├── ice_cream_cone.imageset/
│   │       ├── jellycat.imageset/
│   │       ├── lunch.imageset/
│   │       ├── nyc_shopping.imageset/
│   │       ├── sedan_car.imageset/
│   │       ├── subway_train.imageset/
│   │       ├── times_square.imageset/
│   │       ├── train_station.imageset/
│   │       └── uber_car.imageset/
│   └── Info.plist                        # UIAppFonts + URL scheme allow list
└── NYCTrip2026Tests/
    ├── StepTests.swift
    ├── ReservationDetailTests.swift
    ├── CTATests.swift
    ├── DeepLinkerTests.swift
    ├── ColorHexTests.swift
    └── TripContentTests.swift
```

---

## Phase 0: Project Setup

### Task 1: Create the Xcode project

**Files:**
- Create: `NYCTrip2026.xcodeproj` (via Xcode UI)
- Create: `NYCTrip2026/` (group structure as above)
- Create: `NYCTrip2026Tests/` (unit test target)

- [ ] **Step 1: Open Xcode and create a new project**

In Xcode menu: File → New → Project... → iOS → App. Configure:
- Product Name: `NYCTrip2026`
- Team: **Jonathan Hering** (paid Apple Developer team)
- Organization Identifier: `com.jonathanhering`
- Bundle Identifier auto-fills as `com.jonathanhering.NYCTrip2026`
- Interface: **SwiftUI**
- Language: **Swift**
- Storage: **None** (we use `@AppStorage`)
- **Include Tests:** YES (creates the `NYCTrip2026Tests` target with Swift Testing as the default in Xcode 16+)
- Save location: `/Users/jkher/Documents/Claude/NYC Trip 2026/` (the existing repo root)

- [ ] **Step 2: Verify the project targets iOS 17.0+**

In Xcode: select the `NYCTrip2026` target → General tab → Minimum Deployments → set iOS to **17.0**.

- [ ] **Step 3: Set up the group structure**

In the Xcode file navigator, right-click the `NYCTrip2026` group → New Group. Create in order: `App`, `Models`, `Content`, `Views`, `Theme`, `Resources`. Move the auto-generated `NYCTrip2026App.swift` into `App/`. Move the auto-generated `ContentView.swift` into `Views/` for now (deleted at the end of Phase 5).

- [ ] **Step 4: Verify build succeeds**

Hit `⌘B`. Should build green with zero warnings.

- [ ] **Step 5: Commit**

```bash
cd "/Users/jkher/Documents/Claude/NYC Trip 2026"
git add NYCTrip2026.xcodeproj NYCTrip2026/ NYCTrip2026Tests/
git commit -m "Scaffold NYCTrip2026 Xcode project (iOS 17+, SwiftUI, Swift Testing, bundle com.jonathanhering.NYCTrip2026)"
```

---

### Task 2: Bundle DM Sans fonts and register them

**Files:**
- Create: `NYCTrip2026/Resources/Fonts/DMSans-Regular.ttf`
- Create: `NYCTrip2026/Resources/Fonts/DMSans-Medium.ttf`
- Create: `NYCTrip2026/Resources/Fonts/DMSans-SemiBold.ttf`
- Create: `NYCTrip2026/Resources/Fonts/DMSans-Bold.ttf`
- Modify: `NYCTrip2026/Info.plist`

- [ ] **Step 1: Download DM Sans from Google Fonts**

Visit `https://fonts.google.com/specimen/DM+Sans` → "Download family". Unzip. From the `static/` folder copy:
- `DMSans-Regular.ttf`
- `DMSans-Medium.ttf`
- `DMSans-SemiBold.ttf`
- `DMSans-Bold.ttf`

Drop into `NYCTrip2026/Resources/Fonts/`. In Xcode, drag the Fonts folder into the `Resources` group with "Copy items if needed" ✓ and "Add to targets: NYCTrip2026" ✓.

- [ ] **Step 2: Register fonts in Info.plist**

In Xcode select `Info.plist` → Add Row. Key: `UIAppFonts`, type Array. Four String entries:
```
Fonts/DMSans-Regular.ttf
Fonts/DMSans-Medium.ttf
Fonts/DMSans-SemiBold.ttf
Fonts/DMSans-Bold.ttf
```

- [ ] **Step 3: Verify fonts load**

Edit `ContentView.swift` temporarily:

```swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("DM Sans Regular").font(.custom("DMSans-Regular", size: 18))
            Text("DM Sans Medium").font(.custom("DMSans-Medium", size: 18))
            Text("DM Sans SemiBold").font(.custom("DMSans-SemiBold", size: 18))
            Text("DM Sans Bold").font(.custom("DMSans-Bold", size: 18))
        }
        .padding()
    }
}

#Preview { ContentView() }
```

Open canvas (`⌥⌘⏎`). If all four look identical, fonts aren't registered — verify Info.plist filenames match exactly (case sensitive, includes `Fonts/` prefix).

- [ ] **Step 4: Commit**

```bash
git add NYCTrip2026/Resources/Fonts/ NYCTrip2026/Info.plist NYCTrip2026/Views/ContentView.swift
git commit -m "Bundle and register DM Sans fonts (Regular/Medium/SemiBold/Bold)"
```

---

### Task 3: Import hero artwork and app icon into Assets.xcassets

**Files:**
- Create: `NYCTrip2026/Resources/Assets.xcassets/AppIcon.appiconset/icon.png` (alpha-stripped copy)
- Create: `NYCTrip2026/Resources/Assets.xcassets/<hero>.imageset/` × 15 (icon + 14 heroes)
- Modify: `NYCTrip2026/Resources/Assets.xcassets/AppIcon.appiconset/Contents.json`

- [ ] **Step 1: Strip the alpha channel on icon.png for the AppIcon slot**

iOS App Icon spec rejects PNGs with alpha channels (even fully-opaque ones). `assets/icon.png` is RGBA with fully-opaque alpha — flatten to RGB before importing. `sips --setProperty hasAlpha no` is broken on recent macOS (per CLAUDE.md gotcha), so use Python:

```bash
cd "/Users/jkher/Documents/Claude/NYC Trip 2026"
python3 -c "from PIL import Image; Image.open('assets/icon.png').convert('RGB').save('/tmp/icon-appicon.png', 'PNG')"
file /tmp/icon-appicon.png   # should report '8-bit/color RGB' (no alpha)
```

- [ ] **Step 2: Set up the AppIcon slot**

In Xcode: open `Assets.xcassets` → `AppIcon`. In Xcode 16+ the AppIcon set has a single 1024×1024 slot labeled "iOS Marketing" (auto-generates the smaller sizes at build time). Drag `/tmp/icon-appicon.png` into that slot.

Verify in the Inspector that the slot reads "1024×1024, RGB (no alpha)". If Xcode shows a yellow warning about alpha, repeat Step 1 (the conversion didn't take).

- [ ] **Step 3: Import the welcome/closing hero as an image set**

In `Assets.xcassets`, right-click → New Image Set. Name it `icon`. Drag `assets/icon.png` (the original RGBA — alpha is fine on a hero image since it composites over the step background) into the **Universal** slot (Xcode will use it across all scales).

Note: this is a separate copy from the AppIcon slot — the asset catalog stores each independently. We accept the ~1MB duplication for clarity.

- [ ] **Step 4: Import the 14 screen heroes**

For each of the 14 files in `assets/screen heros/`, repeat:
- In `Assets.xcassets`, right-click → New Image Set
- Name it to match the file (minus `.png`): `breakfast`, `central_park_spring`, `dinner`, `fifth_ave_sign`, `hotel_building`, `ice_cream_cone`, `jellycat`, `lunch`, `nyc_shopping`, `sedan_car`, `subway_train`, `times_square`, `train_station`, `uber_car`
- Drag the PNG into the **Universal** slot

Tip: Xcode lets you multi-select files in Finder and drag them all into the Asset Catalog navigator at once — it auto-creates one image set per file with matching names. Verify each ends up with its PNG in the Universal slot only (not 1x/2x/3x).

- [ ] **Step 5: Verify visually**

Click each image set in the catalog navigator. The right pane should show the artwork at full size. Visually confirm: 15 image sets total (`icon` + 14 heroes), all populated, all named in lowercase snake_case matching the source files.

- [ ] **Step 6: Smoke-test loading from code**

Edit `ContentView.swift` temporarily to render one hero:

```swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image("icon").resizable().scaledToFit().frame(height: 160)
            Image("breakfast").resizable().scaledToFit().frame(height: 160)
            Image("hotel_building").resizable().scaledToFit().frame(height: 160)
        }
        .padding()
        .background(Color(red: 0.984, green: 0.913, blue: 0.862))
    }
}

#Preview { ContentView() }
```

Open canvas. If any image renders as a blue question-mark or empty space, that asset name doesn't match the image set name — fix the catalog entry.

- [ ] **Step 7: Commit**

```bash
git add NYCTrip2026/Resources/Assets.xcassets/ NYCTrip2026/Views/ContentView.swift
git commit -m "Import app icon (alpha-stripped) and 15 hero image sets into Assets.xcassets"
```

---

## Phase 1: Theme primitives

### Task 4: Color hex initializer (TDD)

**Files:**
- Create: `NYCTrip2026/Theme/Color+Hex.swift`
- Create: `NYCTrip2026Tests/ColorHexTests.swift`

- [ ] **Step 1: Write the failing test**

Create `NYCTrip2026Tests/ColorHexTests.swift`:

```swift
import Testing
import SwiftUI
@testable import NYCTrip2026

@Suite("Color hex initializer")
struct ColorHexTests {
    @Test("parses 6-char hex with hash prefix")
    func parses6CharWithHash() {
        let color = Color(hex: "#fbe9dc")
        let components = color.cgColor?.components
        #expect(components != nil)
        #expect(abs((components?[0] ?? 0) - 0xfb / 255.0) < 0.01)
        #expect(abs((components?[1] ?? 0) - 0xe9 / 255.0) < 0.01)
        #expect(abs((components?[2] ?? 0) - 0xdc / 255.0) < 0.01)
    }

    @Test("parses 6-char hex without hash")
    func parses6CharWithoutHash() {
        let color = Color(hex: "2a2622")
        let components = color.cgColor?.components
        #expect(components != nil)
        #expect(abs((components?[0] ?? 0) - 0x2a / 255.0) < 0.01)
        #expect(abs((components?[1] ?? 0) - 0x26 / 255.0) < 0.01)
        #expect(abs((components?[2] ?? 0) - 0x22 / 255.0) < 0.01)
    }
}
```

- [ ] **Step 2: Run tests, verify they fail**

`⌘U`. Expect both to fail with "no exact match for 'Color.init(hex:)'".

- [ ] **Step 3: Implement Color+Hex.swift**

Create `NYCTrip2026/Theme/Color+Hex.swift`:

```swift
import SwiftUI

extension Color {
    /// Initialize from a 6-character hex string. Accepts optional leading `#`.
    /// Example: `Color(hex: "#fbe9dc")`, `Color(hex: "2a2622")`.
    init(hex: String) {
        let trimmed = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        let scanner = Scanner(string: trimmed)
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = Double((rgb & 0xFF0000) >> 16) / 255
        let g = Double((rgb & 0x00FF00) >> 8) / 255
        let b = Double(rgb & 0x0000FF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
```

- [ ] **Step 4: Run tests, verify they pass**

`⌘U`. Both pass.

- [ ] **Step 5: Commit**

```bash
git add NYCTrip2026/Theme/Color+Hex.swift NYCTrip2026Tests/ColorHexTests.swift
git commit -m "Add Color(hex:) initializer with tests"
```

---

### Task 5: Color tokens (universal text colors)

**Files:**
- Create: `NYCTrip2026/Theme/Color+Tokens.swift`

- [ ] **Step 1: Implement the token file**

Create `NYCTrip2026/Theme/Color+Tokens.swift`:

```swift
import SwiftUI

/// Universal text colors shared across all step screens. Per-step palettes only vary
/// background and accent — text colors are fixed to maintain consistent legibility
/// and reinforce the warm/dusty design language.
extension Color {
    static let tripTextPrimary   = Color(hex: "#2a2622")  // warm near-black
    static let tripTextSecondary = Color(hex: "#6b5d52")  // warm taupe
}
```

- [ ] **Step 2: Verify build**

`⌘B`. Clean.

- [ ] **Step 3: Commit**

```bash
git add NYCTrip2026/Theme/Color+Tokens.swift
git commit -m "Add universal trip text color tokens (primary warm-black, secondary taupe)"
```

---

### Task 6: Font helper

**Files:**
- Create: `NYCTrip2026/Theme/Font+DMSans.swift`

- [ ] **Step 1: Implement the helper**

Create `NYCTrip2026/Theme/Font+DMSans.swift`:

```swift
import SwiftUI

enum DMSansWeight {
    case regular, medium, semibold, bold

    var fontName: String {
        switch self {
        case .regular:  return "DMSans-Regular"
        case .medium:   return "DMSans-Medium"
        case .semibold: return "DMSans-SemiBold"
        case .bold:     return "DMSans-Bold"
        }
    }
}

extension Font {
    /// Convenience for our bundled DM Sans family.
    /// Falls back to SF Pro automatically if the custom font fails to load.
    static func dmSans(_ weight: DMSansWeight, size: CGFloat) -> Font {
        .custom(weight.fontName, size: size)
    }
}
```

- [ ] **Step 2: Verify build**

`⌘B`. Clean.

- [ ] **Step 3: Commit**

```bash
git add NYCTrip2026/Theme/Font+DMSans.swift
git commit -m "Add Font.dmSans helper for bundled DM Sans family"
```

---

## Phase 2: Data Model

### Task 7: Step + ReservationDetail + CTA (TDD)

**Files:**
- Create: `NYCTrip2026/Models/Step.swift`
- Create: `NYCTrip2026Tests/StepTests.swift`

- [ ] **Step 1: Write the failing tests**

Create `NYCTrip2026Tests/StepTests.swift`:

```swift
import Testing
import SwiftUI
@testable import NYCTrip2026

@Suite("Step model")
struct StepTests {
    @Test("Step holds all required fields")
    func stepFields() {
        let step = Step(
            id: 1,
            day: 1,
            dayLabel: "Day 1 · 1 of 8",
            hero: "sedan_car",
            title: "Drive to Metropark",
            subtitle: "Iselin, NJ · ~640 mi",
            reservation: nil,
            ctas: [.openInGoogleMaps(destination: "Metropark Station, Iselin NJ", label: "Open in Google Maps")],
            background: Color(hex: "#d8dfe5"),
            accent: Color(hex: "#4d6a82")
        )
        #expect(step.id == 1)
        #expect(step.day == 1)
        #expect(step.hero == "sedan_car")
        #expect(step.ctas.count == 1)
    }

    @Test("ReservationDetail holds confirmation and extra")
    func reservationDetailFields() {
        let res = ReservationDetail(
            time: "10:00 AM",
            address: "727 5th Ave, 5th Floor",
            confirmation: "ABC123",
            extra: "Breakfast for 2"
        )
        #expect(res.time == "10:00 AM")
        #expect(res.confirmation == "ABC123")
    }
}
```

- [ ] **Step 2: Run tests, verify they fail**

`⌘U`. Tests fail — no `Step` type.

- [ ] **Step 3: Implement Step.swift**

Create `NYCTrip2026/Models/Step.swift`:

```swift
import SwiftUI

struct Step: Identifiable {
    let id: Int
    let day: Int                  // 1...4 for trip days; 0 = welcome; 5 = closing
    let dayLabel: String          // e.g., "Day 2 · 6 of 8"
    let hero: String              // Asset catalog image set name (e.g., "breakfast", "icon")
    let title: String             // 1-2 lines
    let subtitle: String?         // optional, 1-2 lines
    let reservation: ReservationDetail?
    let ctas: [CTA]               // 0, 1, or 2 buttons
    let background: Color
    let accent: Color
}

struct ReservationDetail {
    let time: String              // "10:00 AM" or "Check-in 3:00 PM"
    let address: String           // "727 5th Ave, 5th Floor"
    let confirmation: String?     // "#351207910" or hotel conf #, optional
    let extra: String?            // "Room: King Suite" or "Breakfast for 2", optional
}

enum CTA {
    case openInGoogleMaps(destination: String?, label: String)  // nil = Maps with no preset
    case openInUber(destination: String, label: String)
    case openMyTix(label: String)
    case callPhone(number: String, label: String)
    case openURL(URL, label: String)

    var label: String {
        switch self {
        case .openInGoogleMaps(_, let label),
             .openInUber(_, let label),
             .openMyTix(let label),
             .callPhone(_, let label),
             .openURL(_, let label):
            return label
        }
    }
}
```

- [ ] **Step 4: Run tests, verify they pass**

`⌘U`. Both pass.

- [ ] **Step 5: Commit**

```bash
git add NYCTrip2026/Models/Step.swift NYCTrip2026Tests/StepTests.swift
git commit -m "Add Step + ReservationDetail + CTA model with tests (hero field, no symbol)"
```

---

### Task 8: DeepLinker URL construction (TDD)

**Files:**
- Create: `NYCTrip2026/Models/DeepLinker.swift`
- Create: `NYCTrip2026Tests/DeepLinkerTests.swift`

- [ ] **Step 1: Write the failing tests**

Create `NYCTrip2026Tests/DeepLinkerTests.swift`:

```swift
import Testing
import Foundation
@testable import NYCTrip2026

@Suite("DeepLinker URL construction")
struct DeepLinkerTests {
    @Test("Google Maps with address builds universal link with URL-encoded destination")
    func googleMapsWithAddress() {
        let cta = CTA.openInGoogleMaps(destination: "Joe's Pizza, 1435 Broadway, NY", label: "Open in Google Maps")
        let url = DeepLinker.url(for: cta)
        #expect(url?.absoluteString == "https://www.google.com/maps/dir/?api=1&destination=Joe's%20Pizza,%201435%20Broadway,%20NY")
    }

    @Test("Google Maps with nil destination opens the app generically")
    func googleMapsNoDestination() {
        let cta = CTA.openInGoogleMaps(destination: nil, label: "Open Google Maps")
        let url = DeepLinker.url(for: cta)
        #expect(url?.absoluteString == "comgooglemaps://")
    }

    @Test("Uber builds universal link with dropoff address")
    func uberWithDestination() {
        let cta = CTA.openInUber(destination: "11 W 51st St, New York, NY", label: "Open in Uber")
        let url = DeepLinker.url(for: cta)
        let expected = "https://m.uber.com/ul/?action=setPickup&pickup=my_location&dropoff%5Bformatted_address%5D=11%20W%2051st%20St,%20New%20York,%20NY"
        #expect(url?.absoluteString == expected)
    }

    @Test("MyTix uses njtransit scheme")
    func myTixScheme() {
        let cta = CTA.openMyTix(label: "Open MyTix")
        let url = DeepLinker.url(for: cta)
        #expect(url?.absoluteString == "njtransit://")
    }

    @Test("Phone uses tel scheme")
    func phoneScheme() {
        let cta = CTA.callPhone(number: "212-555-1212", label: "Call")
        let url = DeepLinker.url(for: cta)
        #expect(url?.absoluteString == "tel:212-555-1212")
    }
}
```

- [ ] **Step 2: Run tests, verify they fail**

`⌘U`. Five failures, no `DeepLinker` type.

- [ ] **Step 3: Implement DeepLinker.swift**

Create `NYCTrip2026/Models/DeepLinker.swift`:

```swift
import Foundation
#if canImport(UIKit)
import UIKit
#endif

enum DeepLinker {
    static func url(for cta: CTA) -> URL? {
        switch cta {
        case let .openInGoogleMaps(destination, _):
            guard let destination, !destination.isEmpty else {
                return URL(string: "comgooglemaps://")
            }
            var components = URLComponents(string: "https://www.google.com/maps/dir/")!
            components.queryItems = [
                URLQueryItem(name: "api", value: "1"),
                URLQueryItem(name: "destination", value: destination)
            ]
            return components.url

        case let .openInUber(destination, _):
            var components = URLComponents(string: "https://m.uber.com/ul/")!
            components.queryItems = [
                URLQueryItem(name: "action", value: "setPickup"),
                URLQueryItem(name: "pickup", value: "my_location"),
                URLQueryItem(name: "dropoff[formatted_address]", value: destination)
            ]
            return components.url

        case .openMyTix:
            return URL(string: "njtransit://")

        case let .callPhone(number, _):
            return URL(string: "tel:\(number)")

        case let .openURL(url, _):
            return url
        }
    }

    /// Opens the URL via UIApplication. No-op if the URL is nil or cannot be opened.
    @MainActor
    static func open(_ cta: CTA) {
        #if canImport(UIKit)
        guard let url = url(for: cta), UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
        #endif
    }
}
```

- [ ] **Step 4: Run tests, verify they pass**

`⌘U`. All five pass.

- [ ] **Step 5: Commit**

```bash
git add NYCTrip2026/Models/DeepLinker.swift NYCTrip2026Tests/DeepLinkerTests.swift
git commit -m "Add DeepLinker URL construction with tests"
```

---

## Phase 3: Content

### Task 9: Trip.allSteps with all 31 screens

**Files:**
- Create: `NYCTrip2026/Content/Trip.swift`

- [ ] **Step 1: Author the full step array**

Create `NYCTrip2026/Content/Trip.swift`:

```swift
import SwiftUI

enum Trip {

    // MARK: Color palette (warm-family + 2 dusty-cool accents)

    private static let peach        = (bg: "#fbe9dc", accent: "#b85c38")
    private static let blush        = (bg: "#f6e2d8", accent: "#b56b58")
    private static let dustyRose    = (bg: "#f0d3d8", accent: "#9c4a64")
    private static let clay         = (bg: "#ecd9c8", accent: "#a05b2e")
    private static let cream        = (bg: "#f8eedd", accent: "#8a6f3a")
    private static let butterCream  = (bg: "#f4e9cf", accent: "#9a7a2c")
    private static let sageCream    = (bg: "#e0e3d4", accent: "#5e6c4a")
    private static let mistBlue     = (bg: "#d8dfe5", accent: "#4d6a82")
    private static let wisteria     = (bg: "#dcd5dd", accent: "#6b5e75")

    private static func colors(_ p: (bg: String, accent: String)) -> (Color, Color) {
        (Color(hex: p.bg), Color(hex: p.accent))
    }

    // MARK: Step factory

    private static func step(
        id: Int, day: Int, dayLabel: String,
        hero: String, title: String, subtitle: String? = nil,
        reservation: ReservationDetail? = nil,
        ctas: [CTA] = [],
        palette: (bg: String, accent: String)
    ) -> Step {
        let (bg, accent) = colors(palette)
        return Step(
            id: id, day: day, dayLabel: dayLabel,
            hero: hero, title: title, subtitle: subtitle,
            reservation: reservation, ctas: ctas,
            background: bg, accent: accent
        )
    }

    // MARK: The trip

    static let welcomeStep = step(
        id: 0, day: 0, dayLabel: "NYC Trip · June 21–24, 2026",
        hero: "icon",
        title: "Katy and Jada…",
        subtitle: "Welcome to your\nNYC trip!\n\nJune 21–24, 2026",
        palette: peach
    )

    static let closingStep = step(
        id: 999, day: 5, dayLabel: "Trip complete",
        hero: "icon",
        title: "Welcome home!",
        subtitle: "Hope you loved every minute.",
        palette: peach
    )

    static let day1: [Step] = [
        step(id: 1, day: 1, dayLabel: "Day 1 · 1 of 8",
             hero: "sedan_car", title: "Drive to\nMetropark Station",
             subtitle: "Iselin, NJ · ~640 miles\nDepart Fort Wayne by 7 AM",
             ctas: [.openInGoogleMaps(destination: "Metropark Station, Iselin, NJ", label: "Open in Google Maps")],
             palette: mistBlue),

        step(id: 2, day: 1, dayLabel: "Day 1 · 2 of 8",
             hero: "sedan_car", title: "Park at Metropark",
             subtitle: "NexPass reads your plate automatically.\nNo ticket. Just drive in.",
             palette: butterCream),

        step(id: 3, day: 1, dayLabel: "Day 1 · 3 of 8",
             hero: "subway_train", title: "Take the train\nto NY Penn",
             subtitle: "Northeast Corridor line · ~45 min\nActivate your MyTix ticket at the platform.",
             ctas: [.openMyTix(label: "Open MyTix")],
             palette: sageCream),

        step(id: 4, day: 1, dayLabel: "Day 1 · 4 of 8",
             hero: "uber_car", title: "Uber to The Jewel",
             subtitle: "From Penn Station · ~10 min",
             ctas: [.openInUber(destination: "The Jewel New York, 11 W 51st St, New York, NY", label: "Open in Uber")],
             palette: clay),

        step(id: 5, day: 1, dayLabel: "Day 1 · 5 of 8",
             hero: "hotel_building", title: "Check in at\nThe Jewel",
             subtitle: "11 W 51st St · directly across from Rockefeller Center",
             reservation: ReservationDetail(
                time: "Check-in 3:00 PM",
                address: "11 W 51st St, New York, NY 10019",
                confirmation: "(confirmation # — Jon to fill in)",
                extra: "(room type — Jon to fill in)"
             ),
             palette: peach),

        step(id: 6, day: 1, dayLabel: "Day 1 · 6 of 8",
             hero: "dinner", title: "Dinner at\nJoe's Pizza",
             subtitle: "1435 Broadway · Original NYC slice joint\nGrab slices, walk Times Square after.",
             ctas: [.openInGoogleMaps(destination: "Joe's Pizza, 1435 Broadway, New York, NY", label: "Open in Google Maps")],
             palette: dustyRose),

        step(id: 7, day: 1, dayLabel: "Day 1 · 7 of 8",
             hero: "times_square", title: "Times Square\nfirst look",
             subtitle: "Best at night when the lights are full.\nNo rush tonight.",
             ctas: [.openInGoogleMaps(destination: "Times Square, New York, NY", label: "Open in Google Maps")],
             palette: butterCream),

        step(id: 8, day: 1, dayLabel: "Day 1 · 8 of 8",
             hero: "hotel_building", title: "Return to\nThe Jewel",
             subtitle: "Call it an early night.",
             ctas: [.openInGoogleMaps(destination: "The Jewel New York, 11 W 51st St, New York, NY", label: "Open in Google Maps")],
             palette: wisteria),
    ]

    static let day2: [Step] = [
        step(id: 9, day: 2, dayLabel: "Day 2 · 1 of 8",
             hero: "breakfast", title: "Breakfast at\nBlue Box Café",
             subtitle: "4-min walk from the hotel.",
             reservation: ReservationDetail(
                time: "10:00 AM",
                address: "727 5th Ave, 5th Floor",
                confirmation: nil,
                extra: "Breakfast for 2"
             ),
             ctas: [.openInGoogleMaps(destination: "Tiffany & Co., 727 5th Ave, New York, NY", label: "Open in Google Maps")],
             palette: cream),

        step(id: 10, day: 2, dayLabel: "Day 2 · 2 of 8",
             hero: "jellycat", title: "Jellycat Diner\nat FAO Schwarz",
             subtitle: "5-min walk from Tiffany's.\nArrive a few minutes early — 10-min slot.",
             reservation: ReservationDetail(
                time: "11:50 AM – 12:00 PM",
                address: "30 Rockefeller Plaza, 1st floor",
                confirmation: "#351207910",
                extra: nil
             ),
             ctas: [.openInGoogleMaps(destination: "FAO Schwarz, 30 Rockefeller Plaza, New York, NY", label: "Open in Google Maps")],
             palette: blush),

        step(id: 11, day: 2, dayLabel: "Day 2 · 3 of 8",
             hero: "train_station", title: "Visit Grand\nCentral Terminal",
             subtitle: "Celestial ceiling, Whispering Gallery, Grand Central Market.",
             ctas: [.openInGoogleMaps(destination: "Grand Central Terminal, 89 E 42nd St, New York, NY", label: "Open in Google Maps")],
             palette: butterCream),

        step(id: 12, day: 2, dayLabel: "Day 2 · 4 of 8",
             hero: "lunch", title: "OPTIONAL: Lunch at\nVia Quadronno",
             subtitle: "25 E 73rd St · steps from Central Park east entrance.\nSkip if breakfast still holds.",
             ctas: [.openInGoogleMaps(destination: "Via Quadronno, 25 E 73rd St, New York, NY", label: "Open in Google Maps")],
             palette: clay),

        step(id: 13, day: 2, dayLabel: "Day 2 · 5 of 8",
             hero: "central_park_spring", title: "Walk Central Park",
             subtitle: "Strawberry Fields → Bow Bridge → Bethesda Fountain → The Mall.",
             ctas: [
                .openInGoogleMaps(destination: "Bethesda Fountain, Central Park, New York, NY", label: "Open in Google Maps · Walk"),
                .openInUber(destination: "Bethesda Fountain, Central Park, New York, NY", label: "Open in Uber · Drive")
             ],
             palette: sageCream),

        step(id: 14, day: 2, dayLabel: "Day 2 · 6 of 8",
             hero: "nyc_shopping", title: "Herald Square\n& Macy's",
             subtitle: "11 floors, world's largest department store.",
             ctas: [.openInUber(destination: "Macy's Herald Square, 151 W 34th St, New York, NY", label: "Open in Uber")],
             palette: dustyRose),

        step(id: 15, day: 2, dayLabel: "Day 2 · 7 of 8",
             hero: "hotel_building", title: "Back to hotel\nFreshen up",
             subtitle: "TAO is the dress-up dinner.",
             ctas: [
                .openInGoogleMaps(destination: "The Jewel New York, 11 W 51st St, New York, NY", label: "Open in Google Maps · Walk"),
                .openInUber(destination: "The Jewel New York, 11 W 51st St, New York, NY", label: "Open in Uber · Drive")
             ],
             palette: wisteria),

        step(id: 16, day: 2, dayLabel: "Day 2 · 8 of 8",
             hero: "dinner", title: "Dinner at\nTAO Uptown",
             subtitle: "Dramatic pan-Asian. Dress up.",
             reservation: ReservationDetail(
                time: "6:30 PM",
                address: "42 E 58th St",
                confirmation: "(OpenTable conf # — Jon to fill in)",
                extra: nil
             ),
             ctas: [.openInGoogleMaps(destination: "TAO Uptown, 42 E 58th St, New York, NY", label: "Open in Google Maps")],
             palette: dustyRose),
    ]

    static let day3: [Step] = [
        step(id: 17, day: 3, dayLabel: "Day 3 · 1 of 8",
             hero: "breakfast", title: "Breakfast at\nSunday Morning",
             subtitle: "29 W 25th St · Cinnamon rolls are the reason to go.",
             ctas: [.openInUber(destination: "Sunday Morning Bakehouse, 29 W 25th St, New York, NY", label: "Open in Uber")],
             palette: butterCream),

        step(id: 18, day: 3, dayLabel: "Day 3 · 2 of 8",
             hero: "nyc_shopping", title: "SoHo shopping",
             subtitle: "Broadway, Spring, Prince. Walk once you arrive.",
             ctas: [.openInUber(destination: "SoHo, Broadway & Spring St, New York, NY", label: "Open in Uber")],
             palette: blush),

        step(id: 19, day: 3, dayLabel: "Day 3 · 3 of 8",
             hero: "nyc_shopping", title: "Canal Street",
             subtitle: "Chinatown market vibe · ~11-min walk from SoHo.",
             ctas: [.openInGoogleMaps(destination: "Canal Street, Chinatown, New York, NY", label: "Open in Google Maps")],
             palette: clay),

        step(id: 20, day: 3, dayLabel: "Day 3 · 4 of 8",
             hero: "lunch", title: "Lunch at\nJack's Wife Freda",
             subtitle: "226 Lafayette St · Mediterranean-American, casual.",
             ctas: [.openInGoogleMaps(destination: "Jack's Wife Freda, 226 Lafayette St, New York, NY", label: "Open in Google Maps")],
             palette: cream),

        step(id: 21, day: 3, dayLabel: "Day 3 · 5 of 8",
             hero: "ice_cream_cone", title: "Museum of\nIce Cream",
             subtitle: "Interactive immersive experience.\nAllow 60–90 min inside.",
             reservation: ReservationDetail(
                time: "(time set by ticket purchase)",
                address: "558 Broadway, SoHo",
                confirmation: "(ticket conf # — Jon to fill in)",
                extra: nil
             ),
             ctas: [.openInGoogleMaps(destination: "Museum of Ice Cream, 558 Broadway, New York, NY", label: "Open in Google Maps")],
             palette: dustyRose),

        step(id: 22, day: 3, dayLabel: "Day 3 · 6 of 8",
             hero: "uber_car", title: "Uber back\nto the hotel",
             subtitle: "Freshen up before evening.",
             ctas: [.openInUber(destination: "The Jewel New York, 11 W 51st St, New York, NY", label: "Open in Uber")],
             palette: wisteria),

        step(id: 23, day: 3, dayLabel: "Day 3 · 7 of 8",
             hero: "fifth_ave_sign", title: "Evening walk\n5th Ave & Madison",
             subtitle: "Storefronts at dusk. Tiffany's, Bergdorf, Saks.\n4-min walk from the hotel.",
             palette: mistBlue),

        step(id: 24, day: 3, dayLabel: "Day 3 · 8 of 8",
             hero: "dinner", title: "Dinner — pick\na spot near hotel",
             subtitle: "Open call. Use Google Maps to search.",
             ctas: [.openInGoogleMaps(destination: nil, label: "Open Google Maps")],
             palette: clay),
    ]

    static let day4: [Step] = [
        step(id: 25, day: 4, dayLabel: "Day 4 · 1 of 5",
             hero: "breakfast", title: "Breakfast at\nLiberty Bagels",
             subtitle: "Classic NY bagel · Grab and go.",
             ctas: [.openInGoogleMaps(destination: "Liberty Bagels Midtown, 260 W 35th St, New York, NY", label: "Open in Google Maps")],
             palette: butterCream),

        step(id: 26, day: 4, dayLabel: "Day 4 · 2 of 5",
             hero: "hotel_building", title: "Back to The Jewel\nCheck out",
             subtitle: "Checkout by 12:00 PM (noon).\nFront desk can hold bags if you want to stroll.",
             ctas: [.openInGoogleMaps(destination: "The Jewel New York, 11 W 51st St, New York, NY", label: "Open in Google Maps")],
             palette: peach),

        step(id: 27, day: 4, dayLabel: "Day 4 · 3 of 5",
             hero: "uber_car", title: "Uber to\nPenn Station",
             subtitle: "Aim to be at Penn by 11 AM.",
             ctas: [.openInUber(destination: "Moynihan Train Hall, 31st St & 8th Ave, New York, NY", label: "Open in Uber")],
             palette: clay),

        step(id: 28, day: 4, dayLabel: "Day 4 · 4 of 5",
             hero: "subway_train", title: "Take the train\nto Metropark",
             subtitle: "Northeast Corridor line · ~45 min\nActivate your MyTix ticket at the platform.",
             ctas: [.openMyTix(label: "Open MyTix")],
             palette: sageCream),

        step(id: 29, day: 4, dayLabel: "Day 4 · 5 of 5",
             hero: "sedan_car", title: "Drive home\nto Fort Wayne",
             subtitle: "NexPass reads your plate on the way out — no parking ticket to pay.\nHome by 9–10 PM.",
             ctas: [.openInGoogleMaps(destination: "Fort Wayne, IN", label: "Open in Google Maps")],
             palette: mistBlue),
    ]

    static let allSteps: [Step] = [welcomeStep] + day1 + day2 + day3 + day4 + [closingStep]

    /// Set of all asset names referenced by `allSteps`. Used in tests to verify every
    /// hero name resolves to a bundled image.
    static var referencedHeroNames: Set<String> { Set(allSteps.map(\.hero)) }
}
```

- [ ] **Step 2: Verify build**

`⌘B`. Compiles cleanly. If anything fails, fix typos.

- [ ] **Step 3: Commit**

```bash
git add NYCTrip2026/Content/Trip.swift
git commit -m "Author Trip.allSteps: 31 screens with warm palette + hero artwork mapping"
```

---

### Task 10: Content integrity tests

**Files:**
- Create: `NYCTrip2026Tests/TripContentTests.swift`

- [ ] **Step 1: Write the integrity tests**

Create `NYCTrip2026Tests/TripContentTests.swift`:

```swift
import Testing
import UIKit
@testable import NYCTrip2026

@Suite("Trip content integrity")
struct TripContentTests {
    @Test("Step ids are unique")
    func uniqueIds() {
        let ids = Trip.allSteps.map(\.id)
        #expect(ids.count == Set(ids).count, "Duplicate step IDs found")
    }

    @Test("Day values are in valid range 0...5")
    func dayValuesInRange() {
        for step in Trip.allSteps {
            #expect((0...5).contains(step.day), "Step id \(step.id) has invalid day \(step.day)")
        }
    }

    @Test("Welcome is first and closing is last")
    func bookends() {
        #expect(Trip.allSteps.first?.day == 0)
        #expect(Trip.allSteps.last?.day == 5)
        #expect(Trip.allSteps.first?.hero == "icon")
        #expect(Trip.allSteps.last?.hero == "icon")
    }

    @Test("Days flow forward: 0, 1...1, 2...2, 3...3, 4...4, 5")
    func daysAscend() {
        var prev = -1
        for step in Trip.allSteps {
            #expect(step.day >= prev, "Step id \(step.id) day \(step.day) went backwards from \(prev)")
            prev = step.day
        }
    }

    @Test("Every CTA has a non-empty label")
    func ctaLabelsNonEmpty() {
        for step in Trip.allSteps {
            for cta in step.ctas {
                #expect(!cta.label.isEmpty, "Empty CTA label on step id \(step.id)")
            }
        }
    }

    @Test("No step has more than two CTAs")
    func atMostTwoCTAs() {
        for step in Trip.allSteps {
            #expect(step.ctas.count <= 2, "Step id \(step.id) has \(step.ctas.count) CTAs (max 2)")
        }
    }

    @Test("Total step count is 31 (welcome + 29 + closing)")
    func totalCount() {
        #expect(Trip.allSteps.count == 31)
    }

    @Test("Every step's hero name is non-empty")
    func heroNamesNonEmpty() {
        for step in Trip.allSteps {
            #expect(!step.hero.isEmpty, "Step id \(step.id) has empty hero name")
        }
    }

    @Test("Every referenced hero name resolves to a bundled image asset")
    func heroAssetsExist() {
        for name in Trip.referencedHeroNames {
            #expect(UIImage(named: name) != nil, "Asset catalog has no image named '\(name)'")
        }
    }

    @Test("Reservation + 2 CTAs never coincide (layout space invariant)")
    func reservationAndTwoCTAsExclusive() {
        for step in Trip.allSteps {
            if step.reservation != nil {
                #expect(step.ctas.count <= 1, "Step id \(step.id) has both a reservation card and >1 CTA — layout will overflow")
            }
        }
    }
}
```

- [ ] **Step 2: Run tests, verify they pass**

`⌘U`. All ten pass. If `heroAssetsExist` fails, an image set is misnamed in `Assets.xcassets` — fix the catalog. If `reservationAndTwoCTAsExclusive` fails, restructure the offending step in `Trip.swift`.

- [ ] **Step 3: Commit**

```bash
git add NYCTrip2026Tests/TripContentTests.swift
git commit -m "Add Trip content integrity tests (ids, days, CTAs, bookends, hero assets, layout invariant)"
```

---

## ✅ CHECKPOINT 1: Codex Adversarial Review (passed 2026-05-27)

**Stop here. Before building any views, run an adversarial review of the data + content + URL construction + asset wiring.**

- [ ] **Step 1: Push current state**

```bash
git push origin main
```

- [ ] **Step 2: Run the adversarial review**

In Claude Code: `/codex:review --adversarial`.

- [ ] **Step 3: Address every finding**

For each finding:
- If real: fix in a follow-up commit (`fix: address Codex review — <topic>`).
- If false positive: document inline with a one-sentence note.
- If unclear: ask Jon before deciding.

- [ ] **Step 4: Re-run if you made changes**

If any fixes shipped, re-run `/codex:review --adversarial` to confirm clean.

- [ ] **Step 5: Mark checkpoint complete**

Edit this plan file: change the heading to `## ✅ CHECKPOINT 1: Codex Adversarial Review (passed YYYY-MM-DD)`. Commit:

```bash
git add docs/superpowers/plans/2026-05-26-nyc-trip-app-implementation.md
git commit -m "Mark Checkpoint 1 passed"
```

---

## Phase 4: Views

### Task 11: ReservationCard view

**Files:**
- Create: `NYCTrip2026/Views/ReservationCard.swift`

- [ ] **Step 1: Build the card**

Create `NYCTrip2026/Views/ReservationCard.swift`:

```swift
import SwiftUI

struct ReservationCard: View {
    let detail: ReservationDetail
    let accent: Color

    @State private var didCopy = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Circle().fill(accent).frame(width: 6, height: 6)
                Text(detail.time)
                    .font(.dmSans(.semibold, size: 13))
                    .foregroundStyle(.tripTextPrimary)
            }
            Text(detail.address)
                .font(.dmSans(.regular, size: 13))
                .foregroundStyle(.tripTextSecondary)
            if let conf = detail.confirmation {
                Button {
                    UIPasteboard.general.string = conf
                    didCopy = true
                    let haptic = UIImpactFeedbackGenerator(style: .soft)
                    haptic.impactOccurred()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { didCopy = false }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: didCopy ? "checkmark" : "doc.on.doc")
                            .font(.system(size: 11, weight: .semibold))
                        Text(didCopy ? "Copied" : conf)
                            .font(.dmSans(.medium, size: 12))
                    }
                    .foregroundStyle(accent)
                }
            }
            if let extra = detail.extra {
                Text(extra)
                    .font(.dmSans(.regular, size: 12))
                    .foregroundStyle(.tripTextSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.white.opacity(0.85))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(accent.opacity(0.18), lineWidth: 1)
        )
    }
}

#Preview {
    ReservationCard(
        detail: ReservationDetail(
            time: "10:00 AM",
            address: "727 5th Ave, 5th Floor",
            confirmation: "#351207910",
            extra: "Breakfast for 2"
        ),
        accent: Color(hex: "#8a6f3a")
    )
    .padding()
    .background(Color(hex: "#f8eedd"))
}
```

- [ ] **Step 2: Eyeball the preview**

Open canvas. Cream background, soft white card, accent-colored time row dot, tappable confirmation number.

- [ ] **Step 3: Commit**

```bash
git add NYCTrip2026/Views/ReservationCard.swift
git commit -m "Add ReservationCard view with copy-to-clipboard confirmation"
```

---

### Task 12: NavBar view

**Files:**
- Create: `NYCTrip2026/Views/NavBar.swift`

- [ ] **Step 1: Build the nav bar**

Create `NYCTrip2026/Views/NavBar.swift`:

```swift
import SwiftUI

struct NavBar: View {
    let currentIndex: Int
    let totalCount: Int
    let onBack: () -> Void
    let onNext: () -> Void
    let accent: Color

    var isFirst: Bool { currentIndex == 0 }
    var isLast: Bool { currentIndex == totalCount - 1 }

    var body: some View {
        HStack {
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.tripTextPrimary)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle().fill(Color.tripTextPrimary.opacity(0.08))
                    )
            }
            .opacity(isFirst ? 0 : 1)
            .disabled(isFirst)

            Spacer()

            HStack(spacing: 5) {
                ForEach(0..<min(totalCount, 8), id: \.self) { i in
                    Capsule()
                        .fill(i == min(currentIndex, 7) ? accent : Color.tripTextPrimary.opacity(0.18))
                        .frame(width: i == min(currentIndex, 7) ? 18 : 5, height: 5)
                }
            }

            Spacer()

            Button(action: onNext) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.tripTextPrimary)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle().fill(Color.tripTextPrimary.opacity(0.08))
                    )
            }
            .opacity(isLast ? 0 : 1)
            .disabled(isLast)
        }
    }
}

#Preview {
    NavBar(
        currentIndex: 2,
        totalCount: 8,
        onBack: {},
        onNext: {},
        accent: Color(hex: "#4d6a82")
    )
    .padding()
    .background(Color(hex: "#d8dfe5"))
}
```

- [ ] **Step 2: Eyeball preview**

Mist-blue background, subtle back button, 8 dots with one active (wider, accent-colored), forward button.

- [ ] **Step 3: Commit**

```bash
git add NYCTrip2026/Views/NavBar.swift
git commit -m "Add NavBar view (back/dots/next) using universal text tokens"
```

---

### Task 13: CTAButton view

**Files:**
- Create: `NYCTrip2026/Views/CTAButton.swift`

- [ ] **Step 1: Build the button**

CTA buttons keep small inline SF Symbols (mappin / car / train / phone / link) — these are standard UI affordances, not branded illustration moments.

Create `NYCTrip2026/Views/CTAButton.swift`:

```swift
import SwiftUI

struct CTAButton: View {
    let cta: CTA
    let accent: Color

    var body: some View {
        Button {
            DeepLinker.open(cta)
        } label: {
            HStack(spacing: 8) {
                Image(systemName: symbolName)
                    .font(.system(size: 14, weight: .semibold))
                Text(cta.label)
                    .font(.dmSans(.semibold, size: 14))
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 18)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(accent)
            )
        }
    }

    private var symbolName: String {
        switch cta {
        case .openInGoogleMaps: return "mappin.and.ellipse"
        case .openInUber:       return "car.fill"
        case .openMyTix:        return "train.side.front.car"
        case .callPhone:        return "phone.fill"
        case .openURL:          return "arrow.up.right.square"
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        CTAButton(
            cta: .openInGoogleMaps(destination: "Times Square", label: "Open in Google Maps"),
            accent: Color(hex: "#b85c38")
        )
        CTAButton(
            cta: .openInUber(destination: "Penn Station", label: "Open in Uber · Drive"),
            accent: Color(hex: "#4d6a82")
        )
    }
    .padding()
    .background(Color(hex: "#fbe9dc"))
}
```

- [ ] **Step 2: Eyeball preview**

Two pill buttons, full width, SF Symbol + label. Canvas taps are inert; on device, deep links open.

- [ ] **Step 3: Commit**

```bash
git add NYCTrip2026/Views/CTAButton.swift
git commit -m "Add CTAButton view that triggers DeepLinker on tap"
```

---

### Task 14: StepView (the generic step renderer)

**Files:**
- Create: `NYCTrip2026/Views/StepView.swift`

- [ ] **Step 1: Build StepView**

The hero image renders at 180pt (scaled metric for Dynamic Type — applied in Phase 6). Heroes are decorative; they composite over the step's pastel background.

Create `NYCTrip2026/Views/StepView.swift`:

```swift
import SwiftUI

struct StepView: View {
    let step: Step
    let currentIndex: Int
    let totalCount: Int
    let onBack: () -> Void
    let onNext: () -> Void

    private let heroSize: CGFloat = 180

    var body: some View {
        ZStack {
            step.background.ignoresSafeArea()

            VStack(spacing: 0) {
                Text(step.dayLabel)
                    .font(.dmSans(.semibold, size: 11))
                    .tracking(1.5)
                    .textCase(.uppercase)
                    .foregroundStyle(step.accent)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 8)

                Spacer()

                VStack(spacing: 18) {
                    Image(step.hero)
                        .resizable()
                        .scaledToFit()
                        .frame(height: heroSize)
                        .accessibilityHidden(true)

                    Text(step.title)
                        .font(.dmSans(.semibold, size: 22))
                        .tracking(-0.3)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.tripTextPrimary)
                        .lineLimit(3)

                    if let subtitle = step.subtitle {
                        Text(subtitle)
                            .font(.dmSans(.regular, size: 13))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.tripTextSecondary)
                            .lineSpacing(2)
                    }

                    if let reservation = step.reservation {
                        ReservationCard(detail: reservation, accent: step.accent)
                            .padding(.top, 4)
                    }

                    VStack(spacing: 10) {
                        ForEach(Array(step.ctas.enumerated()), id: \.offset) { _, cta in
                            CTAButton(cta: cta, accent: step.accent)
                        }
                    }
                    .padding(.top, 4)
                }

                Spacer()

                NavBar(
                    currentIndex: currentIndex,
                    totalCount: totalCount,
                    onBack: onBack,
                    onNext: onNext,
                    accent: step.accent
                )
                .padding(.bottom, 4)
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 28)
        }
    }
}

#Preview("Reservation step (Blue Box)") {
    StepView(
        step: Trip.day2[0],
        currentIndex: 9,
        totalCount: 31,
        onBack: {},
        onNext: {}
    )
}

#Preview("Two-CTA step (Central Park)") {
    StepView(
        step: Trip.day2[4],
        currentIndex: 13,
        totalCount: 31,
        onBack: {},
        onNext: {}
    )
}

#Preview("Drive step (Day 1 start)") {
    StepView(
        step: Trip.day1[0],
        currentIndex: 1,
        totalCount: 31,
        onBack: {},
        onNext: {}
    )
}
```

- [ ] **Step 2: Eyeball all three previews**

- Blue Box: cream background, breakfast hero, reservation card visible.
- Central Park: sage-cream background, park hero, two CTAs stacked.
- Drive (Day 1 start): mist-blue background, sedan hero.

- [ ] **Step 3: Commit**

```bash
git add NYCTrip2026/Views/StepView.swift
git commit -m "Add StepView generic step renderer with hero images and three previews"
```

---

### Task 15: WelcomeView

**Files:**
- Create: `NYCTrip2026/Views/WelcomeView.swift`

- [ ] **Step 1: Build WelcomeView**

Welcome screen uses the icon as the hero at a slightly larger size (200pt). The icon's built-in "new york" lettering becomes the first half of the bookend; closing reuses it as the second half.

Create `NYCTrip2026/Views/WelcomeView.swift`:

```swift
import SwiftUI

struct WelcomeView: View {
    let step: Step
    let totalCount: Int
    let onBegin: () -> Void

    private let heroSize: CGFloat = 200

    var body: some View {
        ZStack {
            step.background.ignoresSafeArea()

            VStack(spacing: 0) {
                Text(step.dayLabel)
                    .font(.dmSans(.semibold, size: 11))
                    .tracking(1.5)
                    .textCase(.uppercase)
                    .foregroundStyle(step.accent)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 8)

                Spacer()

                VStack(spacing: 22) {
                    Image(step.hero)
                        .resizable()
                        .scaledToFit()
                        .frame(height: heroSize)
                        .accessibilityHidden(true)

                    Text(step.title)
                        .font(.dmSans(.semibold, size: 24))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.tripTextPrimary)

                    if let subtitle = step.subtitle {
                        Text(subtitle)
                            .font(.dmSans(.regular, size: 15))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.tripTextSecondary)
                            .lineSpacing(4)
                    }
                }

                Spacer()

                Button(action: onBegin) {
                    Text("Begin")
                        .font(.dmSans(.semibold, size: 16))
                        .tracking(0.5)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(step.accent)
                        )
                }
                .padding(.bottom, 24)
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 28)
        }
    }
}

#Preview {
    WelcomeView(
        step: Trip.welcomeStep,
        totalCount: 31,
        onBegin: {}
    )
}
```

- [ ] **Step 2: Eyeball preview**

Peach background, "new york" icon hero, "Katy and Jada…" headline, dates, full-width "Begin" pill in deep terracotta.

- [ ] **Step 3: Commit**

```bash
git add NYCTrip2026/Views/WelcomeView.swift
git commit -m "Add WelcomeView with icon hero and personalized headline"
```

---

### Task 16: ClosingView

**Files:**
- Create: `NYCTrip2026/Views/ClosingView.swift`

- [ ] **Step 1: Build ClosingView**

Closing screen reuses the icon as the hero, on the same peach palette as Welcome — visual bookends framing the trip.

Create `NYCTrip2026/Views/ClosingView.swift`:

```swift
import SwiftUI

struct ClosingView: View {
    let step: Step
    let onBack: () -> Void

    private let heroSize: CGFloat = 200

    var body: some View {
        ZStack {
            step.background.ignoresSafeArea()

            VStack(spacing: 0) {
                Text(step.dayLabel)
                    .font(.dmSans(.semibold, size: 11))
                    .tracking(1.5)
                    .textCase(.uppercase)
                    .foregroundStyle(step.accent)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 8)

                Spacer()

                VStack(spacing: 22) {
                    Image(step.hero)
                        .resizable()
                        .scaledToFit()
                        .frame(height: heroSize)
                        .accessibilityHidden(true)

                    Text(step.title)
                        .font(.dmSans(.semibold, size: 24))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.tripTextPrimary)

                    if let subtitle = step.subtitle {
                        Text(subtitle)
                            .font(.dmSans(.regular, size: 15))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.tripTextSecondary)
                            .lineSpacing(4)
                    }
                }

                Spacer()

                Button(action: onBack) {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 13, weight: .semibold))
                        Text("Back through the trip")
                            .font(.dmSans(.medium, size: 13))
                    }
                    .foregroundStyle(step.accent)
                }
                .padding(.bottom, 24)
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 28)
        }
    }
}

#Preview {
    ClosingView(
        step: Trip.closingStep,
        onBack: {}
    )
}
```

- [ ] **Step 2: Eyeball preview**

Peach background, "new york" icon, "Welcome home!" headline, soft "Back through the trip" link.

- [ ] **Step 3: Commit**

```bash
git add NYCTrip2026/Views/ClosingView.swift
git commit -m "Add ClosingView with icon hero matching Welcome bookend"
```

---

## Phase 5: Navigation root

### Task 17: TripView (root container)

**Files:**
- Create: `NYCTrip2026/Views/TripView.swift`

- [ ] **Step 1: Build TripView**

Create `NYCTrip2026/Views/TripView.swift`:

```swift
import SwiftUI

struct TripView: View {
    @AppStorage("lastStepIndex") private var lastStepIndex: Int = 0
    @State private var currentIndex: Int = 0

    private let steps = Trip.allSteps
    private var totalCount: Int { steps.count }

    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(Array(steps.enumerated()), id: \.element.id) { index, step in
                page(for: step, index: index)
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .ignoresSafeArea()
        .onAppear {
            currentIndex = clampedRestoreIndex()
        }
        .onChange(of: currentIndex) { _, newValue in
            lastStepIndex = newValue
        }
    }

    @ViewBuilder
    private func page(for step: Step, index: Int) -> some View {
        switch step.day {
        case 0:
            WelcomeView(step: step, totalCount: totalCount, onBegin: advance)
        case 5:
            ClosingView(step: step, onBack: retreat)
        default:
            StepView(
                step: step,
                currentIndex: index,
                totalCount: totalCount,
                onBack: retreat,
                onNext: advance
            )
        }
    }

    private func advance() {
        guard currentIndex < totalCount - 1 else { return }
        withAnimation(.easeInOut(duration: 0.28)) {
            currentIndex += 1
        }
    }

    private func retreat() {
        guard currentIndex > 0 else { return }
        withAnimation(.easeInOut(duration: 0.28)) {
            currentIndex -= 1
        }
    }

    private func clampedRestoreIndex() -> Int {
        max(0, min(lastStepIndex, totalCount - 1))
    }
}

#Preview {
    TripView()
}
```

- [ ] **Step 2: Eyeball preview**

Starts on Welcome. Swipe right (or tap Begin) → Day 1 · Step 1. Swipe back. Day boundaries should be obvious from color + hero shifts.

- [ ] **Step 3: Commit**

```bash
git add NYCTrip2026/Views/TripView.swift
git commit -m "Add TripView root with TabView paged style and AppStorage persistence"
```

---

### Task 18: Wire app entry point

**Files:**
- Modify: `NYCTrip2026/App/NYCTrip2026App.swift`
- Delete: `NYCTrip2026/Views/ContentView.swift`

- [ ] **Step 1: Update the entry point**

Replace contents of `NYCTrip2026/App/NYCTrip2026App.swift`:

```swift
import SwiftUI

@main
struct NYCTrip2026App: App {
    var body: some Scene {
        WindowGroup {
            TripView()
        }
    }
}
```

- [ ] **Step 2: Delete the placeholder ContentView**

In Xcode: right-click `ContentView.swift` → Delete → Move to Trash.

- [ ] **Step 3: Build and run in the iOS Simulator**

Pick "iPhone 15" from the destination dropdown → `⌘R`. The app launches → Welcome → swipe through all 31 screens.

- [ ] **Step 4: Verify persistence**

Swipe to step 6 (Joe's Pizza dinner). Stop the app (`⌘.`). Re-run (`⌘R`). The app restores to step 6.

- [ ] **Step 5: Commit**

```bash
git add NYCTrip2026/App/NYCTrip2026App.swift NYCTrip2026/Views/ContentView.swift
git commit -m "Wire TripView into app entry point; remove placeholder ContentView"
```

---

## ✅ CHECKPOINT 2: Codex Adversarial Review (passed 2026-05-27)

**Stop. Full UI + navigation is now in place. Adversarial-review before polish.**

- [ ] **Step 1: Push**

```bash
git push origin main
```

- [ ] **Step 2: Run review**

`/codex:review --adversarial`

- [ ] **Step 3: Address findings** (same protocol as Checkpoint 1)

- [ ] **Step 4: Mark passed in the plan and commit**

---

## Phase 6: Polish & accessibility

### Task 19: Dynamic Type support

**Files:**
- Modify: `NYCTrip2026/Views/StepView.swift`
- Modify: `NYCTrip2026/Views/WelcomeView.swift`
- Modify: `NYCTrip2026/Views/ClosingView.swift`

- [ ] **Step 1: Replace fixed sizes with @ScaledMetric**

For each view, swap fixed `let heroSize: CGFloat = 180` and font literals for `@ScaledMetric` properties.

Example for `StepView`:

```swift
@ScaledMetric private var heroSize: CGFloat = 180
@ScaledMetric private var titleSize: CGFloat = 22
@ScaledMetric private var subtitleSize: CGFloat = 13

// then in body:
.frame(height: heroSize)
.font(.dmSans(.semibold, size: titleSize))
.font(.dmSans(.regular, size: subtitleSize))
```

Repeat for `WelcomeView` and `ClosingView` (`heroSize: 200`, `titleSize: 24`, `subtitleSize: 15`).

- [ ] **Step 2: Test at large accessibility size**

Simulator: Settings → Accessibility → Display & Text Size → Larger Text → enable → rightmost notch. Re-launch the app. Verify:
- Titles still fit in ≤3 lines
- Subtitles wrap reasonably
- Hero scales but doesn't push CTAs off-screen
- Reservation card text stays inside the card

- [ ] **Step 3: Adjust line limits if anything breaks**

If a title overflows at the max size: shorten it in `Trip.swift`, or relax `lineLimit(3)` to `lineLimit(4)` for that view. Document with a one-line comment if you relax a limit.

If the hero takes too much space at max Dynamic Type, cap it: `.frame(height: min(heroSize, 240))`.

- [ ] **Step 4: Commit**

```bash
git add NYCTrip2026/Views/StepView.swift NYCTrip2026/Views/WelcomeView.swift NYCTrip2026/Views/ClosingView.swift
git commit -m "Dynamic Type: scale hero, titles, and subtitles via @ScaledMetric"
```

---

### Task 20: VoiceOver labels

**Files:**
- Modify: `NYCTrip2026/Views/StepView.swift`
- Modify: `NYCTrip2026/Views/WelcomeView.swift`
- Modify: `NYCTrip2026/Views/ClosingView.swift`
- Modify: `NYCTrip2026/Views/CTAButton.swift`
- Modify: `NYCTrip2026/Views/NavBar.swift`

- [ ] **Step 1: Add accessibility labels to StepView**

Heroes are already `.accessibilityHidden(true)` from Task 14 — they're decorative. The step's overall narration should combine title + subtitle + reservation.

In `StepView`, after the outer `ZStack`, add:

```swift
.accessibilityElement(children: .combine)
.accessibilityLabel(accessibilityText)
```

And the computed property:

```swift
private var accessibilityText: String {
    var parts: [String] = []
    parts.append("Step \(currentIndex + 1) of \(totalCount)")
    parts.append(step.title.replacingOccurrences(of: "\n", with: " "))
    if let subtitle = step.subtitle { parts.append(subtitle.replacingOccurrences(of: "\n", with: " ")) }
    if let res = step.reservation {
        parts.append("Reservation: \(res.time) at \(res.address)")
        if let extra = res.extra { parts.append(extra) }
    }
    return parts.joined(separator: ". ")
}
```

Add the same pattern to `WelcomeView` and `ClosingView` (without the index — just `step.title` + `step.subtitle`).

- [ ] **Step 2: Label CTAButton**

In `CTAButton.swift`, on the Button:

```swift
.accessibilityLabel(cta.label)
.accessibilityHint("Opens \(appName)")
```

With:

```swift
private var appName: String {
    switch cta {
    case .openInGoogleMaps: return "Google Maps"
    case .openInUber:       return "Uber"
    case .openMyTix:        return "NJ Transit Mobile"
    case .callPhone:        return "Phone"
    case .openURL:          return "the link"
    }
}
```

- [ ] **Step 3: Label NavBar buttons**

In `NavBar.swift`: back button gets `.accessibilityLabel("Back")`, forward button `.accessibilityLabel("Next")`.

- [ ] **Step 4: Test with VoiceOver**

Simulator: Settings → Accessibility → VoiceOver → enable. Re-launch. Tap each element. Confirm speech is sensible — heroes should be silent (decorative), titles/subtitles/CTAs all narrate.

- [ ] **Step 5: Commit**

```bash
git add NYCTrip2026/Views/
git commit -m "Add VoiceOver labels and hints; mark hero images decorative"
```

---

### Task 21: Color contrast audit

**Files:**
- (Possibly) Modify: `NYCTrip2026/Content/Trip.swift`

- [ ] **Step 1: Verify each palette against the universal text colors**

The 9 palettes were chosen for ≥4.5:1 contrast on:
- `background` ↔ `textPrimary` (#2a2622)
- `background` ↔ `textSecondary` (#6b5d52)
- `background` ↔ `accent` (for the eyebrow day label and accent dot)
- `accent` ↔ `white` (for the CTA pill text)

Spot-check by running each `(bg, accent)` pair through `webaim.org/resources/contrastchecker/`:

| Palette | bg vs #2a2622 | bg vs #6b5d52 | accent vs #ffffff |
|---|---|---|---|
| peach `#fbe9dc` / `#b85c38` | expect ≥12:1 | expect ≥4.8:1 | expect ≥5.0:1 |
| blush `#f6e2d8` / `#b56b58` | expect ≥11:1 | expect ≥4.6:1 | expect ≥4.8:1 |
| dustyRose `#f0d3d8` / `#9c4a64` | expect ≥10:1 | expect ≥4.4:1 | expect ≥6.3:1 |
| clay `#ecd9c8` / `#a05b2e` | expect ≥10:1 | expect ≥4.5:1 | expect ≥5.9:1 |
| cream `#f8eedd` / `#8a6f3a` | expect ≥12:1 | expect ≥4.8:1 | expect ≥5.2:1 |
| butterCream `#f4e9cf` / `#9a7a2c` | expect ≥11:1 | expect ≥4.6:1 | expect ≥4.7:1 |
| sageCream `#e0e3d4` / `#5e6c4a` | expect ≥10:1 | expect ≥4.3:1 | expect ≥6.4:1 |
| mistBlue `#d8dfe5` / `#4d6a82` | expect ≥10:1 | expect ≥4.3:1 | expect ≥5.7:1 |
| wisteria `#dcd5dd` / `#6b5e75` | expect ≥10:1 | expect ≥4.3:1 | expect ≥7.0:1 |

- [ ] **Step 2: Fix any that fail 4.5:1**

If `textSecondary` against any background falls below 4.5:1, darken the secondary (e.g., move `#6b5d52` → `#5e5048`) or pick a slightly lighter background for that palette. Re-test until clean.

- [ ] **Step 3: Commit (if changes were made)**

```bash
git add NYCTrip2026/Content/Trip.swift NYCTrip2026/Theme/Color+Tokens.swift
git commit -m "Adjust palette colors to meet WCAG AA contrast"
```

If nothing failed, skip the commit — note "no changes" in the plan instead.

---

## Phase 7: Deploy

### Task 22: Configure signing for paid dev team

**Files:**
- Modify: `NYCTrip2026.xcodeproj` (Signing & Capabilities tab)

- [ ] **Step 1: Confirm signing settings**

In Xcode: select the `NYCTrip2026` target → Signing & Capabilities. Confirm:
- "Automatically manage signing" ✓
- Team: **Jonathan Hering** (paid Apple Developer team)
- Bundle Identifier: `com.jonathanhering.NYCTrip2026`

- [ ] **Step 2: Verify provisioning profile is created**

Xcode auto-generates a development provisioning profile. The Signing pane should show a green check and "Provisioning Profile: Xcode Managed Profile".

- [ ] **Step 3: Commit project file**

```bash
git add NYCTrip2026.xcodeproj
git commit -m "Confirm signing with com.jonathanhering.NYCTrip2026 on paid dev team"
```

---

### Task 23: First install to Katy's iPhone

**Note:** Mostly manual hardware steps. Treat each checkbox as a confirmation, not a code change.

- [ ] **Step 1: Connect Katy's iPhone 15 to the Mac**

USB-C cable. First time: she sees "Trust This Computer" → tap Trust, enter passcode. Mac may need Finder confirmation too.

- [ ] **Step 2: Select her phone as the run destination**

Xcode destination dropdown (top toolbar) → her iPhone 15.

- [ ] **Step 3: Run**

`⌘R`. Xcode builds, signs with the team cert, transfers, launches. First launch may take 30–60s.

- [ ] **Step 4: Verify on her phone**

App appears with the **new york** icon on the home screen. Tap it → Welcome screen ("Katy and Jada…") renders with the icon hero on peach. Swipe right → Day 1 · Step 1, mist-blue background, sedan hero. Swipe through a few more screens (5 check-in on peach, 7 Times Square on butter cream, 13 Central Park on sage cream) to confirm palette + hero variety.

- [ ] **Step 5: Check that deep links work**

- Step 1 (Drive to Metropark) → "Open in Google Maps" → Google Maps app opens with destination preset
- Step 3 (Train to NY Penn) → "Open MyTix" → NJ Transit Mobile app launches
- Step 4 (Uber to Jewel) → "Open in Uber" → Uber app opens with dropoff set
- Step 6 (Joe's Pizza) → Google Maps with restaurant preset
- Step 10 (Jellycat) → tap the `#351207910` confirmation → "Copied" toast appears, paste anywhere to verify

- [ ] **Step 6: Verify cert lifetime**

App stays on her phone for 1 year before needing re-signing (paid dev account). No reconnect needed unless the app is removed.

- [ ] **Step 7: Disconnect**

App lives on her phone independently. Trip starts June 21.

---

## ✅ CHECKPOINT 3: Final Codex Adversarial Review (passed 2026-05-27)

- [ ] **Step 1: Push**

```bash
git push origin main
```

- [ ] **Step 2: Run final review**

`/codex:review --adversarial`. Specifically ask Codex to look at:
- Edge cases around `@AppStorage` restoration (what if `lastStepIndex` is from a build that had fewer steps?)
- VoiceOver flow on multi-CTA screens
- Deep link URL construction edge cases (escaping, missing apps)
- Hero asset resolution paths (any race between asset load and StepView render?)
- Color contrast on the trickier palettes (`butterCream`, `clay`, `sageCream`)
- Dynamic Type behavior at AX5 (largest accessibility size)

- [ ] **Step 3: Address findings**

Anything that affects Katy's experience: fix. Anything cosmetic: file as TODO in a `FUTURE.md` (we ship to her phone regardless).

- [ ] **Step 4: Final commit and push**

```bash
git add .
git commit -m "Final polish per Codex adversarial review"
git push origin main
```

---

## Done

If all checkpoints passed and the app installed cleanly, the work is complete. Katy carries the app through the trip June 21–24, 2026.

**Post-trip:** Optional follow-up to add a photos-of-the-trip gallery view as a sequel, or to swap hero artwork variants. Out of scope for this plan.
