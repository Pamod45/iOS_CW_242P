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
    @State private var showLabPaymentFor: Appointment? = nil
    
    private var filteredBookings: [Appointment] {
        bookings.filter { booking in
            let matchesType: Bool = {
                switch typeFilter {
                case .all:    return true
                case .doctor: return booking.type == .opd
                case .lab:    return booking.type == .laboratory
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
            
            return matchesType && matchesStatus
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
                BookingSummaryRow(bookings: bookings)
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
                
                if filteredBookings.isEmpty {
                    EmptyBookingsView(typeFilter: typeFilter, statusFilter: statusFilter)
                        .padding(.top, 40)
                }
                else {
                    LazyVStack(spacing: 20, pinnedViews: [.sectionHeaders]) {
                        ForEach(groupedBookings, id: \.0) { section, items in
                            Section {
                                VStack(spacing: 12) {
                                    ForEach(items) { booking in
                                        NavigationLink(destination: BookingDetailView(booking: binding(for: booking), onPayNow: {
                                            showLabPaymentFor = booking
                                        })) {
                                            BookingCard(booking: booking)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                            header: {
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
        .background(Color(.systemGroupedBackground))
        .navigationTitle("My Bookings")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $showLabPaymentFor) { booking in
            LabPaymentSheet(booking: booking) {
                if let idx = bookings.firstIndex(where: { $0.id == booking.id }) {
                    bookings[idx].paymentCompleted = true
                    bookings[idx].status = .confirmed
                }
                showLabPaymentFor = nil
            }
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
                case .doctor: return booking.type == .opd
                case .lab:    return booking.type == .laboratory
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

extension Appointment: Equatable {
    static func == (lhs: Appointment, rhs: Appointment) -> Bool {
        lhs.id == rhs.id
    }
}

#Preview {
    NavigationView {
        MyBookingsView()
    }
}
