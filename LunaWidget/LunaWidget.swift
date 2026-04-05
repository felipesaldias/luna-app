import WidgetKit
import SwiftUI

struct LunaEntry: TimelineEntry {
    let date: Date
}

struct LunaProvider: TimelineProvider {
    func placeholder(in context: Context) -> LunaEntry {
        LunaEntry(date: .now)
    }

    func getSnapshot(in context: Context, completion: @escaping (LunaEntry) -> Void) {
        completion(LunaEntry(date: .now))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<LunaEntry>) -> Void) {
        let entry = LunaEntry(date: .now)
        let timeline = Timeline(entries: [entry], policy: .after(.now.addingTimeInterval(3600)))
        completion(timeline)
    }
}

struct LunaWidgetEntryView: View {
    var entry: LunaEntry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            smallWidget
        default:
            smallWidget
        }
    }

    private var smallWidget: some View {
        Link(destination: URL(string: "luna://protocol")!) {
            VStack(spacing: 10) {
                Image(systemName: "shield.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(.white)

                Text("Estoy sintiendo algo")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .containerBackground(for: .widget) {
                Color.indigo
            }
        }
    }
}

@main
struct LunaWidget: Widget {
    let kind: String = "LunaWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: LunaProvider()) { entry in
            LunaWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Luna")
        .description("Acceso rapido al protocolo de emergencia")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
