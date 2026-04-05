import SwiftUI
import SwiftData

struct JournalFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var trigger = ""
    @State private var triggerDetail = ""
    @State private var emotion = ""
    @State private var intensity = 3
    @State private var fact = ""
    @State private var story = ""
    @State private var didAct = false
    @State private var actedFrom = ""
    @State private var outcome = ""
    @State private var lesson = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Que paso?") {
                    Picker("Gatillo", selection: $trigger) {
                        Text("Selecciona...").tag("")
                        ForEach(TriggerType.allCases, id: \.rawValue) { t in
                            Text(t.rawValue).tag(t.rawValue)
                        }
                    }
                    if trigger == "Otro" {
                        TextField("Detalle", text: $triggerDetail)
                    }
                }

                Section("Que sentiste?") {
                    Picker("Emocion", selection: $emotion) {
                        Text("Selecciona...").tag("")
                        ForEach(EmotionType.allCases, id: \.rawValue) { e in
                            Text(e.rawValue).tag(e.rawValue)
                        }
                    }
                    VStack(alignment: .leading) {
                        Text("Intensidad: \(intensity)")
                        Slider(value: .init(get: { Double(intensity) }, set: { intensity = Int($0) }), in: 1...5, step: 1)
                            .tint(.indigo)
                    }
                }

                Section("Hecho vs Historia") {
                    TextField("Que paso realmente?", text: $fact, axis: .vertical)
                        .lineLimit(2...4)
                    TextField("Que interpretaste?", text: $story, axis: .vertical)
                        .lineLimit(2...4)
                }

                Section("Resultado") {
                    Toggle("Actue?", isOn: $didAct)
                    if didAct {
                        Picker("Desde donde?", selection: $actedFrom) {
                            Text("Miedo").tag("Miedo")
                            Text("Claridad").tag("Claridad")
                        }
                        .pickerStyle(.segmented)
                    }
                    Picker("Como termino?", selection: $outcome) {
                        Text("Selecciona...").tag("")
                        ForEach(OutcomeType.allCases, id: \.rawValue) { o in
                            Text(o.rawValue).tag(o.rawValue)
                        }
                    }
                }

                Section("Aprendizaje") {
                    TextField("Que aprendi? (opcional)", text: $lesson, axis: .vertical)
                        .lineLimit(2...4)
                }
            }
            .navigationTitle("Nueva entrada")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        save()
                        dismiss()
                    }
                    .disabled(fact.isEmpty)
                }
            }
        }
    }

    private func save() {
        let entry = JournalEntry(
            trigger: trigger,
            triggerDetail: triggerDetail,
            emotion: emotion,
            intensity: intensity,
            fact: fact,
            story: story,
            didAct: didAct,
            actedFrom: didAct ? actedFrom : nil,
            outcome: outcome.isEmpty ? nil : outcome,
            lesson: lesson.isEmpty ? nil : lesson,
            fromProtocol: false
        )
        modelContext.insert(entry)
    }
}
