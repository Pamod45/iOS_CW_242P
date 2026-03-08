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
    let onClose: () -> Void
    
    var body: some View {
        VStack(spacing: 0){
            HStack {
                VStack(alignment: .leading) {
                    Button(action: onSourceTap){
                        Text(sourceLocation?.name ?? "Choose Source Location")
                    }
                    
                    Divider()
                    
                    Button(action: onDestinationTap){
                        Text(destinationLocation?.name ?? "Choose Destination")
                    }
                }
                
                Spacer()
                
                VStack(spacing: 24){
                    Button(action: onSwapLocations){
                        Image(systemName: "arrow.up.arrow.down")
                    }
                    
                    Button(action: onClose){
                        Image(systemName: "xmark")
                    }
                }
            }
            .padding()
            .background(Color(.white))
            .cornerRadius(8)
            .shadow(radius: 4)
        }
    }
}
