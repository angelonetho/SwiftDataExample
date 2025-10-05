//
//  DiaryEntryView.swift
//  SwiftDataExample
//
//  Created by Angelo Andrioli Netho on 03/10/25.
//

import SwiftUI
import SwiftData

struct DiaryEntryView: View {    
    init(searchString: String = "", sortOrder: [SortDescriptor<DiaryEntry>] = []) {
        _diaryEntry = Query(
            filter: #Predicate<DiaryEntry> { entry in
                if searchString.isEmpty {
                    true
                } else {
                    ((entry.tags?.contains { tag in
                        tag.name.localizedStandardContains(searchString)
                    }) ?? false)
                    ||
                    ((entry.emotions?.contains { emotion in
                        emotion.name.localizedStandardContains(searchString)
                    }) ?? false)
                    ||
                    entry.details.localizedStandardContains(searchString)
                }
            },
            sort: sortOrder
        )
    }

    
    @Query var diaryEntry: [DiaryEntry]
    
    @Environment(\.modelContext) var modelContext
    
    func deletePeople(at offsets: IndexSet) {
        for offset in offsets {
            let diaryEntry = diaryEntry[offset]
            modelContext.delete(diaryEntry)
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        List {
            ForEach(diaryEntry) { diaryEntry in
                NavigationLink(value: diaryEntry) {
                    Text(diaryEntry.details)
                    Text(dateFormatter.string(from: diaryEntry.createdAt))
                }
            }
            .onDelete(perform: deletePeople)
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        return DiaryEntryView()
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}

