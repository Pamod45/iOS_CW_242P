//
//  BookingDetailView.swift
//  iOS_CW_242P
//
//  Created by Liviru Navaratna on 2026-02-27.
//

import SwiftUI

struct BookingDetailView: View {
    @Binding var booking: Appointment
    let onPayNow: () -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var localBooking: Appointment
    @Binding var shouldDismissAfterPayment: Bool
    
    @State private var showRescheduleSheet = false
    @State private var showCancelAlert = false
    @State private var rescheduleDate = Date()
    @State private var rescheduleSession: Session? = nil
    @State private var showSuccessAlert = false
    @State private var successMessage = ""

    init(booking: Binding<Appointment>, shouldDismissAfterPayment: Binding<Bool>, onPayNow: @escaping () -> Void) {
        self._booking = booking
        self._shouldDismissAfterPayment = shouldDismissAfterPayment
        self.onPayNow = onPayNow
        self._localBooking = State(initialValue: booking.wrappedValue)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if localBooking.isUpcoming && !localBooking.isPendingApproval && !localBooking.isAwaitingPayment {
                    if let queue = localBooking.queueNumber, let wait = localBooking.estimatedWaitTime {
                        CompactQueueCard(
                            queueNumber: queue,
                            estimatedWait: wait,
                            room: localBooking.doctorRoom ?? (localBooking.type == .opd ? "Room 101" : "Lab Room 1"),
                            appointmentType: localBooking.type
                        )
                        .padding(.horizontal)
                    }
                    
                    BookingInfoCard(booking: localBooking)
                        .padding(.horizontal)
                    
                    if localBooking.type == .laboratory, let tests = localBooking.labTests {
                        LabTestsCard(tests: tests, approvalStatus: localBooking.approvalStatus)
                            .padding(.horizontal)
                    }
                    
                    PaymentInfoCard(booking: localBooking)
                        .padding(.horizontal)
                    
                    if canModifyBooking {
                        HStack(spacing: 12) {
                            Button(action: { showRescheduleSheet = true }) {
                                HStack {
                                    Image(systemName: "calendar.badge.clock")
                                    Text("Reschedule")
                                        .fontWeight(.semibold)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                            }
                            
                            Button(action: { showCancelAlert = true }) {
                                HStack {
                                    Image(systemName: "xmark.circle")
                                    Text("Cancel")
                                        .fontWeight(.semibold)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal)
                    } else if !localBooking.isCompleted && !localBooking.isCancelled {
                        HStack(spacing: 12) {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(.orange)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Modification Not Allowed")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                Text("Changes can only be made 24 hours before the appointment")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                } else {
                    BookingStatusHeader(booking: localBooking)
                        .padding(.horizontal)
                    
                    BookingInfoCard(booking: localBooking)
                        .padding(.horizontal)
                    
                    if localBooking.type == .laboratory, let tests = localBooking.labTests {
                        LabTestsCard(tests: tests, approvalStatus: localBooking.approvalStatus)
                            .padding(.horizontal)
                    }
                    
                    PaymentInfoCard(booking: localBooking)
                        .padding(.horizontal)
                    
                    if localBooking.isAwaitingPayment {
                        PrimaryButton(
                            title: "Pay Now — Rs. \(String(format: "%.2f", localBooking.amount))",
                            action: onPayNow
                        )
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.top, 16)
            .padding(.bottom, 40)
        }
        .background(Color(.systemGroupedBackground))
        .onChange(of: booking.paymentCompleted) { oldValue, newValue in
            localBooking = booking
        }
        .onChange(of: shouldDismissAfterPayment) { oldValue, newValue in
            if newValue {
                shouldDismissAfterPayment = false
                dismiss()
            }
        }
        .sheet(isPresented: $showRescheduleSheet) {
            RescheduleSheet(
                booking: localBooking,
                rescheduleDate: $rescheduleDate,
                rescheduleSession: $rescheduleSession,
                onConfirm: confirmReschedule
            )
        }
        .alert("Cancel Booking", isPresented: $showCancelAlert) {
            Button("Cancel Booking", role: .destructive) {
                cancelBooking()
            }
            Button("Keep Booking", role: .cancel) {}
        } message: {
            Text("Are you sure you want to cancel this booking? This action cannot be undone.")
        }
        .alert(successMessage, isPresented: $showSuccessAlert) {
            Button("OK", role: .cancel) {
                dismiss()
            }
        }
    }
        
    
    private var canModifyBooking: Bool {
        
        guard localBooking.status == .confirmed || localBooking.status == .pending else {
            return false
        }
        
        if localBooking.isAwaitingPayment || localBooking.isPendingApproval {
            return false
        }
        
        let calendar = Calendar.current
        let bookingDateTime = calendar.startOfDay(for: localBooking.date)
        
        if let session = MockData.sessions.first(where: { $0.id == localBooking.sessionId }) {
            let components = session.startTime.split(separator: ":")
            if components.count == 2,
               let hour = Int(components[0]),
               let minute = Int(components[1]) {
                if let sessionStartDateTime = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: bookingDateTime) {
                    let twentyFourHoursBefore = calendar.date(byAdding: .hour, value: -24, to: sessionStartDateTime) ?? sessionStartDateTime
                    return Date() < twentyFourHoursBefore
                }
            }
        }
        
        return false
    }
        
    private func confirmReschedule() {
        guard let newSession = rescheduleSession else { return }
        
        var updated = localBooking
        updated.date = rescheduleDate
        updated.sessionId = newSession.id
        updated.queueNumber = Int.random(in: 1...15)
        updated.estimatedWaitTime = newSession.averageConsultationTimeInMinutes * newSession.currentQueueNumber
        
        booking = updated
        localBooking = updated
        
        successMessage = "Booking rescheduled successfully to \(rescheduleDate.formatted(date: .long, time: .omitted)) at \(newSession.displayTime)"
        showSuccessAlert = true
        showRescheduleSheet = false
    }
    
    private func cancelBooking() {
        var updated = localBooking
        updated.status = .cancelled
        
        booking = updated
        localBooking = updated
        
        successMessage = "Booking cancelled successfully. You will receive a full refund within 3-5 business days."
        showSuccessAlert = true
    }
}

#Preview {
    NavigationView {
        BookingDetailView(
            booking: .constant(MockData.sampleBookings[2]),
            shouldDismissAfterPayment: .constant(false),
            onPayNow: {}
        )
    }
}

