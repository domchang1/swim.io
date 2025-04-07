//
//  ChatView.swift
//  swim.io
//
//  Created by Dominic Chang on 3/16/25.
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject var chatViewModel: ChatViewModel
    @Environment(\.dismiss) var dismiss
    @State private var currentInput: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 12) {
                            ForEach(chatViewModel.messages) { message in
                                HStack {
                                    if message.isUser {
                                        Spacer()
                                        Text(message.message)
                                            .padding()
                                            .background(Color.blue.opacity(0.2))
                                            .cornerRadius(10)
                                            .frame(maxWidth: 250, alignment: .trailing)
                                    } else {
                                        Text(message.message)
                                            .padding()
                                            .background(Color.gray.opacity(0.1))
                                            .cornerRadius(10)
                                            .frame(maxWidth: 250, alignment: .leading)
                                        Spacer()
                                    }
                                }
                            }
                            
                            if chatViewModel.isLoading {
                                ProgressView()
                                    .padding(.top)
                            }
                        }
                        .padding()
                    }
                    .onChange(of: chatViewModel.messages.count) { _,_ in
                       withAnimation {
                           if let lastID = chatViewModel.messages.last?.id {
                               proxy.scrollTo(lastID, anchor: .bottom)
                           }
                       }
                    }
                }

                HStack {
                    TextField("Type your message...", text: $currentInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(minHeight: 44)

                    Button(action: {
                        guard !currentInput.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                        chatViewModel.sendMessage(currentInput)
                        currentInput = ""
                    }) {
                        Image(systemName:"paperplane.fill")
                    }
                }
                .padding()
            }
            .navigationTitle("Talk to LaneMate")
            .navigationBarItems(trailing:
                                    HStack {
                Button("Close") {
                    dismiss()
                }
            })
        }
    }
}

//#Preview {
//    ChatView()
//}
