//
//  EditEmotionView.swift
//  SwiftDataExample
//
//  Created by Angelo Andrioli Netho on 05/10/25.
//

import SwiftUI
import SwiftData

struct EditEmotionView: View {
    
    @Bindable var emotion: Emotion
    
    var body: some View {
        Form {
            TextField("Name of the emotion", text: $emotion.name)
        }
        .navigationTitle("Edit Emotion")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    do {
        let previewer = try Previewer()

        return EditEmotionView(emotion: previewer.emotion)
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
