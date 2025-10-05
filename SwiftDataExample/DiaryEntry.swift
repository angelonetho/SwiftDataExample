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
    var tag: Tag?
    var emotion: Emotion?
    @Attribute(.externalStorage) var photo: Data?
    
    init(details: String, tag: Tag? = nil, emotion: Emotion? = nil) {
        self.details = details
        self.tag = tag
        self.emotion = emotion
    }
}
