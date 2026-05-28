import SwiftUI

/// Universal text colors shared across all step screens. Per-step palettes only vary
/// background and accent — text colors are fixed to maintain consistent legibility
/// and reinforce the warm/dusty design language.
extension Color {
    static let tripTextPrimary   = Color(hex: "#2a2622")  // warm near-black
    static let tripTextSecondary = Color(hex: "#635750")  // warm taupe (darkened from #6b5d52 to clear WCAG AA on wisteria bg)
}
