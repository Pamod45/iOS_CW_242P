import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var isEditing = false
    @State private var editName: String          = ""
    @State private var editEmail: String         = ""
    @State private var editPhone: String         = ""
    @State private var editRole: UserRole        = .patient
    @State private var editPharmacistID: String  = ""
    @State private var editNIC: String           = ""
    
    @State private var showLogoutAlert          = false
    @State private var showSaveSuccess          = false
    @State private var showProfileChangeAlert   = false
    
    @State private var pendingRole: UserRole?        = nil
    @State private var navigateToPatientDashboard    = false
    @State private var navigateToPharmacistDashboard = false
    
    private var displayName: String {
        authViewModel.currentUser?.name.isEmpty == false
            ? authViewModel.currentUser!.name
            : "New User"
    }
    private var displayEmail: String {
        let email = authViewModel.currentUser?.email
        return email?.isEmpty == false ? email! : "Not Set"
    }
    private var displayPhone: String {
        let phone = authViewModel.currentUser?.telephone
                    ?? authViewModel.currentUser?.phoneNumber
        return phone?.isEmpty == false ? phone! : "Not Set"
    }
    private var displayPharmacistID: String {
        authViewModel.currentUser?.pharmacistID?.isEmpty == false
            ? authViewModel.currentUser!.pharmacistID!
            : "Not Set"
    }
    private var displayNIC: String {
        authViewModel.currentUser?.nic?.isEmpty == false
            ? authViewModel.currentUser!.nic!
            : "Not Set"
    }
    private var avatarLetter: String {
        String(displayName.prefix(1)).uppercased()
    }
    
    private var completedFields: Int {
        var count = 0
        if !(authViewModel.currentUser?.name.isEmpty ?? true) { count += 1 }
        if authViewModel.currentUser?.email?.isEmpty == false { count += 1 }
        if (authViewModel.currentUser?.telephone?.isEmpty == false ||
            authViewModel.currentUser?.phoneNumber?.isEmpty == false) { count += 1 }
        return count
    }
    private var totalFields: Int { 3 }
    private var isProfileComplete: Bool { completedFields >= totalFields }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    
                    if authViewModel.currentUser?.roles.contains(.pharmacist) == true {
                        Picker(
                            "UserRole",
                            selection: Binding(
                                get: { editRole },
                                set: { newRole in
                                    guard newRole != editRole else { return }
                                    pendingRole = newRole
                                    showProfileChangeAlert = true
                                }
                            )
                        ) {
                            Text("Pharmacist").tag(UserRole.pharmacist)
                            Text("Patient").tag(UserRole.patient)
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                    }
                    
                    VStack(spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .frame(width: 74, height: 74)
                                .overlay(
                                    Text(getInitials())
                                        .font(.headline)
                                        .foregroundColor(.white)
                                )
                        }
                        
                        Text(isEditing
                             ? (editName.isEmpty ? "Your Name" : editName)
                             : displayName)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.black)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    
                    if !isProfileComplete {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 6) {
                                Image(systemName: "info.circle")
                                    .foregroundColor(Color(hex: "#3B82F6"))
                                Text("Complete Profile")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(Color(hex: "#3B82F6"))
                            }
                            
                            Text("\(completedFields) OF \(totalFields) COMPLETE")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(Color(hex: "#3B82F6"))
                                .kerning(0.5)
                            
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color(hex: "#3B82F6").opacity(0.15))
                                        .frame(height: 6)
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color(hex: "#3B82F6"))
                                        .frame(width: geo.size.width * CGFloat(completedFields) / CGFloat(totalFields), height: 6)
                                }
                            }
                            .frame(height: 6)
                            
                            Text("Adding the remaining details will help avoid delays during appointments and lab visits.")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(16)
                        .background(Color(hex: "#EFF6FF"))
                        .cornerRadius(12)
                        .padding(.horizontal, 16)
                    }
                    
                    VStack(spacing: 12) {
                        if isEditing {
                            EditableInfoRow(
                                icon: "person",
                                label: "Name",
                                value: $editName,
                                keyboardType: .default
                            )
                            EditableInfoRow(
                                icon: "creditcard",
                                label: "NIC (National Identity Card)",
                                value: $editNIC,
                                keyboardType: .default
                            )
                            EditableInfoRow(
                                icon: "envelope",
                                label: "Email Address",
                                value: $editEmail,
                                keyboardType: .emailAddress
                            )
                            EditableInfoRow(
                                icon: "phone",
                                label: "Telephone",
                                value: $editPhone,
                                keyboardType: .phonePad
                            )
                            if editRole == .pharmacist {
                                EditableInfoRow(
                                    icon: "cross.case",
                                    label: "Pharmacist ID",
                                    value: $editPharmacistID,
                                    keyboardType: .default
                                )
                                .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                        } else {
                            ProfileInfoRow(icon: "person",     label: "Name",                         value: displayName)
                            ProfileInfoRow(icon: "creditcard", label: "NIC (National Identity Card)", value: displayNIC)
                            ProfileInfoRow(icon: "envelope",   label: "Email Address",                value: displayEmail)
                            ProfileInfoRow(icon: "phone",      label: "Telephone",                    value: displayPhone)
                            if editRole == .pharmacist {
                                ProfileInfoRow(icon: "cross.case", label: "Pharmacist ID", value: displayPharmacistID)
                                    .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .animation(.easeInOut(duration: 0.22), value: isEditing)
                    
                    if isEditing {
                        HStack(spacing: 12) {
                            SecondaryButton(title: "Cancel", action: cancelEditing)
                            PrimaryButton(
                                title: "Save Profile",
                                action: handleEditSave,
                                isLoading: authViewModel.isLoading
                            )
                        }
                        .padding(.horizontal, 16)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    } else {
                        PrimaryButton(title: "Edit Profile", action: handleEditSave)
                            .padding(.horizontal, 16)
                    }
                    
                    VStack(spacing: 0) {
                        Button(action: { showLogoutAlert = true }) {
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
            .background(Color(.systemGroupedBackground))
            .navigationTitle("My Profile")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear { syncEditFields() }
            .onChange(of: authViewModel.currentUser?.name)         { _ in syncEditFields() }
            .onChange(of: authViewModel.currentUser?.email)        { _ in syncEditFields() }
            .onChange(of: authViewModel.currentUser?.telephone)    { _ in syncEditFields() }
            .onChange(of: authViewModel.currentUser?.pharmacistID) { _ in syncEditFields() }
            .onChange(of: authViewModel.currentUser?.nic)          { _ in syncEditFields() }
            .alert("Logout", isPresented: $showLogoutAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Logout", role: .destructive) {
                    authViewModel.signOut()
                }
            } message: {
                Text("Are you sure you want to logout?")
            }
            .alert("Profile Updated", isPresented: $showSaveSuccess) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Your profile has been saved successfully.")
            }
            .alert("ProfileChanged", isPresented: $showProfileChangeAlert) {
                Button("Yes", role: .destructive) {
                    if let role = pendingRole {
                        editRole = role
                        if role == .patient { editPharmacistID = "" }
                    }
                    pendingRole = nil
                    if pendingRole == .patient {
                        navigateToPatientDashboard = true
                    } else {
                        navigateToPharmacistDashboard = true
                    }
                }
                Button("No", role: .cancel) {
                    pendingRole = nil
                }
            } message: {
                Text("Are you sure you want to switch your profile?")
            }
            .overlay {
                if authViewModel.isLoading {
                    ZStack {
                        Color.black.opacity(0.25).ignoresSafeArea()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.5)
                    }
                }
            }
        }
        .background {
            NavigationLink(
                destination: DashboardView(),
                isActive: $navigateToPatientDashboard
            ) { EmptyView() }
            
            NavigationLink(
                destination: Text("Pharmacist dashboard not implemented yet"),
                isActive: $navigateToPharmacistDashboard
            ) { EmptyView() }
        }
    }
    
    private func syncEditFields() {
        editName         = authViewModel.currentUser?.name ?? ""
        editEmail        = authViewModel.currentUser?.email ?? ""
        editPhone        = authViewModel.currentUser?.telephone
                           ?? authViewModel.currentUser?.phoneNumber
                           ?? ""
        editRole         = authViewModel.currentUser?.role ?? .patient
        editPharmacistID = authViewModel.currentUser?.pharmacistID ?? ""
        editNIC          = authViewModel.currentUser?.nic ?? ""
    }
    
    private func handleEditSave() {
        if isEditing {
            guard !editName.trimmingCharacters(in: .whitespaces).isEmpty else { return }
            withAnimation { isEditing = false }
            authViewModel.updateProfile(
                name: editName.trimmingCharacters(in: .whitespaces),
                email: editEmail.trimmingCharacters(in: .whitespaces).isEmpty
                    ? nil : editEmail.trimmingCharacters(in: .whitespaces),
                age: nil,
                address: nil,
                telephone: editPhone.trimmingCharacters(in: .whitespaces).isEmpty
                    ? nil : editPhone.trimmingCharacters(in: .whitespaces),
                pharmacistID: editPharmacistID.trimmingCharacters(in: .whitespaces).isEmpty
                    ? nil : editPharmacistID.trimmingCharacters(in: .whitespaces),
                nic: editNIC.trimmingCharacters(in: .whitespaces).isEmpty
                    ? nil : editNIC.trimmingCharacters(in: .whitespaces)
            ) { success in
                if success { showSaveSuccess = true }
            }
        } else {
            syncEditFields()
            withAnimation { isEditing = true }
        }
    }
    
    private func cancelEditing() {
        syncEditFields()
        withAnimation { isEditing = false }
    }
    
    private func getInitials() -> String {
        let name = authViewModel.currentUser?.name ?? "U"
        let components = name.split(separator: " ")
        if components.count >= 2 {
            return String(components[0].prefix(1) + components[1].prefix(1)).uppercased()
        } else {
            return String(name.prefix(1)).uppercased()
        }
    }
}

