# NYC Trip 2026 Companion App — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:subagent-driven-development` (recommended) or `superpowers:executing-plans` to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build and install a private SwiftUI companion app on Katy's iPhone 15 that walks her through the NYC trip (June 21–24, 2026) one task at a time with premium aesthetics and minimal cognitive load.

**Architecture:** Single-target SwiftUI app, iOS 17.0+. `TabView` with `.page` style as the root container, `@AppStorage` for last-step persistence, hardcoded `Step` array as content, deep links to Google Maps / Uber / NJ Transit Mobile via URL schemes and universal links. No third-party dependencies.

**Tech Stack:** Swift 5.10+, SwiftUI, Swift Testing (for unit tests), DM Sans (bundled TTFs), Xcode latest stable.

**Spec:** `docs/superpowers/specs/2026-05-26-nyc-trip-app-design.md` — read this first if you haven't.

**Target install date:** 2026-06-14 (one week before trip departure).

---

## Skills to invoke during execution

- **`swiftui-pro`** — review every view file before committing; ensures modern API usage, no `Color.gray` placeholders, proper `@Observable`/`@State` boundaries.
- **`swift-testing-pro`** — use the new `@Test` / `#expect` macros (not XCTest) for all test code in this plan.
- **`swift-concurrency-pro`** — relevant if you touch `UIApplication.shared.open` callsites or any async work.
- **`/codex:review --adversarial`** — runs at three checkpoint gates in this plan.

---

## File Structure

```
NYCTrip2026/
├── NYCTrip2026.xcodeproj
├── NYCTrip2026/
│   ├── App/
│   │   └── NYCTrip2026App.swift          # @main entry
│   ├── Models/
│   │   ├── Step.swift                    # Step + ReservationDetail + CTA
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
│   │   └── Font+DMSans.swift             # Font helpers
│   ├── Resources/
│   │   ├── Fonts/                        # DM Sans TTFs (4 files)
│   │   └── Assets.xcassets               # AppIcon + AccentColor
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
- Team: select Jon's paid Apple Developer team
- Organization Identifier: use Jon's existing dev portal prefix (e.g., `com.<his-prefix>`)
- Bundle Identifier auto-fills as `<prefix>.NYCTrip2026`
- Interface: **SwiftUI**
- Language: **Swift**
- Storage: **None** (we use `@AppStorage`)
- **Include Tests:** YES (this creates the `NYCTrip2026Tests` target with Swift Testing as the default test framework in Xcode 16+)
- Save location: `/Users/jkher/Documents/Claude/NYC Trip 2026/` (the existing repo root)

- [ ] **Step 2: Verify the project targets iOS 17.0+**

In Xcode: select the `NYCTrip2026` target → General tab → Minimum Deployments. Set iOS to **17.0**.

- [ ] **Step 3: Set up the group structure**

In the Xcode file navigator, right-click the `NYCTrip2026` group → New Group. Create these groups in order: `App`, `Models`, `Content`, `Views`, `Theme`, `Resources`. Move the auto-generated `NYCTrip2026App.swift` into `App/`. Move the auto-generated `ContentView.swift` into `Views/` for now (we'll delete it later).

- [ ] **Step 4: Verify build succeeds**

Hit `⌘B`. Should build green with zero warnings. If it doesn't, fix before proceeding.

- [ ] **Step 5: Commit**

```bash
cd "/Users/jkher/Documents/Claude/NYC Trip 2026"
git add NYCTrip2026.xcodeproj NYCTrip2026/ NYCTrip2026Tests/
git commit -m "Scaffold NYCTrip2026 Xcode project (iOS 17+, SwiftUI, Swift Testing)"
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

In a browser: visit `https://fonts.google.com/specimen/DM+Sans` → click "Download family". Unzip. From the `static/` folder inside, copy these four files:
- `DMSans-Regular.ttf`
- `DMSans-Medium.ttf`
- `DMSans-SemiBold.ttf`
- `DMSans-Bold.ttf`

Drop them into `NYCTrip2026/Resources/Fonts/` (create the folder if it doesn't exist). In Xcode, drag the Fonts folder into the `Resources` group with "Copy items if needed" checked and "Add to targets: NYCTrip2026" checked.

- [ ] **Step 2: Register fonts in Info.plist**

In Xcode: select `Info.plist`. Right-click in the editor → Add Row. Key: `UIAppFonts`, type: Array. Add four String items:
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

Open the canvas (`⌥⌘⏎`). Each line should render in the correct weight. If they all look the same, the font isn't registered — check the Info.plist Array entries match the file names exactly (case sensitive, must include `Fonts/` prefix).

- [ ] **Step 4: Commit**

```bash
git add NYCTrip2026/Resources/Fonts/ NYCTrip2026/Info.plist NYCTrip2026/Views/ContentView.swift
git commit -m "Bundle and register DM Sans fonts (Regular/Medium/SemiBold/Bold)"
```

---

## Phase 1: Theme primitives

### Task 3: Color hex initializer (TDD)

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
        let color = Color(hex: "3c6488")
        let components = color.cgColor?.components
        #expect(components != nil)
        #expect(abs((components?[0] ?? 0) - 0x3c / 255.0) < 0.01)
        #expect(abs((components?[1] ?? 0) - 0x64 / 255.0) < 0.01)
        #expect(abs((components?[2] ?? 0) - 0x88 / 255.0) < 0.01)
    }
}
```

- [ ] **Step 2: Run tests, verify they fail**

In Xcode: `⌘U`. Expect both tests to fail with "no exact match for 'Color.init(hex:)'".

- [ ] **Step 3: Implement Color+Hex.swift**

Create `NYCTrip2026/Theme/Color+Hex.swift`:

```swift
import SwiftUI

