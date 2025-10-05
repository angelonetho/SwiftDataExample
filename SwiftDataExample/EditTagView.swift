//
//  EditTagView.swift
//  SwiftDataExample
//
//  Created by Angelo Andrioli Netho on 03/10/25.
//

import SwiftUI
import SwiftData

struct EditTagView: View {
    
    @Bindable var tag: Tag
    
    var body: some View {
        Form {
            TextField("Name of the tag", text: $tag.name)
        }
        .navigationTitle("Edit Tag")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    do {
        let previewer = try Previewer()

        return EditTagView(tag: previewer.tag)
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
