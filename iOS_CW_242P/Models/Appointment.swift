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
    var currentQueueNumber: Int
    let averageConsultationTimeInMinutes: Int
    let doctorName: String?
    let roomNumber: String?
    
    var displayTime: String {
        "\(startTime) - \(endTime)"
    }
    
    init(id: String = UUID().uuidString, startTime: String, endTime: String, isAvailable: Bool, currentQueueNumber: Int, averageConsultationTimeInMinutes: Int = 5, doctorName: String? = nil, roomNumber: String? = nil) {
            self.id = id
            self.startTime = startTime
            self.endTime = endTime
            self.isAvailable = isAvailable
            self.currentQueueNumber = currentQueueNumber
            self.averageConsultationTimeInMinutes = averageConsultationTimeInMinutes
            self.doctorName = doctorName
            self.roomNumber = roomNumber
        }
    
    func hasPassed(for date: Date) -> Bool {
        guard Calendar.current.isDateInToday(date) else {
            return false
        }
        
        let timeComponents = endTime.split(separator: ":")
        guard timeComponents.count == 2,
              let hour = Int(timeComponents[0]),
              let minute = Int(timeComponents[1]) else {
            return false
        }
        
        var sessionEndComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        sessionEndComponents.hour = hour
        sessionEndComponents.minute = minute
        
        guard let sessionEndDate = Calendar.current.date(from: sessionEndComponents) else {
            return false
        }
        
        return Date() > sessionEndDate
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
    var doctorName: String?
    var status: AppointmentStatus
    var paymentCompleted: Bool
    var amount: Double
    var createdAt: Date
    
    var labTests: [LabTest]?
    var requiresApproval: Bool?
    var approvalStatus: ApprovalStatus?
    
    var medications: [Medication]?
    var prescribedLabTests: [LabTest]?
    
    var hasPrescription: Bool?
    var prescriptionId: String?
    var journeyId: String?
    
    
    init(id: String = UUID().uuidString, patientId: String, type: AppointmentType, date: Date, sessionId: String, queueNumber: Int? = nil, estimatedWaitTime: Int? = nil, reasonForVisit: String? = nil, doctorRoom: String? = nil, doctorName: String? = nil, status: AppointmentStatus = .pending, paymentCompleted: Bool = false, amount: Double = 0, createdAt: Date = Date(), labTests: [LabTest]? = nil, requiresApproval: Bool? = nil, approvalStatus: ApprovalStatus? = nil, medications: [Medication]? = nil, prescribedLabTests: [LabTest]? = nil, hasPrescription: Bool? = nil, prescriptionId: String? = nil, journeyId: String? = nil) {
        self.id = id
        self.patientId = patientId
        self.type = type
        self.date = date
        self.sessionId = sessionId
        self.queueNumber = queueNumber
        self.estimatedWaitTime = estimatedWaitTime
        self.reasonForVisit = reasonForVisit
        self.doctorRoom = doctorRoom
        self.doctorName = doctorName
        self.status = status
        self.paymentCompleted = paymentCompleted
        self.amount = amount
        self.createdAt = createdAt
        self.labTests = labTests
        self.requiresApproval = requiresApproval
        self.approvalStatus = approvalStatus
        self.medications = medications
        self.prescribedLabTests = prescribedLabTests
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
        let todaysAll = MockData.sampleBookings.filter {
            Calendar.current.isDate($0.date, inSameDayAs: Date())
        }
        let inProgress = todaysAll.filter { $0.status == .inProgress }
        let completed = todaysAll.filter { $0.status == .completed }
        
        let combined = inProgress + completed
        
        return Array(combined.prefix(3))
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


