import SwiftUI
import SwiftData

struct MilestoneDetailView: View {
    @Bindable var milestone: Milestone
    @Query private var allMemories: [Memory]
    @State private var isEditing = false
    @State private var selectedMemory: Memory?

    private var linkedMemories: [Memory] {
        let id = milestone.persistentModelID.hashValue.description
        return allMemories.filter { $0.milestoneId == id }
    }

    var body: some View {
        List {
            if !isEditing {
                readView
            } else {
                editView
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
        .fullScreenCover(item: $selectedMemory) { memory in
            MemoryDetailView(memory: memory, allMemories: linkedMemories)
        }
    }

    @ViewBuilder
    private var readView: some View {
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

        if !linkedMemories.isEmpty {
            Section("Fotos y videos") {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(linkedMemories) { memory in
                            if let data = memory.imageData, let uiImage = UIImage(data: data) {
                                ZStack(alignment: .bottomTrailing) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                    if memory.isVideo {
                                        Image(systemName: "play.fill")
                                            .font(.caption2)
                                            .foregroundStyle(.white)
                                            .padding(4)
                                            .background(.black.opacity(0.6))
                                            .clipShape(Circle())
                                            .padding(4)
                                    }
                                }
                                .onTapGesture { selectedMemory = memory }
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
                .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
            }
        }
    }

    @ViewBuilder
    private var editView: some View {
        Section("Editar") {
            TextField("Titulo", text: $milestone.title)
            TextField("Detalle", text: $milestone.detail, axis: .vertical)
                .lineLimit(2...6)
            DatePicker("Fecha", selection: $milestone.date, displayedComponents: .date)

            IconPickerGrid(selected: $milestone.icon)
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
