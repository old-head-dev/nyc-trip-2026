import SwiftUI

struct ClosingView: View {
    let step: Step
    let onBack: () -> Void

    @ScaledMetric private var heroSize: CGFloat = 200
    @ScaledMetric private var titleSize: CGFloat = 24
    @ScaledMetric private var subtitleSize: CGFloat = 15
    @ScaledMetric private var eyebrowSize: CGFloat = 11
    @ScaledMetric private var backLinkSize: CGFloat = 13
    @ScaledMetric private var backLinkSymbolSize: CGFloat = 13

    private var accessibilityText: String {
        var parts: [String] = []
        parts.append(step.title.replacingOccurrences(of: "\n", with: " "))
        if let subtitle = step.subtitle { parts.append(subtitle.replacingOccurrences(of: "\n", with: " ")) }
        return parts.joined(separator: ". ")
    }

    var body: some View {
        ZStack {
            step.background.ignoresSafeArea()

            VStack(spacing: 0) {
                Text(step.dayLabel)
                    .font(.dmSans(.semibold, size: min(eyebrowSize, 16)))
                    .tracking(1.5)
                    .textCase(.uppercase)
                    .foregroundStyle(step.accent)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 8)

                Spacer()

                VStack(spacing: 22) {
                    Image(step.hero)
                        .resizable()
                        .scaledToFit()
                        .frame(height: min(heroSize, 240))
                        .accessibilityHidden(true)

                    Text(step.title)
                        .font(.dmSans(.semibold, size: min(titleSize, 32)))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.tripTextPrimary)
                        .minimumScaleFactor(0.7)
                        .lineLimit(3)

                    if let subtitle = step.subtitle {
                        Text(subtitle)
                            .font(.dmSans(.regular, size: min(subtitleSize, 22)))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color.tripTextSecondary)
                            .lineSpacing(4)
                            .minimumScaleFactor(0.7)
                            .lineLimit(4)
                    }
                }

                Spacer()

                Button(action: onBack) {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: backLinkSymbolSize, weight: .semibold))
                        Text("Back through the trip")
                            .font(.dmSans(.medium, size: backLinkSize))
                    }
                    .foregroundStyle(step.accent)
                }
                .padding(.bottom, 24)
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 28)
        }
        // .contain preserves the "Back through the trip" button as its own focus.
        .accessibilityElement(children: .contain)
        .accessibilityLabel(accessibilityText)
    }
}

#Preview {
    ClosingView(
        step: Trip.closingStep,
        onBack: {}
    )
}