extension Color {
    /// Initialize from a 6-character hex string. Accepts optional leading `#`.
    /// Example: `Color(hex: "#fbe9dc")`, `Color(hex: "3c6488")`.
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

`⌘U`. Both tests should pass.

- [ ] **Step 5: Commit**

```bash
git add NYCTrip2026/Theme/Color+Hex.swift NYCTrip2026Tests/ColorHexTests.swift
git commit -m "Add Color(hex:) initializer with tests"
```

---

### Task 4: Font helper

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

`⌘B`. Should compile cleanly.

- [ ] **Step 3: Commit**

```bash
git add NYCTrip2026/Theme/Font+DMSans.swift
git commit -m "Add Font.dmSans helper for bundled DM Sans family"
```

---

## Phase 2: Data Model

### Task 5: Step + ReservationDetail + CTA (TDD)

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
            symbol: "car.fill",
            title: "Drive to Metropark",
            subtitle: "Iselin, NJ · ~640 mi",
            reservation: nil,
            ctas: [.openInGoogleMaps(destination: "Metropark Station, Iselin NJ", label: "Open in Google Maps")],
            background: Color(hex: "#dfe7ee"),
            accent: Color(hex: "#3c6488"),
            textPrimary: Color(hex: "#1f3142"),
            textSecondary: Color(hex: "#54677a")
        )
        #expect(step.id == 1)
        #expect(step.day == 1)
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

`⌘U`. Tests fail with "no type Step in scope".

- [ ] **Step 3: Implement Step.swift**

Create `NYCTrip2026/Models/Step.swift`:

```swift
import SwiftUI

struct Step: Identifiable {
    let id: Int
    let day: Int                  // 1...4 for trip days; 0 = welcome; 5 = closing
    let dayLabel: String          // e.g., "Day 2 · 6 of 22"
    let symbol: String            // SF Symbol name
    let title: String             // 1-2 lines
    let subtitle: String?         // optional, 1-2 lines
    let reservation: ReservationDetail?
    let ctas: [CTA]               // 0, 1, or 2 buttons
    let background: Color
    let accent: Color
    let textPrimary: Color
    let textSecondary: Color
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

`⌘U`. Both tests pass.

- [ ] **Step 5: Commit**

```bash
git add NYCTrip2026/Models/Step.swift NYCTrip2026Tests/StepTests.swift
git commit -m "Add Step + ReservationDetail + CTA model with tests"
```

---

### Task 6: DeepLinker URL construction (TDD)

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

`⌘U`. All five fail with "no type DeepLinker".

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

### Task 7: Trip.allSteps with all 31 screens

**Files:**
- Create: `NYCTrip2026/Content/Trip.swift`

- [ ] **Step 1: Author the full step array**

Create `NYCTrip2026/Content/Trip.swift`. This is long content authoring. Each step gets a hand-picked pastel.

```swift
import SwiftUI

enum Trip {

    // MARK: Color palette helpers

    private static let peach      = (bg: "#fbe9dc", accent: "#b85c38", primary: "#3a2820", secondary: "#6b5448")
    private static let blue       = (bg: "#dfe7ee", accent: "#3c6488", primary: "#1f3142", secondary: "#54677a")
    private static let mint       = (bg: "#d9e8df", accent: "#3f7556", primary: "#1f3a2c", secondary: "#4f6358")
    private static let sage       = (bg: "#e8e8d8", accent: "#6b7c44", primary: "#2f3424", secondary: "#5b6052")
    private static let lavender   = (bg: "#e3dee9", accent: "#6f5c93", primary: "#2f2840", secondary: "#5e5570")
    private static let butter     = (bg: "#f7eecd", accent: "#a17b1a", primary: "#3a2f10", secondary: "#6a5828")
    private static let rose       = (bg: "#f3dde2", accent: "#9c4a64", primary: "#3f2030", secondary: "#6e4858")
    private static let sky        = (bg: "#dde8f0", accent: "#3e6f96", primary: "#1c3247", secondary: "#506b81")
    private static let clay       = (bg: "#ecd9c8", accent: "#a05b2e", primary: "#3b2616", secondary: "#6b4b32")
    private static let fern       = (bg: "#dbe6d4", accent: "#4f7c3f", primary: "#1d3019", secondary: "#4d6244")

    private static func colors(_ p: (bg: String, accent: String, primary: String, secondary: String))
        -> (Color, Color, Color, Color) {
        (Color(hex: p.bg), Color(hex: p.accent), Color(hex: p.primary), Color(hex: p.secondary))
    }

    // MARK: Step factory

    private static func step(
        id: Int, day: Int, dayLabel: String,
        symbol: String, title: String, subtitle: String? = nil,
        reservation: ReservationDetail? = nil,
        ctas: [CTA] = [],
        palette: (bg: String, accent: String, primary: String, secondary: String)
    ) -> Step {
        let (bg, accent, primary, secondary) = colors(palette)
        return Step(
            id: id, day: day, dayLabel: dayLabel,
            symbol: symbol, title: title, subtitle: subtitle,
            reservation: reservation, ctas: ctas,
            background: bg, accent: accent,
            textPrimary: primary, textSecondary: secondary
        )
    }

