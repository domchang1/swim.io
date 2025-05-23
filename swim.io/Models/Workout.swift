//
//  Workout.swift
//  swim.io
//
//  Created by Dominic Chang on 2/14/25.
//

import Foundation
import SwiftData

@Model
class Workout: Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var date: String
    var totalDistance: Int {
        var count = 0
        for set in sets {
            count += set.totalDistance
        }
        return count
    }
    var user: AppUser
    @Relationship(deleteRule: .cascade) var sets = [SwimSet]()
    var caption: String
    var upvotes: Int = 0
    var comments = [Comment]()
    var distanceUnit: DistanceUnit
    
    init(user: AppUser) {
        let currDate = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long
        self.date = formatter.string(from: currDate)
        self.title = "Workout on \(formatter.string(from: currDate))"
        self.distanceUnit = .scy
        self.caption = ""
        self.user = user
    }
}
