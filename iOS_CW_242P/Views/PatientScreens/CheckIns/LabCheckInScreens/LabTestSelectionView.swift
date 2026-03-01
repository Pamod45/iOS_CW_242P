//
//  LabTestSelectionView.swift
//  iOS_CW_242P
//
//  Created by Pubudu Perera on 2026-02-28.
//
import SwiftUI

struct LabTestSelectionView: View {
    @Binding var selectedTests: [LabTest]
    @State private var selectedCategory: LabTestCategory = .noApprovalRequired
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Select Lab Tests")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("Choose one or more tests. Tap for details.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
            Picker("Category", selection: $selectedCategory) {
                Text("No Approval Required").tag(LabTestCategory.noApprovalRequired)
                Text("Approval Required").tag(LabTestCategory.approvalRequired)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            if !selectedTests.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(selectedTests) { test in
                            TestCartBadge(test: test) {
                                selectedTests.removeAll { $0.id == test.id }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(height: 50)
            }
            
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(getFilteredTests()) { test in
                        LabTestCard(
                            test: test,
                            isSelected: selectedTests.contains(test)
                        ) {
                            toggleTest(test)
                        }
                    }
                }
                .padding()
            }
        }
    }
    
    private func getFilteredTests() -> [LabTest] {
        MockData.sampleTests.filter { $0.category == selectedCategory }
    }
    
    private func toggleTest(_ test: LabTest) {
        if selectedTests.contains(test) {
            selectedTests.removeAll { $0.id == test.id }
        } else {
            selectedTests.append(test)
        }
    }
}

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

struct TestCartBadge: View {
    let test: LabTest
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 8) {
            Text(test.name)
                .font(.caption)
                .lineLimit(1)
            
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .font(.caption)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.blue.opacity(0.1))
        .foregroundColor(.blue)
        .cornerRadius(20)
    }
}
