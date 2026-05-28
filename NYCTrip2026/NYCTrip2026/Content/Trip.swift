import SwiftUI

enum Trip {

    // MARK: Color palette (warm-family + 2 dusty-cool accents)

    private static let peach        = (bg: "#fbe9dc", accent: "#b85c38")
    private static let blush        = (bg: "#f6e2d8", accent: "#a45a48")
    private static let dustyRose    = (bg: "#f0d3d8", accent: "#9c4a64")
    private static let clay         = (bg: "#ecd9c8", accent: "#a05b2e")
    private static let cream        = (bg: "#f8eedd", accent: "#8a6f3a")
    private static let butterCream  = (bg: "#f4e9cf", accent: "#86691d")
    private static let sageCream    = (bg: "#e0e3d4", accent: "#5e6c4a")
    private static let mistBlue     = (bg: "#d8dfe5", accent: "#4d6a82")
    private static let wisteria     = (bg: "#dcd5dd", accent: "#6b5e75")

    private static func colors(_ p: (bg: String, accent: String)) -> (Color, Color) {
        (Color(hex: p.bg), Color(hex: p.accent))
    }

    // MARK: Step factory

    private static func step(
        id: Int, day: Int, dayLabel: String,
        hero: String, title: String, subtitle: String? = nil,
        reservation: ReservationDetail? = nil,
        ctas: [CTA] = [],
        palette: (bg: String, accent: String)
    ) -> Step {
        let (bg, accent) = colors(palette)
        return Step(
            id: id, day: day, dayLabel: dayLabel,
            hero: hero, title: title, subtitle: subtitle,
            reservation: reservation, ctas: ctas,
            background: bg, accent: accent
        )
    }

    // MARK: The trip

    static let welcomeStep = step(
        id: 0, day: 0, dayLabel: "",
        hero: "icon",
        title: "Welcome to your\nNYC trip!",
        subtitle: "June 21-24, 2026",
        palette: peach
    )

    static let closingStep = step(
        id: 999, day: 5, dayLabel: "",
        hero: "icon",
        title: "Welcome home!",
        subtitle: "Hope you loved every minute.",
        palette: peach
    )

    static let day1: [Step] = [
        step(id: 1, day: 1, dayLabel: "Day 1 · 1 of 8",
             hero: "sedan_car", title: "Drive to\nMetropark Station",
             subtitle: "~10 hr drive to Iselin, NJ",
             ctas: [.openInGoogleMaps(destination: "Metropark Station, Iselin, NJ", label: "Open in Google Maps")],
             palette: mistBlue),

        step(id: 2, day: 1, dayLabel: "Day 1 · 2 of 8",
             hero: "sedan_car", title: "Park in the Metropark parking garage",
             subtitle: "No ticket required. Just drive in.",
             palette: butterCream),

        step(id: 3, day: 1, dayLabel: "Day 1 · 3 of 8",
             hero: "subway_train", title: "Train to Penn Station",
             subtitle: "Northeast Corridor line ~35-50 min\n\nActivate your tickets at the platform.",
             ctas: [.openNJTransit(label: "Open NJ Transit app")],
             palette: sageCream),

        step(id: 4, day: 1, dayLabel: "Day 1 · 4 of 8",
             hero: "uber_car", title: "Uber to \nThe Jewel Hotel",
             subtitle: "~15 min ride to 11 W 51st St",
             ctas: [.openInUber(destination: "The Jewel Hotel, 11 W 51st St, New York, NY", latitude: 40.7597381, longitude: -73.9777528, label: "Open in Uber")],
             palette: clay),

        step(id: 5, day: 1, dayLabel: "Day 1 · 5 of 8",
             hero: "hotel_building", title: "Check in at\nThe Jewel Hotel",
             reservation: ReservationDetail(
                time: "Check-in after 3pm",
                address: "11 W 51st St, across from Rockefeller Center",
                confirmation: "Expedia itinerary #73447998588498",
                extra: "Superior Room - reserved under Katy Hering"
             ),
             palette: peach),

        step(id: 6, day: 1, dayLabel: "Day 1 · 6 of 8",
             hero: "dinner", title: "Dinner at\nJoe's Pizza",
             subtitle: "~15-20 min walk to 1435 Broadway\n\nWalk to Times Square after... or walk through Times Square to get there",
             ctas: [.openInGoogleMaps(destination: "Joe's Pizza, 1435 Broadway, New York, NY", label: "Open in Google Maps")],
             palette: dustyRose),

        step(id: 7, day: 1, dayLabel: "Day 1 · 7 of 8",
             hero: "times_square", title: "Times Square",
             subtitle: "Very short walk from Joe's.\nBest at night when the lights are full.",
             ctas: [.openInGoogleMaps(destination: "Times Square, New York, NY", label: "Open in Google Maps")],
             palette: butterCream),

        step(id: 8, day: 1, dayLabel: "Day 1 · 8 of 8",
             hero: "hotel_building", title: "Return to\nThe Jewel Hotel",
             subtitle: "Open Google Maps for directions from wherever you are",
             ctas: [.openInGoogleMaps(destination: "The Jewel Hotel, 11 W 51st St, New York, NY", label: "Open in Google Maps")],
             palette: wisteria),
    ]

