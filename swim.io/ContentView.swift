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

    var body: some View {
//        NavigationSplitView {
//            List {
//                ForEach(items) { item in
//                    NavigationLink {
//                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
//                    } label: {
//                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
//                    }
//                }
//                .onDelete(perform: deleteItems)
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//            }
//        } detail: {
//            Text("Select an item")
//        }
        TabView () {
            Tab("Home", systemImage: "house") {
                HomeView()
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

#Preview {
    ContentView()
        .environmentObject(AppViewModel())
}
