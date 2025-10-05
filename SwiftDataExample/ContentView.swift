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
    
    func addDiaryEntry() {
        let diaryEntry = DiaryEntry(details: "")
        
        path.append(diaryEntry)
        
        modelContext.insert(diaryEntry)
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            DiaryEntryView(searchString: searchText, sortOrder: sortOrder)
                .navigationTitle("FaceFacts")
                .navigationDestination(for: DiaryEntry.self) { person in
                    EditDiaryEntryView(person: person, navigationPath: $path)
                }
                .toolbar {
                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort", selection: $sortOrder) {
                            Text("Name (A-Z)")
                                //.tag([SortDescriptor(\DiaryEntry., order: .forward)])
                            Text("Name (Z-A)")
                                //.tag([SortDescriptor(\DiaryEntry.name, order: .reverse)])
                        }
                    }
                    
                    
                    Button("Add Diary Entry", systemImage: "plus", action: addDiaryEntry)
                }
                .searchable(text: $searchText)
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
