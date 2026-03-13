//
//  PharmacistAppContainer.swift
//  iOS_CW_242P
//
//  Created by Pubudu Perera on 2026-02-25.
//
import SwiftUI

struct PharmacistAppContainer: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            PharmacistDashboardView()
                 .tabItem { Label("Home", systemImage: "house.fill") }
                 .tag(0)
            
            NotificationView()
                .tabItem { Label("Notifications", systemImage: "bell.fill") }
                .tag(1)
            
            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.fill") }
                .tag(2)
        }
        .accentColor(.blue)
    }
}

#Preview {
    PharmacistAppContainer()
        .environmentObject(AuthViewModel())
}
