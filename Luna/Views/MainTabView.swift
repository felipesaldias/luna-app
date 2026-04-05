import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            Tab("Protocolo", systemImage: "shield.fill") {
                ProtocolView()
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
