import SwiftUI

struct AppRootView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var healthVM: HealthViewModel
    @EnvironmentObject var profileVM: ProfileViewModel

    @State private var showingSplash = true

    var body: some View {
        Group {
            if showingSplash {
                SplashView {
                    Task { await initializeAndRoute() }
                }
            } else {
                if authVM.isLoggedIn {
                    MainTabView()
                } else {
                    AuthView()
                }
            }
        }
        .onAppear {
            // Preload profile if any for greeting
            profileVM.loadOrCreateProfile(defaultEmail: authVM.userProfile?.email)
        }
    }

    private func initializeAndRoute() async {
        await healthVM.initialize()
        // Small delay to allow splash animation to feel smooth
        try? await Task.sleep(nanoseconds: 300_000_000)
        withAnimation { showingSplash = false }
    }
}
