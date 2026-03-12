import SwiftUI

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
