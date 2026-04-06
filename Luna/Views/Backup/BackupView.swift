import SwiftUI
import SwiftData
import UniformTypeIdentifiers
import ZIPFoundation

struct BackupView: View {
    @Query private var journals: [JournalEntry]
    @Query private var anchors: [Anchor]
    @Query private var promises: [Promise]
    @Query private var milestones: [Milestone]
    @Query private var memories: [Memory]
    @State private var showExport = false
    @State private var showImport = false
    @State private var exportURL: URL?
    @State private var status = ""
    @State private var showRestoreConfirm = false
    @State private var isExporting = false
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            List {
                Section("Estado actual") {
                    row("Entradas diario", "\(journals.count)")
                    row("Anclas", "\(anchors.count)")
                    row("Promesas", "\(promises.count)")
                    row("Hitos", "\(milestones.count)")
                    row("Recuerdos (fotos/videos)", "\(memories.count)")
                }

                Section("Respaldo") {
                    Button {
                        Task { await exportBackup() }
                    } label: {
                        if isExporting {
                            HStack {
                                ProgressView()
                                    .padding(.trailing, 8)
                                Text("Generando respaldo...")
                            }
                        } else {
                            Label("Exportar respaldo completo (ZIP)", systemImage: "square.and.arrow.up")
                        }
                    }
                    .disabled(isExporting)

                    Button {
                        showRestoreConfirm = true
                    } label: {
                        Label("Restaurar respaldo", systemImage: "square.and.arrow.down")
                    }
                }

                if !status.isEmpty {
                    Section {
                        Text(status)
                            .foregroundStyle(status.contains("Error") ? .red : .green)
                    }
                }

                Section {
                    Text("Incluye todo: diario, anclas, promesas, hitos, fotos y videos. Se exporta como ZIP.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Respaldo")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showExport) {
                if let url = exportURL {
                    ShareSheet(url: url)
                }
            }
            .fileImporter(
                isPresented: $showImport,
                allowedContentTypes: [.zip]
            ) { result in
                switch result {
                case .success(let url):
                    Task { await importBackup(from: url) }
                case .failure(let error):
                    status = "Error: \(error.localizedDescription)"
                }
            }
            .alert("Restaurar respaldo?", isPresented: $showRestoreConfirm) {
                Button("Restaurar", role: .destructive) { showImport = true }
                Button("Cancelar", role: .cancel) {}
            } message: {
                Text("Esto agregara los datos del respaldo a los actuales.")
            }
        }
    }

    private func row(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text(value).foregroundStyle(.secondary).monospacedDigit()
        }
    }

    // MARK: - Export

    private func exportBackup() async {
        isExporting = true
        status = ""

        let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent("luna-backup-\(UUID().uuidString)")
        let mediaDir = tempDir.appendingPathComponent("media")

        do {
            try FileManager.default.createDirectory(at: mediaDir, withIntermediateDirectories: true)

            var memoryBackups: [MemoryBackup] = []
            for (i, memory) in memories.enumerated() {
                var imageFile: String?
                var videoFile: String?

                if let data = memory.imageData {
                    let filename = "img_\(i).jpg"
                    try data.write(to: mediaDir.appendingPathComponent(filename))
                    imageFile = filename
                }
                if let data = memory.videoData {
                    let filename = "vid_\(i).mov"
                    try data.write(to: mediaDir.appendingPathComponent(filename))
                    videoFile = filename
                }

                memoryBackups.append(MemoryBackup(
                    imageFile: imageFile, videoFile: videoFile, isVideo: memory.isVideo,
                    caption: memory.caption, place: memory.place,
                    milestoneId: memory.milestoneId, createdAt: memory.createdAt
                ))
            }

            let backup = BackupData(
                journals: journals.map { JournalBackup(from: $0) },
                anchors: anchors.filter { !$0.isDefault }.map { AnchorBackup(from: $0) },
                promises: promises.filter { !$0.isDefault }.map { PromiseBackup(from: $0) },
                milestones: milestones.map { MilestoneBackup(from: $0) },
                memories: memoryBackups,
                exportDate: Date.now
            )

            let jsonData = try JSONEncoder().encode(backup)
            try jsonData.write(to: tempDir.appendingPathComponent("backup.json"))

            let zipURL = FileManager.default.temporaryDirectory
                .appendingPathComponent("Luna-Backup-\(Date.now.formatted(.dateTime.year().month().day())).zip")
            try? FileManager.default.removeItem(at: zipURL)
            try FileManager.default.zipItem(at: tempDir, to: zipURL)

            try? FileManager.default.removeItem(at: tempDir)

            await MainActor.run {
                exportURL = zipURL
                showExport = true
                isExporting = false
                status = "Respaldo generado"
            }
        } catch {
            await MainActor.run {
                status = "Error: \(error.localizedDescription)"
                isExporting = false
            }
        }
    }

    // MARK: - Import

    private func importBackup(from url: URL) async {
        guard url.startAccessingSecurityScopedResource() else {
            await MainActor.run { status = "Error: sin acceso al archivo" }
            return
        }
        defer { url.stopAccessingSecurityScopedResource() }

        let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent("luna-restore-\(UUID().uuidString)")

        do {
            try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
            try FileManager.default.unzipItem(at: url, to: tempDir)

            guard let jsonURL = findFile(named: "backup.json", in: tempDir) else {
                await MainActor.run { status = "Error: backup.json no encontrado" }
                return
            }

            let jsonData = try Data(contentsOf: jsonURL)
            let backup = try JSONDecoder().decode(BackupData.self, from: jsonData)
            let mediaDir = jsonURL.deletingLastPathComponent().appendingPathComponent("media")

            await MainActor.run {
                for j in backup.journals {
                    modelContext.insert(JournalEntry(
                        date: j.date, trigger: j.trigger, triggerDetail: j.triggerDetail,
                        emotion: j.emotion, intensity: j.intensity, fact: j.fact,
                        story: j.story, didAct: j.didAct, actedFrom: j.actedFrom,
                        outcome: j.outcome, lesson: j.lesson, fromProtocol: j.fromProtocol,
                        rawFeeling: j.rawFeeling
                    ))
                }
                for a in backup.anchors {
                    modelContext.insert(Anchor(text: a.text, category: a.category, linkedProcess: a.linkedProcess))
                }
                for p in backup.promises {
                    modelContext.insert(Promise(text: p.text, category: p.category, brokenCount: p.brokenCount))
                }
                for m in backup.milestones {
                    modelContext.insert(Milestone(title: m.title, detail: m.detail, date: m.date, icon: m.icon))
                }
                for m in backup.memories {
                    var imageData: Data?
                    var videoData: Data?
                    if let f = m.imageFile { imageData = try? Data(contentsOf: mediaDir.appendingPathComponent(f)) }
                    if let f = m.videoFile { videoData = try? Data(contentsOf: mediaDir.appendingPathComponent(f)) }
                    modelContext.insert(Memory(
                        imageData: imageData, videoData: videoData, isVideo: m.isVideo,
                        caption: m.caption, place: m.place, milestoneId: m.milestoneId
                    ))
                }

                status = "Restaurado: \(backup.journals.count) entradas, \(backup.milestones.count) hitos, \(backup.memories.count) recuerdos"
            }

            try? FileManager.default.removeItem(at: tempDir)
        } catch {
            await MainActor.run { status = "Error: \(error.localizedDescription)" }
        }
    }

    private func findFile(named name: String, in directory: URL) -> URL? {
        let enumerator = FileManager.default.enumerator(at: directory, includingPropertiesForKeys: nil)
        while let fileURL = enumerator?.nextObject() as? URL {
            if fileURL.lastPathComponent == name { return fileURL }
        }
        return nil
    }
}