    // MARK: The trip

    static let welcomeStep = step(
        id: 0, day: 0, dayLabel: "NYC Trip · June 21–24, 2026",
        symbol: "sparkles",
        title: "Katy and Jada…",
        subtitle: "Welcome to your\nNYC trip!\n\nJune 21–24, 2026",
        palette: peach
    )

    static let closingStep = step(
        id: 999, day: 5, dayLabel: "Trip complete",
        symbol: "heart.fill",
        title: "Welcome home!",
        subtitle: "Hope you loved every minute. ✨",
        palette: lavender
    )

    static let day1: [Step] = [
        step(id: 1, day: 1, dayLabel: "Day 1 · 1 of 8",
             symbol: "car.fill", title: "Drive to\nMetropark Station",
             subtitle: "Iselin, NJ · ~640 miles\nDepart Fort Wayne by 7 AM",
             ctas: [.openInGoogleMaps(destination: "Metropark Station, Iselin, NJ", label: "Open in Google Maps")],
             palette: blue),

        step(id: 2, day: 1, dayLabel: "Day 1 · 2 of 8",
             symbol: "parkingsign.circle.fill", title: "Park at Metropark",
             subtitle: "NexPass reads your plate automatically.\nNo ticket. Just drive in.",
             palette: butter),

        step(id: 3, day: 1, dayLabel: "Day 1 · 3 of 8",
             symbol: "train.side.front.car", title: "Take the train\nto NY Penn",
             subtitle: "Northeast Corridor line · ~45 min\nActivate your MyTix ticket at the platform.",
             ctas: [.openMyTix(label: "Open MyTix")],
             palette: sky),

        step(id: 4, day: 1, dayLabel: "Day 1 · 4 of 8",
             symbol: "car.side.fill", title: "Uber to The Jewel",
             subtitle: "From Penn Station · ~10 min",
             ctas: [.openInUber(destination: "The Jewel New York, 11 W 51st St, New York, NY", label: "Open in Uber")],
             palette: clay),

        step(id: 5, day: 1, dayLabel: "Day 1 · 5 of 8",
             symbol: "bed.double.fill", title: "Check in at\nThe Jewel",
             subtitle: "11 W 51st St · directly across from Rockefeller Center",
             reservation: ReservationDetail(
                time: "Check-in 3:00 PM",
                address: "11 W 51st St, New York, NY 10019",
                confirmation: "(confirmation # — Jon to fill in)",
                extra: "(room type — Jon to fill in)"
             ),
             palette: peach),

        step(id: 6, day: 1, dayLabel: "Day 1 · 6 of 8",
             symbol: "fork.knife", title: "Dinner at\nJoe's Pizza",
             subtitle: "1435 Broadway · Original NYC slice joint\nGrab slices, walk Times Square after.",
             ctas: [.openInGoogleMaps(destination: "Joe's Pizza, 1435 Broadway, New York, NY", label: "Open in Google Maps")],
             palette: rose),

        step(id: 7, day: 1, dayLabel: "Day 1 · 7 of 8",
             symbol: "sparkles", title: "Times Square\nfirst look",
             subtitle: "Best at night when the lights are full.\nNo rush tonight.",
             ctas: [.openInGoogleMaps(destination: "Times Square, New York, NY", label: "Open in Google Maps")],
             palette: butter),

        step(id: 8, day: 1, dayLabel: "Day 1 · 8 of 8",
             symbol: "house.fill", title: "Return to\nThe Jewel",
             subtitle: "Call it an early night.",
             ctas: [.openInGoogleMaps(destination: "The Jewel New York, 11 W 51st St, New York, NY", label: "Open in Google Maps")],
             palette: lavender),
    ]

