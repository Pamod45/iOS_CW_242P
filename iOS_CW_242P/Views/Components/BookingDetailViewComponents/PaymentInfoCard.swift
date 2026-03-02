//
//  PaymentInfoCard.swift
//  iOS_CW_242P
//
//  Created by Liviru Navaratna on 2026-03-02.
//

import SwiftUI

struct PaymentInfoCard: View {
    let booking: Appointment
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Payment")
                    .font(.headline)
                
                Spacer()
                
                Text(booking.paymentCompleted ? "Paid" : "Unpaid")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(booking.paymentCompleted ? .green : .red)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background((booking.paymentCompleted ? Color.green : Color.red).opacity(0.1))
                    .cornerRadius(8)
            }
            
            HStack {
                Text("Total Amount")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text("Rs. \(String(format: "%.2f", booking.amount))")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
}

