//
//  LabCheckInFlow.swift
//  iOS_CW_242P
//
//  Created by Pubudu Perera on 2026-02-28.
//

import SwiftUI

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

#Preview {
    LabCheckInFlow(isPresented: .constant(true))
        .environmentObject(AuthViewModel())
}

