//
//  QueryBackend.swift
//  swim.io
//
//  Created by Dominic Chang on 3/15/25.
//

import Foundation

private let baseURL = "http://127.0.0.1:5000"

func queryBackend(message: String) async throws -> String {
    guard let url = URL(string: "\(baseURL)/chat") else {
        throw URLError(.badURL)
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let requestBody: [String: String] = ["message": message]
    request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
    
    let (data, response) = try await URLSession.shared.data(for: request)
    guard let httpResponse = response as? HTTPURLResponse,
          (200...299).contains(httpResponse.statusCode) else {
        throw URLError(.badServerResponse)
    }

    let decoded = try JSONDecoder().decode(ChatResponse.self, from: data)
    print("Returned Chat Message: \(decoded.response)")
    return decoded.response
}