// MARK: - Share Sheet

struct ShareSheet: UIViewControllerRepresentable {
    let url: URL
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: [url], applicationActivities: nil)
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Backup models

struct BackupData: Codable {
    let journals: [JournalBackup]
    let anchors: [AnchorBackup]
    let promises: [PromiseBackup]
    let milestones: [MilestoneBackup]
    let memories: [MemoryBackup]
    let exportDate: Date
}

struct JournalBackup: Codable {
    let date: Date
    let trigger, triggerDetail, emotion: String
    let intensity: Int
    let fact, story: String
    let didAct: Bool
    let actedFrom, outcome, lesson: String?
    let fromProtocol: Bool
    let rawFeeling: String?
    init(from e: JournalEntry) {
        date = e.date; trigger = e.trigger; triggerDetail = e.triggerDetail
        emotion = e.emotion; intensity = e.intensity; fact = e.fact
        story = e.story; didAct = e.didAct; actedFrom = e.actedFrom
        outcome = e.outcome; lesson = e.lesson; fromProtocol = e.fromProtocol
        rawFeeling = e.rawFeeling
    }
}

struct AnchorBackup: Codable {
    let text, category: String
    let linkedProcess: String?
    init(from a: Anchor) { text = a.text; category = a.category; linkedProcess = a.linkedProcess }
}

struct PromiseBackup: Codable {
    let text, category: String
    let brokenCount: Int
    init(from p: Promise) { text = p.text; category = p.category; brokenCount = p.brokenCount }
}

struct MilestoneBackup: Codable {
    let title, detail: String
    let date: Date
    let icon: String
    init(from m: Milestone) { title = m.title; detail = m.detail; date = m.date; icon = m.icon }
}

struct MemoryBackup: Codable {
    let imageFile, videoFile: String?
    let isVideo: Bool
    let caption, place: String
    let milestoneId: String?
    let createdAt: Date
}
