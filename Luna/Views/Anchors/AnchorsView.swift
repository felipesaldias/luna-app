import SwiftUI
import SwiftData

struct AnchorsView: View {
    @Query(sort: \Anchor.createdAt) private var anchors: [Anchor]
    @Environment(\.modelContext) private var modelContext
    @State private var showAddSheet = false
    @State private var showNotificationSettings = false
    @State private var hasSeeded = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(groupedAnchors.keys.sorted(), id: \.self) { category in
                    Section(category) {
                        ForEach(groupedAnchors[category] ?? []) { anchor in
                            AnchorRow(anchor: anchor)
                        }
                        .onDelete { offsets in
                            deleteAnchors(in: category, at: offsets)
                        }
                    }
                }
            }
            .navigationTitle("Anclas")
            .navigationBarTitleDisplayMode(.inline)
            .contentMargins(.bottom, 80, for: .scrollContent)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 16) {
                        Button { showNotificationSettings = true } label: {
                            Image(systemName: "bell.fill")
                        }
                        Button { showAddSheet = true } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            .sheet(isPresented: $showAddSheet) {
                AddAnchorView()
            }
            .sheet(isPresented: $showNotificationSettings) {
                NotificationSettingsView(anchors: anchors)
            }
            .task {
                if anchors.isEmpty && !hasSeeded {
                    seedDefaults()
                    hasSeeded = true
                }
            }
        }
    }

    private var groupedAnchors: [String: [Anchor]] {
        Dictionary(grouping: anchors, by: \.category)
    }

    private func seedDefaults() {
        for anchor in Anchor.defaults {
            modelContext.insert(anchor)
        }
    }

    private func deleteAnchors(in category: String, at offsets: IndexSet) {
        let categoryAnchors = groupedAnchors[category] ?? []
        for index in offsets {
            modelContext.delete(categoryAnchors[index])
        }
    }
}

private struct AnchorRow: View {
    let anchor: Anchor

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(anchor.text)
                .font(.body)
            if let process = anchor.linkedProcess {
                NavigationLink(destination: linkedProcessView(process)) {
                    Text("Ver en Mi Proceso")
                        .font(.caption)
                        .foregroundStyle(.indigo)
                }
            }
        }
        .padding(.vertical, 2)
    }

    @ViewBuilder
    private func linkedProcessView(_ id: String) -> some View {
        if let topic = ProcessContent.topics.first(where: { $0.id == id }) {
            ProcessDetailView(topic: topic)
        }
    }
}
