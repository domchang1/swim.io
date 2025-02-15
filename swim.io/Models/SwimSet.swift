//
//  SwimSet.swift
//  swim.io
//
//  Created by Dominic Chang on 2/14/25.
//

import Foundation
import SwiftData

@Model
class SwimSet: ObservableObject {
    var number: Int
    var rounds: Int
    @Relationship(deleteRule: .cascade) var setChunks = [SetChunk]()
    var mainFocus: String
    
    init(number: Int) {
        self.number = number
        self.rounds = 0
        //self.setChunks = setChunks
        self.mainFocus = ""
    }
}
