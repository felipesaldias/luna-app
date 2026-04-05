import SwiftUI
import SwiftData

struct AddAnchorView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var text = ""
    @State private var category = "Crecimiento"

    let categories = ["Patron emocional", "Control y soltar", "Relacion", "Crecimiento"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Nueva frase ancla") {
                    TextField("Escribe tu frase...", text: $text, axis: .vertical)
                        .lineLimit(2...4)
                    Picker("Categoria", selection: $category) {
                        ForEach(categories, id: \.self) { cat in
                            Text(cat).tag(cat)
                        }
                    }
                }
            }
            .navigationTitle("Agregar ancla")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        let anchor = Anchor(text: text, category: category, isDefault: false)
                        modelContext.insert(anchor)
                        dismiss()
                    }
                    .disabled(text.isEmpty)
                }
            }
        }
    }
}
