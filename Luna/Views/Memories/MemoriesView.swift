import SwiftUI
import SwiftData
import PhotosUI

struct MemoriesView: View {
    @Query(sort: \Memory.createdAt, order: .reverse) private var memories: [Memory]
    @Environment(\.modelContext) private var modelContext
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedMemory: Memory?
    @State private var pendingImageData: Data?
    @State private var pendingVideoData: Data?
    @State private var pendingIsVideo = false
    @State private var showForm = false

    let columns = [
        GridItem(.flexible(), spacing: 4),
        GridItem(.flexible(), spacing: 4),
        GridItem(.flexible(), spacing: 4),
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                if memories.isEmpty {
                    emptyState
                } else {
                    LazyVGrid(columns: columns, spacing: 4) {
                        ForEach(memories) { memory in
                            MemoryThumbnail(memory: memory)
                                .onTapGesture { selectedMemory = memory }
                        }
                    }
                    .padding(4)
                    .padding(.bottom, 80)
                }
            }
            .navigationTitle("Recuerdos")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    PhotosPicker(selection: $selectedItems, maxSelectionCount: 1, matching: .any(of: [.images, .videos])) {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
            .onChange(of: selectedItems) { _, items in
                guard let item = items.first else { return }
                Task { await loadMedia(from: item) }
                selectedItems = []
            }
            .sheet(isPresented: $showForm) {
                AddMemoryView(imageData: pendingImageData, videoData: pendingVideoData, isVideo: pendingIsVideo)
            }
            .fullScreenCover(item: $selectedMemory) { memory in
                MemoryDetailView(memory: memory, allMemories: memories)
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 50))
                .foregroundStyle(.indigo.opacity(0.5))
            Text("Sin recuerdos aun")
                .font(.headline)
                .foregroundStyle(.secondary)
            Text("Agrega fotos y videos con el boton +")
                .font(.caption)
                .foregroundStyle(.tertiary)
            Spacer()
        }
    }

    private func loadMedia(from item: PhotosPickerItem) async {
        // Try video first
        if let videoData = try? await item.loadTransferable(type: VideoTransferable.self) {
            pendingVideoData = videoData.data
            pendingImageData = nil
            pendingIsVideo = true
            // Generate thumbnail
            if let thumb = await generateThumbnail(from: videoData.data) {
                pendingImageData = thumb
            }
            showForm = true
            return
        }

        // Then image
        if let data = try? await item.loadTransferable(type: Data.self) {
            pendingImageData = data
            pendingVideoData = nil
            pendingIsVideo = false
            showForm = true
        }
    }

    private func generateThumbnail(from videoData: Data) async -> Data? {
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("temp_video.mov")
        try? videoData.write(to: tempURL)

        let asset = AVAsset(url: tempURL)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        generator.maximumSize = CGSize(width: 400, height: 400)

        guard let cgImage = try? await generator.image(at: .zero).image else { return nil }
        let uiImage = UIImage(cgImage: cgImage)
        return uiImage.jpegData(compressionQuality: 0.7)
    }
}

import AVFoundation

struct VideoTransferable: Transferable {
    let data: Data

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(importedContentType: .movie) { data in
            VideoTransferable(data: data)
        }
    }
}

private struct MemoryThumbnail: View {
    let memory: Memory

    var body: some View {
        if let data = memory.imageData, let uiImage = UIImage(data: data) {
            ZStack(alignment: .bottomLeading) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(minHeight: 120)
                    .clipped()

                HStack(spacing: 4) {
                    if memory.isVideo {
                        Image(systemName: "play.fill")
                            .font(.system(size: 8))
                            .foregroundStyle(.white)
                            .padding(4)
                            .background(.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                    if !memory.place.isEmpty {
                        Text(memory.place)
                            .font(.system(size: 9))
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
                            .background(.black.opacity(0.5))
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                }
                .padding(4)
            }
        }
    }
}

// MARK: - Add Memory Form

struct AddMemoryView: View {
    let imageData: Data?
    let videoData: Data?
    let isVideo: Bool
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Milestone.date, order: .reverse) private var milestones: [Milestone]
    @State private var caption = ""
    @State private var place = ""
    @State private var selectedMilestone = ""

    var body: some View {
        NavigationStack {
            Form {
                if let data = imageData, let uiImage = UIImage(data: data) {
                    Section {
                        ZStack {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 250)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            if isVideo {
                                Image(systemName: "play.circle.fill")
                                    .font(.system(size: 40))
                                    .foregroundStyle(.white.opacity(0.8))
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }

                Section("Detalles") {
                    TextField("Frase o momento", text: $caption, axis: .vertical)
                        .lineLimit(2...4)
                    TextField("Lugar", text: $place)
                }

                if !milestones.isEmpty {
                    Section("Vincular a un hito") {
                        Picker("Hito", selection: $selectedMilestone) {
                            Text("Ninguno").tag("")
                            ForEach(milestones) { milestone in
                                Text(milestone.title).tag(milestone.persistentModelID.hashValue.description)
                            }
                        }
                    }
                }
            }
            .navigationTitle(isVideo ? "Nuevo video" : "Nuevo recuerdo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        let memory = Memory(
                            imageData: imageData,
                            videoData: isVideo ? videoData : nil,
                            isVideo: isVideo,
                            caption: caption,
                            place: place,
                            milestoneId: selectedMilestone.isEmpty ? nil : selectedMilestone
                        )
                        modelContext.insert(memory)
                        dismiss()
                    }
                }
            }
        }
    }
}
