//
//  WorkoutView.swift
//  swim.io
//
//  Created by Dominic Chang on 2/15/25.
//

import SwiftUI

struct WorkoutView: View {
    @Bindable var workout: Workout
    @State private var setNum = 1
    
    var body: some View {
        Form {
            
            TextField(workout.title, text: $workout.title)
                .font(.title2)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.leading, .trailing, .top])
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
            Text(workout.username)
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
                }
                .padding(.vertical, 4)
                Picker("Pool Type", selection: $workout.distanceUnit) {
                    Text("SCY").tag(DistanceUnit.scy)
                    Text("LCM").tag(DistanceUnit.lcm)
                    Text("SCM").tag(DistanceUnit.scm)
                }
                .pickerStyle(.segmented)
                .padding()
                
            }

            ForEach(workout.sets) { set in
                Section("Set \(set.number)") {
                    SetView(set: set)
                        .padding()
                }
            }

            ZStack {
                // Remove default Form section background
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
            }
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
        }
        .navigationTitle("Edit Workout")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func addSet() {
        withAnimation {
            let set = SwimSet(number: setNum)
            workout.sets.append(set)
            setNum += 1
        }
    }
}

//#Preview {
//    WorkoutView()
//}
