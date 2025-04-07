//
//  ChatModels.swift
//  swim.io
//
//  Created by Dominic Chang on 4/6/25.
//
import Foundation

struct ChatResponse: Codable {
    let response: String
}

struct ChatMessage: Identifiable {
    let id = UUID()
    let message: String
    let isUser: Bool
}