    static let day2: [Step] = [
        step(id: 9, day: 2, dayLabel: "Day 2 · 1 of 8",
             hero: "breakfast", title: "Breakfast at\nBlue Box Café",
             subtitle: "8-min walk from the hotel.",
             reservation: ReservationDetail(
                time: "10:00am (arrive by 10:15)",
                address: "727 5th Ave - 6th Floor of Tiffany & Co.",
                confirmation: "Reserved under Katy Hering",
                extra: "Breakfast for 2"
             ),
             ctas: [.openInGoogleMaps(destination: "Tiffany & Co., 727 5th Ave, New York, NY", label: "Open in Google Maps")],
             palette: cream),

        step(id: 10, day: 2, dayLabel: "Day 2 · 2 of 8",
             hero: "jellycat", title: "Jellycat Diner\nat FAO Schwarz",
             subtitle: "10-min walk from Breakfast.",
             reservation: ReservationDetail(
                time: "11:50am",
                address: "30 Rockefeller Plaza, FAO Schwarz building",
                confirmation: "Booking #351207910",
                extra: "Arrive 11:30-12:00 (no later than 12:00)"
             ),
             ctas: [.openInGoogleMaps(destination: "FAO Schwarz, 30 Rockefeller Plaza, New York, NY", label: "Open in Google Maps")],
             palette: blush),

        step(id: 11, day: 2, dayLabel: "Day 2 · 3 of 8",
             hero: "train_station", title: "Visit Grand\nCentral Terminal",
             subtitle: "15-min walk from Jellycat\n(or skip ahead to Central Park)",
             ctas: [.openInGoogleMaps(destination: "Grand Central Terminal, 89 E 42nd St, New York, NY", label: "Open in Google Maps")],
             palette: butterCream),

        step(id: 12, day: 2, dayLabel: "Day 2 · 4 of 8",
             hero: "lunch", title: "OPTIONAL: Lunch at\nVia Quadronno",
             subtitle: "25 E 73rd St\n(steps from Central Park east entrance)",
             ctas: [.openInUber(destination: "Via Quadronno, 25 E 73rd St, New York, NY", latitude: 40.7727446, longitude: -73.9651572, label: "Open in Uber")],
             palette: clay),

        step(id: 13, day: 2, dayLabel: "Day 2 · 5 of 8",
             hero: "central_park_spring", title: "Visit Central Park",
             subtitle: "(or skip back to Grand Central Terminal)\n\nDepending where you are,\nwalk (Google Maps) or ride (Uber).",
             ctas: [
                .openInGoogleMaps(destination: "Bethesda Fountain, Central Park, New York, NY", label: "Walk it (Google Maps)"),
                .openInUber(destination: "Bethesda Fountain, Central Park, New York, NY", latitude: 40.774122, longitude: -73.971136, label: "Drive it (Uber)")
             ],
             palette: sageCream),

        step(id: 14, day: 2, dayLabel: "Day 2 · 6 of 8",
             hero: "nyc_shopping", title: "Herald Square\n& Macy's",
             subtitle: "Uber ride from Central Park\nor 20-min walk from Grand Central.",
             ctas: [
                .openInGoogleMaps(destination: "Macy's Herald Square, 151 W 34th St, New York, NY", label: "Walk it (Google Maps)"),
                .openInUber(destination: "Macy's Herald Square, 151 W 34th St, New York, NY", latitude: 40.750797, longitude: -73.989578, label: "Drive it (Uber)")
             ],
             palette: dustyRose),

        step(id: 15, day: 2, dayLabel: "Day 2 · 7 of 8",
             hero: "hotel_building", title: "Back to hotel\nbefore dinner",
             subtitle: "25-minute walk from Macy's\nor take an Uber.",
             ctas: [
                .openInGoogleMaps(destination: "The Jewel Hotel, 11 W 51st St, New York, NY", label: "Walk it (Google Maps)"),
                .openInUber(destination: "The Jewel Hotel, 11 W 51st St, New York, NY", latitude: 40.7597381, longitude: -73.9777528, label: "Drive it (Uber)")
             ],
             palette: wisteria),

        step(id: 16, day: 2, dayLabel: "Day 2 · 8 of 8",
             hero: "dinner", title: "Dinner at\nTAO Uptown",
             subtitle: "~13-min walk from hotel.",
             reservation: ReservationDetail(
                time: "6:30pm (must arrive by 6:45)",
                address: "42 E 58th St",
                confirmation: "Confirmation #: 2112064704",
                extra: nil
             ),
             ctas: [.openInGoogleMaps(destination: "TAO Uptown, 42 E 58th St, New York, NY", label: "Open in Google Maps")],
             palette: dustyRose),
    ]

