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
    var username: String
    var totalDistance: Int {
        var count = 0
        for set in sets {
            count += set.totalDistance
        }
        return count
    }
    @Relationship(deleteRule: .cascade) var sets = [SwimSet]()
    var caption: String
    var upvotes: Int = 0
    var comments = [Comment]()
    var distanceUnit: DistanceUnit
    
    init() {
        let currDate = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long
        self.date = formatter.string(from: currDate)
        self.title = "Workout on \(formatter.string(from: currDate))"
        self.username = "domchang"
        self.distanceUnit = .scy
        self.caption = ""
    }
}
