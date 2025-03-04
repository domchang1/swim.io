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
        VStack{
            Text("Section #\(chunk.chunkNum):")
                .bold()
            HStack {
                TextField("", value: $chunk.number, format: .number)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .frame(width: 30)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                Text("x")
                    .font(.system(size: 16))
                TextField("", value: $chunk.distance, format: .number)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .frame(width: 30)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Spacer()
                Picker("of", selection: $chunk.setType) {
                    ForEach(SetType.allCases, id: \.self) { type in
                        Text(type.description)
                    }
                }
                .pickerStyle(.menu)
                .layoutPriority(1) // Give higher layout priority
                .frame(minWidth: 120, maxWidth: .infinity)
            }
        }
    }
}

//#Preview {
//    ChunkView()
//}
