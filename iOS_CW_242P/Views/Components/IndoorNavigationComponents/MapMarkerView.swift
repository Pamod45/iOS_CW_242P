//
//  MapMarkerView.swift
//  iOS_CW_242P
//
//  Created by Liviru Navaratna on 2026-03-10.
//
import SwiftUI

struct MapMarkerView: View {
    let location: MapLocation
    let isActive: Bool
    
    private var color: Color{
        if(isActive){
            return .blue
        }
        switch location.type{
            case .entrance, .exit: return .orange
            case .reception:         return .purple
            case .doctorRoom:        return Color(red: 0.22, green: 0.45, blue: 0.82)
            case .laboratory:        return .teal
            case .pharmacy:          return .red
            case .restroom:          return .gray
            case .elevator, .stairs: return .indigo
        }
    }
    
    var body: some View {
        VStack{
            
            Image(systemName: location.type.icon)
                .font(.system(size: isActive ? 22 : 15, weight: .semibold))
                .foregroundColor(color)
                .shadow(color: color.opacity(0.45), radius: 4, x: 0, y: 2)
            Text(location.name)
                .font(.system(size: isActive ? 10 : 8, weight: .semibold))
                .foregroundColor(color.opacity(0.85))
                .lineLimit(1)
                .fixedSize()
        }
    }
}
