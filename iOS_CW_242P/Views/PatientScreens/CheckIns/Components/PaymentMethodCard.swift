//
//  PaymentMethodCard.swift
//  iOS_CW_242P
//
//  Created by Pubudu Perera on 2026-02-28.
//
import SwiftUI
struct PaymentMethodCard: View {
    let icon: String
    let title: String
    let isSelected: Bool
    var color: Color = .blue
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(isSelected ? color : .black)
                .font(.title3)
            Text(title)
                .font(.headline)
            Spacer()
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 1)
        ).animation(.easeInOut(duration: 0.4), value: isSelected)
    }
}
