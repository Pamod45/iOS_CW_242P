//
//  iOS_CW_242PApp.swift
//  iOS_CW_242P
//
//  Created by Pubudu Perera on 2026-02-23.
//

import SwiftUI

@main
struct iOS_CW_242PApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            if authViewModel.isAuthenticated, let user = authViewModel.currentUser {
                let _ = print("[Info] Routing user  Role: \(user.role.rawValue)")
                switch user.role {
                    case .patient:
                        let _ = print("   Directing to patient dashboard")
                    case .pharmacist:
                        let _ = print("   Directing to Pharmacist dashboard")
                }
            } else {
                let _ = print("   Not authenticated directing to LoginView")
                LoginView().environmentObject(authViewModel)
            }
        }
    }
}
