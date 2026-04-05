import SwiftUI

struct JournalDetailView: View {
    @Bindable var entry: JournalEntry
    @State private var isEditing = false

    var body: some View {
        List {
            if !isEditing {
                readView
            } else {
                editView
            }
        }
        .navigationTitle(isEditing ? "Editar" : "Detalle")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(isEditing ? "Listo" : "Editar") {
                    isEditing.toggle()
                }
            }
        }
    }

    // MARK: - Read mode

    @ViewBuilder
    private var readView: some View {
        Section("Contexto") {
            row("Fecha", entry.date.formatted(date: .long, time: .shortened))
            if !entry.trigger.isEmpty { row("Gatillo", entry.trigger) }
            if !entry.emotion.isEmpty { row("Emocion", entry.emotion) }
            HStack {
                Text("Intensidad")
                Spacer()
                IntensityBar(intensity: entry.intensity)
            }
        }

        if let raw = entry.rawFeeling, !raw.isEmpty {
            Section("En caliente") {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Lo que escribiste antes de la pausa:")
                        .font(.caption)
                        .foregroundStyle(.orange)
                    Text(raw)
                        .italic()
                }
            }
        }

        if !entry.fact.isEmpty || !entry.story.isEmpty {
            Section("Hecho vs Historia") {
                if !entry.fact.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Hecho")
                            .font(.caption)
                            .foregroundStyle(.green)
                        Text(entry.fact)
                    }
                }
                if !entry.story.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Historia")
                            .font(.caption)
                            .foregroundStyle(.red)
                        Text(entry.story)
                    }
                }
            }
        }

        Section("Resultado") {
            row("Actue?", entry.didAct ? "Si" : "No")
            if let from = entry.actedFrom { row("Desde", from) }
            if let outcome = entry.outcome { row("Como termino", outcome) }
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

    // MARK: - Edit mode

    @ViewBuilder
    private var editView: some View {
        Section("Contexto") {
            Picker("Gatillo", selection: $entry.trigger) {
                Text("Selecciona...").tag("")
                ForEach(TriggerType.allCases, id: \.rawValue) { t in
                    Text(t.rawValue).tag(t.rawValue)
                }
            }
            Picker("Emocion", selection: $entry.emotion) {
                Text("Selecciona...").tag("")
                ForEach(EmotionType.allCases, id: \.rawValue) { e in
                    Text(e.rawValue).tag(e.rawValue)
                }
            }
            VStack(alignment: .leading) {
                Text("Intensidad: \(entry.intensity)")
                    .font(.caption)
                Slider(value: .init(get: { Double(entry.intensity) }, set: { entry.intensity = Int($0) }), in: 1...5, step: 1)
                    .tint(.indigo)
            }
        }

        Section("Hecho vs Historia") {
            TextField("Que paso realmente?", text: $entry.fact, axis: .vertical)
                .lineLimit(2...6)
            TextField("Que interpretaste?", text: $entry.story, axis: .vertical)
                .lineLimit(2...6)
        }

        Section("Resultado") {
            Toggle("Actue?", isOn: $entry.didAct)
            if entry.didAct {
                Picker("Desde donde?", selection: Binding(
                    get: { entry.actedFrom ?? "Miedo" },
                    set: { entry.actedFrom = $0 }
                )) {
                    Text("Miedo").tag("Miedo")
                    Text("Claridad").tag("Claridad")
                }
                .pickerStyle(.segmented)
            }
            Picker("Como termino?", selection: Binding(
                get: { entry.outcome ?? "" },
                set: { entry.outcome = $0.isEmpty ? nil : $0 }
            )) {
                Text("Selecciona...").tag("")
                ForEach(OutcomeType.allCases, id: \.rawValue) { o in
                    Text(o.rawValue).tag(o.rawValue)
                }
            }
        }

        Section("Aprendizaje") {
            TextField("Que aprendi? (opcional)", text: Binding(
                get: { entry.lesson ?? "" },
                set: { entry.lesson = $0.isEmpty ? nil : $0 }
            ), axis: .vertical)
                .lineLimit(2...6)
        }
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
