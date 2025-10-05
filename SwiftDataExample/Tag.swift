//
//  Tag.swift
//  SwiftDataExample
//
//  Created by Angelo Andrioli Netho on 03/10/25.
//

import SwiftData

@Model
class Tag {
    var name: String = ""
    var people: [Person]? = [Person]()
    
    init(name: String) {
        self.name = name
    }
}
