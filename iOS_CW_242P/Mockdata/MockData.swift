//
//  sessions.swift
//  iOS_CW_242P
//
//  Created by Pubudu Perera on 2026-02-25.
//

import Foundation
import SwiftUI

enum QueueStatus: String {
    case pending    = "Pending"
    case preparing  = "Preparing"
    case ready      = "Ready"
    case collected  = "Collected"

    var color: Color {
        switch self {
        case .pending:   return Color(hex: "#F97316")
        case .preparing: return Color(hex: "#3B82F6")
        case .ready:     return Color(hex: "#22C55E")
        case .collected: return Color(hex: "#9CA3AF")
        }
    }
}

struct QueueMedicine: Identifiable {
    let id = UUID()
    let name: String
    let dose: String
    let frequency: Int
    let durationInDays: Int
    let price: Double
}

struct QueueItem: Identifiable {
    let id = UUID()
    let queueNumber: Int
    let patientName: String
    var status: QueueStatus
    let medicines: [QueueMedicine]
    let doctorName: String
    let timeAgo: String
    let date: Date
    let sessionId: String
    
    func matchesFilter(_ filter: QueueFilter) -> Bool {
        switch filter {
        case .all:
            return true
        case .pending:
            return status == .pending
        case .preparing:
            return status == .preparing
        case .ready:
            return status == .ready
        case .collected:
            return status == .collected
        }
    }
}

enum QueueFilter: String, CaseIterable {
    case all = "All"
    case pending = "Pending"
    case preparing = "Preparing"
    case ready = "Ready"
    case collected = "Collected"
}


struct MockData {

    static let countryCodes: [CountryCode] = [
        CountryCode(flag: "🇱🇰", code: "+94",  name: "Sri Lanka"),
        CountryCode(flag: "🇮🇳", code: "+91",  name: "India"),
        CountryCode(flag: "🇺🇸", code: "+1",   name: "United States"),
        CountryCode(flag: "🇬🇧", code: "+44",  name: "United Kingdom"),
        CountryCode(flag: "🇦🇺", code: "+61",  name: "Australia"),
        CountryCode(flag: "🇸🇬", code: "+65",  name: "Singapore"),
        CountryCode(flag: "🇦🇪", code: "+971", name: "UAE"),
        CountryCode(flag: "🇨🇦", code: "+1",   name: "Canada"),
        CountryCode(flag: "🇩🇪", code: "+49",  name: "Germany"),
        CountryCode(flag: "🇯🇵", code: "+81",  name: "Japan")
    ]

    static let sampleQueueItems: [QueueItem] = [
        QueueItem(
            queueNumber: 1,
            patientName: "Amal Perera",
            status: .pending,
            medicines: [
                QueueMedicine(name: "Paracetamol", dose: "500 mg", frequency: 4, durationInDays: 3, price: 50.0),
                QueueMedicine(name: "Amoxicillin",  dose: "250 mg", frequency: 3, durationInDays: 3, price: 100.0)
            ],
            doctorName: "Dr. kamal Perera",
            timeAgo: "1h ago",
            date: Date(),
            sessionId: "1"
        ),
        QueueItem(
            queueNumber: 2,
            patientName: "Nimal Silva",
            status: .preparing,
            medicines: [
                QueueMedicine(name: "Ibuprofen", dose: "400 mg", frequency: 2, durationInDays: 2, price: 75.0),
            ],
            doctorName: "Dr. Pubudu Perera",
            timeAgo: "30min ago",
            date: Date(),
            sessionId: "1"
        ),
        QueueItem(
            queueNumber: 3,
            patientName: "Nuwan Mendis",
            status: .collected,
            medicines: [
                QueueMedicine(name: "Amoxicillin",  dose: "250 mg", frequency: 2, durationInDays: 2, price: 100.0),
            ],
            doctorName: "Dr. Liviru Navartna",
            timeAgo: "30min ago",
            date: Date(),
            sessionId: "1"
        ),
        QueueItem(
            queueNumber: 4,
            patientName: "Chamudi Jayasinghe",
            status: .ready,
            medicines: [
                QueueMedicine(name: "Metformin",   dose: "500 mg", frequency: 2, durationInDays: 7, price: 120.0),
                QueueMedicine(name: "Atorvastatin", dose: "10 mg", frequency: 1, durationInDays: 10, price: 150.0)
            ],
            doctorName: "Dr. Priya Fernando",
            timeAgo: "45min ago",
            date: Date(),
            sessionId: "3"
        ),
        QueueItem(
            queueNumber: 5,
            patientName: "Yulani Alwis",
            status: .pending,
            medicines: [
                QueueMedicine(name: "Cetirizine",  dose: "10 mg", frequency: 1, durationInDays: 4, price: 80.0),
                QueueMedicine(name: "Prednisolone", dose: "5 mg", frequency: 1, durationInDays: 2, price: 200.0),
                QueueMedicine(name: "Omeprazole",  dose: "20 mg", frequency: 1, durationInDays: 5, price: 150.0)
            ],
            doctorName: "Dr. Sarith Ranathunga",
            timeAgo: "10min ago",
            date: Date(),
            sessionId: "3"
        ),
        QueueItem(
                queueNumber: 1,
                patientName: "Kanishka Bandara",
                status: .collected,
                medicines: [
                    QueueMedicine(name: "Losartan", dose: "50 mg", frequency: 1, durationInDays: 30, price: 450.0),
                    QueueMedicine(name: "Metformin", dose: "500 mg", frequency: 2, durationInDays: 30, price: 300.0)
                ],
                doctorName: "Dr. Anura Kumara",
                timeAgo: "1 day ago",
                date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
                sessionId: "2"
            ),
            QueueItem(
                queueNumber: 2,
                patientName: "Dilini Rajapaksa",
                status: .collected,
                medicines: [
                    QueueMedicine(name: "Salbutamol Inhaler", dose: "100 mcg", frequency: 4, durationInDays: 1, price: 850.0)
                ],
                doctorName: "Dr. Nihal Silva",
                timeAgo: "1 day ago",
                date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
                sessionId: "2"
            ),
            QueueItem(
                queueNumber: 1,
                patientName: "Tharindu Perera",
                status: .collected,
                medicines: [
                    QueueMedicine(name: "Panadol", dose: "500 mg", frequency: 4, durationInDays: 2, price: 40.0),
                    QueueMedicine(name: "Vitamin C", dose: "500 mg", frequency: 1, durationInDays: 10, price: 100.0)
                ],
                doctorName: "Dr. Sanduni Perera",
                timeAgo: "2 days ago",
                date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
                sessionId: "3"
            ),
            QueueItem(
                queueNumber: 1,
                patientName: "Malkanthi Gunawardena",
                status: .collected,
                medicines: [
                    QueueMedicine(name: "Amlodipine", dose: "5 mg", frequency: 1, durationInDays: 14, price: 210.0),
                    QueueMedicine(name: "Atorvastatin", dose: "20 mg", frequency: 1, durationInDays: 14, price: 280.0)
                ],
                doctorName: "Dr. Ruwan Wickramasinghe",
                timeAgo: "3 days ago",
                date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
                sessionId: "5"
            ),
            QueueItem(
                queueNumber: 2,
                patientName: "Arjun Jayawardena",
                status: .collected,
                medicines: [
                    QueueMedicine(name: "Augmentin", dose: "625 mg", frequency: 2, durationInDays: 5, price: 1200.0)
                ],
                doctorName: "Dr. Ruwan Wickramasinghe",
                timeAgo: "3 days ago",
                date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
                sessionId: "4"
            ),
            QueueItem(
                queueNumber: 1,
                patientName: "Ishara Madushanka",
                status: .collected,
                medicines: [
                    QueueMedicine(name: "Chlorphenamine", dose: "4 mg", frequency: 3, durationInDays: 3, price: 60.0)
                ],
                doctorName: "Dr. Priya Fernando",
                timeAgo: "4 days ago",
                date: Calendar.current.date(byAdding: .day, value: -4, to: Date())!,
                sessionId: "2"
            )
    ]


