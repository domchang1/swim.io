//
//  CommentRowView.swift
//  swim.io
//
//  Created by Dominic Chang on 5/24/25.
//
import SwiftUI
import SwiftData

struct CommentRowView: View {
    @Bindable var comment: Comment
    let authViewModel: AuthViewModel
    let modelContext: ModelContext
    let onReply: (Comment) -> Void
    let isReply: Bool
    
    @State private var isLiked = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 12) {
                // User avatar
                Circle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: isReply ? 32 : 40, height: isReply ? 32 : 40)
                    .overlay(
                        Text(String(comment.user.username ?? "?"))
                            .font(isReply ? .callout : .headline)
                            .foregroundColor(.blue)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    // Username and timestamp
                    HStack {
                        if let username = comment.user.username {
                            Text("\(username)")
                                .font(isReply ? .caption : .subheadline)
                                .fontWeight(.semibold)
                        }
                        
                        Text(timeAgoString(from: comment.date))
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                    }
                    
                    // Comment content
                    Text(comment.content)
                        .font(isReply ? .callout : .body)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            
            // Action buttons (like and reply)
            HStack(spacing: 20) {
                // Like button
                Button(action: toggleLike) {
                    HStack(spacing: 4) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .foregroundColor(isLiked ? .red : .gray)
                            .font(.system(size: 14))
                        
                        if comment.likes > 0 {
                            Text("\(comment.likes)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                // Reply button (only for top-level comments)
                if !isReply {
                    Button(action: {
                        onReply(comment)
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "arrowshape.turn.up.left")
                                .foregroundColor(.gray)
                                .font(.system(size: 14))
                            
                            Text("Reply")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                Spacer()
            }
            .padding(.leading, isReply ? 44 : 52) // Align with comment text
            
            // Divider
            if !isReply {
                Divider()
                    .padding(.top, 8)
            }
        }
        .padding(.vertical, isReply ? 4 : 8)
        .onAppear {
            updateLikeState()
        }
        .onChange(of: comment.likedByUsers) { _ in
            updateLikeState()
        }
    }
    
    private func updateLikeState() {
        guard let currentUser = authViewModel.currentUser else { return }
        isLiked = comment.isLikedBy(user: currentUser)
    }
    
    private func toggleLike() {
        guard let currentUser = authViewModel.currentUser else { return }
        
        comment.toggleLike(user: currentUser)
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save like: \(error)")
        }
    }
    
    private func timeAgoString(from date: Date) -> String {
        let now = Date()
        let timeInterval = now.timeIntervalSince(date)
        
        if timeInterval < 60 {
            return "now"
        } else if timeInterval < 3600 {
            let minutes = Int(timeInterval / 60)
            return "\(minutes)m"
        } else if timeInterval < 86400 {
            let hours = Int(timeInterval / 3600)
            return "\(hours)h"
        } else {
            let days = Int(timeInterval / 86400)
            return "\(days)d"
        }
    }
}
