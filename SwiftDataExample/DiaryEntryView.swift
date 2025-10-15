//
//  DiaryEntryView.swift
//  SwiftDataExample
//
//  Created by Angelo Andrioli Netho on 03/10/25.
//

import SwiftUI
import SwiftData

struct DiaryEntryView: View {
    init(searchString: String = "", sortOrder: [SortDescriptor<DiaryEntry>] = []) {
        _diaryEntry = Query(
            filter: #Predicate<DiaryEntry> { entry in
                if searchString.isEmpty {
                    true
                } else {
                    ((entry.tags?.contains { tag in
                        tag.name.localizedStandardContains(searchString)
                    }) ?? false)
                    ||
                    ((entry.emotions?.contains { emotion in
                        emotion.name.localizedStandardContains(searchString)
                    }) ?? false)
                    ||
                    entry.details.localizedStandardContains(searchString)
                }
            },
            sort: sortOrder
        )
    }
    
    
    @Query var diaryEntry: [DiaryEntry]
    
    @Environment(\.modelContext) var modelContext
    
    func deletePeople(at offsets: IndexSet) {
        for offset in offsets {
            let diaryEntry = diaryEntry[offset]
            modelContext.delete(diaryEntry)
        }
    }
    
    func delete(_ entry: DiaryEntry) {
        modelContext.delete(entry)
    }
    
    private static let cachedDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    private var dateFormatter: DateFormatter { Self.cachedDateFormatter }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                ForEach(diaryEntry) { entry in
                    HStack(alignment: .top, spacing: 12) {
                        NavigationLink(value: entry) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(entry.details.isEmpty ? "(Sem descrição)" : entry.details)
                                    .font(.default)
                                    .foregroundStyle(.primary)
                                    .multilineTextAlignment(.leading)
                                    .contentTransition(.opacity)
                                
                                Divider()
                                
                                Text(dateFormatter.string(from: entry.createdAt))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .minimumScaleFactor(0.9)
                                
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(.thinMaterial)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .strokeBorder(.separator, lineWidth: 0.5)
                    )
                    .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
                    .contextMenu {
                        NavigationLink(value: entry) {
                            Label("Editar", systemImage: "pencil")
                        }
                        Button(role: .destructive) {
                            delete(entry)
                        } label: {
                            Label("Excluir", systemImage: "trash")
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .animation(.snappy, value: diaryEntry)
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        return DiaryEntryView()
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}

