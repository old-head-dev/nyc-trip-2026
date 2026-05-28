import SwiftUI

struct NavBar: View {
    let isFirst: Bool
    let isLast: Bool
    let dotPosition: Int      // 0-based position of the active dot within the current day
    let dotCount: Int         // number of dots to render (= steps in the current day)
    let onBack: () -> Void
    let onNext: () -> Void
    let accent: Color

    private let maxDots = 8

    var body: some View {
        HStack {
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color.tripTextPrimary)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle().fill(Color.tripTextPrimary.opacity(0.08))
                    )
            }
            .opacity(isFirst ? 0 : 1)
            .disabled(isFirst)

            Spacer()

            HStack(spacing: 5) {
                let renderedCount = min(dotCount, maxDots)
                let activeDot = min(dotPosition, renderedCount - 1)
                ForEach(0..<renderedCount, id: \.self) { i in
                    Capsule()
                        .fill(i == activeDot ? accent : Color.tripTextPrimary.opacity(0.18))
                        .frame(width: i == activeDot ? 18 : 5, height: 5)
                }
            }

            Spacer()

            Button(action: onNext) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color.tripTextPrimary)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle().fill(Color.tripTextPrimary.opacity(0.08))
                    )
            }
            .opacity(isLast ? 0 : 1)
            .disabled(isLast)
        }
    }
}

#Preview {
    NavBar(
        isFirst: false,
        isLast: false,
        dotPosition: 2,
        dotCount: 8,
        onBack: {},
        onNext: {},
        accent: Color(hex: "#4d6a82")
    )
    .padding()
    .background(Color(hex: "#d8dfe5"))
}