    static var sessions: [Session] = [
        Session(id: "1", startTime: "06:00", endTime: "09:00", isAvailable: true, currentQueueNumber: 1, averageConsultationTimeInMinutes: 15, doctorName: "Dr. Samanthi Perera", roomNumber: "Room 101"),
        Session(id: "2", startTime: "09:00", endTime: "12:00", isAvailable: true, currentQueueNumber: 3, averageConsultationTimeInMinutes: 15, doctorName: "Dr. Kamal Silva", roomNumber: "Room 103"),
        Session(id: "3", startTime: "12:00", endTime: "15:00", isAvailable: true, currentQueueNumber: 2, averageConsultationTimeInMinutes: 15, doctorName: "Dr. Nimesha Fernando",roomNumber: "Room 101"),
        Session(id: "4", startTime: "15:00", endTime: "18:00", isAvailable: true, currentQueueNumber: 1, averageConsultationTimeInMinutes: 15, doctorName: "Dr. Ruwan Bandara", roomNumber: "Room 104"),
        Session(id: "5", startTime: "00:00", endTime: "03:00", isAvailable: true, currentQueueNumber: 4, averageConsultationTimeInMinutes: 15, doctorName: "Dr. Kumara Dissanayake",roomNumber: "Room 102")
    ]
    
    static let doctorSchedule: [String: String] = [
        "1": "Dr. Samanthi Perera",
        "2": "Dr. Kamal Silva",
        "3": "Dr. Nimesha Fernando",
        "4": "Dr. Ruwan Bandara",
        "5": "Dr. Kumara Dissanayake"
    ]
    
    
    static var sampleBookings: [Appointment] = [
        Appointment(
            id: "bk-001",
            patientId: "user123",
            type: .opd,
            date: Date(),
            sessionId: "4",
            queueNumber: 12,
            estimatedWaitTime: 60,
            reasonForVisit: "Annual Checkup",
            doctorRoom: "Room 101",
            doctorName: "Dr. Samanthi Perera",
            status: .completed,
            paymentCompleted: true,
            amount: 1500.00,
            createdAt: Date().addingTimeInterval(-86400),
            hasPrescription: false,
            journeyId: "J001"
        ),
//        Appointment(
//            id: "bk-002",
//            patientId: "user123",
//            type: .opd,
//            date: Date(),
//            sessionId: "5",
//            queueNumber: 3,
//            estimatedWaitTime: 15,
//            reasonForVisit: "Headache and fever",
//            doctorRoom: "Room 103",
//            doctorName: "Dr. Ruwan Bandara",
//            status: .inProgress,
//            paymentCompleted: true,
//            amount: 1500.00,
//            createdAt: Date().addingTimeInterval(-3600),
//            hasPrescription: false,
//            journeyId: "J002"
//        ),
        
//        Appointment(
//            id: "bk-010",
//            patientId: "user123",
//            type: .opd,
//            date: Date(),
//            sessionId: "5",
//            queueNumber: 8,
//            estimatedWaitTime: 40,
//            reasonForVisit: "Follow-up consultation",
//            doctorRoom: "Room 105",
//            doctorName: "Dr. Kamal Silva",
//            status: .inProgress,
//            paymentCompleted: true,
//            amount: 1500.00,
//            createdAt: Date().addingTimeInterval(-7200),
//            hasPrescription: false,
//            journeyId: "J003"
//        ),
        
//        Appointment(
//            id: "bk-011",
//            patientId: "user123",
//            type: .laboratory,
//            date: Date(),
//            sessionId: "4",
//            queueNumber: 4,
//            estimatedWaitTime: 20,
//            status: .completed,
//            paymentCompleted: true,
//            amount: 1200.00,
//            createdAt: Date().addingTimeInterval(-10800),
//            labTests: [MockData.sampleTests[2]],
//            requiresApproval: false,
//            approvalStatus: nil,
//            journeyId: "J002"
//        ),
        
        Appointment(
            id: "bk-012",
            patientId: "user123",
            type: .laboratory,
            date: Date(),
            sessionId: "5",
            queueNumber: 7,
            estimatedWaitTime: 35,
            status: .inProgress,
            paymentCompleted: true,
            amount: 1500.00,
            createdAt: Date().addingTimeInterval(-5400),
            labTests: [MockData.sampleTests[0], MockData.sampleTests[1]],
            requiresApproval: false,
            approvalStatus: nil,
            journeyId: "J001"
        ),
        Appointment(
            id: "bk-003",
            patientId: "user123",
            type: .laboratory,
            date: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
            sessionId: "1",
            queueNumber: 6,
            estimatedWaitTime: 30,
            status: .confirmed,
            paymentCompleted: false,
            amount: 15000.00,
            createdAt: Date().addingTimeInterval(-172800),
            labTests: [MockData.sampleTests[5]],
            requiresApproval: true,
            approvalStatus: .approved,
            journeyId: "J008"
        ),
        Appointment(
            id: "bk-004",
            patientId: "user123",
            type: .laboratory,
            date: Calendar.current.date(byAdding: .day, value: 3, to: Date())!,
            sessionId: "3",
            queueNumber: 4,
            estimatedWaitTime: 20,
            status: .pending,
            paymentCompleted: false,
            amount: 8000.00,
            createdAt: Date().addingTimeInterval(-43200),
            labTests: [MockData.sampleTests[6]],
            requiresApproval: true,
            approvalStatus: .pending,
            journeyId: "J004"
        ),
        Appointment(
            id: "bk-005",
            patientId: "user123",
            type: .laboratory,
            date: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
            sessionId: "1",
            queueNumber: 3,
            estimatedWaitTime: 15,
            status: .confirmed,
            paymentCompleted: true,
            amount: 2000.00,
            createdAt: Date().addingTimeInterval(-259200),
            labTests: [MockData.sampleTests[0], MockData.sampleTests[1]],
            requiresApproval: false,
            approvalStatus: nil,
            journeyId: "J009"
        ),
        Appointment(
            id: "bk-006",
            patientId: "user123",
            type: .opd,
            date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
            sessionId: "2",
            queueNumber: 8,
            estimatedWaitTime: 40,
            reasonForVisit: "Skin rash evaluation",
            doctorRoom: "Room 104",
            doctorName: "Dr. Kamal Silva",
            status: .completed,
            paymentCompleted: true,
            amount: 1500.00,
            createdAt: Date().addingTimeInterval(-345600),
            medications: [
                Medication("Cetirizine", "10mg", 1, 7),
                Medication("Hydrocortisone Cream", "1%", 2, 14)
            ],
            prescribedLabTests: [MockData.sampleTests[0]],
            hasPrescription: true,
            prescriptionId: "presc-002",
            journeyId: "J005"
        ),
        Appointment(
            id: "bk-007",
            patientId: "user123",
            type: .laboratory,
            date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!,
            sessionId: "1",
            queueNumber: 2,
            estimatedWaitTime: 10,
            status: .completed,
            paymentCompleted: true,
            amount: 800.00,
            createdAt: Date().addingTimeInterval(-518400),
            labTests: [MockData.sampleTests[0]],
            requiresApproval: false,
            approvalStatus: nil,
            journeyId: "J006"
        ),
        Appointment(
            id: "bk-008",
            patientId: "user123",
            type: .opd,
            date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
            sessionId: "4",
            queueNumber: 7,
            estimatedWaitTime: 35,
            reasonForVisit: "Back pain",
            doctorRoom: "Room 102",
            doctorName: "Dr. Nimesha Fernando",
            status: .cancelled,
            paymentCompleted: false,
            amount: 1500.00,
            createdAt: Date().addingTimeInterval(-172800)
        ),
        Appointment(
            id: "bk-009",
            patientId: "user123",
            type: .laboratory,
            date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
            sessionId: "2",
            queueNumber: 10,
            estimatedWaitTime: 50,
            status: .cancelled,
            paymentCompleted: false,
            amount: 5000.00,
            createdAt: Date().addingTimeInterval(-259200),
            labTests: [MockData.sampleTests[6]],
            requiresApproval: true,
            approvalStatus: .pending,
            journeyId: "J010"
        ),
    ]


