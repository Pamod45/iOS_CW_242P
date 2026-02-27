//
//  MyBookingsView.swift
//  iOS_CW_242P
//
//  Created by Liviru Navaratna on 2026-02-27.
//

import SwiftUI

// MARK: - Main View

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
                // Summary Cards
                BookingSummaryRow(bookings: bookings)
                    .padding(.horizontal)
                
                // Type Filter
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
                
                // Status Filter
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
                
                // Bookings List
                if filteredBookings.isEmpty {
                    EmptyBookingsView(typeFilter: typeFilter, statusFilter: statusFilter)
                        .padding(.top, 40)
                } else {
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
        .background(Color(.systemGroupedBackground))
        .navigationTitle("My Bookings")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $showLabPaymentFor) { booking in
            LabPaymentSheet(booking: booking) {
                // Mark as paid
                if let idx = bookings.firstIndex(where: { $0.id == booking.id }) {
                    bookings[idx].paymentCompleted = true
                    bookings[idx].status = .confirmed
                }
                showLabPaymentFor = nil
            }
        }
    }
    
    // MARK: - Helpers
    
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

// MARK: - Summary Row

struct BookingSummaryRow: View {
    let bookings: [Appointment]
    
    private var upcoming: Int { bookings.filter { $0.isUpcoming }.count }
    private var pending: Int { bookings.filter { $0.isPendingApproval }.count }
    private var awaitingPay: Int { bookings.filter { $0.isAwaitingPayment }.count }
    
    var body: some View {
        HStack(spacing: 12) {
            SummaryMini(value: "\(upcoming)", label: "Upcoming", color: .blue, icon: "calendar")
            SummaryMini(value: "\(pending)", label: "Pending", color: .orange, icon: "clock")
            SummaryMini(value: "\(awaitingPay)", label: "To Pay", color: .red, icon: "creditcard")
        }
    }
}

struct SummaryMini: View {
    let value: String
    let label: String
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Filter Chips

struct BookingFilterChip: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption)
                Text(title)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .semibold : .regular)
            }
            .foregroundColor(isSelected ? .white : .primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(isSelected ? Color.blue : Color(.systemBackground))
            )
            .overlay(
                Capsule()
                    .stroke(isSelected ? Color.clear : Color.gray.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: isSelected ? Color.blue.opacity(0.3) : .clear, radius: 4, x: 0, y: 2)
        }
    }
}

struct StatusPill: View {
    let title: String
    let count: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                Text(title)
                    .font(.caption)
                    .fontWeight(isSelected ? .semibold : .regular)
                
                if count > 0 {
                    Text("\(count)")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(isSelected ? .blue : .secondary)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 1)
                        .background(
                            Capsule()
                                .fill(isSelected ? Color.white : Color.gray.opacity(0.12))
                        )
                }
            }
            .foregroundColor(isSelected ? .white : .secondary)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(isSelected ? Color.blue.opacity(0.8) : Color(.systemBackground))
            )
            .overlay(
                Capsule()
                    .stroke(isSelected ? Color.clear : Color.gray.opacity(0.15), lineWidth: 1)
            )
        }
    }
}

// MARK: - Booking Card

struct BookingCard: View {
    let booking: Appointment
    
    private var typeColor: Color {
        booking.type == .opd ? .blue : .green
    }
    
