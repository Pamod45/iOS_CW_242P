//
//  CorridorSegment.swift
//  iOS_CW_242P
//
//  Created by Liviru Navaratna on 2026-03-09.
//
import SwiftUI

struct CorridorSegment: Identifiable, Codable {
    let id: String
    let start: CGPoint
    let end: CGPoint
    let width: CGFloat
    let isMainCorridor: Bool
    let floor: Int
    
    init(id: String = UUID().uuidString, start: CGPoint, end: CGPoint, width: CGFloat, isMainCorridor: Bool, floor: Int){
        self.id = id
        self.start = start
        self.end = end
        self.width = width
        self.isMainCorridor = isMainCorridor
        self.floor = floor
    }
}
