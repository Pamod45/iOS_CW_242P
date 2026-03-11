//
//  sessions.swift
//  iOS_CW_242P
//
//  Created by Pubudu Perera on 2026-02-25.
//

import Foundation

struct MockData {
    
    static let countryCodes: [CountryCode] = [
        CountryCode(flag: "🇱🇰", code: "+94", name: "Sri Lanka"),
        CountryCode(flag: "🇮🇳", code: "+91", name: "India"),
        CountryCode(flag: "🇺🇸", code: "+1", name: "United States"),
        CountryCode(flag: "🇬🇧", code: "+44", name: "United Kingdom"),
        CountryCode(flag: "🇦🇺", code: "+61", name: "Australia"),
        CountryCode(flag: "🇸🇬", code: "+65", name: "Singapore"),
        CountryCode(flag: "🇦🇪", code: "+971", name: "UAE"),
        CountryCode(flag: "🇨🇦", code: "+1", name: "Canada"),
        CountryCode(flag: "🇩🇪", code: "+49", name: "Germany"),
        CountryCode(flag: "🇯🇵", code: "+81", name: "Japan")
    ]
    
    static let sessions: [Session] = [
        Session(id: "1", startTime: "06:00", endTime: "09:00", isAvailable: true, currentQueueNumber: 1, averageConsultationTimeInMinutes: 15),
        Session(id: "2", startTime: "09:00", endTime: "12:00", isAvailable: true, currentQueueNumber: 3, averageConsultationTimeInMinutes: 15),
        Session(id: "3", startTime: "12:00", endTime: "15:00", isAvailable: true, currentQueueNumber: 2, averageConsultationTimeInMinutes: 15),
        Session(id: "4", startTime: "15:00", endTime: "18:00", isAvailable: true, currentQueueNumber: 1, averageConsultationTimeInMinutes: 15),
        Session(id: "5", startTime: "18:00", endTime: "21:00", isAvailable: true, currentQueueNumber: 4, averageConsultationTimeInMinutes: 15)
    ]
    
