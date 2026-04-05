import SwiftUI
import Charts

struct JournalStatsView: View {
    let entries: [JournalEntry]
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section("Resumen") {
                    HStack {
                        StatCard(title: "Total", value: "\(entries.count)", color: .indigo)
                        StatCard(title: "No actue", value: "\(entries.filter { !$0.didAct }.count)", color: .green)
                        StatCard(title: "Actue", value: "\(entries.filter { $0.didAct }.count)", color: .orange)
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                }

                if !triggerCounts.isEmpty {
                    Section("Gatillos mas frecuentes") {
                        Chart(triggerCounts, id: \.0) { item in
                            BarMark(
                                x: .value("Cantidad", item.1),
                                y: .value("Gatillo", item.0)
                            )
                            .foregroundStyle(.indigo.gradient)
                        }
                        .frame(height: CGFloat(triggerCounts.count * 36))
                    }
                }

                if !emotionCounts.isEmpty {
                    Section("Emociones mas frecuentes") {
                        Chart(emotionCounts, id: \.0) { item in
                            BarMark(
                                x: .value("Cantidad", item.1),
                                y: .value("Emocion", item.0)
                            )
                            .foregroundStyle(.purple.gradient)
                        }
                        .frame(height: CGFloat(emotionCounts.count * 36))
                    }
                }

                Section("Ratio de control") {
                    let total = entries.count
                    let notActed = entries.filter { !$0.didAct }.count
                    let pct = total > 0 ? Int(Double(notActed) / Double(total) * 100) : 0

                    VStack(spacing: 8) {
                        Text("\(pct)%")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundStyle(pct >= 70 ? .green : pct >= 40 ? .orange : .red)
                        Text("de las veces NO actuaste impulsivamente")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
            }
            .navigationTitle("Estadisticas")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cerrar") { dismiss() }
                }
            }
        }
    }

    private var triggerCounts: [(String, Int)] {
        Dictionary(grouping: entries.filter { !$0.trigger.isEmpty }, by: \.trigger)
            .map { ($0.key, $0.value.count) }
            .sorted { $0.1 > $1.1 }
    }

    private var emotionCounts: [(String, Int)] {
        Dictionary(grouping: entries.filter { !$0.emotion.isEmpty }, by: \.emotion)
            .map { ($0.key, $0.value.count) }
            .sorted { $0.1 > $1.1 }
    }
}

private struct StatCard: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(color)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}
