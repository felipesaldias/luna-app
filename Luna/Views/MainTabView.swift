import SwiftUI

struct MainTabView: View {
    @Binding var showProtocol: Bool
    @Binding var deepLinkAnchor: String?
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Protocolo", systemImage: "shield.fill", value: 0) {
                ProtocolView(showProtocol: $showProtocol)
            }

            Tab("Diario", systemImage: "book.fill", value: 1) {
                JournalView()
            }

            Tab("Mi Proceso", systemImage: "book.closed.fill", value: 2) {
                ProcessView()
            }

            Tab("Promesas", systemImage: "checkmark.shield.fill", value: 3) {
                PromisesView()
            }

            Tab("Recuerdos", systemImage: "photo.fill", value: 4) {
                MemoriesView()
            }

            Tab("Hitos", systemImage: "heart.text.square", value: 5) {
                MilestonesView()
            }

            Tab("Anclas", systemImage: "moon.fill", value: 6) {
                AnchorsView(deepLinkAnchor: $deepLinkAnchor)
            }

            Tab("Ajustes", systemImage: "gear", value: 7) {
                BackupView()
            }
        }
        .tint(.indigo)
        .tabBarMinimizeBehavior(.onScrollDown)
        .onChange(of: deepLinkAnchor) { _, newValue in
            if newValue != nil {
                selectedTab = 6
            }
        }
    }
}
