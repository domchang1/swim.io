//
//  UserView.swift
//  swim.io
//
//  Created by Dominic Chang on 2/10/25.
//

import SwiftUI
import SwiftData

struct UserView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var navigationPath = NavigationPath()
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Workout.date, order: .reverse) var workouts: [Workout]
    @State private var refresh = false
    @State private var showingSignOutAlert = false
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            if let currentUser = authViewModel.currentUser {
                Form {
                    Section("User") {
                        Text(currentUser.username!)
                            .font(.title3)
                            .bold()
                        Text("Total Workouts: \(userWorkouts.count)")
                        Button {
                            showingSignOutAlert = true
                        } label: {
                            Text("Sign Out")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.red)
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }

                    }
                    Section("Workouts") {
                        if userWorkouts.isEmpty {
                            Text("No workouts yet")
                                .foregroundColor(.secondary)
                                .italic()
                        } else {
                            List {
                                ForEach(workouts) { workout in
                                    if workout.user.username == currentUser.username! {
                                        Button(action: {
                                            navigationPath.append(workout)
                                        }) {
                                            HStack {
                                                Text("\(workout.title)")
                                                Spacer()
                                                Image(systemName: "chevron.right")
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                    }
                                }
                                .onDelete(perform: deleteWorkout)
                            }
                        }
                    }
                }
                .alert(isPresented: $showingSignOutAlert) {
                    Alert(
                        title: Text("Sign Out"),
                        message: Text("Are you sure you want to sign out?"),
                        primaryButton: .destructive(Text("Sign Out")) {
                            authViewModel.signOut()
                        },
                        secondaryButton: .cancel()
                    )
                }
                .navigationTitle("User Page")
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
            } else {
                VStack {
                    Text("Loading user information...")
                    ProgressView()
                }
                .onAppear {
                    // If we somehow get here without a user, sign them out
                    authViewModel.signOut()
                }
            }
            
        }
        
        var userWorkouts: [Workout] {
            guard let currentUser = authViewModel.currentUser else { return [] }
            
            // Filter workouts based on user ID instead of username
            return workouts.filter { workout in
                // Assuming your Workout model has a way to identify the user
                // You might need to adjust this based on your Workout model structure
                workout.user.id == currentUser.id
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
