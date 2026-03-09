//
//  LabTest.swift
//  iOS_CW_242P
//
//  Created by Pubudu Perera on 2026-02-25.
//
import Foundation

enum LabTestCategory: String, Codable, CaseIterable {
    case allCategories = "All Categories"
    case noApprovalRequired = "No Approval Required"
    case approvalRequired = "Doctor Approval Required"
}

struct LabTest: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let description: String
    let price: Double
    let duration: Int
    let category: LabTestCategory
    let instructions: String?
    let preparationRequired: String?
    
    static func == (lhs: LabTest, rhs: LabTest) -> Bool {
        lhs.id == rhs.id
    }
}

extension LabTest {
    
    static var allTests: [LabTest] {
        MockData.sampleTests
    }
    
    static var noApprovalTests: [LabTest] {
        MockData.sampleTests.filter { $0.category == .noApprovalRequired }
    }
    
    static var approvalRequiredTests: [LabTest] {
        MockData.sampleTests.filter { $0.category == .approvalRequired }
    }
    
    static func filteredTests(by searchText: String, in category: LabTestCategory = .allCategories) -> [LabTest] {
        let tests: [LabTest]
        
        switch category {
        case .allCategories:
            tests = allTests
        case .noApprovalRequired:
            tests = noApprovalTests
        case .approvalRequired:
            tests = approvalRequiredTests
        }
        
        if searchText.isEmpty {
            return tests
        }
        
        return tests.filter { test in
            test.name.localizedCaseInsensitiveContains(searchText)
        }
    }
}


