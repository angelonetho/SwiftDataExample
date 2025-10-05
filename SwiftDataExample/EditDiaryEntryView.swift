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
    
    @State private var selectedItems: [PhotosPickerItem] = []
    
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
    
    func loadPhotos() {
        let items = selectedItems
        guard !items.isEmpty else { return }

        Task(priority: .userInitiated) {
            var newDatas: [Data] = []
            for item in items {
                if let data = try? await item.loadTransferable(type: Data.self) {
                    newDatas.append(data)
                }
            }
            await MainActor.run {
                if !newDatas.isEmpty {
                    diaryEntry.photos = (diaryEntry.photos ?? []) + newDatas
                }
                selectedItems.removeAll()
            }
        }
    }
    
    var body: some View {
        
        Form {
            if let photos = diaryEntry.photos, !photos.isEmpty {
                ForEach(photos, id: \.self) { data in
                    if let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                    }
                }
            }


            
            Section {
                PhotosPicker(selection: $selectedItems,
                             maxSelectionCount: 10,
                             matching: .images) {
                    Label("Selecionar fotos", systemImage: "photo.on.rectangle")
                }
            }
            
            Section("Tags") {
                ForEach(tags) { tag in
                    let isOn = Binding(
                        get: { diaryEntry.tags?.contains(where: { $0.id == tag.id }) ?? false },
                        set: { on in
                            if on {
                                diaryEntry.tags = (diaryEntry.tags ?? []) + [tag]
                            } else {
                                diaryEntry.tags?.removeAll { $0.id == tag.id }
                                if diaryEntry.tags?.isEmpty == true { diaryEntry.tags = nil }
                            }
                        }
                    )
                    Toggle(tag.name, isOn: isOn)
                }

                Button("Add a new tag", action: addTag)
            }
            
            Section("Emotions") {
                ForEach(emotions) { emotion in
                    let isOn = Binding(
                        get: { diaryEntry.emotions?.contains(where: { $0.id == emotion.id }) ?? false },
                        set: { on in
                            if on {
                                diaryEntry.emotions = (diaryEntry.emotions ?? []) + [emotion]
                            } else {
                                diaryEntry.emotions?.removeAll { $0.id == emotion.id }
                                if diaryEntry.emotions?.isEmpty == true { diaryEntry.emotions = nil }
                            }
                        }
                    )
                    Toggle(emotion.name, isOn: isOn)
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
        .onChange(of: selectedItems, loadPhotos)
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
