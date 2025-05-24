//
//  SetView.swift
//  swim.io
//
//  Created by Dominic Chang on 2/15/25.
//

import SwiftUI

struct SetView: View {
    @Bindable var set: SwimSet
    @State var isCreator: Bool
    @State var chunkNum: Int = 1
    
    var body: some View {
        VStack(spacing: 20) { // Increased spacing between main sections
            // Main Focus section with improved styling
            VStack(alignment: .leading, spacing: 8) {
                Text("Main Focus")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                TextField("Freestyle", text: $set.mainFocus)
                    .font(.body)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
                    .disabled(!isCreator)
            }
            
            // Number of Rounds section with better alignment
            VStack(alignment: .leading, spacing: 8) {
                Text("Number of Rounds")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                HStack(alignment: .center, spacing: 16) {
                    // Number display with styling
                    Text("\(Int(set.rounds))")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .frame(width: 40, alignment: .center)
                    
                    // Slider with better proportions
                    VStack(spacing: 4) {
                        Slider(
                            value: Binding(
                                get: { Double(set.rounds) },
                                set: { set.rounds = Int($0) }
                            ),
                            in: 0...10,
                            step: 1
                        )
                        .disabled(!isCreator)
                        
                        // Min and max labels below slider
                        HStack {
                            Text("0")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("10")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            
            // Divider for visual separation
            Divider()
                .padding(.vertical, 4)
            
            // Chunks section
            VStack(alignment: .leading, spacing: 16) {
                if !set.setChunks.isEmpty {
                    Text("Sections")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
                
                ForEach(set.setChunks) { chunk in
                    ChunkView(chunk: chunk, isCreator: isCreator)
                        .padding(.vertical, 4)
                }
                
                Button(action: addChunk) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add a new section")
                    }
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(!isCreator)
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
