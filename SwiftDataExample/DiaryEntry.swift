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
    
    var emotion: Emotion?
    @Attribute(.externalStorage) var photo: Data?
    
    init(details: String, tags: [Tag] = [], emotion: Emotion? = nil) {
        self.details = details
        self.tags = tags
        self.emotion = emotion
    }
}
