import SwiftUI
import SwiftData

struct ProtocolView: View {
    @State private var isActive = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()

                Image(systemName: "moon.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.indigo)

                Text("Protocolo de emergencia")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text("Usalo cuando sientas algo fuerte.\nTe guiare paso a paso.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Spacer()

                Button {
                    isActive = true
                } label: {
                    Text("Estoy sintiendo algo fuerte")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.indigo)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
            }
            .navigationTitle("Protocolo")
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(isPresented: $isActive) {
                ProtocolFlowView()
            }
        }
    }
}
