//
//  JourneyView.swift
//  iOS_CW_242P
//
//  Created by Pubudu Perera on 2026-03-09.
//

import SwiftUI
struct JourneyView: View {
    let journeyId: String
    @State var journey: Journey
    @State private var showOPDSelection = false
    @State private var showLabSelection = false
    
    init(journeyId: String) {
        self.journeyId = journeyId
        if let foundJourney = MockData.sampleJourneys.first(where: { $0.id == journeyId }) {
            self._journey = State(initialValue: foundJourney)
        } else {
            self._journey = State(initialValue: Journey(patientID: "user123", date: Date()))
        }
    }
    
    private var completionPercentage: Double {
        let displaySteps = journey.steps.filter { $0.type != .opdCheckIn }
        let completedCount = displaySteps.filter { $0.computedStatus == .completed }.count
        let totalCount = displaySteps.filter { $0.computedStatus != .skipped }.count
        return totalCount > 0 ? Double(completedCount) / Double(totalCount) : 0
    }
    
    private var currentStep: JourneyStep? {
        journey.steps.filter { $0.type != .opdCheckIn }.first { $0.computedStatus == .inProgress }
    }
    
    private var displaySteps: [JourneyStep] {
        journey.steps.filter { $0.type != .opdCheckIn }
    }
    
    private var isJourneyEditable: Bool {
        Calendar.current.isDateInToday(journey.date)
    }
    
    private var availableOPDBookings: [Appointment] {
        MockData.sampleBookings.filter { booking in
            booking.type == .opd &&
            Calendar.current.isDate(booking.date, inSameDayAs: journey.date) &&
            !journey.steps.contains { $0.bookingID == booking.id }
        }
    }
    
    private var availableLabBookings: [Appointment] {
        MockData.sampleBookings.filter { booking in
            booking.type == .laboratory &&
            Calendar.current.isDate(booking.date, inSameDayAs: journey.date) &&
            !journey.steps.contains { $0.bookingID == booking.id }
        }
    }
    
    private var suggestedSteps: [SuggestedStep] {
        var steps: [SuggestedStep] = []
        
        let hasPharmacy = journey.steps.contains { $0.type == .pharmacy }
        let hasCheckout = journey.steps.contains { $0.type == .checkout }
        
        if !availableOPDBookings.isEmpty {
            steps.append(SuggestedStep(
                icon: "stethoscope",
                title: "OPD Check-In",
                stepType: .doctorConsultation,
                bookingID: nil
            ))
        }
        
        if !availableLabBookings.isEmpty {
            steps.append(SuggestedStep(
                icon: "flask.fill",
                title: "Lab Check-In",
                stepType: .laboratory,
                bookingID: nil
            ))
        }
        
        if !hasPharmacy {
            steps.append(SuggestedStep(
                icon: "pills.fill",
                title: "Pharmacy",
                stepType: .pharmacy,
                bookingID: nil
            ))
        }
        
        if !hasCheckout {
            steps.append(SuggestedStep(
                icon: "checkmark.circle.fill",
                title: "Checkout",
                stepType: .checkout,
                bookingID: nil
            ))
        }
        
        return steps
    }
    
