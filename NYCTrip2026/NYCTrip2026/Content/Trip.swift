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
        id: 0, day: 0, dayLabel: "NYC Trip · June 21–24, 2026",
        hero: "icon",
        title: "Katy and Jada…",
        subtitle: "Welcome to your\nNYC trip!\n\nJune 21–24, 2026",
        palette: peach
    )

    static let closingStep = step(
        id: 999, day: 5, dayLabel: "Trip complete",
        hero: "icon",
        title: "Welcome home!",
        subtitle: "Hope you loved every minute.",
        palette: peach
    )

    static let day1: [Step] = [
        step(id: 1, day: 1, dayLabel: "Day 1 · 1 of 8",
             hero: "sedan_car", title: "Drive to\nMetropark Station",
             subtitle: "Iselin, NJ · ~640 miles\nDepart Fort Wayne by 7 AM",
             ctas: [.openInGoogleMaps(destination: "Metropark Station, Iselin, NJ", label: "Open in Google Maps")],
             palette: mistBlue),

        step(id: 2, day: 1, dayLabel: "Day 1 · 2 of 8",
             hero: "sedan_car", title: "Park at Metropark",
             subtitle: "NexPass reads your plate automatically.\nNo ticket. Just drive in.",
             palette: butterCream),

        step(id: 3, day: 1, dayLabel: "Day 1 · 3 of 8",
             hero: "subway_train", title: "Take the train\nto NY Penn",
             subtitle: "Northeast Corridor line · ~45 min\nActivate your MyTix ticket at the platform.",
             ctas: [.openMyTix(label: "Open MyTix")],
             palette: sageCream),

        step(id: 4, day: 1, dayLabel: "Day 1 · 4 of 8",
             hero: "uber_car", title: "Uber to The Jewel",
             subtitle: "From Penn Station · ~10 min",
             ctas: [.openInUber(destination: "The Jewel New York, 11 W 51st St, New York, NY", label: "Open in Uber")],
             palette: clay),

        step(id: 5, day: 1, dayLabel: "Day 1 · 5 of 8",
             hero: "hotel_building", title: "Check in at\nThe Jewel",
             subtitle: "11 W 51st St · directly across from Rockefeller Center",
             reservation: ReservationDetail(
                time: "Check-in 3:00 PM",
                address: "11 W 51st St, New York, NY 10019",
                confirmation: "(confirmation # — Jon to fill in)",
                extra: "(room type — Jon to fill in)"
             ),
             palette: peach),

        step(id: 6, day: 1, dayLabel: "Day 1 · 6 of 8",
             hero: "dinner", title: "Dinner at\nJoe's Pizza",
             subtitle: "1435 Broadway · Original NYC slice joint\nGrab slices, walk Times Square after.",
             ctas: [.openInGoogleMaps(destination: "Joe's Pizza, 1435 Broadway, New York, NY", label: "Open in Google Maps")],
             palette: dustyRose),

        step(id: 7, day: 1, dayLabel: "Day 1 · 7 of 8",
             hero: "times_square", title: "Times Square\nfirst look",
             subtitle: "Best at night when the lights are full.\nNo rush tonight.",
             ctas: [.openInGoogleMaps(destination: "Times Square, New York, NY", label: "Open in Google Maps")],
             palette: butterCream),

        step(id: 8, day: 1, dayLabel: "Day 1 · 8 of 8",
             hero: "hotel_building", title: "Return to\nThe Jewel",
             subtitle: "Call it an early night.",
             ctas: [.openInGoogleMaps(destination: "The Jewel New York, 11 W 51st St, New York, NY", label: "Open in Google Maps")],
             palette: wisteria),
    ]

    static let day2: [Step] = [
        step(id: 9, day: 2, dayLabel: "Day 2 · 1 of 8",
             hero: "breakfast", title: "Breakfast at\nBlue Box Café",
             subtitle: "4-min walk from the hotel.",
             reservation: ReservationDetail(
                time: "10:00 AM",
                address: "727 5th Ave, 5th Floor",
                confirmation: nil,
                extra: "Breakfast for 2"
             ),
             ctas: [.openInGoogleMaps(destination: "Tiffany & Co., 727 5th Ave, New York, NY", label: "Open in Google Maps")],
             palette: cream),

        step(id: 10, day: 2, dayLabel: "Day 2 · 2 of 8",
             hero: "jellycat", title: "Jellycat Diner\nat FAO Schwarz",
             subtitle: "5-min walk from Tiffany's.\nArrive a few minutes early — 10-min slot.",
             reservation: ReservationDetail(
                time: "11:50 AM – 12:00 PM",
                address: "30 Rockefeller Plaza, 1st floor",
                confirmation: "#351207910",
                extra: nil
             ),
             ctas: [.openInGoogleMaps(destination: "FAO Schwarz, 30 Rockefeller Plaza, New York, NY", label: "Open in Google Maps")],
             palette: blush),

        step(id: 11, day: 2, dayLabel: "Day 2 · 3 of 8",
             hero: "train_station", title: "Visit Grand\nCentral Terminal",
             subtitle: "Celestial ceiling, Whispering Gallery, Grand Central Market.",
             ctas: [.openInGoogleMaps(destination: "Grand Central Terminal, 89 E 42nd St, New York, NY", label: "Open in Google Maps")],
             palette: butterCream),

        step(id: 12, day: 2, dayLabel: "Day 2 · 4 of 8",
             hero: "lunch", title: "OPTIONAL: Lunch at\nVia Quadronno",
             subtitle: "25 E 73rd St · steps from Central Park east entrance.\nSkip if breakfast still holds.",
             ctas: [.openInGoogleMaps(destination: "Via Quadronno, 25 E 73rd St, New York, NY", label: "Open in Google Maps")],
             palette: clay),

        step(id: 13, day: 2, dayLabel: "Day 2 · 5 of 8",
             hero: "central_park_spring", title: "Walk Central Park",
             subtitle: "Strawberry Fields → Bow Bridge → Bethesda Fountain → The Mall.",
             ctas: [
                .openInGoogleMaps(destination: "Bethesda Fountain, Central Park, New York, NY", label: "Open in Google Maps · Walk"),
                .openInUber(destination: "Bethesda Fountain, Central Park, New York, NY", label: "Open in Uber · Drive")
             ],
             palette: sageCream),

        step(id: 14, day: 2, dayLabel: "Day 2 · 6 of 8",
             hero: "nyc_shopping", title: "Herald Square\n& Macy's",
             subtitle: "11 floors, world's largest department store.",
             ctas: [.openInUber(destination: "Macy's Herald Square, 151 W 34th St, New York, NY", label: "Open in Uber")],
             palette: dustyRose),

        step(id: 15, day: 2, dayLabel: "Day 2 · 7 of 8",
             hero: "hotel_building", title: "Back to hotel\nFreshen up",
             subtitle: "TAO is the dress-up dinner.",
             ctas: [
                .openInGoogleMaps(destination: "The Jewel New York, 11 W 51st St, New York, NY", label: "Open in Google Maps · Walk"),
                .openInUber(destination: "The Jewel New York, 11 W 51st St, New York, NY", label: "Open in Uber · Drive")
             ],
             palette: wisteria),

        step(id: 16, day: 2, dayLabel: "Day 2 · 8 of 8",
             hero: "dinner", title: "Dinner at\nTAO Uptown",
             subtitle: "Dramatic pan-Asian. Dress up.",
             reservation: ReservationDetail(
                time: "6:30 PM",
                address: "42 E 58th St",
                confirmation: "(OpenTable conf # — Jon to fill in)",
                extra: nil
             ),
             ctas: [.openInGoogleMaps(destination: "TAO Uptown, 42 E 58th St, New York, NY", label: "Open in Google Maps")],
             palette: dustyRose),
    ]

    static let day3: [Step] = [
        step(id: 17, day: 3, dayLabel: "Day 3 · 1 of 8",
             hero: "breakfast", title: "Breakfast at\nSunday Morning",
             subtitle: "29 W 25th St · Cinnamon rolls are the reason to go.",
             ctas: [.openInUber(destination: "Sunday Morning Bakehouse, 29 W 25th St, New York, NY", label: "Open in Uber")],
             palette: butterCream),

        step(id: 18, day: 3, dayLabel: "Day 3 · 2 of 8",
             hero: "nyc_shopping", title: "SoHo shopping",
             subtitle: "Broadway, Spring, Prince. Walk once you arrive.",
             ctas: [.openInUber(destination: "SoHo, Broadway & Spring St, New York, NY", label: "Open in Uber")],
             palette: blush),

        step(id: 19, day: 3, dayLabel: "Day 3 · 3 of 8",
             hero: "nyc_shopping", title: "Canal Street",
             subtitle: "Chinatown market vibe · ~11-min walk from SoHo.",
             ctas: [.openInGoogleMaps(destination: "Canal Street, Chinatown, New York, NY", label: "Open in Google Maps")],
             palette: clay),

        step(id: 20, day: 3, dayLabel: "Day 3 · 4 of 8",
             hero: "lunch", title: "Lunch at\nJack's Wife Freda",
             subtitle: "226 Lafayette St · Mediterranean-American, casual.",
             ctas: [.openInGoogleMaps(destination: "Jack's Wife Freda, 226 Lafayette St, New York, NY", label: "Open in Google Maps")],
             palette: cream),

        step(id: 21, day: 3, dayLabel: "Day 3 · 5 of 8",
             hero: "ice_cream_cone", title: "Museum of\nIce Cream",
             subtitle: "Interactive immersive experience.\nAllow 60–90 min inside.",
             reservation: ReservationDetail(
                time: "(time set by ticket purchase)",
                address: "558 Broadway, SoHo",
                confirmation: "(ticket conf # — Jon to fill in)",
                extra: nil
             ),
             ctas: [.openInGoogleMaps(destination: "Museum of Ice Cream, 558 Broadway, New York, NY", label: "Open in Google Maps")],
             palette: dustyRose),

        step(id: 22, day: 3, dayLabel: "Day 3 · 6 of 8",
             hero: "uber_car", title: "Uber back\nto the hotel",
             subtitle: "Freshen up before evening.",
             ctas: [.openInUber(destination: "The Jewel New York, 11 W 51st St, New York, NY", label: "Open in Uber")],
             palette: wisteria),

        step(id: 23, day: 3, dayLabel: "Day 3 · 7 of 8",
             hero: "fifth_ave_sign", title: "Evening walk\n5th Ave & Madison",
             subtitle: "Storefronts at dusk. Tiffany's, Bergdorf, Saks.\n4-min walk from the hotel.",
             palette: mistBlue),

        step(id: 24, day: 3, dayLabel: "Day 3 · 8 of 8",
             hero: "dinner", title: "Dinner — pick\na spot near hotel",
             subtitle: "Open call. Use Google Maps to search.",
             ctas: [.openInGoogleMaps(destination: nil, label: "Open Google Maps")],
             palette: clay),
    ]

    static let day4: [Step] = [
        step(id: 25, day: 4, dayLabel: "Day 4 · 1 of 5",
             hero: "breakfast", title: "Breakfast at\nLiberty Bagels",
             subtitle: "Classic NY bagel · Grab and go.",
             ctas: [.openInGoogleMaps(destination: "Liberty Bagels Midtown, 260 W 35th St, New York, NY", label: "Open in Google Maps")],
             palette: butterCream),

        step(id: 26, day: 4, dayLabel: "Day 4 · 2 of 5",
             hero: "hotel_building", title: "Back to The Jewel\nCheck out",
             subtitle: "Checkout by 12:00 PM (noon).\nFront desk can hold bags if you want to stroll.",
             ctas: [.openInGoogleMaps(destination: "The Jewel New York, 11 W 51st St, New York, NY", label: "Open in Google Maps")],
             palette: peach),

        step(id: 27, day: 4, dayLabel: "Day 4 · 3 of 5",
             hero: "uber_car", title: "Uber to\nPenn Station",
             subtitle: "Aim to be at Penn by 11 AM.",
             ctas: [.openInUber(destination: "Moynihan Train Hall, 31st St & 8th Ave, New York, NY", label: "Open in Uber")],
             palette: clay),

        step(id: 28, day: 4, dayLabel: "Day 4 · 4 of 5",
             hero: "subway_train", title: "Take the train\nto Metropark",
             subtitle: "Northeast Corridor line · ~45 min\nActivate your MyTix ticket at the platform.",
             ctas: [.openMyTix(label: "Open MyTix")],
             palette: sageCream),

        step(id: 29, day: 4, dayLabel: "Day 4 · 5 of 5",
             hero: "sedan_car", title: "Drive home\nto Fort Wayne",
             subtitle: "NexPass reads your plate on the way out — no parking ticket to pay.\nHome by 9–10 PM.",
             ctas: [.openInGoogleMaps(destination: "Fort Wayne, IN", label: "Open in Google Maps")],
             palette: mistBlue),
    ]

    static let allSteps: [Step] = [welcomeStep] + day1 + day2 + day3 + day4 + [closingStep]

    /// Set of all asset names referenced by `allSteps`. Used in tests to verify every
    /// hero name resolves to a bundled image.
    static var referencedHeroNames: Set<String> { Set(allSteps.map(\.hero)) }
}
