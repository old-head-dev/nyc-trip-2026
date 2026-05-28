# Learnings — NYC Trip 2026

Non-obvious bugs, gotchas, and wrong assumptions discovered while building the NYC Trip 2026 companion iOS app. Universally applicable items have been cross-posted to `Mobile Apps/native-apps/docs/LEARNINGS.md` so other native iOS sessions can find them.

## swiftui

### `Font.custom(_:size:)` double-scales when passed a `@ScaledMetric` value

- **Date**: 2026-05-27
- **Root cause**: `Font.custom(_ name: String, size: CGFloat)` auto-scales with Dynamic Type (relative to `.body`) per Apple docs. Passing it a value that's already been scaled by `@ScaledMetric` applies Dynamic Type scaling twice — at AX5 a 22pt title can render as ~110pt instead of the intended ~50pt. Any `min(scaledValue, capValue)` cap becomes meaningless because the cap is applied to the once-scaled value but then Font.custom scales again past it.
- **Wrong assumptions**: Treated `@ScaledMetric` as the canonical way to scale a custom-font size and assumed `Font.custom(_:size:)` was the equivalent of `Font.custom(_:fixedSize:)`. They're different.
- **Tried and failed**: Implementer added `@ScaledMetric` to hero / title / subtitle sizes and capped each with `min(...)` — passed AX5 verification visually for Welcome (one path) but Codex Checkpoint 3 caught that the caps had no actual effect.
- **Correct solution**: Use `Font.custom(_:fixedSize:)` when the caller already has a Dynamic-Type-scaled value. Add a `Font.dmSans(_:fixedSize:)` overload alongside the existing `size:` variant. Callers with `@ScaledMetric` values use `fixedSize:`; callers with plain literals continue using `size:` (and rely on Font.custom's native auto-scaling).
- **Affected files**: `NYCTrip2026/NYCTrip2026/Theme/Font+DMSans.swift`, `Views/StepView.swift`, `Views/WelcomeView.swift`, `Views/ClosingView.swift`

### `.foregroundStyle(.tripTextPrimary)` dot-shorthand does not compile for custom `Color` extensions

- **Date**: 2026-05-27
- **Root cause**: SwiftUI's `ShapeStyle` static-member dot-syntax (`foregroundStyle(.tint)`, `.primary`, etc.) only works for types that explicitly conform to `ShapeStyle` with static members. A plain `extension Color { static let tripTextPrimary = Color(hex: "#2a2622") }` does NOT make `.tripTextPrimary` available via the dot-shorthand — the compiler errors `type 'ShapeStyle' has no member 'tripTextPrimary'`. The plan author wrote view code with the shorthand assuming it would resolve.
- **Wrong assumptions**: That any `static let` on `Color` is reachable through the `.foregroundStyle(.<name>)` shorthand. Only `Color` itself (`.red`, `.blue`) and conforming types appear there.
- **Correct solution**: Use the explicit `Color.tripTextPrimary` form everywhere. `.foregroundStyle(Color.tripTextPrimary)` compiles and renders identically. The `accent` variant works fine because `accent` is already a typed `Color` value passed in as a parameter.
- **Affected files**: `Views/ReservationCard.swift`, `Views/NavBar.swift`, `Views/StepView.swift`, `Views/WelcomeView.swift`, `Views/ClosingView.swift`

### `@AppStorage` restoration in `.onAppear` causes a one-frame flash of the default page

- **Date**: 2026-05-27
- **Root cause**: `@State private var currentIndex: Int = 0` combined with `.onAppear { currentIndex = clampedRestoreIndex() }` lets the first body render lay out with `currentIndex == 0`, then re-render with the restored value. SwiftUI's `TabView(.page)` shows the page-0 frame briefly before snapping to the restored page. Visually it looks like Welcome flickers before the app jumps to step N.
- **Wrong assumptions**: That `.onAppear` runs before the first render. It runs after.
- **Correct solution**: Initialize `_currentIndex = State(initialValue: clamped)` in `init()`, where `clamped` is read synchronously from `UserDefaults.standard.integer(forKey: "lastStepIndex")`. SwiftUI honors the State's initial value on first render. The `@AppStorage` write-back via `.onChange(of: currentIndex)` still works.
- **Affected files**: `Views/TripView.swift`

### `.accessibilityElement(children: .contain)` + parent `.accessibilityLabel` duplicates VoiceOver content

- **Date**: 2026-05-27
- **Root cause**: `.contain` (unlike `.combine`) leaves child elements individually focusable. Adding `.accessibilityLabel("<summary>")` on the parent creates an additional focusable wrapper that speaks the summary, then VoiceOver still walks into each child Text and Button which speak their own labels. The user hears "Walk Central Park. Strawberry Fields → Bow Bridge…" from the parent, then "Walk Central Park" again from the title, then the subtitle, then each CTA. Pure duplication.
- **Wrong assumptions**: The plan author thought `.contain` would let the parent label REPLACE the children's announcements while preserving tap-ability. It doesn't — `.contain` adds a parent, doesn't replace children.
- **Correct solution**: Skip the parent wrapper entirely. Let VoiceOver discover children naturally (day label → title → subtitle → CTAs → NavBar buttons in source order). Mark the title with `.accessibilityAddTraits(.isHeader)` so VoiceOver announces it as a region heading on entry, giving the user a clean orientation cue without re-reading everything.
- **Affected files**: `Views/StepView.swift`, `Views/WelcomeView.swift`, `Views/ClosingView.swift`

### `.ignoresSafeArea()` on the root `TabView` swallows safe-area-respectful padding in every page

- **Date**: 2026-05-27
- **Root cause**: When the wrapping TabView itself uses `.ignoresSafeArea()`, every contained page renders from physical screen edges. Per-view `.padding(.vertical, 28)` is then measured from the screen top — i.e. starts BEHIND the Dynamic Island instead of below the safe-area gutter. Content sits under the system overlays.
- **Wrong assumptions**: That applying `.ignoresSafeArea()` only to the per-view background `Color` was equivalent to applying it to the TabView. The outer modifier overrides the inner safe-area awareness.
- **Correct solution**: Scope `.ignoresSafeArea()` to the per-view background only (`step.background.ignoresSafeArea()` inside each ZStack). Do not apply it on the wrapping TabView. The background still extends to screen edges; the content padding now measures from the safe-area boundary.
- **Affected files**: `Views/TripView.swift`

## xcode

### `INFOPLIST_KEY_UIAppFonts` build setting is silently ignored by Xcode 26.5

- **Date**: 2026-05-27
- **Root cause**: Xcode 16+ projects (`GENERATE_INFOPLIST_FILE = YES` default) accept `INFOPLIST_KEY_<plistKey>` build settings as a way to inject Info.plist values without an explicit Info.plist file. `INFOPLIST_KEY_UIAppFonts` is NOT in Xcode 26.5's hardcoded propagation list, so the value is accepted by `xcodebuild -showBuildSettings` but never reaches the generated Info.plist. Custom fonts never register; `UIFont(name:size:)` returns nil.
- **Wrong assumptions**: That `INFOPLIST_KEY_*` worked for any plist key. It only works for a hardcoded subset (`UISupportedInterfaceOrientations`, `UIApplicationSceneManifest_Generation`, etc.).
- **Tried and failed**: Setting `INFOPLIST_KEY_UIAppFonts = "DMSans-Regular.ttf DMSans-Medium.ttf ..."` for both Debug and Release. Build setting appeared in `xcodebuild -showBuildSettings` output but never in the generated `Info.plist` per `plutil -p`.
- **Correct solution**: Create an explicit `Info.plist` file. Set `GENERATE_INFOPLIST_FILE = NO` and `INFOPLIST_FILE = Info.plist`. Copy across whatever `INFOPLIST_KEY_*` settings were previously auto-generated (scene manifest, indirect input, launch screen, orientations). Add the array-valued keys (UIAppFonts, LSApplicationQueriesSchemes, etc.) directly.
- **Affected files**: `NYCTrip2026/NYCTrip2026.xcodeproj/project.pbxproj`, `NYCTrip2026/Info.plist`

### PBXFileSystemSynchronizedRootGroup + Info.plist collision: "Multiple commands produce Info.plist"

- **Date**: 2026-05-27
- **Root cause**: Xcode 16+ projects with synchronized file system groups (`objectVersion = 77`) auto-include every file in the synced source folder as a target resource. If you also point `INFOPLIST_FILE` at a plist file inside that same folder, Xcode tries to both bundle it as a resource AND use it as the app's Info.plist — emits "Multiple commands produce Info.plist" build error.
- **Wrong assumptions**: That a file at `NYCTrip2026/NYCTrip2026/Info.plist` would behave the same as a file referenced by a manually-curated group. With synchronized groups it doesn't.
- **Correct solution**: Place `Info.plist` at the project SRCROOT level (sibling of the synchronized source folder), not inside it. `INFOPLIST_FILE = Info.plist` with the file at `NYCTrip2026/Info.plist` (where the `.xcodeproj` also lives) works cleanly. Or alternatively, add a `PBXFileSystemSynchronizedBuildFileExceptionSet` to exclude Info.plist from the resources phase — but that's invasive pbxproj surgery; the sibling location is simpler.
- **Affected files**: `NYCTrip2026/Info.plist` (location), `NYCTrip2026/NYCTrip2026.xcodeproj/project.pbxproj` (INFOPLIST_FILE setting)

### SourceKit chronically reports "Cannot find type X" / "No such module 'Testing'" right after creating new files in Xcode 26.5

- **Date**: 2026-05-27
- **Root cause**: SourceKit's index lags behind the file system for newly created Swift files. New imageset references, new types in fresh files, new test imports — all flag as missing in the IDE's editor diagnostics while `xcodebuild build` and `xcodebuild test` both succeed. The pattern is so consistent across a session that it's safe to treat IDE squiggles on freshly added symbols as false positives until proven otherwise by a build.
- **Wrong assumptions**: That IDE diagnostics are authoritative. They aren't — `xcodebuild` is.
- **Correct solution**: When IDE diagnostics flag a missing type/module on a fresh file, run `xcodebuild build -project ... -scheme ... -destination '...'` to confirm. If the build succeeds, ignore the diagnostic. If it persists in actual use, force a clean build (DerivedData wipe) or restart the IDE.
- **Affected files**: n/a (toolchain behavior)

### `IPHONEOS_DEPLOYMENT_TARGET` drifts between project-level and target-level after Xcode 26 project creation

- **Date**: 2026-05-27
- **Root cause**: When Xcode 26 creates a new project, the project-level Debug/Release build configs and the test-target Debug/Release configs default to the currently-installed SDK version (`26.5`), but the app target's Debug/Release configs default to a reasonable iOS deployment target (`17.6`). The setting visually appears consistent in the Xcode UI under "Minimum Deployments" but `grep IPHONEOS_DEPLOYMENT_TARGET project.pbxproj` reveals the 4-way drift.
- **Wrong assumptions**: That setting "iOS 17.0" in the General → Minimum Deployments dropdown applies it everywhere.
- **Correct solution**: After project creation, grep the pbxproj and `sed -i.bak -E 's/IPHONEOS_DEPLOYMENT_TARGET = (26\.5|17\.6);/IPHONEOS_DEPLOYMENT_TARGET = 17.0;/g'` to normalize all 6 entries to a single value. Verify with another grep.
- **Affected files**: `NYCTrip2026/NYCTrip2026.xcodeproj/project.pbxproj`

## process

### "Verified ≥4.5:1" in a design plan is unreliable — bake the WCAG check into a programmatic test

- **Date**: 2026-05-27
- **Root cause**: The plan's color-palette section explicitly stated "Accents are dark enough to support white text on the CTA pill (verified ≥4.5:1 against `#ffffff`)" with a per-palette table of estimated contrast ratios. The estimates were wrong — Codex Checkpoint 2 computed actual ratios and found `blush` accent at 4.04:1 and `butterCream` accent at 4.04:1 against white, both failing AA. The wisteria background failed 4.5:1 against `tripTextSecondary` at 4.41:1.
- **Wrong assumptions**: That a designer's hand-estimated contrast tables are accurate. They aren't always.
- **Correct solution**: Encode the contract as code. Write a `ColorContrastTests` suite that enumerates every palette, computes WCAG 2.1 relative luminance (sRGB linearization with 0.04045 cutoff), and asserts `(L_lighter + 0.05) / (L_darker + 0.05) >= 4.5` for every bg↔textPrimary, bg↔textSecondary, and accent↔white pair. Test fails until colors are actually compliant. Lock in the contract going forward.
- **Affected files**: `NYCTrip2026/NYCTrip2026Tests/ColorContrastTests.swift`

### Codex CLI is invocable from a subagent — no need to ask the user to run `/codex:review`

- **Date**: 2026-05-27
- **Root cause**: The user-invoked `/codex:review --adversarial` slash command isn't directly callable from a session, but the `codex:codex-rescue` agent (via the `Agent` tool with `subagent_type: codex:codex-rescue`) delegates to the same Codex runtime and produces equivalent output. `codex-companion.mjs setup --json` first to confirm Codex CLI is authenticated; then dispatch the rescue agent with a structured review prompt.
- **Wrong assumptions**: That the only way to run adversarial Codex reviews mid-session was to pause and ask the user to type the slash command. Unblocks fully autonomous execution of plans that call for review checkpoints.
- **Correct solution**: For implementation plans with adversarial-review checkpoints, dispatch `codex:codex-rescue` with a focused prompt (commit range, files to scrutinize, "find what's wrong" framing). Compose a follow-up dispatch for re-review after applying fixes. Two-round review of fixes can be done entirely in-session without user intervention.
- **Affected files**: n/a (workflow capability)
