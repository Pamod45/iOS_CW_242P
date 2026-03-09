//
//  LabTestDetailView.swift
//  iOS_CW_242P
//
//  Created by Pubudu Perera on 2026-02-28.
//

import SwiftUI

struct LabTestDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let test: LabTest
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(test.name)
                            .font(.title2)
                            .fontWeight(.bold)
                        Text(test.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineSpacing(3)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top)

                    VStack(spacing: 12) {
                        SummaryRow(icon: "clock", label: "Duration", value: "\(test.duration) minutes")
                        SummaryRow(icon: "creditcard", label: "Price", value: String(format: "LKR %.2f", test.price))
                        SummaryRow(
                            icon: test.category == .approvalRequired ? "checkmark.shield" : "checkmark.circle",
                            label: "Approval",
                            value: test.category == .approvalRequired ? "Required" : "Not Required"
                        )
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.separator).opacity(0.3), lineWidth: 1)
                    )
                    .padding(.horizontal)

                    if let instructions = test.instructions {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Instructions")
                                .font(.headline)
                            Text(instructions)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineSpacing(3)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(.separator).opacity(0.3), lineWidth: 1)
                        )
                        .padding(.horizontal)
                    }

                    if let preparation = test.preparationRequired {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(spacing: 6) {
                                Image(systemName: "exclamationmark.circle")
                                    .foregroundColor(.orange)
                                Text("Preparation Required")
                                    .font(.headline)
                            }
                            Text(preparation)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineSpacing(3)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.orange.opacity(0.25), lineWidth: 1)
                        )
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom)
            }
            .background(Color(.systemGroupedBackground))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

struct LabTestDetailRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
        }
    }
}

#Preview {
    LabTestDetailView(
        test: MockData.sampleTests[0]
    )
}
