import SwiftUI

struct MainTabView: View {
    @Binding var showProtocol: Bool

    var body: some View {
        TabView {
            Tab("Protocolo", systemImage: "shield.fill") {
                ProtocolView(showProtocol: $showProtocol)
            }

            Tab("Diario", systemImage: "book.fill") {
                JournalView()
            }

            Tab("Mi Proceso", systemImage: "book.closed.fill") {
                ProcessView()
            }

            Tab("Anclas", systemImage: "moon.fill") {
                AnchorsView()
            }
        }
        .tint(.indigo)
        .tabBarMinimizeBehavior(.onScrollDown)
    }
}
