//
//  CompactQueueCard.swift
//  iOS_CW_242P
//
//  Created by Liviru Navaratna on 2026-03-02.
//

import SwiftUI

struct CompactQueueCard: View {
    let queueNumber: Int
    let estimatedWait: Int
    let room: String
    let appointmentType: AppointmentType
    
    var body: some View {
        VStack(spacing: 20) {
            // Queue Number - Larger Display
            VStack(spacing: 8) {
                Text("Queue Number")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("\(queueNumber)")
                    .font(.system(size: 56, weight: .bold))
                    .foregroundColor(.blue)
                
                HStack(spacing: 6) {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 8, height: 8)
                    Text("Active")
                        .font(.subheadline)
                        .foregroundColor(.green)
                        .fontWeight(.medium)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(Color.blue.opacity(0.05))
            .cornerRadius(16)
            
            // Stats Row - Larger
            HStack(spacing: 16) {
                // Wait Time
                VStack(spacing: 8) {
                    Image(systemName: "clock.fill")
                        .font(.title2)
                        .foregroundColor(.orange)
                    
                    Text("~\(estimatedWait) min")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Text("Wait Time")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.orange.opacity(0.08))
                .cornerRadius(12)
                
                // Room/Location
                VStack(spacing: 8) {
                    Image(systemName: "door.left.hand.open")
                        .font(.title2)
                        .foregroundColor(.purple)
                    
                    Text(room)
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Text(appointmentType == .opd ? "Room" : "Lab")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.purple.opacity(0.08))
                .cornerRadius(12)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 3)
    }
}


