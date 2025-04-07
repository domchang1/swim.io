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
    @EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var chatViewModel: ChatViewModel

    var body: some View {
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

//#Preview {
//    ContentView()
//        .environmentObject(AppViewModel())
//}
