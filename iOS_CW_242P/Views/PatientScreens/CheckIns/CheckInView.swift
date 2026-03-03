//
//  CheckInView.swift
//  iOS_CW_242P
//
//  Created by Pubudu Perera on 2026-03-03.
//


import SwiftUI

struct CheckInView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showOPDCheckIn = false
    @State private var showLabCheckIn = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Text("Choose a Service")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Select the service you want to check in for")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    .padding(.horizontal)
                    
                    NavigationLink(destination: MyBookingsView()) {
                        HStack(spacing: 14) {
                            Image(systemName: "list.clipboard.fill")
                                .font(.title2)
                                .foregroundColor(.blue)
                                .frame(width: 50, height: 50)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(12)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("My Bookings")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Text("View appointments, lab check-ins & payments")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                    }
                    .padding(.horizontal)
                    
                    VStack(spacing: 20) {
                        CheckInServiceCard(
                            title: "OPD Check-In",
                            description: "Book an appointment with a doctor. Select date, session, and complete payment.",
                            icon: "stethoscope",
                            color: .blue,
                            features: [
                                "Select date and session",
                                "Real-time queue updates",
                                "Doctor room information",
                                "Estimated wait time"
                            ]
                        ) {
                            showOPDCheckIn = true
                        }
                        
                        CheckInServiceCard(
                            title: "Laboratory Check-In",
                            description: "Schedule laboratory tests. Some tests may require doctor approval.",
                            icon: "flask",
                            color: .green,
                            features: [
                                "Browse available tests",
                                "Add multiple tests",
                                "Approval workflow",
                                "Session scheduling"
                            ]
                        ) {
                            showLabCheckIn = true
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 40)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Check-In")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showOPDCheckIn) {
            }
            .sheet(isPresented: $showLabCheckIn) {
                
            }
        }
    }
}

struct CheckInServiceCard: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    let features: [String]
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 16) {
                    Image(systemName: icon)
                        .font(.system(size: 40))
                        .foregroundColor(color)
                        .frame(width: 70, height: 70)
                        .background(color.opacity(0.1))
                        .cornerRadius(16)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text(description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(features, id: \.self) { feature in
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(color)
                                .font(.caption)
                            Text(feature)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                HStack {
                    Spacer()
                    Text("Get Started")
                        .font(.headline)
                        .foregroundColor(color)
                    Image(systemName: "arrow.right.circle.fill")
                        .foregroundColor(color)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
        }
    }
}

#Preview {
    CheckInView()
}
