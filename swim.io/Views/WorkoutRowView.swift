//
//  WorkoutRowView.swift
//  swim.io
//
//  Created by Dominic Chang on 4/7/25.
//

import SwiftUI

struct WorkoutRowView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
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
                    Text(workout.user.username!)
                        .font(.subheadline)
                        .bold()
                    Text(workout.date)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                Menu {
//                    Button("Edit", action: { /* TODO */ })
                    Button("Delete", role: .destructive, action: deleteWorkout)
                } label: {
                    Image(systemName: "ellipsis")
                        .rotationEffect(.degrees(90))
                        .foregroundColor(.gray)
                }
            }
            .padding(.bottom, 4)
            
          
            VStack(alignment: .leading, spacing: 12) {
                Text(workout.title)
                    .font(.headline)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                if !workout.caption.isEmpty {
                    Text(workout.caption)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 2)
                }
                
             
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
                
                
                VStack(alignment: .leading, spacing: 8) {
                    swimSets
                }
                .padding(.top, 6)
            }
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemGray6).opacity(0.3))
            .cornerRadius(8)
            .contentShape(Rectangle())
            .onTapGesture {
                navigationPath.append(workout)
            }
            
            Divider()
                .padding(.vertical, 8)
            

            HStack(spacing: 0) {
                // Like button
                HStack {
                    Spacer()
                    VStack(spacing: 2) {
                        Image(systemName: liked ? "hand.thumbsup.fill" : "hand.thumbsup")
                            .foregroundColor(.blue)
                            .font(.system(size: 16))
                        
                        Text("\(workout.upvotes)")
                            .font(.caption2)
                            .foregroundColor(.blue)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
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
                }
                
               //Divider
                Rectangle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 1, height: 24)
                
                // Comment button
                HStack {
                    Spacer()
                    VStack(spacing: 2) {
                        Image(systemName: "bubble.right")
                            .foregroundColor(.blue)
                            .font(.system(size: 16))
                        
                        Text("")
                            .font(.caption2)
                            .foregroundColor(.blue)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        // Add actual action
                        print("Comment button tapped")
                    }
                    Spacer()
                }
                
                // Second blue divider
                Rectangle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 1, height: 24)
                
                // Share button
                HStack {
                    Spacer()
                    VStack(spacing: 2) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.blue)
                            .font(.system(size: 16))
                        
                        Text("")
                            .font(.caption2)
                            .foregroundColor(.blue)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        //Add share functionality
                        print("Share button tapped")
                    }
                    Spacer()
                }
            }
            .frame(height: 44)
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
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
