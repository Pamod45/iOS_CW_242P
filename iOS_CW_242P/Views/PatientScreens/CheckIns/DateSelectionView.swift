//
//  DateSelectionView.swift
//  iOS_CW_242P
//
//  Created by Pubudu Perera on 2026-03-01.
//
import SwiftUI

struct DateSelectionView: View {
    @Binding var selectedDate: Date
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Select Date")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Choose your preferred appointment date")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                .padding(.top)
                
                DatePicker(
                    "",
                    selection: $selectedDate,
                    in: Date()...,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .padding(.horizontal)
                
                InfoCard(
                    title: "Selected Date",
                    value: selectedDate.formatted(date: .long, time: .omitted),
                    icon: "calendar",
                    iconColor: .blue
                )
                .padding(.horizontal)
            }
            .padding(.bottom, 40)
        }
    }
}