    private var statusColor: Color {
        switch booking.status {
        case .pending:    return .orange
        case .confirmed:  return .blue
        case .inProgress: return .purple
        case .completed:  return .green
        case .cancelled:  return .red
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Top row: type + status
            HStack {
                // Type badge
                HStack(spacing: 5) {
                    Image(systemName: booking.type == .opd ? "stethoscope" : "flask.fill")
                        .font(.caption2)
                    Text(booking.type.rawValue)
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .foregroundColor(typeColor)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(typeColor.opacity(0.1))
                .cornerRadius(8)
                
                Spacer()
                
                // Status badge
                Text(statusDisplayText)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(statusColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(statusColor.opacity(0.1))
                    .cornerRadius(8)
            }
            
            // Main info
            HStack(spacing: 14) {
                // Date block
                VStack(spacing: 2) {
                    Text(dayString)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.primary)
                    Text(monthString)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                }
                .frame(width: 48, height: 48)
                .background(Color.gray.opacity(0.08))
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(booking.type == .opd ? (booking.reasonForVisit ?? "Doctor Appointment") : labTestNames)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    HStack(spacing: 12) {
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .font(.caption2)
                            Text(booking.sessionDisplay)
                                .font(.caption)
                        }
                        .foregroundColor(.secondary)
                        
                        if let room = booking.doctorRoom {
                            HStack(spacing: 4) {
                                Image(systemName: "door.left.hand.open")
                                    .font(.caption2)
                                Text(room)
                                    .font(.caption)
                            }
                            .foregroundColor(.secondary)
                        }
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Action row for awaiting payment
            if booking.isAwaitingPayment {
                HStack {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(.orange)
                        .font(.caption)
                    Text("Payment required — Rs. \(String(format: "%.2f", booking.amount))")
                        .font(.caption)
                        .foregroundColor(.orange)
                        .fontWeight(.medium)
                    Spacer()
                    Text("Pay Now")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
                .padding(.top, 4)
            }
        }
        .padding(14)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
    
    // MARK: Helpers
    
    private var statusDisplayText: String {
        if booking.isPendingApproval { return "Pending Approval" }
        if booking.isAwaitingPayment { return "Awaiting Payment" }
        if booking.approvalStatus == .rejected { return "Rejected" }
        return booking.status.rawValue
    }
    
    private var labTestNames: String {
        booking.labTests?.map { $0.name }.joined(separator: ", ") ?? "Lab Tests"
    }
    
    private var dayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: booking.date)
    }
    
    private var monthString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.string(from: booking.date).uppercased()
    }
}

// MARK: - Empty State

struct EmptyBookingsView: View {
    let typeFilter: BookingTypeFilter
    let statusFilter: BookingStatusFilter
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 48))
                .foregroundColor(.gray.opacity(0.4))
            
            Text("No Bookings Found")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("No \(typeFilter == .all ? "" : typeFilter.rawValue.lowercased() + " ")\(statusFilter == .all ? "" : statusFilter.rawValue.lowercased() + " ")bookings to show.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
}

// MARK: - Lab Payment Sheet

struct LabPaymentSheet: View {
    let booking: Appointment
    let onPaymentComplete: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var isProcessing = false
    @State private var showSuccess = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "creditcard.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.blue)
                        .frame(width: 80, height: 80)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(20)
                    
                    Text("Complete Payment")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Text("Pay for your approved lab tests")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)
                
                // Tests summary
                VStack(alignment: .leading, spacing: 12) {
                    Text("Lab Tests")
                        .font(.headline)
                    
                    if let tests = booking.labTests {
                        ForEach(tests) { test in
                            HStack {
                                Image(systemName: "flask.fill")
                                    .foregroundColor(.green)
                                    .font(.caption)
                                
                                Text(test.name)
                                    .font(.subheadline)
                                
                                Spacer()
                                
                                Text("Rs. \(String(format: "%.2f", test.price))")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Total")
                            .font(.headline)
                        Spacer()
                        Text("Rs. \(String(format: "%.2f", booking.amount))")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Date & Session
                HStack(spacing: 16) {
                    InfoCard(
                        title: "Date",
                        value: booking.displayDate,
                        icon: "calendar",
                        iconColor: .blue
                    )
                    InfoCard(
                        title: "Session",
                        value: booking.sessionDisplay,
                        icon: "clock",
                        iconColor: .purple
                    )
                }
                .padding(.horizontal)
                
                Spacer()
                
                if showSuccess {
                    HStack(spacing: 10) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Payment Successful!")
                            .font(.headline)
                            .foregroundColor(.green)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                
                // Pay button
                PrimaryButton(
                    title: showSuccess ? "Done" : "Pay Rs. \(String(format: "%.2f", booking.amount))",
                    action: {
                        if showSuccess {
                            onPaymentComplete()
                        } else {
                            processPayment()
                        }
                    },
                    isLoading: isProcessing,
                    isDisabled: false
                )
                .padding(.horizontal)
                .padding(.bottom)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Payment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
    
    private func processPayment() {
        isProcessing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isProcessing = false
            showSuccess = true
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
    }
}

// MARK: - Identifiable conformance for sheet

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
