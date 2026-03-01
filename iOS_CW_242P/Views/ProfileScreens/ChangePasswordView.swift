import SwiftUI

//Change Password View
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
