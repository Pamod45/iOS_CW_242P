import SwiftUI

struct ProfileView: View {

    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var isEditing            = false
    @State private var editName: String     = ""
    @State private var editEmail: String    = ""
    @State private var editPhone: String    = ""
    @State private var editPharmacistID     = ""
    @State private var editNIC              = ""

    @State private var showLogoutAlert          = false
    @State private var showSaveSuccess          = false
    @State private var showRoleSwitchAlert      = false
    @State private var pendingRole: UserRole?   = nil

    private var displayName: String {
        let n = authViewModel.currentUser?.name ?? ""
        return n.isEmpty ? "New User" : n
    }
    private var displayEmail: String {
        let e = authViewModel.currentUser?.email ?? ""
        return e.isEmpty ? "No Email" : e
    }
    private var displayPhone: String {
        let p = authViewModel.currentUser?.telephone
             ?? authViewModel.currentUser?.phoneNumber ?? ""
        return p.isEmpty ? "No Phone Number" : p
    }
    private var displayPharmacistID: String {
        let p = authViewModel.currentUser?.pharmacistID ?? ""
        return p.isEmpty ? "No Pharmacist ID" : p
    }
    private var displayNIC: String {
        let n = authViewModel.currentUser?.nic ?? ""
        return n.isEmpty ? "No NIC" : n
    }

    private var completedFields: Int {
        var c = 0
        if !(authViewModel.currentUser?.name ?? "").isEmpty          { c += 1 }
        if !(authViewModel.currentUser?.email ?? "").isEmpty         { c += 1 }
        let phone = authViewModel.currentUser?.telephone
                 ?? authViewModel.currentUser?.phoneNumber ?? ""
        if !phone.isEmpty { c += 1 }
        return c
    }
    private var totalFields: Int { authViewModel.activeRole == .pharmacist ? 5 : 4 }
    private var isProfileComplete: Bool { completedFields >= totalFields }

    private var canSwitchRoles: Bool {
        authViewModel.currentUser?.roles.contains(.pharmacist) == true
    }

