import SwiftUI

@main
struct iOS_CW_242PApp: App {
    @StateObject private var authViewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            if authViewModel.isAuthenticated, let user = authViewModel.currentUser {
                let _ = print("[Info] Routing user — Name: \(user.name), activeRole: \(authViewModel.activeRole.rawValue)")

                switch authViewModel.activeRole {
                case .patient:
                    PatientAppContainer()
                        .environmentObject(authViewModel)
                        .id("patient")

                case .pharmacist:
                    let _ = print("[Info] Directing to Pharmacist dashboard")
                    PharmacistAppContainer()
                        .environmentObject(authViewModel)
                        .id("pharmacist")
                }
            } else {
                let _ = print("[Info] Not authenticated — directing to LoginView")
                LoginView()
                    .environmentObject(authViewModel)
            }
        }
    }
}
