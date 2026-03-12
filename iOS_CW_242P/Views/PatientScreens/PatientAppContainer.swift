//
//  PatientAppContainer.swift
//  iOS_CW_242P
//
//  Created by Pubudu Perera on 2026-02-25.
//
import SwiftUI

struct PatientAppContainer: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem { Label("Home", systemImage: "house.fill") }
                .tag(0)

            MyBookingsView(directCall: true)
                .tabItem { Label("Bookings", systemImage: "calendar.badge.plus") }
                .tag(1)
            
            //Indoor Navigation View
            IndoorNavigationView()
                .tabItem {
                    Label("Map", systemImage: "map.fill")
                }
                .tag(2)

            NotificationView()
                .tabItem { Label("Notifications", systemImage: "bell.fill") }
                .tag(3)

            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.fill") }
                .tag(4)
        }
        .accentColor(.blue)
    }
}

#Preview {
    PatientAppContainer()
        .environmentObject(AuthViewModel())
}