    static let day2: [Step] = [
        step(id: 9, day: 2, dayLabel: "Day 2 · 1 of 8",
             symbol: "cup.and.saucer.fill", title: "Breakfast at\nBlue Box Café",
             subtitle: "4-min walk from the hotel.",
             reservation: ReservationDetail(
                time: "10:00 AM",
                address: "727 5th Ave, 5th Floor",
                confirmation: nil,
                extra: "Breakfast for 2"
             ),
             ctas: [.openInGoogleMaps(destination: "Tiffany & Co., 727 5th Ave, New York, NY", label: "Open in Google Maps")],
             palette: mint),

        step(id: 10, day: 2, dayLabel: "Day 2 · 2 of 8",
             symbol: "teddybear.fill", title: "Jellycat Diner\nat FAO Schwarz",
             subtitle: "5-min walk from Tiffany's.\nArrive a few minutes early — 10-min slot.",
             reservation: ReservationDetail(
                time: "11:50 AM – 12:00 PM",
                address: "30 Rockefeller Plaza, 1st floor",
                confirmation: "#351207910",
                extra: nil
             ),
             ctas: [.openInGoogleMaps(destination: "FAO Schwarz, 30 Rockefeller Plaza, New York, NY", label: "Open in Google Maps")],
             palette: rose),

        step(id: 11, day: 2, dayLabel: "Day 2 · 3 of 8",
             symbol: "building.columns.fill", title: "Visit Grand\nCentral Terminal",
             subtitle: "Celestial ceiling, Whispering Gallery, Grand Central Market.",
             ctas: [.openInGoogleMaps(destination: "Grand Central Terminal, 89 E 42nd St, New York, NY", label: "Open in Google Maps")],
             palette: butter),

        step(id: 12, day: 2, dayLabel: "Day 2 · 4 of 8",
             symbol: "fork.knife", title: "OPTIONAL: Lunch at\nVia Quadronno",
             subtitle: "25 E 73rd St · steps from Central Park east entrance.\nSkip if breakfast still holds.",
             ctas: [.openInGoogleMaps(destination: "Via Quadronno, 25 E 73rd St, New York, NY", label: "Open in Google Maps")],
             palette: clay),

        step(id: 13, day: 2, dayLabel: "Day 2 · 5 of 8",
             symbol: "tree.fill", title: "Walk Central Park",
             subtitle: "Strawberry Fields → Bow Bridge → Bethesda Fountain → The Mall.",
             ctas: [
                .openInGoogleMaps(destination: "Bethesda Fountain, Central Park, New York, NY", label: "Open in Google Maps · Walk"),
                .openInUber(destination: "Bethesda Fountain, Central Park, New York, NY", label: "Open in Uber · Drive")
             ],
             palette: fern),

        step(id: 14, day: 2, dayLabel: "Day 2 · 6 of 8",
             symbol: "bag.fill", title: "Herald Square\n& Macy's",
             subtitle: "11 floors, world's largest department store.",
             ctas: [.openInUber(destination: "Macy's Herald Square, 151 W 34th St, New York, NY", label: "Open in Uber")],
             palette: sky),

        step(id: 15, day: 2, dayLabel: "Day 2 · 7 of 8",
             symbol: "house.fill", title: "Back to hotel\nFreshen up",
             subtitle: "TAO is the dress-up dinner.",
             ctas: [
                .openInGoogleMaps(destination: "The Jewel New York, 11 W 51st St, New York, NY", label: "Open in Google Maps · Walk"),
                .openInUber(destination: "The Jewel New York, 11 W 51st St, New York, NY", label: "Open in Uber · Drive")
             ],
             palette: lavender),

        step(id: 16, day: 2, dayLabel: "Day 2 · 8 of 8",
             symbol: "fork.knife", title: "Dinner at\nTAO Uptown",
             subtitle: "Dramatic pan-Asian. Dress up.",
             reservation: ReservationDetail(
                time: "6:30 PM",
                address: "42 E 58th St",
                confirmation: "(OpenTable conf # — Jon to fill in)",
                extra: nil
             ),
             ctas: [.openInGoogleMaps(destination: "TAO Uptown, 42 E 58th St, New York, NY", label: "Open in Google Maps")],
             palette: rose),
    ]

    static let day3: [Step] = [
        step(id: 17, day: 3, dayLabel: "Day 3 · 1 of 8",
             symbol: "cup.and.saucer.fill", title: "Breakfast at\nSunday Morning",
             subtitle: "29 W 25th St · Cinnamon rolls are the reason to go.",
             ctas: [.openInUber(destination: "Sunday Morning Bakehouse, 29 W 25th St, New York, NY", label: "Open in Uber")],
             palette: butter),

        step(id: 18, day: 3, dayLabel: "Day 3 · 2 of 8",
             symbol: "bag.fill", title: "SoHo shopping",
             subtitle: "Broadway, Spring, Prince. Walk once you arrive.",
             ctas: [.openInUber(destination: "SoHo, Broadway & Spring St, New York, NY", label: "Open in Uber")],
             palette: clay),

        step(id: 19, day: 3, dayLabel: "Day 3 · 3 of 8",
             symbol: "storefront.fill", title: "Canal Street",
             subtitle: "Chinatown market vibe · ~11-min walk from SoHo.",
             ctas: [.openInGoogleMaps(destination: "Canal Street, Chinatown, New York, NY", label: "Open in Google Maps")],
             palette: rose),

        step(id: 20, day: 3, dayLabel: "Day 3 · 4 of 8",
             symbol: "fork.knife", title: "Lunch at\nJack's Wife Freda",
             subtitle: "226 Lafayette St · Mediterranean-American, casual.",
             ctas: [.openInGoogleMaps(destination: "Jack's Wife Freda, 226 Lafayette St, New York, NY", label: "Open in Google Maps")],
             palette: peach),

        step(id: 21, day: 3, dayLabel: "Day 3 · 5 of 8",
             symbol: "snowflake", title: "Museum of\nIce Cream",
             subtitle: "Interactive immersive experience.\nAllow 60–90 min inside.",
             reservation: ReservationDetail(
                time: "(time set by ticket purchase)",
                address: "558 Broadway, SoHo",
                confirmation: "(ticket conf # — Jon to fill in)",
                extra: nil
             ),
             ctas: [.openInGoogleMaps(destination: "Museum of Ice Cream, 558 Broadway, New York, NY", label: "Open in Google Maps")],
             palette: mint),

        step(id: 22, day: 3, dayLabel: "Day 3 · 6 of 8",
             symbol: "house.fill", title: "Uber back\nto the hotel",
             subtitle: "Freshen up before evening.",
             ctas: [.openInUber(destination: "The Jewel New York, 11 W 51st St, New York, NY", label: "Open in Uber")],
             palette: sky),

        step(id: 23, day: 3, dayLabel: "Day 3 · 7 of 8",
             symbol: "moon.stars.fill", title: "Evening walk\n5th Ave & Madison",
             subtitle: "Storefronts at dusk. Tiffany's, Bergdorf, Saks.\n4-min walk from the hotel.",
             palette: lavender),

        step(id: 24, day: 3, dayLabel: "Day 3 · 8 of 8",
             symbol: "fork.knife", title: "Dinner — pick\na spot near hotel",
             subtitle: "Open call. Use Google Maps to search.",
             ctas: [.openInGoogleMaps(destination: nil, label: "Open Google Maps")],
             palette: fern),
    ]

