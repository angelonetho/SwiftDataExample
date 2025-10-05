//
//  Event.swift
//  SwiftDataExample
//
//  Created by Angelo Andrioli Netho on 03/10/25.
//

import SwiftData

@Model
class Event {
    var name: String = ""
    var location: String = ""
    var people: [Person]? = [Person]()
    
    init(name: String, location: String) {
        self.name = name
        self.location = location
    }
}
