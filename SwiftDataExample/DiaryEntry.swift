//
//  DiaryEntry.swift
//  SwiftDataExample
//
//  Created by Angelo Andrioli Netho on 03/10/25.
//

import SwiftData
import Foundation

@Model
class DiaryEntry {
    var details: String = ""
    
    @Relationship(inverse: \Tag.diaryEntries) var tags: [Tag]? = [Tag]()
    @Relationship(inverse: \Tag.diaryEntries) var emotions: [Emotion]? = [Emotion]()
    @Attribute(.externalStorage) var photo: Data?
    
    init(details: String, tags: [Tag] = [], emotions: [Emotion] = []) {
        self.details = details
        self.tags = tags
        self.emotions = emotions
    }
}
