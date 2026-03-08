//
//  Notification.swift
//  iOS_CW_242P
//
//  Created by Liviru Navaratna on 2026-02-26.
//


import Foundation

enum NotificationType: String, CaseIterable {
    
    case appointmentReminder = "Appointment Reminder"
    case labReminder = "Lab Reminder"
    case labApproval = "Lab Approval"
    case pharmacyReady = "Pharmacy Ready"
    case queueUpdate = "Queue Update"
    case general = "General"
    
    var icons: String {
        switch self{
            case .appointmentReminder: return "clock.fill"
            case .labReminder: return "clock.fill"
            case .labApproval: return "checkmark.seal.fill"
            case .pharmacyReady: return "bell.fill"
            case .queueUpdate: return "bell.fill"
            case .general: return "bell.fill"
        }
    }
    
    var color: String {
        switch self{
            case .appointmentReminder: return "blue"
            case .labReminder: return "blue"
            case .labApproval: return "green"
            case .pharmacyReady: return "gray"
            case .queueUpdate: return "gray"
            case .general: return "gray"
        }
    }
}

enum NotificationFilter: String, CaseIterable {
    case all = "All"
    case reminders = "Reminders"
    case approvals = "Approvals"
    case updates = "Updates"
}


struct AppNotification : Identifiable {
    let id: String
    let type: NotificationType
    let title: String
    let message: String
    let timestamp: Date
    
    
    init(id: String = UUID().uuidString, type: NotificationType, title: String, message: String, timestamp: Date) {
        self.id = id
        self.type = type
        self.title = title
        self.message = message
        self.timestamp = timestamp
    }
    
    var timeAgo: String {
        let interval = Date().timeIntervalSince(timestamp)
        let minutes = Int(interval / 60)
        let hours = Int(interval / 3600)
        let days = Int(interval / 86400)
        
        if minutes < 1 { return "Just now" }
        if minutes < 60 { return "\(minutes)m ago" }
        if hours < 24 { return "\(hours)h ago" }
        if days == 1 { return "Yesterday" }
        if days < 7 { return "\(days)d ago" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: timestamp)
    }
    
    func matchesFilter(_ filter: NotificationFilter) -> Bool {
        switch filter {
        case .all:
            return true
        case .reminders:
            return type == .appointmentReminder || type == .labReminder
        case .approvals:
            return type == .labApproval
        case .updates:
            return type == .queueUpdate || type == .pharmacyReady || type == .general
        }
    }
    
}
