import SwiftUI
import SwiftData

@main
struct LunaApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(for: [JournalEntry.self, Anchor.self])
    }
}
