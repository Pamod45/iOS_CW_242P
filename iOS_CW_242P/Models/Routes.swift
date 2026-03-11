//
//  Routes.swift
//  iOS_CW_242P
//
//  Created by Liviru Navaratna on 2026-03-09.
//
import SwiftUI

struct Routes: Identifiable, Codable {
    let id: String
    let sourceName: String
    let destinationName: String
    let floor: Int
    let directionPoints: [CGPoint]
    let directions: [String]
    
    init(id: String = UUID().uuidString, sourceName: String, destinationName: String, floor: Int, directionPoints: [CGPoint], directions: [String]){
        self.id = id
        self.sourceName = sourceName
        self.destinationName = destinationName
        self.floor = floor
        self.directionPoints = directionPoints
        self.directions = directions
    }
    
    static func getRoute(from source: String, to destination: String, floor: Int) -> Routes? {
        if let route = MockData.sampleRoutes.first(where: {
            $0.sourceName == source &&
            $0.destinationName == destination &&
            $0.floor == floor
        }) {
            return route
        }
    
        return MockData.sampleRoutes.first
    }
}

