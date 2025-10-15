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
    @Environment(\.dismiss) private var dismiss
    @State private var showDeleteAlert = false
    
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
            Section("Notas") {
                ZStack(alignment: .topLeading) {
                    if diaryEntry.details.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        Text("Detalhes sobre o que aconteceu")
                            .foregroundStyle(.secondary)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 5)
                    }
                    TextEditor(text: $diaryEntry.details)
                        .frame(minHeight: 180)
                        .textInputAutocapitalization(.sentences)
                        .autocorrectionDisabled(false)
                        .scrollContentBackground(.hidden)
                        .padding(.horizontal, -4)
                }
            }
            
            if let photos = diaryEntry.photos, !photos.isEmpty {
                ForEach(photos, id: \.self) { data in
                    if let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(Color.secondary.opacity(0.25), lineWidth: 1)
                            )
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
            
            EmotionSelectorView(selectedEmotions: $diaryEntry.emotions, emotions: emotions, onAddEmotion: addEmotion)
            
            TagSelectorView(selectedTags: $diaryEntry.tags, tags: tags, onAddTag: addTag)
        }
        .navigationTitle("Editar Entrada do Diário")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(role: .destructive) {
                    showDeleteAlert = true
                } label: {
                    Label("Excluir", systemImage: "trash")
                }
                .accessibilityIdentifier("deleteDiaryEntryButton")
            }
        }
        .alert("Excluir entrada?", isPresented: $showDeleteAlert) {
            Button("Cancelar", role: .cancel) { }
            Button("Excluir", role: .destructive) {
                modelContext.delete(diaryEntry)
                try? modelContext.save()
                dismiss()
            }
        } message: {
            Text("Esta ação não pode ser desfeita.")
        }
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

