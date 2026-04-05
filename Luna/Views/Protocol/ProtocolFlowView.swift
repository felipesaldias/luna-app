import SwiftUI
import SwiftData

struct ProtocolFlowView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var step = 0
    @State private var fact = ""
    @State private var story = ""
    @State private var regulation = ""
    @State private var stillReal = ""
    @State private var worthActing = false
    @State private var actingFrom = ""
    @State private var trigger = ""
    @State private var emotion = ""
    @State private var intensity = 3

    var body: some View {
        NavigationStack {
            VStack {
                // Progress
                ProgressView(value: Double(step), total: 5)
                    .tint(.indigo)
                    .padding(.horizontal)

                Spacer()

                Group {
                    switch step {
                    case 0: pauseStep
                    case 1: factStoryStep
                    case 2: regulateStep
                    case 3: evaluateStep
                    case 4: decisionStep
                    default: EmptyView()
                    }
                }
                .padding(.horizontal, 24)

                Spacer()
            }
            .navigationTitle("Paso \(step + 1) de 5")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Salir") { dismiss() }
                }
            }
        }
    }

    // MARK: - Steps

    private var pauseStep: some View {
        PauseStepView {
            step = 1
        }
    }

    private var factStoryStep: some View {
        VStack(spacing: 20) {
            Image(systemName: "eye.fill")
                .font(.system(size: 40))
                .foregroundStyle(.indigo)

            Text("Hecho vs Historia")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Separa lo que paso de lo que interpretas")
                .foregroundStyle(.secondary)

            Picker("Gatillo", selection: $trigger) {
                Text("Selecciona...").tag("")
                ForEach(TriggerType.allCases, id: \.rawValue) { t in
                    Text(t.rawValue).tag(t.rawValue)
                }
            }

            Picker("Emocion", selection: $emotion) {
                Text("Selecciona...").tag("")
                ForEach(EmotionType.allCases, id: \.rawValue) { e in
                    Text(e.rawValue).tag(e.rawValue)
                }
            }

            VStack(alignment: .leading) {
                Text("Intensidad: \(intensity)")
                    .font(.caption)
                Slider(value: .init(get: { Double(intensity) }, set: { intensity = Int($0) }), in: 1...5, step: 1)
                    .tint(.indigo)
            }

            TextField("Que paso realmente? (el hecho)", text: $fact, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(3...5)

            TextField("Que estoy interpretando? (la historia)", text: $story, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(3...5)

            Button("Siguiente") { step = 2 }
                .buttonStyle(.borderedProminent)
                .tint(.indigo)
                .disabled(fact.isEmpty || story.isEmpty)
        }
    }

    private var regulateStep: some View {
        VStack(spacing: 20) {
            Image(systemName: "figure.walk")
                .font(.system(size: 40))
                .foregroundStyle(.indigo)

            Text("Regulacion")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Haz algo fisico antes de pensar en actuar")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            VStack(spacing: 12) {
                ForEach(["Caminar", "Respirar", "Ejercicio", "Otra cosa"], id: \.self) { option in
                    Button {
                        regulation = option
                    } label: {
                        HStack {
                            Text(option)
                            Spacer()
                            if regulation == option {
                                Image(systemName: "checkmark.circle.fill")
                            }
                        }
                        .padding()
                        .background(regulation == option ? Color.indigo.opacity(0.15) : Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .foregroundStyle(regulation == option ? .indigo : .primary)
                }
            }

            Text("Toma al menos 15 minutos haciendo esto.\nVuelve cuando estes mas tranquilo.")
                .font(.callout)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button("Ya me regule, siguiente") { step = 3 }
                .buttonStyle(.borderedProminent)
                .tint(.indigo)
                .disabled(regulation.isEmpty)
        }
    }

    private var evaluateStep: some View {
        VStack(spacing: 20) {
            Image(systemName: "brain.head.profile")
                .font(.system(size: 40))
                .foregroundStyle(.indigo)

            Text("Evaluacion")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Ahora que estas mas tranquilo...")
                .foregroundStyle(.secondary)

            Text("Lo que sentiste, sigue siendo real?")
                .font(.headline)

            VStack(spacing: 12) {
                ForEach(["Si", "No", "No estoy seguro"], id: \.self) { option in
                    Button {
                        stillReal = option
                    } label: {
                        Text(option)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(stillReal == option ? Color.indigo.opacity(0.15) : Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .foregroundStyle(stillReal == option ? .indigo : .primary)
                }
            }

            Button("Siguiente") { step = 4 }
                .buttonStyle(.borderedProminent)
                .tint(.indigo)
                .disabled(stillReal.isEmpty)
        }
    }

    private var decisionStep: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.shield.fill")
                .font(.system(size: 40))
                .foregroundStyle(.green)

            Text("Decision")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Vale la pena actuar?")
                .font(.headline)

            HStack(spacing: 16) {
                Button("No") {
                    worthActing = false
                    saveAndDismiss()
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)

                Button("Si") {
                    worthActing = true
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
            }

            if worthActing {
                Text("Desde que energia lo harias?")
                    .font(.headline)

                HStack(spacing: 16) {
                    Button("Miedo") {
                        actingFrom = "Miedo"
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(actingFrom == "Miedo" ? .red : .gray)

                    Button("Claridad") {
                        actingFrom = "Claridad"
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(actingFrom == "Claridad" ? .green : .gray)
                }

                if actingFrom == "Miedo" {
                    Text("Si es desde el miedo, mejor no actues.\nEspera a tener claridad.")
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                }

                if !actingFrom.isEmpty {
                    Button("Guardar y terminar") {
                        saveAndDismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.indigo)
                }
            }
        }
    }

    private func saveAndDismiss() {
        let entry = JournalEntry(
            trigger: trigger,
            triggerDetail: "",
            emotion: emotion,
            intensity: intensity,
            fact: fact,
            story: story,
            didAct: worthActing && actingFrom == "Claridad",
            actedFrom: actingFrom.isEmpty ? nil : actingFrom,
            outcome: nil,
            lesson: nil,
            fromProtocol: true
        )
        modelContext.insert(entry)
        dismiss()
    }
}
