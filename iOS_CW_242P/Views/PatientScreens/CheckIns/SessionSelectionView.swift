//
//  SessionSelectionView.swift
//  iOS_CW_242P
//
//  Created by Pubudu Perera on 2026-02-28.
//

import SwiftUI

struct SessionSelectionView: View {
    @Binding var selectedSession: Session?
    var selectedDate: Date = Date()
    
    var availableSessions: [Session] {
        MockData.sessions.filter { session in
            session.isAvailable && !session.hasPassed(for: selectedDate)
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Select Session")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Each session is 3 hours. Choose based on availability.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                .padding(.top)
                
                VStack(spacing: 12) {
                    ForEach(availableSessions) { session in
                        SessionCard(
                            session: session,
                            isSelected: selectedSession?.id == session.id
                        ) {
                            selectedSession = session
                        }
                    }
                    
                    if availableSessions.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "clock.badge.exclamationmark")
                                .font(.system(size: 48))
                                .foregroundColor(.gray)
                            Text("No Available Sessions")
                                .font(.headline)
                            Text("All sessions for today have passed. Please select a future date.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 40)
        }
    }
}

struct SessionCard: View {
    let session: Session
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.blue)
                        Text(session.displayTime)
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                    
                    if let doctorName = session.doctorName {
                        HStack {
                            Image(systemName: "stethoscope")
                                .foregroundColor(.blue)
                                .font(.caption)
                            Text(doctorName)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    HStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Queue")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("\(session.currentQueueNumber)")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Wait Time")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("~\(session.averageConsultationTimeInMinutes * session.currentQueueNumber) min")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.orange)
                        }
                    }
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
            .shadow(color: .black.opacity(isSelected ? 0.1 : 0.05), radius: 5, x: 0, y: 2)
        }
    }
}


#Preview{
    SessionSelectionView(selectedSession: .constant(MockData.sessions[0]))
}
