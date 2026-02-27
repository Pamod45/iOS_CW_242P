//
//  BookingSummaryView.swift
//  iOS_CW_242P
//
//  Created by Liviru Navaratna on 2026-02-27.
//

import SwiftUI

struct BookingSummaryRow: View {
    let bookings: [Appointment]
    
    private var upcoming: Int { bookings.filter { $0.isUpcoming }.count }
    private var pending: Int { bookings.filter { $0.isPendingApproval }.count }
    private var awaitingPay: Int { bookings.filter { $0.isAwaitingPayment }.count }
    
    var body: some View {
        HStack(spacing: 12) {
            SummaryMini(value: "\(upcoming)", label: "Upcoming", color: .blue, icon: "calendar")
            SummaryMini(value: "\(pending)", label: "Pending", color: .orange, icon: "clock")
            SummaryMini(value: "\(awaitingPay)", label: "To Pay", color: .red, icon: "creditcard")
        }
    }
}
