//
//  SleepPerfectApp.swift
//  SleepPerfect
//
//  Created by Michael Nath on 5/8/21.
//

import SwiftUI

@main
struct SleepPerfectApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
