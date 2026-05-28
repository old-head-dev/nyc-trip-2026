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
    /// `size:` returns a font that scales with Dynamic Type relative to .body (use this
    /// for plain literal sizes — Font.custom handles the scaling).
    /// `fixedSize:` returns a font that does NOT auto-scale (use this when the caller
    /// already produced a Dynamic-Type-scaled value via @ScaledMetric — passing it to
    /// `size:` would double-scale).
    static func dmSans(_ weight: DMSansWeight, size: CGFloat) -> Font {
        .custom(weight.fontName, size: size)
    }

    static func dmSans(_ weight: DMSansWeight, fixedSize: CGFloat) -> Font {
        .custom(weight.fontName, fixedSize: fixedSize)
    }
}
