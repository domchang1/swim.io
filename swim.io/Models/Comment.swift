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
    
    init(user: AppUser, content: String) {
        self.user = user
        self.content = content
        self.date = Date()
    }
}
