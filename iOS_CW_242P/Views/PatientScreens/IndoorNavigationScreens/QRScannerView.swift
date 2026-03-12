//
//  QRScannerView.swift
//  iOS_CW_242P
//
//  Created by Liviru Navaratna on 2026-03-11.
//
import SwiftUI

struct QRScannerView: View {
    
    @Binding var isPresented: Bool
    let onLocationScanned: (MapLocation) -> Void
    
    @State private var isScanning = true
    @State private var scannedLocation: MapLocation?
    @State private var showSuccess = false
    
    var body: some View{
        NavigationView{
            ZStack{
                Color(.systemBackground).ignoresSafeArea()
                
                VStack(spacing: 28){
                    VStack(spacing: 12){
                        Image(systemName: "qrcode.viewfinder")
                            .font(.system(size: 48))
                            .foregroundColor(.blue)
                            .frame(width: 90, height: 90)
                            .background(.blue.opacity(0.1))
                            .cornerRadius(20)
                        
                        Text("Scan Location QR Code")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Text("Point your camera at the QR code placed near the location")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                            
                    }
                    .padding(.top, 10)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(.systemBackground))
                        
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(.white))
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.gray.opacity(0.25), lineWidth: 2)
                                .frame(width: 220, height: 220)
                            
                            ScannerCorners()
                                .frame(width: 220, height: 220)
                            
                            Image(systemName: showSuccess ? "checkmark.circle.fill" : "qrcode.viewfinder")
                                .font(.system(size: 60))
                                .foregroundColor(showSuccess ? .green : .blue)
                        }
                    }
                    .frame(height: 270)
                    .padding(.horizontal)
                    
                    if showSuccess, let location = scannedLocation{
                        HStack(spacing: 14) {
                            Image(systemName: location.type.icon)
                                .font(.title2)
                                .foregroundColor(.green)
                                .frame(width: 48, height: 48)
                                .background(Color.green.opacity(0.1))
                                .cornerRadius(12)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Location Identified")
                                    .font(.caption)
                                    .foregroundColor(.green)
                                    .fontWeight(.semibold)
                                Text(location.name)
                                    .font(.headline)
                                Text(location.type.rawValue)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.title3)
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                        .padding(.horizontal)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    } else {
                        Button(action: simulateScan) {
                            HStack(spacing: 10) {
                                Image(systemName: "qrcode.viewfinder")
                                    .font(.title3)
                                Text("Scan Main Entrance")
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Scan QR Code")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
            .animation(.easeInOut(duration: 0.35), value: showSuccess)
        }
    }
    
    
    private func simulateScan() {
        if let mainEntrance = MockData.sampleLocations.first(where: { $0.name == "Main Entrance" }) {
                scannedLocation = mainEntrance
                withAnimation { showSuccess = true
            }
            
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                onLocationScanned(mainEntrance)
                isPresented = false
            }
        }
    }
    
}


struct ScannerCorners: View {
    var body: some View {
        ZStack {
            // Top-left
            VStack(alignment: .leading, spacing: 0) {
                Rectangle().frame(width: 28, height: 3)
                Rectangle().frame(width: 3, height: 28)
            }
            .foregroundColor(.blue)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
            // Top-right
            VStack(alignment: .trailing, spacing: 0) {
                Rectangle().frame(width: 28, height: 3)
                HStack { Spacer(); Rectangle().frame(width: 3, height: 28) }
            }
            .foregroundColor(.blue)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            
            // Bottom-left
            VStack(alignment: .leading, spacing: 0) {
                Rectangle().frame(width: 3, height: 28)
                Rectangle().frame(width: 28, height: 3)
            }
            .foregroundColor(.blue)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            
            // Bottom-right
            VStack(alignment: .trailing, spacing: 0) {
                HStack { Spacer(); Rectangle().frame(width: 3, height: 28) }
                Rectangle().frame(width: 28, height: 3)
            }
            .foregroundColor(.blue)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        }
    }
}






#Preview{
    QRScannerView(
        isPresented: .constant(true),
        onLocationScanned: {_ in }
    )
}
