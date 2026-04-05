import SwiftUI

struct ProcessDetailView: View {
    let topic: ProcessTopic

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(parseContent(topic.content), id: \.id) { block in
                    switch block.type {
                    case .heading:
                        Text(block.text)
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.top, 8)
                    case .subheading:
                        Text(block.text)
                            .font(.headline)
                            .padding(.top, 4)
                    case .quote:
                        Text(block.text)
                            .font(.body)
                            .italic()
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.indigo.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    case .separator:
                        Divider()
                            .padding(.vertical, 4)
                    case .body:
                        Text(block.text)
                            .font(.body)
                            .foregroundStyle(.secondary)
                    case .bullet:
                        HStack(alignment: .top, spacing: 8) {
                            Text("•")
                                .foregroundStyle(.indigo)
                            Text(block.text)
                                .font(.body)
                                .foregroundStyle(.secondary)
                        }
                    case .numbered:
                        HStack(alignment: .top, spacing: 8) {
                            Text(block.prefix)
                                .fontWeight(.bold)
                                .foregroundStyle(.indigo)
                            Text(block.text)
                                .font(.body)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .padding()
            .padding(.bottom, 80)
        }
        .navigationTitle(topic.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Simple markdown parser

private enum BlockType {
    case heading, subheading, quote, separator, body, bullet, numbered
}

private struct ContentBlock: Identifiable {
    let id = UUID()
    let type: BlockType
    let text: String
    var prefix: String = ""
}

private func parseContent(_ content: String) -> [ContentBlock] {
    var blocks: [ContentBlock] = []
    for line in content.components(separatedBy: "\n") {
        let trimmed = line.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty { continue }
        if trimmed.hasPrefix("## ") {
            blocks.append(ContentBlock(type: .heading, text: String(trimmed.dropFirst(3))))
        } else if trimmed.hasPrefix("### ") {
            blocks.append(ContentBlock(type: .subheading, text: String(trimmed.dropFirst(4))))
        } else if trimmed.hasPrefix("> ") {
            blocks.append(ContentBlock(type: .quote, text: String(trimmed.dropFirst(2)).replacingOccurrences(of: "\"", with: "")))
        } else if trimmed == "---" {
            blocks.append(ContentBlock(type: .separator, text: ""))
        } else if trimmed.hasPrefix("- ") {
            blocks.append(ContentBlock(type: .bullet, text: String(trimmed.dropFirst(2)).replacingOccurrences(of: "**", with: "")))
        } else if trimmed.first?.isNumber == true && trimmed.contains(".") {
            let parts = trimmed.split(separator: " ", maxSplits: 1)
            if parts.count == 2 {
                blocks.append(ContentBlock(type: .numbered, text: String(parts[1]).replacingOccurrences(of: "**", with: ""), prefix: String(parts[0])))
            }
        } else {
            blocks.append(ContentBlock(type: .body, text: trimmed.replacingOccurrences(of: "**", with: "")))
        }
    }
    return blocks
}
