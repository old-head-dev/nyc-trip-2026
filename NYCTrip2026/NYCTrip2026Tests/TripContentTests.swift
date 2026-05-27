import Testing
import UIKit
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
        #expect(Trip.allSteps.first?.hero == "icon")
        #expect(Trip.allSteps.last?.hero == "icon")
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

    @Test("Every step's hero name is non-empty")
    func heroNamesNonEmpty() {
        for step in Trip.allSteps {
            #expect(!step.hero.isEmpty, "Step id \(step.id) has empty hero name")
        }
    }

    @Test("Every referenced hero name resolves to a bundled image asset")
    func heroAssetsExist() {
        for name in Trip.referencedHeroNames {
            #expect(UIImage(named: name) != nil, "Asset catalog has no image named '\(name)'")
        }
    }

    @Test("Reservation + 2 CTAs never coincide (layout space invariant)")
    func reservationAndTwoCTAsExclusive() {
        for step in Trip.allSteps {
            if step.reservation != nil {
                #expect(step.ctas.count <= 1, "Step id \(step.id) has both a reservation card and >1 CTA — layout will overflow")
            }
        }
    }

    @Test("Day-step day labels match their actual position and per-day count")
    func dayLabelsMatchPosition() {
        let trip = Trip.allSteps.filter { (1...4).contains($0.day) }
        let byDay = Dictionary(grouping: trip, by: \.day)
        for (day, steps) in byDay {
            let totalForDay = steps.count
            for (index, step) in steps.enumerated() {
                let expected = "Day \(day) · \(index + 1) of \(totalForDay)"
                #expect(step.dayLabel == expected,
                        "Step id \(step.id) has dayLabel '\(step.dayLabel)' — expected '\(expected)' (position drifted)")
            }
        }
    }

    @Test("Placeholder reservation strings flagged for pre-install fill-in")
    func placeholderReservationsVisible() {
        // Codex Checkpoint 1 flagged these as render-on-device risk. We keep them per Jon's choice,
        // but assert the count so any silent disappearance (or new placeholders added) is noticed.
        let placeholderCount = Trip.allSteps.reduce(0) { acc, step in
            guard let res = step.reservation else { return acc }
            let fields = [res.time, res.confirmation, res.extra].compactMap { $0 }
            return acc + fields.filter { $0.contains("Jon to fill in") || $0.contains("time set by ticket purchase") }.count
        }
        #expect(placeholderCount == 5,
                "Expected 5 'Jon to fill in' / 'time set by ticket purchase' placeholders across reservations; found \(placeholderCount). Update count when Jon fills these in.")
    }
}
