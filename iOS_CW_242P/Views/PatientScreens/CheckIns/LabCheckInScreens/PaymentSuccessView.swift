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
                                title: "Position",
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
                            Text("Queue Progress")
                                .font(.headline)
                            Spacer()
                            Text("\(Int((Double(totalInQueue - currentPosition) / Double(totalInQueue)) * 100))%")
                                .font(.headline)
                                .foregroundColor(.blue)
                        }
                        
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(height: 8)
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.blue)
                                    .frame(width: geometry.size.width * (Double(totalInQueue - currentPosition) / Double(totalInQueue)), height: 8)
                            }
                        }
                        .frame(height: 8)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(.blue)
                            Text("Important Information")
                                .font(.headline)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            InfoBullet(text: "Please arrive at least 10 minutes before your turn")
                            InfoBullet(text: "Wait near the designated room")
                            InfoBullet(text: "You'll receive a notification when it's almost your turn")
                            InfoBullet(text: "Keep your queue number for reference")
                        }
                    }
                    .padding()
                    .background(Color.blue.opacity(0.05))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    VStack(spacing: 12) {
                        NavigationLink(destination: Text("Indoor Navigation")) {
                            HStack {
                                Image(systemName: "location.fill")
                                Text("Navigate to Doctor's Room")
                                    .fontWeight(.semibold)
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
