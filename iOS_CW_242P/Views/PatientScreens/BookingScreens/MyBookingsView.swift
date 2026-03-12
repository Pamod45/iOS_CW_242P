//
//  MyBookingsView.swift
//  iOS_CW_242P
//
//  Created by Liviru Navaratna on 2026-02-27.
//

import SwiftUI

struct MyBookingsView: View {
    let directCall: Bool
    @State private var bookings = MockData.sampleBookings
    @State private var typeFilter: BookingTypeFilter = .all
    @State private var statusFilter: BookingStatusFilter = .all
    @State private var dateRangeFilter: DateRangeFilter = .all
    @State private var showLabPaymentFor: Appointment? = nil
    @State private var shouldDismissDetailView = false
    @State private var showFilters = false
    @State private var refreshID = UUID()
    
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
    
    private var groupedBookings: [(String, [(Journey?, [Appointment])])] {
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
            
            let journeyGrouped = Dictionary(grouping: items) { booking in
                booking.journeyId ?? "no-journey-\(booking.id)"
            }
            
            let journeyGroups = journeyGrouped.map { journeyKey, bookings -> (Journey?, [Appointment]) in
                let journey = journeyKey.starts(with: "no-journey") ? nil : MockData.sampleJourneys.first(where: { $0.id == journeyKey })
                
                let sortedBookings = bookings.sorted { first, second in
                    let firstStatusPriority = statusSortPriority(for: first.status)
                    let secondStatusPriority = statusSortPriority(for: second.status)
                    
                    if firstStatusPriority != secondStatusPriority {
                        return firstStatusPriority < secondStatusPriority
                    }
                    
                    let firstTypePriority = typeSortPriority(for: first.type)
                    let secondTypePriority = typeSortPriority(for: second.type)
                    
                    if firstTypePriority != secondTypePriority {
                        return firstTypePriority < secondTypePriority
                    }
                    
                    if calendar.isDate(first.date, inSameDayAs: second.date) {
                        let firstSessionTime = sessionSortOrder(for: first)
                        let secondSessionTime = sessionSortOrder(for: second)
                        
                        if firstSessionTime != secondSessionTime {
                            return firstSessionTime < secondSessionTime
                        }
                        
                        let firstWaitTime = first.estimatedWaitTime ?? 0
                        let secondWaitTime = second.estimatedWaitTime ?? 0
                        return firstWaitTime < secondWaitTime
                    }
                    return first.date < second.date
                }
                return (journey, sortedBookings)
            }.sorted { first, second in
                let firstBooking = first.1.first!
                let secondBooking = second.1.first!
                
                if let firstJourney = first.0, let secondJourney = second.0 {
                    let firstJourneyPriority = journeyStatusPriority(firstJourney.status)
                    let secondJourneyPriority = journeyStatusPriority(secondJourney.status)
                    if firstJourneyPriority != secondJourneyPriority {
                        return firstJourneyPriority < secondJourneyPriority
                    }
                }
                
                let firstStatusPriority = statusSortPriority(for: firstBooking.status)
                let secondStatusPriority = statusSortPriority(for: secondBooking.status)
                
                if firstStatusPriority != secondStatusPriority {
                    return firstStatusPriority < secondStatusPriority
                }
                
                let firstTypePriority = typeSortPriority(for: firstBooking.type)
                let secondTypePriority = typeSortPriority(for: secondBooking.type)
                
                if firstTypePriority != secondTypePriority {
                    return firstTypePriority < secondTypePriority
                }
                
                if calendar.isDate(firstBooking.date, inSameDayAs: secondBooking.date) {
                    let firstSessionTime = sessionSortOrder(for: firstBooking)
                    let secondSessionTime = sessionSortOrder(for: secondBooking)
                    
                    if firstSessionTime != secondSessionTime {
                        return firstSessionTime < secondSessionTime
                    }
                    
                    let firstWaitTime = firstBooking.estimatedWaitTime ?? 0
                    let secondWaitTime = secondBooking.estimatedWaitTime ?? 0
                    return firstWaitTime < secondWaitTime
                }
                return firstBooking.date < secondBooking.date
            }
            
            return (key, journeyGroups)
        }
    }
    
    private func journeyStatusPriority(_ status: JourneyStatus) -> Int {
        switch status {
        case .inProgress:
            return 0
        case .pending:
            return 1
        case .completed:
            return 2
        case .cancelled:
            return 3
        }
    }
    
    private func statusSortPriority(for status: AppointmentStatus) -> Int {
        switch status {
        case .inProgress:
            return 0
        case .confirmed, .pending:
            return 1
        case .completed:
            return 2
        case .cancelled:
            return 3
        }
    }
    
    private func typeSortPriority(for type: AppointmentType) -> Int {
        switch type {
        case .opd:
            return 0
        case .laboratory:
            return 1
        }
    }
    
    private func sessionSortOrder(for booking: Appointment) -> Int {
        guard let session = MockData.sessions.first(where: { $0.id == booking.sessionId }) else {
            return 9999
        }
        let components = session.startTime.split(separator: ":")
        guard components.count == 2,
              let hours = Int(components[0]),
              let minutes = Int(components[1]) else {
            return 9999
        }
        return hours * 60 + minutes
    }
    
    private var statusFilterScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(BookingStatusFilter.allCases, id: \.self) { filter in
                    FilterChip(
                        title: filter.rawValue,
                        isSelected: statusFilter == filter,
                        count: countForStatus(filter)
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
    
    private var filterHeaderSection: some View {
        HStack(spacing: 12) {
            HStack(spacing: 8) {
                let iconName = (typeFilter != .all || dateRangeFilter != .all) ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle"
                Image(systemName: iconName)
                    .font(.title3)
                    .foregroundColor(hasActiveFilters ? .secondary.opacity(0.6) : .secondary)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Filters")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    if typeFilter != .all || dateRangeFilter != .all {
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
                
                if typeFilter != .all || dateRangeFilter != .all  {
                    Button(action: clearAllFilters) {
                        Text("Clear All")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.blue)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
                
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        showFilters.toggle()
                    }
                }) {
                    Image(systemName: showFilters ? "chevron.up" : "chevron.down")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .frame(width: 32, height: 32)
                        .background(.black.opacity(0.05))
                        .cornerRadius(8)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
        }
        .padding(.horizontal)
    }
    
    private var filterPanel: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Type")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Spacer()
                }
                .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(BookingTypeFilter.allCases, id: \.self) { filter in
                            StatusFilterChip(
                                title: filter.rawValue,
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
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Date Range")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Spacer()
                }
                .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(DateRangeFilter.allCases, id: \.self) { filter in
                            StatusFilterChip(
                                title: filter.rawValue,
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
    
    private var bookingsListView: some View {
        ScrollView {
            VStack(spacing: 20) {
                if filteredBookings.isEmpty {
                    EmptyBookingsView(typeFilter: typeFilter, statusFilter: statusFilter)
                        .padding(.top, 40)
                } else {
                    LazyVStack(spacing: 20, pinnedViews: [.sectionHeaders]) {
                        ForEach(groupedBookings, id: \.0) { section, journeyGroups in
                            Section {
                                VStack(spacing: 20) {
                                    ForEach(Array(journeyGroups.enumerated()), id: \.offset) { index, journeyGroup in
                                        journeyGroupView(journeyGroup)
                                    }
                                }
                                .padding(.horizontal)
                            } header: {
                                sectionHeader(section: section, count: journeyGroups.reduce(0) { $0 + $1.1.count })
                            }
                        }
                    }
                }
            }
            .padding(.top, 12)
            .padding(.bottom, 40)
        }
    }
    
    private func sectionHeader(section: String, count: Int) -> some View {
        HStack {
            Text(section)
                .font(.headline)
            
            Text("\(count)")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(Color.black.opacity(0.6))
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .background(Color.gray.opacity(0.12))
                .cornerRadius(8)
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemGroupedBackground))
    }
    
    private func journeyGroupView(_ journeyGroup: (Journey?, [Appointment])) -> some View {
        VStack(spacing: 0) {
            if let journey = journeyGroup.0 {
                VStack(spacing: 0) {
                    HStack(spacing: 12) {
                        
                        Text("Journey")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        Text(journey.status.displayText)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        NavigationLink(destination: JourneyView(journeyId: journey.id)) {
                            HStack(spacing: 4) {
                                Text("View")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                            }
                            .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.blue.opacity(0.05))
                }
            }
            
            VStack(spacing: 12) {
                ForEach(journeyGroup.1.indices, id: \.self) { index in
                    let booking = journeyGroup.1[index]

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
                        BookingCard(booking: booking, onPayNow: {
                            if let idx = bookings.firstIndex(where: { $0.id == booking.id }) {
                                showLabPaymentFor = bookings[idx]
                            } else {
                                showLabPaymentFor = booking
                            }
                        })
                    }

                    if index != journeyGroup.1.count - 1 {
                        Divider()
                    }
                }
            }
            .padding(journeyGroup.0 != nil ? 12 : 0)
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
    
    private var myBookingsBody: some View {
        VStack(spacing: 20){
            statusFilterScrollView
            filterHeaderSection
            if showFilters {
                filterPanel
            }
            bookingsListView
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("My Bookings")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $showLabPaymentFor) { booking in
            LabPaymentSheet(booking: booking) {
                if let idx = bookings.firstIndex(where: { $0.id == booking.id }) {
                    var updated = bookings[idx]
                    updated.paymentCompleted = true
                    updated.status = .confirmed
                    if updated.queueNumber == nil {
                        updated.queueNumber = Int.random(in: 1...15)
                        updated.estimatedWaitTime = Int.random(in: 15...45)
                    }
                    bookings[idx] = updated
                }
                showLabPaymentFor = nil
                shouldDismissDetailView = true
            }
        }
    }
    
    private func journeyStatusColor(_ status: JourneyStatus) -> Color {
        switch status {
        case .inProgress:
            return .blue
        case .pending:
            return .orange
        case .completed:
            return .gray
        case .cancelled:
            return .red
        }
    }
    
    var body: some View {
        if directCall {
            NavigationView{
                myBookingsBody
                    .id(refreshID)
            }
            .onAppear {
                bookings = MockData.sampleBookings
                refreshID = UUID()
            }
        }
        else {
            myBookingsBody
                .id(refreshID)
                .onAppear {
                    bookings = MockData.sampleBookings
                    refreshID = UUID()
                }
        }
    }
    
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
        MyBookingsView(directCall: false)
    }
}
