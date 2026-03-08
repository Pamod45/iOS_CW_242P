//
//  AuthViewModel.swift
//  iOS_CW_242P
//
//  Created by Pubudu Perera on 2026-02-23.
//
import Foundation
import SwiftUI
import Combine
import AuthenticationServices

class AuthViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false

    @Published var otpSent = false
    @Published var isVerifyingOTP = false
    @Published var verificationId: String?

    private let userDefaultsKey = "currentUser"

    private let demoOTPCode = "123456"
    private let demoAccounts: [String: (name: String, role: UserRole, specialization: String?)] = [
        "+94711111111": ("Pubudu Perera", .patient, nil),
        "+94722222222": ("Liviru Navaratna", .pharmacist, nil)
    ]

    init() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        print("🔄 AuthViewModel initialized - UserDefaults cleared")
    }

    func sendOTP(phoneNumber: String, completion: @escaping (Bool) -> Void) {
        isLoading = true
        errorMessage = nil

        guard !phoneNumber.isEmpty else {
            showErrorMessage("Please enter your phone number")
            completion(false)
            return
        }

        let cleanedNumber = phoneNumber.replacingOccurrences(of: " ", with: "")
        guard cleanedNumber.count >= 10 else {
            showErrorMessage("Please enter a valid phone number")
            completion(false)
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            self.verificationId = UUID().uuidString
            self.otpSent = true
            self.isLoading = false
            self.objectWillChange.send()
            print("📱 OTP sent to \(phoneNumber)")
            completion(true)
        }
    }

    func verifyOTP(phoneNumber: String, otp: String, completion: @escaping (Bool) -> Void) {
        isVerifyingOTP = true
        isLoading = true
        errorMessage = nil

        guard !otp.isEmpty else {
            showErrorMessage("Please enter the OTP code")
            completion(false)
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }

            guard otp == self.demoOTPCode else {
                self.showErrorMessage("Invalid OTP code. Please try again.")
                self.isVerifyingOTP = false
                completion(false)
                return
            }

            let cleanedNumber = phoneNumber.replacingOccurrences(of: " ", with: "")

            var user: User
            if let demoAccount = self.demoAccounts[cleanedNumber] {
                user = User(
                    name: demoAccount.name,
                    phoneNumber: cleanedNumber,
                    telephone: cleanedNumber,
                    role: demoAccount.role,
                    authProvider: .phone
                )
                if demoAccount.role == .pharmacist {
                    user.role = .patient
                    user.roles.append(.pharmacist)
                }
            } else {
                user = User(
                    name: "New User",
                    phoneNumber: cleanedNumber,
                    telephone: cleanedNumber,
                    role: .patient,
                    authProvider: .phone
                )
            }

            self.currentUser = user
            self.saveUser(user)
            self.isAuthenticated = true
            self.isLoading = false
            self.isVerifyingOTP = false
            self.otpSent = false
            self.objectWillChange.send()
            print("Phone auth successful - Role: \(user.role)")
            completion(true)
        }
    }

    func resetOTPFlow() {
        otpSent = false
        verificationId = nil
        isVerifyingOTP = false
        isLoading = false
    }

    func signInWithGoogle(completion: @escaping (Bool) -> Void) {
        isLoading = true
        errorMessage = nil

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            let user = User(
                email: "user@gmail.com",
                name: "Google User",
                phoneNumber: nil,
                role: .patient,
                authProvider: .google
            )
            self.currentUser = user
            self.saveUser(user)
            self.isAuthenticated = true
            self.isLoading = false
            self.objectWillChange.send()
            print("Google Sign-In successful - Role: \(user.role)")
            completion(true)
        }
    }

    func handleAppleSignIn(result: Result<ASAuthorization, Error>) {
        isLoading = true

        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                let fullName = [
                    appleIDCredential.fullName?.givenName,
                    appleIDCredential.fullName?.familyName
                ].compactMap { $0 }.joined(separator: " ")

                let user = User(
                    email: appleIDCredential.email,
                    name: fullName.isEmpty ? "Apple User" : fullName,
                    role: .patient,
                    authProvider: .apple
                )
                self.currentUser = user
                self.saveUser(user)
                self.isAuthenticated = true
                self.isLoading = false
                self.objectWillChange.send()
                print("Apple Sign-In successful - Name: \(user.name)")
            }

        case .failure(let error):
            self.isLoading = false
            if (error as NSError).code != ASAuthorizationError.canceled.rawValue {
                showErrorMessage("Apple Sign-In failed: \(error.localizedDescription)")
            }
        }
    }

    func signOut() {
        isLoading = true
        currentUser = nil
        isAuthenticated = false
        otpSent = false
        verificationId = nil
        isVerifyingOTP = false
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        objectWillChange.send()
        print("🚪 User logged out successfully")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.isLoading = false
            self?.objectWillChange.send()
        }
    }

    func updateProfile(
        name: String,
        email: String?,
        age: Int?,
        address: String?,
        telephone: String?,
        pharmacistID: String? = nil,
        nic: String? = nil,
        completion: @escaping (Bool) -> Void
    ) {
        guard var user = currentUser else {
            showErrorMessage("No user logged in")
            completion(false)
            return
        }

        isLoading = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }

            user.name         = name
            user.email        = email
            user.address      = address
            user.telephone    = telephone
            user.pharmacistID = pharmacistID
            user.nic          = nic

            self.currentUser = user
            self.saveUser(user)
            self.isLoading = false
            self.objectWillChange.send()

            print("Profile updated — Name: \(name), NIC: \(nic ?? "nil"), PharmacistID: \(pharmacistID ?? "nil")")

            completion(true)
        }
    }

    private func showErrorMessage(_ message: String) {
        errorMessage = message
        showError = true
        isLoading = false
    }

    private func saveUser(_ user: User) {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }

    private func loadUser() {
        if let userData = UserDefaults.standard.data(forKey: userDefaultsKey),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            currentUser = user
            isAuthenticated = true
        }
    }
}