    static let day3: [Step] = [
        step(id: 17, day: 3, dayLabel: "Day 3 · 1 of 8",
             hero: "breakfast", title: "Cinnamon rolls at\nSunday Morning",
             subtitle: "11 W 25th St\nToo far to walk - take an Uber.",
             ctas: [.openInUber(destination: "Sunday Morning Bakehouse, 11 W 25th St, New York, NY 10010", latitude: 40.74339, longitude: -73.98971, label: "Open in Uber")],
             palette: butterCream),

        step(id: 18, day: 3, dayLabel: "Day 3 · 2 of 8",
             hero: "nyc_shopping", title: "SoHo shopping",
             subtitle: "Too far to walk - take an Uber.",
             ctas: [.openInUber(destination: "SoHo, Broadway & Spring St, New York, NY", latitude: 40.72350, longitude: -73.99830, label: "Open in Uber")],
             palette: blush),

        step(id: 19, day: 3, dayLabel: "Day 3 · 3 of 8",
             hero: "nyc_shopping", title: "Canal Street",
             subtitle: "~10-min walk from SoHo.",
             ctas: [.openInGoogleMaps(destination: "Canal Street, Chinatown, New York, NY", label: "Open in Google Maps")],
             palette: clay),

        step(id: 20, day: 3, dayLabel: "Day 3 · 4 of 8",
             hero: "lunch", title: "Lunch at\nJack's Wife Freda",
             subtitle: "226 Lafayette St · 10-min walk\nMediterranean-American, casual.",
             ctas: [.openInGoogleMaps(destination: "Jack's Wife Freda, 226 Lafayette St, New York, NY", label: "Open in Google Maps")],
             palette: cream),

        step(id: 21, day: 3, dayLabel: "Day 3 · 5 of 8",
             hero: "ice_cream_cone", title: "Museum of\nIce Cream",
             subtitle: "Short walk from lunch.",
             reservation: ReservationDetail(
                time: "2:00pm reservation (enter by 3:30pm)",
                address: "558 Broadway",
                confirmation: "Booking ID: FJ9*YPFVFMP*",
                extra: "Mobile ticket (email). Waivers are signed."
             ),
             ctas: [.openInGoogleMaps(destination: "Museum of Ice Cream, 558 Broadway, New York, NY", label: "Open in Google Maps")],
             palette: dustyRose),

        step(id: 22, day: 3, dayLabel: "Day 3 · 6 of 8",
             hero: "hotel_building", title: "Uber back\nto the hotel",
             subtitle: "Freshen up before evening.",
             ctas: [.openInUber(destination: "The Jewel Hotel, 11 W 51st St, New York, NY", latitude: 40.7597381, longitude: -73.9777528, label: "Open in Uber")],
             palette: wisteria),

        step(id: 23, day: 3, dayLabel: "Day 3 · 7 of 8",
             hero: "fifth_ave_sign", title: "Evening walk\n5th Ave & Madison Ave",
             subtitle: "2-min walk from hotel.\n(or skip ahead to dinner)",
             palette: mistBlue),

        step(id: 24, day: 3, dayLabel: "Day 3 · 8 of 8",
             hero: "dinner", title: "Dinner time",
             subtitle: "(or skip back to 5th Ave and Madison Ave)",
             ctas: [.openInGoogleMaps(destination: nil, label: "Open Google Maps")],
             palette: clay),
    ]

