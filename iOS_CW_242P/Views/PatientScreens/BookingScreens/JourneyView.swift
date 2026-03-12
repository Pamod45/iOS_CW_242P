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
    
    init(journeyId: String) {
        self.journeyId = journeyId
        if let foundJourney = MockData.sampleJourneys.first(where: { $0.id == journeyId }) {
            var journey = foundJourney
            let displaySteps = journey.steps.filter { $0.type != .opdCheckIn }
            let allCompleted = !displaySteps.isEmpty && displaySteps.allSatisfy {
                $0.computedStatus == .completed || $0.computedStatus == .skipped
            }
            if allCompleted && journey.status != .completed {
                journey.status = .completed
                if let journeyIndex = MockData.sampleJourneys.firstIndex(where: { $0.id == journeyId }) {
                    MockData.sampleJourneys[journeyIndex].status = .completed
                }
            }
            if journey.steps.filter { $0.type == .checkout }.isEmpty {
                let maxSequence = journey.steps.map { $0.sequence }.max() ?? 0
                journey.steps.append(JourneyStep(
                    id: UUID().uuidString,
                    type: .checkout,
                    bookingID: "",
                    sequence: maxSequence + 1,
                    status: .pending
                ))
            }
            self._journey = State(initialValue: journey)
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
        journey.steps.sorted { $0.sequence < $1.sequence }
    }

    private var isJourneyEditable: Bool {
        journey.status != .completed && Calendar.current.isDateInToday(journey.date)
    }
    
    private var formattedJourneyDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: journey.date)
    }
    
    private var suggestedSteps: [SuggestedStep] {
        var steps: [SuggestedStep] = []
        
        let hasOPDAppointment = journey.steps.contains { $0.type == .doctorConsultation }
        let hasFollowUp = journey.steps.contains { $0.type == .followUpVisit }
        let hasPharmacy = journey.steps.contains { $0.type == .pharmacy }
        let hasCheckout = journey.steps.contains { $0.type == .checkout }
        
        if !hasPharmacy {
            steps.append(SuggestedStep(
                icon: "pills.fill",
                title: "Pharmacy",
                stepType: .pharmacy,
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
                    
                    Text(formattedJourneyDate)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .padding(.top, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
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
                                VStack (alignment: .leading, spacing: 0){
                                    Text("Current Step").font(.footnote).foregroundColor(.secondary)
                                    Text(stepTitle(for: current.type)).font(.title3).fontWeight(.bold)
                                    if let location = stepLocation(for: current.type) {
                                        Text(location).font(.footnote).foregroundColor(.secondary)
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
                                            if let queueNumber = booking.queueNumber {
                                                VStack(alignment: .center, spacing: 4){
                                                    Text("Live queue position ").font(.footnote).foregroundColor(.secondary)
                                                    Text("\(queueNumber - 2 <= 0 ? 1 : queueNumber - 2 )/18 ").foregroundColor(.blue).fontWeight(.bold)
                                                }
                                            }
                                            if let waitTime = booking.estimatedWaitTime {
                                                VStack(alignment: .center, spacing: 4){
                                                    Text("Wait Time").font(.footnote).foregroundColor(.secondary)
                                                    Text("~ \(waitTime) min").foregroundColor(.orange).fontWeight(.bold)
                                                }
                                            }
                                            
                                        }
                                    }
                                }
                            }
                        }.padding()
                    }.background(.gray.opacity(0.08)).cornerRadius(16)
                }

                VStack(){
                    ForEach(displaySteps) { step in
                        stepRow(for: step)
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
                Text(stepTitle(for: step.type))
                    .font(.headline)
                    .foregroundColor(.secondary)

                Text(stepDescription(for: step))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
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
                
                if step.type == .doctorConsultation || step.type == .laboratory {
                    if let booking = getBooking(for: step), let session = MockData.sessions.first(where: { $0.id == booking.sessionId }) {
                        let arrivalTime = calculateArrivalTime(session: session, estimatedWait: booking.estimatedWaitTime)
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .font(.caption2)
                            Text(arrivalTime)
                                .font(.caption)
                        }
                        .foregroundColor(.gray)
                        .padding(.top, 4)
                    }
                }

                if displayStatus != .completed {
                    if let location = stepLocation(for: step.type), !location.isEmpty {
                        HStack(spacing: 6){
                            Image(systemName: "location").font(.caption).foregroundColor(.blue)
                            Text(location).font(.footnote).foregroundColor(.blue)
                        }
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

                if displayStatus == .pending && step.type != .doctorConsultation && step.type != .checkout {
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
                    
                    if step.type == .pharmacy && isJourneyEditable {
                        Button(action: {
                            removeStep(step)
                        }) {
                            HStack(spacing: 4) {
                                Text("Remove")
                                    .font(.footnote)
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(.red)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                        }
                        .padding(.top, 4)
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
        case .checkout: return "checkmark.circle"
        case .followUpVisit: return "arrow.uturn.left"
        }
    }

    private func stepTitle(for type: JourneyStep.StepType) -> String {
        switch type {
        case .opdCheckIn: return "Registration"
        case .doctorConsultation: return "Doctor Consultation"
        case .laboratory: return "Laboratory"
        case .pharmacy: return "Pharmacy"
        case .checkout: return "Exit Gate"
        case .followUpVisit: return "Follow-up Visit"
        }
    }

    private func stepDescription(for step: JourneyStep) -> String {
        if let booking = getBooking(for: step) {
            switch step.type {
            case .opdCheckIn:
                return "Complete your registration"
            case .doctorConsultation:
                if let doctorName = booking.doctorName, let reason = booking.reasonForVisit {
                    return "\(doctorName) - \(reason)"
                } else if let doctorName = booking.doctorName {
                    return doctorName
                } else if let reason = booking.reasonForVisit {
                    return reason
                }
                return "Meet with your doctor"
            case .laboratory:
                return "Complete lab tests"
            case .pharmacy:
                return "Collect your medicine"
            case .checkout:
                return "Leave the hospital after completing your visit"
            case .followUpVisit:
                if let opdStep = journey.steps.first(where: { $0.type == .doctorConsultation }),
                   let opdBooking = getBooking(for: opdStep),
                   let doctorName = opdBooking.doctorName {
                    return "Return to \(doctorName)"
                }
                return "Return to doctor"
            }
        }
        
        if step.type == .followUpVisit {
            if let opdStep = journey.steps.first(where: { $0.type == .doctorConsultation }),
               let opdBooking = getBooking(for: opdStep),
               let doctorName = opdBooking.doctorName {
                return "Return to \(doctorName)"
            }
            return "Return to doctor"
        }
        
        switch step.type {
        case .opdCheckIn: return "Complete your registration"
        case .doctorConsultation: return "Meet with your doctor"
        case .laboratory: return "Complete lab tests"
        case .pharmacy: return "Collect your medicine"
        case .checkout: return "Complete your visit"
        case .followUpVisit: return "Return to doctor"
        }
    }

    private func stepLocation(for type: JourneyStep.StepType) -> String? {
        switch type {
        case .opdCheckIn: return "Reception"
        case .doctorConsultation: return nil
        case .laboratory: return "Lab Room"
        case .pharmacy: return "Pharmacy Counter"
        case .checkout: return "Exit Gate"
        case .followUpVisit:
            if let opdStep = journey.steps.first(where: { $0.type == .doctorConsultation }),
               let opdBooking = getBooking(for: opdStep),
               let room = opdBooking.doctorRoom {
                return room
            }
            return nil
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
        addStepToJourney(suggestedStep)
    }

    private func addStepToJourney(_ suggestedStep: SuggestedStep) {
        let checkoutIndex = journey.steps.firstIndex { $0.type == .checkout }
        let checkoutSequence = checkoutIndex.map { journey.steps[$0].sequence } ?? ((journey.steps.map { $0.sequence }.max() ?? 0) + 1)
        
        let newSequence = checkoutSequence
        let bookingID = suggestedStep.bookingID ?? "TEMP-\(UUID().uuidString.prefix(8))"

        let currentInProgressStep = journey.steps.first { $0.computedStatus == .inProgress }
        
        let isCheckoutInProgress = currentInProgressStep?.type == .checkout
        
        let initialStatus: StepStatus = isCheckoutInProgress ? .inProgress : .pending

        let newStep = JourneyStep(
            id: UUID().uuidString,
            type: suggestedStep.stepType,
            bookingID: bookingID,
            sequence: newSequence,
            status: initialStatus
        )

        if let checkoutIdx = checkoutIndex {
            journey.steps[checkoutIdx].sequence = newSequence + 1
            if isCheckoutInProgress {
                journey.steps[checkoutIdx].status = .pending
            }
        }

        journey.steps.append(newStep)
        
        if let journeyIndex = MockData.sampleJourneys.firstIndex(where: { $0.id == journeyId }) {
            MockData.sampleJourneys[journeyIndex].steps = journey.steps
        }
    }

    private func getBooking(for step: JourneyStep) -> Appointment? {
        MockData.sampleBookings.first { $0.id == step.bookingID }
    }
    
    private func calculateArrivalTime(session: Session, estimatedWait: Int?) -> String {
        let components = session.startTime.split(separator: ":")
        guard components.count == 2,
              let hours = Int(components[0]),
              let minutes = Int(components[1]) else {
            return session.startTime
        }
        
        let totalMinutes = hours * 60 + minutes + (estimatedWait ?? 0)
        let arrivalHours = totalMinutes / 60
        let arrivalMinutes = totalMinutes % 60
        
        return String(format: "%02d:%02d", arrivalHours, arrivalMinutes)
    }

    private func completeStep(_ step: JourneyStep) {
        if let index = journey.steps.firstIndex(where: { $0.id == step.id }) {
            journey.steps[index].status = .completed

            if let bookingIndex = MockData.sampleBookings.firstIndex(where: { $0.id == step.bookingID }) {
                MockData.sampleBookings[bookingIndex].status = .completed
            }
            
            if let journeyIndex = MockData.sampleJourneys.firstIndex(where: { $0.id == journeyId }) {
                MockData.sampleJourneys[journeyIndex].steps = journey.steps
            }

            let sortedSteps = displaySteps
                .sorted { $0.sequence < $1.sequence }
                .filter { $0.computedStatus == .pending }
            
            if let nextStep = sortedSteps.first {
                if let nextIndex = journey.steps.firstIndex(where: { $0.id == nextStep.id }) {
                    if nextStep.type == .pharmacy || nextStep.type == .checkout || nextStep.type == .followUpVisit {
                        journey.steps[nextIndex].status = .inProgress
                    } else if let nextBooking = MockData.sampleBookings.first(where: { $0.id == nextStep.bookingID }) {
                        if nextBooking.status == .inProgress {
                            journey.steps[nextIndex].status = .inProgress
                        }
                    }
                    
                    if let journeyIndex = MockData.sampleJourneys.firstIndex(where: { $0.id == journeyId }) {
                        MockData.sampleJourneys[journeyIndex].steps = journey.steps
                    }
                }
            } else {
                let displaySteps = journey.steps.filter { $0.type != .opdCheckIn }
                let allCompleted = !displaySteps.isEmpty && displaySteps.allSatisfy {
                    $0.computedStatus == .completed || $0.computedStatus == .skipped
                }
                if allCompleted {
                    journey.status = .completed
                    if let journeyIndex = MockData.sampleJourneys.firstIndex(where: { $0.id == journeyId }) {
                        MockData.sampleJourneys[journeyIndex].status = .completed
                    }
                }
            }
        }
    }

    private func skipStep(_ step: JourneyStep) {
        if let index = journey.steps.firstIndex(where: { $0.id == step.id }) {
            journey.steps[index].status = .skipped
            
            if let journeyIndex = MockData.sampleJourneys.firstIndex(where: { $0.id == journeyId }) {
                MockData.sampleJourneys[journeyIndex].steps = journey.steps
            }

            let sortedSteps = displaySteps
                .sorted { $0.sequence < $1.sequence }
                .filter { $0.computedStatus == .pending }
            
            if let nextStep = sortedSteps.first {
                if let nextIndex = journey.steps.firstIndex(where: { $0.id == nextStep.id }) {
                    if nextStep.type == .pharmacy || nextStep.type == .checkout || nextStep.type == .followUpVisit {
                        journey.steps[nextIndex].status = .inProgress
                    } else if let nextBooking = MockData.sampleBookings.first(where: { $0.id == nextStep.bookingID }) {
                        if nextBooking.status == .inProgress {
                            journey.steps[nextIndex].status = .inProgress
                        }
                    }
                    
                    if let journeyIndex = MockData.sampleJourneys.firstIndex(where: { $0.id == journeyId }) {
                        MockData.sampleJourneys[journeyIndex].steps = journey.steps
                    }
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
            
            if let journeyIndex = MockData.sampleJourneys.firstIndex(where: { $0.id == journeyId }) {
                MockData.sampleJourneys[journeyIndex].steps = journey.steps
            }

            let sortedSteps = journey.steps
                .filter { $0.type != .opdCheckIn }
                .sorted { $0.sequence < $1.sequence }

            let nextPendingStep = sortedSteps.first { $0.computedStatus == .pending }

            if let nextStep = nextPendingStep,
               let nextIndex = journey.steps.firstIndex(where: { $0.id == nextStep.id }) {
                if nextStep.type == .pharmacy || nextStep.type == .checkout || nextStep.type == .followUpVisit {
                    journey.steps[nextIndex].status = .inProgress
                } else if let nextBooking = MockData.sampleBookings.first(where: { $0.id == nextStep.bookingID }) {
                    if nextBooking.status == .inProgress {
                        journey.steps[nextIndex].status = .inProgress
                    }
                }
                
                if let journeyIndex = MockData.sampleJourneys.firstIndex(where: { $0.id == journeyId }) {
                    MockData.sampleJourneys[journeyIndex].steps = journey.steps
                }
            } else {
                let displaySteps = journey.steps.filter { $0.type != .opdCheckIn }
                let allCompleted = !displaySteps.isEmpty && displaySteps.allSatisfy {
                    $0.computedStatus == .completed || $0.computedStatus == .skipped
                }
                if allCompleted {
                    journey.status = .completed
                    if let journeyIndex = MockData.sampleJourneys.firstIndex(where: { $0.id == journeyId }) {
                        MockData.sampleJourneys[journeyIndex].status = .completed
                    }
                }
            }
        }
    }

    private func canMoveUp(_ step: JourneyStep) -> Bool {
        guard let currentIndex = displaySteps.firstIndex(where: { $0.id == step.id }) else { return false }

        if currentIndex == 0 { return false }

        let previousStep = displaySteps[currentIndex - 1]

        if previousStep.computedStatus == .completed || previousStep.computedStatus == .inProgress {
            return false
        }

        if step.type == .pharmacy || step.type == .followUpVisit {
            if previousStep.type == .pharmacy || previousStep.type == .followUpVisit || previousStep.type == .laboratory {
                return true
            }
            return false
        }

        if step.type == .laboratory {
            if previousStep.type == .pharmacy || previousStep.type == .followUpVisit {
                return true
            }
            return false
        }

        return false
    }

    private func canMoveDown(_ step: JourneyStep) -> Bool {
        guard let currentIndex = displaySteps.firstIndex(where: { $0.id == step.id }) else { return false }

        if currentIndex >= displaySteps.count - 1 { return false }

        let nextStep = displaySteps[currentIndex + 1]

        if step.type == .pharmacy || step.type == .followUpVisit {
            if nextStep.type == .pharmacy || nextStep.type == .laboratory || nextStep.type == .followUpVisit {
                return true
            }
            return false
        }

        if step.type == .laboratory {
            if nextStep.type == .pharmacy || nextStep.type == .followUpVisit {
                return true
            }
            return false
        }

        return false
    }

    private func removeStep(_ step: JourneyStep) {
        let wasInProgress = step.computedStatus == .inProgress
        journey.steps.removeAll { $0.id == step.id }
        
        if let journeyIndex = MockData.sampleJourneys.firstIndex(where: { $0.id == journeyId }) {
            MockData.sampleJourneys[journeyIndex].steps = journey.steps
        }

        if wasInProgress {
            let sortedSteps = displaySteps
                .sorted { $0.sequence < $1.sequence }
                .filter { $0.computedStatus == .pending }
            
            if let nextStep = sortedSteps.first {
                if let nextIndex = journey.steps.firstIndex(where: { $0.id == nextStep.id }) {
                    journey.steps[nextIndex].status = .inProgress
                    
                    if let journeyIndex = MockData.sampleJourneys.firstIndex(where: { $0.id == journeyId }) {
                        MockData.sampleJourneys[journeyIndex].steps = journey.steps
                    }
                }
            }
        }
    }

    private func moveStep(_ step: JourneyStep, direction: MoveDirection) {
        guard step.type == .pharmacy || step.type == .laboratory || step.type == .followUpVisit else { return }
        
        let currentDisplaySteps = displaySteps
        guard let currentDisplayIndex = currentDisplaySteps.firstIndex(where: { $0.id == step.id }) else { return }
        
        let targetDisplayIndex: Int
        switch direction {
        case .up:
            targetDisplayIndex = currentDisplayIndex - 1
        case .down:
            targetDisplayIndex = currentDisplayIndex + 1
        }
        
        guard targetDisplayIndex >= 0 && targetDisplayIndex < currentDisplaySteps.count else { return }
        
        let targetStep = currentDisplaySteps[targetDisplayIndex]
        let currentStep = currentDisplaySteps[currentDisplayIndex]
        
        guard let currentIndex = journey.steps.firstIndex(where: { $0.id == currentStep.id }),
              let targetIndex = journey.steps.firstIndex(where: { $0.id == targetStep.id }) else { return }
        
        let tempSequence = journey.steps[currentIndex].sequence
        journey.steps[currentIndex].sequence = journey.steps[targetIndex].sequence
        journey.steps[targetIndex].sequence = tempSequence
        
        if let journeyIndex = MockData.sampleJourneys.firstIndex(where: { $0.id == journeyId }) {
            MockData.sampleJourneys[journeyIndex].steps = journey.steps
        }
    }

    enum MoveDirection {
        case up, down
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
