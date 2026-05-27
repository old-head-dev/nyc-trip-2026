import SwiftUI

struct ReservationCard: View {
    let detail: ReservationDetail
    let accent: Color

    @State private var didCopy = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Circle().fill(accent).frame(width: 6, height: 6)
                Text(detail.time)
                    .font(.dmSans(.semibold, size: 13))
                    .foregroundStyle(Color.tripTextPrimary)
            }
            Text(detail.address)
                .font(.dmSans(.regular, size: 13))
                .foregroundStyle(Color.tripTextSecondary)
            if let conf = detail.confirmation {
                Button {
                    UIPasteboard.general.string = conf
                    didCopy = true
                    let haptic = UIImpactFeedbackGenerator(style: .soft)
                    haptic.impactOccurred()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { didCopy = false }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: didCopy ? "checkmark" : "doc.on.doc")
                            .font(.system(size: 11, weight: .semibold))
                        Text(didCopy ? "Copied" : conf)
                            .font(.dmSans(.medium, size: 12))
                    }
                    .foregroundStyle(accent)
                }
            }
            if let extra = detail.extra {
                Text(extra)
                    .font(.dmSans(.regular, size: 12))
                    .foregroundStyle(Color.tripTextSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.white.opacity(0.85))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(accent.opacity(0.18), lineWidth: 1)
        )
    }
}

#Preview {
    ReservationCard(
        detail: ReservationDetail(
            time: "10:00 AM",
            address: "727 5th Ave, 5th Floor",
            confirmation: "#351207910",
            extra: "Breakfast for 2"
        ),
        accent: Color(hex: "#8a6f3a")
    )
    .padding()
    .background(Color(hex: "#f8eedd"))
}
