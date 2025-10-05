//
//  Previewer.swift
//  SwiftDataExample
//
//  Created by Angelo Andrioli Netho on 03/10/25.
//

import SwiftData
struct Previewer {
    let container: ModelContainer
    let event: Event
    let person: Person
    
    init() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: Person.self, configurations: config)
        
        event = Event(name: "Katy Perry Concert", location: "Curitiba")
        person = Person(name: "Petter Griffin", emailAddress: "petter.griffin@pucpr.edu.br", details: "", metAt: event)
        
        container.mainContext.insert(person)
    }
}
