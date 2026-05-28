import SwiftUI

struct TripView: View {
    @AppStorage("lastStepIndex") private var lastStepIndex: Int = 0
    @State private var currentIndex: Int = 0

    private let steps = Trip.allSteps
    private var totalCount: Int { steps.count }

    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(Array(steps.enumerated()), id: \.element.id) { index, step in
                page(for: step, index: index)
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .ignoresSafeArea()
        .onAppear {
            currentIndex = clampedRestoreIndex()
        }
        .onChange(of: currentIndex) { _, newValue in
            lastStepIndex = newValue
        }
    }

    @ViewBuilder
    private func page(for step: Step, index: Int) -> some View {
        switch step.day {
        case 0:
            WelcomeView(step: step, totalCount: totalCount, onBegin: advance)
        case 5:
            ClosingView(step: step, onBack: retreat)
        default:
            StepView(
                step: step,
                currentIndex: index,
                totalCount: totalCount,
                onBack: retreat,
                onNext: advance
            )
        }
    }

    private func advance() {
        guard currentIndex < totalCount - 1 else { return }
        withAnimation(.easeInOut(duration: 0.28)) {
            currentIndex += 1
        }
    }

    private func retreat() {
        guard currentIndex > 0 else { return }
        withAnimation(.easeInOut(duration: 0.28)) {
            currentIndex -= 1
        }
    }

    private func clampedRestoreIndex() -> Int {
        max(0, min(lastStepIndex, totalCount - 1))
    }
}

#Preview {
    TripView()
}
