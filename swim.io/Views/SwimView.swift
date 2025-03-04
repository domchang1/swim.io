//
//  SwimView.swift
//  swim.io
//
//  Created by Dominic Chang on 2/10/25.
//

import SwiftUI
import SwiftData

struct SwimView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var navigationPath = NavigationPath()
    @Query private var workouts: [Workout]
    
    var body: some View {
       NavigationStack(path: $navigationPath) {
           Form {
               Section {
                   Button(action: addWorkout) {
                       HStack {
                           Label("Add Workout", systemImage: "plus")
                           Spacer()
                           Image(systemName: "chevron.right")
                               .foregroundColor(.gray)
                       }
                   }
               } header: {
                   Text("Quick Start")
               }
               
               Section {
                   NavigationLink {
                       Text("Random Set View")  // Replace with  actual view
                   } label: {
                       HStack {
                           Text("Generate Random Set")
                           Spacer()
                           Image(systemName: "die.face.5")
                       }
                   }
               } header: {
                   Text("Random Workouts")
               }
           }
           .navigationTitle("Swim Workouts")
           .navigationBarTitleDisplayMode(.large)
           .navigationDestination(for: Workout.self) { workout in
               WorkoutView(workout: workout)
           }
        }
    }
    
    func addWorkout() {
        let workout = Workout()
        modelContext.insert(workout)
        do {
            try modelContext.save()
        } catch {
            print("Failed to save new item: \(error)")
        }
        navigationPath.append(workout)
    }
    
}

//#Preview {
//    SwimView()
//        .modelContainer(for: Workout.self, inMemory: true)
//        .environmentObject(AppViewModel())
//}
