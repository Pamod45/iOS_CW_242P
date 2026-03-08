
import SwiftUI

struct ProfileInfoRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 22, height: 22)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
                Text(value)
                    .font(.system(size: 15))
                    .foregroundColor(.black)
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.white)
        .cornerRadius(12)
    }
}