    static let sampleTests: [LabTest] = [
        LabTest(
            id: "lab1",
            name: "Complete Blood Count (CBC)",
            description: "Measures red blood cells, white blood cells, hemoglobin, and platelets.",
            price: 800.00,
            duration: 30,
            category: .noApprovalRequired,
            instructions: "No special preparation needed.",
            preparationRequired: nil
        ),
        LabTest(
            id: "lab2",
            name: "Blood Glucose (Fasting)",
            description: "Measures blood sugar levels after 8-12 hours of fasting.",
            price: 350.00,
            duration: 15,
            category: .noApprovalRequired,
            instructions: "Fast for 8-12 hours before the test.",
            preparationRequired: "Fasting required"
        ),
        LabTest(
            id: "lab3",
            name: "Lipid Profile",
            description: "Measures cholesterol and triglyceride levels.",
            price: 1200.00,
            duration: 30,
            category: .noApprovalRequired,
            instructions: "Fast for 9-12 hours before the test.",
            preparationRequired: "Fasting required"
        ),
        LabTest(
            id: "lab4",
            name: "Urine Analysis",
            description: "Analyzes urine for various conditions including infections.",
            price: 450.00,
            duration: 20,
            category: .noApprovalRequired,
            instructions: "Collect midstream urine sample.",
            preparationRequired: nil
        ),
        LabTest(
            id: "lab5",
            name: "Liver Function Test (LFT)",
            description: "Evaluates liver health by measuring enzymes and proteins.",
            price: 1500.00,
            duration: 45,
            category: .noApprovalRequired,
            instructions: "Avoid alcohol 24 hours before test.",
            preparationRequired: "Avoid alcohol"
        ),
        LabTest(
            id: "lab6",
            name: "MRI Scan",
            description: "Detailed imaging using magnetic resonance.",
            price: 15000.00,
            duration: 60,
            category: .approvalRequired,
            instructions: "Remove all metal objects. Inform staff of any implants.",
            preparationRequired: nil
        ),
        LabTest(
            id: "lab7",
            name: "CT Scan",
            description: "Cross-sectional X-ray imaging.",
            price: 8000.00,
            duration: 45,
            category: .approvalRequired,
            instructions: "May require contrast dye. Inform of allergies.",
            preparationRequired: nil
        ),
        LabTest(
            id: "lab8",
            name: "Biopsy",
            description: "Tissue sample collection for analysis.",
            price: 5000.00,
            duration: 90,
            category: .approvalRequired,
            instructions: "Follow specific pre-procedure instructions.",
            preparationRequired: nil
        ),
        LabTest(
            id: "lab9",
            name: "Cardiac Stress Test",
            description: "Evaluates heart function during physical stress.",
            price: 6000.00,
            duration: 60,
            category: .approvalRequired,
            instructions: "Wear comfortable clothing. Avoid caffeine.",
            preparationRequired: nil
        ),
        LabTest(
            id: "lab10",
            name: "Hormone Panel",
            description: "Comprehensive hormone level analysis.",
            price: 3500.00,
            duration: 30,
            category: .approvalRequired,
            instructions: "Best done in the morning. Fasting may be required.",
            preparationRequired: nil
        )
    ]