    var body: some View {
        ScrollView{
            VStack(spacing:32){
                ZStack{
                    Circle().stroke(Color(.systemGray5), lineWidth: 16)
                    
                    Circle().trim(from: 0, to: completionPercentage).stroke(Color.blue, style: StrokeStyle(lineWidth: 16, lineCap: .round)).rotationEffect(.degrees(-90))
                    
                    VStack{
                        Text("\(Int(completionPercentage * 100))%").font(.largeTitle).fontWeight(.bold)
                        Text("Completed").foregroundColor(.secondary)
                    }
                }.padding(.horizontal,104)
                
                VStack(alignment:.center){
                    Text("Please follow the steps to complete \n your journey").multilineTextAlignment(.center).foregroundColor(Color(.systemGray))
                        .font(.subheadline)
                        .fontWeight(.regular)
                }
                
                if let current = currentStep {
                    VStack(alignment:.leading, spacing: 0){
                        VStack(spacing: 16){
                            HStack(alignment: .top, spacing: 16){
                                Image(systemName: stepIcon(for: current.type))
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.blue)
                                    .padding(12)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(12)
                                VStack (alignment: .leading){
                                    Text("Current Step").font(.footnote).foregroundColor(.secondary)
                                    Text(stepTitle(for: current.type)).font(.title3).fontWeight(.bold)
                                    if let location = stepLocation(for: current.type) {
                                        Text(location).font(.footnote).foregroundColor(.secondary)
                                    }
                                }
                                
                                Spacer()
                            }
                            
                            if current.type == .doctorConsultation || current.type == .laboratory {
                                Divider()
                                VStack(){
                                    HStack(spacing: 24){
                                        if let booking = getBooking(for: current) {
                                            if let queueNumber = booking.queueNumber {
                                                VStack(alignment: .center,spacing: 4){
                                                    Text("Queue No #").font(.footnote).foregroundColor(.secondary)
                                                    Text("\(queueNumber)").foregroundColor(.blue).fontWeight(.bold)
                                                }
                                            }
                                            if let waitTime = booking.estimatedWaitTime {
                                                VStack(alignment: .center, spacing: 4){
                                                    Text("Wait Time").font(.footnote).foregroundColor(.secondary)
                                                    Text("~ \(waitTime) min").foregroundColor(.orange).fontWeight(.bold)
                                                }
                                            }
                                        }
                                        Spacer()
                                        Image(systemName: "location.fill")
                                            .font(.title2)
                                            .padding()
                                            .background(Color.white.opacity(0.6))
                                            .clipShape(Circle())
                                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                                    }
                                }
                            }
                            
                            if current.type == .pharmacy || current.type == .checkout {
                                Divider()
                                VStack(spacing: 12) {
                                    HStack(spacing: 12) {
                                        Button(action: {
                                            completeStep(current)
                                        }) {
                                            HStack {
                                                Image(systemName: "checkmark.circle.fill")
                                                Text("Complete")
                                            }
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 12)
                                            .background(Color.green)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                        }
                                        .disabled(!isJourneyEditable)
                                        .opacity(isJourneyEditable ? 1.0 : 0.5)
                                        
                                        Button(action: {
                                            skipStep(current)
                                        }) {
                                            HStack {
                                                Image(systemName: "forward.fill")
                                                Text("Skip")
                                            }
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 12)
                                            .background(Color.orange)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                        }
                                        .disabled(!isJourneyEditable)
                                        .opacity(isJourneyEditable ? 1.0 : 0.5)
                                    }
                                    
                                    Button(action: {
                                        removeStep(current)
                                    }) {
                                        HStack {
                                            Image(systemName: "trash.fill")
                                            Text("Remove from Journey")
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(Color.red.opacity(0.1))
                                        .foregroundColor(.red)
                                        .cornerRadius(10)
                                    }
                                    .disabled(!isJourneyEditable)
                                    .opacity(isJourneyEditable ? 1.0 : 0.5)
                                }
                            }
                        }.padding()
                    }.background(.gray.opacity(0.08)).cornerRadius(16)
                }
                
                VStack(){
                    ForEach(displaySteps) { step in
                        stepRow(for: step)
                            .contextMenu {
                                if isJourneyEditable && step.computedStatus == .pending {
                                    if step.type == .pharmacy || step.type == .checkout {
                                        Button(role: .destructive) {
                                            removeStep(step)
                                        } label: {
                                            Label("Remove", systemImage: "trash")
                                        }
                                    }
                                    
                                    if let currentIndex = displaySteps.firstIndex(where: { $0.id == step.id }) {
                                        if currentIndex > 0 {
                                            Button {
                                                moveStep(step, direction: .up)
                                            } label: {
                                                Label("Move Up", systemImage: "arrow.up")
                                            }
                                        }
                                        
                                        if currentIndex < displaySteps.count - 1 {
                                            Button {
                                                moveStep(step, direction: .down)
                                            } label: {
                                                Label("Move Down", systemImage: "arrow.down")
                                            }
                                        }
                                    }
                                }
                            }
                        if step.id != displaySteps.last?.id {
                            Divider().padding(.horizontal)
                        }
                    }
                }.background().cornerRadius(16)
                
                if !suggestedSteps.isEmpty && isJourneyEditable {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Add to Journey").font(.headline).foregroundColor(.primary)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(suggestedSteps) { suggested in
                                    Button(action: {
                                        handleSuggestedStepTap(suggested)
                                    }) {
                                        VStack(spacing: 8) {
                                            Image(systemName: suggested.icon)
                                                .font(.title2)
                                                .foregroundColor(.blue)
                                            
                                            Text(suggested.title)
                                                .font(.caption)
                                                .foregroundColor(.primary)
                                                .multilineTextAlignment(.center)
                                                .lineLimit(2)
                                        }
                                        .frame(width: 100, height: 80)
                                        .background(Color.white)
                                        .cornerRadius(12)
                                        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }.padding(.vertical)
             .padding(.horizontal)
            
        }.background(Color(.systemGroupedBackground))
            .navigationTitle("My Journey")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showOPDSelection) {
                BookingSelectionSheet(
                    title: "Select OPD Check-In",
                    bookings: availableOPDBookings,
                    onSelect: { booking in
                        addBookingToJourney(booking, stepType: .doctorConsultation)
                        showOPDSelection = false
                    }
                )
            }
            .sheet(isPresented: $showLabSelection) {
                BookingSelectionSheet(
                    title: "Select Lab Check-In",
                    bookings: availableLabBookings,
                    onSelect: { booking in
                        addBookingToJourney(booking, stepType: .laboratory)
                        showLabSelection = false
                    }
                )
            }
    }
    
    @ViewBuilder
    private func stepRow(for step: JourneyStep) -> some View {
        let displayStatus = step.computedStatus
        
        HStack(alignment: .top, spacing: 16){
            Image(systemName: statusIcon(for: displayStatus))
                .font(.footnote)
                .foregroundColor(statusColor(for: displayStatus))
                .padding(.all,10)
                .background(statusColor(for: displayStatus).opacity(0.2))
                .fontWeight(.bold)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 6){
                HStack(spacing: 8){
                    Image(systemName: stepIcon(for: step.type))
                        .foregroundColor(statusColor(for: displayStatus))
                        .font(.headline)
                    Text(stepTitle(for: step.type))
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                
                Text(stepDescription(for: step.type))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if displayStatus != .completed {
                    if let location = stepLocation(for: step.type), !location.isEmpty {
                        HStack(spacing: 6){
                            Image(systemName: "location").font(.caption).foregroundColor(.blue)
                            Text(location).font(.footnote).foregroundColor(.blue)
                        }
                    }
                }
                
                if step.type == .laboratory {
                    if let booking = getBooking(for: step), let tests = booking.labTests, !tests.isEmpty {
                        Text(tests.map { $0.name }.joined(separator: ", "))
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .padding(.all,8)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                }
            }.frame(maxWidth:.infinity, alignment: .leading)
            
            VStack(spacing: 8) {
                Text(statusText(for: displayStatus))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(statusColor(for: displayStatus))
                    .padding(.all,8)
                    .background(statusColor(for: displayStatus).opacity(0.1))
                    .cornerRadius(8)
                
                if displayStatus == .pending {
                    HStack(spacing: 8) {
                        if canMoveUp(step) && isJourneyEditable {
                            Button(action: {
                                moveStep(step, direction: .up)
                            }) {
                                Image(systemName: "arrow.up.circle.fill")
                                    .font(.title3)
                                    .foregroundColor(.blue)
                            }
                        }
                        
                        if canMoveDown(step) && isJourneyEditable {
                            Button(action: {
                                moveStep(step, direction: .down)
                            }) {
                                Image(systemName: "arrow.down.circle.fill")
                                    .font(.title3)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                
                if displayStatus == .inProgress {
                    Spacer()
                    
                    Button(action: {
                        completeStepInList(step)
                    }) {
                        Text("Complete")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(Color.blue.opacity(0.8))
                            .cornerRadius(8)
                    }
                    .frame(width: 100)
                    .disabled(!isJourneyEditable)
                    .opacity(isJourneyEditable ? 1.0 : 0.5)
                }
            }
        }
        .padding()
    }
    
    private func stepIcon(for type: JourneyStep.StepType) -> String {
        switch type {
        case .opdCheckIn: return "person.badge.plus"
        case .doctorConsultation: return "stethoscope"
        case .laboratory: return "flask"
        case .pharmacy: return "pill"
        case .checkout: return "checkmark.circle.fill"
        }
    }
    
    private func stepTitle(for type: JourneyStep.StepType) -> String {
        switch type {
        case .opdCheckIn: return "Registration"
        case .doctorConsultation: return "Doctor Consultation"
        case .laboratory: return "Laboratory"
        case .pharmacy: return "Pharmacy"
        case .checkout: return "Checkout"
        }
    }
    
    private func stepDescription(for type: JourneyStep.StepType) -> String {
        switch type {
        case .opdCheckIn: return "Complete your registration"
        case .doctorConsultation: return "Meet with your doctor"
        case .laboratory: return "Complete lab tests"
        case .pharmacy: return "Collect your medicine"
        case .checkout: return "Complete your visit"
        }
    }
    
    private func stepLocation(for type: JourneyStep.StepType) -> String? {
        switch type {
        case .opdCheckIn: return "Reception"
        case .doctorConsultation: return nil
        case .laboratory: return "Lab Room"
        case .pharmacy: return "Pharmacy Counter"
        case .checkout: return "Reception"
        }
    }
    
    private func statusIcon(for status: StepStatus) -> String {
        switch status {
        case .completed: return "checkmark"
        case .inProgress: return "circle.fill"
        case .pending: return "circle"
        case .skipped: return "xmark"
        }
    }
    
    private func statusColor(for status: StepStatus) -> Color {
        switch status {
        case .completed: return .green
        case .inProgress: return .blue
        case .pending: return .gray
        case .skipped: return .orange
        }
    }
    
    private func statusText(for status: StepStatus) -> String {
        switch status {
        case .completed: return "Completed"
        case .inProgress: return "In Progress"
        case .pending: return "Pending"
        case .skipped: return "Skipped"
        }
    }
    
    private func handleSuggestedStepTap(_ suggestedStep: SuggestedStep) {
        switch suggestedStep.stepType {
        case .doctorConsultation:
            showOPDSelection = true
        case .laboratory:
            showLabSelection = true
        case .pharmacy, .checkout:
            addStepToJourney(suggestedStep)
        case .opdCheckIn:
            break
        }
    }
    
    private func addStepToJourney(_ suggestedStep: SuggestedStep) {
        let newSequence = (journey.steps.map { $0.sequence }.max() ?? 0) + 1
        let bookingID = suggestedStep.bookingID ?? "TEMP-\(UUID().uuidString.prefix(8))"
        
        let newStep = JourneyStep(
            id: UUID().uuidString,
            type: suggestedStep.stepType,
            bookingID: bookingID,
            sequence: newSequence,
            status: .pending
        )
        
        journey.steps.append(newStep)
    }
    
    private func addBookingToJourney(_ booking: Appointment, stepType: JourneyStep.StepType) {
        let newSequence = (journey.steps.map { $0.sequence }.max() ?? 0) + 1
        
        let newStep = JourneyStep(
            id: UUID().uuidString,
            type: stepType,
            bookingID: booking.id,
            sequence: newSequence,
            status: .pending
        )
        
        journey.steps.append(newStep)
    }
    
    private func getBooking(for step: JourneyStep) -> Appointment? {
        MockData.sampleBookings.first { $0.id == step.bookingID }
    }
    
    private func completeStep(_ step: JourneyStep) {
        if let index = journey.steps.firstIndex(where: { $0.id == step.id }) {
            journey.steps[index].status = .completed
            
            if let bookingIndex = MockData.sampleBookings.firstIndex(where: { $0.id == step.bookingID }) {
                MockData.sampleBookings[bookingIndex].status = .completed
            }
            
            let remainingPendingSteps = displaySteps.filter { $0.status == .pending || $0.status == .inProgress }
            if let nextStep = remainingPendingSteps.first {
                if let nextIndex = journey.steps.firstIndex(where: { $0.id == nextStep.id }) {
                    
                    if let nextBooking = MockData.sampleBookings.first(where: { $0.id == nextStep.bookingID }) {
                        if nextBooking.status == .inProgress {
                            journey.steps[nextIndex].status = .inProgress
                        }
                    } else {
                        journey.steps[nextIndex].status = .inProgress
                    }
                }
            }
        }
    }
    
    private func skipStep(_ step: JourneyStep) {
        if let index = journey.steps.firstIndex(where: { $0.id == step.id }) {
            journey.steps[index].status = .skipped
            
            let remainingPendingSteps = displaySteps.filter { $0.status == .pending || $0.status == .inProgress }
            if let nextStep = remainingPendingSteps.first {
                if let nextIndex = journey.steps.firstIndex(where: { $0.id == nextStep.id }) {
                    journey.steps[nextIndex].status = .inProgress
                }
            }
        }
    }
    
    private func completeStepInList(_ step: JourneyStep) {
        if let index = journey.steps.firstIndex(where: { $0.id == step.id }) {
            journey.steps[index].status = .completed
            
            if let bookingIndex = MockData.sampleBookings.firstIndex(where: { $0.id == step.bookingID }) {
                MockData.sampleBookings[bookingIndex].status = .completed
            }
            
            let nextPendingStep = journey.steps
                .filter { $0.type != .opdCheckIn }
                .sorted { $0.sequence < $1.sequence }
                .first { $0.computedStatus == .pending }
            
            if let nextStep = nextPendingStep,
               let nextIndex = journey.steps.firstIndex(where: { $0.id == nextStep.id }) {
                
                if let nextBooking = MockData.sampleBookings.first(where: { $0.id == nextStep.bookingID }) {
                    if nextBooking.status == .inProgress {
                        journey.steps[nextIndex].status = .inProgress
                    }
                } else {
                    journey.steps[nextIndex].status = .inProgress
                }
            }
        }
    }
    
    private func canMoveUp(_ step: JourneyStep) -> Bool {
        guard let currentIndex = displaySteps.firstIndex(where: { $0.id == step.id }) else { return false }
        
        if currentIndex == 0 { return false }
        
        let previousStep = displaySteps[currentIndex - 1]
        
        if previousStep.computedStatus == .completed {
            return false
        }
        
        if previousStep.computedStatus == .inProgress {
            return false
        }
        
        return true
    }
    
    private func canMoveDown(_ step: JourneyStep) -> Bool {
        guard let currentIndex = displaySteps.firstIndex(where: { $0.id == step.id }) else { return false }
        
        if currentIndex >= displaySteps.count - 1 { return false }
        
        return true
    }
    
    private func removeStep(_ step: JourneyStep) {
        let wasInProgress = step.computedStatus == .inProgress
        journey.steps.removeAll { $0.id == step.id }
        
        if wasInProgress {
            let remainingPendingSteps = displaySteps.filter { $0.computedStatus == .pending }
            if let nextStep = remainingPendingSteps.first {
                if let nextIndex = journey.steps.firstIndex(where: { $0.id == nextStep.id }) {
                    journey.steps[nextIndex].status = .inProgress
                }
            }
        }
    }
    
    private func moveStep(_ step: JourneyStep, direction: MoveDirection) {
        guard let currentIndex = journey.steps.firstIndex(where: { $0.id == step.id }) else { return }
        
        let targetIndex: Int
        switch direction {
        case .up:
            targetIndex = currentIndex - 1
        case .down:
            targetIndex = currentIndex + 1
        }
        
        guard targetIndex >= 0 && targetIndex < journey.steps.count else { return }
        
        journey.steps.swapAt(currentIndex, targetIndex)
        
        for (index, _) in journey.steps.enumerated() {
            journey.steps[index].sequence = index + 1
        }
    }
    
    enum MoveDirection {
        case up, down
    }
}

struct BookingSelectionSheet: View {
    let title: String
    let bookings: [Appointment]
    let onSelect: (Appointment) -> Void
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List(bookings) { booking in
                Button(action: {
                    onSelect(booking)
                }) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(booking.type == .opd ? "OPD Appointment" : "Lab Test")
                                .font(.headline)
                            Spacer()
                            Text(booking.status.rawValue)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(statusColor(for: booking.status).opacity(0.1))
                                .foregroundColor(statusColor(for: booking.status))
                                .cornerRadius(6)
                        }
                        
                        if let reason = booking.reasonForVisit {
                            Text(reason)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        if let tests = booking.labTests, !tests.isEmpty {
                            Text(tests.map { $0.name }.joined(separator: ", "))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(2)
                        }
                        
                        HStack {
                            Image(systemName: "calendar")
                                .font(.caption)
                                .foregroundColor(.blue)
                            Text(booking.date, style: .date)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            if let session = MockData.sessions.first(where: { $0.id == booking.sessionId }) {
                                Image(systemName: "clock")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                                Text(session.displayTime)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func statusColor(for status: AppointmentStatus) -> Color {
        switch status {
        case .pending: return .orange
        case .confirmed: return .blue
        case .inProgress: return .purple
        case .completed: return .green
        case .cancelled: return .red
        }
    }
}

struct SuggestedStep: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let stepType: JourneyStep.StepType
    let bookingID: String?
}

#Preview {
    JourneyView(journeyId: "J001")
}