    static let day4: [Step] = [
        step(id: 25, day: 4, dayLabel: "Day 4 · 1 of 5",
             symbol: "cup.and.saucer.fill", title: "Breakfast at\nLiberty Bagels",
             subtitle: "Classic NY bagel · Grab and go.",
             ctas: [.openInGoogleMaps(destination: "Liberty Bagels Midtown, 260 W 35th St, New York, NY", label: "Open in Google Maps")],
             palette: butter),

        step(id: 26, day: 4, dayLabel: "Day 4 · 2 of 5",
             symbol: "key.fill", title: "Back to The Jewel\nCheck out",
             subtitle: "Checkout by 12:00 PM (noon).\nFront desk can hold bags if you want to stroll.",
             ctas: [.openInGoogleMaps(destination: "The Jewel New York, 11 W 51st St, New York, NY", label: "Open in Google Maps")],
             palette: peach),

        step(id: 27, day: 4, dayLabel: "Day 4 · 3 of 5",
             symbol: "car.side.fill", title: "Uber to\nPenn Station",
             subtitle: "Aim to be at Penn by 11 AM.",
             ctas: [.openInUber(destination: "Moynihan Train Hall, 31st St & 8th Ave, New York, NY", label: "Open in Uber")],
             palette: clay),

        step(id: 28, day: 4, dayLabel: "Day 4 · 4 of 5",
             symbol: "train.side.front.car", title: "Take the train\nto Metropark",
             subtitle: "Northeast Corridor line · ~45 min\nActivate your MyTix ticket at the platform.",
             ctas: [.openMyTix(label: "Open MyTix")],
             palette: sky),

        step(id: 29, day: 4, dayLabel: "Day 4 · 5 of 5",
             symbol: "house.fill", title: "Drive home\nto Fort Wayne",
             subtitle: "NexPass reads your plate on the way out — no parking ticket to pay.\nHome by 9–10 PM.",
             ctas: [.openInGoogleMaps(destination: "Fort Wayne, IN", label: "Open in Google Maps")],
             palette: lavender),
    ]

    static let allSteps: [Step] = [welcomeStep] + day1 + day2 + day3 + day4 + [closingStep]
}
```

- [ ] **Step 2: Verify build**

`⌘B`. Should compile cleanly. If a hex code or SF Symbol name has a typo, fix it now.

- [ ] **Step 3: Commit**

```bash
git add NYCTrip2026/Content/Trip.swift
git commit -m "Author Trip.allSteps: welcome + 29 step screens + closing across 4 days"
```

---

### Task 8: Content integrity tests

**Files:**
- Create: `NYCTrip2026Tests/TripContentTests.swift`

- [ ] **Step 1: Write the integrity tests**

Create `NYCTrip2026Tests/TripContentTests.swift`:

```swift
import Testing
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
}
```

- [ ] **Step 2: Run tests, verify they pass**

`⌘U`. All seven pass. If any fail, the content array has a bug — fix it in `Trip.swift`.

- [ ] **Step 3: Commit**

```bash
git add NYCTrip2026Tests/TripContentTests.swift
git commit -m "Add Trip content integrity tests (ids, days, CTAs, bookends)"
```

---

## 🛡 CHECKPOINT 1: Codex Adversarial Review

**Stop here. Before building any views, run an adversarial review of the data + content + URL construction.**

- [ ] **Step 1: Push current state**

```bash
git push origin main
```

- [ ] **Step 2: Run the adversarial review**

In Claude Code: type `/codex:review --adversarial`.

- [ ] **Step 3: Address every finding**

For each finding from Codex:
- If real: fix in a follow-up commit (`fix: address Codex review — <topic>`).
- If false positive: document inline in the plan with a note explaining why (one sentence).
- If unclear: ask the user (Jon) before deciding.

- [ ] **Step 4: Re-run if you made changes**

If you made any fixes, re-run `/codex:review --adversarial` once more to confirm clean.

- [ ] **Step 5: Mark checkpoint complete in this plan**

Edit this plan file: change the checkpoint heading to `## ✅ CHECKPOINT 1: Codex Adversarial Review (passed YYYY-MM-DD)`. Commit:

```bash
git add docs/superpowers/plans/2026-05-26-nyc-trip-app-implementation.md
git commit -m "Mark Checkpoint 1 passed"
```

---

## Phase 4: Views

### Task 9: ReservationCard view

**Files:**
- Create: `NYCTrip2026/Views/ReservationCard.swift`

- [ ] **Step 1: Build the card**

Create `NYCTrip2026/Views/ReservationCard.swift`:

```swift
import SwiftUI

struct ReservationCard: View {
    let detail: ReservationDetail
    let accent: Color
    let textPrimary: Color
    let textSecondary: Color

    @State private var didCopy = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Circle().fill(accent).frame(width: 6, height: 6)
                Text(detail.time)
                    .font(.dmSans(.semibold, size: 13))
                    .foregroundStyle(textPrimary)
            }
            Text(detail.address)
                .font(.dmSans(.regular, size: 13))
                .foregroundStyle(textSecondary)
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
                    .foregroundStyle(textSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.white.opacity(0.9))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(accent.opacity(0.15), lineWidth: 1)
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
        accent: Color(hex: "#3f7556"),
        textPrimary: Color(hex: "#1f3a2c"),
        textSecondary: Color(hex: "#4f6358")
    )
    .padding()
    .background(Color(hex: "#d9e8df"))
}
```

