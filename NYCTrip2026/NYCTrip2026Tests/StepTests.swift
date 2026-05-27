import Testing
import SwiftUI
@testable import NYCTrip2026

@Suite("Step model")
struct StepTests {
    @Test("Step holds all required fields")
    func stepFields() {
        let step = Step(
            id: 1,
            day: 1,
            dayLabel: "Day 1 · 1 of 8",
            hero: "sedan_car",
            title: "Drive to Metropark",
            subtitle: "Iselin, NJ · ~640 mi",
            reservation: nil,
            ctas: [.openInGoogleMaps(destination: "Metropark Station, Iselin NJ", label: "Open in Google Maps")],
            background: Color(hex: "#d8dfe5"),
            accent: Color(hex: "#4d6a82")
        )
        #expect(step.id == 1)
        #expect(step.day == 1)
        #expect(step.hero == "sedan_car")
        #expect(step.ctas.count == 1)
    }

    @Test("ReservationDetail holds confirmation and extra")
    func reservationDetailFields() {
        let res = ReservationDetail(
            time: "10:00 AM",
            address: "727 5th Ave, 5th Floor",
            confirmation: "ABC123",
            extra: "Breakfast for 2"
        )
        #expect(res.time == "10:00 AM")
        #expect(res.confirmation == "ABC123")
    }
}
