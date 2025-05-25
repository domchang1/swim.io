//
//  Comment.swift
//  swim.io
//
//  Created by Dominic Chang on 2/14/25.
//

import Foundation
import SwiftData

@Model
class Comment {
    var user: AppUser
    var content: String
    var date: Date
    var likes: Int = 0
    var likedByUsers: [AppUser] = []
    var replies: [Comment] = [] // Nested replies
    var parentComment: Comment? // Reference to parent comment (nil for top-level)
    
    init(user: AppUser, content: String, parentComment: Comment? = nil) {
        self.user = user
        self.content = content
        self.date = Date()
        self.parentComment = parentComment
    }
    
    func isLikedBy(user: AppUser) -> Bool {
        return likedByUsers.contains(user)
    }
    
    func toggleLike(user: AppUser) {
        if isLikedBy(user: user) {
            likedByUsers.removeAll { $0 == user }
            likes = max(0, likes - 1)
        } else {
            likedByUsers.append(user)
            likes += 1
        }
    }
}