    static let sampleNotifications: [AppNotification] = [
        AppNotification(
            type: .appointmentReminder,
            title: "Appointment in 30 Minutes",
            message: "Your OPD appointment with Dr. Silva is at 9:00 AM today. Room 103, Queue #15.",
            timestamp: Date().addingTimeInterval(-1800)
        ),
        AppNotification(
            type: .queueUpdate,
            title: "Queue Update",
            message: "You are now #3 in the queue. Estimated wait time: 15 minutes.",
            timestamp: Date().addingTimeInterval(-3600)
        ),
        AppNotification(
            type: .labApproval,
            title: "Lab Test Approved",
            message: "Your Complete Blood Count (CBC) test has been approved by Dr. Perera. Please proceed to Lab Room 1.",
            timestamp: Date().addingTimeInterval(-5400)
        ),
        AppNotification(
            type: .pharmacyReady,
            title: "Prescription Ready",
            message: "Your prescription is ready for pickup at Pharmacy Counter 1. Token: PH-042.",
            timestamp: Date().addingTimeInterval(-7200)
        ),
        AppNotification(
            type: .labReminder,
            title: "Lab Check-In Tomorrow",
            message: "Reminder: You have a Lipid Panel test scheduled for tomorrow at 8:00 AM. Please fast for 12 hours before the test.",
            timestamp: Date().addingTimeInterval(-86400)
        ),
        AppNotification(
            type: .appointmentReminder,
            title: "Appointment Confirmed",
            message: "Your appointment with Dr. Fernando (Cardiologist) has been confirmed for Feb 21 at 10:00 AM, Room 103.",
            timestamp: Date().addingTimeInterval(-90000)
        ),
        AppNotification(
            type: .labApproval,
            title: "Lab Test Requires Approval",
            message: "Your X-Ray Chest test requires doctor approval. We have notified Dr. Silva. You will be updated once approved.",
            timestamp: Date().addingTimeInterval(-100000)
        ),
        AppNotification(
            type: .general,
            title: "Welcome to MediQueue",
            message: "Thank you for registering! You can now book OPD appointments, schedule lab tests, and track your journey through the clinic.",
            timestamp: Date().addingTimeInterval(-259200)
        ),
        AppNotification(
            type: .queueUpdate,
            title: "Check-In Complete",
            message: "You have successfully checked in for your OPD appointment. Your queue number is #8.",
            timestamp: Date().addingTimeInterval(-172800)
        ),
        AppNotification(
            type: .pharmacyReady,
            title: "Prescription Ready",
            message: "Your prescription from your visit on Feb 17 is ready for pickup at Pharmacy Counter 1.",
            timestamp: Date().addingTimeInterval(-259200)
        ),
        AppNotification(
            type: .labReminder,
            title: "Lab Results Available",
            message: "Your CBC test results from Feb 16 are now available. Please check with your doctor during your next visit.",
            timestamp: Date().addingTimeInterval(-345600)
        ),
    ]
    
    static var sampleJourneys: [Journey] = [
        Journey(
            id: "J001",
            patientID: "user123",
            date: Date(),
            steps: [
                JourneyStep(
                    id: "S002",
                    type: .doctorConsultation,
                    bookingID: "bk-001",
                    sequence: 1,
                    status: .completed
                ),
                JourneyStep(
                    id: "S003",
                    type: .laboratory,
                    bookingID: "bk-012",
                    sequence: 2,
                    status: .inProgress
                ),
                JourneyStep(
                    id: "S004",
                    type: .followUpVisit,
                    bookingID: "bk-001",
                    sequence: 3,
                    status: .pending
                ),
                JourneyStep(
                    id: "S005",
                    type: .pharmacy,
                    bookingID: "PHAR010",
                    sequence: 4,
                    status: .pending
                ),
            ],
            status: .inProgress
        ),
        
//        Journey(
//            id: "J002",
//            patientID: "user123",
//            date: Date(),
//            steps: [
//                JourneyStep(
//                    id: "S007",
//                    type: .laboratory,
//                    bookingID: "bk-011",
//                    sequence: 1,
//                    status: .completed
//                ),
//                JourneyStep(
//                    id: "S006",
//                    type: .doctorConsultation,
//                    bookingID: "bk-002",
//                    sequence: 2,
//                    status: .inProgress
//                )
//                
//            ],
//            status: .inProgress
//        ),
        
//        Journey(
//            id: "J003",
//            patientID: "user123",
//            date: Date(),
//            steps: [
//                JourneyStep(
//                    id: "S008",
//                    type: .doctorConsultation,
//                    bookingID: "bk-010",
//                    sequence: 1,
//                    status: .inProgress
//                ),
//                
//            ],
//            status: .pending
//        ),
//        
        Journey(
            id: "J005",
            patientID: "user123",
            date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
            steps: [
                JourneyStep(
                    id: "S012",
                    type: .doctorConsultation,
                    bookingID: "bk-006",
                    sequence: 1,
                    status: .completed
                ),
                JourneyStep(
                    id: "S013",
                    type: .pharmacy,
                    bookingID: "PHAR002",
                    sequence: 2,
                    status: .completed
                ),
                JourneyStep(
                    id: "S014",
                    type: .checkout,
                    bookingID: "CHECK002",
                    sequence: 3,
                    status: .completed
                )
            ],
            status: .completed
        ),
        
        Journey(
            id: "J006",
            patientID: "user123",
            date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!,
            steps: [
                JourneyStep(
                    id: "S015",
                    type: .laboratory,
                    bookingID: "bk-007",
                    sequence: 1,
                    status: .completed
                ),
                JourneyStep(
                    id: "S016",
                    type: .checkout,
                    bookingID: "CHECK003",
                    sequence: 2,
                    status: .completed
                )
            ],
            status: .completed
        ),
        
        Journey(
            id: "J007",
            patientID: "user123",
            date: Date(),
            steps: [
                JourneyStep(
                    id: "S018",
                    type: .doctorConsultation,
                    bookingID: "bk-002",
                    sequence: 1,
                    status: .pending
                )
            ],
            status: .pending
        ),
        
        Journey(
            id: "J008",
            patientID: "user123",
            date: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
            steps: [
                JourneyStep(
                    id: "S019",
                    type: .laboratory,
                    bookingID: "bk-003",
                    sequence: 1,
                    status: .pending
                )
            ],
            status: .pending
        ),
        
        Journey(
            id: "J009",
            patientID: "user123",
            date: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
            steps: [
                JourneyStep(
                    id: "S020",
                    type: .laboratory,
                    bookingID: "bk-005",
                    sequence: 1,
                    status: .pending
                )
            ],
            status: .pending
        ),
        
        Journey(
            id: "J010",
            patientID: "user123",
            date: Calendar.current.date(byAdding: .day, value: 3, to: Date())!,
            steps: [
                JourneyStep(
                    id: "S021",
                    type: .laboratory,
                    bookingID: "bk-004",
                    sequence: 1,
                    status: .pending
                )
            ],
            status: .pending
        )
    ]
    
