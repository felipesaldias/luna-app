import SwiftUI

struct PauseStepView: View {
    let onComplete: () -> Void
    @State private var timeRemaining = 30
    @State private var timerActive = false

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "pause.circle.fill")
                .font(.system(size: 60))
                .foregroundStyle(.indigo)

            Text("Pausa")
                .font(.title)
                .fontWeight(.bold)

            Text("No hagas nada.\nRespira profundo.")
                .font(.title3)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            ZStack {
                Circle()
                    .stroke(Color.indigo.opacity(0.2), lineWidth: 8)
                    .frame(width: 120, height: 120)

                Circle()
                    .trim(from: 0, to: Double(timeRemaining) / 30.0)
                    .stroke(Color.indigo, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 1), value: timeRemaining)

                Text("\(timeRemaining)s")
                    .font(.system(size: 36, weight: .bold, design: .monospaced))
                    .foregroundStyle(.indigo)
            }

            if !timerActive {
                Button("Iniciar pausa") {
                    timerActive = true
                }
                .buttonStyle(.borderedProminent)
                .tint(.indigo)
            }

            if timeRemaining == 0 {
                Button("Siguiente") {
                    onComplete()
                }
                .buttonStyle(.borderedProminent)
                .tint(.indigo)
            }
        }
        .onReceive(timer) { _ in
            if timerActive && timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
    }
}
