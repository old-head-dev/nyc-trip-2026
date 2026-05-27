import SwiftUI

struct ClosingView: View {
    let step: Step
    let onBack: () -> Void

    private let heroSize: CGFloat = 200

    var body: some View {
        ZStack {
            step.background.ignoresSafeArea()

            VStack(spacing: 0) {
                Text(step.dayLabel)
                    .font(.dmSans(.semibold, size: 11))
                    .tracking(1.5)
                    .textCase(.uppercase)
                    .foregroundStyle(step.accent)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 8)

                Spacer()

                VStack(spacing: 22) {
                    Image(step.hero)
                        .resizable()
                        .scaledToFit()
                        .frame(height: heroSize)
                        .accessibilityHidden(true)

                    Text(step.title)
                        .font(.dmSans(.semibold, size: 24))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.tripTextPrimary)

                    if let subtitle = step.subtitle {
                        Text(subtitle)
                            .font(.dmSans(.regular, size: 15))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color.tripTextSecondary)
                            .lineSpacing(4)
                    }
                }

                Spacer()

                Button(action: onBack) {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 13, weight: .semibold))
                        Text("Back through the trip")
                            .font(.dmSans(.medium, size: 13))
                    }
                    .foregroundStyle(step.accent)
                }
                .padding(.bottom, 24)
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 28)
        }
    }
}

#Preview {
    ClosingView(
        step: Trip.closingStep,
        onBack: {}
    )
}
