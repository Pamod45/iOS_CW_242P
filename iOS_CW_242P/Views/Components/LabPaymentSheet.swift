//
//  LabPaymentSheet.swift
//  iOS_CW_242P
//
//  Created by Liviru Navaratna on 2026-02-27.
//

import SwiftUI

struct LabPaymentSheet: View {
    let booking: Appointment
    let onPaymentComplete: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var isProcessing = false
    @State private var showSuccess = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "creditcard.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.blue)
                        .frame(width: 80, height: 80)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(20)
                    
                    Text("Complete Payment")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Text("Pay for your approved lab tests")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)
                
                // Tests summary
                VStack(alignment: .leading, spacing: 12) {
                    Text("Lab Tests")
                        .font(.headline)
                    
                    if let tests = booking.labTests {
                        ForEach(tests) { test in
                            HStack {
                                Image(systemName: "flask.fill")
                                    .foregroundColor(.green)
                                    .font(.caption)
                                
                                Text(test.name)
                                    .font(.subheadline)
                                
                                Spacer()
                                
                                Text("Rs. \(String(format: "%.2f", test.price))")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Total")
                            .font(.headline)
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
                .padding(.horizontal)
                
                // Date & Session
                HStack(spacing: 16) {
                    InfoCard(
                        title: "Date",
                        value: booking.displayDate,
                        icon: "calendar",
                        iconColor: .blue
                    )
                    InfoCard(
                        title: "Session",
                        value: booking.sessionDisplay,
                        icon: "clock",
                        iconColor: .purple
                    )
                }
                .padding(.horizontal)
                
                Spacer()
                
                if showSuccess {
                    HStack(spacing: 10) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Payment Successful!")
                            .font(.headline)
                            .foregroundColor(.green)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                
                // Pay button
                PrimaryButton(
                    title: showSuccess ? "Done" : "Pay Rs. \(String(format: "%.2f", booking.amount))",
                    action: {
                        if showSuccess {
                            onPaymentComplete()
                        } else {
                            processPayment()
                        }
                    },
                    isLoading: isProcessing,
                    isDisabled: false
                )
                .padding(.horizontal)
                .padding(.bottom)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Payment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
    
    private func processPayment() {
        isProcessing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isProcessing = false
            showSuccess = true
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
    }
}
