import SwiftUI

struct ProcessView: View {
    var body: some View {
        NavigationStack {
            List(ProcessContent.topics) { topic in
                NavigationLink(destination: ProcessDetailView(topic: topic)) {
                    HStack(spacing: 14) {
                        Image(systemName: topic.icon)
                            .font(.title3)
                            .foregroundStyle(.indigo)
                            .frame(width: 32)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(topic.title)
                                .font(.headline)
                        }
                    }
                    .padding(.vertical, 6)
                }
            }
            .navigationTitle("Mi Proceso")
            .navigationBarTitleDisplayMode(.inline)
            .contentMargins(.bottom, 80, for: .scrollContent)
        }
    }
}
