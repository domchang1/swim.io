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
                HStack {
                    Text("Caption:")
                    TextField("Any additional notes", text: $workout.caption)
                }
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

            HStack {
                Button("Add a new set", systemImage: "plus", action: addSet)
            }
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
