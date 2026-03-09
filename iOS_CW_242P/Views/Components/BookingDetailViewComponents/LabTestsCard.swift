//
//  LabTestsCard.swift
//  iOS_CW_242P
//
//  Created by Liviru Navaratna on 2026-03-02.
//

import SwiftUI

struct LabTestsCard: View {
    let tests: [LabTest]
    let approvalStatus: ApprovalStatus?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Lab Tests")
                    .font(.headline)
                Spacer()
                
                if let status = approvalStatus {
                    Text(status.rawValue)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(colorFor(status))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(colorFor(status).opacity(0.1))
                        .cornerRadius(8)
                }
            }
            
            ForEach(tests) { test in
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "flask.fill")
                        .font(.caption)
                        .foregroundColor(.green)
                        .frame(width: 32, height: 32)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(8)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(test.name)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        Text(test.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                        
                        HStack(spacing: 12) {
                            HStack(spacing: 4) {
                                Image(systemName: "clock")
                                    .font(.caption2)
                                Text("\(test.duration) min")
                                    .font(.caption)
                            }
                            .foregroundColor(.secondary)
                            
                            if let prep = test.preparationRequired {
                                HStack(spacing: 4) {
                                    Image(systemName: "exclamationmark.triangle")
                                        .font(.caption2)
                                    Text(prep)
                                        .font(.caption)
                                }
                                .foregroundColor(.orange)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Text("Rs. \(String(format: "%.0f", test.price))")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
                .padding(10)
                .background(Color.gray.opacity(0.04))
                .cornerRadius(10)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
    
    private func colorFor(_ status: ApprovalStatus) -> Color {
        switch status {
        case .pending:  return .orange
        case .approved: return .green
        case .rejected: return .red
        }
    }
}
