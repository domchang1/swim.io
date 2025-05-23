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
    @StateObject var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(AppViewModel())
                .environmentObject(chatViewModel)
                .environmentObject(authViewModel)
        }
        .modelContainer(for: [Workout.self, AppUser.self])
    }
}
