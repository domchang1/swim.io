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
    var username: String
    var content: String
    
    init(username: String, content: String) {
        self.username = username
        self.content = content
    }
}
