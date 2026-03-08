//
//  NotificationCard.swift
//  iOS_CW_242P
//
//  Created by Liviru Navaratna on 2026-02-26.
//

import SwiftUI

struct NotificationCard: View {
    let notification: AppNotification
    
    private var iconColor: Color {
        switch notification.type.color {
        case "blue":   return .blue
        case "green":  return .green
        case "orange": return .orange
        case "pink":   return .pink
        case "purple": return .purple
        default:       return .gray
        }
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 14) {
                Image(systemName: notification.type.icons)
                    .font(.title3)
                    .foregroundColor(iconColor)
                    .frame(width: 44, height: 44)
                    .background(iconColor.opacity(0.1))
                    .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(notification.title)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        Text(notification.timeAgo)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    
                    Text(notification.message)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Text(notification.type.rawValue)
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(6)
                }
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
            )
            .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
        }
    }
}