    static func updateAppointmentStatuses() {
        let now = Date()
        let calendar = Calendar.current
        
        for (index, appointment) in sampleBookings.enumerated() {
            if appointment.status == .confirmed {
                if calendar.isDateInToday(appointment.date) {
                    if let session = sessions.first(where: { $0.id == appointment.sessionId }) {
                        if isCurrentTimeInSession(session: session, currentTime: now) {
                            sampleBookings[index].status = .inProgress
                        } else if hasSessionEnded(session: session, currentTime: now) {
                            sampleBookings[index].status = .completed
                        }
                    }
                } else if appointment.date < calendar.startOfDay(for: now) {
                    if let session = sessions.first(where: { $0.id == appointment.sessionId }) {
                        if hasSessionEnded(session: session, currentTime: calendar.startOfDay(for: appointment.date).addingTimeInterval(24 * 60 * 60)) {
                            sampleBookings[index].status = .completed
                        }
                    } else {
                        sampleBookings[index].status = .completed
                    }
                }
            }
        }
    }
    
    private static func hasSessionEnded(session: Session, currentTime: Date) -> Bool {
        let calendar = Calendar.current
        let components = session.endTime.split(separator: ":")
        guard components.count == 2,
              let hours = Int(components[0]),
              let minutes = Int(components[1]) else {
            return false
        }
        
        var sessionEndComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: currentTime)
        sessionEndComponents.hour = hours
        sessionEndComponents.minute = minutes
        
        guard let sessionEnd = calendar.date(from: sessionEndComponents) else {
            return false
        }
        
