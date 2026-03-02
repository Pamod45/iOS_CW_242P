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
    @State private var selectedPaymentMethod: PaymentMethod? = nil
    
    enum PaymentMethod: String, CaseIterable, Hashable {
        case applePay = "Apple Pay"
        case card = "Credit/Debit Card"
        
        var icon: String {
            switch self {
            case .applePay: return "apple.logo"
            case .card: return "creditcard.fill"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    if showSuccess {
                        // SUCCESS VIEW - Similar to OPD QueueTrackingView
                        
                        // Success Icon
                        ZStack {
                            Circle()
                                .fill(Color.green.opacity(0.1))
                                .frame(width: 100, height: 100)
                            
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.green)
                        }
                        .padding(.top, 20)
                        
                        VStack(spacing: 8) {
                            Text("Payment Successful!")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("Your lab appointment has been confirmed")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        // Queue Number - Large Display
                        if let queue = booking.queueNumber, let wait = booking.estimatedWaitTime {
                            VStack(spacing: 12) {
                                Text("Your Queue Number")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Text("\(queue)")
                                    .font(.system(size: 80, weight: .bold))
                                    .foregroundColor(.blue)
                                
                                HStack(spacing: 8) {
                                    Circle()
                                        .fill(Color.green)
                                        .frame(width: 8, height: 8)
                                    Text("Active")
                                        .font(.subheadline)
                                        .foregroundColor(.green)
                                }
                            }
                            .padding(.vertical, 20)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.05))
                            .cornerRadius(16)
                            .padding(.horizontal)
                            
                            // Queue Stats
                            HStack(spacing: 20) {
                                VStack(spacing: 8) {
                                    Image(systemName: "clock.fill")
                                        .font(.title3)
                                        .foregroundColor(.orange)
                                    
                                    Text("~\(wait) min")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                    
                                    Text("Wait Time")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.orange.opacity(0.08))
                                .cornerRadius(12)
                                
                                VStack(spacing: 8) {
                                    Image(systemName: "flask.fill")
                                        .font(.title3)
                                        .foregroundColor(.green)
                                    
                                    Text("Lab")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                    
                                    Text("Location")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.green.opacity(0.08))
                                .cornerRadius(12)
                            }
                            .padding(.horizontal)
                        }
                        
                        // Booking Details Summary
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Booking Details")
                                .font(.headline)
                            
                            VStack(spacing: 12) {
                                HStack {
                                    Image(systemName: "calendar")
                                        .foregroundColor(.blue)
                                    Text("Date")
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text(booking.displayDate)
                                        .fontWeight(.semibold)
                                }
                                
                                Divider()
                                
                                HStack {
                                    Image(systemName: "clock")
                                        .foregroundColor(.purple)
                                    Text("Session")
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text(booking.sessionDisplay)
                                        .fontWeight(.semibold)
                                }
                                
                                if let tests = booking.labTests {
                                    Divider()
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack {
                                            Image(systemName: "flask.fill")
                                                .foregroundColor(.green)
                                            Text("Tests")
                                                .foregroundColor(.secondary)
                                        }
                                        
                                        ForEach(tests) { test in
                                            Text("• \(test.name)")
                                                .font(.subheadline)
                                                .padding(.leading, 24)
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        
                        // Important Information
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "info.circle.fill")
                                    .foregroundColor(.blue)
                                Text("Important Information")
                                    .font(.headline)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                InfoBullet(text: "Please arrive at least 10 minutes before your turn")
                                InfoBullet(text: "Follow the preparation requirements for your tests")
                                InfoBullet(text: "You'll receive a notification when it's almost your turn")
                                InfoBullet(text: "Keep your queue number for reference")
                            }
                        }
                        .padding()
                        .background(Color.blue.opacity(0.05))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        
                        // Done Button
                        PrimaryButton(
                            title: "Done",
                            action: {
                                onPaymentComplete()
                            },
                            isLoading: false,
                            isDisabled: false
                        )
                        .padding(.horizontal)
                        
                    } else {
                        // PAYMENT VIEW - Original payment form
                        
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
                        
                        // Payment Method Selection
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Select Payment Method")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            VStack(spacing: 12) {
                                ForEach(PaymentMethod.allCases, id: \.rawValue) { method in
                                    Button(action: {
                                        selectedPaymentMethod = method
                                    }) {
                                        PaymentMethodCard(
                                            icon: method.icon,
                                            title: method.rawValue,
                                            isSelected: selectedPaymentMethod == method
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        Spacer()
                        
                        // Pay button
                        PrimaryButton(
                            title: "Pay Rs. \(String(format: "%.2f", booking.amount))",
                            action: {
                                processPayment()
                            },
                            isLoading: isProcessing,
                            isDisabled: selectedPaymentMethod == nil
                        )
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 40)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(showSuccess ? "Payment Confirmed" : "Payment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if !showSuccess {
                        Button("Cancel") { dismiss() }
                    }
                }
            }
        }
        .interactiveDismissDisabled(showSuccess)
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
