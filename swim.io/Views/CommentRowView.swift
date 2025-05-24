//
//  CommentRowView.swift
//  swim.io
//
//  Created by Dominic Chang on 5/24/25.
//
import SwiftUI

struct CommentRowView: View {
    @State var comment: Comment
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
         
            VStack(alignment: .leading, spacing: 4) {
                // Username and timestamp
                HStack {
                    if let username = comment.user.username {
                        Text("\(username)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    
                    Spacer()
                    
                    Text(timeAgoString(from: comment.date))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // Comment content
                Text(comment.content)
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
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
