//
//  NavigationView.swift
//  iOS_CW_242P
//
//  Created by Liviru Navaratna on 2026-03-08.
//

import SwiftUI


struct IndoorNavigationView: View {
    
    @State private var sourceLocation: MapLocation?
    @State private var destinationLocation: MapLocation?
    @State private var selectedFloor = 1
    @State private var showLocationSheet = false
    @State private var showQRScanner = false
    @State private var showDirectionsList = false
    @State private var showARNavigation = false
    @State private var isEditingSource = true
    @State private var currentDirectionStep = 0

    
    var body: some View {
        ZStack {
            EnhancedIndoorMapView(
                sourceLocation: sourceLocation,
                destinationLocation: destinationLocation,
                selectedFloor: selectedFloor
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                GoogleMapsStyleSearchBar(
                    sourceLocation: sourceLocation,
                    destinationLocation: destinationLocation,
                    onSourceTap: {
                        isEditingSource = true
                        showLocationSheet = true
                    },
                    onDestinationTap: {
                        isEditingSource = false
                        showLocationSheet = true
                    },
                    onSwapLocations: swapLocations,
                    onQRScan: {
                        showQRScanner = true
                    },
                    onClose: clearRoute
                )
                .padding(.horizontal)
                .padding(.top, 8)
                
                Spacer()
            }
        }
    }
    
    //Functions will be placed here
    private func swapLocations(){
        let temp = sourceLocation
        sourceLocation = destinationLocation
        destinationLocation = temp
    }
    
    private func clearRoute(){
        sourceLocation = nil
        destinationLocation = nil
    }
}

#Preview {
    IndoorNavigationView(
//        sourceLocation: MockData.sampleLocations.first,
//        destinationLocation: MockData.sampleLocations.last,
//        selectedFloor: 1
    )
}
