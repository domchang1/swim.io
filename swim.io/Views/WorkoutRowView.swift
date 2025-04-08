//
//  WorkoutRowView.swift
//  swim.io
//
//  Created by Dominic Chang on 4/7/25.
//

import SwiftUI

struct WorkoutRowView: View {
    @State var workout: Workout
    @Binding var navigationPath: NavigationPath
    @State var liked: Bool = false
    var unit: String {
        if workout.distanceUnit == .scy {
            return "yards"
        }
        return "meters"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Top bar
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(workout.username)
                        .font(.subheadline)
                        .bold()
                    Text(workout.date)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                Menu {
                    Button("Edit", action: { /* TODO */ })
                    Button("Delete", role: .destructive, action: { /* TODO */ })
                } label: {
                    Image(systemName: "ellipsis")
                        .rotationEffect(.degrees(90))
                        .foregroundColor(.gray)
                }
            }

            // Title and caption
            Button(action: {
                navigationPath.append(workout)
            }) {
                Text(workout.title)
                    .font(.headline)
                if !workout.caption.isEmpty {
                    Text(workout.caption)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // Pool type and total distance
                HStack(spacing: 12) {
                    Text(workout.distanceUnit.rawValue.uppercased())
                        .font(.caption)
                        .foregroundColor(.blue)
                    Text("\(workout.totalDistance) \(unit)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                // Swim sets
                swimSets
            }

            Divider()
            HStack {
                Spacer()
                Button(action: {
                    liked = !liked
                    if liked {
                        workout.upvotes += 1
                    } else {
                        workout.upvotes -= 1
                    }
                }) {
                    if liked {
                        Label("", systemImage: "hand.thumbsup.fill")
                            .foregroundColor(.blue)
                            .font(.caption)
                    } else {
                        Label("", systemImage: "hand.thumbsup")
                            .foregroundColor(.blue)
                            .font(.caption)
                    }
                }
                Spacer()
                Button(action: {}) {
                    Label("", systemImage: "bubble.right")
                        .foregroundColor(.blue)
                        .font(.caption)
                }
                Spacer()
                
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    var swimSets: some View {
        ForEach(Array(workout.sets.sorted(by: { $0.number < $1.number }).enumerated()), id: \.element.id) { index, swimSet in
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Set \(index + 1):")
                        .font(.caption)
                        .bold()
                    Spacer()
                    Text("\(swimSet.mainFocus)")
                        .foregroundColor(.secondary)
                }
                Text("\(swimSet.totalDistance) \(unit)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}

//#Preview {
//    WorkoutRowView()
//}
