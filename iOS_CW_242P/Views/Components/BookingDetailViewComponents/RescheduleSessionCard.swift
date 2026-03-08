//
//  RescheduleSessionCard.swift
//  iOS_CW_242P
//
//  Created by Liviru Navaratna on 2026-03-02.
//

import SwiftUI

struct RescheduleSessionCard: View {
    let session: Session
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(session.displayTime)
                    .font(.headline)
                    .foregroundColor(isSelected ? .blue : .primary)
                
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Image(systemName: "person.2.fill")
                            .font(.caption)
                        Text("Queue: \(session.currentQueueNumber)")
                            .font(.caption)
                    }
                    .foregroundColor(.secondary)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "clock.fill")
                            .font(.caption)
                        Text("~\(session.currentQueueNumber * session.averageConsultationTimeInMinutes) min")
                            .font(.caption)
                    }
                    .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title3)
                    .foregroundColor(.blue)
            } else {
                Image(systemName: "circle")
                    .font(.title3)
                    .foregroundColor(.gray.opacity(0.3))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? Color.blue.opacity(0.08) : Color(.systemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
        )
        .shadow(color: .black.opacity(isSelected ? 0.08 : 0.04), radius: 4, x: 0, y: 2)
    }
}

