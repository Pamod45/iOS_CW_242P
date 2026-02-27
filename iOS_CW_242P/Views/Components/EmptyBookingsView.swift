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
        Text("No bookings yet")
            .font(.title)
            .padding()
    }
}
