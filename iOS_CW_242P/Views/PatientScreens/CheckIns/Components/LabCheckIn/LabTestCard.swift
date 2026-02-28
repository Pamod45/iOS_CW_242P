//
//  LabTestcard.swift
//  iOS_CW_242P
//
//  Created by Pubudu Perera on 2026-02-28.
//
import SwiftUI
struct LabTestCard: View {
    let test: LabTest
    let isSelected: Bool
    let action: () -> Void
    
    @State private var showDetails = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(test.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(test.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                    
                    HStack(spacing: 16) {
                        Label("\(test.duration) min", systemImage: "clock")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("LKR \(test.price, specifier: "%.2f")")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                    
                    if test.category == .approvalRequired {
                        HStack(spacing: 4) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.caption)
                            Text("Requires Approval")
                                .font(.caption)
                        }
                        .foregroundColor(.orange)
                    }
                }
                
                Spacer()
                
                VStack(spacing: 8) {
                    Button(action: action) {
                        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                            .font(.title2)
                            .foregroundColor(isSelected ? .blue : .gray)
                    }
                    
                    Button(action: { showDetails = true }) {
                        Image(systemName: "info.circle")
                            .font(.title3)
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
        )
        .sheet(isPresented: $showDetails) {
            LabTestDetailView(test: test)
        }
    }
}
