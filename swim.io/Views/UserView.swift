//
//  UserView.swift
//  swim.io
//
//  Created by Dominic Chang on 2/10/25.
//

import SwiftUI
import SwiftData

struct UserView: View {
    @State private var navigationPath = NavigationPath()
    @Environment(\.modelContext) var modelContext
    @Query var workouts: [Workout]
    var body: some View {
        NavigationStack(path: $navigationPath) {
            Form {
                Section("User") {
                    Text("domchang")
                        .font(.title3)
                        .bold()
                    Text("Total Workouts: \(workouts.count)")
                }
                Section("Workouts") {
                    List {
                        ForEach(workouts) { workout in
                            HStack {
                                Text("Workout on \(workout.date)")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                        .onDelete(perform: deleteWorkout)
                    }
                }
            }
        }
        .navigationTitle("User Page")
        .navigationBarTitleDisplayMode(.large)
//        .navigationDestination(for: Workout.self) { workout in
//            WorkoutView(workout: workout)
//        }
    }
    
    func deleteWorkout(_ indexSet: IndexSet) {
        withAnimation {
            for index in indexSet {
                let workout = workouts[index]
                modelContext.delete(workout)
            }
        }
    }
}

//#Preview {
//    UserView()
//        .environmentObject(AppViewModel())
//}
