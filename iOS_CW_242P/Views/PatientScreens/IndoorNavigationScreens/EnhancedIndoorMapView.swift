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
                    
                    let routePoints = buildRoutePoints(in: geometry.size)
                    if routePoints.count >= 2 {
                        FootstepTrail(points: routePoints, progress: routeAnimationProgress)

//                        Circle().fill(Color.white)
//                            .frame(width: 90, height: 90)
//                            .position(routePoints.first!)

//                        Circle().fill(Color.blue)
//                            .frame(width: 14, height: 14)
//                            .shadow(color: .blue.opacity(0.6), radius: 6)
//                            .position(routePoints.last!)
                    }
                    
                    ForEach(floorLocations) { location in
                        let screenPosition = convertToScreenPoint(location: location, in: geometry.size)
                        
                        let isStart = (location.id == sourceLocation?.id)
                        let isEnd = (location.id == destinationLocation?.id)
                        let isHighlighted = isStart || isEnd

                        MapMarkerView(location: location, isActive: isHighlighted)
                            .position(screenPosition)
                    }
                }
                .scaleEffect(scale)
                .offset(offset)
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            let delta = value / lastScale
                            lastScale = value
                            scale = min(max(scale * delta, 0.5), 4.0)
                        }
                        .onEnded { _ in lastScale = scale }
                )
                .simultaneousGesture(
                    DragGesture()
                        .onChanged { value in
                            offset = CGSize(
                                width: lastOffset.width + value.translation.width,
                                height: lastOffset.height + value.translation.height
                            )
                        }
                        .onEnded { _ in lastOffset = offset }
                )
            }
        }
        .onAppear { animateRoute() }
        .onChange(of: sourceLocation) { animateRoute() }
        .onChange(of: destinationLocation) { animateRoute() }
        .onChange(of: selectedFloor) {
            withAnimation(.spring(response: 0.3)) {
                scale = 1
                lastScale = 1
                offset = .zero
                lastOffset = .zero
            }
            animateRoute()
        }
    }
    
    //Functions    
    private func convertToScreenPoint(location: MapLocation, in screen: CGSize) -> CGPoint {
        let newXPositon = location.coordinates.x * screen.width
        let newYPosition = location.coordinates.y * screen.height
        
        return CGPoint(x: newXPositon, y: newYPosition)
    }
    
    private func animateRoute() {
        routeAnimationProgress = 0
        withAnimation(.easeInOut(duration: 1.4)) { routeAnimationProgress = 1 }
    }

    private func buildRoutePoints(in size: CGSize) -> [CGPoint] {
        guard let source = sourceLocation, let destination = destinationLocation else { return [] }
        
        if source.floor == selectedFloor && destination.floor == selectedFloor {
            if let route = Routes.getRoute(
                from: source.name,
                to: destination.name,
                floor: selectedFloor
            ) {
                return route.directionPoints.map { directionPoint in
                    CGPoint(x: directionPoint.x * size.width, y: directionPoint.y * size.height)
                }
            }
        }
        
        if source.floor != destination.floor {
            let transitionPoint = findTransitionPoint(from: source, to: destination)
            
            if source.floor == selectedFloor {
                if let route = Routes.getRoute(
                    from: source.name,
                    to: transitionPoint,
                    floor: selectedFloor
                ) {
                    return route.directionPoints.map { directionPoint in
                        CGPoint(x: directionPoint.x * size.width, y: directionPoint.y * size.height)
                    }
                }
            } else if destination.floor == selectedFloor {
                if let route = Routes.getRoute(
                    from: transitionPoint,
                    to: destination.name,
                    floor: selectedFloor
                ) {
                    return route.directionPoints.map { directionPoint in
                        CGPoint(x: directionPoint.x * size.width, y: directionPoint.y * size.height)
                    }
                }
            }
        }
        
        return []
    }
    
    private func findTransitionPoint(from source: MapLocation, to destination: MapLocation) -> String {
        if let _ = Routes.getRoute(from: source.name, to: "Elevator", floor: source.floor),
           let _ = Routes.getRoute(from: "Elevator", to: destination.name, floor: destination.floor) {
            return "Elevator"
        }
        
        if let _ = Routes.getRoute(from: source.name, to: "Stairs", floor: source.floor),
           let _ = Routes.getRoute(from: "Stairs", to: destination.name, floor: destination.floor) {
            return "Stairs"
        }
        
        return "Elevator"
    }
}

#Preview{
    EnhancedIndoorMapView(
        sourceLocation: MockData.sampleLocations.first,
        destinationLocation: MockData.sampleLocations[2],
        selectedFloor: 1
    )
}
