//
//  CoreDataExampleApp.swift
//  CoreDataExample
//
//  Created by Cihangir Tuncer on 6.11.2022.
//

import SwiftUI

@main
struct CoreDataExampleApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
