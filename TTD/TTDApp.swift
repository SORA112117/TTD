//
//  TTDApp.swift
//  TTD
//
//  Created by 山内壮良 on 2026/03/03.
//

import SwiftUI
import SwiftData

@main
struct TTDApp: App {
    var body: some Scene {
        WindowGroup {
            RootTabView()
        }
        .modelContainer(for: [TaskItem.self, TaskTemplate.self])
    }
}
