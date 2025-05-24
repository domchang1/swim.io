//
//  WorkoutView.swift
//  swim.io
//
//  Created by Dominic Chang on 2/15/25.
//

import SwiftUI

struct WorkoutView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var chatViewModel: ChatViewModel
    @Bindable var workout: Workout
    @State private var setNum = 1
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var showingDeleteAlert = false
    @State private var navigateToHome = false
    @State private var isDeleting = false
    private var isCreator: Bool {
        guard let currentUser = authViewModel.currentUser else { return false }
        return currentUser.username == workout.user.username
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom header with conditional back button
            if !isCreator {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .foregroundColor(.blue)
                    }
                    
                    Spacer()
                    
                    Text("View Workout")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    // Empty space to balance the back button
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .opacity(0) // Invisible but takes up space
                }
                .padding()
                .background(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
            } else {
                HStack {
                    Spacer()
                    Text("Edit Workout")
                        .font(.headline)
                        .fontWeight(.semibold)
                    Spacer()
                }
                .padding()
                .background(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
            }
            
            Form {
                TextField(workout.title, text: $workout.title)
                    .font(.title2)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading, .trailing, .top])
                    .disabled(!isCreator)
                
                HStack {
                    Text("Total Distance: ")
                        .font(.subheadline)
                    Spacer()
                    Text("\(workout.totalDistance)")
                    if workout.distanceUnit == .scy {
                        Text("yards")
                    } else {
                        Text("meters")
                    }
                }
                
                Text(workout.user.username!)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Section("Details") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Caption")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        TextField("Any additional notes", text: $workout.caption)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                            .disabled(!isCreator)
                    }
                    .padding(.vertical, 4)
                    
                    Picker("Pool Type", selection: $workout.distanceUnit) {
                        Text("SCY").tag(DistanceUnit.scy)
                        Text("LCM").tag(DistanceUnit.lcm)
                        Text("SCM").tag(DistanceUnit.scm)
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    .disabled(!isCreator)
                }

                ForEach(workout.sets) { set in
                    Section("Set \(set.number)") {
                        SetView(set: set, isCreator: isCreator)
                            .padding()
                    }
                }

                ZStack {
                    Color.clear
                        .listRowBackground(Color.clear)
                    
                    Button(action: addSet) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add a new set")
                        }
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal, 4)
                    .disabled(!isCreator)
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
                
            }
            //.navigationTitle("Edit Workout")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
        }
        // Bottom buttons section
        if isCreator {
            Section {
                HStack() {
                    Button(action: saveWorkout) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Save")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(12)
                    }
                    
                    Button(action: { showingDeleteAlert = true }) {
                        HStack {
                            Image(systemName: "trash.fill")
                            Text("Delete")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(12)
                    }
                }
                .padding(.vertical, 8)
            }
            .listRowBackground(Color.clear)
            .confirmationDialog("Delete Workout", isPresented: $showingDeleteAlert, titleVisibility: .visible) {
                Button("Delete Workout", role: .destructive) {
                    deleteWorkout()
                }
                Button("Cancel", role: .cancel) {
                    showingDeleteAlert = false
                }
            } message: {
                Text("Are you sure you want to delete this workout? This action cannot be undone.")
            }
        }
        
    }
    
    func addSet() {
        withAnimation {
            let set = SwimSet(number: setNum)
            workout.sets.append(set)
            setNum += 1
        }
    }
    
    func saveWorkout() {
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Failed to save workout: \(error)")
        }
    }
    
    func deleteWorkout() {
        isDeleting = true
        modelContext.delete(workout)
        do {
            try modelContext.save()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                dismiss()
            }
        } catch {
            print("Failed to delete workout: \(error)")
            isDeleting = false
        }
    }
}
