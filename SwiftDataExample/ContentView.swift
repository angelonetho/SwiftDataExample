//
//  ContentView.swift
//  SwiftDataExample
//
//  Created by Angelo Andrioli Netho on 03/10/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State private var path = NavigationPath()
    
    @Environment(\.modelContext) var modelContext
    
    @State private var searchText = ""
    
    @State private var sortOrder = [SortDescriptor(\DiaryEntry.details)]
    
    @Query(sort: [SortDescriptor(\Tag.name, order: .forward)])
    private var tags: [Tag]
    
    @Query(sort: [SortDescriptor(\Emotion.name, order: .forward)])
    private var emotions: [Emotion]
    
    func addDiaryEntry() {
        let diaryEntry = DiaryEntry(details: "")
        
        path.append(diaryEntry)
        
        modelContext.insert(diaryEntry)
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            DiaryEntryView(searchString: searchText, sortOrder: sortOrder)
                .navigationTitle("Jupiter")
                .navigationDestination(for: DiaryEntry.self) { person in
                    EditDiaryEntryView(diaryEntry: person, navigationPath: $path)
                }
                .toolbar {
                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort", selection: $sortOrder) {
                            Text("Mais recentes primeiro")
                                .tag([SortDescriptor(\DiaryEntry.createdAt, order: .reverse)])
                            Text("Mais antigas primeiro")
                                .tag([SortDescriptor(\DiaryEntry.createdAt, order: .forward)])
                        }
                    }
                    
                    
                    Button("Add Diary Entry", systemImage: "plus", action: addDiaryEntry)
                }
                .searchable(text: $searchText)
                .searchSuggestions {
                    ForEach(tags) { tag in
                        Text("#\(tag.name)")
                            .searchCompletion(tag.name)
                    }
                    ForEach(emotions) { emotion in
                        Text("#\(emotion.name)")
                            .searchCompletion(emotion.name)
                    }
                }
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        return ContentView()
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
