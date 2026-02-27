//
//  BookingDetailView.swift
//  iOS_CW_242P
//
//  Created by Liviru Navaratna on 2026-02-27.
//

import SwiftUI

struct BookingDetailView: View {
    @Binding var booking: Appointment
    let onPayNow: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Status Header
                BookingStatusHeader(booking: booking)
                    .padding(.horizontal)
                
                // Booking Info Card
                BookingInfoCard(booking: booking)
                    .padding(.horizontal)
                
                // Lab Tests (if lab booking)
                if booking.type == .laboratory, let tests = booking.labTests {
                    LabTestsCard(tests: tests, approvalStatus: booking.approvalStatus)
                        .padding(.horizontal)
                }
                
                // Timeline
                BookingTimeline(booking: booking)
                    .padding(.horizontal)
                
                // Payment Section
                PaymentInfoCard(booking: booking)
                    .padding(.horizontal)
                
                // Action Button
                if booking.isAwaitingPayment {
                    PrimaryButton(
                        title: "Pay Now — Rs. \(String(format: "%.2f", booking.amount))",
                        action: onPayNow
                    )
                    .padding(.horizontal)
                }
                
                if booking.isUpcoming && !booking.isPendingApproval && !booking.isAwaitingPayment {
                    // Queue info if confirmed
                    if let queue = booking.queueNumber, let wait = booking.estimatedWaitTime {
                        QueueInfoCard(queueNumber: queue, estimatedWait: wait, room: booking.doctorRoom)
                            .padding(.horizontal)
                    }
                }
            }
            .padding(.top, 16)
            .padding(.bottom, 40)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Booking Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Status Header

struct BookingStatusHeader: View {
    let booking: Appointment
    
    private var statusColor: Color {
        if booking.isPendingApproval { return .orange }
        if booking.isAwaitingPayment { return .red }
        if booking.approvalStatus == .rejected { return .red }
        switch booking.status {
        case .pending:    return .orange
        case .confirmed:  return .blue
        case .inProgress: return .purple
        case .completed:  return .green
        case .cancelled:  return .red
        }
    }
    
    private var statusIcon: String {
        if booking.isPendingApproval { return "clock.badge.questionmark" }
        if booking.isAwaitingPayment { return "creditcard" }
        if booking.approvalStatus == .rejected { return "xmark.circle" }
        switch booking.status {
        case .pending:    return "clock"
        case .confirmed:  return "checkmark.circle"
        case .inProgress: return "arrow.triangle.2.circlepath"
        case .completed:  return "checkmark.seal.fill"
        case .cancelled:  return "xmark.circle"
        }
    }
    
    private var statusText: String {
        if booking.isPendingApproval { return "Pending Doctor Approval" }
        if booking.isAwaitingPayment { return "Awaiting Payment" }
        if booking.approvalStatus == .rejected { return "Approval Rejected" }
        return booking.status.rawValue
    }
    
    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: statusIcon)
                .font(.system(size: 36))
                .foregroundColor(statusColor)
                .frame(width: 72, height: 72)
                .background(statusColor.opacity(0.1))
                .cornerRadius(18)
            
            Text(statusText)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(statusColor)
            
            HStack(spacing: 6) {
                Image(systemName: booking.type == .opd ? "stethoscope" : "flask.fill")
                    .font(.caption)
                Text(booking.type.rawValue)
                    .font(.subheadline)
            }
            .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Info Card

struct BookingInfoCard: View {
    let booking: Appointment
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Booking Information")
                .font(.headline)
            
            VStack(spacing: 14) {
                BookingInfoRow(icon: "calendar", label: "Date", value: booking.displayDate, color: .blue)
                
                Divider()
                
                BookingInfoRow(icon: "clock", label: "Session", value: booking.sessionDisplay, color: .purple)
                
                if booking.type == .opd {
                    Divider()
                    
                    BookingInfoRow(icon: "text.bubble", label: "Reason", value: booking.reasonForVisit ?? "N/A", color: .orange)
                    
                    if let room = booking.doctorRoom {
                        Divider()
                        BookingInfoRow(icon: "door.left.hand.open", label: "Room", value: room, color: .teal)
                    }
                }
                
                Divider()
                
                BookingInfoRow(icon: "number", label: "Booking ID", value: booking.id.prefix(12).uppercased().description, color: .gray)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
}

struct BookingInfoRow: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundColor(color)
                .frame(width: 24)
            
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(1)
        }
    }
}

// MARK: - Lab Tests Card

struct LabTestsCard: View {
    let tests: [LabTest]
    let approvalStatus: ApprovalStatus?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Lab Tests")
                    .font(.headline)
                Spacer()
                
