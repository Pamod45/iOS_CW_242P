//
//  LabTestSelectionView.swift
//  iOS_CW_242P
//
//  Created by Pubudu Perera on 2026-02-28.
//
import SwiftUI

struct LabTestSelectionView: View {
    @Binding var selectedTests: [LabTest]
    @State private var selectedCategory: LabTestCategory = .allCategories
    
    @State private var searchText: String = ""
    
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
            
            HStack(spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)

                    TextField("Search lab tests", text: $searchText)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .submitLabel(.search)

                    if !searchText.isEmpty {
                        Button {
                            searchText = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                Button {
                    
                } label: {
                    Image(systemName: "line.3.horizontal.decrease")
                        .font(.title3)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Filters")
            }
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
        LabTest.filteredTests(by: searchText, in: selectedCategory)
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

#Preview{
    LabTestSelectionView(selectedTests: .constant(Array(MockData.sampleTests.prefix(2))))
}
