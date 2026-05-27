//
//  FontLoadingTests.swift
//  NYCTrip2026Tests
//
//  Verifies the bundled DM Sans fonts are registered via UIAppFonts and
//  load successfully via UIFont(name:size:) at runtime.
//

import Testing
import UIKit
@testable import NYCTrip2026

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
