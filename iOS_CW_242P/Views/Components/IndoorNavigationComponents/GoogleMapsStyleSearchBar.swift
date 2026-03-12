//
//  GoogleMapsStyleSearchBar.swift
//  iOS_CW_242P
//
//  Created by Liviru Navaratna on 2026-03-08.
//

import SwiftUI

struct GoogleMapsStyleSearchBar: View {
    
    let sourceLocation: MapLocation?
    let destinationLocation: MapLocation?
    let onSourceTap: () -> Void
    let onDestinationTap: () -> Void
    let onSwapLocations: () -> Void
    let onQRScan: () -> Void
    let onClose: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                VStack(spacing: 0) {
                    Button(action: onSourceTap) {
                        HStack(spacing: 8) {
                            Image(systemName: "mappin")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            if let location = sourceLocation {
                                Text(location.name)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                                Text("·")
                                    .foregroundColor(.secondary)
                                Text("Floor \(location.floor)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            } else {
                                Text("Choose start location")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                        .padding(.vertical, 12)
                    }

                    Divider()

                    Button(action: onDestinationTap) {
                        HStack(spacing: 8) {
                            Image(systemName: "location.fill")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            if let location = destinationLocation {
                                Text(location.name)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                                Text("·")
                                    .foregroundColor(.secondary)
                                Text("Floor \(location.floor)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            } else {
                                Text("Choose destination")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                        .padding(.vertical, 12)
                    }
                }
                .padding(.leading, 14)

                VStack(spacing: 12) {
                    if sourceLocation != nil && destinationLocation != nil {
                        Button(action: onSwapLocations) {
                            Image(systemName: "arrow.up.arrow.down")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.blue)
                                .frame(width: 30, height: 30)
                        }
                    }

                    if sourceLocation != nil || destinationLocation != nil {
                        Button(action: onClose) {
                            Image(systemName: "xmark")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.gray)
                                .frame(width: 30, height: 30)
                        }
                    }
                }
                .padding(.trailing, 10)
            }
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 2)
        }
    }
}


#Preview {
    GoogleMapsStyleSearchBar(
        sourceLocation: MockData.sampleLocations.first,
        destinationLocation: MockData.sampleLocations.last,
        onSourceTap: {},
        onDestinationTap: {},
        onSwapLocations: {},
        onQRScan: {},
        onClose: {}
    )
}
