//
//  EmptyNotificationView.swift
//  iOS_CW_242P
//
//  Created by Liviru Navaratna on 2026-02-26.
//

import SwiftUI

struct EmptyNotificationsView: View {
    let filter: NotificationFilter
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "bell.slash")
                .font(.system(size: 48))
                .foregroundColor(.gray.opacity(0.4))
            
            Text("No Notifications")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text(emptyMessage)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
    
    private var emptyMessage: String {
        switch filter {
        case .all:       return "You're all caught up! New notifications will appear here."
        case .reminders: return "No appointment or lab reminders at the moment."
        case .approvals: return "No pending lab approvals right now."
        case .updates:   return "No queue or pharmacy updates available."
        }
    }
}
