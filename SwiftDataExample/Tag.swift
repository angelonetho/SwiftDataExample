//
//  Tag.swift
//  SwiftDataExample
//
//  Created by Angelo Andrioli Netho on 03/10/25.
//

import SwiftData
import Foundation

@Model
class Tag {
    var name: String = ""
    var diaryEntries: [DiaryEntry]? = [DiaryEntry]()
    
    init(name: String) {
        self.name = name
    }
}