- [ ] **Step 2: Eyeball the preview**

Open the canvas (`⌥⌘⏎`). The card should render with a mint background, white card, accent-colored time row, and a tappable confirmation number.

- [ ] **Step 3: Commit**

```bash
git add NYCTrip2026/Views/ReservationCard.swift
git commit -m "Add ReservationCard view with copy-to-clipboard confirmation"
```

---

### Task 10: NavBar view

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
    let textPrimary: Color

    var isFirst: Bool { currentIndex == 0 }
    var isLast: Bool { currentIndex == totalCount - 1 }

    var body: some View {
        HStack {
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(textPrimary)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle().fill(textPrimary.opacity(0.08))
                    )
            }
            .opacity(isFirst ? 0 : 1)
            .disabled(isFirst)

            Spacer()

            HStack(spacing: 5) {
                ForEach(0..<min(totalCount, 8), id: \.self) { i in
                    Capsule()
                        .fill(i == min(currentIndex, 7) ? accent : textPrimary.opacity(0.18))
                        .frame(width: i == min(currentIndex, 7) ? 18 : 5, height: 5)
                }
            }

            Spacer()

            Button(action: onNext) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(textPrimary)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle().fill(textPrimary.opacity(0.08))
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
        accent: Color(hex: "#3c6488"),
        textPrimary: Color(hex: "#1f3142")
    )
    .padding()
    .background(Color(hex: "#dfe7ee"))
}
```

- [ ] **Step 2: Eyeball preview**

The bar shows a back button (subtle gray), 8 dots with one active (wider, accent-colored), and a forward button.

- [ ] **Step 3: Commit**

```bash
git add NYCTrip2026/Views/NavBar.swift
git commit -m "Add NavBar view (back/dots/next)"
```

---

### Task 11: CTAButton view

**Files:**
- Create: `NYCTrip2026/Views/CTAButton.swift`

- [ ] **Step 1: Build the button**

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
            accent: Color(hex: "#3c6488")
        )
    }
    .padding()
    .background(Color(hex: "#fbe9dc"))
}
```

- [ ] **Step 2: Eyeball preview**

Two pill buttons, full width, with SF Symbol + label. Tapping won't do anything in the canvas, but on device it'll open the deep link.

- [ ] **Step 3: Commit**

```bash
git add NYCTrip2026/Views/CTAButton.swift
git commit -m "Add CTAButton view that triggers DeepLinker on tap"
```

---

### Task 12: StepView (the generic step renderer)

**Files:**
- Create: `NYCTrip2026/Views/StepView.swift`

- [ ] **Step 1: Build StepView**

Create `NYCTrip2026/Views/StepView.swift`:

```swift
import SwiftUI

struct StepView: View {
    let step: Step
    let currentIndex: Int
    let totalCount: Int
    let onBack: () -> Void
    let onNext: () -> Void

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
                    Image(systemName: step.symbol)
                        .font(.system(size: 56, weight: .medium))
                        .foregroundStyle(step.accent)
                        .padding(.bottom, 4)

                    Text(step.title)
                        .font(.dmSans(.semibold, size: 22))
                        .tracking(-0.3)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(step.textPrimary)
                        .lineLimit(3)

                    if let subtitle = step.subtitle {
                        Text(subtitle)
                            .font(.dmSans(.regular, size: 13))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(step.textSecondary)
                            .lineSpacing(2)
                    }

                    if let reservation = step.reservation {
                        ReservationCard(
                            detail: reservation,
                            accent: step.accent,
                            textPrimary: step.textPrimary,
                            textSecondary: step.textSecondary
                        )
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
                    accent: step.accent,
                    textPrimary: step.textPrimary
                )
                .padding(.bottom, 4)
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 28)
        }
    }
}

#Preview("Reservation step") {
    StepView(
        step: Trip.day2[0],   // Blue Box Café
        currentIndex: 9,
        totalCount: 31,
        onBack: {},
        onNext: {}
    )
}

#Preview("Two-CTA step") {
    StepView(
        step: Trip.day2[4],   // Central Park walk-or-drive
        currentIndex: 13,
        totalCount: 31,
        onBack: {},
        onNext: {}
    )
}
```

- [ ] **Step 2: Eyeball both previews**

The reservation step shows the mint-themed Blue Box Café screen with the card. The two-CTA step shows the Central Park walk-or-drive screen with both buttons.

- [ ] **Step 3: Commit**

```bash
git add NYCTrip2026/Views/StepView.swift
git commit -m "Add StepView generic step renderer with previews"
```

---

### Task 13: WelcomeView

**Files:**
- Create: `NYCTrip2026/Views/WelcomeView.swift`

- [ ] **Step 1: Build WelcomeView**

Create `NYCTrip2026/Views/WelcomeView.swift`:

