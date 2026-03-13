//
//  OPDCheckIn.swift
//  iOS_CW_242P
//
//  Created by Pubudu Perera on 2026-03-01.
//


import SwiftUI

struct OPDCheckInFlow: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = CheckInViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var isPresented: Bool
    
    @State private var currentStep = 1
    @State private var selectedSession: Session?
    @State private var reasonForVisit = "Headache"
    @State private var showPaymentSuccess = false
    @State private var showQueueTracking = false
    @State private var hasUploadedDocuments = false
    @State private var isVisitFormValid = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ProgressBar(currentStep: currentStep, totalSteps: 4)
                    .padding()
                
                ZStack {
                    if currentStep == 1 {
                        DateSelectionView(selectedDate: $viewModel.selectedDate)
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    } else if currentStep == 2 {
                        SessionSelectionView(selectedSession: $selectedSession, selectedDate: viewModel.selectedDate, displayRoomNumber: true)
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    } else if currentStep == 3 {
                        ReasonForVisitView(reasonForVisit: $reasonForVisit, user: authViewModel.currentUser, flowType: .opd, hasUploadedDocuments: $hasUploadedDocuments, isFormValid: $isVisitFormValid)
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    } else if currentStep == 4 {
                        PaymentView(
                            selectedDate: viewModel.selectedDate,
                            selectedSession: selectedSession,
                            reasonForVisit: reasonForVisit,
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
                        title: currentStep == 4 ? "Pay Now" : "Continue",
                        action: {
                            if currentStep == 4 {
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
            .navigationTitle("OPD Check-In")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                    }
                }
            }
            .sheet(isPresented: $showPaymentSuccess) {
                PaymentSuccessView(
                    queueNumber: 15,
                    estimatedWaitTime: 45,
                    doctorRoom: "Room 105",
                    dismissEntireFlow: {
                        showPaymentSuccess = false
                        isPresented = false
                    }
                )
            }
            .onChange(of: viewModel.selectedDate) { oldValue, newValue in
                if let session = selectedSession, session.hasPassed(for: newValue) {
                    selectedSession = nil
                }
            }
        }
        .interactiveDismissDisabled(showPaymentSuccess)
    }
    
    private var canProceed: Bool {
        switch currentStep {
        case 1:
            return true
        case 2:
            return selectedSession != nil
        case 3:
            return isVisitFormValid
        case 4:
            return true
        default:
            return false
        }
    }
    
    private func processPayment() {
        viewModel.isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            viewModel.isLoading = false
            showPaymentSuccess = true
            
            if let session = selectedSession {
                let appointmentId: String = UUID().uuidString
                let journeyId: String = UUID().uuidString
                var appointment = Appointment(
                    id: appointmentId ,
                    patientId: authViewModel.currentUser?.id ?? "user123",
                    type: .opd,
                    date: viewModel.selectedDate,
                    sessionId: session.id,
                    queueNumber: session.currentQueueNumber + 1,
                    estimatedWaitTime: (session.currentQueueNumber - 1) * session.averageConsultationTimeInMinutes,
                    reasonForVisit: reasonForVisit,
                    doctorRoom: session.roomNumber,
                    doctorName: MockData.doctorSchedule[session.id],
                    status: .confirmed,
                    paymentCompleted: true,
                    amount: 1500.00,
                    createdAt: Date(),
                    hasPrescription: false,
                    journeyId: journeyId
                )
                
                var journey: Journey = Journey(
                    id: journeyId,
                    patientID: authViewModel.currentUser?.id ?? "user123",
                    date: viewModel.selectedDate,
                    steps: [
                        JourneyStep(
                            id: UUID().uuidString,
                            type: .doctorConsultation,
                            bookingID: appointmentId,
                            sequence: 1,
                            status: .pending
                        )
                    ],
                    status: .pending
                )
                
                MockData.sampleBookings.append(appointment)
                MockData.sampleJourneys.append(journey)
                
                if let index = MockData.sessions.firstIndex(where: { $0.id == session.id }) {
                    MockData.sessions[index].currentQueueNumber += 1
                }
            }
            
            
        }
    }
}

#Preview {
    OPDCheckInFlow(isPresented: .constant(true))
        .environmentObject(AuthViewModel())
}

