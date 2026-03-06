//
//  PaymentView.swift
//  iOS_CW_242P
//
//  Created by Pubudu Perera on 2026-03-01.
//

import SwiftUI

struct PaymentView: View {
    enum PaymentMethod {
        case cardPayment
        case applePay
    }

    let selectedDate: Date
    let selectedSession: Session?
    let reasonForVisit: String
    let onPaymentComplete: () -> Void
    
    let consultationFee: Double = 1500.00
    @State private var selectedPaymentMethod: PaymentMethod = .cardPayment
    
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
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("LKR \(consultationFee, specifier: "%.2f")")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Total to Pay")
                            .font(.headline)
                            .fontWeight(.semibold)
                        Spacer()
                        Text("LKR \(consultationFee, specifier: "%.2f")")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color(.separator).opacity(0.55), lineWidth: 1)
                )
                .cornerRadius(14)
                .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 6)
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Payment Method")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    PaymentMethodCard(icon: "creditcard.fill", title: "Credit/Debit Card", isSelected: selectedPaymentMethod == .cardPayment)
                        .padding(.horizontal)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                selectedPaymentMethod = .cardPayment
                            }
                        }

                    PaymentMethodCard(icon: "apple.logo", title: "Apple Pay", isSelected: selectedPaymentMethod == .applePay)
                        .padding(.horizontal)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                selectedPaymentMethod = .applePay
                            }
                        }
                }
            }
            .padding(.bottom, 40)
        }
    }
}

#Preview {
    PaymentView(
        selectedDate: Date(),selectedSession: MockData.sessions[0], reasonForVisit: "Headache",
        onPaymentComplete: {}
    )
}
