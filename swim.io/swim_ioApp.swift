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
    @StateObject var chatViewModel = ChatViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(AppViewModel())
                .environmentObject(chatViewModel)
        }
        .modelContainer(for: Workout.self)
    }
}
