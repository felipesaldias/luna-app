import SwiftUI
import SwiftData

struct JournalView: View {
    @Query(sort: \JournalEntry.date, order: .reverse) private var entries: [JournalEntry]
    @State private var showForm = false
    @State private var showStats = false

    var body: some View {
        NavigationStack {
            List {
                if !entries.isEmpty {
                    StatsPreview(entries: entries)
                }

                ForEach(entries) { entry in
                    NavigationLink(destination: JournalDetailView(entry: entry)) {
                        JournalRow(entry: entry)
                    }
                }
            }
            .navigationTitle("Diario")
            .navigationBarTitleDisplayMode(.inline)
            .contentMargins(.bottom, 80, for: .scrollContent)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 16) {
                        Button { showStats = true } label: {
                            Image(systemName: "chart.bar.fill")
                        }
                        Button { showForm = true } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            .sheet(isPresented: $showForm) {
                JournalFormView()
            }
            .sheet(isPresented: $showStats) {
                JournalStatsView(entries: entries)
            }
            .overlay {
                if entries.isEmpty {
                    ContentUnavailableView("Sin entradas", systemImage: "book", description: Text("Usa el protocolo o agrega una entrada manual"))
                }
            }
        }
    }
}

private struct StatsPreview: View {
    let entries: [JournalEntry]

    var body: some View {
        Section {
            HStack {
                StatBox(value: "\(entries.count)", label: "Entradas")
                StatBox(value: "\(entries.filter { !$0.didAct }.count)", label: "No actue")
                StatBox(value: "\(entries.filter { $0.didAct }.count)", label: "Actue")
            }
        }
    }
}

private struct StatBox: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.indigo)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct JournalRow: View {
    let entry: JournalEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(entry.emotion.isEmpty ? "Sin emocion" : entry.emotion)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Spacer()
                if entry.fromProtocol {
                    Image(systemName: "shield.fill")
                        .font(.caption)
                        .foregroundStyle(.indigo)
                }
                IntensityDots(intensity: entry.intensity)
            }
            Text(entry.fact.prefix(80) + (entry.fact.count > 80 ? "..." : ""))
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(entry.date.formatted(date: .abbreviated, time: .shortened))
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 2)
    }
}

private struct IntensityDots: View {
    let intensity: Int

    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { i in
                Circle()
                    .fill(i <= intensity ? Color.indigo : Color.indigo.opacity(0.2))
                    .frame(width: 6, height: 6)
            }
        }
    }
}
