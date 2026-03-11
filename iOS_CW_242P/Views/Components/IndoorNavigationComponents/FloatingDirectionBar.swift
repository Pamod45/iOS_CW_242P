import SwiftUI
import AVFoundation

struct FloatingDirectionBar: View {
    let currentStep: Int
    let directions: [String]
    let estimatedTime: String
    let distance: String
    let onTap: () -> Void
    
    var currentInstruction: String? {
        guard currentStep < directions.count else { return nil }
        return directions[currentStep]
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                HStack {
                    HStack(spacing: 6) {
                        Image(systemName: "clock.fill")
                            .font(.caption)
                        Text(estimatedTime)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.blue)
                    
                    Spacer()
                    
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.left.and.right")
                            .font(.caption2)
                        Text(distance)
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.secondary)
                    
                    Image(systemName: "chevron.up")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                if let instruction = currentInstruction {
                    HStack(spacing: 12) {
                        Image(systemName: icon(for: instruction))
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(.blue)
                            .cornerRadius(12)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(instruction)
                                .font(.headline)
                                .foregroundColor(.primary)
                                .lineLimit(2)
                            
                            if currentStep + 1 < directions.count {
                                Text("Next: \(directions[currentStep + 1])")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                            } else {
                                Text("Arriving soon")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Spacer()
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.2), radius: 15, x: 0, y: 5)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func icon(for text: String) -> String {
        let lowerText = text.lowercased()
        if lowerText.contains("left") { return "arrow.turn.up.left" }
        if lowerText.contains("right") { return "arrow.turn.up.right" }
        if lowerText.contains("arrive") || lowerText.contains("check in") { return "mappin.circle.fill" }
        if lowerText.contains("exit") || lowerText.contains("outside") { return "door.left.hand.open" }
        if lowerText.contains("elevator") { return "arrow.up.arrow.down" }
        if lowerText.contains("stairs") { return "figure.stairs" }
        return "arrow.up"
    }
}


struct ExpandedDirectionsSheet: View {
    let directions: [String]
    let sourceName: String
    let destinationName: String
    let estimatedTime: String
    let distance: String
    let onClose: () -> Void
    
    @State private var isSpeaking = false
    @State private var synthesizer = AVSpeechSynthesizer()
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Directions")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Image(systemName: "clock.fill").font(.caption2)
                        Text(estimatedTime).font(.caption).fontWeight(.semibold)
                    }
                    .foregroundColor(.blue)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.left.and.right").font(.caption2)
                        Text(distance).font(.caption).fontWeight(.medium)
                    }
                    .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: toggleSpeech) {
                    Image(systemName: isSpeaking ? "speaker.wave.2.fill" : "speaker.slash.fill")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(isSpeaking ? .blue : .gray)
                        .frame(width: 32, height: 32)
                }
                
                Button(action: {
                    stopSpeech()
                    onClose()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.gray)
                        .frame(width: 32, height: 32)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 12)
            
            Divider()
                .padding(.horizontal, 16)
            
            ScrollView {
                LazyVStack(spacing: 4) {
                    ForEach(Array(directions.enumerated()), id: \.offset) { index, instruction in
                        DirectionStepRow(
                            stepNumber: index + 1,
                            instruction: instruction,
                            icon: getIcon(for: instruction),
                            isLast: index == 0
                        )
                    }
                }
                .padding(16)
            }
        }
        .frame(maxHeight: 460)
        .background(Color(red: 0.96, green: 0.96, blue: 0.97))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 2)
        .onDisappear { stopSpeech() }
    }
    
    private func toggleSpeech() {
        if isSpeaking {
            stopSpeech()
        } else {
            speakDirections()
        }
    }
    
    private func speakDirections() {
        let text = directions.enumerated().map { index, instruction in
            "Step \(index + 1). \(instruction)"
        }.joined(separator: ". ")
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate * 0.9
        utterance.pitchMultiplier = 1.05
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        
        synthesizer.speak(utterance)
        isSpeaking = true
    }
    
    private func stopSpeech() {
        synthesizer.stopSpeaking(at: .immediate)
        isSpeaking = false
    }
    
    private func getIcon(for text: String) -> String {
        let lowerText = text.lowercased()
        if lowerText.contains("left") { return "arrow.turn.up.left" }
        if lowerText.contains("right") { return "arrow.turn.up.right" }
        if lowerText.contains("arrive") || lowerText.contains("check in") { return "mappin.circle.fill" }
        if lowerText.contains("exit") || lowerText.contains("outside") { return "door.left.hand.open" }
        if lowerText.contains("elevator") { return "arrow.up.arrow.down" }
        if lowerText.contains("stairs") { return "figure.stairs" }
        return "arrow.up"
    }
}


struct DirectionStepRow: View {
    let stepNumber: Int
    let instruction: String
    let icon: String
    let isLast: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(isLast ? Color.blue : Color.gray.opacity(0.12))
                    .frame(width: 36, height: 36)
                
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(isLast ? .white : .blue)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(instruction)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
    }
}

//#Preview("Floating Bar") {
//    ZStack(alignment: .bottom) {
//        Color.gray.opacity(0.2).ignoresSafeArea()
//        
//        FloatingDirectionBar(
//            currentStep: 2,
//            directions: MockData.sampleRoutes[0].directions,
//            estimatedTime: "2 min",
//            distance: "120m",
//            onTap: {}
//        )
//        .padding()
//    }
//}

#Preview("Expanded Sheet") {
    ExpandedDirectionsSheet(
        directions: MockData.sampleRoutes[0].directions,
        sourceName: MockData.sampleRoutes[0].sourceName,
        destinationName: MockData.sampleRoutes[0].destinationName,
        estimatedTime: "2 min",
        distance: "120m",
        onClose: {}
    )
    .padding()
}
