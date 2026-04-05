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

    @State private var rawFeeling = ""

    var body: some View {
        NavigationStack {
            VStack {
                ProgressView(value: Double(step), total: 6)
                    .tint(.indigo)
                    .padding(.horizontal)

                Spacer()

                stepContent

                Spacer()
            }
            .navigationTitle("Paso \(step + 1) de 6")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Salir") { dismiss() }
                }
            }
        }
    }

    @ViewBuilder
    private var stepContent: some View {
        switch step {
        case 0:
            RawFeelingStep(rawFeeling: $rawFeeling, onNext: { step = 1 })
        case 1:
            PauseStepView { step = 2 }
        case 2:
            FactStoryStep(
                trigger: $trigger, emotion: $emotion, intensity: $intensity,
                fact: $fact, story: $story, rawFeeling: rawFeeling, onNext: { step = 3 }
            )
        case 3:
            RegulateStep(regulation: $regulation, onNext: { step = 4 })
        case 4:
            EvaluateStep(stillReal: $stillReal, onNext: { step = 5 })
        case 5:
            DecisionStep(
                worthActing: $worthActing, actingFrom: $actingFrom,
                onSave: { saveAndDismiss() }
            )
        default:
            EmptyView()
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
            fromProtocol: true,
            rawFeeling: rawFeeling.isEmpty ? nil : rawFeeling
        )
        modelContext.insert(entry)
        dismiss()
    }
}

// MARK: - Step 0: Raw Feeling

private struct RawFeelingStep: View {
    @Binding var rawFeeling: String
    let onNext: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "flame.fill")
                .font(.system(size: 40))
                .foregroundStyle(.orange)

            Text("Que estas sintiendo?")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Escribe lo que sientes ahora, en caliente.\nDespues de la pausa lo vamos a revisar.")
                .font(.callout)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            TextField("Escribe lo que sientes...", text: $rawFeeling, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(4...8)

            Button("Siguiente") { onNext() }
                .buttonStyle(.borderedProminent)
                .tint(.indigo)
                .disabled(rawFeeling.isEmpty)
        }
        .padding(.horizontal, 24)
    }
}

// MARK: - Step 2: Fact vs Story

private struct FactStoryStep: View {
    @Binding var trigger: String
    @Binding var emotion: String
    @Binding var intensity: Int
    @Binding var fact: String
    @Binding var story: String
    let rawFeeling: String
    let onNext: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(systemName: "eye.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(.indigo)

                Text("Hecho vs Historia")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text("Separa lo que paso de lo que interpretas")
                    .foregroundStyle(.secondary)

                // Show what they wrote in hot state
                VStack(alignment: .leading, spacing: 6) {
                    Text("Lo que escribiste en caliente:")
                        .font(.caption)
                        .foregroundStyle(.orange)
                    Text(rawFeeling)
                        .font(.callout)
                        .italic()
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.orange.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

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

                Button("Siguiente") { onNext() }
                    .buttonStyle(.borderedProminent)
                    .tint(.indigo)
                    .disabled(fact.isEmpty || story.isEmpty)
            }
            .padding(.horizontal, 24)
        }
    }
}

// MARK: - Step 3: Regulate

private struct RegulateStep: View {
    @Binding var regulation: String
    let onNext: () -> Void

    var body: some View {
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

            Button("Ya me regule, siguiente") { onNext() }
                .buttonStyle(.borderedProminent)
                .tint(.indigo)
                .disabled(regulation.isEmpty)
        }
        .padding(.horizontal, 24)
    }
}

// MARK: - Step 4: Evaluate

private struct EvaluateStep: View {
    @Binding var stillReal: String
    let onNext: () -> Void

    var body: some View {
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

            Button("Siguiente") { onNext() }
                .buttonStyle(.borderedProminent)
                .tint(.indigo)
                .disabled(stillReal.isEmpty)
        }
        .padding(.horizontal, 24)
    }
}

// MARK: - Step 5: Decision

private struct DecisionStep: View {
    @Binding var worthActing: Bool
    @Binding var actingFrom: String
    let onSave: () -> Void

    var body: some View {
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
                    onSave()
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
                actingFromSection
            }
        }
        .padding(.horizontal, 24)
    }

    private var actingFromSection: some View {
        VStack(spacing: 16) {
            Text("Desde que energia lo harias?")
                .font(.headline)

            HStack(spacing: 16) {
                Button("Miedo") { actingFrom = "Miedo" }
                    .buttonStyle(.borderedProminent)
                    .tint(actingFrom == "Miedo" ? .red : .gray)

                Button("Claridad") { actingFrom = "Claridad" }
                    .buttonStyle(.borderedProminent)
                    .tint(actingFrom == "Claridad" ? .green : .gray)
            }

            if actingFrom == "Miedo" {
                Text("Si es desde el miedo, mejor no actues.\nEspera a tener claridad.")
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
            }

            if !actingFrom.isEmpty {
                Button("Guardar y terminar") { onSave() }
                    .buttonStyle(.borderedProminent)
                    .tint(.indigo)
            }
        }
    }
}
