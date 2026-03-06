//
//  OPDCheckInViewModel.swift
//  iOS_CW_242P
//
//  Created by Pubudu Perera on 2026-03-01.
//

import Foundation
import Combine

class CheckInViewModel: ObservableObject {
    @Published var selectedDate: Date = Date()
    @Published var selectedSession: Session?
    @Published var reasonForVisit: String = ""
    @Published var currentAppointment: Appointment?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    @Published var showPaymentSuccess = false
    
    @Published var currentQueueNumber: Int = 0
    @Published var estimatedWaitTime: Int = 0
    @Published var doctorRoom: String = "Room 105"
    
    let sessions = MockData.sessions
    let consultationFee: Double = 1500.00
    
    var availableSessions: [Session] {
        sessions.filter { $0.isAvailable }
    }
    
    var minimumDate: Date {
        Date()
    }
    
    var maximumDate: Date {
        Calendar.current.date(byAdding: .month, value: 3, to: Date()) ?? Date()
    }
        
    func createOPDAppointment(for user: User, completion: @escaping (Bool) -> Void) {
        guard let session = selectedSession else {
            showErrorMessage("Please select a session")
            completion(false)
            return
        }
        
        guard !reasonForVisit.isEmpty else {
            showErrorMessage("Please enter reason for visit")
            completion(false)
            return
        }
        
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            
            let queueNumber = session.currentQueueNumber + 1
            let waitTime = (queueNumber - 1) * 5
            
            let appointment = Appointment(
                patientId: user.id,
                type: .opd,
                date: self.selectedDate,
                sessionId: session.id,
                queueNumber: queueNumber,
                estimatedWaitTime: waitTime,
                reasonForVisit: self.reasonForVisit,
                doctorRoom: self.doctorRoom,
                status: .pending,
                paymentCompleted: false,
                amount: self.consultationFee
            )
            
            self.currentAppointment = appointment
            self.currentQueueNumber = queueNumber
            self.estimatedWaitTime = waitTime
            self.isLoading = false
            completion(true)
        }
    }
    
    func processPayment(completion: @escaping (Bool) -> Void) {
        guard var appointment = currentAppointment else {
            showErrorMessage("No appointment found")
            completion(false)
            return
        }
        
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let self = self else { return }
            
            appointment.paymentCompleted = true
            appointment.status = .confirmed
            self.currentAppointment = appointment
            self.showPaymentSuccess = true
            self.isLoading = false
            completion(true)
        }
    }
        
    func startQueueUpdates() {
        Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            guard let self = self, self.estimatedWaitTime > 0 else { return }
            
            DispatchQueue.main.async {
                if self.estimatedWaitTime > 5 {
                    self.estimatedWaitTime -= 5
                }
                
                if Int.random(in: 0...2) == 0 && self.currentQueueNumber > 1 {
                    self.currentQueueNumber -= 1
                }
            }
        }
    }
        
    func reset() {
        selectedDate = Date()
        selectedSession = nil
        reasonForVisit = ""
        currentAppointment = nil
        showPaymentSuccess = false
        errorMessage = nil
    }
    
    private func showErrorMessage(_ message: String) {
        errorMessage = message
        showError = true
        isLoading = false
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    func formatWaitTime(_ minutes: Int) -> String {
        if minutes < 60 {
            return "\(minutes) min"
        } else {
            let hours = minutes / 60
            let mins = minutes % 60
            return mins > 0 ? "\(hours)h \(mins)m" : "\(hours)h"
        }
    }
}


