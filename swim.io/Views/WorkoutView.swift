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
            Text(workout.date)
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.leading, .trailing, .top])
            Text(workout.username)
                .font(.caption)
                .foregroundColor(.secondary)
            Section("Details") {
                TextField("Caption: ", text: $workout.caption)
                Picker("Pool Type", selection: $workout.distanceUnit) {
                    Text("SCY").tag(DistanceUnit.scy)
                    Text("LCM").tag(DistanceUnit.lcm)
                    Text("SCM").tag(DistanceUnit.scm)
                }
                .pickerStyle(.segmented)
                .padding()
                
            }

            Section("Sets") {
                ForEach(workout.sets) { set in
                    SetView(set: set)
                        .padding()
                }

                HStack {
                    Button("Add a new set", systemImage: "plus", action: addSight)
                }
            }
        }
        .navigationTitle("Edit Workout")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func addSight() {
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
