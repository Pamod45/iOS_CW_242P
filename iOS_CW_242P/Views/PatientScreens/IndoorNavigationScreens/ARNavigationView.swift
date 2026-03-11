//
//  ARNavigationView.swift
//  iOS_CW_242P
//
//  Created by Liviru Navaratna on 2026-03-11.
//

import SwiftUI

struct ARNavigationView: View {
    let sourceLocation: MapLocation
    let destinationLocation: MapLocation
    @Binding var isPresented: Bool
    @Binding var viewMode: IndoorNavigationView.ViewMode
    
    var body: some View {
        ZStack {
            Image("ARImage")
                .resizable()
                .scaledToFit()
                
            VStack {
                Spacer()
                
                VStack(spacing: 20) {
                    VStack{
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.blue)
                            .frame(width: 80, height: 80)
                            .background(.white)
                            .cornerRadius(50)
                        
                        Text("Walk straight ahead")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
        
                        Text("Continue for 15 meters")
                            .font(.subheadline)
                            .foregroundColor(.black.opacity(0.9))
                    }
                    .padding()
                }
                .background(.white.opacity(0.8))
                .cornerRadius(12)
                
                VStack{
                }
                .padding(.bottom, 100)
            }
            
            VStack {
                HStack {
                    Button(action: {
                        isPresented = false
                        viewMode = .map
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                    .padding()
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Navigating to")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                        Text(destinationLocation.name)
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(12)
                    .padding()
                }
                
                Spacer()
            }
            
            VStack {
                Spacer()
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("AR Navigation")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("Point camera at corridor")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "camera.fill")
                        .font(.title3)
                        .foregroundColor(.blue)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.2), radius: 10)
                .padding()
            }
        }
        .ignoresSafeArea()
        .padding(.vertical, 4)
        .background(Color(.black))
    }
}

#Preview {
    ARNavigationView(
        sourceLocation: MockData.sampleLocations[0],
        destinationLocation: MockData.sampleLocations[5],
        isPresented: .constant(true),
        viewMode: .constant(.ar)
    )
}

