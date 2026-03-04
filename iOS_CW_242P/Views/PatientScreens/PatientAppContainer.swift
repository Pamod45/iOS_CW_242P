//
//  AppContainer.swift
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
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            CheckInView()
                .tabItem {
                    Label("Check-In", systemImage: "calendar.badge.plus")
                }
                .tag(1)
            
            Text("Map View")
                .tabItem {
                    Label("Map", systemImage: "map.fill")
                }
                .tag(2)
            
            NotificationView()
                .tabItem {
                        Label("Notifications", systemImage: "bell.fill")
                    }
                    .tag(3)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(4)
        }
        .environmentObject(authViewModel)
        .accentColor(.blue)
    }
}

#Preview {
    PatientAppContainer()
        .environmentObject(AuthViewModel())
}
