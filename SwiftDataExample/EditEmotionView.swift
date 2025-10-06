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
            TextField("Nome da emoção", text: $emotion.name)
        }
        .navigationTitle("Editar emoção")
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

