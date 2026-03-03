import SwiftUI

//Editable Info Row (edit)
struct EditableInfoRow: View {
    let icon: String
    let label: String
    @Binding var value: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .foregroundColor(Color(hex: "#3B82F6"))
                .frame(width: 22, height: 22)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
                TextField("Enter \(label.lowercased())", text: $value)
                    .font(.system(size: 15))
                    .foregroundColor(.black)
                    .keyboardType(keyboardType)
                    .autocapitalization(keyboardType == .emailAddress ? .none : .words)
                    .disableAutocorrection(keyboardType == .emailAddress)
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(hex: "#3B82F6").opacity(0.5), lineWidth: 1.5)
        )
    }
}
