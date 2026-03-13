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
    @State private var tempPickedLocation: MapLocation? = nil
    @State private var currentDirectionStep = 0
    @State private var viewMode: ViewMode = .map
    @State private var activeRoute: Routes? = MockData.sampleRoutes.first
    @State private var isToggled: Bool = false
    
    let floors: [Int] = [1, 2]
    
    var hasRoute: Bool {
        sourceLocation != nil && destinationLocation != nil
    }
    
    enum ViewMode {
        case map
        case ar
    }
    
    init(){
    }
    
    init(source: MapLocation, destination: MapLocation){
        self._sourceLocation = State(initialValue: source)
            self._destinationLocation = State(initialValue: destination)
            
            self._selectedFloor = State(initialValue: source.floor)
    }
    
    
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
            
            VStack {
                Spacer()
                
                HStack(alignment: .bottom) {
                    if hasRoute {
                        FloatingViewModeToggle(
                            viewMode: $viewMode,
                            onARTap: {
                                showARNavigation = true
                            }
                        )
                    }
                    
                    Spacer()
                    
                    FloatingFloorSelector(
                        selectedFloor: $selectedFloor,
                        floors: floors
                    )
                }
                .padding(.horizontal, 16)
                .padding(.bottom, hasRoute ? 180 : 40)
            }
            
            if hasRoute && !showDirectionsList {
                VStack {
                    Spacer()
                    if let route = activeRoute {
                        FloatingDirectionBar(
                            currentStep: currentDirectionStep,
                            directions: route.directions,
                            estimatedTime: "5 mins",
                            distance: "250m",
                            onTap: {
                                withAnimation(.spring(response: 0.4)) {
                                    showDirectionsList = true
                                }
                            }
                        )
                        .padding(.horizontal, 16)
                        .padding(.bottom, 20)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            }
            
            if showDirectionsList {
                Color.black.opacity(0.15)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.4)) {
                            showDirectionsList = false
                        }
                    }
                
                VStack {
                    Spacer()
                    
                    if let route = activeRoute {
                        ExpandedDirectionsSheet(
                            directions: route.directions,
                            sourceName: route.sourceName,
                            destinationName: route.destinationName,
                            estimatedTime: "5 mins",
                            distance: "250m",
                            onClose: {
                                withAnimation(.spring(response: 0.4)) {
                                    showDirectionsList = false
                                }
                            }
                        )
                        .padding(.horizontal, 16)
                        .padding(.bottom, 20)
                        .transition(.move(edge: .bottom))
                    }
                }
            }
        }
//        .navigationTitle("Indoor Navigation")
//        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showLocationSheet){
            LocationPickerView(
                isPresented: $showLocationSheet,
                title: isEditingSource ? "Select Starting Location" : "Select Destination",
                selectedLocation: isEditingSource ? sourceLocation : destinationLocation,
                onLocationSelected: { location in
                    if isEditingSource {
                        sourceLocation = location
                        selectedFloor = location.floor
                    } else {
                        destinationLocation = location
                    }
                },
                allowQRScan: isEditingSource
            )
        }
        .fullScreenCover(isPresented: $showARNavigation) {
            if let src = sourceLocation, let dst = destinationLocation {
                ARNavigationView(
                    sourceLocation: src,
                    destinationLocation: dst,
                    isPresented: $showARNavigation,
                    viewMode: $viewMode
                )
            }
        }
    }
    
    //Functions will be placed here
    private func swapLocations(){
        let temp = sourceLocation
        sourceLocation = destinationLocation
        destinationLocation = temp
        activeRoute = MockData.sampleRoutes[isToggled ? 0 : 1]
        isToggled.toggle()
    }
    
    private func clearRoute(){
        sourceLocation = nil
        destinationLocation = nil
    }
}

#Preview {
    NavigationView {
        IndoorNavigationView()
    }
}
