//
//  EmptyBookingsView.swift
//  iOS_CW_242P
//
//  Created by Liviru Navaratna on 2026-02-27.
//

import SwiftUI

struct EmptyBookingsView: View {
    let typeFilter: BookingTypeFilter
    let statusFilter: BookingStatusFilter
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 48))
                .foregroundColor(.gray.opacity(0.4))
            
            Text("No Bookings Found")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("No \(typeFilter == .all ? "" : typeFilter.rawValue.lowercased() + " ")\(statusFilter == .all ? "" : statusFilter.rawValue.lowercased() + " ")bookings to show.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
}
