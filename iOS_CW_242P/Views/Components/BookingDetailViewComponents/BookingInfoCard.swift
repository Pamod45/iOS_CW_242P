//
//  BookingInfoCard.swift
//  iOS_CW_242P
//
//  Created by Liviru Navaratna on 2026-03-02.
//

import SwiftUI

struct BookingInfoCard: View {
    let booking: Appointment
    let iconColor: Color = .gray
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Booking Information")
                .font(.headline)
            
            VStack(spacing: 14) {
                BookingInfoRow(icon: "calendar", label: "Date", value: booking.displayDate, color: iconColor)
                
                Divider()
                
                BookingInfoRow(icon: "clock", label: "Session", value: booking.sessionDisplay, color: iconColor)
                
                if booking.type == .opd {
                    Divider()
                    
                    BookingInfoRow(icon: "text.bubble", label: "Reason", value: booking.reasonForVisit ?? "N/A", color: iconColor)
                    
                    if let room = booking.doctorRoom {
                        Divider()
                        BookingInfoRow(icon: "door.left.hand.open", label: "Room", value: room, color: iconColor)
                    }
                }
                
                Divider()
                
                BookingInfoRow(icon: "number", label: "Booking ID", value: booking.id.prefix(12).uppercased().description, color: iconColor)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
}

