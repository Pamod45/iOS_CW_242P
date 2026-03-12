import SwiftUI

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
