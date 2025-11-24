import Foundation
import AuthenticationServices
import SwiftUI
import CoreData
import UIKit
import Combine

// AuthViewModel coordinates auth state and basic profile linkage.
// - Sign in with Apple is implemented using ASAuthorizationController.
// - Google Sign-In/Firebase is stubbed with clear comments for configuration.
@MainActor
final class AuthViewModel: NSObject, ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var userProfile: UserProfile?
    @Published var errorMessage: String?

    private let persistence = PersistenceController.shared

    // Simple persisted flag for demo/assignment
    @AppStorage("WalkWise_IsLoggedIn") private var storedLoggedIn: Bool = false

    override init() {
        super.init()
        isLoggedIn = storedLoggedIn
    }

    // MARK: - Apple Sign-In
    func signInWithApple() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }

    // MARK: - Google Sign-In (Stub)
    func signInWithGoogle() {
        // To enable:
        // 1) Add Firebase SDK and GoogleSignIn SDK via Swift Package Manager.
        // 2) Configure GoogleService-Info.plist and URL types in the target.
        // 3) Use GIDSignIn.sharedInstance.signIn(withPresenting:) and update isLoggedIn on success.
        // For the assignment, we simulate a successful sign-in:
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.finishLogin(displayName: "WalkWise User", email: "user@gmail.com")
        }
    }

    func logOut() {
        // Attempt provider sign-outs here (Apple has no persistent session, Google/Firebase signOut may be called).
        isLoggedIn = false
        storedLoggedIn = false
        deleteLocalProfileOnly()
    }

    func deleteAccount() {
        // 1) Attempt provider account deletion if applicable (Firebase delete).
        // 2) Clear local Core Data for privacy.
        deleteAllLocalData()
        isLoggedIn = false
        storedLoggedIn = false
    }

    // MARK: - Helpers
    private func finishLogin(displayName: String?, email: String?) {
        let ctx = persistence.context
        let profile = fetchOrCreateProfile(in: ctx, name: displayName ?? "", email: email ?? "")
        userProfile = profile
        isLoggedIn = true
        storedLoggedIn = true
        persistence.save()
    }

    private func fetchOrCreateProfile(in context: NSManagedObjectContext, name: String, email: String) -> UserProfile {
        let request = NSFetchRequest<UserProfile>(entityName: "UserProfile")
        request.fetchLimit = 1
        if let existing = try? context.fetch(request).first { return existing }

        let p = UserProfile(entity: NSEntityDescription.entity(forEntityName: "UserProfile", in: context)!, insertInto: context)
        p.id = UUID()
        p.displayName = name.isEmpty ? "Walker" : name
        p.email = email
        p.dailyStepGoal = 8000
        p.units = "km"
        p.createdAt = Date()
        return p
    }

    private func deleteLocalProfileOnly() {
        let ctx = persistence.context
        let req1 = NSFetchRequest<UserProfile>(entityName: "UserProfile")
        if let profiles = try? ctx.fetch(req1) { profiles.forEach { ctx.delete($0) } }
        persistence.save()
        userProfile = nil
    }

    private func deleteAllLocalData() {
        let ctx = persistence.context
        ["UserProfile", "WalkSession", "DailySummary"].forEach { name in
            let fr = NSFetchRequest<NSFetchRequestResult>(entityName: name)
            let batch = NSBatchDeleteRequest(fetchRequest: fr)
            _ = try? ctx.execute(batch)
        }
        persistence.save()
        userProfile = nil
    }
}

// MARK: - ASAuthorizationControllerDelegate & Presentation
extension AuthViewModel: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleID as ASAuthorizationAppleIDCredential:
            let fullName = [appleID.fullName?.givenName, appleID.fullName?.familyName].compactMap { $0 }.joined(separator: " ")
            let email = appleID.email // Only available first time
            finishLogin(displayName: fullName.isEmpty ? "Apple User" : fullName, email: email ?? "")
        default:
            break
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.errorMessage = error.localizedDescription
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        // Find the key window safely on iOS 17+
        let window = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
        return window ?? ASPresentationAnchor()
    }
}
