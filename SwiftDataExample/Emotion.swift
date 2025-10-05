//
//  Emotion.swift
//  SwiftDataExample
//
//  Created by Angelo Andrioli Netho on 05/10/25.
//

import SwiftData

@Model
class Emotion {
    var name: String = ""
    var diaryEntries: [DiaryEntry]? = [DiaryEntry]()
    
    init(name: String) {
        self.name = name
    }
}
