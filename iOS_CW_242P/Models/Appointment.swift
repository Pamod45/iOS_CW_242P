//
//  Appointment.swift
//  iOS_CW_242P
//
//  Created by Pubudu Perera on 2026-02-25.
//

import Foundation

enum AppointmentType: String, Codable, CaseIterable {
    case opd = "OPD"
    case laboratory = "Laboratory"
}

enum AppointmentStatus: String, Codable, CaseIterable {
    case pending = "Pending"
    case confirmed = "Confirmed"
    case inProgress = "In Progress"
    case completed = "Completed"
    case cancelled = "Cancelled"
}

struct Session: Identifiable, Codable {
    let id: String
    let startTime: String
    let endTime: String
    let isAvailable: Bool
    let currentQueueNumber: Int
    let estimatedWaitTime: Int // in minutes
    
    var displayTime: String {
        "\(startTime) - \(endTime)"
    }
    
    init(id: String = UUID().uuidString, startTime: String, endTime: String, isAvailable: Bool, currentQueueNumber: Int, estimatedWaitTime: Int = 5) {
            self.id = id
            self.startTime = startTime
            self.endTime = endTime
            self.isAvailable = isAvailable
            self.currentQueueNumber = currentQueueNumber
            self.estimatedWaitTime = estimatedWaitTime
        }
}

enum ApprovalStatus: String, Codable {
    case pending = "Pending Approval"
    case approved = "Approved"
    case rejected = "Rejected"
}

struct Appointment: Identifiable, Codable {
    let id: String
    let patientId: String
    let type: AppointmentType
    var date: Date
    var sessionId: String
    var queueNumber: Int?
    var estimatedWaitTime: Int?
    var reasonForVisit: String?
    var doctorRoom: String?
    var status: AppointmentStatus
    var paymentCompleted: Bool
    var amount: Double
    var createdAt: Date
    
    //Lab related appointment details
    var labTests: [LabTest]?
    var requiresApproval: Bool?
    var approvalStatus: ApprovalStatus?
    
    //Has journey and prescription specific details
    var hasPrescription: Bool?
    var prescriptionId: String?
    var journeyId: String?
    
    
    init(id: String = UUID().uuidString, patientId: String, type: AppointmentType, date: Date, sessionId: String, queueNumber: Int? = nil, estimatedWaitTime: Int? = nil, reasonForVisit: String? = nil, doctorRoom: String? = nil, status: AppointmentStatus = .pending, paymentCompleted: Bool = false, amount: Double = 0, createdAt: Date = Date(), labTests: [LabTest]? = nil, requiresApproval: Bool? = nil, approvalStatus: ApprovalStatus? = nil, hasPrescription: Bool? = nil, prescriptionId: String? = nil, journeyId: String? = nil) {
        self.id = id
        self.patientId = patientId
        self.type = type
        self.date = date
        self.sessionId = sessionId
        self.queueNumber = queueNumber
        self.estimatedWaitTime = estimatedWaitTime
        self.reasonForVisit = reasonForVisit
        self.doctorRoom = doctorRoom
        self.status = status
        self.paymentCompleted = paymentCompleted
        self.amount = amount
        self.createdAt = createdAt
        self.labTests = labTests
        self.requiresApproval = requiresApproval
        self.approvalStatus = approvalStatus
        self.hasPrescription = hasPrescription
        self.prescriptionId = prescriptionId
        self.journeyId = journeyId
    }
}

extension Appointment{
    var isUpcoming: Bool {
        guard status == .confirmed else { return false }
        guard date >= Calendar.current.startOfDay(for: Date()) else { return false }
        if isAwaitingPayment{
            return false
        }
        return true
    }
    
    var isCompleted: Bool {
        status == .completed
    }
    
    var isCancelled: Bool {
        status == .cancelled || approvalStatus == .rejected
    }
    
    var isPendingApproval: Bool {
        type == .laboratory && approvalStatus == .pending
    }
    
    var isAwaitingPayment: Bool {
        guard type == .laboratory else { return false }
        guard !paymentCompleted else { return false }
        if requiresApproval == true {
            return approvalStatus == .approved
        } else {
            return status == .confirmed || status == .pending
        }
    }
    
    var displayDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
    
    var sessionDisplay: String {
        MockData.sessions.first { $0.id == sessionId }?.displayTime ?? "N/A"
    }
    
    static var todaysAppointments: [Appointment] {
        MockData.sampleBookings.filter { appointment in
                Calendar.current.isDate(appointment.date, inSameDayAs: Date())
            }
    }
    
    var statusColor: String {
        switch status {
        case .pending:    return "orange"
        case .confirmed:  return "blue"
        case .inProgress: return "purple"
        case .completed:  return "green"
        case .cancelled:  return "red"
        }
    }
}