    //Body

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {

                    //Role switcher
                    if canSwitchRoles {
                        Picker(
                            "Active Role",
                            selection: Binding(
                                get: { authViewModel.activeRole },
                                set: { newRole in
                                    guard newRole != authViewModel.activeRole else { return }
                                    pendingRole = newRole
                                    showRoleSwitchAlert = true
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

                    
                    VStack(spacing: 10) {
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

                        Text(isEditing ? (editName.isEmpty ? "Your Name" : editName) : displayName)
                            .font(.system(size: 22, weight: .bold))

                        Text(authViewModel.activeRole == .pharmacist ? "Pharmacist" : "Patient")
                            .font(.caption).fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 10).padding(.vertical, 4)
                            .background(authViewModel.activeRole == .pharmacist
                                        ? Color.green : Color.blue)
                            .cornerRadius(20)
                    }
                    .frame(maxWidth: .infinity)
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
                                        .frame(
                                            width: geo.size.width
                                                * CGFloat(completedFields) / CGFloat(totalFields),
                                            height: 6
                                        )
                                }
                            }
                            .frame(height: 6)
                            Text("Adding the remaining details will help avoid delays during appointments and lab visits.")
                                .font(.system(size: 12)).foregroundColor(.gray)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(16)
                        .background(Color(hex: "#EFF6FF"))
                        .cornerRadius(12)
                        .padding(.horizontal, 16)
                    }

                    
                    VStack(spacing: 12) {
                        if isEditing {
                            EditableInfoRow(icon: "person",     label: "Name",
                                            placeholder: "Enter your name",
                                            value: $editName,     keyboardType: .default)
                            EditableInfoRow(icon: "creditcard", label: "NIC (National Identity Card)",
                                            placeholder: "Enter your NIC number",
                                            value: $editNIC,      keyboardType: .default)
                            EditableInfoRow(icon: "envelope",   label: "Email Address",
                                            placeholder: "Enter your Email Address",
                                            value: $editEmail,    keyboardType: .emailAddress)
                            EditableInfoRow(icon: "phone",      label: "Telephone",
                                            placeholder: "Enter your telephone number",
                                            value: $editPhone,    keyboardType: .phonePad)
                            if authViewModel.activeRole == .pharmacist {
                                EditableInfoRow(icon: "cross.case", label: "Pharmacist ID",
                                                placeholder: "Enter your Pharmacist ID",
                                                value: $editPharmacistID, keyboardType: .default)
                                .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                        } else {
                            ProfileInfoRow(icon: "person",     label: "Name",                         value: displayName)
                            ProfileInfoRow(icon: "creditcard", label: "NIC (National Identity Card)", value: displayNIC)
                            ProfileInfoRow(icon: "envelope",   label: "Email Address",                value: displayEmail)
                            ProfileInfoRow(icon: "phone",      label: "Telephone",                    value: displayPhone)
                            if authViewModel.activeRole == .pharmacist {
                                ProfileInfoRow(icon: "cross.case", label: "Pharmacist ID", value: displayPharmacistID)
                                    .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .animation(.easeInOut(duration: 0.22), value: isEditing)
                    .animation(.easeInOut(duration: 0.22), value: authViewModel.activeRole)

                    
                    if isEditing {
                        HStack(spacing: 12) {
                            SecondaryButton(title: "Cancel", action: cancelEditing)
                            PrimaryButton(title: "Save Profile",
                                          action: handleEditSave,
                                          isLoading: authViewModel.isLoading)
                        }
                        .padding(.horizontal, 16)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    } else {
                        PrimaryButton(title: "Edit Profile", action: handleEditSave)
                            .padding(.horizontal, 16)
                    }

                    
                    Button(action: { showLogoutAlert = true }) {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .foregroundColor(.red).frame(width: 24)
                            Text("Logout")
                                .font(.system(size: 15)).foregroundColor(.red)
                            Spacer()
                        }
                        .padding(.horizontal, 16).padding(.vertical, 16)
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
                Button("Logout", role: .destructive) { authViewModel.signOut() }
            } message: { Text("Are you sure you want to logout?") }
            .alert("Profile Updated", isPresented: $showSaveSuccess) {
                Button("OK", role: .cancel) {}
            } message: { Text("Your profile has been saved successfully.") }
            .alert("Switch Profile", isPresented: $showRoleSwitchAlert) {
                Button("Switch", role: .destructive) {
                    if let role = pendingRole {
                        authViewModel.switchActiveRole(to: role)
                    }
                    pendingRole = nil
                }
                Button("Cancel", role: .cancel) { pendingRole = nil }
            } message: {
                let target = pendingRole == .pharmacist ? "Pharmacist" : "Patient"
                Text("Switch to \(target) view? The app will reload with that dashboard.")
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
    }

    private func syncEditFields() {
        editName         = authViewModel.currentUser?.name ?? ""
        editEmail        = authViewModel.currentUser?.email ?? ""
        editPhone        = authViewModel.currentUser?.telephone
                        ?? authViewModel.currentUser?.phoneNumber ?? ""
        editPharmacistID = authViewModel.currentUser?.pharmacistID ?? ""
        editNIC          = authViewModel.currentUser?.nic ?? ""
    }

    private func handleEditSave() {
        if isEditing {
            guard !editName.trimmingCharacters(in: .whitespaces).isEmpty else { return }
            withAnimation { isEditing = false }
            authViewModel.updateProfile(
                name:         editName.trimmed,
                email:        editEmail.trimmedOrNil,
                age:          nil,
                address:      nil,
                telephone:    editPhone.trimmedOrNil,
                pharmacistID: editPharmacistID.trimmedOrNil,
                nic:          editNIC.trimmedOrNil
            ) { success in if success { showSaveSuccess = true } }
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
        let parts = name.split(separator: " ")
        if parts.count >= 2 {
            return String(parts[0].prefix(1) + parts[1].prefix(1)).uppercased()
        }
        return String(name.prefix(1)).uppercased()
    }
}

private extension String {
    var trimmed: String { trimmingCharacters(in: .whitespaces) }
    var trimmedOrNil: String? { let s = trimmed; return s.isEmpty ? nil : s }
}

enum ValidationState { case none, valid, invalid }

struct PasswordField: View {
    let label: String; let icon: String; let placeholder: String
    @Binding var text: String; @Binding var isVisible: Bool
    var validationState: ValidationState = .none
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label).font(.system(size: 12, weight: .medium)).foregroundColor(.gray).padding(.leading, 4)
            HStack(spacing: 12) {
                Image(systemName: icon).foregroundColor(.gray).frame(width: 22)
                if isVisible {
                    TextField(placeholder, text: $text).font(.system(size: 15)).autocapitalization(.none).disableAutocorrection(true)
                } else {
                    SecureField(placeholder, text: $text).font(.system(size: 15))
                }
                if validationState != .none {
                    Image(systemName: validationState == .valid ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(validationState == .valid ? .green : .red).font(.system(size: 16))
                }
                Button(action: { isVisible.toggle() }) {
                    Image(systemName: isVisible ? "eye.slash" : "eye").foregroundColor(.gray).font(.system(size: 15))
                }
            }
            .padding(.horizontal, 16).padding(.vertical, 14).background(Color.white).cornerRadius(12)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(
                validationState == .valid ? Color.green : validationState == .invalid ? Color.red : Color.clear, lineWidth: 1.5))
        }
    }
}

struct RoleToggleRow: View {
    @Binding var selectedRole: UserRole
    var body: some View {
        HStack(spacing: 0) {
            roleButton(title: "Patient", icon: "person.fill", role: .patient)
            roleButton(title: "Pharmacist", icon: "cross.case.fill", role: .pharmacist)
        }
        .background(Color(hex: "#F3F4F6")).cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "#3B82F6").opacity(0.3), lineWidth: 1.5))
    }
    @ViewBuilder
    private func roleButton(title: String, icon: String, role: UserRole) -> some View {
        Button(action: { withAnimation(.easeInOut(duration: 0.2)) { selectedRole = role } }) {
            HStack(spacing: 6) {
                Image(systemName: icon).font(.system(size: 13, weight: .medium))
                Text(title).font(.system(size: 14, weight: .semibold))
            }
            .foregroundColor(selectedRole == role ? .white : Color(hex: "#3B82F6"))
            .frame(maxWidth: .infinity).frame(height: 44)
            .background(selectedRole == role ? Color(hex: "#3B82F6") : Color.clear)
            .cornerRadius(selectedRole == role ? 11 : 0).padding(selectedRole == role ? 2 : 0)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView().environmentObject(AuthViewModel())
    }
}
