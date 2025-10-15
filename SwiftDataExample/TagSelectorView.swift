import SwiftUI
import SwiftData

struct TagSelectorView: View {
    @Binding var selectedTags: [Tag]?
    var tags: [Tag]
    var onAddTag: () -> Void
    
    var body: some View {
        Section("Tags") {
            ForEach(tags) { tag in
                NavigationLink(value: tag) {
                    HStack {
                        Button {
                            if selectedTags?.contains(tag) == true {
                                if let index = selectedTags?.firstIndex(of: tag) {
                                    selectedTags?.remove(at: index)
                                }
                                if selectedTags?.isEmpty == true {
                                    selectedTags = nil
                                }
                            } else {
                                if selectedTags == nil {
                                    selectedTags = [tag]
                                } else {
                                    selectedTags?.append(tag)
                                }
                            }
                        } label: {
                            Image(systemName: selectedTags?.contains(tag) == true ? "checkmark.circle.fill" : "circle")
                        }
                        .buttonStyle(.plain)
                        .foregroundColor(selectedTags?.contains(tag) == true ? .accentColor : .secondary)
                        
                        Text(tag.name)
                    }
                }
            }
            
            Button("Adicionar uma nova tag", action: onAddTag)
        }
    }
}
