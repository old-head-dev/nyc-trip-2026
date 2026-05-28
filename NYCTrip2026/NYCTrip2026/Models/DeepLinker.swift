import Foundation
#if canImport(UIKit)
import UIKit
#endif

enum DeepLinker {
    static func url(for cta: CTA) -> URL? {
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

        case let .openInUber(destination, _):
            var components = URLComponents(string: "https://m.uber.com/ul/")!
            components.queryItems = [
                URLQueryItem(name: "action", value: "setPickup"),
                URLQueryItem(name: "pickup", value: "my_location"),
                URLQueryItem(name: "dropoff[formatted_address]", value: destination)
            ]
            return components.url

        case .openMyTix:
            return URL(string: "njtransit://")

        case let .callPhone(number, _):
            return URL(string: "tel:\(number)")

        case let .openURL(url, _):
            return url
        }
    }

    /// Opens the URL via UIApplication. If the primary URL can't be opened (e.g. the
    /// target app isn't installed and the custom scheme is allow-listed but unhandled),
    /// fall back per CTA — currently only MyTix has a meaningful App Store fallback so
    /// Katy never sees a tap do nothing.
    @MainActor
    static func open(_ cta: CTA) {
        #if canImport(UIKit)
        let app = UIApplication.shared
        if let url = url(for: cta), app.canOpenURL(url) {
            app.open(url)
            return
        }
        if case .openMyTix = cta, let fallback = URL(string: "https://apps.apple.com/us/app/nj-transit-mobile-app/id964927905") {
            app.open(fallback)
        }
        #endif
    }
}
