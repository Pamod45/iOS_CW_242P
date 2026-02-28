import SwiftUI

struct ProfileView: View {
    
    // MARK: - Environment & State
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showEditProfile = false
    @State private var showLogoutAlert = false
    
    // MARK: - Computed Properties from currentUser
    private var displayName: String {
        authViewModel.currentUser?.name ?? "Unknown"
    }
    
    private var displayEmail: String {
        authViewModel.currentUser?.email ?? "No email provided"
    }
    
    private var displayPhone: String {
        authViewModel.currentUser?.telephone ?? authViewModel.currentUser?.phoneNumber ?? "Not provided"
    }
    
    private var displayAddress: String {
        authViewModel.currentUser?.address ?? "Not provided"
    }
    
    private var displayRole: String {
        authViewModel.currentUser?.role.rawValue ?? "Patient"
    }
    
    private var avatarLetter: String {
        String(displayName.prefix(1)).uppercased()
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // MARK: - Avatar Section
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(Color(hex: "#8B5CF6"))
                                .frame(width: 80, height: 80)
                            Text(avatarLetter)
                                .font(.system(size: 36, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        
                        Text(displayName)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                        
                        Text(displayEmail)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        // Role Badge
                        Text(displayRole)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(hex: "#8B5CF6"))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(Color(hex: "#8B5CF6").opacity(0.12))
                            .cornerRadius(20)
                    }
                    .padding(.top, 20)
                    
                    // MARK: - Info Cards
                    VStack(spacing: 12) {
                        ProfileInfoRow(icon: "person", label: "Name", value: displayName)
                        ProfileInfoRow(icon: "phone", label: "Telephone", value: displayPhone)
                        ProfileInfoRow(icon: "mappin.and.ellipse", label: "Address", value: displayAddress)
                        ProfileInfoRow(icon: "envelope", label: "Email", value: displayEmail)
                    }
                    .padding(.horizontal, 16)
                    
                    // MARK: - Edit Profile Button
                    Button(action: {
                        showEditProfile = true
                    }) {
                        Text("Edit Profile")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color(hex: "#3B82F6"))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 16)
                    
                    // MARK: - Settings Section
                    VStack(spacing: 0) {
                        NavigationLink(destination: Text("Change Password Screen")) {
                            HStack {
                                Image(systemName: "lock.rotation")
                                    .foregroundColor(Color(hex: "#3B82F6"))
                                    .frame(width: 24)
                                Text("Change Password")
                                    .font(.system(size: 15))
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 13))
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 16)
                        }
                        
                        Divider()
                            .padding(.horizontal, 16)
                        
                        // MARK: - Logout
                        Button(action: {
                            showLogoutAlert = true
                        }) {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .foregroundColor(.red)
                                    .frame(width: 24)
                                Text("Logout")
                                    .font(.system(size: 15))
                                    .foregroundColor(.red)
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 16)
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(12)
                    .padding(.horizontal, 16)
                    
                    Spacer(minLength: 40)
                }
            }
            .background(Color(hex: "#F3F4F6"))
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .overlay {
                if authViewModel.isLoading {
                    ZStack {
                        Color.black.opacity(0.2).ignoresSafeArea()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.5)
                    }
                }
            }
        }
        // MARK: - Edit Profile Sheet
        .sheet(isPresented: $showEditProfile) {
            EditProfileView()
                .environmentObject(authViewModel)
        }
        // MARK: - Logout Confirmation Alert
        .alert("Logout", isPresented: $showLogoutAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Logout", role: .destructive) {
                authViewModel.signOut()
            }
        } message: {
            Text("Are you sure you want to logout?")
        }
    }
}

// MARK: - Edit Profile Sheet View
struct EditProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var address: String = ""
    @State private var telephone: String = ""
    @State private var showSuccess = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Avatar Preview
                    ZStack {
                        Circle()
                            .fill(Color(hex: "#8B5CF6"))
                            .frame(width: 80, height: 80)
                        Text(String(name.prefix(1)).uppercased())
                            .font(.system(size: 36, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 14) {
                        EditField(icon: "person", placeholder: "Name", text: $name)
                        EditField(icon: "envelope", placeholder: "Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        EditField(icon: "mappin.and.ellipse", placeholder: "Address", text: $address)
                        EditField(icon: "phone", placeholder: "Telephone", text: $telephone)
                            .keyboardType(.phonePad)
                    }
                    .padding(.horizontal, 16)
                    
                    Button(action: saveProfile) {
                        if authViewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color(hex: "#3B82F6"))
                                .cornerRadius(12)
                        } else {
                            Text("Save Changes")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color(hex: "#3B82F6"))
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 16)
                    .disabled(authViewModel.isLoading || name.isEmpty)
                }
            }
            .background(Color(hex: "#F3F4F6"))
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(Color(hex: "#3B82F6"))
                }
            }
            .onAppear(perform: populateFields)
            .alert("Success", isPresented: $showSuccess) {
                Button("OK") { dismiss() }
            } message: {
                Text("Your profile has been updated successfully.")
            }
        }
    }
    
    private func populateFields() {
        name      = authViewModel.currentUser?.name ?? ""
        email     = authViewModel.currentUser?.email ?? ""
        address   = authViewModel.currentUser?.address ?? ""
        telephone = authViewModel.currentUser?.telephone
                    ?? authViewModel.currentUser?.phoneNumber
                    ?? ""
    }
    
    private func saveProfile() {
        authViewModel.updateProfile(
            name: name,
            email: email.isEmpty ? nil : email,
            age: nil,
            address: address.isEmpty ? nil : address,
            telephone: telephone.isEmpty ? nil : telephone
        ) { success in
            if success { showSuccess = true }
        }
    }
}

// MARK: - Reusable Edit Field Component
struct EditField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 22)
            TextField(placeholder, text: $text)
                .font(.system(size: 15))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.white)
        .cornerRadius(12)
    }
}

// MARK: - Profile Info Row Component
struct ProfileInfoRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 22, height: 22)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
                Text(value)
                    .font(.system(size: 15))
                    .foregroundColor(.black)
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.white)
        .cornerRadius(12)
    }
}

// MARK: - Hex Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Preview
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = AuthViewModel()
        ProfileView()
            .environmentObject(vm)
    }
}
