import SwiftUI

struct IconPickerGrid: View {
    @Binding var selected: String

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 12) {
            ForEach(milestoneIcons, id: \.self) { icon in
                Image(systemName: icon)
                    .font(.title3)
                    .frame(width: 36, height: 36)
                    .background(selected == icon ? Color.indigo.opacity(0.3) : Color(.systemGray5))
                    .clipShape(Circle())
                    .foregroundStyle(selected == icon ? .indigo : .secondary)
                    .onTapGesture {
                        selected = icon
                    }
            }
        }
    }
}
