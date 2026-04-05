import SwiftUI
import SwiftData

struct AddPromiseView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var text = ""
    @State private var category = "Cambios"

    let categories = ["Mensajes", "Relacion", "Mi cabeza", "Cambios"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Nueva promesa") {
                    TextField("Que prometes cambiar o no repetir?", text: $text, axis: .vertical)
                        .lineLimit(2...4)
                    Picker("Categoria", selection: $category) {
                        ForEach(categories, id: \.self) { cat in
                            Text(cat).tag(cat)
                        }
                    }
                }
            }
            .navigationTitle("Agregar promesa")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        let promise = Promise(text: text, category: category)
                        modelContext.insert(promise)
                        dismiss()
                    }
                    .disabled(text.isEmpty)
                }
            }
        }
    }
}
