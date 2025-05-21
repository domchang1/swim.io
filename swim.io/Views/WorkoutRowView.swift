//
//  WorkoutRowView.swift
//  swim.io
//
//  Created by Dominic Chang on 4/7/25.
//

import SwiftUI

struct WorkoutRowView: View {
    @State var workout: Workout
    @Environment(\.modelContext) var modelContext
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
                    Button("Delete", role: .destructive, action: deleteWorkout)
                } label: {
                    Image(systemName: "ellipsis")
                        .rotationEffect(.degrees(90))
                        .foregroundColor(.gray)
                }
            }
            .padding(.bottom, 4)
            
            // Title and caption - Using TapGesture instead of Button
            VStack(alignment: .leading, spacing: 12) {  // Increased spacing between elements
                Text(workout.title)
                    .font(.headline)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)  // Allow proper text wrapping
                
                if !workout.caption.isEmpty {
                    Text(workout.caption)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)  // Allow proper text wrapping
                        .padding(.top, 2)  // Add a bit more space after the title
                }
                
                // Pool type and total distance - improved spacing and style
                HStack(spacing: 12) {
                    Text(workout.distanceUnit.rawValue.uppercased())
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(4)
                    
                    Text("\(workout.totalDistance) \(unit)")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.gray)
                }
                .padding(.top, 4)
                
                // Swim sets with better spacing
                VStack(alignment: .leading, spacing: 8) {
                    swimSets
                }
                .padding(.top, 6)
            }
            .padding(.vertical, 8)  // Add padding within the tappable area
            .frame(maxWidth: .infinity, alignment: .leading)  // Ensure full width while keeping left alignment
            .background(Color(.systemGray6).opacity(0.3))  // Subtle background to define the clickable area
            .cornerRadius(8)  // Rounded corners for the content area
            .contentShape(Rectangle())  // Important: defines the tappable area
            .onTapGesture {
                navigationPath.append(workout)
            }
            
            Divider()
                .padding(.vertical, 8)
            
            // Interaction buttons - Using separate ZStacks with tap gestures
            HStack {
                Spacer()
                
                // Like button
                ZStack {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: 60, height: 44)
                        
                    if liked {
                        Label("\(workout.upvotes)", systemImage: "hand.thumbsup.fill")  // Added count label
                            .foregroundColor(.blue)
                            .font(.caption)
                    } else {
                        Label("\(workout.upvotes)", systemImage: "hand.thumbsup")  // Added count label
                            .foregroundColor(.blue)
                            .font(.caption)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    liked = !liked
                    if liked {
                        workout.upvotes += 1
                    } else {
                        workout.upvotes -= 1
                    }
                }
                
                Spacer()
                
                // Comment button
                ZStack {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: 60, height: 44)
                        
                    Label("", systemImage: "bubble.right")
                        .foregroundColor(.blue)
                        .font(.caption)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    // Your comment action
                }
                
                Spacer()
            }
        }
        .padding(16)  // Increased overall padding
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)  // Subtle shadow for depth
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
    
    func deleteWorkout() {
        withAnimation {
            modelContext.delete(workout)
            do {
                try modelContext.save()
            } catch {
                print("Failed to save after deleting workout: \(error)")
            }
        }
    }
}

//#Preview {
//    WorkoutRowView()
//}
