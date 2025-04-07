//
//  ChatViewModel.swift
//  swim.io
//
//  Created by Dominic Chang on 4/6/25.
//

import Foundation

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = [ChatMessage(message: "Hi, I'm LaneMate, your AI swim coach! How can I help you today?", isUser: false)]
    @Published var isLoading = false

    func sendMessage(_ text: String) {
        let userMessage = ChatMessage(message: text, isUser: true)
        messages.append(userMessage)
        isLoading = true
        
        Task {
            do {
                let response = try await queryBackend(message: text)
                let botMessage = ChatMessage(message: response, isUser: false)
                await MainActor.run {
                    messages.append(botMessage)
                    isLoading = false
                }
            } catch {
                print("Error: \(error)")
                await MainActor.run {
                    isLoading = false
                }
            }
        }
    }
}
