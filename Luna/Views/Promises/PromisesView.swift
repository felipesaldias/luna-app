import SwiftUI
import SwiftData

struct PromisesView: View {
    @Query(sort: \Promise.createdAt) private var promises: [Promise]
    @Environment(\.modelContext) private var modelContext
    @State private var showAddSheet = false
    @State private var hasSeeded = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(groupedPromises.keys.sorted(), id: \.self) { category in
                    Section(category) {
                        ForEach(groupedPromises[category] ?? []) { promise in
                            PromiseRow(promise: promise)
                        }
                        .onDelete { offsets in
                            deletePromises(in: category, at: offsets)
                        }
                    }
                }
            }
            .navigationTitle("Mis promesas")
            .navigationBarTitleDisplayMode(.inline)
            .contentMargins(.bottom, 80, for: .scrollContent)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showAddSheet = true } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddSheet) {
                AddPromiseView()
            }
            .task {
                if promises.isEmpty && !hasSeeded {
                    for p in Promise.defaults {
                        modelContext.insert(p)
                    }
                    hasSeeded = true
                }
            }
        }
    }

    private var groupedPromises: [String: [Promise]] {
        Dictionary(grouping: promises, by: \.category)
    }

    private func deletePromises(in category: String, at offsets: IndexSet) {
        let categoryPromises = groupedPromises[category] ?? []
        for index in offsets {
            modelContext.delete(categoryPromises[index])
        }
    }
}

private struct PromiseRow: View {
    @Bindable var promise: Promise

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(promise.text)
                .font(.body)

            if promise.brokenCount > 0 {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.caption2)
                        .foregroundStyle(.orange)
                    Text("Roto \(promise.brokenCount) vez\(promise.brokenCount == 1 ? "" : "es")")
                        .font(.caption2)
                        .foregroundStyle(.orange)
                }
            }
        }
        .swipeActions(edge: .trailing) {
            Button {
                promise.brokenCount += 1
            } label: {
                Label("Rompi", systemImage: "xmark.circle")
            }
            .tint(.red)
        }
        .swipeActions(edge: .leading) {
            if promise.brokenCount > 0 {
                Button {
                    promise.brokenCount = 0
                } label: {
                    Label("Resetear", systemImage: "arrow.counterclockwise")
                }
                .tint(.green)
            }
        }
    }
}
