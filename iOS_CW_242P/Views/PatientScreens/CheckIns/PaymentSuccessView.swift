//
//  PaymentSuccessView.swift
//  iOS_CW_242P
//
//  Created by Pubudu Perera on 2026-02-28.
//


import SwiftUI

struct PaymentSuccessView: View {
    @Environment(\.dismiss) private var dismiss
    let queueNumber: Int
    let estimatedWaitTime: Int
    let doctorRoom: String
    let dismissEntireFlow: () -> Void
    
    @State private var currentPosition = 3
    @State private var totalInQueue = 18
    
    let appointmentInstructions: [String] = [
        "Please arrive at least 10 minutes before your turn","Wait near the designated areas","You ‘ll receive a notification when it’s almost your turn","Keep your queue number for reference"
    ]
    
    let preTestInstructions: [String]  = [
        "Bring your uploaded doctor note","Follow any pre-test instructions (fasting, medication restrictions, timing, etc.)","Inform the laboratory staff about allergies, medical conditions, or pregnancy","Avoid eating, drinking, or medications unless instructed","Arrive on time and wear appropriate clothing (easy access for blood draw if needed)"
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    ZStack {
                        Circle()
                            .fill(Color.green.opacity(0.1))
                            .frame(width: 100, height: 100)
                        
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.green)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 8) {
                        Text("Payment Successful!")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Your appointment has been confirmed")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    VStack(spacing: 12) {
                        Text("Your Queue Number")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text("\(queueNumber)")
                            .font(.system(size: 80, weight: .bold))
                            .foregroundColor(.blue)
                        
                        HStack(spacing: 8) {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 8, height: 8)
                            Text("Active")
                                .font(.subheadline)
                                .foregroundColor(.green)
                        }
                    }
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.05))
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    VStack(spacing: 16) {
                        HStack(spacing: 20) {
                            QueueStatCard(
                                icon: "person.2.fill",
                                title: "Live queue position",
                                value: "\(currentPosition)/\(totalInQueue)",
                                color: .blue
                            )
                            
                            QueueStatCard(
                                icon: "clock.fill",
                                title: "Wait Time",
                                value: "~\(estimatedWaitTime) min",
                                color: .orange
                            )
                        }
                        
                        HStack(spacing: 20) {
                            QueueStatCard(
                                icon: "door.left.hand.open",
                                title: "Room",
                                value: doctorRoom,
                                color: .purple
                            )
                            
                            QueueStatCard(
                                icon: "bell.fill",
                                title: "Status",
                                value: "Waiting",
                                color: .green
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(.blue)
                            if doctorRoom == "Lab Room"{
                                Text("Pre test instructions")
                                    .font(.headline)
                            } else {
                                Text("Appointment Instructions")
                                    .font(.headline)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            
                            if doctorRoom == "Lab Room" {
                                ForEach(preTestInstructions, id: \.self){ instruction in
                                    InfoBullet(text: instruction)
                                }
                                
                            } else {
                                ForEach(appointmentInstructions, id: \.self){ instruction in
                                    InfoBullet(text: instruction)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.blue.opacity(0.05))
                    .cornerRadius(12)
                    
                    VStack(spacing: 12) {
                        NavigationLink(destination: Text("Indoor Navigation")) {
                            HStack {
                                Image(systemName: "location.fill")
                                if doctorRoom == "Lab Room" {
                                    Text("Navigate to Lab Room")
                                        .fontWeight(.semibold)
                                }
                                else {
                                    Text("Navigate to Doctor's Room")
                                        .fontWeight(.semibold)
                                }
                                
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        
                        Button(action: {
                            dismissEntireFlow()
                        }) {
                            Text("Back to Home")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.gray.opacity(0.1))
                                .foregroundColor(.blue)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 40)
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismissEntireFlow()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}

#Preview {
    PaymentSuccessView(queueNumber: 15, estimatedWaitTime: 45, doctorRoom: "Room 105", dismissEntireFlow: {})
}
