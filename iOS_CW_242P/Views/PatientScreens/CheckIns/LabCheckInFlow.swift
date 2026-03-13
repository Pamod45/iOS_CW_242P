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
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var isPresented: Bool

    @State private var currentStep = 1
    @State private var selectedTests: [LabTest] = []
    @State private var selectedSession: Session?
    @State private var showApprovalRequired = false
    @State private var showPaymentSuccess = false
    @State private var selectedDate: Date = Date()
    @State private var reasonForVisit: String = ""
    @State private var hasUploadedDocuments = false
    @State private var isVisitFormValid = false
    @State private var isExistingJourney: Bool = false
    @State private var requiresNewJourney: Bool = true

    @State private var pendingPaymentSuccessAfterAlert = false
    
    @State var index: Int? = nil

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ProgressBar(currentStep: currentStep, totalSteps: 5)
                    .padding()
                
                ZStack{
                    if currentStep == 1 {
                        LabTestSelectionView(selectedTests: $selectedTests)
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    }
                    else if currentStep == 2 {
                        DateSelectionView(selectedDate: $selectedDate)
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    }
                    else if currentStep == 3 {
                        SessionSelectionView(selectedSession: $selectedSession, selectedDate: selectedDate)
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    }
                    else if currentStep == 4 {
                        ReasonForVisitView(
                            reasonForVisit: $reasonForVisit,
                            user: authViewModel.currentUser,
                            flowType: .lab(approvalRequiredTests: selectedTests.filter { $0.category == .approvalRequired }),
                            hasUploadedDocuments: $hasUploadedDocuments,
                            isFormValid: $isVisitFormValid
                        )
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    }
                    else if currentStep == 5 {
                        LabPaymentView(
                            selectedTests: selectedTests,
                            selectedSession: selectedSession,
                            selectedDate: selectedDate,
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
                        title: currentStep == 5
                            ? (hasPayableTests ? "Pay Now" : (requiresApproval ? "Request Approval" : "Pay Now"))
                            : "Continue",
                        action: {
                            if currentStep == 5 {
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
                    if !hasPayableTests {
                        dismiss()
                    } else {
                        pendingPaymentSuccessAfterAlert = true
                    }
                }
            } message: {
                Text("Your request for approval has been submitted. You can proceed with payment once approved.")
            }
            .onChange(of: showApprovalRequired) {
                if !showApprovalRequired && pendingPaymentSuccessAfterAlert {
                    pendingPaymentSuccessAfterAlert = false
                    DispatchQueue.main.async {
                        showPaymentSuccess = true
                    }
                }
            }
            .sheet(isPresented: $showPaymentSuccess) {
                PaymentSuccessView(
                    queueNumber: 8,
                    estimatedWaitTime: 30,
                    doctorRoom: "Lab Room",
                    dismissEntireFlow: {
                        showPaymentSuccess = false
                        isPresented = false
                    }
                )
            }
            .onChange(of: selectedDate) { oldValue, newValue in
                // Clear selected session if it has passed for the new date
                if let session = selectedSession, session.hasPassed(for: newValue) {
                    selectedSession = nil
                }
            }
            .alert("Add to an existing journey", isPresented: $isExistingJourney){
                Button("Yes", role: .confirm){
                    requiresNewJourney = false
                    completeBooking()
                }
                Button("No", role: .cancel){
                    requiresNewJourney = false
                    completeBooking()
                }
            } message: {
                Text("We found another appointment in the same date do you want to add this booking to the existing visit journey?")
            }
                
            
        }
        .interactiveDismissDisabled(showPaymentSuccess)
    }
    
    private var requiresApproval: Bool {
        selectedTests.contains { $0.category == .approvalRequired }
    }

    private var hasPayableTests: Bool {
        selectedTests.contains { $0.category == .noApprovalRequired }
    }

    private var canProceed: Bool {
        switch currentStep {
        case 1:
            return !selectedTests.isEmpty
        case 2:
            return true
        case 3:
            return selectedSession != nil
        case 4:
            return isVisitFormValid
        case 5:
            return true
        default:
            return false
        }
    }
    
    private func completeBooking() {
        if hasPayableTests {
            if requiresApproval {
                pendingPaymentSuccessAfterAlert = true
            } else {
                showPaymentSuccess = true
            }
        } else if !requiresApproval {
            showPaymentSuccess = true
        }
        
        if let session = selectedSession {
            let appointmentId = UUID().uuidString
            var journeyId = UUID().uuidString
            
            let appointment = Appointment(
                id: appointmentId ,
                patientId: authViewModel.currentUser?.id ?? "user123",
                type: .laboratory,
                date: selectedDate,
                sessionId: session.id,
                queueNumber: session.currentQueueNumber + 1,
                estimatedWaitTime: (session.currentQueueNumber - 1) * session.averageConsultationTimeInMinutes,
                status: requiresApproval ? .pending : .confirmed,
                paymentCompleted: !requiresApproval,
                amount: selectedTests.reduce(0) {$0 + $1.price},
                createdAt: Date(),
                labTests: selectedTests,
                requiresApproval: requiresApproval,
                approvalStatus: .pending,
                journeyId: journeyId
            )
            
            MockData.sampleBookings.append(appointment)
            
            if(requiresNewJourney){
                MockData.sampleJourneys.append(Journey(
                    id: journeyId,
                    patientID: authViewModel.currentUser?.id ?? "user123",
                    date: selectedDate,
                    steps: [
                        JourneyStep(
                            id: UUID().uuidString,
                            type: .laboratory,
                            bookingID: appointmentId,
                            sequence: 1,
                            status: .pending
                        )
                    ],
                    status: .pending
                ))

            } else {
                let nextSequenceNumber = MockData.sampleJourneys[index!].steps.count + 1
                MockData.sampleJourneys[index!].steps.append(
                   JourneyStep(
                       id: UUID().uuidString,
                       type: .laboratory,
                       bookingID: appointmentId,
                       sequence: nextSequenceNumber,
                       status: .pending
                   )
                )
                journeyId = MockData.sampleJourneys[index!].id
            }
            
            if let index = MockData.sessions.firstIndex(where: { $0.id == session.id }) {
                MockData.sessions[index].currentQueueNumber += 1
            }
        }
    }
    
    private func processPayment() {
        
        
        viewModel.isLoading = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            viewModel.isLoading = false

            if requiresApproval {
                showApprovalRequired = true
            }
            
            index = MockData.sampleJourneys.firstIndex(where: {
               $0.patientID == authViewModel.currentUser?.id ?? "user123" &&
               Calendar.current.isDate($0.date, inSameDayAs: selectedDate)
            })
            
            if let index = index {
                isExistingJourney = true
            }
            else {
                completeBooking()
            }
            

        }
    }
}

#Preview {
    LabCheckInFlow(isPresented: .constant(true))
        .environmentObject(AuthViewModel())
}
