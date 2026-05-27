import SwiftUI

struct Step: Identifiable {
    let id: Int
    let day: Int                  // 1...4 for trip days; 0 = welcome; 5 = closing
    let dayLabel: String          // e.g., "Day 2 · 6 of 8"
    let hero: String              // Asset catalog image set name (e.g., "breakfast", "icon")
    let title: String             // 1-2 lines
    let subtitle: String?         // optional, 1-2 lines
    let reservation: ReservationDetail?
    let ctas: [CTA]               // 0, 1, or 2 buttons
    let background: Color
    let accent: Color
}

struct ReservationDetail {
    let time: String              // "10:00 AM" or "Check-in 3:00 PM"
    let address: String           // "727 5th Ave, 5th Floor"
    let confirmation: String?     // "#351207910" or hotel conf #, optional
    let extra: String?            // "Room: King Suite" or "Breakfast for 2", optional
}

enum CTA {
    case openInGoogleMaps(destination: String?, label: String)  // nil = Maps with no preset
    case openInUber(destination: String, label: String)
    case openMyTix(label: String)
    case callPhone(number: String, label: String)
    case openURL(URL, label: String)

    var label: String {
        switch self {
        case .openInGoogleMaps(_, let label),
             .openInUber(_, let label),
             .openMyTix(let label),
             .callPhone(_, let label),
             .openURL(_, let label):
            return label
        }
    }
}
