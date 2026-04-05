import SwiftUI
import UserNotifications

struct NotificationSettingsView: View {
    let anchors: [Anchor]
    @Environment(\.dismiss) private var dismiss
    @AppStorage("notificationsEnabled") private var notificationsEnabled = false
    @AppStorage("notificationMode") private var mode = "auto"
    @AppStorage("notificationsPerDay") private var notificationsPerDay = 3
    @AppStorage("notificationStartHour") private var startHour = 8
    @AppStorage("notificationEndHour") private var endHour = 22
    @State private var customTimes: [Date] = []
    @State private var saved = false

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
                    Section("Modo") {
                        Picker("Tipo", selection: $mode) {
                            Text("Automatico").tag("auto")
                            Text("Horas exactas").tag("custom")
                        }
                        .pickerStyle(.segmented)
                    }

                    if mode == "auto" {
                        autoSection
                    } else {
                        customSection
                    }

                    Section {
                        Button("Aplicar cambios") {
                            scheduleNotifications()
                            saved = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                saved = false
                            }
                        }
                        .frame(maxWidth: .infinity)

                        if saved {
                            Label("Notificaciones programadas", systemImage: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        }
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
            .onAppear {
                loadCustomTimes()
            }
        }
    }

    // MARK: - Auto mode

    private var autoSection: some View {
        Section("Configuracion automatica") {
            Stepper("Veces al dia: \(notificationsPerDay)", value: $notificationsPerDay, in: 1...5)
            Stepper("Desde las: \(startHour):00", value: $startHour, in: 6...20)
            Stepper("Hasta las: \(endHour):00", value: $endHour, in: (startHour + 1)...23)

            Text("Se distribuiran \(notificationsPerDay) frase(s) entre las \(startHour):00 y las \(endHour):00")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Custom mode

    private var customSection: some View {
        Section("Horarios personalizados") {
            ForEach(customTimes.indices, id: \.self) { index in
                HStack {
                    DatePicker(
                        "Hora \(index + 1)",
                        selection: $customTimes[index],
                        displayedComponents: .hourAndMinute
                    )
                    Button(role: .destructive) {
                        customTimes.remove(at: index)
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .foregroundStyle(.red)
                    }
                }
            }

            if customTimes.count < 10 {
                Button {
                    var components = Calendar.current.dateComponents([.year, .month, .day], from: .now)
                    components.hour = 9
                    components.minute = 0
                    let date = Calendar.current.date(from: components) ?? .now
                    customTimes.append(date)
                } label: {
                    Label("Agregar horario", systemImage: "plus")
                }
            }
        }
    }

    // MARK: - Persistence for custom times

    private func loadCustomTimes() {
        if let data = UserDefaults.standard.data(forKey: "customNotificationTimes"),
           let times = try? JSONDecoder().decode([Date].self, from: data) {
            customTimes = times
        }
    }

    private func saveCustomTimes() {
        if let data = try? JSONEncoder().encode(customTimes) {
            UserDefaults.standard.set(data, forKey: "customNotificationTimes")
        }
    }

    // MARK: - Scheduling

    private func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
            DispatchQueue.main.async {
                if !granted {
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

        if mode == "auto" {
            scheduleAuto(center: center)
        } else {
            saveCustomTimes()
            scheduleCustom(center: center)
        }
    }

    private func scheduleAuto(center: UNUserNotificationCenter) {
        let totalHours = endHour - startHour
        guard totalHours > 0 && notificationsPerDay > 0 else { return }
        let interval = totalHours / notificationsPerDay

        for i in 0..<notificationsPerDay {
            let hour = startHour + (i * interval)
            scheduleOne(center: center, id: "luna-auto-\(i)", hour: hour, minute: 0)
        }
    }

    private func scheduleCustom(center: UNUserNotificationCenter) {
        for (i, time) in customTimes.enumerated() {
            let components = Calendar.current.dateComponents([.hour, .minute], from: time)
            scheduleOne(center: center, id: "luna-custom-\(i)", hour: components.hour ?? 9, minute: components.minute ?? 0)
        }
    }

    private func scheduleOne(center: UNUserNotificationCenter, id: String, hour: Int, minute: Int) {
        let anchor = anchors.randomElement()!

        let content = UNMutableNotificationContent()
        content.title = "Luna"
        content.body = anchor.text
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        center.add(request)
    }
}
