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
    
    @Binding var showCancelConfirmation: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Booking Information")
                .font(.headline)
            
            VStack(spacing: 14) {
                BookingInfoRow(icon: "calendar", label: "Date", value: booking.displayDate, color: iconColor, showCancelConfirmation: $showCancelConfirmation )
                
                Divider()
                
                BookingInfoRow(icon: "clock", label: "Session", value: booking.sessionDisplay, color: iconColor, showCancelConfirmation: $showCancelConfirmation)
                
                if booking.type == .opd {
                    Divider()
                    
                    BookingInfoRow(icon: "text.bubble", label: "Reason", value: booking.reasonForVisit ?? "N/A", color: iconColor, showCancelConfirmation: $showCancelConfirmation)
                    
                    if let room = booking.doctorRoom {
                        Divider()
                        BookingInfoRow(icon: "door.left.hand.open", label: "Room", value: room, color: iconColor, showCancelConfirmation: $showCancelConfirmation)
                    }
                }
                
                Divider()
                
                BookingInfoRow(icon: "number", label: "Booking ID", value: booking.id.prefix(12).uppercased().description, color: iconColor, showCancelConfirmation: $showCancelConfirmation)
                
                
                if booking.requiresApproval == true {
                    Divider()
                    BookingInfoRow(icon: "note", label: "Doctor Note (Proof doc)", value:"Uploaded", color: iconColor, showCancelConfirmation: $showCancelConfirmation)
                }
                
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
}

