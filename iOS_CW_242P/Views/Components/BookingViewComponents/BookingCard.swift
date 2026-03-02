//
//  BookingCard.swift
//  iOS_CW_242P
//
//  Created by Liviru Navaratna on 2026-02-27.
//
import SwiftUI

struct BookingCard: View {
    let booking: Appointment
    
    private var typeColor: Color {
        booking.type == .opd ? .blue : .green
    }
    
    private var statusColor: Color {
        // Override for awaiting payment
        if booking.isAwaitingPayment {
            return .red
        }
        
        // Override for cancelled/rejected
        if booking.isCancelled || booking.approvalStatus == .rejected {
            return .gray
        }
        
        switch booking.status {
        case .pending:    return .orange
        case .confirmed:  return .blue
        case .inProgress: return .purple
        case .completed:  return .green
        case .cancelled:  return .gray
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Top row: type + status
            HStack {
                // Type badge
                HStack(spacing: 5) {
                    Image(systemName: booking.type == .opd ? "stethoscope" : "flask.fill")
                        .font(.caption2)
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
                
                // Status badge
                Text(statusDisplayText)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(statusColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(statusColor.opacity(0.1))
                    .cornerRadius(8)
            }
            
            // Main info
            HStack(spacing: 14) {
                // Date block
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
                    
                    HStack(spacing: 12) {
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .font(.caption2)
                            Text(booking.sessionDisplay)
                                .font(.caption)
                        }
                        .foregroundColor(.secondary)
                        
                        if let room = booking.doctorRoom {
                            HStack(spacing: 4) {
                                Image(systemName: "door.left.hand.open")
                                    .font(.caption2)
                                Text(room)
                                    .font(.caption)
                            }
                            .foregroundColor(.secondary)
                        }
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Action row for awaiting payment - Highly Visible Warning
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
            }
            
            // Quick Action Buttons Row - Journey & Prescription
            if booking.journeyId != nil || (booking.type == .opd && booking.hasPrescription == true) {
                Divider()
                    .padding(.vertical, 4)
                
                HStack(spacing: 12) {
                    // Journey Button - Shows for all bookings with journey
                    if booking.journeyId != nil {
                        NavigationLink(destination: Text("Journey Page, Coming Soon")) {
                            HStack(spacing: 6) {
                                Image(systemName: "figure.walk")
                                    .font(.subheadline)
                                    .foregroundColor(.purple)
                                Text("View Journey")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.purple)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.purple, lineWidth: 1.5)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    // Prescription Button - Only for OPD bookings with prescription
                    if booking.type == .opd && booking.hasPrescription == true {
                        NavigationLink(destination: Text("Pharmacy Stage, Coming soon")) {
                            HStack(spacing: 6) {
                                Image(systemName: "pills.fill")
                                    .font(.subheadline)
                                    .foregroundColor(.teal)
                                Text("Prescription")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.teal)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.teal, lineWidth: 1.5)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
        .padding(14)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
    
    // MARK: Helpers
    
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
}
