import SwiftUI
import SwiftData

struct MemoryDetailView: View {
    @Bindable var memory: Memory
    let allMemories: [Memory]
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var currentIndex: Int = 0
    @State private var showDeleteConfirm = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            TabView(selection: $currentIndex) {
                ForEach(Array(allMemories.enumerated()), id: \.element.id) { index, mem in
                    if let data = mem.imageData, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .tag(index)
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .automatic))
            .ignoresSafeArea()

            // Overlay controls
            VStack {
                HStack {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    Spacer()
                    Button { showDeleteConfirm = true } label: {
                        Image(systemName: "trash.circle.fill")
                            .font(.title)
                            .foregroundStyle(.white.opacity(0.8))
                    }
                }
                .padding()
                Spacer()

                Text("\(currentIndex + 1) / \(allMemories.count)")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.6))
                    .padding(.bottom, 20)
            }
        }
        .onAppear {
            if let idx = allMemories.firstIndex(where: { $0.id == memory.id }) {
                currentIndex = idx
            }
        }
        .alert("Eliminar foto?", isPresented: $showDeleteConfirm) {
            Button("Eliminar", role: .destructive) {
                let mem = allMemories[currentIndex]
                modelContext.delete(mem)
                if allMemories.count <= 1 {
                    dismiss()
                }
            }
            Button("Cancelar", role: .cancel) {}
        }
    }
}
