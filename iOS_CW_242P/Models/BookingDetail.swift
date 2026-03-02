//
//  BookingDetail.swift
//  iOS_CW_242P
//
//  Created by Liviru Navaratna on 2026-02-27.
//

import Foundation

enum BookingTypeFilter: String, CaseIterable {
    case all = "All"
    case doctor = "OPD Visits"
    case lab = "Lab Tests"
}

enum BookingStatusFilter: String, CaseIterable {
    case all = "All"
    case upcoming = "Upcoming"
    case pendingApproval = "Pending Approval"
    case awaitingPayment = "Awaiting Payment"
    case completed = "Completed"
    case cancelled = "Cancelled"
}

enum DateRangeFilter: String, CaseIterable {
    case all = "All"
    case today = "Today"
    case tomorrow = "Tomorrow"
    case thisWeek = "This Week"
    case nextWeek = "Next Week"
    case thisMonth = "This Month"
    case past = "Past"
    
    var icon: String {
        switch self{
            case .all : return "calendar"
            case .today : return "sun.max.fill"
            case .tomorrow: return "sunrise.fill"
            case .thisWeek: return "calendar.badge.clock"
            case .nextWeek: return "calendar.badge.plus"
            case .thisMonth: return "calendar.circle"
            case .past: return "clock.arrow.circlepath"
        }
    }
}
