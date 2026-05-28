import Foundation
#if canImport(UIKit)
import UIKit
#endif

enum DeepLinker {
    static func url(for cta: CTA, uberClientID: String? = Bundle.main.uberClientID) -> URL? {
        switch cta {
        case let .openInGoogleMaps(destination, _):
            guard let destination, !destination.isEmpty else {
                // Universal Maps link: opens Google Maps app if installed, otherwise Safari to maps.google.com.
                // Bare comgooglemaps:// silently no-ops when the app isn't installed.
                return URL(string: "https://www.google.com/maps/@?api=1&map_action=map")
            }
            var components = URLComponents(string: "https://www.google.com/maps/dir/")!
            components.queryItems = [
                URLQueryItem(name: "api", value: "1"),
                URLQueryItem(name: "destination", value: destination)
            ]
            return components.url

        case let .openInUber(destination, latitude, longitude, _):
            let hasClientID = uberClientID?.isEmpty == false
            return uberURL(
                base: hasClientID ? "uber://" : "https://m.uber.com/ul/",
                clientID: uberClientID,
                destination: destination,
                latitude: latitude,
                longitude: longitude
            )

        case .openNJTransit:
            return URL(string: "https://apps.apple.com/us/app/nj-transit-mobile-app/id589549928")

        case let .callPhone(number, _):
            return URL(string: "tel:\(number)")

        case let .openURL(url, _):
            return url
        }
    }

    static func fallbackURL(for cta: CTA, uberClientID: String? = Bundle.main.uberClientID) -> URL? {
        guard case let .openInUber(destination, latitude, longitude, _) = cta else {
            return nil
        }
        return uberURL(
            base: "https://m.uber.com/ul/",
            clientID: uberClientID,
            destination: destination,
            latitude: latitude,
            longitude: longitude
        )
    }

    /// Opens the URL via UIApplication.
    @MainActor
    static func open(_ cta: CTA) {
        #if canImport(UIKit)
        let app = UIApplication.shared
        if let url = url(for: cta), app.canOpenURL(url) {
            app.open(url)
            return
        }
        if let fallback = fallbackURL(for: cta) {
            app.open(fallback)
        }
        #endif
    }

    private static func uberURL(base: String, clientID: String?, destination: String, latitude: Double, longitude: Double) -> URL? {
        var components = URLComponents(string: base)!
        components.queryItems = uberQueryItems(
            clientID: clientID,
            destination: destination,
            latitude: latitude,
            longitude: longitude
        )
        return components.url
    }

    private static func uberQueryItems(clientID: String?, destination: String, latitude: Double, longitude: Double) -> [URLQueryItem] {
        var items: [URLQueryItem] = []
        if let clientID, !clientID.isEmpty {
            items.append(URLQueryItem(name: "client_id", value: clientID))
        }
        items.append(contentsOf: [
            URLQueryItem(name: "action", value: "setPickup"),
            URLQueryItem(name: "pickup", value: "my_location"),
            URLQueryItem(name: "dropoff[latitude]", value: "\(latitude)"),
            URLQueryItem(name: "dropoff[longitude]", value: "\(longitude)"),
            URLQueryItem(name: "dropoff[nickname]", value: destination),
            URLQueryItem(name: "dropoff[formatted_address]", value: destination),
            URLQueryItem(name: "user-agent", value: "rides-ios-v0-nyc-trip-2026")
        ])
        return items
    }
}

private extension Bundle {
    var uberClientID: String? {
        guard let uberConfig = object(forInfoDictionaryKey: "Uber") as? [String: Any],
              let clientID = uberConfig["ClientID"] as? String else {
            return nil
        }
        return clientID
    }
}
