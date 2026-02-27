//
//  SummaryMini.swift
//  iOS_CW_242P
//
//  Created by Liviru Navaratna on 2026-02-27.
//

import SwiftUI

struct SummaryMini: View {
    let value: String
    let label: String
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: 8){
            //Icon for the summary
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            
            //title for the summary
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            //label for the summary
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
}
