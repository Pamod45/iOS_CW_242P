//
//  FloatingFloorSelector.swift
//  iOS_CW_242P
//
//  Created by Liviru Navaratna on 2026-03-10.
//

import SwiftUI

struct FloatingFloorSelector: View {
    @Binding var selectedFloor: Int
    let floors: [Int]
    
    var body: some View {
        Menu {
            ForEach(floors, id: \.self) { floor in
                Button(action: {
                    withAnimation(.spring(response: 0.3)) {
                        selectedFloor = floor
                    }
                }) {
                    Label("Floor \(floor)", systemImage: selectedFloor == floor ? "checkmark" : "building.2")
                }
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: "building.2")
                    .font(.system(size: 12, weight: .semibold))
                Text("Floor \(selectedFloor)")
                    .font(.system(size: 13, weight: .semibold))
                Image(systemName: "chevron.up.chevron.down")
                    .font(.system(size: 9, weight: .bold))
            }
            .foregroundColor(.primary)
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color(.systemBackground))
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 2)
        }
    }
}
