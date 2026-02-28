//
//  LabCheckInFlow.swift
//  iOS_CW_242P
//
//  Created by Pubudu Perera on 2026-02-28.
//

import SwiftUI
import Combine

struct LabCheckInFlow: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = LabCheckInViewModel()
    @Binding var isPresented: Bool
    
    @State private var currentStep = 1
    @State private var selectedTests: [LabTest] = []
    @State private var selectedSession: Session?
    @State private var showApprovalRequired = false
    @State private var showPaymentSuccess = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ProgressBar(currentStep: currentStep, totalSteps: 3)
                    .padding()
                ZStack {
                    if currentStep == 1 {
                        LabTestSelectionView(selectedTests: $selectedTests)
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    } else if currentStep == 2 {
                        SessionSelectionView(selectedSession: $selectedSession)
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    } else if currentStep == 3 {
                        LabPaymentView(
                            selectedTests: selectedTests,
                            selectedSession: selectedSession,
                            onPaymentComplete: {
                                showPaymentSuccess = true
                            }
                        )
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    }
                }
                
                HStack(spacing: 16) {
                    if currentStep > 1 {
                        SecondaryButton(title: "Back") {
                            withAnimation {
                                currentStep -= 1
                            }
                        }
                    }
                    
                    PrimaryButton(
                        title: currentStep == 3 ? (requiresApproval ? "Request Approval" : "Pay Now") : "Continue",
                        action: {
                            if currentStep == 3 {
                                processPayment()
                            } else {
                                withAnimation {
                                    currentStep += 1
                                }
                            }
                        },
                        isLoading: viewModel.isLoading,
                        isDisabled: !canProceed
                    )
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Laboratory Check-In")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                    }
                }
            }
            .alert("Approval Required", isPresented: $showApprovalRequired) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Your request for approval has been submitted. You can proceed with payment once approved.")
            }
            .sheet(isPresented: $showPaymentSuccess) {
                PaymentSuccessView(
                    queueNumber: 8,
                    estimatedWaitTime: 30,
                    doctorRoom: "Lab Room 1",
                    dismissEntireFlow: {
                        showPaymentSuccess = false
                        isPresented = false
                    }
                )
            }
        }
        .interactiveDismissDisabled(showPaymentSuccess)
    }
    
    private var requiresApproval: Bool {
        selectedTests.contains { $0.category == .approvalRequired }
    }
    
    private var canProceed: Bool {
        switch currentStep {
        case 1:
            return !selectedTests.isEmpty
        case 2:
            return selectedSession != nil
        case 3:
            return true
        default:
            return false
        }
    }
    
    private func processPayment() {
        viewModel.isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            viewModel.isLoading = false
            if requiresApproval {
                showApprovalRequired = true
            } else {
                showPaymentSuccess = true
            }
        }
    }
}

class LabCheckInViewModel: ObservableObject {
    @Published var isLoading = false
}

struct TestCartBadge: View {
    let test: LabTest
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 8) {
            Text(test.name)
                .font(.caption)
                .lineLimit(1)
            
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .font(.caption)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.blue.opacity(0.1))
        .foregroundColor(.blue)
        .cornerRadius(20)
    }
}



struct LabTestDetailRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
        }
    }
}

struct LabPaymentView: View {
    let selectedTests: [LabTest]
    let selectedSession: Session?
    let onPaymentComplete: () -> Void
    
    var totalAmount: Double {
        selectedTests.reduce(0) { $0 + $1.price }
    }
    
    var longestDuration: Int {
        selectedTests.map { $0.duration }.max() ?? 0
    }
    
    var requiresApproval: Bool {
        selectedTests.contains { $0.category == .approvalRequired }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(requiresApproval ? "Approval Request" : "Payment Summary")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text(requiresApproval ? "Review and submit for approval" : "Review your lab test details")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                .padding(.top)
                
                if requiresApproval {
                    HStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.title2)
                            .foregroundColor(.orange)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Approval Required")
                                .font(.headline)
                                .foregroundColor(.primary)
                            Text("You can pay after doctor approval")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Selected Tests (\(selectedTests.count))")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ForEach(selectedTests) { test in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(test.name)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Text("\(test.duration) minutes")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Text("LKR \(test.price, specifier: "%.2f")")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                
                if let session = selectedSession {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Session Details")
                            .font(.headline)
                        
                        SummaryRow(icon: "clock", label: "Session", value: session.displayTime)
                        SummaryRow(icon: "hourglass", label: "Expected Duration", value: "\(longestDuration) minutes")
                        SummaryRow(icon: "mappin", label: "Location", value: "Lab Room 1")
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                
                VStack(spacing: 12) {
                    ForEach(selectedTests) { test in
                        HStack {
                            Text(test.name)
                                .font(.subheadline)
                            Spacer()
                            Text("LKR \(test.price, specifier: "%.2f")")
                                .font(.subheadline)
                        }
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Total Amount")
                            .font(.title3)
                            .fontWeight(.bold)
                        Spacer()
                        Text("LKR \(totalAmount, specifier: "%.2f")")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
                
                if !requiresApproval {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Payment Method")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        PaymentMethodCard(icon: "creditcard.fill", title: "Credit/Debit Card", isSelected: true)
                            .padding(.horizontal)
                    }
                }
            }
            .padding(.bottom, 40)
        }
    }
}

#Preview {
    LabCheckInFlow(isPresented: .constant(true))
        .environmentObject(AuthViewModel())
}

