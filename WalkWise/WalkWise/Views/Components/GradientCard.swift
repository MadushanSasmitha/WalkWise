import SwiftUI

struct GradientCard<Content: View>: View {
    let colors: [Color]
    let content: Content
    init(colors: [Color], @ViewBuilder content: () -> Content) {
        self.colors = colors
        self.content = content()
    }
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 6)
            content
                .padding()
        }
    }
}
