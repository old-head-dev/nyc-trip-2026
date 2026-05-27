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
}
