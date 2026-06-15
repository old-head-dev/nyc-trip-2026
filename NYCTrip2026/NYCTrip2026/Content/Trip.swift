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
        hidesHero: Bool = false,
        palette: (bg: String, accent: String)
    ) -> Step {
        let (bg, accent) = colors(palette)
        return Step(
            id: id, day: day, dayLabel: dayLabel,
            hero: hero, title: title, subtitle: subtitle,
            reservation: reservation, ctas: ctas,
            background: bg, accent: accent,
            hidesHero: hidesHero
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
        step(id: 1, day: 1, dayLabel: "Day 1 · 1 of 9",
             hero: "sedan_car", title: "Drive to\nMetropark Station",
             subtitle: "~10 hr drive to Iselin, NJ",
             ctas: [.openInGoogleMaps(destination: "Metropark Station, Iselin, NJ", label: "Open in Google Maps")],
             palette: mistBlue),

        step(id: 2, day: 1, dayLabel: "Day 1 · 2 of 9",
             hero: "sedan_car", title: "Park in the Metropark parking garage",
             subtitle: "No ticket required. Just drive in.",
             palette: butterCream),

        step(id: 3, day: 1, dayLabel: "Day 1 · 3 of 9",
             hero: "subway_train", title: "Train to Penn Station",
             subtitle: "Northeast Corridor line ~35-50 min\n\nActivate your tickets at the platform.",
             ctas: [.openNJTransit(label: "Open NJ Transit app")],
             palette: sageCream),

        step(id: 4, day: 1, dayLabel: "Day 1 · 4 of 9",
             hero: "uber_car", title: "Hail a cab to\nThe Jewel Hotel",
             subtitle: "~15 min ride to 11 W 51st St.\nGrab a yellow cab outside Penn — or use Uber as a backup.\n\n(Or swipe forward for subway instructions.)",
             ctas: [.openInUber(destination: "The Jewel Hotel, 11 W 51st St, New York, NY", latitude: 40.7597381, longitude: -73.9777528, label: "Backup: open Uber")],
             palette: clay),

        step(id: 5, day: 1, dayLabel: "Day 1 · 5 of 9",
             hero: "subway_train", title: "Or take the subway\nto the hotel",
             subtitle: "Inside Penn, follow signs to the 8th Ave A/C/E subway.\n\nTake the uptown E train only, toward Queens / Jamaica Center — do not take the A or C. Ride 4 stops to 5 Av/53 St.\n\nExit on the 5th Ave side, walk south to 51st St, turn right (west) — the hotel is at 11 W 51st St. Allow 20–25 min with luggage.",
             ctas: [.openInGoogleMaps(destination: "The Jewel Hotel, 11 W 51st St, New York, NY", label: "Open hotel in Google Maps")],
             hidesHero: true,
             palette: mistBlue),

        step(id: 6, day: 1, dayLabel: "Day 1 · 6 of 9",
             hero: "hotel_building", title: "Check in at\nThe Jewel Hotel",
             reservation: ReservationDetail(
                time: "Check-in after 3pm",
                address: "11 W 51st St, across from Rockefeller Center",
                confirmation: "Expedia itinerary #73447998588498",
                extra: "Superior Room - reserved under Katy Hering"
             ),
             palette: peach),

        step(id: 7, day: 1, dayLabel: "Day 1 · 7 of 9",
             hero: "dinner", title: "Dinner at\nJoe's Pizza",
             subtitle: "~15-20 min walk to 1435 Broadway\n\nWalk to Times Square after... or walk through Times Square to get there",
             ctas: [.openInGoogleMaps(destination: "Joe's Pizza, 1435 Broadway, New York, NY", label: "Open in Google Maps")],
             palette: dustyRose),

        step(id: 8, day: 1, dayLabel: "Day 1 · 8 of 9",
             hero: "times_square", title: "Times Square",
             subtitle: "Very short walk from Joe's.\nBest at night when the lights are full.",
             ctas: [.openInGoogleMaps(destination: "Times Square, New York, NY", label: "Open in Google Maps")],
             palette: butterCream),

        step(id: 9, day: 1, dayLabel: "Day 1 · 9 of 9",
             hero: "hotel_building", title: "Return to\nThe Jewel Hotel",
             subtitle: "Open Google Maps for directions from wherever you are",
             ctas: [.openInGoogleMaps(destination: "The Jewel Hotel, 11 W 51st St, New York, NY", label: "Open in Google Maps")],
             palette: wisteria),
    ]

    static let day2: [Step] = [
        step(id: 10, day: 2, dayLabel: "Day 2 · 1 of 9",
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

        step(id: 11, day: 2, dayLabel: "Day 2 · 2 of 9",
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

        step(id: 12, day: 2, dayLabel: "Day 2 · 3 of 9",
             hero: "train_station", title: "Visit Grand\nCentral Terminal",
             subtitle: "15-min walk from Jellycat\n(or skip ahead to Brandy Melville)",
             ctas: [.openInGoogleMaps(destination: "Grand Central Terminal, 89 E 42nd St, New York, NY", label: "Open in Google Maps")],
             palette: butterCream),

        step(id: 13, day: 2, dayLabel: "Day 2 · 4 of 9",
             hero: "nyc_shopping", title: "Brandy Melville",
             subtitle: "1172 3rd Ave (68th & 3rd), Upper East Side\nA longer walk up from Grand Central, or a short cab.",
             ctas: [.openInGoogleMaps(destination: "Brandy Melville, 1172 3rd Ave, New York, NY", label: "Open in Google Maps")],
             palette: dustyRose),

        step(id: 14, day: 2, dayLabel: "Day 2 · 5 of 9",
             hero: "lunch", title: "OPTIONAL: Lunch at\nVia Quadronno",
             subtitle: "25 E 73rd St\n(steps from Central Park east entrance)",
             ctas: [.openInUber(destination: "Via Quadronno, 25 E 73rd St, New York, NY", latitude: 40.7727446, longitude: -73.9651572, label: "Cab or Uber")],
             palette: clay),

        step(id: 15, day: 2, dayLabel: "Day 2 · 6 of 9",
             hero: "central_park_spring", title: "Visit Central Park",
             subtitle: "(or skip back to the Upper East Side)\n\nDepending where you are,\nwalk (Google Maps) or grab a cab / Uber.",
             ctas: [
                .openInGoogleMaps(destination: "Bethesda Fountain, Central Park, New York, NY", label: "Walk it (Google Maps)"),
                .openInUber(destination: "Bethesda Fountain, Central Park, New York, NY", latitude: 40.774122, longitude: -73.971136, label: "Cab or Uber")
             ],
             palette: sageCream),

        step(id: 16, day: 2, dayLabel: "Day 2 · 7 of 9",
             hero: "nyc_shopping", title: "Herald Square\n& Macy's",
             subtitle: "Cab or Uber from Central Park\nor 20-min walk from Grand Central.",
             ctas: [
                .openInGoogleMaps(destination: "Macy's Herald Square, 151 W 34th St, New York, NY", label: "Walk it (Google Maps)"),
                .openInUber(destination: "Macy's Herald Square, 151 W 34th St, New York, NY", latitude: 40.750797, longitude: -73.989578, label: "Cab or Uber")
             ],
             palette: dustyRose),

        step(id: 17, day: 2, dayLabel: "Day 2 · 8 of 9",
             hero: "hotel_building", title: "Back to hotel\nbefore dinner",
             subtitle: "25-minute walk from Macy's\nor grab a cab / Uber.",
             ctas: [
                .openInGoogleMaps(destination: "The Jewel Hotel, 11 W 51st St, New York, NY", label: "Walk it (Google Maps)"),
                .openInUber(destination: "The Jewel Hotel, 11 W 51st St, New York, NY", latitude: 40.7597381, longitude: -73.9777528, label: "Cab or Uber")
             ],
             palette: wisteria),

        step(id: 18, day: 2, dayLabel: "Day 2 · 9 of 9",
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
        step(id: 19, day: 3, dayLabel: "Day 3 · 1 of 11",
             hero: "breakfast", title: "Cinnamon rolls at\nSunday Morning",
             subtitle: "11 W 25th St · about a 25-min walk, or swipe forward for subway instructions.\n\nNot feeling the walk? Grab Starbucks near the hotel instead.",
             ctas: [
                .openInGoogleMaps(destination: "Sunday Morning Bakehouse, 11 W 25th St, New York, NY 10010", label: "Walk it (Google Maps)"),
                .openInGoogleMaps(destination: "Starbucks, 1290 Sixth Avenue, New York, NY", label: "Starbucks instead")
             ],
             palette: butterCream),

        step(id: 20, day: 3, dayLabel: "Day 3 · 2 of 11",
             hero: "subway_train", title: "Subway option:\nhotel → Sunday Morning",
             subtitle: "Walk to 47–50 Sts–Rockefeller Center (6th Ave).\n\nTake a downtown F or M train only — not B or D — 3 stops to 23 St.\n\nWalk north to 25th St, turn right — the bakery is mid-block. ~15 min.",
             ctas: [.openInGoogleMaps(destination: "47-50 Sts–Rockefeller Center Station, New York, NY", label: "Open station in Google Maps")],
             hidesHero: true,
             palette: mistBlue),

        step(id: 21, day: 3, dayLabel: "Day 3 · 3 of 11",
             hero: "ice_cream_cone", title: "Museum of\nIce Cream",
             subtitle: "Hail a cab from breakfast — or swipe forward for subway instructions.",
             reservation: ReservationDetail(
                time: "11:30am reservation",
                address: "558 Broadway, at Prince St (SoHo)",
                confirmation: "Booking ID: FJ9*YPFVFMP*",
                extra: "Mobile ticket (email). Waivers are signed."
             ),
             ctas: [.openInUber(destination: "Museum of Ice Cream, 558 Broadway, New York, NY", latitude: 40.7238545, longitude: -73.9979167, label: "Backup: open Uber")],
             palette: dustyRose),

        step(id: 22, day: 3, dayLabel: "Day 3 · 4 of 11",
             hero: "subway_train", title: "Subway option:\nto the museum",
             subtitle: "Take the downtown R or W train only to Prince St — NOT the N or Q (they skip Prince St). The museum is steps from the exit.\n\nFrom Sunday Morning, board at 23 St (R/W). From the hotel/Starbucks, board at 49 St (R/W).",
             ctas: [
                .openInGoogleMaps(destination: "23 St Station (R/W), Broadway & W 23rd St, New York, NY", label: "From breakfast: 23 St"),
                .openInGoogleMaps(destination: "49 St Station (R/W), W 49th St & 7th Ave, New York, NY", label: "From the hotel: 49 St")
             ],
             hidesHero: true,
             palette: mistBlue),

        step(id: 23, day: 3, dayLabel: "Day 3 · 5 of 11",
             hero: "lunch", title: "OPTIONAL: Lunch at\nJack's Wife Freda",
             subtitle: "226 Lafayette St · steps from the museum.\nMediterranean-American, casual.",
             ctas: [.openInGoogleMaps(destination: "Jack's Wife Freda, 226 Lafayette St, New York, NY", label: "Open in Google Maps")],
             palette: cream),

        step(id: 24, day: 3, dayLabel: "Day 3 · 6 of 11",
             hero: "nyc_shopping", title: "SoHo shopping",
             subtitle: "Start around Prince & Mercer. Walk Prince → Greene → Spring → Wooster — the classic cobblestone boutique blocks — dipping over to Broadway for the bigger stores.\n\nWorth a look: Aritzia (560 Broadway), MoMA Design Store (81 Spring), Mure + Grand (155 Spring), Pearl River Mart (452 Broadway).",
             ctas: [.openInGoogleMaps(destination: "Prince St & Mercer St, New York, NY", label: "Open start point in Maps")],
             hidesHero: true,
             palette: blush),

        step(id: 25, day: 3, dayLabel: "Day 3 · 7 of 11",
             hero: "nyc_shopping", title: "Canal Street",
             subtitle: "Start at Broadway & Canal, then walk east on Canal toward Lafayette/Centre.\n\nThe classic busy-Canal stretch — crowded sidewalks, souvenir shops, bargain finds. A fun browse more than serious shopping.",
             ctas: [.openInGoogleMaps(destination: "Canal St & Broadway, New York, NY", label: "Open start point in Maps")],
             hidesHero: true,
             palette: clay),

        step(id: 26, day: 3, dayLabel: "Day 3 · 8 of 11",
             hero: "hotel_building", title: "Hail a cab\nback to the hotel",
             subtitle: "Freshen up before evening.\nGrab a yellow cab — or use Uber as a backup.\n\n(Or swipe forward for subway instructions.)",
             ctas: [.openInUber(destination: "The Jewel Hotel, 11 W 51st St, New York, NY", latitude: 40.7597381, longitude: -73.9777528, label: "Backup: open Uber")],
             palette: wisteria),

        step(id: 27, day: 3, dayLabel: "Day 3 · 9 of 11",
             hero: "subway_train", title: "Subway option:\nCanal St → hotel",
             subtitle: "At Broadway & Canal, take an uptown N, R, or W train to 49 St — not the Q (it veers off toward the Upper East Side). The N runs local this far north, so it's fine here.\n\nExit at 7th Ave & 49th, walk north to 51st St, turn right.",
             ctas: [.openInGoogleMaps(destination: "Canal St Station, Broadway & Canal St, New York, NY", label: "Open station in Google Maps")],
             hidesHero: true,
             palette: mistBlue),

        step(id: 28, day: 3, dayLabel: "Day 3 · 10 of 11",
             hero: "fifth_ave_sign", title: "Evening walk\n5th Ave & Madison Ave",
             subtitle: "2-min walk from hotel.\n(or skip ahead to dinner)",
             palette: peach),

        step(id: 29, day: 3, dayLabel: "Day 3 · 11 of 11",
             hero: "dinner", title: "Dinner time",
             subtitle: "(or skip back to 5th Ave and Madison Ave)",
             ctas: [.openInGoogleMaps(destination: nil, label: "Open Google Maps")],
             palette: clay),
    ]

    static let day4: [Step] = [
        step(id: 30, day: 4, dayLabel: "Day 4 · 1 of 6",
             hero: "breakfast", title: "Breakfast at\nLiberty Bagels",
             subtitle: "~7-min walk from hotel.",
             ctas: [.openInGoogleMaps(destination: "Liberty Bagels Grand Central, 5 E 47th St, New York, NY", label: "Open in Google Maps")],
             palette: butterCream),

        step(id: 31, day: 4, dayLabel: "Day 4 · 2 of 6",
             hero: "hotel_building", title: "Back to hotel\nto check out",
             subtitle: "Checkout by 12pm.",
             ctas: [.openInGoogleMaps(destination: "The Jewel Hotel, 11 W 51st St, New York, NY", label: "Open in Google Maps")],
             palette: peach),

        step(id: 32, day: 4, dayLabel: "Day 4 · 3 of 6",
             hero: "uber_car", title: "Hail a cab to\nPenn Station",
             subtitle: "Too far to walk with bags (~30 min).\nGrab a yellow cab — or use Uber as a backup.\n\n(Or swipe forward for subway instructions.)",
             ctas: [.openInUber(destination: "Penn Station, 31st St & 8th Ave, New York, NY", latitude: 40.750568, longitude: -73.994235, label: "Backup: open Uber")],
             palette: clay),

        step(id: 33, day: 4, dayLabel: "Day 4 · 4 of 6",
             hero: "subway_train", title: "Subway option:\nhotel → Penn Station",
             subtitle: "Walk to 5 Av/53 St (E/F). Take the downtown E train only (toward World Trade Center) — not the F — 4 stops to 34 St–Penn Station.\n\nWeekday mornings 6:30–10:30am the 5 Av/53 St entrance is closed for repairs — enter at 7 Av (53rd & 7th) instead and take the downtown E 3 stops to Penn.",
             ctas: [
                .openInGoogleMaps(destination: "7 Av Station, W 53rd St & 7th Ave, New York, NY", label: "Before 10:30am: 7 Av"),
                .openInGoogleMaps(destination: "5 Av/53 St Station, New York, NY", label: "After 10:30am: 5 Av/53 St")
             ],
             hidesHero: true,
             palette: mistBlue),

        step(id: 34, day: 4, dayLabel: "Day 4 · 5 of 6",
             hero: "subway_train", title: "Take the train\nto Metropark",
             subtitle: "Northeast Corridor line ~35-50 min\n\nActivate your tickets at the platform.",
             ctas: [.openNJTransit(label: "Open NJ Transit app")],
             palette: sageCream),

        step(id: 35, day: 4, dayLabel: "Day 4 · 6 of 6",
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
