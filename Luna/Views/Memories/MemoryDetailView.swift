import SwiftUI
import SwiftData
import AVKit

struct MemoryDetailView: View {
    @Bindable var memory: Memory
    let allMemories: [Memory]
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var currentIndex: Int = 0
    @State private var showDeleteConfirm = false
    @State private var showEdit = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            TabView(selection: $currentIndex) {
                ForEach(Array(allMemories.enumerated()), id: \.element.id) { index, mem in
                    MemoryPage(memory: mem)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .automatic))
            .ignoresSafeArea()

            VStack {
                HStack {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    Spacer()
                    Button { showEdit = true } label: {
                        Image(systemName: "pencil.circle.fill")
                            .font(.title)
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    Button { showDeleteConfirm = true } label: {
                        Image(systemName: "trash.circle.fill")
                            .font(.title)
                            .foregroundStyle(.white.opacity(0.8))
                    }
                }
                .padding()
                Spacer()
            }
        }
        .onAppear {
            if let idx = allMemories.firstIndex(where: { $0.id == memory.id }) {
                currentIndex = idx
            }
        }
        .alert("Eliminar?", isPresented: $showDeleteConfirm) {
            Button("Eliminar", role: .destructive) {
                let mem = allMemories[currentIndex]
                modelContext.delete(mem)
                if allMemories.count <= 1 { dismiss() }
            }
            Button("Cancelar", role: .cancel) {}
        }
        .sheet(isPresented: $showEdit) {
            if currentIndex < allMemories.count {
                EditMemoryView(memory: allMemories[currentIndex])
            }
        }
    }
}

private struct MemoryPage: View {
    let memory: Memory
    @State private var player: AVPlayer?

    var body: some View {
        VStack {
            Spacer()

            if memory.isVideo, let videoData = memory.videoData {
                VideoPlayerView(videoData: videoData)
                    .frame(maxHeight: UIScreen.main.bounds.height * 0.6)
            } else if let data = memory.imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            }

            Spacer()

            if !memory.caption.isEmpty || !memory.place.isEmpty {
                VStack(spacing: 6) {
                    if !memory.caption.isEmpty {
                        Text(memory.caption)
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                    }
                    if !memory.place.isEmpty {
                        HStack(spacing: 4) {
                            Image(systemName: "mappin")
                                .font(.caption2)
                            Text(memory.place)
                                .font(.caption)
                        }
                        .foregroundStyle(.white.opacity(0.7))
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial.opacity(0.5))
                .padding(.bottom, 40)
            }
        }
    }
}

private struct VideoPlayerView: View {
    let videoData: Data
    @State private var player: AVPlayer?

    var body: some View {
        Group {
            if let player {
                VideoPlayer(player: player)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                ProgressView()
            }
        }
        .onAppear { setupPlayer() }
        .onDisappear { player?.pause() }
    }

    private func setupPlayer() {
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".mov")
        try? videoData.write(to: tempURL)
        player = AVPlayer(url: tempURL)
    }
}

private struct EditMemoryView: View {
    @Bindable var memory: Memory
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Detalles") {
                    TextField("Frase o momento", text: $memory.caption, axis: .vertical)
                        .lineLimit(2...4)
                    TextField("Lugar", text: $memory.place)
                }
            }
            .navigationTitle("Editar recuerdo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Listo") { dismiss() }
                }
            }
        }
    }
}
