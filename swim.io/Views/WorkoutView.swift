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
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.leading, .trailing, .top])
            Section("Pool Type") {
                Picker("Unit", selection: $workout.distanceUnit) {
                    Text("Short Course Yards").tag(DistanceUnit.scy)
                    Text("Long Course Meters").tag(DistanceUnit.lcm)
                    Text("Short Course Meters").tag(DistanceUnit.scm)
                }
                .pickerStyle(.segmented)
            }

            Section("Sets") {
                ForEach(workout.sets) { set in
                    SetView(set: set)
                }

                HStack {
                    Text("Add a new set")
                    Button("Add", systemImage: "plus", action: addSight)
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
