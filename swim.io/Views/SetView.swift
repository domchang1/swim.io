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
        VStack{
            HStack {
                Text("Main Focus:")
                    .font(.subheadline)
                Spacer()
                TextField("Freestyle", text: $set.mainFocus)
            }
            HStack {
                Text("Number of Rounds: ")
                    .font(.subheadline)
                Spacer()
                VStack(spacing: 2) {
                    Text("\(Int(set.rounds))")
                        .font(.headline)
                        .foregroundColor(.blue)
                    Slider(
                        value: Binding(
                            get: { Double(set.rounds) },
                            set: { set.rounds = Int($0) }
                        ),
                        in: 0...10,
                        step: 1
                    ) {
                    } minimumValueLabel: {
                        Text("0")
                    } maximumValueLabel: {
                        Text("10")
                    }
                }
            }
        }
        ForEach(set.setChunks) { chunk in
            ChunkView(chunk: chunk)
        }
        Button("Add a new section", systemImage: "plus", action: addChunk)
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
