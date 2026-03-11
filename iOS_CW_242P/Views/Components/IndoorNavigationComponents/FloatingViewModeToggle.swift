//
//  FloatingViewModeToggle.swift
//  iOS_CW_242P
//
//  Created by Liviru Navaratna on 2026-03-11.
//

import SwiftUI

struct FloatingViewModeToggle: View {
    
    @Binding var viewMode: IndoorNavigationView.ViewMode
    let onARTap: () -> Void
    
    var body: some View {
        HStack(spacing: 8) {
            Button(action: {
                viewMode = .map
            }) {
                Image(systemName: "map.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(viewMode == .map ? .white : .primary)
                    .frame(width: 44, height: 44)
                    .background(viewMode == .map ?.blue : .white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 2)
            }
            
            Button(action: {
                viewMode = .ar
                onARTap()
            }) {
                Image(systemName: "arkit")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(viewMode == .ar ? .white : .primary)
                    .frame(width: 44, height: 44)
                    .background( viewMode == .ar ? .blue : .white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 2)
            }
        }
    }

}
