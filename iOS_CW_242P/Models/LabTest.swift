//
//  LabTest.swift
//  iOS_CW_242P
//
//  Created by Pubudu Perera on 2026-02-25.
//
import Foundation

enum LabTestCategory: String, Codable, CaseIterable {
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
    static var noApprovalTests: [LabTest] {
        MockData.sampleTests.filter { $0.category == .noApprovalRequired }
    }
    
    static var approvalRequiredTests: [LabTest] {
        MockData.sampleTests.filter { $0.category == .approvalRequired }
    }
}


