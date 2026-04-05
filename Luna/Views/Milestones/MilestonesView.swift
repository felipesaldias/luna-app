import SwiftUI
import SwiftData

struct MilestonesView: View {
    @Query(sort: \Milestone.date, order: .reverse) private var milestones: [Milestone]
    @Environment(\.modelContext) private var modelContext
    @State private var showAddSheet = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(milestones) { milestone in
                    NavigationLink(destination: MilestoneDetailView(milestone: milestone)) {
                        MilestoneRow(milestone: milestone)
                    }
                }
                .onDelete(perform: deleteMilestones)
            }
            .navigationTitle("Hitos")
            .navigationBarTitleDisplayMode(.inline)
            .contentMargins(.bottom, 80, for: .scrollContent)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showAddSheet = true } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddSheet) {
                AddMilestoneView()
            }
            .overlay {
                if milestones.isEmpty {
                    ContentUnavailableView("Sin hitos", systemImage: "heart.text.square", description: Text("Agrega fechas y momentos importantes"))
                }
            }
        }
    }

    private func deleteMilestones(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(milestones[index])
        }
    }
}

private struct MilestoneRow: View {
    let milestone: Milestone

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: milestone.icon)
                .font(.title3)
                .foregroundStyle(.indigo)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 4) {
                Text(milestone.title)
                    .font(.headline)
                Text(milestone.date.formatted(date: .long, time: .omitted))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                if !milestone.detail.isEmpty {
                    Text(milestone.detail)
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                        .lineLimit(1)
                }
            }

            Spacer()

            Text(timeAgo(from: milestone.date))
                .font(.caption2)
                .foregroundStyle(.indigo)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.indigo.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding(.vertical, 4)
    }

    private func timeAgo(from date: Date) -> String {
        let days = Calendar.current.dateComponents([.day], from: date, to: .now).day ?? 0
        if days < 0 {
            return "en \(abs(days))d"
        } else if days == 0 {
            return "hoy"
        } else if days < 30 {
            return "hace \(days)d"
        } else if days < 365 {
            let months = days / 30
            return "hace \(months)m"
        } else {
            let years = days / 365
            let remainingMonths = (days % 365) / 30
            if remainingMonths > 0 {
                return "hace \(years)a \(remainingMonths)m"
            }
            return "hace \(years)a"
        }
    }
}
