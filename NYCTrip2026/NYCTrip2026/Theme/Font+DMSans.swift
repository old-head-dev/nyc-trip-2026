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
