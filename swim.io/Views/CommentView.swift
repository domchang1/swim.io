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
    @State private var replyingToComment: Comment?
    @State private var replyText = ""
    
    // Get only top-level comments (those without a parent)
    private var topLevelComments: [Comment] {
        workout.comments.filter { $0.parentComment == nil }.sorted(by: { $0.date > $1.date })
    }
    
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
                    
                    Button("Cancel") {
                        dismiss()
                    }
                    .opacity(0)
                }
                .padding()
                .background(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
                
                // Comments list
                if topLevelComments.isEmpty {
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
                        LazyVStack(spacing: 0) {
                            ForEach(topLevelComments, id: \.id) { comment in
                                CommentThreadView(
                                    comment: comment,
                                    authViewModel: authViewModel,
                                    modelContext: modelContext,
                                    onReply: { comment in
                                        replyingToComment = comment
                                    }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                Spacer()
                
                // Reply indicator
                if let replyingTo = replyingToComment {
                    VStack(spacing: 0) {
                        Divider()
                        HStack {
                            Text("Replying to \(replyingTo.user.username ?? "")")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Button("Cancel") {
                                replyingToComment = nil
                                replyText = ""
                            }
                            .font(.caption)
                            .foregroundColor(.blue)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color(.systemGray6))
                    }
                }
                
                // Comment input section
                VStack(spacing: 0) {
                    if replyingToComment == nil {
                        Divider()
                    }
                    
                    HStack(alignment: .bottom, spacing: 12) {
                        // User avatar placeholder
                        Circle()
                            .fill(Color.blue.opacity(0.2))
                            .frame(width: 36, height: 36)
                            .overlay(
                                Text(String(authViewModel.currentUser?.username ?? "?"))
                                    .font(.headline)
                                    .foregroundColor(.blue)
                            )
                        
                        // Text input
                        TextField(
                            replyingToComment != nil ? "Write a reply..." : "Add a comment...",
                            text: replyingToComment != nil ? $replyText : $newCommentText,
                            axis: .vertical
                        )
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(12)
                        .background(Color(.systemGray6))
                        .cornerRadius(20)
                        .lineLimit(1...4)
                        
                        // Send button
                        Button(action: {
                            if replyingToComment != nil {
                                addReply()
                            } else {
                                addComment()
                            }
                        }) {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.system(size: 32))
                                .foregroundColor(currentTextIsEmpty ? .gray : .blue)
                        }
                        .disabled(currentTextIsEmpty)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(.systemBackground))
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private var currentTextIsEmpty: Bool {
        let text = replyingToComment != nil ? replyText : newCommentText
        return text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
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
    
    private func addReply() {
        guard let currentUser = authViewModel.currentUser,
              let parentComment = replyingToComment,
              !replyText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        let reply = Comment(
            user: currentUser,
            content: replyText.trimmingCharacters(in: .whitespacesAndNewlines),
            parentComment: parentComment
        )
        
        parentComment.replies.append(reply)
        workout.comments.append(reply)
        modelContext.insert(reply)
        
        do {
            try modelContext.save()
            replyText = ""
            replyingToComment = nil
        } catch {
            print("Failed to save reply: \(error)")
        }
    }
}
