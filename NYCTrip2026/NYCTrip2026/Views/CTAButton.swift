import SwiftUI

struct CTAButton: View {
    let cta: CTA
    let accent: Color

    var body: some View {
        Button {
            DeepLinker.open(cta)
        } label: {
            HStack(spacing: 8) {
                Image(systemName: symbolName)
                    .font(.system(size: 16, weight: .semibold))
                Text(cta.label)
                    .font(.dmSans(.semibold, size: 16))
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 18)
            .padding(.vertical, 14)
            .frame(maxWidth: 260)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(accent)
            )
        }
        .accessibilityLabel(cta.label)
        .accessibilityHint("Opens \(appName)")
    }

    private var symbolName: String {
        switch cta {
        case .openInGoogleMaps: return "mappin.and.ellipse"
        case .openInUber:       return "car.fill"
        case .openNJTransit:    return "train.side.front.car"
        case .callPhone:        return "phone.fill"
        case .openURL:          return "arrow.up.right.square"
        }
    }

    private var appName: String {
        switch cta {
        case .openInGoogleMaps: return "Google Maps"
        case .openInUber:       return "Uber"
        case .openNJTransit:    return "NJ TRANSIT"
        case .callPhone:        return "Phone"
        case .openURL:          return "the link"
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        CTAButton(
            cta: .openInGoogleMaps(destination: "Times Square", label: "Open in Google Maps"),
            accent: Color(hex: "#b85c38")
        )
        CTAButton(
            cta: .openInUber(
                destination: "Penn Station",
                latitude: 40.750568,
                longitude: -73.994235,
                label: "Open in Uber · Drive"
            ),
            accent: Color(hex: "#4d6a82")
        )
    }
    .padding()
    .background(Color(hex: "#fbe9dc"))
}
