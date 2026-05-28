import Testing
import SwiftUI
@testable import NYCTrip2026

/// WCAG AA color contrast verification. Lock in the contract that:
///   - every step background is ≥4.5:1 against tripTextPrimary AND tripTextSecondary
///   - every step accent is ≥4.5:1 against white (used as CTA-pill text)
/// This is a programmatic version of Task 21's manual contrast audit. Codex Checkpoint 2
/// found the blush and butterCream accents both ~4.07:1 vs white (failing); the accents
/// were darkened and this test prevents regression.
@Suite("Color contrast (WCAG AA)")
struct ColorContrastTests {

    @Test("Every step background contrasts ≥4.5:1 with tripTextPrimary")
    func backgroundsVsTextPrimary() {
        let textL = relativeLuminance(of: .tripTextPrimary)
        for step in Trip.allSteps {
            let bgL = relativeLuminance(of: step.background)
            let ratio = contrastRatio(bgL, textL)
            #expect(ratio >= 4.5,
                    "Step id \(step.id) background fails AA vs tripTextPrimary: \(String(format: "%.2f", ratio)):1")
        }
    }

    @Test("Every step background contrasts ≥4.5:1 with tripTextSecondary")
    func backgroundsVsTextSecondary() {
        let textL = relativeLuminance(of: .tripTextSecondary)
        for step in Trip.allSteps {
            let bgL = relativeLuminance(of: step.background)
            let ratio = contrastRatio(bgL, textL)
            #expect(ratio >= 4.5,
                    "Step id \(step.id) background fails AA vs tripTextSecondary: \(String(format: "%.2f", ratio)):1")
        }
    }

    @Test("Every step accent contrasts ≥4.5:1 with white (CTA pill text)")
    func accentsVsWhite() {
        let whiteL = 1.0
        for step in Trip.allSteps {
            let aL = relativeLuminance(of: step.accent)
            let ratio = contrastRatio(aL, whiteL)
            #expect(ratio >= 4.5,
                    "Step id \(step.id) accent fails AA vs white: \(String(format: "%.2f", ratio)):1")
        }
    }
}

// MARK: WCAG luminance helpers

private func relativeLuminance(of color: Color) -> Double {
    let components = color.cgColor?.components ?? [0, 0, 0, 1]
    let r = linearize(components[0])
    let g = linearize(components.count > 1 ? components[1] : components[0])
    let b = linearize(components.count > 2 ? components[2] : components[0])
    return 0.2126 * r + 0.7152 * g + 0.0722 * b
}

private func linearize(_ srgb: CGFloat) -> Double {
    let v = Double(srgb)
    return v <= 0.03928 ? v / 12.92 : pow((v + 0.055) / 1.055, 2.4)
}

private func contrastRatio(_ l1: Double, _ l2: Double) -> Double {
    let (lighter, darker) = l1 > l2 ? (l1, l2) : (l2, l1)
    return (lighter + 0.05) / (darker + 0.05)
}
