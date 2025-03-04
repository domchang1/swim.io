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
        VStack (alignment: .leading, spacing: 15){
            Text("Section #\(chunk.chunkNum):")
                .bold()
            HStack {
                TextField("", value: $chunk.number, format: .number)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .frame(width: 45)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: chunk.number) {
                        if chunk.number < 0 {
                            chunk.number = 0
                        } else if chunk.number > 100 {
                            chunk.number = 100
                        }
                    }
                    
                Text("x")
                    .font(.headline)
                TextField("", value: $chunk.distance, format: .number)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .frame(width: 60)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: chunk.distance) {
                        if chunk.distance < 0 {
                            chunk.distance = 0
                        } else if chunk.distance > 2000 {
                            chunk.distance = 2000
                        }
                    }
                Text("of")
                    .font(.headline)
                Picker("", selection: $chunk.setType) {
                    ForEach(SetType.allCases, id: \.self) { type in
                        Text(type.description)
                            .frame(width: 120)
                    }
                }
                .pickerStyle(.menu)
            }
            .padding(.leading, 10)
            HStack {
                Text("Interval:")
                    .font(.headline)
                TextField("", value: $chunk.minutes, format: .number)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .frame(width: 45)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: chunk.minutes) {
                        if chunk.minutes < 0 {
                            chunk.minutes = 0
                        } else if chunk.minutes > 59 {
                            chunk.minutes = 59
                        }
                    }
                Text(":")
                    .font(.headline)
                TextField("", value: $chunk.seconds, format: .number)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .frame(width: 45)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: chunk.seconds) {
                        if chunk.seconds < 0 {
                            chunk.seconds = 0
                        } else if chunk.seconds > 59 {
                            chunk.seconds = 0
                        }
                    }
            }
            .padding(.leading, 10)
            HStack {
                Text("Notes:")
                    .font(.headline)
                TextField("Enter any notes", text: $chunk.notes)
            }
            .padding(.leading, 10)
        }
    }
}

//#Preview {
//    ChunkView()
//}
