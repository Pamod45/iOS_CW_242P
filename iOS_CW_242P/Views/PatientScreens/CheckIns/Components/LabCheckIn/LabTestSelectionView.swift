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
