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
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var showDeleteAlert = false
    
    var body: some View {
        Form {
            TextField("Nome da emoção", text: $emotion.name)
        }
        .navigationTitle("Editar emoção")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(role: .destructive) {
                    showDeleteAlert = true
                } label: {
                    Label("Excluir", systemImage: "trash")
                }
                .accessibilityIdentifier("deleteEmotionButton")
            }
        }
        .alert("Excluir emoção?", isPresented: $showDeleteAlert) {
            Button("Cancelar", role: .cancel) { }
            Button("Excluir", role: .destructive) {
                modelContext.delete(emotion)
                try? modelContext.save()
                dismiss()
            }
        } message: {
            Text("Esta ação não pode ser desfeita.")
        }
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
