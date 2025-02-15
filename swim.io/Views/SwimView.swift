//
//  SwimView.swift
//  swim.io
//
//  Created by Dominic Chang on 2/10/25.
//

import SwiftUI
import SwiftData

struct SwimView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @Environment(\.modelContext) private var modelContext
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            Section(header: Text("Quick Start")) {
                Button("Add Workout", systemImage: "plus", action: addWorkout)
            }
            .navigationDestination(for: Workout.self) { workout in
                WorkoutView(workout: workout)
            }
        }
    }
    func addWorkout() {
        let workout = Workout()
        modelContext.insert(workout)
        navigationPath.append(workout)
    }
    
}

//    private func addItem() {
//        withAnimation {
//            let newItem = Item(timestamp: Date())
//            modelContext.insert(newItem)
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            for index in offsets {
//                modelContext.delete(items[index])
//            }
//        }
//    }
//
//#Preview {
//    SwimView()
//        .modelContainer(for: Workout.self, inMemory: true)
//        .environmentObject(AppViewModel())
//}
