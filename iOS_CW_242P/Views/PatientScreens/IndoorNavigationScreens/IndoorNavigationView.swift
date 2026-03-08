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
    
    var body: some View {
        ZStack {
            VStack {
//                Text("Search Bar is in here")
                GoogleMapsStyleSearchBar(
                    sourceLocation: sourceLocation,
                    destinationLocation: destinationLocation,
                    onSourceTap: {},
                    onDestinationTap: {},
                    onSwapLocations: swapLocations,
                    onClose: clearRoute
                )
                .padding()
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
