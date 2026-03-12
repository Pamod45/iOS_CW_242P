//
//  BookingCard.swift
//  iOS_CW_242P
//
//  Created by Liviru Navaratna on 2026-02-27.
//
import SwiftUI

struct BookingCard: View {
    let booking: Appointment
    let onPayNow: () -> Void
    
    private var typeColor: Color {
//        booking.type == .opd ? .blue : .green
        return Color.primary.opacity(0.8)
    }
    
    private var statusColor: Color {
        if booking.isAwaitingPayment {
            return .red
        }
        
        if booking.isCancelled || booking.approvalStatus == .rejected {
            return .gray
        }
        
        switch booking.status {
        case .pending:    return .orange
        case .confirmed:  return .blue
        case .inProgress: return .purple
        case .completed:  return .gray
        case .cancelled:  return .gray
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 5) {
                    Text(booking.type.rawValue)
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .foregroundColor(typeColor)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(typeColor.opacity(0.1))
                .cornerRadius(8)
                
                Spacer()
                
                Text(statusDisplayText)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(statusColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(statusColor.opacity(0.1))
                    .cornerRadius(8)
            }
            
            HStack(spacing: 14) {
                VStack(spacing: 2) {
                    Text(dayString)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.primary)
                    Text(monthString)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                }
                .frame(width: 48, height: 48)
                .background(Color.gray.opacity(0.08))
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(booking.type == .opd ? (booking.reasonForVisit ?? "Doctor Appointment") : labTestNames)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    if booking.type == .opd, let doctorName = booking.doctorName {
                        Text(doctorName)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.caption2)
                        Text(arrivalTime)
                            .font(.caption)
                    }
                    .foregroundColor(.secondary)
                    
                    if let room = booking.doctorRoom {
                        Text(room)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if booking.isAwaitingPayment {
                VStack(spacing: 0) {
                    Divider()
                        .padding(.vertical, 8)
                    
                    HStack(spacing: 10) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.white)
                            .font(.title3)
                        
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Payment Required")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Rs. \(String(format: "%.2f", booking.amount))")
                                .font(.title3)
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        VStack(spacing: 4) {
                            Image(systemName: "chevron.right.circle.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                            
                            Text("Pay Now")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.red, Color.red.opacity(0.85)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(10)
                    .shadow(color: .red.opacity(0.4), radius: 6, x: 0, y: 3)
                }
                .onTapGesture {
                    onPayNow()
                }
            }
        }
        .padding(14)
        .background(Color.white)
        .cornerRadius(12)

    }
        
    private var statusDisplayText: String {
        if booking.isPendingApproval { return "Pending Approval" }
        if booking.isAwaitingPayment { return "Awaiting Payment" }
        if booking.approvalStatus == .rejected { return "Rejected" }
        return booking.status.rawValue
    }
    
    private var labTestNames: String {
        booking.labTests?.map { $0.name }.joined(separator: ", ") ?? "Lab Tests"
    }
    
    private var dayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: booking.date)
    }
    
    private var monthString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.string(from: booking.date).uppercased()
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: booking.date)
    }
    
    private var arrivalTime: String {
        if let session = MockData.sessions.first(where: { $0.id == booking.sessionId }) {
            return session.displayTime
        }
        return booking.sessionDisplay
    }
}
