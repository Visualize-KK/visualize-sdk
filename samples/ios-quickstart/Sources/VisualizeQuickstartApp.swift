import SwiftUI
import VisualizeSDK

/// The smallest complete Visualize integration: configure, gate on device
/// support, present the scanner. Everything a member sees — the scan flow,
/// results, history, trends, sharing — is inside `presentHome`.
@main
struct VisualizeQuickstartApp: App {
    var body: some Scene {
        WindowGroup { ContentView() }
    }
}

struct ContentView: View {
    @State private var ready = false
    @State private var supported = false

    var body: some View {
        VStack(spacing: 16) {
            Text("Visualize Quickstart").font(.title.bold())

            Button("Body Scan") { presentScanner() }
                .buttonStyle(.borderedProminent)
                .disabled(!ready || !supported)

            if ready && !supported {
                Text("Scanning needs a Face ID iPhone (TrueDepth camera).")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
        .task {
            // The publishable key comes from Info.plist (VZPublishableKey).
            try? await Visualize.configureFromHostConfiguration(
                engine: AVIXScanEngine())
            supported = await Visualize.isDeviceSupported
            ready = true

            // Recommended: pull the one-time ~180 MB model download into
            // launch, so it is not inside the member's first scan.
            if supported, let token = try? await PartnerBackend.sessionToken() {
                try? await Visualize.prepare(sessionToken: token)
            }
        }
    }

    private func presentScanner() {
        guard let root = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive })?
            .keyWindow?.rootViewController else { return }

        Visualize.presentHome(from: root) {
            try await PartnerBackend.sessionToken()
        }
    }
}