                if let status = approvalStatus {
                    Text(status.rawValue)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(colorFor(status))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(colorFor(status).opacity(0.1))
                        .cornerRadius(8)
                }
            }
            
            ForEach(tests) { test in
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "flask.fill")
                        .font(.caption)
                        .foregroundColor(.green)
                        .frame(width: 32, height: 32)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(8)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(test.name)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        Text(test.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                        
                        HStack(spacing: 12) {
                            HStack(spacing: 4) {
                                Image(systemName: "clock")
                                    .font(.caption2)
                                Text("\(test.duration) min")
                                    .font(.caption)
                            }
                            .foregroundColor(.secondary)
                            
                            if let prep = test.preparationRequired {
                                HStack(spacing: 4) {
                                    Image(systemName: "exclamationmark.triangle")
                                        .font(.caption2)
                                    Text(prep)
                                        .font(.caption)
                                }
                                .foregroundColor(.orange)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Text("Rs. \(String(format: "%.0f", test.price))")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
                .padding(10)
                .background(Color.gray.opacity(0.04))
                .cornerRadius(10)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
    
    private func colorFor(_ status: ApprovalStatus) -> Color {
        switch status {
        case .pending:  return .orange
        case .approved: return .green
        case .rejected: return .red
        }
    }
}

// MARK: - Timeline

struct BookingTimeline: View {
    let booking: Appointment
    
    private var steps: [(String, String, Bool)] {
        if booking.type == .opd {
            return opdSteps
        } else {
            return labSteps
        }
    }
    
    private var opdSteps: [(String, String, Bool)] {
        let s = booking.status
        return [
            ("Booked", "Appointment created", true),
            ("Payment", booking.paymentCompleted ? "Payment completed" : "Awaiting payment", booking.paymentCompleted),
            ("Confirmed", "Appointment confirmed", s == .confirmed || s == .inProgress || s == .completed),
            ("In Progress", "Consultation started", s == .inProgress || s == .completed),
            ("Completed", "Visit completed", s == .completed),
        ]
    }
    
    private var labSteps: [(String, String, Bool)] {
        let requiresApproval = booking.requiresApproval ?? false
        let approval = booking.approvalStatus
        let paid = booking.paymentCompleted
        let s = booking.status
        
        var result: [(String, String, Bool)] = [
            ("Booked", "Lab check-in created", true),
        ]
        
        if requiresApproval {
            let approved = approval == .approved
            let rejected = approval == .rejected
            result.append(("Approval", rejected ? "Approval rejected" : (approved ? "Doctor approved" : "Awaiting doctor approval"), approved || rejected))
        }
        
        result.append(("Payment", paid ? "Payment completed" : "Awaiting payment", paid))
        result.append(("Confirmed", "Check-in confirmed", s == .confirmed || s == .inProgress || s == .completed))
        result.append(("Completed", "Tests completed", s == .completed))
        
        return result
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Progress")
                .font(.headline)
            
            VStack(spacing: 0) {
                ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                    HStack(alignment: .top, spacing: 14) {
                        // Timeline indicator
                        VStack(spacing: 0) {
                            ZStack {
                                Circle()
                                    .fill(step.2 ? Color.blue : Color.gray.opacity(0.2))
                                    .frame(width: 28, height: 28)
                                
                                if step.2 {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundColor(.white)
                                } else {
                                    Text("\(index + 1)")
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            if index < steps.count - 1 {
                                Rectangle()
                                    .fill(step.2 ? Color.blue.opacity(0.3) : Color.gray.opacity(0.15))
                                    .frame(width: 2, height: 28)
                            }
                        }
                        
                        // Step content
                        VStack(alignment: .leading, spacing: 3) {
                            Text(step.0)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(step.2 ? .primary : .secondary)
                            
                            Text(step.1)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.bottom, index < steps.count - 1 ? 8 : 0)
                        
                        Spacer()
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Payment Info

struct PaymentInfoCard: View {
    let booking: Appointment
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Payment")
                    .font(.headline)
                
                Spacer()
                
                Text(booking.paymentCompleted ? "Paid" : "Unpaid")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(booking.paymentCompleted ? .green : .red)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background((booking.paymentCompleted ? Color.green : Color.red).opacity(0.1))
                    .cornerRadius(8)
            }
            
            HStack {
                Text("Total Amount")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text("Rs. \(String(format: "%.2f", booking.amount))")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Queue Info

struct QueueInfoCard: View {
    let queueNumber: Int
    let estimatedWait: Int
    let room: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Queue Information")
                .font(.headline)
            
            HStack(spacing: 16) {
                VStack(spacing: 4) {
                    Text("Queue #")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(queueNumber)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
                .frame(maxWidth: .infinity)
                
                VStack(spacing: 4) {
                    Text("Est. Wait")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("~\(estimatedWait) min")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.orange)
                }
                .frame(maxWidth: .infinity)
                
                if let room = room {
                    VStack(spacing: 4) {
                        Text("Room")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(room)
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    NavigationView {
        BookingDetailView(
            booking: .constant(MockData.sampleBookings[2]),
            onPayNow: {}
        )
    }
}

