import SwiftUI

struct CustomTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var icon: String? = nil
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    var disableAutocapitalization: Bool = false
    var disableAutocorrection: Bool = false
    var backgroundColor = Color(.systemGray6)
    
    @State private var isSecureVisible: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundColor(.gray)
                        .frame(width: 20)
                }
                
                if isSecure && !isSecureVisible {
                    SecureField(placeholder, text: $text)
                        .textFieldStyle(PlainTextFieldStyle())
                        .keyboardType(keyboardType)
                        .textInputAutocapitalization(disableAutocapitalization ? .never : nil)
                        .autocorrectionDisabled(disableAutocorrection)
                } else {
                    TextField(placeholder, text: $text)
                        .textFieldStyle(PlainTextFieldStyle())
                        .keyboardType(keyboardType)
                        .textInputAutocapitalization(disableAutocapitalization ? .never : .words)
                        .autocorrectionDisabled(disableAutocorrection)
                }
                
                if isSecure {
                    Button(action: { isSecureVisible.toggle() }) {
                        Image(systemName: isSecureVisible ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .background(backgroundColor)
            .cornerRadius(10)
        }
    }
}

struct CustomTextEditor: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var height: CGFloat = 100
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            
            ZStack(alignment: .topLeading) {
                TextEditor(text: $text)
                    .frame(height: height)
                    .padding(4)
                    .scrollContentBackground(.hidden)
                    .opacity(text.isEmpty ? 0.5 : 1)
                
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(.gray.opacity(0.5))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 12)
                        .allowsHitTesting(false)
                }
            }
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        CustomTextField(title: "Email", placeholder: "Enter your email", text: .constant(""), icon: "envelope")
        CustomTextField(title: "Password", placeholder: "Enter password", text: .constant(""), icon: "lock", isSecure: true)
        CustomTextEditor(title: "Notes", placeholder: "Enter notes", text: .constant(""))
    }
    .padding()
}
