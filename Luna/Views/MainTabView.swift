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

            Tab("Anclas", systemImage: "moon.fill", value: 3) {
                AnchorsView(deepLinkAnchor: $deepLinkAnchor)
            }
        }
        .tint(.indigo)
        .tabBarMinimizeBehavior(.onScrollDown)
        .onChange(of: deepLinkAnchor) { _, newValue in
            if newValue != nil {
                selectedTab = 3
            }
        }
    }
}
