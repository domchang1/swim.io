//
//  ChunkView.swift
//  swim.io
//
//  Created by Dominic Chang on 2/15/25.
//

import SwiftUI

struct ChunkView: View {
    @Bindable var chunk: SetChunk
    @State var isCreator: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Section #\(chunk.chunkNum)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if isCreator {
                    Button(action: { /* delete action */ }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
            
            HStack(alignment: .bottom, spacing: 8) {
                // Number field with label
                VStack(alignment: .center, spacing: 4) {
                    Text("Number")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    TextField("", value: $chunk.number, format: .number)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .frame(height: 36)
                        .padding(.horizontal, 8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                        .frame(width: 50)
                        .onChange(of: chunk.number) {
                            if chunk.number < 0 {
                                chunk.number = 0
                            } else if chunk.number > 100 {
                                chunk.number = 100
                            }
                        }
                        .disabled(!isCreator)
                }
                
                // "×" symbol with clear width
                Text("×")
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .frame(width: 20, height: 36, alignment: .center)
                
                // Distance field with label
                VStack(alignment: .center, spacing: 4) {
                    Text("Distance")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    TextField("", value: $chunk.distance, format: .number)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .frame(height: 36)
                        .padding(.horizontal, 8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                        .frame(width: 65)
                        .onChange(of: chunk.distance) {
                            if chunk.distance < 0 {
                                chunk.distance = 0
                            } else if chunk.distance > 2000 {
                                chunk.distance = 2000
                            }
                        }
                        .disabled(!isCreator)
                }
                
                // "of" text with clear width
                Text("of")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .frame(width: 20, height: 36, alignment: .center)
                
                // Type picker with label - standard picker
                VStack(alignment: .center, spacing: 4) {
                    Text("Type")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Picker("", selection: $chunk.setType) {
                        ForEach(SetType.allCases, id: \.self) { type in
                            Text(type.description)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(height: 36)
                    .frame(width: 130)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
                    .labelsHidden()
                    .compositingGroup()
                    .disabled(!isCreator)
                }
            }
            
            // Interval row
            HStack(alignment: .bottom, spacing: 8) {
                VStack(alignment: .leading) {
                    Spacer()
                    Text("Interval")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 10)
                }
                .frame(width: 60, alignment: .leading)
                
                // Minutes field with label
                VStack(alignment: .center, spacing: 4) {
                    Text("Min")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    TextField("", value: $chunk.minutes, format: .number)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .frame(height: 36)
                        .padding(.horizontal, 8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                        .frame(width: 50)
                        .onChange(of: chunk.minutes) {
                            if chunk.minutes < 0 {
                                chunk.minutes = 0
                            } else if chunk.minutes > 59 {
                                chunk.minutes = 59
                            }
                        }
                        .disabled(!isCreator)
                }
                
                // ":" symbol with clear width
                Text(":")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                    .frame(width: 20, height: 36, alignment: .center)
                
                // Seconds field with label
                VStack(alignment: .center, spacing: 4) {
                    Text("Sec")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    TextField("", value: $chunk.seconds, format: .number)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .frame(height: 36)
                        .padding(.horizontal, 8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                        .frame(width: 50)
                        .onChange(of: chunk.seconds) {
                            if chunk.seconds < 0 {
                                chunk.seconds = 0
                            } else if chunk.seconds > 59 {
                                chunk.seconds = 0
                            }
                        }
                        .disabled(!isCreator)
                }
                
                Spacer()
            }
            
            // Notes row
            VStack(alignment: .leading, spacing: 4) {
                Text("Notes")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                TextField("Enter any notes", text: $chunk.notes)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
                    .disabled(!isCreator)
            }
        }
        .padding(16)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

//#Preview {
//    ChunkView()
//}
