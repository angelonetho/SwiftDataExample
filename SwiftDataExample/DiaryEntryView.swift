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
        _diaryEntry = Query(filter: #Predicate { diaryEntry in
            if searchString.isEmpty {
                true
            } else {
                diaryEntry.details.localizedStandardContains(searchString)
                || ((diaryEntry.tag?.name.localizedStandardContains(searchString)) != nil)
            }
           
        }, sort: sortOrder)
    }
    
    @Query var diaryEntry: [DiaryEntry]
    
    @Environment(\.modelContext) var modelContext
    
    func deletePeople(at offsets: IndexSet) {
        for offset in offsets {
            let diaryEntry = diaryEntry[offset]
            modelContext.delete(diaryEntry)
        }
    }
    
    var body: some View {
        List {
            ForEach(diaryEntry) { diaryEntry in
                NavigationLink(value: diaryEntry) {
                    Text(diaryEntry.details)
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