```swift
import SwiftUI

struct WelcomeView: View {
    let step: Step
    let totalCount: Int
    let onBegin: () -> Void

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
                    Image(systemName: step.symbol)
                        .font(.system(size: 56, weight: .medium))
                        .foregroundStyle(step.accent)

                    Text(step.title)
                        .font(.dmSans(.semibold, size: 24))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(step.textPrimary)

                    if let subtitle = step.subtitle {
                        Text(subtitle)
                            .font(.dmSans(.regular, size: 15))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(step.textSecondary)
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

Peach background, sparkles symbol, "Katy and Jada…" headline, body text, full-width "Begin" pill button.

- [ ] **Step 3: Commit**

```bash
git add NYCTrip2026/Views/WelcomeView.swift
git commit -m "Add WelcomeView with personalized headline and Begin pill"
```

---

### Task 14: ClosingView

**Files:**
- Create: `NYCTrip2026/Views/ClosingView.swift`

- [ ] **Step 1: Build ClosingView**

Create `NYCTrip2026/Views/ClosingView.swift`:

```swift
import SwiftUI

struct ClosingView: View {
    let step: Step
    let onBack: () -> Void

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
                    Image(systemName: step.symbol)
                        .font(.system(size: 56, weight: .medium))
                        .foregroundStyle(step.accent)

                    Text(step.title)
                        .font(.dmSans(.semibold, size: 24))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(step.textPrimary)

