//
//  MyBookingsView.swift
//  iOS_CW_242P
//
//  Created by Liviru Navaratna on 2026-02-27.
//

import SwiftUI

struct MyBookingsView: View {
    @State private var bookings = MockData.sampleBookings
    @State private var typeFilter: BookingTypeFilter = .all
    @State private var statusFilter: BookingStatusFilter = .all
    @State private var dateRangeFilter: DateRangeFilter = .all
    @State private var showLabPaymentFor: Appointment? = nil
    @State private var shouldDismissDetailView = false
    @State private var showFilters = false
    
    private var filteredBookings: [Appointment] {
        bookings.filter { booking in
            let matchesType: Bool = {
                switch typeFilter {
                case .all:    return true
                case .doctor: return booking.type == AppointmentType.opd
                case .lab:    return booking.type == AppointmentType.laboratory
                }
            }()
            
            let matchesStatus: Bool = {
                switch statusFilter {
                case .all:              return true
                case .upcoming:         return booking.isUpcoming
                case .pendingApproval:  return booking.isPendingApproval
                case .awaitingPayment:  return booking.isAwaitingPayment
                case .completed:        return booking.isCompleted
                case .cancelled:        return booking.isCancelled
                }
            }()
            
            let matchesDateRange: Bool = {
                let calendar = Calendar.current
                let now = Date()
                
                switch dateRangeFilter {
                case .all:
                    return true
                case .today:
                    return calendar.isDateInToday(booking.date)
                case .tomorrow:
                    return calendar.isDateInTomorrow(booking.date)
                case .thisWeek:
                    let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: now)?.start ?? now
                    let endOfWeek = calendar.date(byAdding: .day, value: 7, to: startOfWeek) ?? now
                    return booking.date >= startOfWeek && booking.date < endOfWeek
                case .nextWeek:
                    let startOfNextWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: calendar.dateInterval(of: .weekOfYear, for: now)?.start ?? now) ?? now
                    let endOfNextWeek = calendar.date(byAdding: .day, value: 7, to: startOfNextWeek) ?? now
                    return booking.date >= startOfNextWeek && booking.date < endOfNextWeek
                case .thisMonth:
                    let startOfMonth = calendar.dateInterval(of: .month, for: now)?.start ?? now
                    let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth) ?? now
                    return booking.date >= startOfMonth && booking.date < endOfMonth
                case .past:
                    return booking.date < calendar.startOfDay(for: now)
                }
            }()
            
            return matchesType && matchesStatus && matchesDateRange
        }
    }
    
    private var groupedBookings: [(String, [Appointment])] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: filteredBookings) { booking -> String in
            if calendar.isDateInToday(booking.date) {
                return "Today"
            } else if calendar.isDateInTomorrow(booking.date) {
                return "Tomorrow"
            } else if booking.date > Date() {
                return "Upcoming"
            } else {
                return "Past"
            }
        }
        
        let order = ["Today", "Tomorrow", "Upcoming", "Past"]
        return order.compactMap { key in
            guard let items = grouped[key] else { return nil }
            return (key, items.sorted { $0.date > $1.date })
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Summary Cards
                BookingSummaryRow(bookings: bookings)
                    .padding(.horizontal)
                
                // Compact Filter Bar
                HStack(spacing: 12) {
                    // Active Filters Summary
                    HStack(spacing: 8) {
                        Image(systemName: "line.3.horizontal.decrease.circle\(hasActiveFilters ? ".fill" : "")")
                            .font(.title3)
                            .foregroundColor(hasActiveFilters ? .blue : .secondary)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Filters")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            if hasActiveFilters {
                                Text(activeFiltersText)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                            } else {
                                Text("All bookings")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Spacer()
                        
                        // Clear All button
                        if hasActiveFilters {
                            Button(action: clearAllFilters) {
                                Text("Clear All")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.red)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Color.red.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                        
                        // Expand/Collapse button
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                showFilters.toggle()
                            }
                        }) {
                            Image(systemName: showFilters ? "chevron.up" : "chevron.down")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                                .frame(width: 32, height: 32)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
                }
                .padding(.horizontal)

                // Expandable Filter Panel
                if showFilters {
                    VStack(spacing: 16) {
                        // Type Filter
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "list.bullet.rectangle")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                                Text("Type")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(BookingTypeFilter.allCases, id: \.self) { filter in
                                        BookingFilterChip(
                                            title: filter.rawValue,
                                            icon: iconForType(filter),
                                            isSelected: typeFilter == filter
                                        ) {
                                            withAnimation(.easeInOut(duration: 0.2)) {
                                                typeFilter = filter
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        Divider()
                            .padding(.horizontal)
                        
                        
                        
                        Divider()
                            .padding(.horizontal)
                        
                        // Date Range Filter
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "calendar")
                                    .font(.caption)
                                    .foregroundColor(.purple)
                                Text("Date Range")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(DateRangeFilter.allCases, id: \.self) { filter in
                                        DateRangeChip(
                                            title: filter.rawValue,
                                            icon: filter.icon,
                                            isSelected: dateRangeFilter == filter
                                        ) {
                                            withAnimation(.easeInOut(duration: 0.2)) {
                                                dateRangeFilter = filter
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.vertical, 16)
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
                    .padding(.horizontal)
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.95, anchor: .top).combined(with: .opacity),
                        removal: .scale(scale: 0.95, anchor: .top).combined(with: .opacity)
                    ))
                }
                
                // Bookings List
                if filteredBookings.isEmpty {
                    EmptyBookingsView(typeFilter: typeFilter, statusFilter: statusFilter)
                        .padding(.top, 40)
                }else {
                    LazyVStack(spacing: 20, pinnedViews: [.sectionHeaders]) {
                        ForEach(groupedBookings, id: \.0) { section, items in
                            Section {
                                VStack(spacing: 12) {
                                    ForEach(items) { booking in
                                        NavigationLink(destination: BookingDetailView(
                                            booking: binding(for: booking),
                                            shouldDismissAfterPayment: $shouldDismissDetailView,
                                            onPayNow: {
                                                if let idx = bookings.firstIndex(where: { $0.id == booking.id }) {
                                                    showLabPaymentFor = bookings[idx]
                                                } else {
                                                    showLabPaymentFor = booking
                                                }
                                            }
                                        )) {
                                            BookingCard(booking: booking)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            } header: {
                                HStack {
                                    Text(section)
                                        .font(.headline)
                                    
                                    Spacer()
                                    
                                    Text("\(items.count)")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(.secondary)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 2)
                                        .background(Color.gray.opacity(0.12))
                                        .cornerRadius(8)
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .background(Color(.systemGroupedBackground))
                            }
                        }
                    }
                }
            }
            .padding(.top, 12)
            .padding(.bottom, 40)
        }
        .safeAreaInset(edge: .top) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "flag")
                        .font(.caption)
                        .foregroundColor(.blue)

                    Text("Status")
                        .font(.subheadline)
                        .fontWeight(.semibold)

                    Spacer()

                    if statusFilter != .all {
                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                statusFilter = .all
                            }
                        } label: {
                            Text("Clear")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.red)
                        }
                    }
                }
                .padding(.horizontal)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(BookingStatusFilter.allCases, id: \.self) { filter in
                            StatusPill(
                                title: filter.rawValue,
                                count: countForStatus(filter),
                                isSelected: statusFilter == filter
                            ) {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    statusFilter = filter
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical, 12)
            .background(Color(.systemBackground))
            .shadow(color: .black.opacity(0.06), radius: 3, x: 0, y: 2)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("My Bookings")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $showLabPaymentFor) { booking in
            LabPaymentSheet(booking: booking) {
                // Mark as paid and confirmed, and assign queue number
                if let idx = bookings.firstIndex(where: { $0.id == booking.id }) {
                    // Create a new copy to force SwiftUI to detect the change
                    var updated = bookings[idx]
                    updated.paymentCompleted = true
                    updated.status = .confirmed
                    // Assign queue number and wait time if not already set
                    if updated.queueNumber == nil {
                        updated.queueNumber = Int.random(in: 1...15)
                        updated.estimatedWaitTime = Int.random(in: 15...45)
                    }
                    bookings[idx] = updated
                }
                showLabPaymentFor = nil
                // Pop BookingDetailView back to this list
                shouldDismissDetailView = true
            }
        }
    }
    
    //functions and helper methods
    private var hasActiveFilters: Bool {
        typeFilter != .all || statusFilter != .all || dateRangeFilter != .all
    }
    
    private var activeFiltersText: String {
        var parts: [String] = []
        if typeFilter != .all { parts.append(typeFilter.rawValue) }
        if statusFilter != .all { parts.append(statusFilter.rawValue) }
        if dateRangeFilter != .all { parts.append(dateRangeFilter.rawValue) }
        return parts.joined(separator: " • ")
    }
    
    private func clearAllFilters() {
        withAnimation(.easeInOut(duration: 0.2)) {
            typeFilter = .all
            statusFilter = .all
            dateRangeFilter = .all
        }
    }
    
    private func binding(for booking: Appointment) -> Binding<Appointment> {
        guard let idx = bookings.firstIndex(where: { $0.id == booking.id }) else {
            return .constant(booking)
        }
        return $bookings[idx]
    }
    
    private func iconForType(_ filter: BookingTypeFilter) -> String {
        switch filter {
        case .all:    return "list.bullet"
        case .doctor: return "stethoscope"
        case .lab:    return "flask.fill"
        }
    }
    
    private func countForStatus(_ filter: BookingStatusFilter) -> Int {
        bookings.filter { booking in
            let matchesType: Bool = {
                switch typeFilter {
                case .all:    return true
                case .doctor: return booking.type == AppointmentType.opd
                case .lab:    return booking.type == AppointmentType.laboratory
                }
            }()
            
            guard matchesType else { return false }
            
            switch filter {
            case .all:              return true
            case .upcoming:         return booking.isUpcoming
            case .pendingApproval:  return booking.isPendingApproval
            case .awaitingPayment:  return booking.isAwaitingPayment
            case .completed:        return booking.isCompleted
            case .cancelled:        return booking.isCancelled
            }
        }.count
    }
}

#Preview {
    NavigationView {
        MyBookingsView()
    }
}
