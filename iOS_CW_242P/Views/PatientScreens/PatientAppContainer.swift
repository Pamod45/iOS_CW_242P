import SwiftUI

struct PatientAppContainer: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedTab = 0

    // Determine active role from currentUser
    private var isPharmacist: Bool {
        authViewModel.currentUser?.role == .pharmacist
    }

    var body: some View {
        TabView(selection: $selectedTab) {

            // MARK: Home tab — switches based on active role
            Group {
                if isPharmacist {
                    NavigationView { PharmacistDashboardView() }
                } else {
                    NavigationView { DashboardView() }
                }
            }
            .tabItem {
                Label("Home", systemImage: isPharmacist ? "cross.case.fill" : "house.fill")
            }
            .tag(0)

            // MARK: Patient-only tabs — hidden when in pharmacist role
            if !isPharmacist {
                NavigationView { CheckInView() }
                    .tabItem { Label("Check-In", systemImage: "calendar.badge.plus") }
                    .tag(1)

                NavigationView { Text("Map View") }
                    .tabItem { Label("Map", systemImage: "map.fill") }
                    .tag(2)

                NavigationView { NotificationView() }
                    .tabItem { Label("Notifications", systemImage: "bell.fill") }
                    .tag(3)
            }

            // MARK: Profile tab — always visible
            NavigationView { ProfileView() }
                .tabItem { Label("Profile", systemImage: "person.fill") }
                .tag(4)
        }
        .environmentObject(authViewModel)
        .accentColor(isPharmacist ? Color(hex: "#3B82F6") : .blue)
        // Reset to tab 0 when role changes so we never land on a hidden tab
        .onChange(of: authViewModel.currentUser?.role) { _ in
            selectedTab = 0
        }
    }
}

#Preview {
    PatientAppContainer()
        .environmentObject(AuthViewModel())
}
