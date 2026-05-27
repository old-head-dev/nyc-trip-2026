import SwiftUI

struct NavBar: View {
    let currentIndex: Int
    let totalCount: Int
    let onBack: () -> Void
    let onNext: () -> Void
    let accent: Color

    var isFirst: Bool { currentIndex == 0 }
    var isLast: Bool { currentIndex == totalCount - 1 }

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
                ForEach(0..<min(totalCount, 8), id: \.self) { i in
                    Capsule()
                        .fill(i == min(currentIndex, 7) ? accent : Color.tripTextPrimary.opacity(0.18))
                        .frame(width: i == min(currentIndex, 7) ? 18 : 5, height: 5)
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
        currentIndex: 2,
        totalCount: 8,
        onBack: {},
        onNext: {},
        accent: Color(hex: "#4d6a82")
    )
    .padding()
    .background(Color(hex: "#d8dfe5"))
}
