import SwiftUI

// MARK: - Profile View
struct ProfileView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    //Edit State
    @State private var isEditing = false
    @State private var editName: String    = ""
    @State private var editEmail: String   = ""
    @State private var editPhone: String   = ""
    @State private var editAddress: String       = ""
    @State private var editRole: UserRole        = .patient
    @State private var editPharmacistID: String  = ""
    
    //UI State
    @State private var showLogoutAlert          = false
    @State private var navigateToChangePassword = false
    @State private var showSaveSuccess          = false
    
    //Computed Properties — always read live from currentUser
    private var displayName: String {
        authViewModel.currentUser?.name.isEmpty == false
            ? authViewModel.currentUser!.name
            : "No Name"
    }
    private var displayEmail: String {
        authViewModel.currentUser?.email?.isEmpty == false
            ? authViewModel.currentUser!.email!
            : "No Email"
    }
    private var displayPhone: String {
        let phone = authViewModel.currentUser?.telephone
                    ?? authViewModel.currentUser?.phoneNumber
        return phone?.isEmpty == false ? phone! : "No Number"
    }
    private var displayAddress: String {
        authViewModel.currentUser?.address?.isEmpty == false
            ? authViewModel.currentUser!.address!
            : "No Address"
    }
    private var displayRole: String {
        authViewModel.currentUser?.role.rawValue ?? "Patient"
    }
    private var displayPharmacistID: String {
        authViewModel.currentUser?.pharmacistID?.isEmpty == false
            ? authViewModel.currentUser!.pharmacistID!
            : "No Pharmacist ID"
    }
    private var avatarLetter: String {
        String(displayName.prefix(1)).uppercased()
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    
                    //Avatar + Header
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(Color(hex: "#8B5CF6"))
                                .frame(width: 80, height: 80)
                            Text(isEditing
                                 ? (editName.isEmpty ? "?" : String(editName.prefix(1)).uppercased())
                                 : avatarLetter)
                                .font(.system(size: 36, weight: .semibold))
                                .foregroundColor(.white)
                                .animation(.easeInOut, value: editName)
                        }
                        
                        // Name updates live as user types in edit mode
                        Text(isEditing
                             ? (editName.isEmpty ? "Your Name" : editName)
                             : displayName)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                        
                        // Email updates live as user types in edit mode
                        Text(isEditing
                             ? (editEmail.isEmpty ? "your@email.com" : editEmail)
                             : displayEmail)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        // Role badge — updates live with toggle
                        Text(editRole.rawValue)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(hex: "#8B5CF6"))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(Color(hex: "#8B5CF6").opacity(0.12))
                            .cornerRadius(20)
                            .animation(.easeInOut(duration: 0.2), value: editRole)
                    }
                    .padding(.top, 20)
                    
                    //Role Toggle — always visible
                    RoleToggleRow(selectedRole: $editRole)
                        .padding(.horizontal, 16)
                    
                    //Info Fields (read-only ↔ editable)
                    VStack(spacing: 12) {
                        if isEditing {
                            //Editable fields pre-filled with current user data
                            EditableInfoRow(
                                icon: "person",
                                label: "Name",
                                value: $editName,
                                keyboardType: .default
                            )
                            EditableInfoRow(
                                icon: "phone",
                                label: "Telephone",
                                value: $editPhone,
                                keyboardType: .phonePad
                            )
                            EditableInfoRow(
                                icon: "mappin.and.ellipse",
                                label: "Address",
                                value: $editAddress,
                                keyboardType: .default
                            )
                            EditableInfoRow(
                                icon: "envelope",
                                label: "Email",
                                value: $editEmail,
                                keyboardType: .emailAddress
                            )
                            // Pharmacist ID — only shown when Pharmacist is selected
                            if editRole == .pharmacist {
                                EditableInfoRow(
                                    icon: "creditcard",
                                    label: "Pharmacist ID",
                                    value: $editPharmacistID,
                                    keyboardType: .default
                                )
                                .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                        } else {
                            //Read-only fields showing live currentUser data
                            ProfileInfoRow(icon: "person",             label: "Name",      value: displayName)
                            ProfileInfoRow(icon: "phone",              label: "Telephone", value: displayPhone)
                            ProfileInfoRow(icon: "mappin.and.ellipse", label: "Address",   value: displayAddress)
                            ProfileInfoRow(icon: "envelope",           label: "Email",     value: displayEmail)
                            if editRole == .pharmacist {
                                ProfileInfoRow(icon: "creditcard", label: "Pharmacist ID", value: displayPharmacistID)
                                    .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .animation(.easeInOut(duration: 0.22), value: isEditing)
                    
                    //Edit / Save + Cancel Buttons
                    if isEditing {
                        //Save + Cancel side by side (PrimaryButton + SecondaryButton style)
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
                        // Single Edit Profile button
                        PrimaryButton(title: "Edit Profile", action: handleEditSave)
                            .padding(.horizontal, 16)
                    }
                    
                    //Settings Section
                    VStack(spacing: 0) {
                        
                        //Hidden link for programmatic navigation
//                        NavigationLink(
//                            destination: ChangePasswordView(),
//                            isActive: $navigateToChangePassword
//                        ) { EmptyView() }
//                        
                        //Change Password row
//                        Button(action: { navigateToChangePassword = true }) {
//                            HStack {
//                                Image(systemName: "lock.rotation")
//                                    .foregroundColor(Color(hex: "#3B82F6"))
//                                    .frame(width: 24)
//                                Text("Change Password")
//                                    .font(.system(size: 15))
//                                    .foregroundColor(.black)
//                                Spacer()
//                                Image(systemName: "chevron.right")
//                                    .foregroundColor(.gray)
//                                    .font(.system(size: 13))
//                            }
//                            .padding(.horizontal, 16)
//                            .padding(.vertical, 16)
//                        }
//                        
//                        Divider().padding(.horizontal, 16)
                        
                        // Logout row
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
            .background(Color(hex: "#F3F4F6").ignoresSafeArea())
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            //Reload edit fields whenever the view appears (catches external updates)
            .onAppear { syncEditFields() }
            //Also sync whenever currentUser changes (e.g. after save)
            .onChange(of: authViewModel.currentUser?.name)    { _ in syncEditFields() }
            .onChange(of: authViewModel.currentUser?.email)   { _ in syncEditFields() }
            .onChange(of: authViewModel.currentUser?.telephone) { _ in syncEditFields() }
            .onChange(of: authViewModel.currentUser?.address) { _ in syncEditFields() }
            .onChange(of: authViewModel.currentUser?.pharmacistID) { _ in syncEditFields() }
            // Logout alert
            .alert("Logout", isPresented: $showLogoutAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Logout", role: .destructive) {
                    authViewModel.signOut()
                }
            } message: {
                Text("Are you sure you want to logout?")
            }
            // Save success toast-style alert
            .alert("Profile Updated", isPresented: $showSaveSuccess) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Your profile has been saved successfully.")
            }
            // Loading overlay
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
    }
    
    //Sync local edit fields from currentUser
    private func syncEditFields() {
        editName         = authViewModel.currentUser?.name ?? ""
        editEmail        = authViewModel.currentUser?.email ?? ""
        editPhone        = authViewModel.currentUser?.telephone
                           ?? authViewModel.currentUser?.phoneNumber
                           ?? ""
        editAddress      = authViewModel.currentUser?.address ?? ""
        editRole         = authViewModel.currentUser?.role ?? .patient
        editPharmacistID = authViewModel.currentUser?.pharmacistID ?? ""
    }
    
    //Edit with Save toggle
    private func handleEditSave() {
        if isEditing {
            // Guard: name must not be empty
            guard !editName.trimmingCharacters(in: .whitespaces).isEmpty else { return }
            
            // ✅ Immediately flip back to view mode and hide Cancel button
            withAnimation { isEditing = false }
            
            // Then persist the changes in the background
            authViewModel.updateProfile(
                name: editName.trimmingCharacters(in: .whitespaces),
                email: editEmail.trimmingCharacters(in: .whitespaces).isEmpty
                    ? nil : editEmail.trimmingCharacters(in: .whitespaces),
                age: nil,
                address: editAddress.trimmingCharacters(in: .whitespaces).isEmpty
                    ? nil : editAddress.trimmingCharacters(in: .whitespaces),
                telephone: editPhone.trimmingCharacters(in: .whitespaces).isEmpty
                    ? nil : editPhone.trimmingCharacters(in: .whitespaces)
            ) { success in
                if success {
                    showSaveSuccess = true
                }
            }
        } else {
            // Pre-fill with current user data before entering edit mode
            syncEditFields()
            withAnimation { isEditing = true }
        }
    }
    
    private func cancelEditing() {
        syncEditFields()  // reset to last saved values
        withAnimation { isEditing = false }
    }
}

//Validation State
enum ValidationState { case none, valid, invalid }

//Password Field Component
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

//Role Toggle Row
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

//Hex Color Extension
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
