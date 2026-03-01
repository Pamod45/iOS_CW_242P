//
//  Untitled.swift
//  iOS_CW_242P
//
//  Created by Pubudu Perera on 2026-03-01.
//
import SwiftUI

struct ReasonForVisitView: View {
    @Binding var reasonForVisit: String
    let user: User?
    
    @State private var name: String = ""
    @State private var dob: Date = Date()
    @State private var address: String = ""
    @State private var telephone: String = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Visit Details")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Review and edit your information")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                .padding(.top)
                
                VStack(spacing: 16) {
                    CustomTextField(
                        title: "Full Name",
                        placeholder: "Enter your name",
                        text: $name,
                        icon: "person"
                    )
                    
                    DatePicker("Date of Birth", selection: $dob, displayedComponents: .date)
                    
                    CustomTextField(
                        title: "Address",
                        placeholder: "Enter your address",
                        text: $address,
                        icon: "house"
                    )
                    
                    CustomTextField(
                        title: "Telephone",
                        placeholder: "Enter phone number",
                        text: $telephone,
                        icon: "phone",
                        keyboardType: .phonePad
                    )
                }
                .padding(.horizontal)
                
                CustomTextEditor(
                    title: "Reason for Visit",
                    placeholder: "Describe your symptoms or reason for visiting...",
                    text: $reasonForVisit,
                    height: 120
                )
                .padding(.horizontal)
            }
            .padding(.bottom, 40)
            .onAppear {
                if name.isEmpty {
                    name = user?.name ?? ""
                    dob = user?.dateOfBirth ?? Date()
                    address = user?.address ?? ""
                    telephone = user?.telephone ?? ""
                }
            }
        }
    }
}
