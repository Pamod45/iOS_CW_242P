//
//  BookingInfoRow.swift
//  iOS_CW_242P
//
//  Created by Liviru Navaratna on 2026-03-02.
//

import SwiftUI

struct BookingInfoRow: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
        
    @Binding var showCancelConfirmation: Bool
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon == "medical_report_link" ? "doc.text.fill" : icon)
                .font(.subheadline)
                .foregroundColor(color)
                .frame(width: 24)
            
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            if icon == "note" || icon == "doc.text.fill" {
                Button("Download") {
                    showCancelConfirmation = true
                }
                .font(.footnote)
            }
            else if (icon == "medical_report_link"){
                NavigationLink(destination: PrescriptionView(appointment: MockData.sampleBookings.filter{ $0.id == value}.first!)) {
                    Text("Medical Report")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                }
            }
            else {
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)
            }
        }
    }
}

