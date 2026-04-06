import SwiftUI
import SwiftData
import PhotosUI
import AVFoundation

struct MilestoneDetailView: View {
    @Bindable var milestone: Milestone
    @Query private var allMemories: [Memory]
    @Environment(\.modelContext) private var modelContext
    @State private var isEditing = false
    @State private var selectedMemory: Memory?
    @State private var selectedPhotoItem: [PhotosPickerItem] = []

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

        Section("Fotos y videos") {
            if linkedMemories.isEmpty {
                Text("Sin fotos aun")
                    .foregroundStyle(.tertiary)
            } else {
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

            PhotosPicker(selection: $selectedPhotoItem, maxSelectionCount: 1, matching: .any(of: [.images, .videos])) {
                Label("Agregar foto o video", systemImage: "plus.circle")
                    .foregroundStyle(.indigo)
            }
            .onChange(of: selectedPhotoItem) { _, items in
                guard let item = items.first else { return }
                Task { await addMedia(from: item) }
                selectedPhotoItem = []
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

    private func addMedia(from item: PhotosPickerItem) async {
        let milestoneIdStr = milestone.persistentModelID.hashValue.description

        // Try video
        if let videoData = try? await item.loadTransferable(type: VideoTransferable.self) {
            var thumbnail: Data?
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("temp_vid.mov")
            try? videoData.data.write(to: tempURL)
            let asset = AVAsset(url: tempURL)
            let gen = AVAssetImageGenerator(asset: asset)
            gen.appliesPreferredTrackTransform = true
            gen.maximumSize = CGSize(width: 400, height: 400)
            if let cgImage = try? await gen.image(at: .zero).image {
                thumbnail = UIImage(cgImage: cgImage).jpegData(compressionQuality: 0.7)
            }
            let memory = Memory(imageData: thumbnail, videoData: videoData.data, isVideo: true, milestoneId: milestoneIdStr)
            modelContext.insert(memory)
            return
        }

        // Image
        if let data = try? await item.loadTransferable(type: Data.self) {
            let memory = Memory(imageData: data, milestoneId: milestoneIdStr)
            modelContext.insert(memory)
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
