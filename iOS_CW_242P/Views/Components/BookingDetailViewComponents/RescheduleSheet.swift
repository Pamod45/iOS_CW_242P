//
//  RescheduleSheet.swift
//  iOS_CW_242P
//
//  Created by Liviru Navaratna on 2026-03-02.
//
import SwiftUI

struct RescheduleSheet: View {
    let booking: Appointment
    @Binding var rescheduleDate: Date
    @Binding var rescheduleSession: Session?
    let onConfirm: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var showDatePicker = true
    
    private let availableSessions = MockData.sessions.filter { $0.isAvailable }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: "calendar.badge.clock")
                            .font(.system(size: 40))
                            .foregroundColor(.blue)
                            .frame(width: 80, height: 80)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(20)
                        
                        Text("Reschedule Booking")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Choose a new date and session for your appointment")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top)
                    
                    // Current Booking Info
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Current Booking")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 12) {
                            Image(systemName: booking.type == .opd ? "stethoscope" : "flask.fill")
                                .foregroundColor(.blue)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(booking.type.rawValue)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                Text("\(booking.displayDate) • \(booking.sessionDisplay)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    Divider()
                        .padding(.horizontal)
                    
                    // Date Selection
                    VStack(alignment: .leading, spacing: 12) {
                        Text("New Date")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        DatePicker(
                            "",
                            selection: $rescheduleDate,
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
                            value: rescheduleDate.formatted(date: .long, time: .omitted),
                            icon: "calendar",
                            iconColor: .blue
                        )
                        .padding(.horizontal)
                    }
                    
                    // Session Selection
                    VStack(alignment: .leading, spacing: 12) {
                        Text("New Session")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ForEach(availableSessions) { session in
                            Button(action: {
                                rescheduleSession = session
                            }) {
                                RescheduleSessionCard(
                                    session: session,
                                    isSelected: rescheduleSession?.id == session.id
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal)
                    }
                    
                    // Confirm Button
                    PrimaryButton(
                        title: "Confirm Reschedule",
                        action: {
                            onConfirm()
                        },
                        isDisabled: rescheduleSession == nil
                    )
                    .padding(.horizontal)
                    .padding(.bottom, 40)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Reschedule")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

