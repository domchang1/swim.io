//
//  AppModel.swift
//  swim.io
//
//  Created by Dominic Chang on 2/10/25.
//

import Foundation
import SwiftData

enum SetType: String, Codable, CaseIterable {
    case butterfly
    case breaststroke
    case backstroke
    case freestyle
    case im
    case kick
    case scull
    case pull
    case stroke
    case easy
    case drill
    case sprint
    
    var description: String {
        switch self {
        case .butterfly: return "Butterfly"
        case .breaststroke: return "Breaststroke"
        case .backstroke: return "Backstroke"
        case .freestyle: return "Freestyle"
        case .im: return "IM"
        case .kick: return "Kick"
        case .scull: return "Scull"
        case .pull: return "Pull"
        case .stroke: return "Stroke"
        case .easy: return "Easy"
        case .drill: return "Drill"
        case .sprint: return "Sprint"
        }
    }
}

enum DistanceUnit: String, Codable {
    case scm
    case scy
    case lcm
}

@Model
class AppUser {
    var passwordHash: String
    var id: String
    var createdDate: Date
    var username: String?
    
    init(passwordHash: String, username: String? = nil) {
        self.username = username
        self.passwordHash = passwordHash
        self.id = UUID().uuidString
        self.createdDate = Date()
    }
}
