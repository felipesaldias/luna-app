import SwiftUI
import SwiftData

struct AnchorsView: View {
    @Query(sort: \Anchor.createdAt) private var anchors: [Anchor]
    @Environment(\.modelContext) private var modelContext
    @Binding var deepLinkAnchor: String?
    @State private var showAddSheet = false
    @State private var showNotificationSettings = false
    @State private var hasSeeded = false
    @State private var selectedAnchor: Anchor?

    var body: some View {
        NavigationStack {
            List {
                ForEach(groupedAnchors.keys.sorted(), id: \.self) { category in
                    Section(category) {
                        ForEach(groupedAnchors[category] ?? []) { anchor in
                            NavigationLink(destination: AnchorDetailView(anchor: anchor)) {
                                Text(anchor.text)
                                    .font(.body)
                                    .padding(.vertical, 2)
                            }
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
            .sheet(item: $selectedAnchor) { anchor in
                NavigationStack {
                    AnchorDetailView(anchor: anchor)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cerrar") { selectedAnchor = nil }
                            }
                        }
                }
            }
            .task {
                if anchors.isEmpty && !hasSeeded {
                    seedDefaults()
                    hasSeeded = true
                }
            }
            .onChange(of: deepLinkAnchor) { _, text in
                if let text {
                    if let match = anchors.first(where: { $0.text == text }) {
                        selectedAnchor = match
                    }
                    deepLinkAnchor = nil
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
