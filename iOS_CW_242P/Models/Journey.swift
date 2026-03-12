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
        if type == .pharmacy || type == .checkout || type == .followUpVisit {
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
    
    var sortOrder: Int {
            let statusMultiplier: Int
            switch computedStatus {
            case .completed:
                statusMultiplier = 0
            case .inProgress:
                statusMultiplier = 100000
            case .pending:
                statusMultiplier = 200000
            case .skipped:
                statusMultiplier = 300000
            }
            
            if type == .pharmacy  || type == .followUpVisit {
                return statusMultiplier + 9000 + sequence
            }
            
            if type == .checkout {
                return statusMultiplier + 400000 + sequence
            }
            
            guard let booking = MockData.sampleBookings.first(where: { $0.id == bookingID }),
                  let session = MockData.sessions.first(where: { $0.id == booking.sessionId }) else {
                return statusMultiplier + sequence * 100
            }
            
            let sessionStartMinutes = timeToMinutes(session.startTime)
            let waitTime = booking.estimatedWaitTime ?? 0
            let totalMinutes = sessionStartMinutes + waitTime
            
            let typeOffset = (type == .opdCheckIn || type == .doctorConsultation) ? 0 : 1
            
            return statusMultiplier + totalMinutes * 10 + typeOffset
        }
    private func timeToMinutes(_ time: String) -> Int {
        let components = time.split(separator: ":")
        guard components.count == 2,
              let hours = Int(components[0]),
              let minutes = Int(components[1]) else {
            return 0
        }
        return hours * 60 + minutes
    }
    
    enum StepType: String, Codable {
        case opdCheckIn
        case doctorConsultation
        case laboratory
        case pharmacy
        case checkout
        case followUpVisit
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
    case inProgress
    case completed
    case cancelled
    
    var displayText: String {
        switch self {
            case .pending: return "Pending"
            case .inProgress: return "In Progress"
            case .completed: return "Completed"
            case .cancelled: return "Cancelled"
        }
    }
}
