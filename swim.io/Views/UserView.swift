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
    @Query(sort: \Workout.date, order: .reverse) var workouts: [Workout]
    @State private var refresh = false
    
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
                                Text("\(workout.title)")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                        .onDelete(perform: deleteWorkout)
                    }
                }
            }
            .navigationTitle("User Page")
            .navigationBarTitleDisplayMode(.large)
            .refreshable {
                refresh.toggle()
            }
            .onAppear {
                refresh.toggle()
            }
        }
    }
    
    func deleteWorkout(_ indexSet: IndexSet) {
        withAnimation {
            for index in indexSet {
                let workout = workouts[index]
                modelContext.delete(workout)
            }
            do {
                try modelContext.save()
            } catch {
                print("Failed to save after deleting workout: \(error)")
            }
        }
    }
}

//#Preview {
//    UserView()
//        .environmentObject(AppViewModel())
//}
