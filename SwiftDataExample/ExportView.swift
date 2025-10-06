//
//  ExportView.swift
//  SwiftDataExample
//
//  Created by Angelo Andrioli Netho on 05/10/25.
//

import SwiftUI
import SwiftData

struct ExportView: View {
    
    @Query var diaryEntries: [DiaryEntry]
    
    @State private var startDate: Date = {
        Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    }()
    
    @State private var endDate: Date = Date()
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
    
    private var filteredEntries: [DiaryEntry] {
        diaryEntries.filter { entry in
            entry.createdAt >= startDate.startOfDay && entry.createdAt <= endDate.endOfDay
        }
        .sorted { $0.createdAt < $1.createdAt }
    }
    
    private var mostFrequentEmotion: (name: String, count: Int)? {
        let names = filteredEntries.flatMap { $0.emotions?.map { $0.name } ?? [] }
        guard !names.isEmpty else { return nil }
        let counts = names.reduce(into: [String: Int]()) { $0[$1, default: 0] += 1 }
        if let (name, count) = counts.max(by: { $0.value < $1.value }) {
            return (name, count)
        }
        return nil
    }

    private var emotionFrequencies: [(name: String, count: Int)] {
        let names = filteredEntries.flatMap { $0.emotions?.map { $0.name } ?? [] }
        let counts = names.reduce(into: [String: Int]()) { $0[$1, default: 0] += 1 }
        return counts
            .map { ($0.key, $0.value) }
            .sorted { lhs, rhs in
                if lhs.count == rhs.count { return lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending }
                return lhs.count > rhs.count
            }
    }

    private var exportJSONString: String {
        let iso = ISO8601DateFormatter()
        let items: [[String: Any]] = filteredEntries.map { entry in
            [
                "details": entry.details,
                "createdAt": iso.string(from: entry.createdAt),
                "tags": (entry.tags ?? []).map { $0.name },
                "emotions": (entry.emotions ?? []).map { $0.name }
            ]
        }
        let payload: [String: Any] = [
            "exportedAt": iso.string(from: Date()),
            "range": [
                "start": iso.string(from: startDate.startOfDay),
                "end": iso.string(from: endDate.endOfDay)
            ],
            "count": filteredEntries.count,
            "entries": items
        ]
        if let data = try? JSONSerialization.data(withJSONObject: payload, options: [.prettyPrinted]),
           let str = String(data: data, encoding: .utf8) {
            return str
        }
        return ""
    }

    private var exportHumanReadableString: String {
        guard !filteredEntries.isEmpty else { return "Sem entradas no período selecionado." }

        // Cabeçalho e período
        let header = "Exportação do Diário"
        let period = "Período: \(startDate.formatted(date: .abbreviated, time: .omitted)) – \(endDate.formatted(date: .abbreviated, time: .omitted))"

        // Resumo de emoções
        var summaryLines: [String] = ["Resumo de Emoções:"]
        if emotionFrequencies.isEmpty {
            summaryLines.append("- (Sem emoções registradas)")
        } else {
            for (name, count) in emotionFrequencies {
                summaryLines.append("- \(name): \(count)x")
            }
        }
        let summaryBlock = summaryLines.joined(separator: "\n")

        // Entradas detalhadas
        let separator = String(repeating: "—", count: 18)
        let entryBlocks: [String] = filteredEntries.map { entry in
            let details = entry.details.isEmpty ? "(Sem descrição)" : entry.details
            let emotions = (entry.emotions ?? []).map { $0.name }.joined(separator: ", ")
            let tags = (entry.tags ?? []).map { $0.name }.joined(separator: ", ")
            let dateLine = dateFormatter.string(from: entry.createdAt)
            let emotionsLine = emotions.isEmpty ? "(Sem emoções)" : emotions
            let tagsLine = tags.isEmpty ? "(Sem tags)" : tags
            return [
                "• \(dateLine)",
                "  Detalhes: \(details)",
                "  Emoções: \(emotionsLine)",
                "  Tags: \(tagsLine)",
                separator
            ].joined(separator: "\n")
        }

        // Monta o corpo completo
        let parts = [
            header,
            period,
            "",
            summaryBlock,
            "",
            "Entradas:",
            entryBlocks.joined(separator: "\n")
        ]

        return parts.joined(separator: "\n")
    }
    
    var body: some View {
        Form {
            Section("Filtrar por data") {
                DatePicker("Início", selection: $startDate, displayedComponents: .date)
                DatePicker("Fim", selection: $endDate, in: startDate...Date(), displayedComponents: .date)
            }
            
            Section("Resumo") {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        Image(systemName: "chart.bar.fill")
                            .foregroundStyle(.secondary)
                        Text("Visão geral do período")
                            .font(.headline)
                    }
                    Divider()
                    HStack {
                        Text("Entradas")
                        Spacer()
                        Text("\(filteredEntries.count)")
                            .bold()
                    }
                    HStack {
                        Text("Emoção mais frequente")
                        Spacer()
                        if let top = mostFrequentEmotion {
                            Text("\(top.name) (\(top.count)x)")
                                .bold()
                        } else {
                            Text("—")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(.thinMaterial)
                )
            }
            
            Section(header: Text("Entradas (\(filteredEntries.count))")) {
                if filteredEntries.isEmpty {
                    ContentUnavailableView("Sem entradas no período", systemImage: "calendar")
                } else {
                    ForEach(filteredEntries) { entry in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(entry.details.isEmpty ? "(Sem descrição)" : entry.details)
                                .font(.body)
                            Text(dateFormatter.string(from: entry.createdAt))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle("Exportar")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ShareLink(item: exportHumanReadableString) {
                    Label("Exportar", systemImage: "square.and.arrow.up")
                }
                .disabled(filteredEntries.isEmpty)
            }
        }
        .onChange(of: startDate) { _, newValue in
            // Garante que a data final nunca seja anterior à inicial
            if endDate < newValue { endDate = newValue }
        }
        .onChange(of: endDate) { _, newValue in
            // Garante que o intervalo seja válido
            if newValue < startDate { startDate = newValue }
        }
    }
}

private extension Date {
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    var endOfDay: Date {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: self)
        return calendar.date(byAdding: DateComponents(day: 1, second: -1), to: start) ?? self
    }
}

#Preview {
    ExportView()
}
