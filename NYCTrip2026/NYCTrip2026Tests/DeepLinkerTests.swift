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

    @Test("Google Maps with nil destination uses universal Maps URL (browser fallback when app missing)")
    func googleMapsNoDestination() {
        let cta = CTA.openInGoogleMaps(destination: nil, label: "Open Google Maps")
        let url = DeepLinker.url(for: cta)
        #expect(url?.absoluteString == "https://www.google.com/maps/@?api=1&map_action=map")
    }

    @Test("Google Maps with empty-string destination matches nil-destination behavior")
    func googleMapsEmptyDestination() {
        let cta = CTA.openInGoogleMaps(destination: "", label: "Open Google Maps")
        let url = DeepLinker.url(for: cta)
        #expect(url?.absoluteString == "https://www.google.com/maps/@?api=1&map_action=map")
    }

    @Test("openURL case returns the provided URL untouched")
    func openURLPassthrough() {
        let raw = URL(string: "https://example.com/foo?bar=baz")!
        let cta = CTA.openURL(raw, label: "Open Example")
        let url = DeepLinker.url(for: cta)
        #expect(url == raw)
    }

    @Test("Uber builds standard native deep link with dropoff address")
    func uberWithDestination() {
        let cta = CTA.openInUber(
            destination: "11 W 51st St, New York, NY",
            latitude: 40.7598080,
            longitude: -73.9776070,
            label: "Open in Uber"
        )
        let url = DeepLinker.url(for: cta, uberClientID: "real-client-id")
        let expected = "uber://?client_id=real-client-id&action=setPickup&pickup=my_location&dropoff%5Blatitude%5D=40.759808&dropoff%5Blongitude%5D=-73.977607&dropoff%5Bnickname%5D=11%20W%2051st%20St,%20New%20York,%20NY&dropoff%5Bformatted_address%5D=11%20W%2051st%20St,%20New%20York,%20NY&user-agent=rides-ios-v0-nyc-trip-2026"
        #expect(url?.absoluteString == expected)
    }

    @Test("Uber falls back to mobile web when Client ID is missing")
    func uberMissingClientID() {
        let cta = CTA.openInUber(
            destination: "11 W 51st St, New York, NY",
            latitude: 40.7598080,
            longitude: -73.9776070,
            label: "Open in Uber"
        )

        let url = DeepLinker.url(for: cta, uberClientID: "")
        let expected = "https://m.uber.com/ul/?action=setPickup&pickup=my_location&dropoff%5Blatitude%5D=40.759808&dropoff%5Blongitude%5D=-73.977607&dropoff%5Bnickname%5D=11%20W%2051st%20St,%20New%20York,%20NY&dropoff%5Bformatted_address%5D=11%20W%2051st%20St,%20New%20York,%20NY&user-agent=rides-ios-v0-nyc-trip-2026"
        #expect(url?.absoluteString == expected)
    }

    @Test("Uber fallback keeps mobile web dropoff coordinates when native app is missing")
    func uberFallbackWithClientID() {
        let cta = CTA.openInUber(
            destination: "11 W 51st St, New York, NY",
            latitude: 40.7598080,
            longitude: -73.9776070,
            label: "Open in Uber"
        )

        let url = DeepLinker.fallbackURL(for: cta, uberClientID: "real-client-id")
        let expected = "https://m.uber.com/ul/?client_id=real-client-id&action=setPickup&pickup=my_location&dropoff%5Blatitude%5D=40.759808&dropoff%5Blongitude%5D=-73.977607&dropoff%5Bnickname%5D=11%20W%2051st%20St,%20New%20York,%20NY&dropoff%5Bformatted_address%5D=11%20W%2051st%20St,%20New%20York,%20NY&user-agent=rides-ios-v0-nyc-trip-2026"
        #expect(url?.absoluteString == expected)
    }

    @Test("NJ Transit opens its App Store page because no reliable public deep link is available")
    func njTransitAppStoreURL() {
        let cta = CTA.openNJTransit(label: "Open NJ Transit app")
        let url = DeepLinker.url(for: cta)
        #expect(url?.absoluteString == "https://apps.apple.com/us/app/nj-transit-mobile-app/id589549928")
    }

    @Test("Phone uses tel scheme")
    func phoneScheme() {
        let cta = CTA.callPhone(number: "212-555-1212", label: "Call")
        let url = DeepLinker.url(for: cta)
        #expect(url?.absoluteString == "tel:212-555-1212")
    }
}