    static let day4: [Step] = [
        step(id: 25, day: 4, dayLabel: "Day 4 · 1 of 5",
             hero: "breakfast", title: "Breakfast at\nLiberty Bagels",
             subtitle: "~7-min walk from hotel.",
             ctas: [.openInGoogleMaps(destination: "Liberty Bagels Grand Central, 5 E 47th St, New York, NY", label: "Open in Google Maps")],
             palette: butterCream),

        step(id: 26, day: 4, dayLabel: "Day 4 · 2 of 5",
             hero: "hotel_building", title: "Back to hotel\nto check out",
             subtitle: "Checkout by 12pm.",
             ctas: [.openInGoogleMaps(destination: "The Jewel Hotel, 11 W 51st St, New York, NY", label: "Open in Google Maps")],
             palette: peach),

        step(id: 27, day: 4, dayLabel: "Day 4 · 3 of 5",
             hero: "uber_car", title: "Uber to\nPenn Station",
             subtitle: "Too far to walk with bags (30-min).",
             ctas: [.openInUber(destination: "Penn Station, 31st St & 8th Ave, New York, NY", latitude: 40.750568, longitude: -73.994235, label: "Open in Uber")],
             palette: clay),

        step(id: 28, day: 4, dayLabel: "Day 4 · 4 of 5",
             hero: "subway_train", title: "Take the train\nto Metropark",
             subtitle: "Northeast Corridor line ~35-50 min\n\nActivate your tickets at the platform.",
             ctas: [.openNJTransit(label: "Open NJ Transit app")],
             palette: sageCream),

        step(id: 29, day: 4, dayLabel: "Day 4 · 5 of 5",
             hero: "sedan_car", title: "~10 hr drive home",
             subtitle: "NexPass reads your license plate on the way out - no ticket, don't need to pay.",
             ctas: [.openInGoogleMaps(destination: "16206 Gemma Pass, Huntertown, IN", label: "Open in Google Maps")],
             palette: mistBlue),
    ]

    static let allSteps: [Step] = [welcomeStep] + day1 + day2 + day3 + day4 + [closingStep]

    /// Set of all asset names referenced by `allSteps`. Used in tests to verify every
    /// hero name resolves to a bundled image.
    static var referencedHeroNames: Set<String> { Set(allSteps.map(\.hero)) }
}
