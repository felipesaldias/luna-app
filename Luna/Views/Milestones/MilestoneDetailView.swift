import SwiftUI

struct MilestoneDetailView: View {
    @Bindable var milestone: Milestone
    @State private var isEditing = false

    var body: some View {
        List {
            if !isEditing {
                Section {
                    VStack(spacing: 16) {
                        Image(systemName: milestone.icon)
                            .font(.system(size: 50))
                            .foregroundStyle(.indigo)

                        Text(milestone.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)

                        Text(milestone.date.formatted(date: .long, time: .omitted))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Text(daysDescription)
                            .font(.headline)
                            .foregroundStyle(.indigo)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                }

                if !milestone.detail.isEmpty {
                    Section("Detalle") {
                        Text(milestone.detail)
                    }
                }
            } else {
                Section("Editar") {
                    TextField("Titulo", text: $milestone.title)
                    TextField("Detalle", text: $milestone.detail, axis: .vertical)
                        .lineLimit(2...6)
                    DatePicker("Fecha", selection: $milestone.date, displayedComponents: .date)

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 12) {
                        ForEach(milestoneIcons, id: \.self) { icon in
                            Button {
                                milestone.icon = icon
                            } label: {
                                Image(systemName: icon)
                                    .font(.title3)
                                    .frame(width: 36, height: 36)
                                    .background(milestone.icon == icon ? Color.indigo.opacity(0.2) : Color.clear)
                                    .clipShape(Circle())
                            }
                            .foregroundStyle(milestone.icon == icon ? .indigo : .secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle(isEditing ? "Editar" : "Hito")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(isEditing ? "Listo" : "Editar") {
                    isEditing.toggle()
                }
            }
        }
    }

    private var daysDescription: String {
        let days = Calendar.current.dateComponents([.day], from: milestone.date, to: .now).day ?? 0
        if days == 0 { return "Hoy" }
        if days < 0 { return "En \(abs(days)) dias" }
        if days == 1 { return "Hace 1 dia" }
        if days < 30 { return "Hace \(days) dias" }
        let months = days / 30
        let remainingDays = days % 30
        if months < 12 {
            return "Hace \(months) mes\(months == 1 ? "" : "es") y \(remainingDays) dias"
        }
        let years = days / 365
        let remainingMonths = (days % 365) / 30
        return "Hace \(years) ano\(years == 1 ? "" : "s") y \(remainingMonths) mes\(remainingMonths == 1 ? "" : "es")"
    }
}
