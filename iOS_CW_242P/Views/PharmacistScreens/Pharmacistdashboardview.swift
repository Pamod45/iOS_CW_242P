import SwiftUI

struct PharmacistDashboardView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var queueItems: [QueueItem] = MockData.sampleQueueItems
    
    private var pendingCount:   Int { queueItems.filter { $0.status == .pending   }.count }
    private var preparingCount: Int { queueItems.filter { $0.status == .preparing }.count }
    private var readyCount:     Int { queueItems.filter { $0.status == .ready     }.count }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    HStack {
                        Text(authViewModel.currentUser?.name ?? "Pharmacist")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 4)
                    
                    HStack(spacing: 12) {
                        SummaryCard(count: pendingCount,   label: "Pending",   icon: "clock.fill",           color: Color(hex: "#F97316"))
                        SummaryCard(count: preparingCount, label: "Preparing", icon: "hourglass",             color: Color(hex: "#3B82F6"))
                        SummaryCard(count: readyCount,     label: "Ready",     icon: "checkmark.circle.fill", color: Color(hex: "#22C55E"))
                    }
                    .padding(.horizontal, 16)
                    
                    ForEach($queueItems) { $item in
                        QueueCard(item: $item)
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
 
}



#Preview {
    NavigationStack {
        PharmacistDashboardView()
    }.environmentObject(AuthViewModel())
}
