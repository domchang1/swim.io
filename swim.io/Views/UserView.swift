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
            Form {
                Section("User") {
                    Text("domchang")
                        .font(.title3)
                        .bold()
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
                    .padding(.top, 30)
                    Text("Total Workouts: \(workouts.count)")
                }
                Section("Workouts") {
                    List {
                        ForEach(workouts) { workout in
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
                        .onDelete(perform: deleteWorkout)
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