    static var sampleBookings: [Appointment] = [
        Appointment(
            id: "bk-001",
            patientId: "user123",
            type: .opd,
            date: Date(),
            sessionId: "3",
            queueNumber: 12,
            estimatedWaitTime: 60,
            reasonForVisit: "Annual Checkup",
            doctorRoom: "Room 101",
            status: .confirmed,
            paymentCompleted: true,
            amount: 1500.00,
            createdAt: Date().addingTimeInterval(-86400),
            hasPrescription: false,
            journeyId: "J001"
        ),
        
        Appointment(
            id: "bk-002",
            patientId: "user123",
            type: .opd,
            date: Date(),
            sessionId: "1",
            queueNumber: 5,
            estimatedWaitTime: 25,
            reasonForVisit: "Headache and fever",
            doctorRoom: "Room 103",
            status: .confirmed,
            paymentCompleted: true,
            amount: 1500.00,
            createdAt: Date().addingTimeInterval(-3600),
            hasPrescription: false,
            journeyId: "J007"
        ),
        
        Appointment(
            id: "bk-003",
            patientId: "user123",
            type: .laboratory,
            date: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
            sessionId: "1",
            status: .confirmed,
            paymentCompleted: false,
            amount: 15000.00,
            createdAt: Date().addingTimeInterval(-172800),
            labTests: [MockData.sampleTests[5]],
            requiresApproval: true,
            approvalStatus: .approved,
            journeyId: "J003"
        ),
        
        Appointment(
            id: "bk-004",
            patientId: "user123",
            type: .laboratory,
            date: Calendar.current.date(byAdding: .day, value: 3, to: Date())!,
            sessionId: "3",
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
            estimatedWaitTime: 20,
            status: .confirmed,
            paymentCompleted: true,
            amount: 2000.00,
            createdAt: Date().addingTimeInterval(-259200),
            labTests: [MockData.sampleTests[0], MockData.sampleTests[1]],
            requiresApproval: false,
            approvalStatus: nil,
            journeyId: "J003"
        ),
        
        Appointment(
            id: "bk-006",
            patientId: "user123",
            type: .opd,
            date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
            sessionId: "2",
            queueNumber: 8,
            reasonForVisit: "Skin rash evaluation",
            doctorRoom: "Room 104",
            status: .completed,
            paymentCompleted: true,
            amount: 1500.00,
            createdAt: Date().addingTimeInterval(-345600),
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
            reasonForVisit: "Back pain",
            doctorRoom: "Room 102",
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
            status: .cancelled,
            paymentCompleted: false,
            amount: 5000.00,
            createdAt: Date().addingTimeInterval(-259200),
            labTests: [MockData.sampleTests[7]],
            requiresApproval: true,
            approvalStatus: .rejected
        ),
        
        Appointment(
            id: "bk-010",
            patientId: "user123",
            type: .opd,
            date: Date(),
            sessionId: "2",
            queueNumber: 8,
            estimatedWaitTime: 40,
            reasonForVisit: "Follow-up consultation",
            doctorRoom: "Room 105",
            status: .confirmed,
            paymentCompleted: true,
            amount: 1500.00,
            createdAt: Date().addingTimeInterval(-7200),
            hasPrescription: false,
            journeyId: "J002"
        ),
        
        Appointment(
            id: "bk-011",
            patientId: "user123",
            type: .laboratory,
            date: Date(),
            sessionId: "3",
            queueNumber: 4,
            estimatedWaitTime: 30,
            status: .confirmed,
            paymentCompleted: true,
            amount: 1200.00,
            createdAt: Date().addingTimeInterval(-10800),
            labTests: [MockData.sampleTests[2]],
            requiresApproval: false,
            approvalStatus: nil,
            journeyId: "J002"
        ),
        
        Appointment(
            id: "bk-012",
            patientId: "user123",
            type: .laboratory,
            date: Date(),
            sessionId: "1",
            queueNumber: 5,
            estimatedWaitTime: 15,
            status: .confirmed,
            paymentCompleted: true,
            amount: 1500.00,
            createdAt: Date().addingTimeInterval(-5400),
            labTests: [MockData.sampleTests[0], MockData.sampleTests[1]],
            requiresApproval: false,
            approvalStatus: nil,
            journeyId: "J001"
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
    
    static let sampleJourneys: [Journey] = [
        Journey(
            id: "J001",
            patientID: "user123",
            date: Date(),
            steps: [
                JourneyStep(
                    id: "S001",
                    type: .opdCheckIn,
                    bookingID: "bk-001",
                    sequence: 1,
                    status: .completed
                ),
                JourneyStep(
                    id: "S002",
                    type: .doctorConsultation,
                    bookingID: "bk-001",
                    sequence: 2,
                    status: .pending
                ),
                JourneyStep(
                    id: "S003",
                    type: .laboratory,
                    bookingID: "bk-012",
                    sequence: 3,
                    status: .pending
                ),
                JourneyStep(
                    id: "S004",
                    type: .pharmacy,
                    bookingID: "PHAR001",
                    sequence: 4,
                    status: .pending
                )
            ],
            status: .ongoing
        ),
        
        Journey(
            id: "J002",
            patientID: "user123",
            date: Date(),
            steps: [
                JourneyStep(
                    id: "S005",
                    type: .opdCheckIn,
                    bookingID: "bk-010",
                    sequence: 1,
                    status: .pending
                ),
                JourneyStep(
                    id: "S006",
                    type: .doctorConsultation,
                    bookingID: "bk-010",
                    sequence: 2,
                    status: .pending
                ),
                JourneyStep(
                    id: "S007",
                    type: .laboratory,
                    bookingID: "bk-011",
                    sequence: 3,
                    status: .pending
                )
            ],
            status: .pending
        ),
        
        Journey(
            id: "J003",
            patientID: "user123",
            date: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
            steps: [
                JourneyStep(
                    id: "S008",
                    type: .laboratory,
                    bookingID: "bk-003",
                    sequence: 1,
                    status: .pending
                ),
                JourneyStep(
                    id: "S009",
                    type: .laboratory,
                    bookingID: "bk-005",
                    sequence: 2,
                    status: .pending
                )
            ],
            status: .pending
        ),
        
        Journey(
            id: "J004",
            patientID: "user123",
            date: Calendar.current.date(byAdding: .day, value: 3, to: Date())!,
            steps: [
                JourneyStep(
                    id: "S010",
                    type: .laboratory,
                    bookingID: "bk-004",
                    sequence: 1,
                    status: .pending
                )
            ],
            status: .pending
        ),
        
        Journey(
            id: "J005",
            patientID: "user123",
            date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
            steps: [
                JourneyStep(
                    id: "S011",
                    type: .opdCheckIn,
                    bookingID: "bk-006",
                    sequence: 1,
                    status: .completed
                ),
                JourneyStep(
                    id: "S012",
                    type: .doctorConsultation,
                    bookingID: "bk-006",
                    sequence: 2,
                    status: .completed
                ),
                JourneyStep(
                    id: "S013",
                    type: .pharmacy,
                    bookingID: "PHAR002",
                    sequence: 3,
                    status: .completed
                ),
                JourneyStep(
                    id: "S014",
                    type: .checkout,
                    bookingID: "CHECK002",
                    sequence: 4,
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
                    id: "S017",
                    type: .opdCheckIn,
                    bookingID: "bk-002",
                    sequence: 1,
                    status: .completed
                ),
                JourneyStep(
                    id: "S018",
                    type: .doctorConsultation,
                    bookingID: "bk-002",
                    sequence: 2,
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
            if appointment.status == .confirmed && calendar.isDateInToday(appointment.date) {
                if let session = sessions.first(where: { $0.id == appointment.sessionId }) {
                    if isCurrentTimeInSession(session: session, currentTime: now) {
                        sampleBookings[index].status = .inProgress
                    }
                }
            }
        }
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
}
