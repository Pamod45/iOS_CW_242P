//
//  User.swift
//  iOS_CW_242P
//
//  Created by Pubudu Perera on 2026-02-23.
//

import Foundation

enum UserRole: String, Codable {
    case patient = "Patient"
    case pharmacist = "Pharmacist"
}

enum AuthProvider: String, Codable {
    case phone = "phone"
    case google = "google"
    case apple = "apple"
}

struct User: Identifiable, Codable {
    let id: String
    var phoneNumber: String?
    var email: String?
    var name: String
    var age: Int
    var dateOfBirth: Date?
    var address: String?
    var telephone: String?
    var pharmacistID: String?
    var nic: String?
    var createdAt: Date
    var role: UserRole
    var roles: [UserRole]
    var authProvider: AuthProvider

    init(id: String = UUID().uuidString,
         email: String? = nil,
         name: String,
         age: Int = 0,
         phoneNumber: String? = nil,
         dateOfBirth: Date? = nil,
         address: String? = nil,
         telephone: String? = nil,
         pharmacistID: String? = nil,
         nic: String? = nil,
         createdAt: Date = Date(),
         role: UserRole = .patient,
         authProvider: AuthProvider = .phone)
    {
        self.id           = id
        self.email        = email
        self.name         = name
        self.age          = age
        self.phoneNumber  = phoneNumber
        self.dateOfBirth  = dateOfBirth
        self.address      = address
        self.telephone    = telephone
        self.pharmacistID = pharmacistID
        self.nic          = nic
        self.createdAt    = createdAt
        self.role         = role
        self.authProvider = authProvider
        self.roles        = [role]
    }
}
