//
//  ContentView.swift
//  swim.io
//
//  Created by Dominic Chang on 2/9/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var chatViewModel: ChatViewModel

    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                mainView
            } else {
                AuthView()
            }
        }
        .onAppear {
            authViewModel.setModelContext(modelContext)
        }
        .onChange(of: modelContext) { _, newContext in
            authViewModel.setModelContext(newContext)
        }
    }
    
    var mainView: some View {
        TabView () {
            Tab("Home", systemImage: "house") {
                HomeView()
                    .environmentObject(chatViewModel)
            }
            Tab("Swim", systemImage: "figure.pool.swim") {
                SwimView()
            }
            Tab("Profile", systemImage: "person.crop.circle") {
                UserView()
                    .environmentObject(authViewModel)
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
   static var previews: some View {
      Group {
         ContentView()
            .environment(\.colorScheme, .light)
         ContentView()
            .environment(\.colorScheme, .dark)
      }
   }
}
#endif

