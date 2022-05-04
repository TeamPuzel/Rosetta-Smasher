

import SwiftUI

@main
struct Rosetta_SmasherApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onReceive(NotificationCenter.default.publisher(for: NSApplication.willUpdateNotification), perform: { _ in
                                for window in NSApplication.shared.windows {
                                    window.standardWindowButton(.zoomButton)?.isEnabled = false
                                    window.isMovableByWindowBackground = true
                                }
                })
                .background(VisualEffectView(material: NSVisualEffectView.Material.contentBackground, blendingMode: NSVisualEffectView.BlendingMode.withinWindow))
        }
        .windowStyle(.hiddenTitleBar)
    }
}



//    .onAppear(perform: {
//        let visualEffect = NSVisualEffectView()
//        visualEffect.blendingMode = .behindWindow
//        visualEffect.state = .active
//        visualEffect.material = .dark
//        window?.contentView = visualEffect
//    })
