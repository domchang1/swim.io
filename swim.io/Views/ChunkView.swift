//
//  ChunkView.swift
//  swim.io
//
//  Created by Dominic Chang on 2/15/25.
//

import SwiftUI

struct ChunkView: View {
    @Bindable var chunk: SetChunk
    var body: some View {
        Text("Section #\(chunk.number)")
        HStack{
            TextField("Repetitions", value: $chunk.number, format: .number)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
            TextField("Distance", value: $chunk.distance, format: .number)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
            Picker("Stroke Type", selection: $chunk.setType) {
                ForEach(SetType.allCases, id: \.self) { type in
                    Text(type.description)
                }
            }
            .pickerStyle(.menu)
        }
    }
}

//#Preview {
//    ChunkView()
//}
