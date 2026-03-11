//
//  MapLocation.swift
//  iOS_CW_242P
//
//  Created by Liviru Navaratna on 2026-03-08.
//

import Foundation

enum LocationTypes: String, CaseIterable, Codable {
    
    //Different locations provided for the map
    case entrance = "Entrance"
    case reception = "Reception"
    case doctorRoom = "Doctor Room"
    case laboratory = "Laboratory"
    case pharmacy = "Pharmacy"
    case restroom = "Restroom"
    case exit = "Exit"
    case elevator = "Elevator"
    case stairs = "Stairs"
    
    
    //Icons for the Locations
    var icon: String {
        switch self {
            case .entrance: return "door.left.hand.open"
            case .reception: return "person.crop.rectangle.fill"
            case .doctorRoom: return "stethoscope"
            case .laboratory: return "flask.fill"
            case .pharmacy: return "pills.fill"
            case .restroom: return "figure.dress.line.vertical.figure"
            case .exit: return "rectangle.portrait.and.arrow.right.fill"
            case .elevator: return "arrow.up.arrow.down"
            case .stairs: return "stairs"
        }
    }
}

//structure from the model for Coordinates
struct MapCoordinates: Codable, Equatable {
    let x: Double
    let y: Double
}


//Main structure for Map Location Model
struct MapLocation: Identifiable, Codable, Equatable{
    let id: String
    let name: String
    let type: LocationTypes
    let floor: Int
    let coordinates: MapCoordinates
    let description: String?
    let qrCode: String?
    
    init(id: String = UUID().uuidString, name: String, type: LocationTypes, floor: Int = 1, coordinates: MapCoordinates, description: String? = nil, qrCode: String? = nil){
        self.id = id
        self.name = name
        self.type = type
        self.floor = floor
        self.coordinates = coordinates
        self.description = description
        self.qrCode = qrCode
    }
    
    
    //This will be used to compare if two map locations are the same using the ID and not the entire MapLocation
    static func == (lhs: MapLocation, rhs: MapLocation) -> Bool {
        lhs.id == rhs.id
    }
    
}



