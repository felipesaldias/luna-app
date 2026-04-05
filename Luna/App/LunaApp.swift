import SwiftUI
import SwiftData
import UserNotifications

@main
struct LunaApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var showProtocol = false
    @State private var deepLinkAnchor: String?

    var body: some Scene {
        WindowGroup {
            MainTabView(showProtocol: $showProtocol, deepLinkAnchor: $deepLinkAnchor)
                .onOpenURL { url in
                    if url.scheme == "luna" && url.host == "protocol" {
                        showProtocol = true
                    } else if url.scheme == "luna" && url.host == "anchor" {
                        deepLinkAnchor = url.queryItems?["text"]
                    }
                }
        }
        .modelContainer(for: [JournalEntry.self, Anchor.self, Promise.self, Memory.self])
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.banner, .sound]
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let body = response.notification.request.content.body
        if let encoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: "luna://anchor?text=\(encoded)") {
            await MainActor.run {
                UIApplication.shared.open(url)
            }
        }
    }
}

extension URL {
    var queryItems: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false),
              let items = components.queryItems else { return nil }
        return Dictionary(items.map { ($0.name, $0.value ?? "") }, uniquingKeysWith: { _, last in last })
    }
}
