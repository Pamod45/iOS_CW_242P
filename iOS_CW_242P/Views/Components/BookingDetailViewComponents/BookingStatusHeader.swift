//
//  BookingStatusHeader.swift
//  iOS_CW_242P
//
//  Created by Liviru Navaratna on 2026-03-02.
//

import SwiftUI

struct BookingStatusHeader: View {
    let booking: Appointment
    
    private var statusColor: Color {
        if booking.isPendingApproval { return .orange }
        if booking.isAwaitingPayment { return .red }
        if booking.approvalStatus == .rejected { return .gray }
        switch booking.status {
        case .pending:    return .orange
        case .confirmed:  return .blue
        case .inProgress: return .purple
        case .completed:  return .green
        case .cancelled:  return .gray
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

