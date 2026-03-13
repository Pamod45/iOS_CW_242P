//
//  Login.swift
//  iOS_CW_242P
//
//  Created by Pubudu Perera on 2026-02-23.
//

import SwiftUI
import AuthenticationServices

struct CountryCode: Identifiable, Hashable {
    let id = UUID()
    let flag: String
    let code: String
    let name: String
}

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedCountry: CountryCode = MockData.countryCodes[0]
    @State private var phoneNumber = ""
    @State private var otpCode = ""
    @State private var showCountryPicker = false
    @FocusState private var focusedField: Field?
    
    enum Field {
        case phone, otp
    }
    
    private var fullPhoneNumber: String {
        selectedCountry.code + phoneNumber.replacingOccurrences(of: " ", with: "")
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                VStack(spacing: 12) {
                    Image("AppLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        
                    
                    Text("Q-Less")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Spend time on health, not on lines")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 50)
                .padding(.bottom, 10)
                
                if !authViewModel.otpSent {
                    phoneInputView
                } else {
                    otpInputView
                }
                
                HStack {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray.opacity(0.3))
                    Text("or continue with")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .fixedSize()
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray.opacity(0.3))
                }
                .padding(.horizontal)
                .padding(.vertical, 4)
                
                HStack(spacing: 24) {
                    Button(action: {
                        authViewModel.signInWithGoogle { _ in }
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color(.systemBackground))
                                .frame(width: 56, height: 56)
                                .shadow(color: .black.opacity(0.08), radius: 4, y: 2)
                            
                            Image("GoogleLogo")
                                .resizable()
                                .renderingMode(.original)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24, height: 24)
                        }
                    }
                    .disabled(authViewModel.isLoading)
                    
                    Button(action: {
                        triggerAppleSignIn()
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color(.systemBackground))
                                .frame(width: 56, height: 56)
                                .shadow(color: .black.opacity(0.08), radius: 4, y: 2)
                            
                            Image(systemName: "apple.logo")
                                .font(.system(size: 26))
                                .foregroundColor(.primary)
                        }
                    }
                    .disabled(authViewModel.isLoading)
                }
                
                Spacer()
            }
        }
        .background(Color(.white))
        .sheet(isPresented: $showCountryPicker) {
            CountryCodePickerView(selectedCountry: $selectedCountry)
        }
        .alert("Error", isPresented: $authViewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(authViewModel.errorMessage ?? "An error occurred")
        }
    }
        
    private var phoneInputView: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Phone Number")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 10) {
                    Button(action: { showCountryPicker = true }) {
                        HStack(spacing: 6) {
                            Text(selectedCountry.flag)
                                .font(.title3)
                            Text(selectedCountry.code)
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                            Image(systemName: "chevron.down")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 12)
                        .frame(height: 50)
                    }
                    
                    TextField("7X XXX XXXX", text: $phoneNumber)
                        .keyboardType(.phonePad)
                        .textFieldStyle(PlainTextFieldStyle())
                        .focused($focusedField, equals: .phone)
                        .padding(.horizontal, 14)
                        .frame(height: 50)
                        .onChange(of: phoneNumber) { oldValue, newValue in
                            phoneNumber = formatPhoneNumber(newValue)
                        }
                }
            }
            .padding(.horizontal)
            
            PrimaryButton(
                title: "Send OTP",
                action: {
                    focusedField = nil
                    authViewModel.sendOTP(phoneNumber: fullPhoneNumber) { success in
                        if success {
                            focusedField = .otp
                        }
                    }
                },
                isLoading: authViewModel.isLoading,
                isDisabled: phoneNumber.isEmpty
            )
            .padding(.horizontal)
        }
    }
        
    private var otpInputView: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "phone.fill")
                    .foregroundColor(.blue)
                Text(fullPhoneNumber)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Spacer()
                Button(action: {
                    authViewModel.resetOTPFlow()
                    otpCode = ""
                }) {
                    Text("Change")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
            }
            .padding()
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Verification Code")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 8) {
                    ForEach(0..<6, id: \.self) { index in
                        OTPDigitBox(
                            digit: getDigit(at: index),
                            isFocused: otpCode.count == index
                        )
                    }
                }
                .onTapGesture {
                    focusedField = .otp
                }
                
                TextField("", text: $otpCode)
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .otp)
                    .frame(width: 0, height: 0)
                    .opacity(0)
                    .onChange(of: otpCode) { oldValue, newValue in
                        if newValue.count > 6 {
                            otpCode = String(newValue.prefix(6))
                        }
                        otpCode = otpCode.filter { $0.isNumber }
                    }
                
                Text("Enter the 6-digit code sent to your phone")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            PrimaryButton(
                title: "Verify & Sign In",
                action: {
                    focusedField = nil
                    authViewModel.verifyOTP(phoneNumber: fullPhoneNumber, otp: otpCode) { _ in }
                },
                isLoading: authViewModel.isLoading,
                isDisabled: otpCode.count != 6
            )
            
            Button(action: {
                otpCode = ""
                authViewModel.sendOTP(phoneNumber: fullPhoneNumber) { _ in }
            }) {
                Text("Resend OTP")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
            }
            .disabled(authViewModel.isLoading)
        }
        .padding(.horizontal)
    }
        
    private func getDigit(at index: Int) -> String {
        guard index < otpCode.count else { return "" }
        return String(otpCode[otpCode.index(otpCode.startIndex, offsetBy: index)])
    }
    
    private func triggerAppleSignIn() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let coordinator = AppleSignInCoordinator(authViewModel: authViewModel)
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = coordinator
        controller.presentationContextProvider = coordinator
        controller.performRequests()
    }
    
    private func formatPhoneNumber(_ number: String) -> String {
        let digits = number.replacingOccurrences(of: " ", with: "")
        
        var formatted = ""
        
        for (index, char) in digits.enumerated() {
            if index == 2 || index == 5 {
                formatted += " "
            }
            formatted.append(char)
        }
        
        return String(formatted.prefix(11))
    }
}

