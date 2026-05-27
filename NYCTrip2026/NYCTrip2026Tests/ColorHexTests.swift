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
        #expect(abs((components?[0] ?? 0) - 0xfb / 255.0) < 0.002)
        #expect(abs((components?[1] ?? 0) - 0xe9 / 255.0) < 0.002)
        #expect(abs((components?[2] ?? 0) - 0xdc / 255.0) < 0.002)
    }

    @Test("parses 6-char hex without hash")
    func parses6CharWithoutHash() {
        let color = Color(hex: "2a2622")
        let components = color.cgColor?.components
        #expect(components != nil)
        #expect(abs((components?[0] ?? 0) - 0x2a / 255.0) < 0.002)
        #expect(abs((components?[1] ?? 0) - 0x26 / 255.0) < 0.002)
        #expect(abs((components?[2] ?? 0) - 0x22 / 255.0) < 0.002)
    }
}
