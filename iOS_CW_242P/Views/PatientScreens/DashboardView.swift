//
//  Dashboard.swift
//  iOS_CW_242P
//
//  Created by Pubudu Perera on 2026-02-25.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showOPDCheckIn = false
    @State private var showLabCheckIn = false
    
    @State private var hasActiveJourney = true
    @State private var shouldDismissAfterPayment = false
    
    @State private var todaysAppointments: [Appointment] = Appointment.todaysAppointments
    
    @StateObject private var dataManager = DataManager.shared
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Welcome back,")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text(authViewModel.currentUser?.name ?? "Patient")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        
                        Spacer()
                        
                        Circle()
                            .fill(LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 50, height: 50)
                            .overlay(
                                Text(getInitials())
                                    .font(.headline)
                                    .foregroundColor(.white)
                            )
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    if let activeJourney = dataManager.sampleJourneys.filter{Calendar.current.isDate($0.date, inSameDayAs: Date())}.first {
                        
                        NavigationLink(destination: JourneyView(journeyId: activeJourney.id)) {
                            HStack(spacing: 12) {
                                
                                Image(systemName: "exclamationmark.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.orange)
                                if let journeyStep = activeJourney.steps.first(where: {$0.status == .inProgress}) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Visit in Progress")
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                        Text(
                                            "\(journeyStep.type.displayText) - Queue #5"
                                        )
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                } else if let journeyStep = activeJourney.steps.first(where: {$0.status == .pending}) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Upcoming visit")
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                        Text(
                                            "\(journeyStep.type.displayText) - Queue #5"
                                        )
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(12)
                        }
                        .padding(.horizontal)
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Book an Appointment")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        HStack(spacing: 16) {
                            ServiceCard(
                                title: "Doctor Visit (OPD)",
                                subtitle: "Book an OPD visit",
                                icon: "stethoscope",
                                color: .blue
                            ) {
                                showOPDCheckIn = true
                            }
                            
                            ServiceCard(
                                title: "Laboratory",
                                subtitle: "Schedule lab tests",
                                icon: "flask",
                                color: .green
                            ) {
                                showLabCheckIn = true
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    if !todaysAppointments.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack(alignment: .top) {
                                Text("Today's Appointments")
                                    .font(.title3)
                                    .fontWeight(.bold)

                                Spacer()

                                NavigationLink(destination: MyBookingsView(directCall: false)) {
                                    HStack(spacing: 4){
                                        Text("See All")
                                            .font(.subheadline)
                                            .foregroundColor(.primary)
                                        Image(systemName: "chevron.right")
                                            .font(.caption)
                                            .foregroundColor(.primary)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal)
                            
                            
                            ForEach($todaysAppointments) { $appointment in
                                NavigationLink(destination: BookingDetailView(
                                    booking: $appointment,
                                    shouldDismissAfterPayment: $shouldDismissAfterPayment,
                                    onPayNow: {}
                                )) {
                                    AppointmentCard(appointment: appointment)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding(.bottom, 40)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showLabCheckIn){
                LabCheckInFlow(isPresented: $showLabCheckIn)
                    .environmentObject(authViewModel)
            }
            .sheet(isPresented: $showOPDCheckIn){
                OPDCheckInFlow(isPresented: $showOPDCheckIn)
            }
        }
    }
    
    private func getInitials() -> String {
        let name = authViewModel.currentUser?.name ?? "U"
        let components = name.split(separator: " ")
        if components.count >= 2 {
            return String(components[0].prefix(1) + components[1].prefix(1)).uppercased()
        } else {
            return String(name.prefix(1)).uppercased()
        }
    }
}

struct ShortcutTile: View {
    let icon: String
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.primary)
                .frame(width: 44, height: 44)
                .background(Color(.systemGray6))
                .cornerRadius(12)
            
            Text(label)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
}

struct AppointmentCard: View {
    let appointment: Appointment
    
    private var statusColor: Color {
        switch appointment.status {
        case .confirmed: return .green
        case .inProgress: return .blue
        case .pending: return .orange
        case .completed: return .gray
        case .cancelled: return .red
        }
    }
    
    private var session: Session? {
        MockData.sessions.first { $0.id == appointment.sessionId }
    }
    
    private var estimatedCallTime: String? {
        guard let queue = appointment.queueNumber,
              let wait = appointment.estimatedWaitTime,
              let session = session else { return nil }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        guard let sessionStart = formatter.date(from: session.startTime) else { return nil }
        
        let perPerson = max(3, wait / max(queue, 1))
        let fromMinutes = (queue - 1) * perPerson
        let toMinutes = fromMinutes + perPerson + 10
        
        let fromDate = sessionStart.addingTimeInterval(TimeInterval(fromMinutes * 60))
        let toDate   = sessionStart.addingTimeInterval(TimeInterval(toMinutes  * 60))
        
        let display = DateFormatter()
        display.dateFormat = "h:mm a"
        return "\(display.string(from: fromDate)) – \(display.string(from: toDate))"
    }
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .center) {
                    Text(appointment.type == .opd ? "OPD Appointment" : "Lab Appointment")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text(appointment.status.rawValue)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(statusColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(statusColor.opacity(0.1))
                        .cornerRadius(6)
                }
                
                if let session = session {
                    Text("Session  \(session.displayTime)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Divider()
                
                HStack(spacing: 20) {
                    if let queue = appointment.queueNumber {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Queue")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("#\(queue)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                    }
                    
                    if let room = appointment.doctorRoom {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Room")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(room.replacingOccurrences(of: "Room ", with: ""))
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                        }
                    }
                    
                    if appointment.type == .laboratory, let tests = appointment.labTests {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Tests")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("\(tests.count)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                        }
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.gray)
                }
                
                if let callTime = estimatedCallTime {
                    HStack(spacing: 5) {
                        Text("Est. call time  \(callTime)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 14)
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 3)
    }
}

#Preview {
    DashboardView()
        .environmentObject(AuthViewModel())
}

