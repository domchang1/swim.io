//
//  HomeView.swift
//  swim.io
//
//  Created by Dominic Chang on 2/10/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @State private var navigationPath = NavigationPath()
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Workout.date, order: .reverse) var workouts: [Workout]
    @State private var refresh = false
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            Form {
                Section("Feed") {
                    List {
                        ForEach(workouts) { workout in
                            Button(action: {
                                navigationPath.append(workout)
                            }) {
                                Text("\(workout.title)")
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Home Page")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: Workout.self) { workout in
                WorkoutView(workout: workout)
            }
            .refreshable {
                refresh.toggle()
            }
            .onAppear {
                refresh.toggle()
            }
        }
    }
}
//
//#Preview {
//    HomeView()
//        .environmentObject(AppViewModel())
//}
