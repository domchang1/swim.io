//
//  CommentThreadView.swift
//  swim.io
//
//  Created by Dominic Chang on 5/24/25.
//
import SwiftUI
import SwiftData

struct CommentThreadView: View {
    @Bindable var comment: Comment
    let authViewModel: AuthViewModel
    let modelContext: ModelContext
    let onReply: (Comment) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Main comment
            CommentRowView(
                comment: comment,
                authViewModel: authViewModel,
                modelContext: modelContext,
                onReply: onReply,
                isReply: false
            )
            
            // Replies
            if !comment.replies.isEmpty {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(comment.replies.sorted(by: { $0.date < $1.date }), id: \.id) { reply in
                        CommentRowView(
                            comment: reply,
                            authViewModel: authViewModel,
                            modelContext: modelContext,
                            onReply: onReply,
                            isReply: true
                        )
                    }
                }
                .padding(.leading, 52) // Indent replies
            }
        }
    }
}
