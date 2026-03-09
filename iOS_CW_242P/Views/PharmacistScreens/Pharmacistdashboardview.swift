import SwiftUI

// MARK: - Pharmacist Dashboard View

struct PharmacistDashboardView: View {

    @EnvironmentObject var authViewModel: AuthViewModel

    // Seeded from MockData.sampleQueueItems — models & data now live in sessions.swift
    @State private var queueItems: [QueueItem] = MockData.sampleQueueItems

    private var pendingCount:   Int { queueItems.filter { $0.status == .pending   }.count }
    private var preparingCount: Int { queueItems.filter { $0.status == .preparing }.count }
    private var readyCount:     Int { queueItems.filter { $0.status == .ready     }.count }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {

                // MARK: Subtitle
                HStack {
                    Text(authViewModel.currentUser?.name ?? "Pharmacist")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 4)

                // MARK: Summary Cards
                HStack(spacing: 12) {
                    SummaryCard(count: pendingCount,   label: "Pending",   icon: "clock.fill",           color: Color(hex: "#F97316"))
                    SummaryCard(count: preparingCount, label: "Preparing", icon: "hourglass",             color: Color(hex: "#3B82F6"))
                    SummaryCard(count: readyCount,     label: "Ready",     icon: "checkmark.circle.fill", color: Color(hex: "#22C55E"))
                }
                .padding(.horizontal, 16)

                // MARK: Queue Cards
                ForEach($queueItems) { $item in
                    QueueCard(item: $item)
                        .padding(.horizontal, 16)
                }

                Spacer(minLength: 40)
            }
            .padding(.top, 8)
        }
        .background(Color(hex: "#F3F4F6").ignoresSafeArea())
        .navigationTitle("Pharmacy Dashboard")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Summary Card

struct SummaryCard: View {
    let count: Int
    let label: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
            Text("\(count)")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(color)
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.white)
        .cornerRadius(12)
    }
}

// MARK: - Queue Card

struct QueueCard: View {
    @Binding var item: QueueItem

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            // Header
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Queue #\(item.queueNumber)")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    Text(item.patientName)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.black)
                }
                Spacer()
                StatusBadge(status: item.status)
            }

            Divider()

            // Medicines
            HStack(spacing: 6) {
                Image(systemName: "pills.fill")
                    .foregroundColor(Color(hex: "#22C55E"))
                    .font(.system(size: 14))
                Text("Medicines (\(item.medicines.count))")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.black)
            }
            ForEach(item.medicines) { med in
                HStack(spacing: 6) {
                    Circle().fill(Color(hex: "#3B82F6")).frame(width: 6, height: 6)
                    Text(med.name).font(.system(size: 13)).foregroundColor(.black)
                    Text("• \(med.dose)").font(.system(size: 13)).foregroundColor(.gray)
                }
                .padding(.leading, 4)
            }

            // Doctor + time
            HStack {
                Image(systemName: "stethoscope").font(.system(size: 13)).foregroundColor(.gray)
                Text(item.doctorName).font(.system(size: 13)).foregroundColor(.gray)
                Spacer()
                Text(item.timeAgo).font(.system(size: 12)).foregroundColor(.gray)
            }

            // Action button
            if item.status == .pending {
                QueueActionButton(title: "Start Preparing", icon: "play.fill", color: Color(hex: "#3B82F6")) {
                    withAnimation { item.status = .preparing }
                }
            } else if item.status == .preparing {
                QueueActionButton(title: "Mark Ready", icon: "checkmark.circle.fill", color: Color(hex: "#22C55E")) {
                    withAnimation { item.status = .ready }
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Status Badge

struct StatusBadge: View {
    let status: QueueStatus
    var body: some View {
        Text(status.rawValue)
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(.white)
            .padding(.horizontal, 10).padding(.vertical, 4)
            .background(status.color)
            .cornerRadius(20)
    }
}

// MARK: - Queue Action Button

struct QueueActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon).font(.system(size: 14, weight: .semibold))
                Text(title).font(.system(size: 15, weight: .semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(color)
            .cornerRadius(12)
        }
    }
}

#Preview {
    NavigationView {
        PharmacistDashboardView()
    }.environmentObject(AuthViewModel())
}
