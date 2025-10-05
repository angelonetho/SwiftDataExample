//
//  Previewer.swift
//  SwiftDataExample
//
//  Created by Angelo Andrioli Netho on 03/10/25.
//

import SwiftData
struct Previewer {
    let container: ModelContainer
    let tag: Tag
    let diaryEntry: DiaryEntry
    
    init() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: DiaryEntry.self, configurations: config)
        
        tag = Tag(name: "Work")
        diaryEntry = DiaryEntry(details: "", tag: tag)
        
        container.mainContext.insert(diaryEntry)
    }
}