                    if let subtitle = step.subtitle {
                        Text(subtitle)
                            .font(.dmSans(.regular, size: 15))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(step.textSecondary)
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

Lavender background, heart symbol, "Welcome home!", subtle "Back through the trip" link.

- [ ] **Step 3: Commit**

```bash
git add NYCTrip2026/Views/ClosingView.swift
git commit -m "Add ClosingView with closing message and back-to-trip link"
```

---

## Phase 5: Navigation root

### Task 15: TripView (root container)

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

The preview starts on the Welcome screen. Swipe right or tap Begin to advance to Day 1 · Step 1. Swipe back through. Day boundaries should be obvious from the color shifts.

- [ ] **Step 3: Commit**

```bash
git add NYCTrip2026/Views/TripView.swift
git commit -m "Add TripView root with TabView paged style and AppStorage persistence"
```

---

### Task 16: Wire app entry point

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

Pick "iPhone 15" from the destination dropdown → `⌘R`. The app should launch, show the welcome screen, swipe through all 31 screens.

- [ ] **Step 4: Verify persistence**

In the simulator, swipe to step 6 (Joe's Pizza). Stop the app (`⌘.`). Re-run (`⌘R`). The app should restore to step 6.

- [ ] **Step 5: Commit**

```bash
git add NYCTrip2026/App/NYCTrip2026App.swift NYCTrip2026/Views/ContentView.swift
git commit -m "Wire TripView into app entry point; remove placeholder ContentView"
```

---

## 🛡 CHECKPOINT 2: Codex Adversarial Review

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

### Task 17: Dynamic Type support

**Files:**
- Modify: `NYCTrip2026/Views/StepView.swift`
- Modify: `NYCTrip2026/Views/WelcomeView.swift`
- Modify: `NYCTrip2026/Views/ClosingView.swift`

- [ ] **Step 1: Add @ScaledMetric for symbol and title sizes**

For each of StepView, WelcomeView, ClosingView, replace the fixed font sizes with scaled equivalents. Example for StepView title:

```swift
@ScaledMetric private var titleSize: CGFloat = 22
@ScaledMetric private var subtitleSize: CGFloat = 13
@ScaledMetric private var symbolSize: CGFloat = 56

// then:
.font(.dmSans(.semibold, size: titleSize))
// and:
.font(.system(size: symbolSize, weight: .medium))
```

Repeat for WelcomeView (`titleSize: 24`, `subtitleSize: 15`) and ClosingView (same as Welcome).

- [ ] **Step 2: Test at large accessibility size**

In the simulator: Settings → Accessibility → Display & Text Size → Larger Text → enable → drag the slider to the rightmost notch. Re-launch the app. Verify:
- Titles still fit in ≤3 lines
- Subtitles wrap reasonably
- Nothing overlaps or runs off-screen

- [ ] **Step 3: Adjust line limits if anything breaks**

If a title overflows at the max size, either shorten the title (in `Trip.swift`) or relax `lineLimit(3)` to `lineLimit(4)` for that view. Document the decision in a one-line comment.

- [ ] **Step 4: Commit**

```bash
git add NYCTrip2026/Views/StepView.swift NYCTrip2026/Views/WelcomeView.swift NYCTrip2026/Views/ClosingView.swift
git commit -m "Dynamic Type: scale symbols, titles, and subtitles via @ScaledMetric"
```

---

### Task 18: VoiceOver labels

**Files:**
- Modify: `NYCTrip2026/Views/StepView.swift`
- Modify: `NYCTrip2026/Views/WelcomeView.swift`
- Modify: `NYCTrip2026/Views/ClosingView.swift`
- Modify: `NYCTrip2026/Views/CTAButton.swift`
- Modify: `NYCTrip2026/Views/NavBar.swift`

- [ ] **Step 1: Add accessibility labels to StepView**

In StepView, after the outer `ZStack`, add:

```swift
.accessibilityElement(children: .combine)
.accessibilityLabel(accessibilityText)
```

And add the computed property:

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

- [ ] **Step 2: Label CTAButton**

In `CTAButton.swift`, add to the Button:

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

In `NavBar.swift`, on the back button add `.accessibilityLabel("Back")` and on the forward `.accessibilityLabel("Next")`.

- [ ] **Step 4: Test with VoiceOver**

On the simulator: Settings → Accessibility → VoiceOver → enable. Re-launch the app. Tap each element. Confirm the speech is sensible.

- [ ] **Step 5: Commit**

```bash
git add NYCTrip2026/Views/
git commit -m "Add VoiceOver labels and hints across step screens, CTAs, and nav bar"
```

---

### Task 19: Color contrast audit

**Files:**
- (Possibly) Modify: `NYCTrip2026/Content/Trip.swift`

- [ ] **Step 1: Spot-check each palette**

Open `Trip.swift`. For each pastel palette pair (`peach`, `blue`, `mint`, etc.), eyeball the `bg` ↔ `primary` and `bg` ↔ `accent` pairings. Run each through a contrast checker like webaim.org/resources/contrastchecker/. Each pair must hit ≥4.5:1 for text on background.

- [ ] **Step 2: Fix any that fail**

If a palette fails, darken `primary` or `accent` slightly. Re-run the contrast check.

- [ ] **Step 3: Commit (if changes were made)**

```bash
git add NYCTrip2026/Content/Trip.swift
git commit -m "Adjust palette colors to meet WCAG AA contrast for text and accents"
```

If nothing needed adjusting, skip the commit — note "no changes" in the plan.

---

### Task 20: App icon

**Files:**
- Modify: `NYCTrip2026/Resources/Assets.xcassets/AppIcon.appiconset`

- [ ] **Step 1: Make a placeholder icon for first install**

For the surprise install, a simple icon is fine. Options:
- **Quickest:** Use an emoji-on-pastel-background image. Build a 1024×1024 PNG with a peach background (`#fbe9dc`) and a centered ✨ emoji. Tools: Preview, Figma, or just use any online icon generator.
- **Slightly nicer:** Sparkles SF Symbol exported as PNG against a peach background.

Drag the 1024×1024 PNG into the `AppIcon.appiconset` slot for "App Store iOS 1024pt". Xcode 16+ auto-generates the smaller sizes.

- [ ] **Step 2: Verify the icon appears**

Build and run on the simulator. Check the home screen — the icon should look like your PNG.

- [ ] **Step 3: Commit**

```bash
git add NYCTrip2026/Resources/Assets.xcassets/
git commit -m "Add placeholder app icon (peach + sparkles)"
```

---

## Phase 7: Deploy

### Task 21: Configure signing for paid dev team

**Files:**
- Modify: `NYCTrip2026.xcodeproj` (Signing & Capabilities tab)

- [ ] **Step 1: Set the team**

In Xcode: select the `NYCTrip2026` target → Signing & Capabilities. Check "Automatically manage signing". Team: Jon's paid Apple Developer team. Bundle Identifier: confirm matches what was set in Task 1.

- [ ] **Step 2: Verify provisioning profile is created**

Xcode auto-generates a development provisioning profile. The Signing pane should show a green check and "Provisioning Profile: Xcode Managed Profile".

- [ ] **Step 3: Commit project file**

```bash
git add NYCTrip2026.xcodeproj
git commit -m "Configure signing with paid Apple Developer team"
```

---

### Task 22: First install to Katy's iPhone

**Note:** This task is mostly manual hardware steps. Treat each checkbox as a confirmation, not a code change.

- [ ] **Step 1: Connect Katy's iPhone 15 to the Mac**

USB-C cable. First time: she'll see "Trust This Computer" on her phone — tap Trust, enter her passcode. On the Mac, may need to confirm in Finder too.

- [ ] **Step 2: Select her phone as the run destination**

In Xcode's destination dropdown (top toolbar), her iPhone 15 should now appear. Select it.

- [ ] **Step 3: Run**

`⌘R`. Xcode builds, signs with Jon's team cert, transfers the app, and launches it. First launch may take 30–60 seconds.

- [ ] **Step 4: Verify on her phone**

The app should appear with the placeholder icon. Tap it. The Welcome screen ("Katy and Jada…") should render. Swipe right — Day 1, Step 1 appears with the dusty-blue background. Continue through a few screens to confirm.

- [ ] **Step 5: Check that deep links work**

On step 1 (Drive to Metropark), tap "Open in Google Maps". If Google Maps is installed, it opens with the destination preset. Repeat for step 3 (MyTix), step 4 (Uber), step 6 (Joe's Pizza). Each should hand off correctly.

- [ ] **Step 6: Verify cert lifetime**

App stays on her phone for 1 year before needing re-signing (paid dev account). She doesn't need to be connected to your Mac again unless the app is removed.

- [ ] **Step 7: Disconnect and unplug**

The app lives on her phone independently now.

---

## 🛡 CHECKPOINT 3: Final Codex Adversarial Review (pre-handoff)

- [ ] **Step 1: Push**

```bash
git push origin main
```

- [ ] **Step 2: Run final review**

`/codex:review --adversarial`. Specifically ask Codex to look at:
- Edge cases around `@AppStorage` restoration (what if `lastStepIndex` is from an old build?)
- VoiceOver flow on multi-CTA screens
- Any deep link URL construction edge cases
- Color contrast on the trickier palettes (`butter`, `clay`)

- [ ] **Step 3: Address findings**

Same protocol. Anything found that affects Katy's experience: fix. Anything cosmetic: file as TODO in a `FUTURE.md` (we ship to her phone regardless).

- [ ] **Step 4: Final commit and push**

```bash
git add .
git commit -m "Final polish per Codex adversarial review"
git push origin main
```

---

## Done

If all checkpoints passed and the app installed cleanly, the work is complete. Katy carries the app through the trip June 21–24.

**Post-trip:** Optional follow-up to swap the placeholder icon for a designed one, or add a photos-of-the-trip gallery view as a sequel. Out of scope for this plan.
