//
//  PaymentView.swift
//  iOS_CW_242P
//
//  Created by Pubudu Perera on 2026-03-01.
//

import SwiftUI

struct PaymentView: View {
    let selectedDate: Date
    let selectedSession: Session?
    let reasonForVisit: String
    let onPaymentComplete: () -> Void
    
    let consultationFee: Double = 1500.00
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Payment Summary")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Review your appointment details")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                .padding(.top)
                
                VStack(alignment: .leading, spacing: 16) {
                    SummaryRow(
                        icon: "calendar",
                        label: "Date",
                        value: selectedDate.formatted(date: .long, time: .omitted)
                    )
                    
                    if let session = selectedSession {
                        SummaryRow(
                            icon: "clock",
                            label: "Session",
                            value: session.displayTime
                        )
                        
                        SummaryRow(
                            icon: "number",
                            label: "Current Queue",
                            value: "\(session.currentQueueNumber)"
                        )
                        
                        SummaryRow(
                            icon: "hourglass",
                            label: "Estimated Wait",
                            value: "~\(session.averageConsultationTimeInMinutes * session.currentQueueNumber) minutes"
                        )
                    }
                    
                    SummaryRow(
                        icon: "door.left.hand.open",
                        label: "Doctor Room",
                        value: "Room 105"
                    )
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .padding(.horizontal)
                
                VStack(spacing: 12) {
                    HStack {
                        Text("Consultation Fee")
                            .font(.headline)
                        Spacer()
                        Text("LKR \(consultationFee, specifier: "%.2f")")
                            .font(.headline)
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Total Amount")
                            .font(.title3)
                            .fontWeight(.bold)
                        Spacer()
                        Text("LKR \(consultationFee, specifier: "%.2f")")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Payment Method")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    PaymentMethodCard(icon: "creditcard.fill", title: "Credit/Debit Card", isSelected: true)
                        .padding(.horizontal)
                }
            }
            .padding(.bottom, 40)
        }
    }
}
