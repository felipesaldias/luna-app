import SwiftUI
import SwiftData

@main
struct LunaApp: App {
    @State private var showProtocol = false

    var body: some Scene {
        WindowGroup {
            MainTabView(showProtocol: $showProtocol)
                .onOpenURL { url in
                    if url.scheme == "luna" && url.host == "protocol" {
                        showProtocol = true
                    }
                }
        }
        .modelContainer(for: [JournalEntry.self, Anchor.self])
    }
}
