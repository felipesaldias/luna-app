import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct BackupView: View {
    @Query private var journals: [JournalEntry]
    @Query private var anchors: [Anchor]
    @Query private var promises: [Promise]
    @Query private var milestones: [Milestone]
    @Query private var memories: [Memory]
    @State private var showExport = false
    @State private var showImport = false
    @State private var exportData: Data?
    @State private var status = ""
    @State private var showRestoreConfirm = false
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            List {
                Section("Estado actual") {
                    row("Entradas diario", "\(journals.count)")
                    row("Anclas", "\(anchors.count)")
                    row("Promesas", "\(promises.count)")
                    row("Hitos", "\(milestones.count)")
                    row("Recuerdos", "\(memories.count)")
                }

                Section("Respaldo") {
                    Button {
                        exportBackup()
                    } label: {
                        Label("Exportar respaldo", systemImage: "square.and.arrow.up")
                    }

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
                    Text("El respaldo incluye diario, anclas, promesas e hitos. Las fotos y videos no se incluyen por su tamaño.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Respaldo")
            .navigationBarTitleDisplayMode(.inline)
            .fileExporter(
                isPresented: $showExport,
                document: BackupDocument(data: exportData ?? Data()),
                contentType: .json,
                defaultFilename: "luna-backup-\(Date.now.formatted(.dateTime.year().month().day()))"
            ) { result in
                switch result {
                case .success:
                    status = "Respaldo exportado exitosamente"
                case .failure(let error):
                    status = "Error: \(error.localizedDescription)"
                }
            }
            .fileImporter(
                isPresented: $showImport,
                allowedContentTypes: [.json]
            ) { result in
                switch result {
                case .success(let url):
                    importBackup(from: url)
                case .failure(let error):
                    status = "Error: \(error.localizedDescription)"
                }
            }
            .alert("Restaurar respaldo?", isPresented: $showRestoreConfirm) {
                Button("Restaurar", role: .destructive) {
                    showImport = true
                }
                Button("Cancelar", role: .cancel) {}
            } message: {
                Text("Esto reemplazara los datos actuales con los del respaldo.")
            }
        }
    }

    private func row(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
                .monospacedDigit()
        }
    }

    private func exportBackup() {
        let backup = BackupData(
            journals: journals.map { JournalBackup(from: $0) },
            anchors: anchors.filter { !$0.isDefault }.map { AnchorBackup(from: $0) },
            promises: promises.filter { !$0.isDefault }.map { PromiseBackup(from: $0) },
            milestones: milestones.map { MilestoneBackup(from: $0) },
            exportDate: Date.now
        )

        if let data = try? JSONEncoder().encode(backup) {
            exportData = data
            showExport = true
        }
    }

    private func importBackup(from url: URL) {
        guard url.startAccessingSecurityScopedResource() else {
            status = "Error: sin acceso al archivo"
            return
        }
        defer { url.stopAccessingSecurityScopedResource() }

        guard let data = try? Data(contentsOf: url),
              let backup = try? JSONDecoder().decode(BackupData.self, from: data) else {
            status = "Error: archivo invalido"
            return
        }

        // Restore journals
        for j in backup.journals {
            let entry = JournalEntry(
                date: j.date, trigger: j.trigger, triggerDetail: j.triggerDetail,
                emotion: j.emotion, intensity: j.intensity, fact: j.fact,
                story: j.story, didAct: j.didAct, actedFrom: j.actedFrom,
                outcome: j.outcome, lesson: j.lesson, fromProtocol: j.fromProtocol,
                rawFeeling: j.rawFeeling
            )
            modelContext.insert(entry)
        }

        // Restore custom anchors
        for a in backup.anchors {
            let anchor = Anchor(text: a.text, category: a.category, linkedProcess: a.linkedProcess)
            modelContext.insert(anchor)
        }

        // Restore custom promises
        for p in backup.promises {
            let promise = Promise(text: p.text, category: p.category, brokenCount: p.brokenCount)
            modelContext.insert(promise)
        }

        // Restore milestones
        for m in backup.milestones {
            let milestone = Milestone(title: m.title, detail: m.detail, date: m.date, icon: m.icon)
            modelContext.insert(milestone)
        }

        status = "Respaldo restaurado: \(backup.journals.count) entradas, \(backup.milestones.count) hitos"
    }
}

// MARK: - Backup models

struct BackupData: Codable {
    let journals: [JournalBackup]
    let anchors: [AnchorBackup]
    let promises: [PromiseBackup]
    let milestones: [MilestoneBackup]
    let exportDate: Date
}

struct JournalBackup: Codable {
    let date: Date
    let trigger: String
    let triggerDetail: String
    let emotion: String
    let intensity: Int
    let fact: String
    let story: String
    let didAct: Bool
    let actedFrom: String?
    let outcome: String?
    let lesson: String?
    let fromProtocol: Bool
    let rawFeeling: String?

    init(from entry: JournalEntry) {
        date = entry.date; trigger = entry.trigger; triggerDetail = entry.triggerDetail
        emotion = entry.emotion; intensity = entry.intensity; fact = entry.fact
        story = entry.story; didAct = entry.didAct; actedFrom = entry.actedFrom
        outcome = entry.outcome; lesson = entry.lesson; fromProtocol = entry.fromProtocol
        rawFeeling = entry.rawFeeling
    }
}

struct AnchorBackup: Codable {
    let text: String
    let category: String
    let linkedProcess: String?

    init(from anchor: Anchor) {
        text = anchor.text; category = anchor.category; linkedProcess = anchor.linkedProcess
    }
}

struct PromiseBackup: Codable {
    let text: String
    let category: String
    let brokenCount: Int

    init(from promise: Promise) {
        text = promise.text; category = promise.category; brokenCount = promise.brokenCount
    }
}

struct MilestoneBackup: Codable {
    let title: String
    let detail: String
    let date: Date
    let icon: String

    init(from milestone: Milestone) {
        title = milestone.title; detail = milestone.detail; date = milestone.date; icon = milestone.icon
    }
}

// MARK: - File document

struct BackupDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.json] }
    let data: Data

    init(data: Data) { self.data = data }

    init(configuration: ReadConfiguration) throws {
        data = configuration.file.regularFileContents ?? Data()
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: data)
    }
}
