//
//  LabPaymentView.swift
//  iOS_CW_242P
//
//  Created by Pubudu Perera on 2026-03-01.
//

import SwiftUI

struct LabPaymentView: View {
    let selectedTests: [LabTest]
    let selectedSession: Session?
    let onPaymentComplete: () -> Void
    
    var totalAmount: Double {
        selectedTests.reduce(0) { $0 + $1.price }
    }
    
    var longestDuration: Int {
        selectedTests.map { $0.duration }.max() ?? 0
    }
    
    var requiresApproval: Bool {
        selectedTests.contains { $0.category == .approvalRequired }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(requiresApproval ? "Approval Request" : "Payment Summary")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text(requiresApproval ? "Review and submit for approval" : "Review your lab test details")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                .padding(.top)
                
                if requiresApproval {
                    HStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.title2)
                            .foregroundColor(.orange)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Approval Required")
                                .font(.headline)
                                .foregroundColor(.primary)
                            Text("You can pay after doctor approval")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Selected Tests (\(selectedTests.count))")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ForEach(selectedTests) { test in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(test.name)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Text("\(test.duration) minutes")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Text("LKR \(test.price, specifier: "%.2f")")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                
                if let session = selectedSession {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Session Details")
                            .font(.headline)
                        
                        SummaryRow(icon: "clock", label: "Session", value: session.displayTime)
                        SummaryRow(icon: "hourglass", label: "Expected Duration", value: "\(longestDuration) minutes")
                        SummaryRow(icon: "mappin", label: "Location", value: "Lab Room 1")
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                
                VStack(spacing: 12) {
                    ForEach(selectedTests) { test in
                        HStack {
                            Text(test.name)
                                .font(.subheadline)
                            Spacer()
                            Text("LKR \(test.price, specifier: "%.2f")")
                                .font(.subheadline)
                        }
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Total Amount")
                            .font(.title3)
                            .fontWeight(.bold)
                        Spacer()
                        Text("LKR \(totalAmount, specifier: "%.2f")")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
                
                if !requiresApproval {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Payment Method")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        PaymentMethodCard(icon: "creditcard.fill", title: "Credit/Debit Card", isSelected: true)
                            .padding(.horizontal)
                    }
                }
            }
            .padding(.bottom, 40)
        }
    }
}
