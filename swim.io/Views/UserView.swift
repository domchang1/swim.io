//
//  UserView.swift
//  swim.io
//
//  Created by Dominic Chang on 2/10/25.
//

import SwiftUI
import SwiftData

struct UserView: View {
    @Environment(\.modelContext) var modelContext
    @Query var workouts: [Workout]
    var body: some View {
        Form {
            Section("User") {
                Text("domchang")
                    .font(.title)
                    .bold()
            }
            Section("Workouts") {
                List {
                    ForEach(workouts) { workout in
                        Text("Workout on \(workout.date)")
                    }
                    .onDelete(perform: deleteWorkout)
                }
            }
        }
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
