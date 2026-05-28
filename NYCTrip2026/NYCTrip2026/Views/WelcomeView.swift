import SwiftUI

struct WelcomeView: View {
    let step: Step
    let totalCount: Int
    let onBegin: () -> Void

    @ScaledMetric private var heroSize: CGFloat = 200
    @ScaledMetric private var titleSize: CGFloat = 24
    @ScaledMetric private var subtitleSize: CGFloat = 15
    @ScaledMetric private var eyebrowSize: CGFloat = 11
    @ScaledMetric private var beginSize: CGFloat = 16

    var body: some View {
        ZStack {
            step.background.ignoresSafeArea()

            VStack(spacing: 0) {
                Text(step.dayLabel)
                    .font(.dmSans(.semibold, fixedSize: min(eyebrowSize, 16)))
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
                        .font(.dmSans(.semibold, fixedSize: min(titleSize, 32)))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.tripTextPrimary)
                        .minimumScaleFactor(0.7)
                        .lineLimit(3)
                        .accessibilityAddTraits(.isHeader)

                    if let subtitle = step.subtitle {
                        Text(subtitle)
                            .font(.dmSans(.regular, fixedSize: min(subtitleSize, 22)))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color.tripTextSecondary)
                            .lineSpacing(4)
                            .minimumScaleFactor(0.7)
                            .lineLimit(4)
                    }
                }

                Spacer()

                Button(action: onBegin) {
                    Text("Begin")
                        .font(.dmSans(.semibold, fixedSize: beginSize))
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
