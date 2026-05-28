//
//  NYCTrip2026UITests.swift
//  NYCTrip2026UITests
//
//  Created by Jon Hering on 5/27/26.
//

import XCTest
import UIKit

final class NYCTrip2026UITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // XCUIAutomation Documentation
        // https://developer.apple.com/documentation/xcuiautomation
    }

    @MainActor
    func testWelcomeBackgroundFillsSystemSafeAreas() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-lastStepIndex", "0"]
        app.launch()

        let screenshot = app.screenshot()
        let image = try XCTUnwrap(UIImage(data: screenshot.pngRepresentation))
        let cgImage = try XCTUnwrap(image.cgImage)
        let expectedPeach = RGB(red: 251, green: 233, blue: 220)

        let topSafeArea = try rgb(
            in: cgImage,
            x: Int(Double(cgImage.width) * 0.08),
            y: Int(Double(cgImage.height) * 0.025)
        )
        let bottomSafeArea = try rgb(
            in: cgImage,
            x: Int(Double(cgImage.width) * 0.08),
            y: Int(Double(cgImage.height) * 0.975)
        )

        XCTAssertLessThan(
            topSafeArea.distance(to: expectedPeach),
            8,
            "Top safe area should be filled by the welcome peach background, got \(topSafeArea)."
        )
        XCTAssertLessThan(
            bottomSafeArea.distance(to: expectedPeach),
            8,
            "Bottom safe area should be filled by the welcome peach background, got \(bottomSafeArea)."
        )
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }

    private struct RGB: CustomStringConvertible {
        let red: Int
        let green: Int
        let blue: Int

        var description: String {
            "rgb(\(red), \(green), \(blue))"
        }

        func distance(to other: RGB) -> Double {
            let redDelta = Double(red - other.red)
            let greenDelta = Double(green - other.green)
            let blueDelta = Double(blue - other.blue)
            return sqrt(redDelta * redDelta + greenDelta * greenDelta + blueDelta * blueDelta)
        }
    }

    private func rgb(in image: CGImage, x: Int, y: Int) throws -> RGB {
        let data = try XCTUnwrap(image.dataProvider?.data)
        let bytes = CFDataGetBytePtr(data)
        let bytesPerPixel = image.bitsPerPixel / 8
        let offset = y * image.bytesPerRow + x * bytesPerPixel

        guard bytesPerPixel >= 4 else {
            XCTFail("Unsupported screenshot pixel format: \(image.bitsPerPixel) bits per pixel.")
            return RGB(red: 0, green: 0, blue: 0)
        }

        switch image.bitmapInfo.componentLayout {
        case .bgra:
            return RGB(red: Int(bytes![offset + 2]), green: Int(bytes![offset + 1]), blue: Int(bytes![offset]))
        default:
            return RGB(red: Int(bytes![offset]), green: Int(bytes![offset + 1]), blue: Int(bytes![offset + 2]))
        }
    }
}

private enum BitmapComponentLayout {
    case bgra
    case rgba
}

private extension CGBitmapInfo {
    var componentLayout: BitmapComponentLayout {
        let byteOrder = CGBitmapInfo(rawValue: rawValue & CGBitmapInfo.byteOrderMask.rawValue)
        let alpha = CGImageAlphaInfo(rawValue: rawValue & CGBitmapInfo.alphaInfoMask.rawValue)

        if byteOrder == .byteOrder32Little,
           alpha == .premultipliedFirst || alpha == .first || alpha == .noneSkipFirst {
            return .bgra
        }

        return .rgba
    }
}
