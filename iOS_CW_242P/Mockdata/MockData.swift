//
//  sessions.swift
//  iOS_CW_242P
//
//  Created by Pubudu Perera on 2026-02-25.
//

import Foundation

struct MockData {
    
    //Sample Country Codes data
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
    
    //Sample Sessions data
    static let sessions: [Session] = [
        Session(id: "1", startTime: "06:00", endTime: "09:00", isAvailable: true, currentQueueNumber: 5, estimatedWaitTime: 25),
        Session(id: "2", startTime: "09:00", endTime: "12:00", isAvailable: true, currentQueueNumber: 12, estimatedWaitTime: 60),
        Session(id: "3", startTime: "12:00", endTime: "15:00", isAvailable: true, currentQueueNumber: 8, estimatedWaitTime: 40),
        Session(id: "4", startTime: "15:00", endTime: "18:00", isAvailable: true, currentQueueNumber: 3, estimatedWaitTime: 15),
        Session(id: "5", startTime: "18:00", endTime: "21:00", isAvailable: true, currentQueueNumber: 7, estimatedWaitTime: 35),
        Session(id: "6", startTime: "21:00", endTime: "00:00", isAvailable: false, currentQueueNumber: 0, estimatedWaitTime: 0),
        Session(id: "7", startTime: "00:00", endTime: "03:00", isAvailable: false, currentQueueNumber: 0, estimatedWaitTime: 0),
        Session(id: "8", startTime: "03:00", endTime: "06:00", isAvailable: false, currentQueueNumber: 0, estimatedWaitTime: 0)
    ]
    
    //Sample Bookings data
    static let sampleBookings: [Appointment] = [
        // 1. Upcoming OPD — Confirmed, paid and upcoming
        Appointment(
            id: "bk-001",
            patientId: "user123",
            type: .opd,
            date: Date(),
            sessionId: "2",
            queueNumber: 12,
            estimatedWaitTime: 60,
            reasonForVisit: "Annual Checkup",
            doctorRoom: "Room 101",
            status: .confirmed,
            paymentCompleted: true,
            amount: 1500.00,
            createdAt: Date().addingTimeInterval(-86400),
            hasPrescription: false,
            journeyId: "journey-001"
        ),
        
        // 2. Upcoming OPD — Today, in progress
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
            status: .inProgress,
            paymentCompleted: true,
            amount: 1500.00,
            createdAt: Date().addingTimeInterval(-3600),
            hasPrescription: true,
            prescriptionId: "presc-001",
            journeyId: "journey-002"
        ),
        
        // 3. Lab — Approved, awaiting payment
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
            labTests: [MockData.sampleTests[5]], // MRI Scan
            requiresApproval: true,
            approvalStatus: .approved,
            journeyId: "journey-003"
        ),
        
        // 4. Lab — Pending doctor approval
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
            labTests: [MockData.sampleTests[6]], // CT Scan
            requiresApproval: true,
            approvalStatus: .pending
        ),
        
        // 5. Lab — No approval needed, paid, upcoming
        Appointment(
            id: "bk-005",
            patientId: "user123",
            type: .laboratory,
            date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
            sessionId: "1",
            queueNumber: 3,
            estimatedWaitTime: 20,
            status: .confirmed,
            paymentCompleted: true,
            amount: 2000.00,
            createdAt: Date().addingTimeInterval(-259200),
            labTests: [MockData.sampleTests[0], MockData.sampleTests[1]], // CBC + Glucose
            requiresApproval: false,
            approvalStatus: nil,
            journeyId: "journey-004"
        ),
        
        // 6. OPD — Completed
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
            journeyId: "journey-005"
        ),
        
        // 7. Lab — Completed
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
            labTests: [MockData.sampleTests[0]], // CBC
            requiresApproval: false,
            approvalStatus: nil,
            journeyId: "journey-006"
        ),
        
        // 8. OPD — Cancelled
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
        
        // 9. Lab — Rejected approval
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
            labTests: [MockData.sampleTests[7]], // Biopsy
            requiresApproval: true,
            approvalStatus: .rejected
        ),
    ]
    
    //Sample Lab Test data
    static let sampleTests: [LabTest] = [
        // No Approval Required Tests
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
        
        // Doctor Approval Required Tests
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
    
    
    //Sample Notifications List
    static let sampleNotifications: [AppNotification] = [
        // Today notifications
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
        
        // Yesterday notifications
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
        
        // Older notifications
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
}