struct OTPDigitBox: View {
    let digit: String
    let isFocused: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemGray6))
                .frame(height: 52)
            
            RoundedRectangle(cornerRadius: 10)
                .stroke(isFocused ? Color.blue : Color.gray.opacity(0.3), lineWidth: isFocused ? 2 : 1)
                .frame(height: 52)
            
            Text(digit)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
        }
    }
}

class AppleSignInCoordinator: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    var authViewModel: AuthViewModel
    
    init(authViewModel: AuthViewModel) {
        self.authViewModel = authViewModel
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first else {
            if #available(iOS 26.0, *),
               let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                return UIWindow(windowScene: scene)
            } else {
                #if compiler(>=6.0)
                #warning("UIWindow() is deprecated in iOS 26.0 but needed for backwards compatibility")
                #endif
                return UIWindow()
            }
        }
        return window
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        authViewModel.handleAppleSignIn(result: .success(authorization))
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        authViewModel.handleAppleSignIn(result: .failure(error))
    }
}

struct CountryCodePickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedCountry: CountryCode
    @State private var searchText = ""
    
    var filteredCountries: [CountryCode] {
        if searchText.isEmpty {
            return MockData.countryCodes
        }
        return MockData.countryCodes.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.code.contains(searchText)
        }
    }
    
    var body: some View {
        NavigationView {
            List(filteredCountries) { country in
                Button(action: {
                    selectedCountry = country
                    dismiss()
                }) {
                    HStack(spacing: 12) {
                        Text(country.flag)
                            .font(.title2)
                        
                        Text(country.name)
                            .font(.body)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Text(country.code)
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        
                        if country.code == selectedCountry.code && country.name == selectedCountry.name {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                                .fontWeight(.semibold)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .searchable(text: $searchText, prompt: "Search country")
            .navigationTitle("Country Code")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
