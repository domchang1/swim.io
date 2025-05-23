//
//  HomeView.swift
//  swim.io
//
//  Created by Dominic Chang on 2/10/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var chatViewModel: ChatViewModel
    @State private var navigationPath = NavigationPath()
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Workout.date, order: .reverse) var workouts: [Workout]
    @State private var refresh = false
    @State private var showChat = false
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                Form {
                    workoutListView
                }
                .navigationTitle("Home Page")
                .navigationBarTitleDisplayMode(.large)
                .navigationDestination(for: Workout.self) { workout in
                    WorkoutView(workout: workout).environmentObject(authViewModel)
                }
                .refreshable {
                    refresh.toggle()
                }
                .onAppear {
                    refresh.toggle()
                }
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation {
                                showChat = true
                            }
                        }) {
                            Image(systemName: "ellipsis.message.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .background(Circle().fill(Color.blue))
                                .shadow(radius: 5)
                        }
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
                }
            }
            .sheet(isPresented: $showChat) {
                ChatView()
                    .environmentObject(chatViewModel)
                    .presentationDetents([.medium])
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
    
    var workoutListView: some View {
        Section("Feed") {
            List {
                ForEach(workouts) { workout in
                    WorkoutRowView(workout: workout, navigationPath: $navigationPath).environmentObject(authViewModel)
                }
            }
        }
    }
    
}
