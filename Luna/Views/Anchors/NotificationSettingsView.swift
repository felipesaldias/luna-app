import SwiftUI
import UserNotifications

struct NotificationSettingsView: View {
    let anchors: [Anchor]
    @Environment(\.dismiss) private var dismiss
    @AppStorage("notificationsPerDay") private var notificationsPerDay = 3
    @AppStorage("notificationStartHour") private var startHour = 8
    @AppStorage("notificationEndHour") private var endHour = 22
    @AppStorage("notificationsEnabled") private var notificationsEnabled = false
    @State private var permissionGranted = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Toggle("Notificaciones activas", isOn: $notificationsEnabled)
                        .onChange(of: notificationsEnabled) { _, newValue in
                            if newValue {
                                requestPermission()
                            } else {
                                cancelAll()
                            }
                        }
                }

                if notificationsEnabled {
                    Section("Configuracion") {
                        Stepper("Veces al dia: \(notificationsPerDay)", value: $notificationsPerDay, in: 1...5)
                        Stepper("Desde las: \(startHour):00", value: $startHour, in: 6...20)
                        Stepper("Hasta las: \(endHour):00", value: $endHour, in: (startHour + 1)...23)
                    }

                    Section {
                        Button("Aplicar cambios") {
                            scheduleNotifications()
                        }
                        .frame(maxWidth: .infinity)
                    }

                    Section("Preview") {
                        Text("Recibiras \(notificationsPerDay) frase(s) al dia entre las \(startHour):00 y las \(endHour):00")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Notificaciones")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cerrar") { dismiss() }
                }
            }
            .task {
                let settings = await UNUserNotificationCenter.current().notificationSettings()
                permissionGranted = settings.authorizationStatus == .authorized
            }
        }
    }

    private func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
            DispatchQueue.main.async {
                permissionGranted = granted
                if granted {
                    scheduleNotifications()
                } else {
                    notificationsEnabled = false
                }
            }
        }
    }

    private func cancelAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    private func scheduleNotifications() {
        cancelAll()
        guard !anchors.isEmpty else { return }

        let center = UNUserNotificationCenter.current()
        let totalHours = endHour - startHour
        guard totalHours > 0 && notificationsPerDay > 0 else { return }

        let interval = totalHours / notificationsPerDay

        for i in 0..<notificationsPerDay {
            let hour = startHour + (i * interval)
            let anchor = anchors.randomElement()!

            let content = UNMutableNotificationContent()
            content.title = "Luna"
            content.body = anchor.text
            content.sound = .default

            var dateComponents = DateComponents()
            dateComponents.hour = hour
            dateComponents.minute = 0

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(
                identifier: "luna-anchor-\(i)",
                content: content,
                trigger: trigger
            )
            center.add(request)
        }
    }
}
