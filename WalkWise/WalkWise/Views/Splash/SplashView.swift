import SwiftUI

struct SplashView: View {
    @State private var show = false
    let onFinished: () -> Void

    private let tips = [
        "Short walks add up. Aim for consistency.",
        "Swing your arms to increase pace naturally.",
        "Stay hydrated before and after your walk.",
        "Adjust your goal gradually each week.",
        "Good shoes make great walks."
    ]

    var body: some View {
        GradientBackgroundView {
            VStack(spacing: 24) {
                Spacer()
                VStack(spacing: 8) {
                    Image(systemName: "figure.walk")
                        .resizable().scaledToFit().frame(width: 64, height: 64)
                        .foregroundStyle(.teal)
                        .scaleEffect(show ? 1 : 0.9)
                        .animation(.spring(response: 0.6, dampingFraction: 0.7), value: show)
                    Text("WalkWise").font(.largeTitle).fontWeight(.bold)
                    Text("Your gentle walking companion")
                        .font(.subheadline).foregroundStyle(.secondary)
                }
                GradientCard(colors: [.white.opacity(0.6), .white.opacity(0.3)]) {
                    Text(tips.randomElement() ?? "Take a mindful step today.")
                        .font(.callout)
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)
                }.padding(.horizontal)
                Spacer()
                ProgressView().progressViewStyle(.circular)
                Spacer().frame(height: 20)
            }
        }
        .onAppear {
            show = true
            // Simulate initialization time; actual init done by App after this view appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                onFinished()
            }
        }
    }
}
