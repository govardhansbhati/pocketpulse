//
//  PocketPulseShortcutsProvider.swift
//  PocketPulse
//
//  Created by govardhan singh on 08/09/26.
//

import AppIntents

struct PocketPulseShortcutsProvider: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: DetectTransactionIntent(),
            phrases: [
                "Detect transaction in \(.applicationName)",
                "Log message in \(.applicationName)"
            ],
            shortTitle: "Detect Transaction",
            systemImageName: "sparkles"
        )
    }
}
