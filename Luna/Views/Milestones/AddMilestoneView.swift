import SwiftUI
import SwiftData

struct AddMilestoneView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var title = ""
    @State private var detail = ""
    @State private var date = Date.now
    @State private var selectedIcon = "heart.fill"

    var body: some View {
        NavigationStack {
            Form {
                Section("Hito") {
                    TextField("Titulo (ej: Primera cita)", text: $title)
                    TextField("Detalle (opcional)", text: $detail, axis: .vertical)
                        .lineLimit(2...4)
                    DatePicker("Fecha", selection: $date, displayedComponents: .date)
                }

                Section("Icono") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 12) {
                        ForEach(milestoneIcons, id: \.self) { icon in
                            Button {
                                selectedIcon = icon
                            } label: {
                                Image(systemName: icon)
                                    .font(.title3)
                                    .frame(width: 36, height: 36)
                                    .background(selectedIcon == icon ? Color.indigo.opacity(0.2) : Color.clear)
                                    .clipShape(Circle())
                            }
                            .foregroundStyle(selectedIcon == icon ? .indigo : .secondary)
                        }
                    }
                }
            }
            .navigationTitle("Nuevo hito")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        let milestone = Milestone(title: title, detail: detail, date: date, icon: selectedIcon)
                        modelContext.insert(milestone)
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}
