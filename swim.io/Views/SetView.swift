//
//  SetView.swift
//  swim.io
//
//  Created by Dominic Chang on 2/15/25.
//

import SwiftUI

struct SetView: View {
    @Bindable var set: SwimSet
    @State var chunkNum: Int = 1
    var body: some View {
        
        Text("Set #\(set.number)")
        HStack{
            TextField("Focus", text: $set.mainFocus)
            Slider(
                value: Binding(
                    get: { Double(set.rounds) },
                    set: { set.rounds = Int($0) }
                ),
                in: 0...10,
                step: 1
            ) {
                Text("Number of Rounds")
            } minimumValueLabel: {
                Text("0")
            } maximumValueLabel: {
                Text("10")
            }
        }
        Section("Sections") {
            ForEach(set.setChunks) { chunk in
                ChunkView(chunk: chunk)
                    .padding()
            }
            .padding()

            HStack {
                Text("Add a new section")
                Button("Add", systemImage: "plus", action: addChunk)
            }
        }

    }
    
    func addChunk() {
        withAnimation {
            let chunk = SetChunk(chunkNum: chunkNum)
            set.setChunks.append(chunk)
            chunkNum += 1
        }
    }
}

//#Preview {
//    SetView()
//}
