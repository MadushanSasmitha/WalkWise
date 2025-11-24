import SwiftUI

struct GradientBackgroundView<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) { self.content = content() }

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(.sRGB, red: 0.66, green: 0.9, blue: 0.82, opacity: 1),
                    Color(.sRGB, red: 0.86, green: 0.92, blue: 0.98, opacity: 1)
                ]),
                startPoint: .topLeading, endPoint: .bottomTrailing
            ).ignoresSafeArea()
            content
        }
    }
}
