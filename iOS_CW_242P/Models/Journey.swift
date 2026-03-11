//
//  Journey.swift
//  iOS_CW_242P
//
//  Created by Pubudu Perera on 2026-03-11.
//
import Foundation
struct Journey: Identifiable, Codable {
    let id: String
    let patientID: String
    let date: Date
    var steps: [JourneyStep]
    var status: JourneyStatus
    
    init(patientID: String, date: Date) {
        self.id = UUID().uuidString
        self.patientID = patientID
        self.date = date
        self.steps = []
        self.status = .pending
    }
    
    init(id: String, patientID: String, date: Date, steps: [JourneyStep], status: JourneyStatus) {
        self.id = id
        self.patientID = patientID
        self.date = date
        self.steps = steps
        self.status = status
    }
}

struct JourneyStep: Identifiable, Codable {
    let id: String
    let type: StepType
    let bookingID: String
    var sequence: Int
    var status: StepStatus
    
    var computedStatus: StepStatus {
        if type == .pharmacy || type == .checkout {
            return status
        }
        
        if let booking = MockData.sampleBookings.first(where: { $0.id == bookingID }) {
            switch booking.status {
            case .confirmed:
                return .pending
            case .inProgress:
                return .inProgress
            case .completed:
                return .completed
            case .cancelled:
                return .skipped
            case .pending:
                return .pending
            }
        }
        
        return status
    }
    
    enum StepType: String, Codable {
        case opdCheckIn
        case doctorConsultation
        case laboratory
        case pharmacy
        case checkout
    }
    
    init(id: String, type: StepType, bookingID: String, sequence: Int, status: StepStatus) {
        self.id = id
        self.type = type
        self.bookingID = bookingID
        self.sequence = sequence
        self.status = status
    }
}

enum StepStatus: String, Codable {
    case pending
    case inProgress
    case completed
    case skipped
}

enum JourneyStatus: String, Codable {
    case pending
    case ongoing
    case completed
    case cancelled
}
