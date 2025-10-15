import SwiftUI
import SwiftData

struct EmotionSelectorView: View {
    @Binding var selectedEmotions: [Emotion]?
    var emotions: [Emotion]
    var onAddEmotion: () -> Void
    
    var body: some View {
        Section("Emoções") {
            ForEach(emotions) { emotion in
                NavigationLink(value: emotion) {
                    HStack {
                        Button {
                            if selectedEmotions?.contains(emotion) == true {
                                if let index = selectedEmotions?.firstIndex(of: emotion) {
                                    selectedEmotions?.remove(at: index)
                                }
                                if selectedEmotions?.isEmpty == true {
                                    selectedEmotions = nil
                                }
                            } else {
                                if selectedEmotions == nil {
                                    selectedEmotions = [emotion]
                                } else {
                                    selectedEmotions?.append(emotion)
                                }
                            }
                        } label: {
                            Image(systemName: selectedEmotions?.contains(emotion) == true ? "checkmark.circle.fill" : "circle")
                        }
                        .buttonStyle(.plain)
                        .foregroundColor(selectedEmotions?.contains(emotion) == true ? .accentColor : .secondary)
                        
                        Text(emotion.name)
                    }
                }
            }
            
            Button("Adicionar uma nova emoção", action: onAddEmotion)
        }
    }
}