enum ValidationState { case none, valid, invalid }

struct PasswordField: View {
    let label: String
    let icon: String
    let placeholder: String
    @Binding var text: String
    @Binding var isVisible: Bool
    var validationState: ValidationState = .none
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.gray)
                .padding(.leading, 4)
            
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundColor(.gray)
                    .frame(width: 22)
                
                if isVisible {
                    TextField(placeholder, text: $text)
                        .font(.system(size: 15))
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                } else {
                    SecureField(placeholder, text: $text)
                        .font(.system(size: 15))
                }
                
                if validationState != .none {
                    Image(systemName: validationState == .valid
                          ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(validationState == .valid ? .green : .red)
                        .font(.system(size: 16))
                }
                
                Button(action: { isVisible.toggle() }) {
                    Image(systemName: isVisible ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                        .font(.system(size: 15))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        validationState == .valid   ? Color.green :
                        validationState == .invalid ? Color.red   : Color.clear,
                        lineWidth: 1.5
                    )
            )
        }
    }
}

struct RoleToggleRow: View {
    @Binding var selectedRole: UserRole

    var body: some View {
        HStack(spacing: 0) {
            roleButton(title: "Patient",    icon: "person.fill",     role: .patient)
            roleButton(title: "Pharmacist", icon: "cross.case.fill", role: .pharmacist)
        }
        .background(Color(hex: "#F3F4F6"))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(hex: "#3B82F6").opacity(0.3), lineWidth: 1.5)
        )
    }

    @ViewBuilder
    private func roleButton(title: String, icon: String, role: UserRole) -> some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedRole = role
            }
        }) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 13, weight: .medium))
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
            }
            .foregroundColor(selectedRole == role ? .white : Color(hex: "#3B82F6"))
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(
                selectedRole == role
                    ? Color(hex: "#3B82F6")
                    : Color.clear
            )
            .cornerRadius(selectedRole == role ? 11 : 0)
            .padding(selectedRole == role ? 2 : 0)
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:  (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:  (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:  (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red:     Double(r) / 255,
            green:   Double(g) / 255,
            blue:    Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(AuthViewModel())
    }
}
