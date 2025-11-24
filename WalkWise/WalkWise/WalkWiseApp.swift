//
//  WalkWiseApp.swift
//  WalkWise
//
//  Created by IM Student on 2025-11-11.
//

import SwiftUI

@main
struct WalkWiseApp: App {
    // Core Data stack
    private let persistence = PersistenceController.shared

    // App-wide view models
    @StateObject private var authVM = AuthViewModel()
    @StateObject private var healthVM = HealthViewModel()
    @StateObject private var sessionVM = SessionViewModel()
    @StateObject private var profileVM = ProfileViewModel()

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environment(\.managedObjectContext, persistence.context)
                .environmentObject(authVM)
                .environmentObject(healthVM)
                .environmentObject(sessionVM)
                .environmentObject(profileVM)
        }
    }
}
