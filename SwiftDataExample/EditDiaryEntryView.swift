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
    ]) var events: [Tag]
    
    @Bindable var person: DiaryEntry
    
    @Environment(\.modelContext) var modelContext
    
    @Binding var navigationPath: NavigationPath
    
    func addEvent() {
        let event = Tag(name: "")
        modelContext.insert(event)
        navigationPath.append(event)
    }
    
    func loadPhoto() {
        Task { @MainActor in
            person.photo = try await selectedItem?.loadTransferable(type: Data.self)
        }
    }
    
    var body: some View {
        
        Form {
            if let imageData = person.photo, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            }
            
            Section {
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    Label("Select a photo", systemImage: "person")
                }
            }
            
            Section("Where did you meet them?") {
                Picker("Met at", selection: $person.tag) {
                    Text("Unkown event")
                        .tag(Optional<Tag>.none)
                    
                    if events.isEmpty == false {
                        Divider()
                        
                        ForEach(events) { event in
                            Text(event.name)
                                .tag(Optional(event))
                        }
                    }
                }
                
                Button("Add a new tag", action: addEvent)
            }
            
            Section("Notes") {
                TextField("Details about this person", text: $person.details, axis: .vertical)
            }
        }
        .navigationTitle("Edit Diary Entry")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: Tag.self) { event in
                EditTagView(tag: event)
        }
        .onChange(of: selectedItem, loadPhoto)
    }
}

#Preview {
    do {
        let previewer = try Previewer()

        return EditDiaryEntryView(person: previewer.diaryEntry, navigationPath: .constant(NavigationPath()))
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
