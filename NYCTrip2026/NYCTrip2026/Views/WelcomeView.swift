import SwiftUI

struct WelcomeView: View {
    let step: Step
    let totalCount: Int
    let onBegin: () -> Void

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

                Button(action: onBegin) {
                    Text("Begin")
                        .font(.dmSans(.semibold, size: 16))
                        .tracking(0.5)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(step.accent)
                        )
                }
                .padding(.bottom, 24)
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 28)
        }
    }
}

#Preview {
    WelcomeView(
        step: Trip.welcomeStep,
        totalCount: 31,
        onBegin: {}
    )
}
