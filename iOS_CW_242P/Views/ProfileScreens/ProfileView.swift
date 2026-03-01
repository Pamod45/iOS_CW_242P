import SwiftUI

// MARK: - Profile View
struct ProfileView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    // MARK: - Edit State
    @State private var isEditing = false
    @State private var editName: String    = ""
    @State private var editEmail: String   = ""
    @State private var editPhone: String   = ""
    @State private var editAddress: String       = ""
    @State private var editRole: UserRole        = .patient
    @State private var editPharmacistID: String  = ""
    
    // MARK: - UI State
    @State private var showLogoutAlert          = false
    @State private var navigateToChangePassword = false
    @State private var showSaveSuccess          = false
    
    // MARK: - Computed Properties — always read live from currentUser
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
                    
                    // MARK: - Avatar + Header
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
                    
                    // MARK: - Role Toggle — always visible
                    RoleToggleRow(selectedRole: $editRole)
                        .padding(.horizontal, 16)
                    
                    // MARK: - Info Fields (read-only ↔ editable)
                    VStack(spacing: 12) {
                        if isEditing {
                            // ✅ Editable fields pre-filled with current user data
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
                            // ✅ Read-only fields showing live currentUser data
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
                    
                    // MARK: - Edit / Save + Cancel Buttons
                    if isEditing {
                        // Save + Cancel side by side (PrimaryButton + SecondaryButton style)
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
                    
                    // MARK: - Settings Section
                    VStack(spacing: 0) {
                        
                        // Hidden link for programmatic navigation
                        NavigationLink(
                            destination: ChangePasswordView(),
                            isActive: $navigateToChangePassword
                        ) { EmptyView() }
                        
                        // Change Password row
                        Button(action: { navigateToChangePassword = true }) {
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
                        
                        Divider().padding(.horizontal, 16)
                        
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
            // ✅ Reload edit fields whenever the view appears (catches external updates)
            .onAppear { syncEditFields() }
            // ✅ Also sync whenever currentUser changes (e.g. after save)
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
    
    // MARK: - Sync local edit fields from currentUser
    /// Called on appear and whenever currentUser changes — keeps fields always fresh
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
    
    // MARK: - Edit / Save toggle
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

// MARK: - Change Password View
struct ChangePasswordView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var currentPassword = ""
    @State private var newPassword     = ""
    @State private var confirmPassword = ""
    @State private var showCurrentPwd  = false
    @State private var showNewPwd      = false
    @State private var showConfirmPwd  = false
    @State private var errorMessage    = ""
    @State private var showError       = false
    @State private var showSuccess     = false
    
    private var passwordsMatch: Bool { newPassword == confirmPassword }
    private var isFormValid: Bool {
        !currentPassword.isEmpty &&
        newPassword.count >= 6 &&
        !confirmPassword.isEmpty &&
        passwordsMatch
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // Lock icon header
                ZStack {
                    Circle()
                        .fill(Color(hex: "#3B82F6").opacity(0.12))
                        .frame(width: 80, height: 80)
                    Image(systemName: "lock.fill")
                        .font(.system(size: 32))
                        .foregroundColor(Color(hex: "#3B82F6"))
                }
                .padding(.top, 32)
                
                VStack(spacing: 6) {
                    Text("Change Password")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                    Text("Enter your current password\nand choose a strong new one.")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                
                // MARK: - Password Fields
                VStack(spacing: 14) {
                    PasswordField(
                        label: "Current Password",
                        icon: "lock",
                        placeholder: "Enter current password",
                        text: $currentPassword,
                        isVisible: $showCurrentPwd
                    )
                    PasswordField(
                        label: "New Password",
                        icon: "lock.open",
                        placeholder: "Enter new password",
                        text: $newPassword,
                        isVisible: $showNewPwd
                    )
                    PasswordField(
                        label: "Confirm Password",
                        icon: "lock.open",
                        placeholder: "Confirm new password",
                        text: $confirmPassword,
                        isVisible: $showConfirmPwd,
                        validationState: confirmPassword.isEmpty
                            ? .none : (passwordsMatch ? .valid : .invalid)
                    )
                }
                .padding(.horizontal, 16)
                
                // Length hint
                if !newPassword.isEmpty && newPassword.count < 6 {
                    HStack(spacing: 6) {
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundColor(.orange).font(.system(size: 13))
                        Text("Password must be at least 6 characters")
                            .font(.system(size: 13)).foregroundColor(.orange)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                }
                
                // Error message
                if showError {
                    HStack(spacing: 6) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red).font(.system(size: 13))
                        Text(errorMessage)
                            .font(.system(size: 13)).foregroundColor(.red)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                }
                
                // Save Password button
                Button(action: savePassword) {
                    Text("Save Password")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(isFormValid
                                    ? Color(hex: "#3B82F6")
                                    : Color(hex: "#3B82F6").opacity(0.4))
                        .cornerRadius(12)
                }
                .padding(.horizontal, 16)
                .disabled(!isFormValid)
                
                Spacer(minLength: 40)
            }
        }
        .background(Color(hex: "#F3F4F6").ignoresSafeArea())
        .navigationTitle("Change Password")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Password Updated", isPresented: $showSuccess) {
            Button("OK") { presentationMode.wrappedValue.dismiss() }
        } message: {
            Text("Your password has been changed successfully.")
        }
    }
    
    private func savePassword() {
        showError = false
        guard !currentPassword.isEmpty else {
            errorMessage = "Please enter your current password."
            showError = true; return
        }
        guard newPassword.count >= 6 else {
            errorMessage = "New password must be at least 6 characters."
            showError = true; return
        }
        guard passwordsMatch else {
            errorMessage = "Passwords do not match. Please try again."
            showError = true; return
        }
        // TODO: Wire to real auth backend (e.g. Firebase re-authentication)
        showSuccess = true
    }
}

// MARK: - Validation State
enum ValidationState { case none, valid, invalid }

// MARK: - Password Field Component
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

// MARK: - Role Toggle Row
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

// MARK: - Editable Info Row (edit mode)
struct EditableInfoRow: View {
    let icon: String
    let label: String
    @Binding var value: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .foregroundColor(Color(hex: "#3B82F6"))
                .frame(width: 22, height: 22)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
                TextField("Enter \(label.lowercased())", text: $value)
                    .font(.system(size: 15))
                    .foregroundColor(.black)
                    .keyboardType(keyboardType)
                    .autocapitalization(keyboardType == .emailAddress ? .none : .words)
                    .disableAutocorrection(keyboardType == .emailAddress)
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(hex: "#3B82F6").opacity(0.5), lineWidth: 1.5)
        )
    }
}

// MARK: - Profile Info Row (read-only)
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

// MARK: - Preview
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(AuthViewModel())
    }
}
