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

    /// Opens the URL via UIApplication. No-op if the URL is nil or cannot be opened.
    @MainActor
    static func open(_ cta: CTA) {
        #if canImport(UIKit)
        guard let url = url(for: cta), UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
        #endif
    }
}
