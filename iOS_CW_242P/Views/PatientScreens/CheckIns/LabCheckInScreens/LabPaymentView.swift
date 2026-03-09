//
//  LabPaymentView.swift
//  iOS_CW_242P
//
//  Created by Pubudu Perera on 2026-03-01.
//

import SwiftUI

struct LabPaymentView: View {
    enum PaymentMethod {
        case cardPayment
        case applePay
    }

    let selectedTests: [LabTest]
    let selectedSession: Session?
    let selectedDate: Date?
    let onPaymentComplete: () -> Void
    @State private var selectedPaymentMethod: PaymentMethod = .cardPayment

    private var approvalRequiredTests: [LabTest] {
        selectedTests.filter { $0.category == .approvalRequired }
    }

    private var payableTests: [LabTest] {
        selectedTests.filter { $0.category != .approvalRequired }
    }

    private var payableSubtotal: Double {
        payableTests.reduce(0) { $0 + $1.price }
    }

    private var approvalRequiredSubtotal: Double {
        approvalRequiredTests.reduce(0) { $0 + $1.price }
    }

    private var totalSelectedSubtotal: Double {
        selectedTests.reduce(0) { $0 + $1.price }
    }

    var longestDuration: Int {
        selectedTests.map { $0.duration }.max() ?? 0
    }

    var requiresApproval: Bool {
        !approvalRequiredTests.isEmpty
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Payment Summary")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Review your lab test details")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                .padding(.top)

                if requiresApproval {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Awaiting Approval (\(approvalRequiredTests.count))")
                            .font(.headline)

                        ForEach(approvalRequiredTests) { test in
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
                                Text("Pay after approval")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                    .background(Color(.tertiarySystemFill))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }

                if !payableTests.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Pay Now (\(payableTests.count))")
                            .font(.headline)
                            .padding(.horizontal)

                        ForEach(payableTests) { test in
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
                }

                if let session = selectedSession {
                    VStack(alignment: .leading, spacing: 14) {
                        HStack(spacing: 10) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Appointment Details")
                                    .font(.headline)
                                Text("\(payableTests.count) pay now • \(approvalRequiredTests.count) needs approval")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }

                            Spacer()
                        }

                        VStack(spacing: 10) {
                            SummaryRow(
                                icon: "calendar",
                                label: "Date",
                                value: selectedDate != nil
                                    ? DateFormatter.localizedString(from: selectedDate!, dateStyle: .medium, timeStyle: .none)
                                    : "N/A"
                            )
                            SummaryRow(icon: "clock", label: "Session", value: session.displayTime)
                            SummaryRow(icon: "number", label: "Current Queue", value: "\(session.currentQueueNumber)")
                            SummaryRow(icon: "hourglass", label: "Expected Duration", value: "\(longestDuration) minutes")
                            SummaryRow(icon: "mappin", label: "Location", value: "Lab Room 1")
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color(.separator).opacity(0.35), lineWidth: 1)
                    )
                    .cornerRadius(14)
                    .padding(.horizontal)
                }

                if !payableTests.isEmpty {
                    VStack(spacing: 12) {
                        HStack {
                            Text("Subtotal (Pay Now)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("LKR \(payableSubtotal, specifier: "%.2f")")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                        }

                        if !approvalRequiredTests.isEmpty {
                            HStack {
                                Text("Subtotal (Needs Approval)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text("LKR \(approvalRequiredSubtotal, specifier: "%.2f")")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.secondary)
                            }

                            HStack {
                                Text("Selected Total")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text("LKR \(totalSelectedSubtotal, specifier: "%.2f")")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.secondary)
                            }
                        }

                        Divider()

                        HStack {
                            Text("Total to Pay Now")
                                .font(.headline)
                                .fontWeight(.semibold)
                            Spacer()
                            Text("LKR \(payableSubtotal, specifier: "%.2f")")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                        }

                        if requiresApproval {
                            Text("Approval-required tests are paid after approval.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
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
            }
            .padding(.bottom, 40)
        }
    }
}

#Preview {
    LabPaymentView(
        selectedTests: Array(MockData.sampleTests.prefix(2)),
        selectedSession: MockData.sessions.first, selectedDate: Date(),
        onPaymentComplete: {}
    )
}
