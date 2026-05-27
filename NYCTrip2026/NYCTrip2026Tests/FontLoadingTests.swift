import Testing
import UIKit

@Suite("DM Sans font loading")
struct FontLoadingTests {
    @Test("All four DM Sans weights load from the bundle", arguments: [
        "DMSans-Regular", "DMSans-Medium", "DMSans-SemiBold", "DMSans-Bold"
    ])
    func fontLoads(_ name: String) {
        #expect(
            UIFont(name: name, size: 12) != nil,
            "Font '\(name)' did not load — check Info.plist UIAppFonts registration and bundle inclusion"
        )
    }
}
