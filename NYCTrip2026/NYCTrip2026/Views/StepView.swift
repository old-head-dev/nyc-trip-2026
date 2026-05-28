import SwiftUI

struct StepView: View {
    let step: Step
    let currentIndex: Int
    let totalCount: Int
    let onBack: () -> Void
    let onNext: () -> Void

    @ScaledMetric private var heroSize: CGFloat = 180
    @ScaledMetric private var titleSize: CGFloat = 22
    @ScaledMetric private var subtitleSize: CGFloat = 13
    @ScaledMetric private var eyebrowSize: CGFloat = 11

    private var dayPeers: [Step] {
        Trip.allSteps.filter { $0.day == step.day }
    }

    private var dayPosition: Int {
        dayPeers.firstIndex(where: { $0.id == step.id }) ?? 0
    }

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

                VStack(spacing: 18) {
                    Image(step.hero)
                        .resizable()
                        .scaledToFit()
                        .frame(height: min(heroSize, 220))
                        .accessibilityHidden(true)

                    Text(step.title)
                        .font(.dmSans(.semibold, fixedSize: min(titleSize, 30)))
                        .tracking(-0.3)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.tripTextPrimary)
                        .lineLimit(4)
                        .minimumScaleFactor(0.7)
                        .accessibilityAddTraits(.isHeader)

                    if let subtitle = step.subtitle {
                        Text(subtitle)
                            .font(.dmSans(.regular, fixedSize: min(subtitleSize, 19)))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color.tripTextSecondary)
                            .lineSpacing(2)
                            .minimumScaleFactor(0.7)
                            .lineLimit(5)
                    }

                    if let reservation = step.reservation {
                        ReservationCard(detail: reservation, accent: step.accent)
                            .padding(.top, 4)
                    }

                    VStack(spacing: 10) {
                        ForEach(Array(step.ctas.enumerated()), id: \.offset) { _, cta in
                            CTAButton(cta: cta, accent: step.accent)
                        }
                    }
                    .padding(.top, 4)
                }

                Spacer()

                NavBar(
                    isFirst: currentIndex == 0,
                    isLast: currentIndex == totalCount - 1,
                    dotPosition: dayPosition,
                    dotCount: dayPeers.count,
                    onBack: onBack,
                    onNext: onNext,
                    accent: step.accent
                )
                .padding(.bottom, 4)
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 28)
        }
    }
}

#Preview("Reservation step (Blue Box)") {
    StepView(
        step: Trip.day2[0],
        currentIndex: 9,
        totalCount: 31,
        onBack: {},
        onNext: {}
    )
}

#Preview("Two-CTA step (Central Park)") {
    StepView(
        step: Trip.day2[4],
        currentIndex: 13,
        totalCount: 31,
        onBack: {},
        onNext: {}
    )
}

#Preview("Drive step (Day 1 start)") {
    StepView(
        step: Trip.day1[0],
        currentIndex: 1,
        totalCount: 31,
        onBack: {},
        onNext: {}
    )
}
