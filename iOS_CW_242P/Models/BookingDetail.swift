//
//  BookingDetail.swift
//  iOS_CW_242P
//
//  Created by Liviru Navaratna on 2026-02-27.
//

import Foundation

enum BookingTypeFilter: String, CaseIterable {
    case all = "All"
    case doctor = "Doctor"
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
