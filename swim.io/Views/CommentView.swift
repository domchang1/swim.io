//
//  CommentView.swift
//  swim.io
//
//  Created by Dominic Chang on 5/24/25.
//

import SwiftUI
import SwiftData

struct CommentsView: View {
    @Bindable var workout: Workout
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var newCommentText = ""
    @State private var isAddingComment = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.blue)
                    
                    Spacer()
                    
                    Text("Comments")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    // Invisible cancel button for centering
                    Button("Cancel") {
                        dismiss()
                    }
                    .opacity(0)
                }
                .padding()
                .background(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
                
                // Comments list
                if workout.comments.isEmpty {
                    // Empty state
                    VStack(spacing: 16) {
                        Spacer()
                        
                        Image(systemName: "bubble.right")
                            .font(.system(size: 50))
                            .foregroundColor(.gray.opacity(0.5))
                        
                        Text("No comments yet")
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        
                        Text("Be the first to leave a comment!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(workout.comments.sorted(by: { $0.date > $1.date }), id: \.id) { comment in
                                CommentRowView(comment: comment)
                            }
                        }
                        .padding()
                    }
                }
                
                Spacer()
                
                // Comment input section
                VStack(spacing: 0) {
                    Divider()
                    
                    HStack(alignment: .bottom, spacing: 12) {
                        // User avatar placeholder
                        Circle()
                            .fill(Color.blue.opacity(0.2))
                            .frame(width: 36, height: 36)
                            .overlay(
                                Text(String(authViewModel.currentUser?.username?.first ?? "?"))
                                    .font(.headline)
                                    .foregroundColor(.blue)
                            )
                        
                        // Text input
                        VStack(alignment: .leading, spacing: 4) {
                            TextField("Add a comment...", text: $newCommentText, axis: .vertical)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(12)
                                .background(Color(.systemGray6))
                                .cornerRadius(20)
                                .lineLimit(1...4)
                        }
                        
                        // Send button
                        Button(action: addComment) {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.system(size: 32))
                                .foregroundColor(newCommentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .gray : .blue)
                        }
                        .disabled(newCommentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(.systemBackground))
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private func addComment() {
        guard let currentUser = authViewModel.currentUser,
              !newCommentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        let comment = Comment(user: currentUser, content: newCommentText.trimmingCharacters(in: .whitespacesAndNewlines))
        
        workout.comments.append(comment)
        modelContext.insert(comment)
        
        do {
            try modelContext.save()
            newCommentText = ""
        } catch {
            print("Failed to save comment: \(error)")
        }
    }
}
