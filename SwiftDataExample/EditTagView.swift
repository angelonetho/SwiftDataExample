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
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var showDeleteAlert = false
    
    var body: some View {
        Form {
            TextField("Nome da tag", text: $tag.name)
        }
        .navigationTitle("Editar tag")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(role: .destructive) {
                    showDeleteAlert = true
                } label: {
                    Label("Excluir", systemImage: "trash")
                }
                .accessibilityIdentifier("deleteTagButton")
            }
        }
        .alert("Excluir tag?", isPresented: $showDeleteAlert) {
            Button("Cancelar", role: .cancel) { }
            Button("Excluir", role: .destructive) {
                modelContext.delete(tag)
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
        
        return EditTagView(tag: previewer.tag)
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
