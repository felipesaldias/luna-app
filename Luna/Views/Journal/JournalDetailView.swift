import SwiftUI

struct JournalDetailView: View {
    let entry: JournalEntry

    var body: some View {
        List {
            Section("Contexto") {
                row("Fecha", entry.date.formatted(date: .long, time: .shortened))
                row("Gatillo", entry.trigger)
                row("Emocion", entry.emotion)
                HStack {
                    Text("Intensidad")
                    Spacer()
                    IntensityBar(intensity: entry.intensity)
                }
            }

            Section("Hecho vs Historia") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Hecho")
                        .font(.caption)
                        .foregroundStyle(.green)
                    Text(entry.fact)
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("Historia")
                        .font(.caption)
                        .foregroundStyle(.red)
                    Text(entry.story)
                }
            }

            Section("Resultado") {
                row("Actue?", entry.didAct ? "Si" : "No")
                if let from = entry.actedFrom {
                    row("Desde", from)
                }
                if let outcome = entry.outcome {
                    row("Como termino", outcome)
                }
            }

            if let lesson = entry.lesson, !lesson.isEmpty {
                Section("Aprendizaje") {
                    Text(lesson)
                }
            }

            if entry.fromProtocol {
                Section {
                    Label("Generado desde el protocolo", systemImage: "shield.fill")
                        .foregroundStyle(.indigo)
                }
            }
        }
        .navigationTitle("Detalle")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func row(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
        }
    }
}

private struct IntensityBar: View {
    let intensity: Int

    var body: some View {
        HStack(spacing: 3) {
            ForEach(1...5, id: \.self) { i in
                RoundedRectangle(cornerRadius: 2)
                    .fill(i <= intensity ? Color.indigo : Color.indigo.opacity(0.2))
                    .frame(width: 16, height: 10)
            }
        }
    }
}
