import Testing
import Foundation
@testable import NYCTrip2026

@Suite("DeepLinker URL construction")
struct DeepLinkerTests {
    @Test("Google Maps with address builds universal link with URL-encoded destination")
    func googleMapsWithAddress() {
        let cta = CTA.openInGoogleMaps(destination: "Joe's Pizza, 1435 Broadway, NY", label: "Open in Google Maps")
        let url = DeepLinker.url(for: cta)
        #expect(url?.absoluteString == "https://www.google.com/maps/dir/?api=1&destination=Joe's%20Pizza,%201435%20Broadway,%20NY")
    }

    @Test("Google Maps with nil destination opens the app generically")
    func googleMapsNoDestination() {
        let cta = CTA.openInGoogleMaps(destination: nil, label: "Open Google Maps")
        let url = DeepLinker.url(for: cta)
        #expect(url?.absoluteString == "comgooglemaps://")
    }

    @Test("Uber builds universal link with dropoff address")
    func uberWithDestination() {
        let cta = CTA.openInUber(destination: "11 W 51st St, New York, NY", label: "Open in Uber")
        let url = DeepLinker.url(for: cta)
        let expected = "https://m.uber.com/ul/?action=setPickup&pickup=my_location&dropoff%5Bformatted_address%5D=11%20W%2051st%20St,%20New%20York,%20NY"
        #expect(url?.absoluteString == expected)
    }

    @Test("MyTix uses njtransit scheme")
    func myTixScheme() {
        let cta = CTA.openMyTix(label: "Open MyTix")
        let url = DeepLinker.url(for: cta)
        #expect(url?.absoluteString == "njtransit://")
    }

    @Test("Phone uses tel scheme")
    func phoneScheme() {
        let cta = CTA.callPhone(number: "212-555-1212", label: "Call")
        let url = DeepLinker.url(for: cta)
        #expect(url?.absoluteString == "tel:212-555-1212")
    }
}
