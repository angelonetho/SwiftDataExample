//
//  EditDiaryEntryView.swift
//  SwiftDataExample
//
//  Created by Angelo Andrioli Netho on 03/10/25.
//

import SwiftUI
import SwiftData
import PhotosUI

struct EditDiaryEntryView: View {
    
    @State private var selectedItem: PhotosPickerItem?
    
    @Query(sort: [
        SortDescriptor(\Tag.name),
    ]) var tags: [Tag]
    
    @Query(sort: [
        SortDescriptor(\Emotion.name),
    ]) var emotions: [Emotion]
    
    @Bindable var diaryEntry: DiaryEntry
    
    @Environment(\.modelContext) var modelContext
    
    @Binding var navigationPath: NavigationPath
    
    func addTag() {
        let tag = Tag(name: "")
        modelContext.insert(tag)
        navigationPath.append(tag)
    }
    
    func addEmotion() {
        let emotion = Emotion(name: "")
        modelContext.insert(emotion)
        navigationPath.append(emotion)
    }
    
    func loadPhoto() {
        Task { @MainActor in
            diaryEntry.photo = try await selectedItem?.loadTransferable(type: Data.self)
        }
    }
    
    var body: some View {
        
        Form {
            if let imageData = diaryEntry.photo, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            }
            
            Section {
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    Label("Select a photo", systemImage: "person")
                }
            }
            
            Section("What this is related to?") {
                Picker("Met at", selection: $diaryEntry.tag) {
                    Text("Unkown event")
                        .tag(Optional<Tag>.none)
                    
                    if tags.isEmpty == false {
                        Divider()
                        
                        ForEach(tags) { tag in
                            Text(tag.name)
                                .tag(Optional(tag))
                        }
                    }
                }
                
                Button("Add a new tag", action: addTag)
            }
            
            Section("What are you feeling?") {
                Picker("Emotion", selection: $diaryEntry.emotion) {
                    Text("Unkown emotion")
                        .tag(Optional<Emotion>.none)
                    
                    if emotions.isEmpty == false {
                        Divider()
                        
                        ForEach(emotions) { emotion in
                            Text(emotion.name)
                                .tag(Optional(emotion))
                        }
                    }
                }
                
                Button("Add a new emotion", action: addEmotion)
            }
            
            Section("Notes") {
                TextField("Details about this person", text: $diaryEntry.details, axis: .vertical)
            }
        }
        .navigationTitle("Edit Diary Entry")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: Tag.self) { tag in
                EditTagView(tag: tag)
        }
        .navigationDestination(for: Emotion.self) { emotion in
                EditEmotionView(emotion: emotion)
        }
        .onChange(of: selectedItem, loadPhoto)
    }
}

#Preview {
    do {
        let previewer = try Previewer()

        return EditDiaryEntryView(diaryEntry: previewer.diaryEntry, navigationPath: .constant(NavigationPath()))
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
