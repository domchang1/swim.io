//
//  SetChunk.swift
//  swim.io
//
//  Created by Dominic Chang on 2/14/25.
//

import Foundation
import SwiftData

@Model
class SetChunk {
    var number: Int
    var distance: Int
    var setType: SetType
    var interval: Int
    var notes: String?
    var chunkNum: Int
    
    init(chunkNum: Int) {
        self.chunkNum = chunkNum
        self.number = 0
        self.distance = 0
        self.setType = SetType.freestyle
        self.interval = 0
    }
}
