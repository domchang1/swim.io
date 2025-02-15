//
//  swim_ioApp.swift
//  swim.io
//
//  Created by Dominic Chang on 2/9/25.
//

import SwiftUI
import SwiftData

@main
struct swim_ioApp: App {
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            Workout.self, SwimSet.self, SetChunk.self, Comment.self
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(AppViewModel())
        }
        .modelContainer(for: Workout.self)
    }
}
