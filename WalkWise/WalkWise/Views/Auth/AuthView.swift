import SwiftUI

struct AuthView: View {
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        GradientBackgroundView {
            VStack(spacing: 24) {
                Spacer()
                VStack(spacing: 8) {
                    Image(systemName: "figure.walk.circle")
                        .resizable().scaledToFit().frame(width: 72, height: 72)
                        .foregroundStyle(.teal)
                    Text("WalkWise").font(.largeTitle).bold()
                    Text("Build a better walking habit.")
                        .foregroundStyle(.secondary)
                }
                VStack(spacing: 12) {
                    Button(action: { authVM.signInWithApple() }) {
                        HStack { Image(systemName: "apple.logo"); Text("Continue with Apple").bold() }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.black)
                            .foregroundStyle(.white)
                            .cornerRadius(12)
                    }
                    Button(action: { authVM.signInWithGoogle() }) {
                        HStack { Image(systemName: "envelope"); Text("Continue with Google").bold() }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.9))
                            .foregroundStyle(.white)
                            .cornerRadius(12)
                    }
                    if let err = authVM.errorMessage {
                        Text(err).font(.footnote).foregroundStyle(.red)
                    }
                }.padding(.horizontal)
                Spacer()
            }
        }
    }
}