        return currentTime >= sessionEnd
    }
    
    private static func isCurrentTimeInSession(session: Session, currentTime: Date) -> Bool {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        guard let sessionStart = dateFormatter.date(from: session.startTime),
              let sessionEnd = dateFormatter.date(from: session.endTime) else {
            return false
        }
        
        let currentComponents = calendar.dateComponents([.hour, .minute], from: currentTime)
        let sessionStartComponents = calendar.dateComponents([.hour, .minute], from: sessionStart)
        let sessionEndComponents = calendar.dateComponents([.hour, .minute], from: sessionEnd)
        
        guard let currentHour = currentComponents.hour,
              let currentMinute = currentComponents.minute,
              let startHour = sessionStartComponents.hour,
              let startMinute = sessionStartComponents.minute,
              let endHour = sessionEndComponents.hour,
              let endMinute = sessionEndComponents.minute else {
            return false
        }
        
        let currentTotalMinutes = currentHour * 60 + currentMinute
        let startTotalMinutes = startHour * 60 + startMinute
        let endTotalMinutes = endHour * 60 + endMinute
        
        return currentTotalMinutes >= startTotalMinutes && currentTotalMinutes < endTotalMinutes
    }
    
    //Sample data for map locations
    static let sampleLocations: [MapLocation] = [
        // ── Floor 1 ─────────────────────────────────
        // Bottom – entrance lobby
        MapLocation(
            name: "Main Entrance",
            type: .entrance,
            floor: 1,
            coordinates: MapCoordinates(x: 0.50, y: 0.92),
            description: "Main clinic entrance",
            qrCode: "QR-ENTRANCE-001"
        ),
        MapLocation(
            name: "Reception",
            type: .reception,
            floor: 1,
            coordinates: MapCoordinates(x: 0.50, y: 0.78),
            description: "Check-in and information",
            qrCode: "QR-RECEPTION-001"
        ),
        
        // Left wing – doctor rooms
        MapLocation(
            name: "Room 101",
            type: .doctorRoom,
            floor: 1,
            coordinates: MapCoordinates(x: 0.12, y: 0.58),
            description: "General Physician",
            qrCode: "QR-ROOM-101"
        ),
        MapLocation(
            name: "Room 102",
            type: .doctorRoom,
            floor: 1,
            coordinates: MapCoordinates(x: 0.12, y: 0.42),
            description: "General Physician",
            qrCode: "QR-ROOM-102"
        ),
        
        // Centre – corridor intersection area
        MapLocation(
            name: "Room 103",
            type: .doctorRoom,
            floor: 1,
            coordinates: MapCoordinates(x: 0.42, y: 0.55),
            description: "Cardiologist",
            qrCode: "QR-ROOM-103"
        ),
        MapLocation(
            name: "Room 104",
            type: .doctorRoom,
            floor: 1,
            coordinates: MapCoordinates(x: 0.60, y: 0.55),
            description: "Dermatologist",
            qrCode: "QR-ROOM-104"
        ),
        
        // Right wing – labs
        MapLocation(
            name: "Lab Room",
            type: .laboratory, floor: 1,
            coordinates: MapCoordinates(x: 0.88, y: 0.58),
            description: "Blood tests",
            qrCode: "QR-LAB-001"
        ),
        MapLocation(
            name: "Restroom",
            type: .restroom, floor: 1,
            coordinates: MapCoordinates(x: 0.88, y: 0.42),
            description: "Imaging",
            qrCode: "QR-RESTROOM-001-F1"
        ),
        
        // Top area – pharmacy & exit
        MapLocation(
            name: "Pharmacy",
            type: .pharmacy,
            floor: 1,
            coordinates: MapCoordinates(x: 0.65, y: 0.18),
            description: "Prescription pickup",
            qrCode: "QR-PHARMACY-001"
        ),
        MapLocation(
            name: "Exit",
            type: .exit,
            floor: 1,
            coordinates: MapCoordinates(x: 0.35, y: 0.08),
            description: "Rear exit",
            qrCode: "QR-EXIT-001"
        ),
        
        // Utilities scattered
        MapLocation(
            name: "Restroom",
            type: .restroom,
            floor: 1,
            coordinates: MapCoordinates(x: 0.78, y: 0.78),
            qrCode: "QR-RESTROOM-002-F1"
        ),
        
        MapLocation(
            name: "Elevator",
            type: .elevator,
            floor: 1,
            coordinates: MapCoordinates(x: 0.28, y: 0.35),
            qrCode: "QR-ELEVATOR-F1"
        ),
        MapLocation(
            name: "Stairs",
            type: .stairs,
            floor: 1,
            coordinates: MapCoordinates(x: 0.72, y: 0.35),
            qrCode: "QR-STAIRS-F1"
        ),
        
        // ── Floor 2 ─────────────────────────────────
        MapLocation(
            name: "Room 201",
            type: .doctorRoom,
            floor: 2,
            coordinates: MapCoordinates(x: 0.15, y: 0.55),
            description: "Pediatrician",
            qrCode: "QR-ROOM-201"
        ),
        MapLocation(
            name: "Room 202",
            type: .doctorRoom,
            floor: 2,
            coordinates: MapCoordinates(x: 0.40, y: 0.55),
            description: "ENT Specialist",
            qrCode: "QR-ROOM-202"
        ),
        MapLocation(
            name: "Room 203",
            type: .doctorRoom,
            floor: 2,
            coordinates: MapCoordinates(x: 0.65, y: 0.55),
            description: "Ophthalmologist",
            qrCode: "QR-ROOM-203"
        ),
        MapLocation(
            name: "Elevator",
            type: .elevator,
            floor: 2,
            coordinates: MapCoordinates(x: 0.28, y: 0.35),
            qrCode: "QR-ELEVATOR-F2"
        ),
        MapLocation(
            name: "Stairs",
            type: .stairs,
            floor: 2,
            coordinates: MapCoordinates(x: 0.72, y: 0.35),
            qrCode: "QR-STAIRS-F2"
        ),
        MapLocation(
            name: "Restroom",
            type: .restroom,
            floor: 2,
            coordinates: MapCoordinates(x: 0.50, y: 0.80),
            qrCode: "QR-RESTROOM-F2"
        )
    ]
    
    
    //sample data for predefined routes
    static let sampleRoutes: [Routes] = [
        Routes(
            sourceName: "Main Entrance",
            destinationName: "Room 101",
            floor: 1,
            directionPoints: [
                CGPoint(x: 0.50, y: 0.92),
                CGPoint(x: 0.50, y: 0.78),
                CGPoint(x: 0.50, y: 0.68),
                CGPoint(x: 0.18, y: 0.68),
                CGPoint(x: 0.18, y: 0.58),
                CGPoint(x: 0.12, y: 0.58)
            ],
            directions: [
                "Head inside through the main entrance doors.",
                "Walk straight ahead past the reception desk.",
                "Continue along the main corridor until you reach the central junction.",
                "Turn left at the junction and go past the first lane you see on the right",
                "Turn right at the next lane",
                "You have arrived at your destination which will be the first room on the left hand side!"
            ]
        ),
        
        Routes(
            sourceName: "Room 101",
            destinationName: "Main Entrance",
            floor: 1,
            directionPoints: [
                CGPoint(x: 0.12, y: 0.58),
                CGPoint(x: 0.18, y: 0.58),
                CGPoint(x: 0.18, y: 0.68),
                CGPoint(x: 0.50, y: 0.68),
                CGPoint(x: 0.50, y: 0.78),
                CGPoint(x: 0.50, y: 0.92),
            ],
            directions: [
                "Head outside the room and turn right.",
                "Walk straight and turn left.",
                "Continue along the main corridor until you reach the central junction.",
                "Turn right at the junction — you will see the reception far ahead.",
                "Head down the corridor until you see reception and pass it.",
                "You have passed the reception. The main entrance will be up ahead. Exit through the main doors to leave the clinic."
            ]
        ),
        
        
        Routes(
            sourceName: "Main Entrance",
            destinationName: "Pharmacy",
            floor: 1,
            directionPoints: [
                CGPoint(x: 0.50, y: 0.92),
                CGPoint(x: 0.50, y: 0.78),
                CGPoint(x: 0.50, y: 0.68),
                CGPoint(x: 0.50, y: 0.50),
                CGPoint(x: 0.50, y: 0.35),
                CGPoint(x: 0.50, y: 0.25),
                CGPoint(x: 0.65, y: 0.25),
                CGPoint(x: 0.65, y: 0.18)
            ],
            directions: [
                "Head inside through the main entrance doors.",
                "Walk straight ahead past the reception desk.",
                "Continue forward along the central corridor.",
                "Keep walking straight — you'll pass the consultation rooms on both sides.",
                "Continue ahead until you reach the upper corridor junction.",
                "Turn right toward the pharmacy section.",
                "The pharmacy counter is just ahead on your right.",
                "You've arrived at the pharmacy. Show your prescription and wait to be called."
            ]
        ),
        
        Routes(
            sourceName: "Pharmacy",
            destinationName: "Main Entrance",
            floor: 1,
            directionPoints: [
                CGPoint(x: 0.65, y: 0.18),
                CGPoint(x: 0.65, y: 0.25),
                CGPoint(x: 0.50, y: 0.25),
                CGPoint(x: 0.50, y: 0.35),
                CGPoint(x: 0.50, y: 0.50),
                CGPoint(x: 0.50, y: 0.68),
                CGPoint(x: 0.50, y: 0.78),
                CGPoint(x: 0.50, y: 0.92)
            ],
            directions: [
                "Head inside through the main entrance doors.",
                "Walk straight ahead past the reception desk.",
                "Continue forward along the central corridor.",
                "Keep walking straight — you'll pass the consultation rooms on both sides.",
                "Continue ahead until you reach the upper corridor junction.",
                "Turn right toward the pharmacy section.",
                "The pharmacy counter is just ahead on your right.",
                "You've arrived at the pharmacy. Show your prescription and wait to be called."
            ]
        ),
        
//        Routes(
//            sourceName: "Reception",
//            destinationName: "Lab Room 1",
//            floor: 1,
//            directionPoints: [
//                CGPoint(x: 0.50, y: 0.78),
//                CGPoint(x: 0.50, y: 0.68),
//                CGPoint(x: 0.82, y: 0.68),
//                CGPoint(x: 0.82, y: 0.58),
//                CGPoint(x: 0.88, y: 0.58)
//            ],
//            directions: [
//                "From reception, face the main corridor ahead.",
//                "Walk to the central junction where the corridors meet.",
//                "Turn right and follow the corridor toward the laboratory section.",
//                "You'll see the lab entrance with glass partitions ahead.",
//                "Enter Lab Room 1 and present your test request form to the technician."
//            ]
//        ),
        
//        Routes(
//            sourceName: "Room 101",
//            destinationName: "Room 102",
//            floor: 1,
//            directionPoints: [
//                CGPoint(x: 0.12, y: 0.58),
//                CGPoint(x: 0.18, y: 0.58),
//                CGPoint(x: 0.18, y: 0.50),
//                CGPoint(x: 0.18, y: 0.42),
//                CGPoint(x: 0.12, y: 0.42)
//            ],
//            directions: [
//                "Step out of Room 101 and face the corridor.",
//                "Walk down the left wing corridor.",
//                "Continue along the corridor past the waiting area.",
//                "Room 102 is the next door on your left.",
//                "You've arrived at Room 102. Please check in with the nurse."
//            ]
//        ),
        
//        Routes(
//            sourceName: "Room 103",
//            destinationName: "Lab Room 2",
//            floor: 1,
//            directionPoints: [
//                CGPoint(x: 0.42, y: 0.55),
//                CGPoint(x: 0.42, y: 0.68),
//                CGPoint(x: 0.82, y: 0.68),
//                CGPoint(x: 0.82, y: 0.50),  
//                CGPoint(x: 0.82, y: 0.42),
//                CGPoint(x: 0.88, y: 0.42)
//            ],
//            directions: [
//                "Exit Room 103 and turn toward the main corridor.",
//                "Walk to the central junction.",
//                "Turn right and head down the corridor toward the laboratory wing.",
//                "Continue along the right corridor.",
//                "Lab Room 2 is ahead on your right — look for the imaging lab sign.",
//                "You've arrived at Lab Room 2. Hand your form to the lab staff."
//            ]
//        ),
//        
//        Routes(
//            sourceName: "Lab Room 1",
//            destinationName: "Pharmacy",
//            floor: 1,
//            directionPoints: [
//                CGPoint(x: 0.88, y: 0.58),
//                CGPoint(x: 0.82, y: 0.58),
//                CGPoint(x: 0.82, y: 0.68),
//                CGPoint(x: 0.50, y: 0.68),
//                CGPoint(x: 0.50, y: 0.35),
//                CGPoint(x: 0.50, y: 0.25),
//                CGPoint(x: 0.65, y: 0.25),
//                CGPoint(x: 0.65, y: 0.18)
//            ],
//            directions: [
//                "Exit Lab Room 1 and turn left into the corridor.",
//                "Walk toward the main corridor junction.",
//                "Turn left at the junction and head toward the center.",
//                "Continue straight along the central corridor.",
//                "Keep walking ahead until you reach the upper corridor.",
//                "Turn right toward the pharmacy section.",
//                "The pharmacy counter is just ahead.",
//                "You've arrived at the pharmacy. Show your prescription and wait."
//            ]
//        ),
//        
//        Routes(
//            sourceName: "Room 104",
//            destinationName: "Exit",
//            floor: 1,
//            directionPoints: [
//                CGPoint(x: 0.60, y: 0.55),
//                CGPoint(x: 0.60, y: 0.68),
//                CGPoint(x: 0.50, y: 0.68),
//                CGPoint(x: 0.50, y: 0.50),
//                CGPoint(x: 0.50, y: 0.35),
//                CGPoint(x: 0.50, y: 0.25),
//                CGPoint(x: 0.35, y: 0.25),
//                CGPoint(x: 0.35, y: 0.08)
//            ],
//            directions: [
//                "Exit Room 104 and face the main corridor.",
//                "Walk toward the central junction.",
//                "Continue straight along the central corridor.",
//                "Keep walking forward through the middle of the building.",
//                "Continue ahead toward the upper level.",
//                "Turn left at the upper corridor.",
//                "Follow the corridor toward the rear exit.",
//                "You've reached the exit. The doors are directly ahead."
//            ]
//        ),
//        
//        
//        Routes(
//            sourceName: "Main Entrance",
//            destinationName: "Elevator",
//            floor: 1,
//            directionPoints: [
//                CGPoint(x: 0.50, y: 0.92),
//                CGPoint(x: 0.50, y: 0.78),
//                CGPoint(x: 0.50, y: 0.68),
//                CGPoint(x: 0.50, y: 0.50),
//                CGPoint(x: 0.50, y: 0.35),
//                CGPoint(x: 0.35, y: 0.35),
//                CGPoint(x: 0.28, y: 0.35)
//            ],
//            directions: [
//                "Head inside through the main entrance doors.",
//                "Walk straight past the reception desk.",
//                "Continue along the central corridor.",
//                "Keep walking forward through the main corridor.",
//                "Continue ahead — you'll pass the consultation rooms.",
//                "Turn left toward the elevator area.",
//                "The elevator is just ahead on your left. Press the call button and wait.",
//                "Take the elevator to Floor 2."
//            ]
//        ),
//        
//        Routes(
//            sourceName: "Elevator",
//            destinationName: "Room 201",
//            floor: 2,
//            directionPoints: [
//                CGPoint(x: 0.28, y: 0.35),
//                CGPoint(x: 0.50, y: 0.35),
//                CGPoint(x: 0.50, y: 0.50),
//                CGPoint(x: 0.50, y: 0.65),
//                CGPoint(x: 0.15, y: 0.65),
//                CGPoint(x: 0.15, y: 0.55)
//            ],
//            directions: [
//                "Exit the elevator on Floor 2 and look for the signage ahead.",
//                "Turn right and walk toward the central corridor.",
//                "Continue straight along the center corridor.",
//                "Walk ahead until you reach the main corridor junction.",
//                "Turn left along the main corridor — you'll see the pediatrics section.",
//                "Room 201 is on your left. Check in with the receptionist."
//            ]
//        ),
//        
//        Routes(
//            sourceName: "Main Entrance",
//            destinationName: "Stairs",
//            floor: 1,
//            directionPoints: [
//                CGPoint(x: 0.50, y: 0.92),
//                CGPoint(x: 0.50, y: 0.78),
//                CGPoint(x: 0.50, y: 0.68),
//                CGPoint(x: 0.50, y: 0.50),
//                CGPoint(x: 0.50, y: 0.35),
//                CGPoint(x: 0.72, y: 0.35)
//            ],
//            directions: [
//                "Head inside through the main entrance doors.",
//                "Walk straight past the reception desk.",
//                "Continue along the central corridor.",
//                "Keep walking forward through the main corridor.",
//                "Continue ahead — you'll pass the consultation rooms.",
//                "Turn right and you'll see the staircase ahead. Look for the stairs sign.",
//                "Take the stairs up to Floor 2."
//            ]
//        ),
//        
//        Routes(
//            sourceName: "Stairs",
//            destinationName: "Room 203",
//            floor: 2,
//            directionPoints: [
//                CGPoint(x: 0.72, y: 0.35),
//                CGPoint(x: 0.50, y: 0.35),
//                CGPoint(x: 0.50, y: 0.50),
//                CGPoint(x: 0.50, y: 0.65),
//                CGPoint(x: 0.65, y: 0.65),
//                CGPoint(x: 0.65, y: 0.55)
//            ],
//            directions: [
//                "Exit the staircase on Floor 2 and look for directional signs.",
//                "Turn left and walk toward the central corridor.",
//                "Continue straight along the center corridor.",
//                "Walk ahead until you reach the main corridor junction.",
//                "Turn right along the main corridor — you'll see the ophthalmology section.",
//                "Room 203 is on your right. Check in with the receptionist."
//            ]
//        )
    ]
            
    private static let main: CGFloat = 20
    private static let side: CGFloat = 14
    private static let small: CGFloat = 10
    
    static let allCorridors: [CorridorSegment] = floor1Corridors + floor2Corridors
    
    static let floor1Corridors: [CorridorSegment] = [
        CorridorSegment(start: .init(x: 0.50, y: 0.95), end: .init(x: 0.50, y: 0.68), width: main, isMainCorridor: true, floor: 1),
        CorridorSegment(start: .init(x: 0.08, y: 0.68), end: .init(x: 0.92, y: 0.68), width: main, isMainCorridor: true, floor: 1),
        CorridorSegment(start: .init(x: 0.18, y: 0.68), end: .init(x: 0.18, y: 0.38), width: side, isMainCorridor: false, floor: 1),
        CorridorSegment(start: .init(x: 0.08, y: 0.50), end: .init(x: 0.18, y: 0.50), width: small, isMainCorridor: false, floor: 1),
        CorridorSegment(start: .init(x: 0.82, y: 0.68), end: .init(x: 0.82, y: 0.38), width: side, isMainCorridor: false, floor: 1),
        CorridorSegment(start: .init(x: 0.82, y: 0.50), end: .init(x: 0.92, y: 0.50), width: small, isMainCorridor: false, floor: 1),
        CorridorSegment(start: .init(x: 0.50, y: 0.68), end: .init(x: 0.50, y: 0.25), width: side, isMainCorridor: true, floor: 1),
        CorridorSegment(start: .init(x: 0.22, y: 0.25), end: .init(x: 0.80, y: 0.25), width: side, isMainCorridor: false, floor: 1),
        CorridorSegment(start: .init(x: 0.65, y: 0.25), end: .init(x: 0.65, y: 0.14), width: small, isMainCorridor: false, floor: 1),
        CorridorSegment(start: .init(x: 0.35, y: 0.25), end: .init(x: 0.35, y: 0.06), width: small, isMainCorridor: false, floor: 1),
        CorridorSegment(start: .init(x: 0.08, y: 0.58), end: .init(x: 0.18, y: 0.58), width: small, isMainCorridor: false, floor: 1),
        CorridorSegment(start: .init(x: 0.08, y: 0.42), end: .init(x: 0.18, y: 0.42), width: small, isMainCorridor: false, floor: 1),
        CorridorSegment(start: .init(x: 0.42, y: 0.68), end: .init(x: 0.42, y: 0.52), width: small, isMainCorridor: false, floor: 1),
        CorridorSegment(start: .init(x: 0.60, y: 0.68), end: .init(x: 0.60, y: 0.52), width: small, isMainCorridor: false, floor: 1),
        CorridorSegment(start: .init(x: 0.50, y: 0.80), end: .init(x: 0.78, y: 0.80), width: small, isMainCorridor: false, floor: 1),
        CorridorSegment(start: .init(x: 0.22, y: 0.35), end: .init(x: 0.50, y: 0.35), width: small, isMainCorridor: false, floor: 1),
        CorridorSegment(start: .init(x: 0.50, y: 0.35), end: .init(x: 0.80, y: 0.35), width: small, isMainCorridor: false, floor: 1)
    ]
    
    static let floor2Corridors: [CorridorSegment] = [
        CorridorSegment(start: .init(x: 0.50, y: 0.85), end: .init(x: 0.50, y: 0.25), width: main, isMainCorridor: true, floor: 2),
        CorridorSegment(start: .init(x: 0.10, y: 0.65), end: .init(x: 0.90, y: 0.65), width: main, isMainCorridor: true, floor: 2),
        CorridorSegment(start: .init(x: 0.15, y: 0.65), end: .init(x: 0.15, y: 0.50), width: side, isMainCorridor: false, floor: 2),
        CorridorSegment(start: .init(x: 0.40, y: 0.65), end: .init(x: 0.40, y: 0.50), width: small, isMainCorridor: false, floor: 2),
        CorridorSegment(start: .init(x: 0.65, y: 0.65), end: .init(x: 0.65, y: 0.50), width: small, isMainCorridor: false, floor: 2),
        CorridorSegment(start: .init(x: 0.22, y: 0.35), end: .init(x: 0.80, y: 0.35), width: side, isMainCorridor: false, floor: 2),
        CorridorSegment(start: .init(x: 0.80, y: 0.45), end: .init(x: 0.90, y: 0.45), width: small, isMainCorridor: false, floor: 2),
        CorridorSegment(start: .init(x: 0.80, y: 0.35), end: .init(x: 0.80, y: 0.45), width: small, isMainCorridor: false, floor: 2),
        CorridorSegment(start: .init(x: 0.50, y: 0.78), end: .init(x: 0.50, y: 0.85), width: small, isMainCorridor: false, floor: 2)
    ]
    
    static func corridors(for floor: Int) -> [CorridorSegment] {
        return floor == 1 ? floor1Corridors : floor2Corridors
    }
}
