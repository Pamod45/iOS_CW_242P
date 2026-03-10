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
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundColor(color)
                .frame(width: 24)
            
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            if icon == "note" {
                Button("Download") {
                    showCancelConfirmation = true
                }
                .font(.footnote)
            } else {
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)
            }
        }
    }
}

