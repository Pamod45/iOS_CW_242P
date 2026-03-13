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
    @Binding var showRecieptDownload: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Booking Information")
                .font(.headline)
            
            VStack(spacing: 14) {
                
                BookingInfoRow(icon: "number", label: "Booking ID", value: booking.id.prefix(12).uppercased().description, color: iconColor, showCancelConfirmation: $showCancelConfirmation)
                
                Divider()
                
                BookingInfoRow(icon: "calendar", label: "Date", value: booking.displayDate, color: iconColor, showCancelConfirmation: $showCancelConfirmation )
                
                Divider()
                
                BookingInfoRow(icon: "clock", label: "Session", value: booking.sessionDisplay, color: iconColor, showCancelConfirmation: $showCancelConfirmation)
                
                if booking.type == .opd {
                    if let doctorName = booking.doctorName {
                        Divider()
                        BookingInfoRow(icon: "person.fill", label: "Doctor", value: doctorName, color: iconColor, showCancelConfirmation: $showCancelConfirmation)
                    }
                    
                    Divider()
                    
                    BookingInfoRow(icon: "text.bubble", label: "Reason", value: booking.reasonForVisit ?? "N/A", color: iconColor, showCancelConfirmation: $showCancelConfirmation)
                    
                    if let room = booking.doctorRoom {
                        Divider()
                        BookingInfoRow(icon: "door.left.hand.open", label: "Room", value: room, color: iconColor, showCancelConfirmation: $showCancelConfirmation)
                    }
                }
                
                if booking.type == .opd && (booking.medications != nil || booking.prescribedLabTests != nil) {
                    
                    Divider()
                    BookingInfoRow(icon: "medical_report_link", label: "Medical Reports", value: booking.id, color: iconColor, showCancelConfirmation: $showCancelConfirmation)
                    
                }
                
                if booking.requiresApproval == true {
                    Divider()
                    BookingInfoRow(icon: "note", label: "Doctor Note (Proof doc)", value:"Uploaded", color: iconColor, showCancelConfirmation: $showCancelConfirmation)
                }
                
                if booking.type == .laboratory && booking.status == .completed {
                    Divider()
                    BookingInfoRow(icon: "doc.text.fill", label: "Lab Report", value:"Completed", color: iconColor, showCancelConfirmation: $showCancelConfirmation)
                }
                
                if booking.status == .confirmed || booking.status == .completed || booking.status == .inProgress {
                    Divider()
                    BookingInfoRow(icon: "doc.text.fill", label: "Appointment Receipt", value:"Completed", color: iconColor, showCancelConfirmation: $showRecieptDownload)
                }
                
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
}

