import SwiftUI
import SwiftData
import PhotosUI

struct MemoriesView: View {
    @Query(sort: \Memory.createdAt, order: .reverse) private var memories: [Memory]
    @Environment(\.modelContext) private var modelContext
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedMemory: Memory?
    @State private var pendingImageData: Data?
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
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
            .onChange(of: selectedItem) { _, item in
                if let item {
                    Task {
                        if let data = try? await item.loadTransferable(type: Data.self) {
                            pendingImageData = data
                            showForm = true
                        }
                        selectedItem = nil
                    }
                }
            }
            .sheet(isPresented: $showForm) {
                AddMemoryView(imageData: pendingImageData)
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
            Text("Agrega fotos con el boton +")
                .font(.caption)
                .foregroundStyle(.tertiary)
            Spacer()
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

                if !memory.place.isEmpty {
                    Text(memory.place)
                        .font(.system(size: 9))
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(.black.opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                        .padding(4)
                }
            }
        }
    }
}

// MARK: - Add Memory Form

private struct AddMemoryView: View {
    let imageData: Data?
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var caption = ""
    @State private var place = ""

    var body: some View {
        NavigationStack {
            Form {
                if let data = imageData, let uiImage = UIImage(data: data) {
                    Section {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 250)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .frame(maxWidth: .infinity)
                    }
                }

                Section("Detalles") {
                    TextField("Frase o momento", text: $caption, axis: .vertical)
                        .lineLimit(2...4)
                    TextField("Lugar", text: $place)
                }
            }
            .navigationTitle("Nuevo recuerdo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        let memory = Memory(imageData: imageData, caption: caption, place: place)
                        modelContext.insert(memory)
                        dismiss()
                    }
                }
            }
        }
    }
}
