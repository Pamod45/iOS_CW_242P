import SwiftUI

struct PharmacistDashboardView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var allQueueItems: [QueueItem] = MockData.sampleQueueItems
    
    private var queueItems: [QueueItem] {
        if(selectedSession.id == "6") {
            return allQueueItems.filter { item in
                return (Calendar.current.isDate(item.date, inSameDayAs: selectedDate))
            }
        }
        return allQueueItems.filter { item in
            return (Calendar.current.isDate(item.date, inSameDayAs: selectedDate)) && (item.sessionId == selectedSession.id)
        }
    }

    private var visibleQueueIndices: [Int] {
        if(selectedSession.id == "6") {return allQueueItems.indices.filter { idx in
            let item = allQueueItems[idx]
            return (Calendar.current.isDate(item.date, inSameDayAs: selectedDate)) && (item.matchesFilter(selectedFilter))
        } }
        return allQueueItems.indices.filter { idx in
            let item = allQueueItems[idx]
            return (Calendar.current.isDate(item.date, inSameDayAs: selectedDate)) && (item.sessionId == selectedSession.id) && (item.matchesFilter(selectedFilter))
        }
    }
    
    private var pendingCount:   Int { queueItems.filter { $0.status == .pending   }.count }
    private var preparingCount: Int { queueItems.filter { $0.status == .preparing }.count }
    private var readyCount:     Int { queueItems.filter { $0.status == .ready     }.count }
    @State private var selectedFilter: QueueFilter = .all
    
    @State private var selectedDate: Date = Date()
    @State private var selectedSession: Session = MockData.sessions[0]
    private var last5Days: [Date] {
        (0..<5).map { Calendar.current.date(byAdding: .day, value: -$0, to: Date())! }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
//                    HStack {
//                        Text(Date(), style: .date)
//                            .font(.system(size: 14))
//                            .foregroundColor(.gray)
//                            .fontWeight(.medium)
//                        Spacer()
//                        Text("09:00 - 12:00")
//                            .font(.system(size: 14))
//                            .foregroundColor(.gray)
//                            .fontWeight(.medium)
//                    }
//                    .padding(.horizontal, 16)
//                    .padding(.top, 4)
                    
                    HStack {
                        DatePicker("Date", selection: $selectedDate, in: ...Date(), displayedComponents: .date)
                            .pickerStyle(.menu)
                            .labelsHidden()

                        Spacer()

                        Menu {
                            ForEach(MockData.sessions) { session in
                                Button {
                                    selectedSession = session
                                } label: {
                                    Text("\(session.startTime) - \(session.endTime)")
                                }
                            }
                            Button {
                                selectedSession = Session(id: "6", startTime: "00:00", endTime: "23:59", isAvailable: true, currentQueueNumber: 1, averageConsultationTimeInMinutes: 15, doctorName: "", roomNumber: "Room 101")
                            } label: {
                                Text("All")
                            }
                        } label: {
                            HStack(spacing: 4) {
                                Text("\(selectedSession.startTime) - \(selectedSession.endTime)")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.gray)
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 4)
                    
                    HStack(spacing: 12) {
                        SummaryCard(count: pendingCount,   label: "Pending",   icon: "clock.fill",           color: Color(hex: "#F97316"))
                        SummaryCard(count: preparingCount, label: "Preparing", icon: "hourglass",             color: Color(hex: "#3B82F6"))
                        SummaryCard(count: readyCount,     label: "Ready",     icon: "checkmark.circle.fill", color: Color(hex: "#22C55E"))
                    }
                    .padding(.horizontal, 16)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(QueueFilter.allCases, id: \.self) { filter in
                                FilterChip(
                                    title: filter.rawValue,
                                    isSelected: selectedFilter == filter,
                                    count: countForFilter(filter)
                                ) {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        selectedFilter = filter
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    ForEach(visibleQueueIndices, id: \.self) { index in
                        QueueCard(item: $allQueueItems[index])
                            .padding(.horizontal, 16)
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding(.top, 8)
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemGroupedBackground))
        }
    }
    
    private func countForFilter(_ filter: QueueFilter) -> Int {
        return queueItems.filter { $0.matchesFilter(filter) }.count
    }
    
    
 
}

#Preview {
    NavigationStack {
        PharmacistDashboardView()
    }.environmentObject(AuthViewModel())
}
