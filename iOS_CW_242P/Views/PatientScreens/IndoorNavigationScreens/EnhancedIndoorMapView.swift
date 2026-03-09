//
//  EnhancedIndoorMapView.swift
//  iOS_CW_242P
//
//  Created by Liviru Navaratna on 2026-03-09.
//

import SwiftUI

struct EnhancedIndoorMapView: View {
    
    let sourceLocation: MapLocation?
    let destinationLocation: MapLocation?
    let selectedFloor: Int
    @State private var routeAnimationProgress: CGFloat = 0
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    
    private var floorLocations: [MapLocation] {
        MockData.sampleLocations.filter { $0.floor == selectedFloor }
    }
    
    private var corridorsOnCurrentFloor: [CorridorSegment] {
        MockData.corridors(for: selectedFloor)
    }
    
    var body: some View {
        ZStack {
            Color(red: 0.945, green: 0.950, blue: 0.935).ignoresSafeArea()
            
            GeometryReader{ geometry in
                ZStack{
                    //Draw corridors
                    ForEach(corridorsOnCurrentFloor){ corridor in
                        Path{ path in
                            path.move(to: CGPoint(x: corridor.start.x * geometry.size.width, y: corridor.start.y * geometry.size.height))
                            
                            path.addLine(to: CGPoint(x: corridor.end.x * geometry.size.width, y: corridor.end.y * geometry.size.height))
                        }
                        .stroke(corridor.isMainCorridor ? Color(white: 0.82): Color(white: 0.82),style: StrokeStyle(lineWidth: corridor.width, lineCap: .round, lineJoin: .round)
                        )
                    }
                    
                    //highlight map markers and assign to proper location
                    ForEach(floorLocations) { location in
                        let screenPosition = convertToScreenPoint(location: location, in: geometry.size)
                        
                        let isStart = (location.id == sourceLocation?.id)
                        let isEnd = (location.id == destinationLocation?.id)
                        let isHighlighted = isStart || isEnd

                        MapMarkerView(location: location, isActive: isHighlighted)
                            .position(screenPosition)
                    }
                }
            }
        }
    }
    
    //Functions    
    private func convertToScreenPoint(location: MapLocation, in screen: CGSize) -> CGPoint {
        let newXPositon = location.coordinates.x * screen.width
        let newYPosition = location.coordinates.y * screen.height
        
        return CGPoint(x: newXPositon, y: newYPosition)
    }

}

#Preview{
    // Provide sample data for preview
    EnhancedIndoorMapView(
        sourceLocation: MockData.sampleLocations.first,
        destinationLocation: MockData.sampleLocations.dropFirst().first,
        selectedFloor: 1
    )
}
