import SwiftUI

struct AnchorDetailView: View {
    let anchor: Anchor

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // La frase
                Text(anchor.text)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.indigo.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                // Categoria
                HStack {
                    Image(systemName: "tag.fill")
                        .foregroundStyle(.indigo)
                    Text(anchor.category)
                        .foregroundStyle(.secondary)
                }

                // Link a Mi Proceso
                if let processId = anchor.linkedProcess,
                   let topic = ProcessContent.topics.first(where: { $0.id == processId }) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Profundizar")
                            .font(.headline)

                        NavigationLink(destination: ProcessDetailView(topic: topic)) {
                            HStack(spacing: 12) {
                                Image(systemName: topic.icon)
                                    .font(.title3)
                                    .foregroundStyle(.indigo)
                                    .frame(width: 32)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(topic.title)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    Text("Ver en Mi Proceso")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.tertiary)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .foregroundStyle(.primary)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Ancla")
        .navigationBarTitleDisplayMode(.inline)
    }
}
